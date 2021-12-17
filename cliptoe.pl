#!/usr/bin/env perl

use strict;

use Encode;
use Data::Dumper;
use JSON::XS;
use Getopt::Long qw(GetOptions);
use Time::HiRes qw(usleep);
# use LWP::Simple;

my $ptoe_version = '1.1';

# ,-----------------------------------------------,
# | CLIPTOE - by underwood,                       |
# |               searinox,                       |
# |                     and devon - December 2021 |
# `-----------------------------------------------'
# Command Line Interactive Periodic Table of Elements
# ' https://www.youtube.com/watch?v=wlOdUATGuQY
#
# ' "There is no standard set of colors used to identify element groups or other properties.
# ' Colors are selected based on how well the text shows up against them, but mostly it's a
# ' matter of personal preference." https://www.thoughtco.com/color-on-the-periodic-table-608827

# Originally written in BASIC, then ported to Perl

our @ptoe_category_examples;
our @ptoe_colours;

# our $mole = 6.02214076e23;

our $elements = {
    'elementbynumber' => {
        '51'  => 'Sb',
        '108' => 'Hs',
        '78'  => 'Pt',
        '5'   => 'B',
        '88'  => 'Ra',
        '4'   => 'Be',
        '41'  => 'Nb',
        '33'  => 'As',
        '109' => 'Mt',
        '21'  => 'Sc',
        '112' => 'Cn',
        '91'  => 'Pa',
        '117' => 'Ts',
        '2'   => 'He',
        '9'   => 'F',
        '86'  => 'Rn',
        '11'  => 'Na',
        '37'  => 'Rb',
        '6'   => 'C',
        '114' => 'Fl',
        '61'  => 'Pm',
        '103' => 'Lr',
        '76'  => 'Os',
        '1'   => 'H',
        '106' => 'Sg',
        '23'  => 'V',
        '79'  => 'Au',
        '101' => 'Md',
        '93'  => 'Np',
        '89'  => 'Ac',
        '115' => 'Mc',
        '57'  => 'La',
        '13'  => 'Al',
        '85'  => 'At',
        '84'  => 'Po',
        '47'  => 'Ag',
        '74'  => 'W',
        '63'  => 'Eu',
        '75'  => 'Re',
        '53'  => 'I',
        '110' => 'Ds',
        '70'  => 'Yb',
        '97'  => 'Bk',
        '80'  => 'Hg',
        '27'  => 'Co',
        '3'   => 'Li',
        '72'  => 'Hf',
        '67'  => 'Ho',
        '43'  => 'Tc',
        '17'  => 'Cl',
        '82'  => 'Pb',
        '31'  => 'Ga',
        '113' => 'Nh',
        '60'  => 'Nd',
        '55'  => 'Cs',
        '54'  => 'Xe',
        '49'  => 'In',
        '116' => 'Lv',
        '22'  => 'Ti',
        '10'  => 'Ne',
        '92'  => 'U',
        '104' => 'Rf',
        '77'  => 'Ir',
        '62'  => 'Sm',
        '107' => 'Bh',
        '102' => 'No',
        '87'  => 'Fr',
        '20'  => 'Ca',
        '12'  => 'Mg',
        '36'  => 'Kr',
        '59'  => 'Pr',
        '44'  => 'Ru',
        '90'  => 'Th',
        '45'  => 'Rh',
        '94'  => 'Pu',
        '40'  => 'Zr',
        '95'  => 'Am',
        '25'  => 'Mn',
        '38'  => 'Sr',
        '69'  => 'Tm',
        '24'  => 'Cr',
        '52'  => 'Te',
        '19'  => 'K',
        '42'  => 'Mo',
        '83'  => 'Bi',
        '15'  => 'P',
        '14'  => 'Si',
        '118' => 'Og',
        '50'  => 'Sn',
        '99'  => 'Es',
        '29'  => 'Cu',
        '65'  => 'Tb',
        '73'  => 'Ta',
        '64'  => 'Gd',
        '48'  => 'Cd',
        '96'  => 'Cm',
        '30'  => 'Zn',
        '26'  => 'Fe',
        '81'  => 'Tl',
        '16'  => 'S',
        '7'   => 'N',
        '32'  => 'Ge',
        '58'  => 'Ce',
        '66'  => 'Dy',
        '100' => 'Fm',
        '71'  => 'Lu',
        '8'   => 'O',
        '68'  => 'Er',
        '39'  => 'Y',
        '56'  => 'Ba',
        '18'  => 'Ar',
        '105' => 'Db',
        '34'  => 'Se',
        '35'  => 'Br',
        '28'  => 'Ni',
        '98'  => 'Cf',
        '111' => 'Rg',
        '46'  => 'Pd'
    },
    'elementbysymbol' => {
        'F' => {
            'amu'      => '18.998',
            'fact'     => 'Latin fluere, \'to flow\'',
            'group'    => '17',
            'number'   => '9',
            'symbol'   => 'F',
            'category' => 'Halogen',
            'colour'   => '3',
            'name'     => 'Fluorine',
            'phase'    => 'gas',
            'period'   => '2'
        },
        'S' => {
            'amu'      => '32.065',
            'fact'     => 'Latin sulphur, \'brimstone\'',
            'group'    => '16',
            'number'   => '16',
            'category' => 'Nonmetal',
            'symbol'   => 'S',
            'colour'   => '4',
            'name'     => 'Sulphur',
            'phase'    => 'solid',
            'period'   => '3'
        },
        'Ba' => {
            'period'   => '6',
            'phase'    => 'solid',
            'name'     => 'Barium',
            'colour'   => '10',
            'category' => 'Alkaline Earth Metal',
            'symbol'   => 'Ba',
            'number'   => '56',
            'group'    => '2',
            'fact'     => 'Greek barys, \'heavy\'',
            'amu'      => '137.327'
        },
        'Cu' => {
            'group' => '11',
            'amu'   => '63.546',
            'fact'  =>
'English word, from Latin cuprum, from Ancient Greek Kypros \'Cyprus\'',
            'symbol'   => 'Cu',
            'category' => 'Transition Metal',
            'number'   => '29',
            'name'     => 'Copper',
            'colour'   => '7',
            'period'   => '4',
            'phase'    => 'solid'
        },
        'La' => {
            'group'    => '3',
            'fact'     => 'Greek lanthanein, \'to lie hidden\'',
            'amu'      => '138.905',
            'symbol'   => 'La',
            'category' => 'Lanthanide',
            'number'   => '57',
            'name'     => 'Lanthanum',
            'colour'   => '12',
            'period'   => '6',
            'phase'    => 'solid'
        },
        'Hs' => {
            'colour'   => '7',
            'name'     => 'Hassium',
            'phase'    => 'artificial',
            'period'   => '7',
            'amu'      => '267',
            'fact'     => 'New Latin Hassia, \'Hesse\' (a state in Germany)',
            'group'    => '8',
            'number'   => '108',
            'symbol'   => 'Hs',
            'category' => 'Transactinide'
        },
        'Pu' => {
            'colour' => '13',
            'name'   => 'Plutonium',
            'phase'  => 'artificial',
            'period' => '9',
            'fact'   =>
'the dwarf planet Pluto, considered the ninth planet in the Solar System at the time',
            'amu'      => '244',
            'group'    => '7',
            'number'   => '94',
            'symbol'   => 'Pu',
            'category' => 'Actinide'
        },
        'B' => {
            'fact'     => 'borax, a mineral (from Arabic bawraq)',
            'amu'      => '10.811',
            'group'    => '13',
            'number'   => '5',
            'symbol'   => 'B',
            'category' => 'Metalloid',
            'colour'   => '0',
            'name'     => 'Boron',
            'phase'    => 'solid',
            'period'   => '2'
        },
        'Sc' => {
            'colour'   => '7',
            'name'     => 'Scandium',
            'phase'    => 'solid',
            'period'   => '4',
            'amu'      => '44.956',
            'fact'     => 'Latin Scandia, \'Scandinavia\'',
            'group'    => '3',
            'number'   => '21',
            'symbol'   => 'Sc',
            'category' => 'Transition Metal'
        },
        'Ti' => {
            'group' => '4',
            'amu'   => '47.867',
            'fact'  =>
              'Titans, the sons of the Earth Goddess of Greek mythology',
            'category' => 'Transition Metal',
            'symbol'   => 'Ti',
            'number'   => '22',
            'name'     => 'Titanium',
            'colour'   => '7',
            'period'   => '4',
            'phase'    => 'solid'
        },
        'Te' => {
            'phase'    => 'solid',
            'period'   => '5',
            'colour'   => '4',
            'name'     => 'Tellurium',
            'number'   => '52',
            'symbol'   => 'Te',
            'category' => 'Metalloid',
            'amu'      => '127.6',
            'fact'     => 'Latin tellus, \'the ground, earth\'',
            'group'    => '16'
        },
        'Sm' => {
            'group' => '7',
            'fact'  =>
'samarskite, a mineral named after Colonel Vasili Samarsky-Bykhovets, Russian mine official',
            'amu'      => '150.36',
            'category' => 'Lanthanide',
            'symbol'   => 'Sm',
            'number'   => '62',
            'name'     => 'Samarium',
            'colour'   => '12',
            'period'   => '8',
            'phase'    => 'solid'
        },
        'Fm' => {
            'phase'    => 'artificial',
            'period'   => '9',
            'colour'   => '13',
            'name'     => 'Fermium',
            'number'   => '100',
            'category' => 'Actinide',
            'symbol'   => 'Fm',
            'amu'      => '257',
            'fact'     => 'Enrico Fermi, Italian physicist',
            'group'    => '13'
        },
        'Bh' => {
            'phase'    => 'artificial',
            'period'   => '7',
            'colour'   => '7',
            'name'     => 'Bohrium',
            'number'   => '107',
            'category' => 'Transactinide',
            'symbol'   => 'Bh',
            'amu'      => '264',
            'fact'     => 'Niels Bohr, Danish physicist',
            'group'    => '7'
        },
        'Lv' => {
            'category' => 'Transactinide',
            'symbol'   => 'Lv',
            'number'   => '116',
            'group'    => '16',
            'fact'     =>
'Lawrence Livermore National Laboratory in Livermore, California, which collaborated with JINR on its synthesis',
            'amu'    => '292',
            'period' => '7',
            'phase'  => 'artificial',
            'name'   => 'Livermorium',
            'colour' => '4'
        },
        'Pr' => {
            'colour'   => '12',
            'name'     => 'Praseodymium',
            'phase'    => 'solid',
            'period'   => '8',
            'fact'     => 'Greek prasios didymos, \'green twin\'',
            'amu'      => '140.908',
            'group'    => '4',
            'number'   => '59',
            'category' => 'Lanthanide',
            'symbol'   => 'Pr'
        },
        'Zn' => {
            'name'   => 'Zinc',
            'colour' => '7',
            'period' => '4',
            'phase'  => 'solid',
            'group'  => '12',
            'amu'    => '65.38',
            'fact'   =>
'Most likely from German Zinke, \'prong\' or \'tooth\', though some suggest Persian sang, \'stone\'',
            'symbol'   => 'Zn',
            'category' => 'Transition Metal',
            'number'   => '30'
        },
        'Sg' => {
            'number'   => '106',
            'category' => 'Transactinide',
            'symbol'   => 'Sg',
            'fact'     => 'Glenn T. Seaborg, American chemist',
            'amu'      => '266',
            'group'    => '6',
            'phase'    => 'artificial',
            'period'   => '7',
            'colour'   => '7',
            'name'     => 'Seaborgium'
        },
        'Gd' => {
            'colour' => '12',
            'name'   => 'Gadolinium',
            'phase'  => 'solid',
            'period' => '8',
            'amu'    => '157.25',
            'fact'   =>
'gadolinite, a mineral named after Johan Gadolin, Finnish chemist, physicist and mineralogist',
            'group'    => '9',
            'number'   => '64',
            'symbol'   => 'Gd',
            'category' => 'Lanthanide'
        },
        'Cr' => {
            'symbol'   => 'Cr',
            'category' => 'Transition Metal',
            'number'   => '24',
            'group'    => '6',
            'fact'     => 'Greek chroma, \'colour\'',
            'amu'      => '51.996',
            'period'   => '4',
            'phase'    => 'solid',
            'name'     => 'Chromium',
            'colour'   => '7'
        },
        'Cf' => {
            'amu'      => '251',
            'fact'     => 'California, where the element was first synthesised',
            'group'    => '11',
            'number'   => '98',
            'symbol'   => 'Cf',
            'category' => 'Actinide',
            'colour'   => '13',
            'name'     => 'Californium',
            'phase'    => 'artificial',
            'period'   => '9'
        },
        'Sb' => {
            'phase'    => 'solid',
            'period'   => '5',
            'colour'   => '5',
            'name'     => 'Antimony',
            'number'   => '51',
            'category' => 'Metalloid',
            'symbol'   => 'Sb',
            'fact'     =>
'Latin antimonium, the origin of which is uncertain: folk etymologies suggest it is derived from Greek anti (\'against\') + monos (\'alone\'), or Old French anti-moine, \'Monk\'s bane\', but it could plausibly be from or related to Arabic _itmid, \'antimony\', reformatted as a Latin word. (The symbol derives from Latin stibium \'stibnite\'.)',
            'amu'   => '121.76',
            'group' => '15'
        },
        'Pt' => {
            'name'   => 'Platinum',
            'colour' => '7',
            'period' => '6',
            'phase'  => 'solid',
            'group'  => '10',
            'amu'    => '195.084',
            'fact'   =>
              'Spanish platina, \'little silver\', from plata \'silver\'',
            'category' => 'Transition Metal',
            'symbol'   => 'Pt',
            'number'   => '78'
        },
        'Kr' => {
            'phase'    => 'gas',
            'period'   => '4',
            'colour'   => '2',
            'name'     => 'Krypton',
            'number'   => '36',
            'symbol'   => 'Kr',
            'category' => 'Noble Gas',
            'amu'      => '83.798',
            'fact'     => 'Greek kryptos, \'hidden\'',
            'group'    => '18'
        },
        'Xe' => {
            'phase'    => 'gas',
            'period'   => '5',
            'colour'   => '2',
            'name'     => 'Xenon',
            'number'   => '54',
            'symbol'   => 'Xe',
            'category' => 'Noble Gas',
            'amu'      => '131.293',
            'fact'     => 'Greek xenon, neuter form of xenos \'strange\'',
            'group'    => '18'
        },
        'Ga' => {
            'colour'   => '0',
            'name'     => 'Gallium',
            'phase'    => 'solid',
            'period'   => '4',
            'amu'      => '69.723',
            'fact'     => 'Latin Gallia, \'France\'',
            'group'    => '13',
            'number'   => '31',
            'category' => 'Metal',
            'symbol'   => 'Ga'
        },
        'W' => {
            'name'   => 'Tungsten',
            'colour' => '7',
            'period' => '6',
            'phase'  => 'solid',
            'group'  => '6',
            'fact'   =>
'Swedish tung sten, \'heavy stone\' (The symbol is from wolfram, the old name of the tungsten mineral wolframite)',
            'amu'      => '183.84',
            'category' => 'Transition Metal',
            'symbol'   => 'W',
            'number'   => '74'
        },
        'Re' => {
            'name'     => 'Rhenium',
            'colour'   => '7',
            'period'   => '6',
            'phase'    => 'solid',
            'group'    => '7',
            'fact'     => 'Latin Rhenus, \'the Rhine\'',
            'amu'      => '186.207',
            'category' => 'Transition Metal',
            'symbol'   => 'Re',
            'number'   => '75'
        },
        'Db' => {
            'period'   => '7',
            'phase'    => 'artificial',
            'name'     => 'Dubnium',
            'colour'   => '7',
            'category' => 'Transactinide',
            'symbol'   => 'Db',
            'number'   => '105',
            'group'    => '5',
            'fact'     =>
'Dubna, Russia, where the Joint Institute for Nuclear Research is located',
            'amu' => '262'
        },
        'Hf' => {
            'number'   => '72',
            'symbol'   => 'Hf',
            'category' => 'Transition Metal',
            'amu'      => '178.49',
            'fact'     => 'New Latin Hafnia, \'Copenhagen\' (from Danish havn)',
            'group'    => '4',
            'phase'    => 'solid',
            'period'   => '6',
            'colour'   => '7',
            'name'     => 'Hafnium'
        },
        'Rg' => {
            'category' => 'Transactinide',
            'symbol'   => 'Rg',
            'number'   => '111',
            'group'    => '11',
            'fact'     => 'Wilhelm Conrad Rontgen, German physicist',
            'amu'      => '272',
            'period'   => '7',
            'phase'    => 'artificial',
            'name'     => 'Roentgenium',
            'colour'   => '7'
        },
        'Be' => {
            'period'   => '2',
            'phase'    => 'solid',
            'name'     => 'Beryllium',
            'colour'   => '10',
            'category' => 'Alkaline Earth Metal',
            'symbol'   => 'Be',
            'number'   => '4',
            'group'    => '2',
            'fact'     =>
'beryl, a mineral (ultimately from the name of Belur in southern India)',
            'amu' => '9.012'
        },
        'Bi' => {
            'name'   => 'Bismuth',
            'colour' => '5',
            'period' => '6',
            'phase'  => 'solid',
            'group'  => '15',
            'fact'   =>
'German Wismut, from weiss Masse \'white mass\', unless from Arabic',
            'amu'      => '208.98',
            'category' => 'Metal',
            'symbol'   => 'Bi',
            'number'   => '83'
        },
        'Li' => {
            'fact'     => 'Greek lithos, \'stone\'',
            'amu'      => '6.941',
            'group'    => '1',
            'number'   => '3',
            'category' => 'Alkali Metal',
            'symbol'   => 'Li',
            'colour'   => '11',
            'name'     => 'Lithium',
            'phase'    => 'solid',
            'period'   => '2'
        },
        'O' => {
            'phase'    => 'gas',
            'period'   => '2',
            'colour'   => '4',
            'name'     => 'Oxygen',
            'number'   => '8',
            'symbol'   => 'O',
            'category' => 'Nonmetal',
            'fact'     => 'Greek oxy- and -gen, meaning \'acid-forming\'',
            'amu'      => '15.999',
            'group'    => '16'
        },
        'Np' => {
            'fact'     => 'Neptune, the eighth planet in the Solar System',
            'amu'      => '237',
            'group'    => '6',
            'number'   => '93',
            'category' => 'Actinide',
            'symbol'   => 'Np',
            'colour'   => '13',
            'name'     => 'Neptunium',
            'phase'    => 'artificial',
            'period'   => '9'
        },
        'Am' => {
            'category' => 'Actinide',
            'symbol'   => 'Am',
            'number'   => '95',
            'group'    => '8',
            'amu'      => '243',
            'fact'     =>
'The Americas, as the element was first synthesised on the continent, by analogy with europium',
            'period' => '9',
            'phase'  => 'artificial',
            'name'   => 'Americium',
            'colour' => '13'
        },
        'Rb' => {
            'symbol'   => 'Rb',
            'category' => 'Alkali Metal',
            'number'   => '37',
            'group'    => '1',
            'fact'     => 'Latin rubidus, \'deep red\'',
            'amu'      => '85.468',
            'period'   => '5',
            'phase'    => 'solid',
            'name'     => 'Rubidium',
            'colour'   => '11'
        },
        'Mc' => {
            'category' => 'Post-transition Metal',
            'symbol'   => 'Mc',
            'number'   => '115',
            'group'    => '15',
            'fact'     =>
              'Moscow Oblast, Russia, where the element was first synthesised',
            'amu'    => '288',
            'period' => '7',
            'phase'  => 'artificial',
            'name'   => 'Moscovium',
            'colour' => '5'
        },
        'Md' => {
            'name'   => 'Mendelevium',
            'colour' => '13',
            'period' => '9',
            'phase'  => 'artificial',
            'group'  => '14',
            'fact'   =>
'Dmitri Mendeleev, Russian chemist and inventor who proposed the periodic table',
            'amu'      => '258',
            'symbol'   => 'Md',
            'category' => 'Actinide',
            'number'   => '101'
        },
        'Rh' => {
            'amu'  => '102.906',
            'fact' =>
              'Greek rhodoeis, \'rose-coloured\', from rhodon, \'rose\'',
            'group'    => '9',
            'number'   => '45',
            'symbol'   => 'Rh',
            'category' => 'Transition Metal',
            'colour'   => '7',
            'name'     => 'Rhodium',
            'phase'    => 'solid',
            'period'   => '5'
        },
        'Tc' => {
            'symbol'   => 'Tc',
            'category' => 'Transition Metal',
            'number'   => '43',
            'group'    => '7',
            'fact'     => 'Greek tekhnetos, \'artificial\'',
            'amu'      => '98',
            'period'   => '5',
            'phase'    => 'artificial',
            'name'     => 'Technetium',
            'colour'   => '7'
        },
        'Ac' => {
            'number'   => '89',
            'symbol'   => 'Ac',
            'category' => 'Actinide',
            'amu'      => '227',
            'fact'     => 'Greek aktis, \'ray\'',
            'group'    => '3',
            'phase'    => 'solid',
            'period'   => '7',
            'colour'   => '13',
            'name'     => 'Actinium'
        },
        'Fe' => {
            'number'   => '26',
            'category' => 'Transition Metal',
            'symbol'   => 'Fe',
            'fact'     =>
              'English word (the symbol Fe is derived from Latin ferrum)',
            'amu'    => '55.845',
            'group'  => '8',
            'phase'  => 'solid',
            'period' => '4',
            'colour' => '7',
            'name'   => 'Iron'
        },
        'Si' => {
            'category' => 'Metalloid',
            'symbol'   => 'Si',
            'number'   => '14',
            'group'    => '14',
            'fact'     => 'Latin silex, \'flint\' (originally silicium)',
            'amu'      => '28.086',
            'period'   => '3',
            'phase'    => 'solid',
            'name'     => 'Silicone',
            'colour'   => '6'
        },
        'Ta' => {
            'category' => 'Transition Metal',
            'symbol'   => 'Ta',
            'number'   => '73',
            'group'    => '5',
            'fact'     => 'King Tantalus, father of Niobe from Greek mythology',
            'amu'      => '180.948',
            'period'   => '6',
            'phase'    => 'solid',
            'name'     => 'Tantalum',
            'colour'   => '7'
        },
        'Se' => {
            'phase'    => 'solid',
            'period'   => '4',
            'colour'   => '4',
            'name'     => 'Selenium',
            'number'   => '34',
            'symbol'   => 'Se',
            'category' => 'Nonmetal',
            'fact'     => 'Greek selene, \'moon\'',
            'amu'      => '78.96',
            'group'    => '16'
        },
        'Tm' => {
            'group' => '14',
            'amu'   => '168.934',
            'fact'  =>
              'Thule, the ancient name for an unclear northern location',
            'symbol'   => 'Tm',
            'category' => 'Lanthanide',
            'number'   => '69',
            'name'     => 'Thulium',
            'colour'   => '12',
            'period'   => '8',
            'phase'    => 'solid'
        },
        'Ag' => {
            'phase'    => 'solid',
            'period'   => '5',
            'colour'   => '7',
            'name'     => 'Silver',
            'number'   => '47',
            'symbol'   => 'Ag',
            'category' => 'Transition Metal',
            'amu'      => '107.868',
            'fact'  => 'English word (The symbol derives from Latin argentum)',
            'group' => '11'
        },
        'Zr' => {
            'phase'    => 'solid',
            'period'   => '5',
            'colour'   => '7',
            'name'     => 'Zirconium',
            'number'   => '40',
            'symbol'   => 'Zr',
            'category' => 'Transition Metal',
            'amu'      => '91.224',
            'fact'     => 'zircon, a mineral',
            'group'    => '4'
        },
        'Mo' => {
            'number'   => '42',
            'category' => 'Transition Metal',
            'symbol'   => 'Mo',
            'fact'     =>
              'Greek molybdaina, \'piece of lead\', from molybdos, \'lead\'',
            'amu'    => '95.96',
            'group'  => '6',
            'phase'  => 'solid',
            'period' => '5',
            'colour' => '7',
            'name'   => 'Molybdenum'
        },
        'Cl' => {
            'group'    => '17',
            'amu'      => '35.453',
            'fact'     => 'Greek chloros, \'greenish yellow\'',
            'symbol'   => 'Cl',
            'category' => 'Halogen',
            'number'   => '17',
            'name'     => 'Chlorine',
            'colour'   => '3',
            'period'   => '3',
            'phase'    => 'gas'
        },
        'Mg' => {
            'fact'     => 'Magnesia, a district of Eastern Thessaly in Greece',
            'amu'      => '24.305',
            'group'    => '2',
            'number'   => '12',
            'category' => 'Alkaline Earth Metal',
            'symbol'   => 'Mg',
            'colour'   => '10',
            'name'     => 'Magnesium',
            'phase'    => 'solid',
            'period'   => '3'
        },
        'U' => {
            'number'   => '92',
            'symbol'   => 'U',
            'category' => 'Actinide',
            'fact'     => 'Uranus, the seventh planet in the Solar System',
            'amu'      => '238.029',
            'group'    => '5',
            'phase'    => 'solid',
            'period'   => '9',
            'colour'   => '13',
            'name'     => 'Uranium'
        },
        'Th' => {
            'fact'     => 'Thor, the Scandinavian God of thunder',
            'amu'      => '232.038',
            'group'    => '3',
            'number'   => '90',
            'category' => 'Actinide',
            'symbol'   => 'Th',
            'colour'   => '13',
            'name'     => 'Thorium',
            'phase'    => 'solid',
            'period'   => '9'
        },
        'Tb' => {
            'phase'    => 'solid',
            'period'   => '8',
            'colour'   => '12',
            'name'     => 'Terbium',
            'number'   => '65',
            'category' => 'Lanthanide',
            'symbol'   => 'Tb',
            'amu'      => '158.925',
            'fact'     => 'Ytterby, a village in Sweden',
            'group'    => '10'
        },
        'Cn' => {
            'phase'    => 'artificial',
            'period'   => '7',
            'colour'   => '7',
            'name'     => 'Copernicium',
            'number'   => '112',
            'symbol'   => 'Cn',
            'category' => 'Transactinide',
            'amu'      => '285',
            'fact'     => 'Nicolaus Copernicus, Polish astronomer',
            'group'    => '12'
        },
        'Cs' => {
            'colour'   => '11',
            'name'     => 'Cesium',
            'phase'    => 'solid',
            'period'   => '6',
            'fact'     => 'Latin caesius, \'sky-blue\'',
            'amu'      => '132.905',
            'group'    => '1',
            'number'   => '55',
            'symbol'   => 'Cs',
            'category' => 'Alkali Metal'
        },
        'Ge' => {
            'period'   => '4',
            'phase'    => 'solid',
            'name'     => 'Germanium',
            'colour'   => '6',
            'symbol'   => 'Ge',
            'category' => 'Metalloid',
            'number'   => '32',
            'group'    => '14',
            'fact'     => 'Latin Germania, \'Germany\'',
            'amu'      => '72.64'
        },
        'Og' => {
            'fact'     => 'Yuri Oganessian, Russian physicist',
            'amu'      => '294',
            'group'    => '18',
            'number'   => '118',
            'symbol'   => 'Og',
            'category' => 'Noble Gas',
            'colour'   => '2',
            'name'     => 'Oganesson',
            'phase'    => 'artificial',
            'period'   => '7'
        },
        'Ra' => {
            'number'   => '88',
            'category' => 'Actinide',
            'symbol'   => 'Ra',
            'fact'     => 'French radium, from Latin radius, \'ray\'',
            'amu'      => '226',
            'group'    => '2',
            'phase'    => 'solid',
            'period'   => '7',
            'colour'   => '10',
            'name'     => 'Radium'
        },
        'I' => {
            'symbol'   => 'I',
            'category' => 'Halogen',
            'number'   => '53',
            'group'    => '17',
            'amu'      => '126.904',
            'fact'     => 'French iode, from Greek ioeides, \'violet\')',
            'period'   => '5',
            'phase'    => 'solid',
            'name'     => 'Iodine',
            'colour'   => '3'
        },
        'Br' => {
            'colour'   => '3',
            'name'     => 'Bromine',
            'phase'    => 'liquid',
            'period'   => '4',
            'fact'     => 'Greek bromos, \'stench\'',
            'amu'      => '79.904',
            'group'    => '17',
            'number'   => '35',
            'category' => 'Halogen',
            'symbol'   => 'Br'
        },
        'Lr' => {
            'symbol'   => 'Lr',
            'category' => 'Actinide',
            'number'   => '103',
            'group'    => '16',
            'fact'     => 'Ernest O. Lawrence, American physicist',
            'amu'      => '262',
            'period'   => '9',
            'phase'    => 'artificial',
            'name'     => 'Lawrencium',
            'colour'   => '13'
        },
        'Al' => {
            'colour' => '0',
            'name'   => 'Aluminium',
            'phase'  => 'solid',
            'period' => '3',
            'fact'   =>
'alumina, from Latin alumen (gen. aluminis), \'bitter salt, alum\'',
            'amu'      => '26.982',
            'group'    => '13',
            'number'   => '13',
            'symbol'   => 'Al',
            'category' => 'Metal'
        },
        'Os' => {
            'fact'     => 'Greek osme, \'smell\'',
            'amu'      => '190.23',
            'group'    => '8',
            'number'   => '76',
            'symbol'   => 'Os',
            'category' => 'Transition Metal',
            'colour'   => '7',
            'name'     => 'Osmium',
            'phase'    => 'solid',
            'period'   => '6'
        },
        'Bk' => {
            'name'   => 'Berkelium',
            'colour' => '13',
            'period' => '9',
            'phase'  => 'artificial',
            'group'  => '10',
            'amu'    => '247',
            'fact'   =>
'Berkeley, California, where the element was first synthesised, by analogy with terbium',
            'symbol'   => 'Bk',
            'category' => 'Actinide',
            'number'   => '97'
        },
        'Tl' => {
            'category' => 'Metal',
            'symbol'   => 'Tl',
            'number'   => '81',
            'group'    => '13',
            'fact'     => 'Greek thallos, \'green shoot or twig\'',
            'amu'      => '204.383',
            'period'   => '6',
            'phase'    => 'solid',
            'name'     => 'Thallium',
            'colour'   => '0'
        },
        'He' => {
            'fact'     => 'Greek helios, \'sun\'',
            'amu'      => '4.002',
            'group'    => '18',
            'number'   => '2',
            'category' => 'Noble Gas',
            'symbol'   => 'He',
            'colour'   => '2',
            'name'     => 'Helium',
            'phase'    => 'gas',
            'period'   => '1'
        },
        'Er' => {
            'amu'      => '167.259',
            'fact'     => 'Ytterby, a village in Sweden',
            'group'    => '13',
            'number'   => '68',
            'symbol'   => 'Er',
            'category' => 'Lanthanide',
            'colour'   => '12',
            'name'     => 'Erbium',
            'phase'    => 'solid',
            'period'   => '8'
        },
        'Pb' => {
            'symbol'   => 'Pb',
            'category' => 'Metal',
            'number'   => '82',
            'group'    => '14',
            'fact'   => 'English word (The symbol derives from Latin plumbum)',
            'amu'    => '207.2',
            'period' => '6',
            'phase'  => 'solid',
            'name'   => 'Lead',
            'colour' => '6'
        },
        'Co' => {
            'name'     => 'Cobalt',
            'colour'   => '7',
            'period'   => '4',
            'phase'    => 'solid',
            'group'    => '9',
            'amu'      => '58.933',
            'fact'     => 'German Kobold, \'goblin\'',
            'symbol'   => 'Co',
            'category' => 'Transition Metal',
            'number'   => '27'
        },
        'Fr' => {
            'colour'   => '11',
            'name'     => 'Francium',
            'phase'    => 'solid',
            'period'   => '7',
            'amu'      => '223',
            'fact'     => 'France',
            'group'    => '1',
            'number'   => '87',
            'symbol'   => 'Fr',
            'category' => 'Alkaline Earth Metal'
        },
        'Sr' => {
            'period'   => '5',
            'phase'    => 'solid',
            'name'     => 'Strontium',
            'colour'   => '10',
            'category' => 'Alkaline Earth Metal',
            'symbol'   => 'Sr',
            'number'   => '38',
            'group'    => '2',
            'amu'      => '87.62',
            'fact'     => 'Strontian, a village in Scotland'
        },
        'Po' => {
            'fact' =>
              'Latin Polonia, \'Poland\' (the home country of Marie Curie)',
            'amu'      => '210',
            'group'    => '16',
            'number'   => '84',
            'symbol'   => 'Po',
            'category' => 'Metalloid',
            'colour'   => '4',
            'name'     => 'Polonium',
            'phase'    => 'solid',
            'period'   => '6'
        },
        'As' => {
            'amu'  => '74.922',
            'fact' =>
'French arsenic, from Greek arsenikon \'yellow arsenic\' (influenced by arsenikos, \'masculine\' or \'virile\'), from a West Asian wanderword ultimately from Old Iranian *zarniya-ka, \'golden\'',
            'group'    => '15',
            'number'   => '33',
            'symbol'   => 'As',
            'category' => 'Metalloid',
            'colour'   => '5',
            'name'     => 'Arsenic',
            'phase'    => 'solid',
            'period'   => '4'
        },
        'Ts' => {
            'period'   => '7',
            'phase'    => 'artificial',
            'name'     => 'Tennessine',
            'colour'   => '3',
            'category' => 'Post-transition Metal',
            'symbol'   => 'Ts',
            'number'   => '117',
            'group'    => '17',
            'amu'      => '295',
            'fact'     => 'Tennessee, United States'
        },
        'Ni' => {
            'colour' => '7',
            'name'   => 'Nickel',
            'phase'  => 'solid',
            'period' => '4',
            'fact'  => 'Nickel, a mischievous sprite of German miner mythology',
            'amu'   => '58.693',
            'group' => '10',
            'number'   => '28',
            'symbol'   => 'Ni',
            'category' => 'Transition Metal'
        },
        'Y' => {
            'group'    => '3',
            'fact'     => 'Ytterby, a village in Sweden',
            'amu'      => '88.906',
            'category' => 'Transition Metal',
            'symbol'   => 'Y',
            'number'   => '39',
            'name'     => 'Yttrium',
            'colour'   => '7',
            'period'   => '5',
            'phase'    => 'solid'
        },
        'Mn' => {
            'colour'   => '7',
            'name'     => 'Manganese',
            'phase'    => 'solid',
            'period'   => '4',
            'amu'      => '54.938',
            'fact'     => 'corrupted from magnesia negra; see Magnesium',
            'group'    => '7',
            'number'   => '25',
            'symbol'   => 'Mn',
            'category' => 'Transition Metal'
        },
        'Ne' => {
            'fact'     => 'Greek neon, \'new\'',
            'amu'      => '20.18',
            'group'    => '18',
            'number'   => '10',
            'symbol'   => 'Ne',
            'category' => 'Noble Gas',
            'colour'   => '2',
            'name'     => 'Neon',
            'phase'    => 'gas',
            'period'   => '2'
        },
        'Pa' => {
            'number'   => '91',
            'category' => 'Actinide',
            'symbol'   => 'Pa',
            'amu'      => '231.036',
            'fact'     =>
'proto- (from Greek protos, \'first, before\') + actinium, which is produced through the radioactive decay of protactinium',
            'group'  => '4',
            'phase'  => 'solid',
            'period' => '9',
            'colour' => '13',
            'name'   => 'Protactinium'
        },
        'C' => {
            'period'   => '2',
            'phase'    => 'solid',
            'name'     => 'Carbon',
            'colour'   => '6',
            'category' => 'Nonmetal',
            'symbol'   => 'C',
            'number'   => '6',
            'group'    => '14',
            'amu'      => '12.011',
            'fact'     => 'Latin carbo, \'coal\''
        },
        'In' => {
            'symbol'   => 'In',
            'category' => 'Metal',
            'number'   => '49',
            'group'    => '13',
            'fact'     =>
              'Latin indicum, \'indigo\' (colour found in its spectrum)',
            'amu'    => '114.818',
            'period' => '5',
            'phase'  => 'solid',
            'name'   => 'Indium',
            'colour' => '0'
        },
        'Pm' => {
            'group'    => '6',
            'fact'     => 'Prometheus of Greek mythology',
            'amu'      => '145',
            'category' => 'Lanthanide',
            'symbol'   => 'Pm',
            'number'   => '61',
            'name'     => 'Promethium',
            'colour'   => '12',
            'period'   => '8',
            'phase'    => 'artificial'
        },
        'K' => {
            'group' => '1',
            'amu'   => '39.098',
            'fact'  =>
'New Latin potassa, \'potash\' (the symbol K is derived from Latin kalium)',
            'symbol'   => 'K',
            'category' => 'Alkali Metal',
            'number'   => '19',
            'name'     => 'Potassium',
            'colour'   => '11',
            'period'   => '4',
            'phase'    => 'solid'
        },
        'Pd' => {
            'number'   => '46',
            'symbol'   => 'Pd',
            'category' => 'Transition Metal',
            'fact'   => 'the asteroid Pallas, considered a planet at the time',
            'amu'    => '106.42',
            'group'  => '10',
            'phase'  => 'solid',
            'period' => '5',
            'colour' => '7',
            'name'   => 'Palladium'
        },
        'Yb' => {
            'amu'      => '173.054',
            'fact'     => 'Ytterby, a village in Sweden',
            'group'    => '15',
            'number'   => '70',
            'symbol'   => 'Yb',
            'category' => 'Lanthanide',
            'colour'   => '12',
            'name'     => 'Ytterbium',
            'phase'    => 'solid',
            'period'   => '8'
        },
        'Ds' => {
            'colour' => '7',
            'name'   => 'Darmstadtium',
            'phase'  => 'artificial',
            'period' => '7',
            'fact'   =>
              'Darmstadt, Germany, where the element was first synthesised',
            'amu'      => '271',
            'group'    => '10',
            'number'   => '110',
            'category' => 'Transactinide',
            'symbol'   => 'Ds'
        },
        'Cd' => {
            'group'    => '12',
            'amu'      => '112.411',
            'fact'     => 'New Latin cadmia, from King Kadmos',
            'category' => 'Transition Metal',
            'symbol'   => 'Cd',
            'number'   => '48',
            'name'     => 'Cadmium',
            'colour'   => '7',
            'period'   => '5',
            'phase'    => 'solid'
        },
        'Eu' => {
            'fact'     => 'Europe',
            'amu'      => '151.964',
            'group'    => '8',
            'number'   => '63',
            'category' => 'Lanthanide',
            'symbol'   => 'Eu',
            'colour'   => '12',
            'name'     => 'Europium',
            'phase'    => 'solid',
            'period'   => '8'
        },
        'Ca' => {
            'colour'   => '10',
            'name'     => 'Calcium',
            'phase'    => 'solid',
            'period'   => '4',
            'amu'      => '40.078',
            'fact'     => 'Latin calx, \'lime\'',
            'group'    => '2',
            'number'   => '20',
            'symbol'   => 'Ca',
            'category' => 'Alkaline Earth Metal'
        },
        'Lu' => {
            'name'     => 'Lutetium',
            'colour'   => '12',
            'period'   => '8',
            'phase'    => 'solid',
            'group'    => '16',
            'amu'      => '174.967',
            'fact'     => 'Latin Lutetia, \'Paris\'',
            'category' => 'Lanthanide',
            'symbol'   => 'Lu',
            'number'   => '71'
        },
        'P' => {
            'symbol'   => 'P',
            'category' => 'Nonmetal',
            'number'   => '15',
            'group'    => '15',
            'fact'     => 'Greek phosphoros, \'light-bearing\'',
            'amu'      => '30.974',
            'period'   => '3',
            'phase'    => 'solid',
            'name'     => 'Phosphorus',
            'colour'   => '5'
        },
        'Rn' => {
            'name'     => 'Radon',
            'colour'   => '2',
            'period'   => '6',
            'phase'    => 'gas',
            'group'    => '18',
            'fact'     => 'radium',
            'amu'      => '222',
            'symbol'   => 'Rn',
            'category' => 'Alkali Metal',
            'number'   => '86'
        },
        'Cm' => {
            'number'   => '96',
            'category' => 'Actinide',
            'symbol'   => 'Cm',
            'amu'      => '247',
            'fact'     =>
              'Pierre Curie and Marie Curie, French physicists and chemists',
            'group'  => '9',
            'phase'  => 'artificial',
            'period' => '9',
            'colour' => '13',
            'name'   => 'Curium'
        },
        'At' => {
            'symbol'   => 'At',
            'category' => 'Noble Gas',
            'number'   => '85',
            'group'    => '17',
            'fact'     => 'Greek astatos, \'unstable\'',
            'amu'      => '210',
            'period'   => '6',
            'phase'    => 'solid',
            'name'     => 'Astatine',
            'colour'   => '3'
        },
        'Es' => {
            'colour'   => '13',
            'name'     => 'Einsteinium',
            'phase'    => 'artificial',
            'period'   => '9',
            'fact'     => 'Albert Einstein, German physicist',
            'amu'      => '252',
            'group'    => '12',
            'number'   => '99',
            'category' => 'Actinide',
            'symbol'   => 'Es'
        },
        'N' => {
            'name'     => 'Nitrogen',
            'colour'   => '5',
            'period'   => '2',
            'phase'    => 'gas',
            'group'    => '15',
            'amu'      => '14.007',
            'fact'     => 'Greek nitron and -gen, meaning \'niter-forming\'',
            'symbol'   => 'N',
            'category' => 'Nonmetal',
            'number'   => '7'
        },
        'Mt' => {
            'period'   => '7',
            'phase'    => 'artificial',
            'name'     => 'Meitnerium',
            'colour'   => '7',
            'symbol'   => 'Mt',
            'category' => 'Transactinide',
            'number'   => '109',
            'group'    => '9',
            'amu'      => '268',
            'fact'     => 'Lise Meitner, Austrian physicist'
        },
        'Fl' => {
            'group' => '14',
            'amu'   => '289',
            'fact'  =>
'Flerov Laboratory of Nuclear Reactions, part of JINR, where the element was synthesised; itself named after Georgy Flyorov, Russian physicist',
            'symbol'   => 'Fl',
            'category' => 'Transactinide',
            'number'   => '114',
            'name'     => 'Flerovium',
            'colour'   => '6',
            'period'   => '7',
            'phase'    => 'artificial'
        },
        'Ru' => {
            'name'     => 'Ruthenium',
            'colour'   => '7',
            'period'   => '5',
            'phase'    => 'solid',
            'group'    => '8',
            'amu'      => '101.07',
            'fact'     => 'New Latin Ruthenia, \'Russia\'',
            'symbol'   => 'Ru',
            'category' => 'Transition Metal',
            'number'   => '44'
        },
        'V' => {
            'period'   => '4',
            'phase'    => 'solid',
            'name'     => 'Vanadium',
            'colour'   => '7',
            'category' => 'Transition Metal',
            'symbol'   => 'V',
            'number'   => '23',
            'group'    => '5',
            'amu'      => '50.942',
            'fact'     =>
              'Vanadis, an Old Norse name for the Scandinavian Goddess Freyja'
        },
        'H' => {
            'number'   => '1',
            'symbol'   => 'H',
            'category' => 'Nonmetal',
            'fact'     =>
              'Greek elements hydro- and -gen, meaning \'water-forming\'',
            'amu'    => '1.007',
            'group'  => '1',
            'phase'  => 'gas',
            'period' => '1',
            'colour' => '1',
            'name'   => 'Hydrogen'
        },
        'Nd' => {
            'colour'   => '12',
            'name'     => 'Neodymium',
            'phase'    => 'solid',
            'period'   => '8',
            'amu'      => '144.242',
            'fact'     => 'Greek neos didymos, \'new twin\'',
            'group'    => '5',
            'number'   => '60',
            'symbol'   => 'Nd',
            'category' => 'Lanthanide'
        },
        'Sn' => {
            'amu'    => '118.71',
            'fact'   => 'English word (The symbol derives from Latin stannum)',
            'group'  => '14',
            'number' => '50',
            'symbol' => 'Sn',
            'category' => 'Metal',
            'colour'   => '6',
            'name'     => 'Tin',
            'phase'    => 'solid',
            'period'   => '5'
        },
        'Ar' => {
            'number'   => '18',
            'category' => 'Noble Gas',
            'symbol'   => 'Ar',
            'amu'      => '39.948',
            'fact'     => 'Greek argos, \'idle\' (because of its inertness)',
            'group'    => '18',
            'phase'    => 'gas',
            'period'   => '3',
            'colour'   => '2',
            'name'     => 'Argon'
        },
        'Na' => {
            'group' => '1',
            'fact'  =>
'English soda (the symbol Na is derived from New Latin natrium, coined from German Natron, \'natron\')',
            'amu'      => '22.99',
            'symbol'   => 'Na',
            'category' => 'Alkali Metal',
            'number'   => '11',
            'name'     => 'Sodium',
            'colour'   => '11',
            'period'   => '3',
            'phase'    => 'solid'
        },
        'Dy' => {
            'colour'   => '12',
            'name'     => 'Dysprosium',
            'phase'    => 'solid',
            'period'   => '8',
            'amu'      => '162.5',
            'fact'     => 'Greek dysprositos, \'hard to get\'',
            'group'    => '11',
            'number'   => '66',
            'symbol'   => 'Dy',
            'category' => 'Lanthanide'
        },
        'Au' => {
            'number'   => '79',
            'category' => 'Transition Metal',
            'symbol'   => 'Au',
            'amu'      => '196.967',
            'fact'     => 'English word (The symbol derives from Latin aurum)',
            'group'    => '11',
            'phase'    => 'solid',
            'period'   => '6',
            'colour'   => '7',
            'name'     => 'Gold'
        },
        'No' => {
            'category' => 'Actinide',
            'symbol'   => 'No',
            'number'   => '102',
            'group'    => '15',
            'amu'      => '259',
            'fact'     => 'Alfred Nobel, Swedish chemist and engineer',
            'period'   => '9',
            'phase'    => 'artificial',
            'name'     => 'Nobelium',
            'colour'   => '13'
        },
        'Ir' => {
            'colour'   => '7',
            'name'     => 'Iridium',
            'phase'    => 'solid',
            'period'   => '6',
            'fact'     => 'Iris, the Greek Goddess of the rainbow',
            'amu'      => '192.217',
            'group'    => '9',
            'number'   => '77',
            'symbol'   => 'Ir',
            'category' => 'Transition Metal'
        },
        'Nb' => {
            'phase'    => 'solid',
            'period'   => '5',
            'colour'   => '7',
            'name'     => 'Niobium',
            'number'   => '41',
            'category' => 'Transition Metal',
            'symbol'   => 'Nb',
            'fact'  => 'Niobe, daughter of king Tantalus from Greek mythology',
            'amu'   => '92.906',
            'group' => '5'
        },
        'Nh' => {
            'colour' => '0',
            'name'   => 'Nihonium',
            'phase'  => 'artificial',
            'period' => '7',
            'amu'    => '284',
            'fact'   =>
'Japanese Nihon, \'Japan\' (where the element was first synthesised)',
            'group'    => '13',
            'number'   => '113',
            'category' => 'Post-transition Metal',
            'symbol'   => 'Nh'
        },
        'Rf' => {
            'name'   => 'Rutherfordium',
            'colour' => '7',
            'period' => '7',
            'phase'  => 'artificial',
            'group'  => '4',
            'amu'    => '261',
            'fact'   =>
              'Ernest Rutherford, chemist and physicist from New Zealand',
            'symbol'   => 'Rf',
            'category' => 'Transactinide',
            'number'   => '104'
        },
        'Hg' => {
            'name'   => 'Mercury',
            'colour' => '7',
            'period' => '6',
            'phase'  => 'liquid',
            'group'  => '12',
            'amu'    => '200.59',
            'fact'   =>
'Mercury, Roman God of commerce, communication, and luck, known for his speed and mobility (The symbol is from the element\'s Latin name hydrargyrum, derived from Greek hydrargyros, \'water-silver\')',
            'symbol'   => 'Hg',
            'category' => 'Transition Metal',
            'number'   => '80'
        },
        'Ce' => {
            'name'   => 'Cerium',
            'colour' => '12',
            'period' => '8',
            'phase'  => 'solid',
            'group'  => '3',
            'amu'    => '140.116',
            'fact' => 'the dwarf planet Ceres, considered a planet at the time',
            'symbol'   => 'Ce',
            'category' => 'Lanthanide',
            'number'   => '58'
        },
        'Ho' => {
            'symbol'   => 'Ho',
            'category' => 'Lanthanide',
            'number'   => '67',
            'group'    => '12',
            'amu'      => '164.93',
            'fact'     => 'New Latin Holmia, \'Stockholm\'',
            'period'   => '8',
            'phase'    => 'solid',
            'name'     => 'Holmium',
            'colour'   => '12'
        }
    },
    'compounds' => {
        'C21H30O2'      => 'Tetrahydrocannabinol',
        'H2SO4'         => 'Sulphuric Acid',
        'NH3'           => 'Ammonia',
        'SF6'           => 'Sulphur Hexafluoride',
        'C7H8'          => 'Toluene',
        'H2O2'          => 'Hydrogen Peroxide',
        'C2H2'          => 'Acetylene',
        'CH3OH'         => 'Methanol',
        'C7H5N3O6'      => 'Trinitrotoluene',
        'SO4'           => 'Sulphur Dioxide',
        'NaHCO3'        => 'Sodium Bicarbonate',
        'C2H5OH'        => 'Ethanol',
        'CH4'           => 'Methane',
        'C8H18O'        => 'Octanol',
        'C2H6'          => 'Ethane',
        'C15H31N3O13P2' => 'Deoxyribonucleic Acid',
        'C8H10N4O2'     => 'Caffeine',
        'C8H18'         => 'Octane',
        'C6H6'          => 'Benzene',
        'NaCl'          => 'Sodium Chloride',
        'HCl'           => 'Hydrogen Chloride',
        'CaCO3'         => 'Calcium Carbonate',
        'HClO3'         => 'Chloric Acid',
        'HNO3'          => 'Nitric Acid',
        'ClH3O'         => 'Hydrochloric Acid',
        'C6H14O'        => 'Hexanol',
        'C10H8'         => 'Naphthalene',
        'CO2'           => 'Carbon Dioxide',
        'H2O'           => 'Dihydrogen Monoxide',
        'C20H25N3O'     => 'Lysergic Acid Diethylamide',
        'C6H14'         => 'Hexane'
    }
};

