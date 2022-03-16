///usr/bin/env true; exec /usr/bin/env go run "$0" "$@"
package main

import (
    "encoding/csv"
    "encoding/json"
    "flag"
    "fmt"
    "io"
    "log"
    "os"
    "sort"
    "regexp"
    "strconv"
    "strings"
    "time"
)

func readCsvFile(filePath string) [][]string {
    f, err := os.Open(filePath)

    if err != nil {
        log.Fatal("Unable to read input file " + filePath, err)
    }

    defer f.Close()

    csvReader := csv.NewReader(f)
    records, err := csvReader.ReadAll()

    if err != nil {
        log.Fatal("Unable to parse file as CSV for " + filePath, err)
    }

    return records
}

func get_elements_arrays() ([10][19][]string,map[string][]string) {
    f, err := os.Open("../elements.csv")

    if err != nil {
        log.Fatal(err)
    }

    // remember to close the file at the end of the program
    defer f.Close()

    // make new slice for all elements by symbol
    var elements_by_sym = map[string][]string{}

    // make new slice for all elements by period and group
    var elements_by_pgn [10][19] []string

    // read csv values using csv.Reader
    csvReader := csv.NewReader(f)

    for {
        rec, err := csvReader.Read()

        if err == io.EOF {
            break
        }

        if err != nil {
            log.Fatal(err)
        }

        // 0:  symbol
        // 1:  category
        // 2:  number
        // 3:  group
        // 4:  amu
        // 5:  fact
        // 6:  period
        // 7:  phase
        // 8:  name
        // 9:  colour

        // Maybe make a type for this

        symbol := rec[0]
        group  := rec[3]
        period := rec[6]

        pn, _ := strconv.Atoi(period)
        gn, _ := strconv.Atoi(group)

        elements_by_pgn[pn][gn] = rec
        elements_by_sym[symbol] = rec
    }
    return elements_by_pgn, elements_by_sym
}

func contains(s []string, str string) bool {
    for _, v := range s {
        if v == str {
            return true
        }
    }

    return false
}

func ptoe(elements_by_pgn [10][19][]string, elements_by_sym map[string][]string, highlighted_elements []string, mono bool, label bool, showkey bool, variation int, ind int) string {
    o := "  "
    if label {
        for group := 1; group < 19; group++ {
            o += fmt.Sprint(group) + strings.Repeat(" ", (4-len(fmt.Sprint(group))))
        }
    }

    for period := 1; period < 10; period++ {
        inv := "\033[7m"
        o += "\r\n"

        if label { o += fmt.Sprint(period) + " " }

        for group := 1; group < 19; group++ {
            if len(elements_by_pgn[period][group]) > 0 {
                symbol := elements_by_pgn[period][group][0]
                colour := get_colour(elements_by_pgn[period][group], mono, false, variation, ind)

                c := ""
                c += colour + symbol + " \033[m"
                c += strings.Repeat(" ", (3-len(symbol)))

                if contains(highlighted_elements, symbol) {
                    c = inv + c
                }

                o += c
            } else {
                o += "    "
            }
        }
    }

    o += "\n"

    if showkey {
        o += ptoe_colour_key(elements_by_sym, mono, variation, ind)
        o += "\r\n"
    }

    o += "\n"

    return o
}

func ptoe_colour_key(ebs map[string][]string, mono bool, variation int, ind int) string {
    lines := 0

    o := ""

    examples := [][]string{
        {"H", "Hydrogen"},
        {"He", "G 18"},
        {"F", "G 17"},
        {"O", "G 16"},
        {"N", "G 15"},
        {"C", "G 14"},
        {"B", "G 13"},
        {"Zn", "G 3-12"},
        {"Be", "G 2"},
        {"Li", "G 1-H"},
        {"La", "Lanthanides"},
        {"Ac", "Actinides"}}

    for _, ex := range examples {
        if (lines % 4) == 0 { o += "\r\n  " }

        o += get_colour(ebs[ex[0]], mono, true, variation, ind)

        spc := strings.Repeat(" ", 2 - len(ex[0]))
        o += fmt.Sprintf("%+v %+v\033[m %+v", ex[0], spc, ex[1])
        o += strings.Repeat(" ", 14 - len(ex[1]))

        lines++
    }
    return o
}

func parse_ptoe_formula(query string) ([]string, [][]string) {
    var elem []string
    var formula [][]string

    re1 := regexp.MustCompile(`([A-Z][a-z]?)([0-9]+)?`)
    matches := re1.FindAllString(query, -1)

    for _, s := range matches {
        re2 := regexp.MustCompile(`^[^0-9]+`)
        re3 := regexp.MustCompile(`[0-9]+$`)

        syma := re2.FindAllString(s, -1)
        sym := syma[0]

        manya := re3.FindAllString(s, -1)
        many := "1"

        if len(manya) > 0 { many = manya[0] }

        elem = append(elem, sym)
        sm := []string{sym, many}

        formula = append(formula, sm)
    }
    return elem, formula
}

