#!/usr/bin/env python3

import re
import json
import argparse
import signal
from sys import argv
from csv import DictReader
from time import sleep

version = '1.0.1 [python 3] beta'
author = 'underwood@underwood.network'


def signal_handler(sig, frame):
    print("\33[?25h")
    exit(0)


def version_and_author():
    return "{} version {} - {}".format(argv[0], version, author)


def compounds():
    c = {'C21H30O2': 'Tetrahydrocannabinol',
         'H2SO4': 'Sulphuric Acid',
         'NH3': 'Ammonia',
         'SF6': 'Sulphur Hexafluoride',
         'C7H8': 'Toluene',
         'H2O2': 'Hydrogen Peroxide',
         'C2H2': 'Acetylene',
         'CH3OH': 'Methanol',
         'C7H5N3O6': 'Trinitrotoluene',
         'SO4': 'Sulphur Dioxide',
         'NaHCO3': 'Sodium Bicarbonate',
         'C2H5OH': 'Ethanol',
         'CH4': 'Methane',
         'C8H18O': 'Octanol',
         'C2H6': 'Ethane',
         'C15H31N3O13P2': 'Deoxyribonucleic Acid',
         'C8H10N4O2': 'Caffeine',
         'C8H18': 'Octane',
         'C6H6': 'Benzene',
         'NaCl': 'Sodium Chloride',
         'HCl': 'Hydrogen Chloride',
         'CaCO3': 'Calcium Carbonate',
         'HClO3': 'Chloric Acid',
         'HNO3': 'Nitric Acid',
         'ClH3O': 'Hydrochloric Acid',
         'C6H14O': 'Hexanol',
         'C10H8': 'Naphthalene',
         'CO2': 'Carbon Dioxide',
         'H2O': 'Dihydrogen Monoxide',
         'C20H25N3O': 'Lysergic Acid Diethylamide',
         'C6H14': 'Hexane'}
    return c


def list_compounds(compounds):
    pad = 4
    longest = max(map(len, compounds))
    print('{} {}{}'.format('Formula', ' '*(pad+longest-7), 'Common Name'))
    print('{} {}{}'.format('-------', ' '*(pad+longest-7), '-----------'))
    for c in sorted(compounds):
        print('{} {}{}'.format(c, ' '*(pad+longest-len(c)), compounds[c]))
    exit(0)


def epg(elements):
    epg = {}
    # Populate dictionary of elements by period and group
    for i in range(0, 118):
        p = int(elements[i]['period'])
        g = int(elements[i]['group'])
        epg[p, g] = elements[i]
    return epg


def elements_hash(elements):
    ebs = {}
    # Populate dictionary of elements by period and group
    for i in range(0, 118):
        ebs[elements[i]['symbol']] = elements[i]
    return ebs


def get_ptoe_args():
    parser = argparse.ArgumentParser(
            description='Command-line Interactive Periodic Table of Elements')
    parser.add_argument('-va', '--var', help='Colour variation')
    parser.add_argument('-i', '--ind', help='Colour index')
    parser.add_argument(
            '-k', '--key', help='Show colour key', action='store_true')
    parser.add_argument(
            '-l', '--label', help='Show period and group labels',
            action='store_true')
    parser.add_argument(
            '-m', '--mono', help='Disable colours', action='store_true')
    parser.add_argument(
            '-j', '--json', help='Show JSON output', action='store_true')
    parser.add_argument('-a', '--animate', help='Scroll through colours')
    parser.add_argument(
            '-t', '--table', help='Show table', action='store_true')
    parser.add_argument(
            '-d', '--debug', help='Enable debug output', action='store_true')
    parser.add_argument(
            '-v', '--version', help='Print program version',
            action='store_true')
    parser.add_argument(
            '-c', '--compounds', help='List known compounds',
            action='store_true')
    parser.add_argument(
            'query', help='Query to lookup, can be element or compound',
            nargs='?')

    return parser.parse_args()


def ptoe_table(elements, highlighted, ebs):
    output = "\r\n"
    clear = "\33[m"
    # print('')
    if args.label:
        for group in range(1, 19):
            output += "{:>4}".format(group)
        output += "\r\n"
    for period in range(1, 10):
        if args.label:
            output += f"{period } "
        for group in range(1, 19):
            colour = ''
            invert = ''
            uninvert = ''
            # clear = "\33[m"
            symbol = '   '
            try:
                element = epg(elements)[period, group]
                colour = getcolour(element, args, 0)
                symbol = element['symbol']
                if symbol in highlighted:
                    invert = "\33[7m"
                    uninvert = "\33[27m"
                symbol += (' ' * (3 - len(symbol)))
            except KeyError:
                pass
            if args.mono:
                colour = ''
            output += f'{colour}{invert}{symbol}{uninvert}{clear} '
        output += "\r\n"
    output += "\33[m"

    if args.key:
        output += ptoe_colour_key(ebs)

    return output


def ptoe_colour_key(ebs):
    lines = 0
    o = "\r\n"
    for ex in [
        ['H', "Hydrogen"],
        ['He', "G 18"],
        ['F', "G 17"],
        ['O', "G 16"],
        ['N', "G 15"],
        ['C', "G 14"],
        ['B', "G 13"],
        ['Zn', "G 3-12"],
        ['Be', "G 2"],
        ['Li', "G 1-H"],
        ['La', "Lanthanides"],
        ['Ac', "Actinides"],
      ]:
        if (lines % 4) == 0:
            o += "\r\n  "
        lines += 1
        o += getcolour(ebs[ex[0]], args, 1)
        o += f"{ex[0]} {' ' * (2-(len(str(ex[0]))))}\33[m {ex[1]}"
        # o += (' ' * (2-(len(str(ex[0])))))
        o += (' ' * (14-(len(str(ex[1])))))

    o += "\33[m\r\n"
    return o