sub ptoe_help
{
    println( 'Command Line Interactive Periodic Table of Elements' );
    println();
    println( 'Usage:' );
    println( $0
          . ' [atom]         show details for element by atomic symbol or number'
    );
    println( $0 . ' [compound]     list elements in compound [q]' );
    println();
    println( 'Options:' );
    println( $0 . ' --animate=<n>  scroll through colours, speed is <n>' );
    println( $0 . ' --var=<n>      set colour variation' );
    println( $0 . ' --ind=<n>      set colour start index' );
    println( $0 . ' --label        show period and group labels' );
    println( $0 . ' --compounds    show list of example compounds' );
    println( $0 . ' --key          show colour key' );
    println( $0 . ' --table [q]    show table / highlight elements on table' );
    println( $0 . ' --mono         disable colours' );
    exit;
}

sub load_ptoe
{
# eval { $elements = decode_json( read_file( 'chemical_elements.json' ) ); };
# if ( $@ )
# {
#     println( "data not found, please make sure chemical_elements.json is in your cwd" );
#     die;
# }
# println( Dumper $elements );
    @ptoe_category_examples = ptoe_category_examples();
    @ptoe_colours           = ptoe_colours();
    return;
}

sub ptoe
{
    my ( $conn ) = @_;

    # Elementary, my dear Watson
    my $insanity = ( $elements->{elementbysymbol}->{'U'}->{name} ne 'Uranium' );
    if ( $insanity )
    {
        load_ptoe();
        if ( $insanity )
        {
            return error( "error while loading data" );
        }
    }

    my $query = $conn->{arg};

    if ( $query =~ /([^A-Za-z0-9])/ )
    {
        return error( 'unknown symbol in query: "' . $1 . '"' );
    }

    if ( ( $query =~ /[a-z]{2,}/ ) || ( $query =~ /\d[a-z]/ ) )
    {
        error( 'invalid input' );
        return;
    }

    return ptoe_list_compounds()
      if ( $conn->{options}->{compounds} || $conn->{options}->{list} );

    $conn->{options}->{ind} = 0 if ( $conn->{options}->{ind} < 0 );
    $conn->{options}->{var} = 0 if ( $conn->{options}->{var} < 0 );

    if ( !( $query || $conn->{options}->{table} ) )
    {
        $conn->{options}->{table} = 1;
    }

    ptoe_list_atoms( $query, $conn );
    return;
}