func get_colour(adetails []string, mono bool, bg bool, variation int, ind int) string {
    inv := ""
    colour, _ := strconv.Atoi(adetails[9])

    if variation > 0 { colour *= int(variation) }

    if ind > 0 { colour += int(ind) }

    if bg {
        inv = "\033[7m"
    }

    return fmt.Sprintf("%+v\033[38;5;%+vm", inv, colour)
}

func get_sumoutput(formula [][]string, ebs map[string][]string, mono bool, variation int, ind int) ([]string, float32, float32) {
    var sumoutput []string

    atmol := float32(0)
    totalsum := float32(0)

    for _, einc := range formula {
        atom := einc[0]
        many64, _ := strconv.ParseFloat(einc[1], 32)
        many := float32(many64)
        atmol += many
        adetails := ebs[atom]

        sum64, _ := strconv.ParseFloat(adetails[4], 32)
        sum := float32(sum64) * many
        totalsum += float32(sum)
        colour := ""

        if ! mono { colour = get_colour(adetails, mono, false, variation, ind) }

        amu := fmt.Sprintf("%+v amu", adetails[4])

        if many > 1 {
            amu = fmt.Sprintf("%+v * %+v amu = ", many, adetails[4] )
            amu64, _ := strconv.ParseFloat(adetails[4], 32)
            amu32 := float32(amu64)
            amu += fmt.Sprintf("%+v amu",amu32 * many)
        }

        sumoutput = append(
            sumoutput,
            colour +
            adetails[8] + "\033[m" +
            strings.Repeat(" ", 12 - len(adetails[8])) +
            fmt.Sprintf("(atomic number %+v) ", adetails[2]) +
            fmt.Sprintf("[%+v] %+v", atom, amu) )

        if len(formula) == 1 {
            a := adetails
            pg := fmt.Sprintf("Period %+v, group %+v.", a[6], a[3])
            fact := fmt.Sprintf("%+v %+v, %+v.\r\n%+v.", pg, a[1], a[7], a[5])
            spc := strings.Repeat(" ", 12)
            sumoutput = append(sumoutput, spc + fact)
        }
    }

    return sumoutput, atmol, totalsum
}

func bool_to_int8(bitSet bool) int8 {
	var bitSetVar int8
	if bitSet {
		bitSetVar = 1
	}

	return bitSetVar
}

func get_compounds() (map[string]string, int) {
    compounds := map[string]string{}

    compounds["C21H30O2"] = "Tetrahydrocannabinol"
    compounds["H2SO4"] = "Sulphuric Acid"
    compounds["NH3"] = "Ammonia"
    compounds["SF6"] = "Sulphur Hexafluoride"
    compounds["C7H8"] = "Toluene"
    compounds["H2O2"] = "Hydrogen Peroxide"
    compounds["C2H2"] = "Acetylene"
    compounds["CH3OH"] = "Methanol"
    compounds["C7H5N3O6"] = "Trinitrotoluene"
    compounds["SO4"] = "Sulphur Dioxide"
    compounds["NaHCO3"] = "Sodium Bicarbonate"
    compounds["C2H5OH"] = "Ethanol"
    compounds["CH4"] = "Methane"
    compounds["C8H18O"] = "Octanol"
    compounds["C2H6"] = "Ethane"
    compounds["C15H31N3O13P2"] = "Deoxyribonucleic Acid"
    compounds["C8H10N4O2"] = "Caffeine"
    compounds["C8H18"] = "Octane"
    compounds["C6H6"] = "Benzene"
    compounds["NaCl"] = "Sodium Chloride"
    compounds["HCl"] = "Hydrogen Chloride"
    compounds["CaCO3"] = "Calcium Carbonate"
    compounds["HClO3"] = "Chloric Acid"
    compounds["HNO3"] = "Nitric Acid"
    compounds["ClH3O"] = "Hydrochloric Acid"
    compounds["C6H14O"] = "Hexanol"
    compounds["C10H8"] = "Naphthalene"
    compounds["CO2"] = "Carbon Dioxide"
    compounds["H2O"] = "Dihydrogen Monoxide"
    compounds["C20H25N3O"] = "Lysergic Acid Diethylamide"
    compounds["C6H14"] = "Hexane"

    longest := 1

    for k := range compounds {
        if len(k) > longest { longest = len(k) }
    }

    return compounds, longest
}