def ptoe_parse_input(query):
    # Parse chemical formula, input a string and get an array
    # e.g 'H2O' => $VAR1 = [ 'H', '2' ]; $VAR2 = [ 'O', '1' ];
    elem = []
    formula = []
    pattern = '([A-Z][a-z]?)([0-9]+)?'
    matches = re.findall(pattern, query)
    i = 0
    for m in matches:
        element = matches[i][0]
        many = matches[i][1]
        if not many:
            many = 1
        i += 1
        formula.append([element, int(many)])
        elem.append(element)
    return elem, formula


def getcolour(adetails, args, bg):
    inv = ''
    colour = int(adetails['colour'])
    if args.ind:
        colour += int(args.ind)
    if args.var:
        colour *= int(args.var)
    if bg:
        inv = "\33[7m"
    return f"{inv}\33[38;5;{colour}m"


def ptoe_list_atoms(elements):
    args.gmult = 1
    gmresult = re.search('(^\\d+)', args.query)
    if gmresult:
        args.gmult = gmresult.group(1)

    elem, formula = ptoe_parse_input(args.query)

    if args.debug:
        print(formula)
        exit(0)
    elif args.json:
        print(json.dumps(formula, indent=4))
        exit(0)

    higa = {}
    for e in elem:
        higa[e] = True

    if args.table or args.label:
        print(ptoe_table(elements, higa, ebs))

    atmolcalc(formula)


def get_sumoutput(formula):
    sumoutput = []
    atmol = 0
    totalsum = float(0)

    for einc in formula:
        atom = einc[0]
        many = int(einc[1])
        atmol += many
        try:
            adetails = ebs[atom]
        except KeyError:
            print('%invalid input')
            exit(1)

        sum = float(adetails['amu']) * many
        totalsum += float(sum)
        colour = ''
        if not args.mono:
            colour = getcolour(adetails, args, 0)
        amu = f"{adetails['amu']} amu"
        if many > 1:
            amu = f"{many} * {adetails['amu']} amu = "
            amu += str(float(float(adetails['amu']) * many)) + ' amu'

        sumoutput.append(
            # hatom +
            colour +
            adetails['name'] + "\33[m" +
            (' ' * (12 - len(adetails['name']))) +
            f"(atomic number {ebs[atom]['number']}) " +
            f"[{atom}] {amu}"
        )

        if len(formula) == 1:
            a = adetails
            pg = f"Period {a['period']}, group {a['group']}."
            fact = f"{pg} {a['category']}, {a['phase']}.\r\n\r\n{a['fact']}."
            spc = ' ' * 12
            sumoutput.append(spc + fact + "\n")
    return sumoutput, atmol, totalsum


def atmolcalc(formula):
    sumoutput, atmol, totalsum = get_sumoutput(formula)

    if args.query:
        if len(formula) < 1:
            print('%not a valid element')
            exit(1)
        elif len(formula) > 1:
            args.query = re.sub("(^[^A-Z]+)", "", args.query)
            k = ''

            try:
                if compounds()[args.query]:
                    k = ' (' + compounds()[args.query] + ')'
            except KeyError:
                pass

            print(str(len(formula))+' elements in compound '+str(args.query+k))
            print(str(atmol * args.gmult) + ' atom' +
                  ('s' * ((atmol * float(args.gmult)) > 1)) +
                  f" in {args.gmult} {args.query} molecule"
                  + ('s' * (float(args.gmult) > 1)))
        else:
            args.query = re.sub("(^[^A-Za-z]+)", "", args.query)
            args.query = re.sub("([^A-Za-z]+)$", "", args.query)
            print('Element: ' + args.query)

    for s in sumoutput:
        print(s)

    if args.query:
        if len(formula) > 1:
            print(
                "There are {} grams per mole of {}".format(
                    str(float(totalsum)), args.query)
            )

    return


def ptoe(elements, ebs, args):
    if args.query:
        invalidresult = re.search('([^A-Za-z0-9])', args.query)
        if invalidresult:
            print('%unknown symbol in query: "' + invalidresult.group(1) + '"')
            exit(1)

        # Search for element by name if query is not symbol, number, or formula
        if re.search('[a-z]{2,}', args.query) or re.search(
                                                    '\\d[a-z]', args.query):
            found = False
            for element in ebs:
                e = ebs[element]
                nm = e['name']
                if nm.upper() == args.query.upper():
                    found = True
                    args.query = element
                    break
            if not found:
                print('%unknown input')
                exit(1)

    if args.ind and int(args.ind) < 0:
        args.ind = 0
    if args.var and int(args.var) < 0:
        args.var = 0

    if not (args.query or args.table):
        args.table = True

    ptoe_list_atoms(elements)
    return


args = get_ptoe_args()

if args.version:
    print(version_and_author())
    exit(0)

if args.compounds:
    compounds = compounds()
    list_compounds(compounds)

if args.query is None:
    args.query = ''

with open("../elements.csv") as elements_csv:
    elements = list(DictReader(elements_csv))

ebs = elements_hash(elements)  # elements by symbol
args.elem, formula = ptoe_parse_input(args.query)

ptoe(elements, ebs, args)

if args.animate:
    signal.signal(signal.SIGINT, signal_handler)
    args.ind = int(1)
    print("\33[?25l\33[H\33[0J")
    while True:
        print("\33[H")
        ptoe(elements, ebs, args)
        args.ind += 1
        sleep(float(args.animate))