sub ptoe_auto
{
    my ( $conn ) = @_;
    print( "\e[H" );
    print( "\e[0J" );
    print( "\e[?25l" );
    while ( 1 )
    {
        $conn->{options}->{ind}++;
        $conn->{options}->{var}++ if ( $conn->{options}->{ind} > 16 );
        if ( $conn->{options}->{ind} > 1 )
        {
            print( "\e[?25l\e[10A" );
            print( "\e[?25l\e[3A" ) if ( $conn->{options}->{key} );
            print( "\e[?25l\e[1A" ) if ( $conn->{options}->{label} );
        }
        print ptoe_table( $conn ) . "\e[?25h";

        # print $conn->{options}->{ind} . ' ' . $conn->{options}->{var};
        usleep( 500000 / $conn->{options}->{auto} );
        $conn->{options}->{ind} = 1 if ( $conn->{options}->{ind} > 64 );
        $conn->{options}->{var} = 1 if $conn->{options}->{var} > 32;
    }
    return;
}

sub ptoe_parse_input
{
    my ( $query ) = @_;

    # Parse chemical formula, input a string and get an array
    # e.g 'H20' => $VAR1 = [ 'H', '2' ]; $VAR2 = [ 'O', '1' ];

    my @elem;
    while ( $query =~ /([A-Z][a-z]?)([0-9]+)?/g )
    {
        my $element = $1;
        my $many    = $2;
        $many = '1' if !$many;
        push @elem, [ $element, $many ];
    }

    return @elem;
}