func atmolcalc(query string, gmult int, formula [][]string, elements_by_sym map[string][]string, mono bool, variation int, ind int) string {
    sumoutput, atmol, totalsum := get_sumoutput(formula, elements_by_sym, mono, variation, ind)
    compounds, _ := get_compounds()

    o := ""

    if query != "" {
        if len(formula) < 1 {
            fmt.Println("%not a valid element")
            os.Exit(1)
        } else if len(formula) > 1 {
            var re = regexp.MustCompile(`(^[^A-Z]+)`)

            query = re.ReplaceAllString(query, ``)
            k := ""

            if compounds[query] != "" { k += " (" + compounds[query] + ")" }

            o += fmt.Sprintf("%+v elements in compound %+v\r\n", len(formula), query+k)
            plural1 := bool_to_int8((atmol * float32(gmult)) > 1)
            plural2 := bool_to_int8(gmult > 1)

            o += fmt.Sprintf(
                "%+v atom%+v in %+v %+v molecule%+v",
                atmol * float32(gmult),
                strings.Repeat("s", int(plural1)),
                gmult,
                query,
                strings.Repeat("s", int(plural2)))
        } else {
            var re1 = regexp.MustCompile(`(^[^A-Za-z]+)`)
            var re2 = regexp.MustCompile(`([^A-Za-z]+)$`)

            query = re1.ReplaceAllString(query, ``)
            query = re2.ReplaceAllString(query, ``)

            o += fmt.Sprintf("Element: %+v", query)
        }

        o += "\r\n"

        for _, line := range sumoutput {
            o += fmt.Sprintln(line)
        }
    }

    if query != "" {
        if len(formula) > 1 {
            o += fmt.Sprintf("There are %+v grams per mole of %+v molecules", totalsum, query)
        }
    }

    return o
}

func do_cliptoe(variation int, ind int, label bool, key bool, jsonmode bool, debug bool, table bool, mono bool) string {

    out := ""
    elements_by_pgn, elements_by_sym := get_elements_arrays()

    var query string = ""
    if len(flag.Args()) > 0 { query = flag.Args()[0] }

    gmult := 1
    re1 := regexp.MustCompile(`(^\\d+)`)
    gmresult := re1.FindAllString(query, -1)

    if len(gmresult) > 0 { gmult, _ = strconv.Atoi(gmresult[0]) }

    elem, formula := parse_ptoe_formula(query)

    if (table || label) && ! debug && ! jsonmode {
        out += fmt.Sprintf(ptoe(elements_by_pgn, elements_by_sym, elem, mono, label, key, variation, ind))
    }

    if debug {
        out += fmt.Sprintln(formula)
        return out
    } else if jsonmode {
        pBytes, _ := json.MarshalIndent(formula, "", "    ")
        out += fmt.Sprintln(string(pBytes))
        return out
    }

    out += fmt.Sprintln(atmolcalc(query, gmult, formula, elements_by_sym, mono, variation, ind))

    return out
}

func sortmap(m map[string]string) ([]string) {
    keys := make([]string, 0, len(m))

    for k := range m {
	    keys = append(keys, k)
    }

    sort.Strings(keys)

    return keys
}

func list_compounds() string {
    o := ""
    c, l := get_compounds()
    pad := 4

    o += fmt.Sprintf("%+v %+v%+v", "Formula", strings.Repeat(" ", pad + l - 7), "Common Name\r\n")
    o += fmt.Sprintf("%+v %+v%+v", "-------", strings.Repeat(" ", pad + l - 7), "-----------\r\n")

    for _, v := range sortmap(c) {
        o += fmt.Sprintf("%+v %+v%+v\r\n", v, strings.Repeat(" ", pad + l - len(v)), c[v])
    }

    return o
}

func sleep(d float32) {
    time.Sleep(time.Duration(d) * time.Second)
}

func main() {

    animatePtr := flag.Float64("animate", 0, "animate")
    variationPtr := flag.Int("variation", 2, "colour variation")
    indPtr := flag.Int("ind", 0, "colour index")
    labelPtr := flag.Bool("label", false, "period and group labels")
    compoundsPtr := flag.Bool("compounds", false, "list compounds")
    keyPtr := flag.Bool("key", false, "colour key")
    JSONPtr := flag.Bool("json", false, "JSON output")
    debugPtr := flag.Bool("debug", false, "debug output")
    tablePtr := flag.Bool("table", false, "show table")
    monoPtr := flag.Bool("mono", false, "disable colours")

    flag.Parse()

    if *compoundsPtr {
        fmt.Print(list_compounds())
        os.Exit(0)
    }

    if len(flag.Args()) == 0 { *tablePtr = true }

    if *animatePtr > 0 {

        if *animatePtr < 1 {
            *animatePtr = 1
        }

        fmt.Printf("\033[H\033[0J")
        ind := *indPtr

        for {
            fmt.Printf("\033[H")
            fmt.Printf(do_cliptoe(*variationPtr, ind, *labelPtr, *keyPtr, *JSONPtr, *debugPtr, *tablePtr, *monoPtr))
            ind++
            sleep(float32(*animatePtr))
        }
    }

    fmt.Printf(do_cliptoe(*variationPtr, *indPtr, *labelPtr, *keyPtr, *JSONPtr, *debugPtr, *tablePtr, *monoPtr))
}