sub ptoe_list_atoms
{
    my ( $query, $conn ) = @_;
    chomp $query;
    my @sumoutput;
    $query =~ /(^\d+)/;
    my $gmult = $1;
    $gmult = 1 if !$gmult;

    my @elem = ptoe_parse_input( $query );
    if ( $conn->{options}->{debug} )
    {
        println( Dumper( \@elem ) );
        exit;
    }

    my $higa;
    $higa->{ $_->[0] } = 1 for ( @elem );
    print ptoe_table( $conn, $higa ) if ( $conn->{options}->{table} );
    my $atmol;
    my $totalsum;
    for my $einc ( @elem )
    {
        my $atom = $einc->[0];
        my $many = $einc->[1];
        $atmol += $many;
        my $adetails = $elements->{elementbysymbol}->{$atom};

        if ( !defined $adetails )
        {
            error( 'invalid input' );
            return;
        }

        if ( defined $adetails && !$adetails->{amu} )
        {
            error( "invalid input: $atom" );
            return;
        }

        my $sum = $adetails->{amu} * $many;
        $totalsum += $sum;
        my $hatom = ptoe_highlight_atom( $atom, 1, 1, $conn );
        my $amu   = "$adetails->{amu} amu";
        $amu =
          "$many * $adetails->{amu} amu = " . $adetails->{amu} * $many . ' amu'
          if ( $many > 1 );
        push @sumoutput,
          (     $hatom
              . ( ' ' x ( 12 - length( $adetails->{name} ) ) )
              . "(atomic number $elements->{elementbysymbol}->{ $atom }->{number}) "
              . '['
              . $atom . '] '
              . $amu
              . "\n" );
        if ( ( scalar @elem ) eq 1 )
        {
            my $pg =
                'Period '
              . $adetails->{period}
              . ', group '
              . $adetails->{group} . '.';
            my $fact =
                $pg . ' '
              . $adetails->{category} . ', '
              . $adetails->{phase} . '. '
              . $adetails->{fact} . '.';
            my $spc = ( ' ' x 12 );

            # Word wrap
            $fact =~ s/(.{54}[^\s]*)\s+/$1\n$spc/g;
            push @sumoutput, ( $spc . $fact . "\n" );
        }
    }
    if ( $query )
    {
        if ( ( scalar @elem ) < 1 )
        {
            return error( 'not a valid element' );
        }
        elsif ( ( scalar @elem ) > 1 )
        {
            $query =~ s/(^[^A-Z]+)//g;
            my $k;
            if ( defined $elements->{compounds}->{$query} )
            {
                $k = ' (' . $elements->{compounds}->{$query} . ')';
            }
            println(
                ( ( scalar @elem ) ) . ' elements in compound ' . $query . $k );
            println($atmol * $gmult . ' atom'
                  . ( 's' x ( ( $atmol * $gmult ) > 1 ) )
                  . " in $gmult $query molecule"
                  . ( 's' x ( $gmult > 1 ) ) );
        }
        else
        {
            $query =~ s/(^[^A-Za-z]+)//g;
            $query =~ s/([^A-Za-z]+)$//g;
            println( 'Element: ' . $query );
        }
    }
    delete $conn->{ptoe};
    print @sumoutput;
    if ( $query )
    {
        if ( scalar @elem > 1 )
        {
            my $s = "There are $totalsum grams per mole of $query molecules";
            println( $s );
        }
    }

    # println();
    return;
}

sub ptoe_table
{
    my ( $conn, $hig ) = @_;

    if ( $conn->{options}->{label} )
    {
        my $line;
        for my $g ( 1 .. 18 )
        {
            $line .= ( "\e[2m" . ( ' ' x ( 4 - length( $g ) ) ) . "$g\e[22m" );
        }
        println( $line );
    }
    for my $p ( 1 .. 9 )
    {
        my $line;
        $line .= ( "\e[2m$p\e[22m " ) if ( $conn->{options}->{label} );
        for my $g ( 1 .. 18 )
        {
            my $atomn = ptoe_epg( $p, $g );
            my $a;
            ( !$atomn ) ? $a = '' : $a = $elements->{elementbynumber}->{$atomn};

            $line .= ( ptoe_highlight_atom( $a, 0, $hig->{$a}, $conn ) . ' ' );
        }
        println( $line );
    }
    println();
    return if ( !$conn->{options}->{key} );
    return if ( $conn->{options}->{mono} );

    my $ck = '';
    for my $gy ( 1 .. 12 )
    {
        my $atomn = $ptoe_category_examples[$gy];
        my $b;
        ( !$atomn ) ? $b = '' : $b = $elements->{elementbynumber}->{$atomn};
        $ck .= "  \e[7m" . ptoe_highlight_atom( $b, 0, 1, $conn ) . ' ';
        my $kw = $ptoe_colours[$gy];
        $ck .= $kw . ( ' ' x ( 13 - length( $kw ) ) );
        $ck .= "\r\n" if !( $gy % 4 );
    }
    chomp $ck;
    println( "\e[0J$ck" );
    println() if ( $conn->{arg} );
    return;
}

sub ptoe_highlight_atom
{
    my ( $asym, $full, $hig, $conn ) = @_;
    my $inv;
    $inv = ( "\e[7m" ) if ( $hig );

    if ( $conn->{options}->{mono} )
    {
        return $elements->{elementbysymbol}->{$asym}->{name} if ( $full );
        return "$inv$asym" . ( ' ' x ( 3 - length( $asym ) ) ) . "\e[m"
          if ( $hig );
        return $asym . ( ' ' x ( 3 - length( $asym ) ) );
    }
    return $asym if ( $conn->{options}->{mono} );
    my $c    = $elements->{elementbysymbol}->{$asym}->{colour};
    my $anam = $elements->{elementbysymbol}->{$asym}->{name};
    my $var  = int( $conn->{options}->{var} );
    my $ind  = int( $conn->{options}->{ind} );
    $c += $ind;
    $var = 1   if ( !defined $conn->{options}->{var} );
    $c *= $var if ( $var );
    $c = $ind  if ( defined $var && !$var );

    return "\e[38;5;$c" . "m$anam\e[m" if ( $full );
    return
        "$inv\e[38;5;$c"
      . "m$asym"
      . ( ' ' x ( 3 - length( $asym ) ) ) . "\e[m";

    # return "\e[38;5;$c"."m$asym\e[m";
}

sub ptoe_epg
{
    # Element by Period and Group
    # Returns atomic number
    my ( $p, $g ) = @_;

    for my $e ( keys %{ $elements->{elementbysymbol} } )
    {
        my $anum   = $elements->{elementbysymbol}->{$e}->{number};
        my $period = $elements->{elementbysymbol}->{$e}->{period};
        my $group  = $elements->{elementbysymbol}->{$e}->{group};
        return $anum if ( $p == $period && $g == $group );
    }
    return;
}

sub ptoe_list_compounds
{
    my ( $conn ) = @_;
    my @out;
    my $longest;
    for my $k ( keys %{ $elements->{compounds} } )
    {
        $longest = length( $k ) if ( length( $k ) > $longest );
    }
    println(
        'Formula' . ( ' ' x ( ( $longest + 2 ) - 7 ) ) . 'Name of compound' );
    println(
        '-------' . ( ' ' x ( ( $longest + 2 ) - 7 ) ) . '----------------' );
    for my $k ( sort keys %{ $elements->{compounds} } )
    {
        println($k
              . ( ' ' x ( ( $longest + 2 ) - ( length( $k ) ) ) )
              . $elements->{compounds}->{$k} );
    }
    return;
}

sub ptoe_category_examples
{
    # Example elements in colour categories
    my @p;
    my $i;
    for (
        'H',  'He', 'F',  'O',  'N',  'C',  'B',
        'Zn', 'Be', 'Li', 'La', 'Ac', 'La', 'Ac'
      )
    {
        $p[ $i++ ] = $elements->{elementbysymbol}->{$_}->{number};
    }
    return @p;
}

sub ptoe_colours
{
    my @c;

    # Colour categories
    my $i;
    $c[ $i++ ] = $_
      for (
        "Hydrogen",
        "G 18",
        "G 17",
        "G 16",
        "G 15",
        "G 14",
        "G 13",
        "G 3-12",
        "G 2",
        "G 1-H",
        "Lanthanides",
        "Actinides"
      );
    return @c;
}

sub version_and_author
{
    return
        "This is $0 version "
      . $ptoe_version
      . " by underwood\@telehack.com";
}

sub ptoe_usage
{
    my ( $conn ) = @_;
    my $u = "usage: $0 \[element|compound\] (case sensitive) "
      . "'$0 --help' for full details";
    return $u;
}

sub println
{
    my ( $s ) = @_;
    print( "$s\n" );
    return;
}

sub error
{
    my ( $s ) = @_;
    print( "\e[31m\%$s\e[m\n" );
    println( ptoe_usage() );
    exit;
}

sub read_file
{
    my ( $fname, $warn ) = @_;

    my $s;
    my $fd;

    # return if !open( $fd, '<', $fname );
    if ( !open( $fd, '<', $fname ) )
    {
        warn "can't read $fname: $!" if $warn;
        return;
    }

    my $len = ( stat( $fd ) )[7];
    my $got = sysread( $fd, $s, $len );
    if ( $got ne $len )
    {
        warn "read_file $fname: error got=$got len=$len: $!";
        undef $s;
    }
    close( $fd );

    Encode::_utf8_off( $s );
    return $s;
}

sub do_ptoe
{
    my $conn;

    my $help;
    my $version;
    my $var;
    my $ind;
    my $key;
    my $label;
    my $mono;
    my $auto;
    my $debug;
    my $table;
    my $comp;

    GetOptions(
        "var=i"     => \$var,        # numeric
        "ind=i"     => \$ind,        # numeric
        "key"       => \$key,        # flag
        "label"     => \$label,      # flag
        "mono"      => \$mono,       # flag
        "auto=i"    => \$auto,       # numeric
        "animate=i" => \$auto,       # numeric
        "table"     => \$table,      # flag
        "debug"     => \$debug,      # flag
        "help"      => \$help,       # flag
        "version"   => \$version,    # flag
        "v"         => \$version,    # flag
        "compounds" => \$comp,       # flag
    ) or error( 'Error in command line arguments' );

    $conn->{options}->{var}       = $var;
    $conn->{options}->{ind}       = $ind;
    $conn->{options}->{key}       = $key;
    $conn->{options}->{label}     = $label;
    $conn->{options}->{mono}      = $mono;
    $conn->{options}->{auto}      = $auto;
    $conn->{options}->{table}     = $table;
    $conn->{options}->{debug}     = $debug;
    $conn->{options}->{help}      = $help;
    $conn->{options}->{version}   = $version;
    $conn->{options}->{compounds} = $comp;

    if ( $help )
    {
        println( version_and_author() );
        ptoe_help();
        exit;
    }
    if ( $version )
    {
        println( version_and_author() );
        exit;
    }
    if ( $auto )
    {
        return ptoe_auto( $conn );
    }

    my $formula = $ARGV[0];
    chomp $formula;
    if ( !$formula && !$table && !$comp )
    {
        $formula = <STDIN>;
    }
    chomp $formula;
    if ( $formula =~ /^[0-9]+$/ )
    {
        if ( $elements->{elementbynumber}->{$formula} )
        {
            $formula = $elements->{elementbynumber}->{$formula};
        }
        else
        {
            error( 'invalid input' );
            exit;
        }
    }
    $conn->{arg} = $formula;
    ptoe( $conn );
    return;
}

sub repaint_cursor
{
    $SIG{INT} = \&repaint_cursor;
    print( "\e[0J" );
    print( "\e[H" );
    print( "\e[?25h" );
    exit;
}

$SIG{INT} = \&repaint_cursor;

load_ptoe();
do_ptoe();

1;
