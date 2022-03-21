
    ' PTOE - by underwood,
    '               searinox,
    '                     and devon - December 2021

    ' https://www.youtube.com/watch?v=wlOdUATGuQY

    ' "There is no standard set of colors used to identify element groups or other properties.
    ' Colors are selected based on how well the text shows up against them, but mostly it's a
    ' matter of personal preference." https://www.thoughtco.com/color-on-the-periodic-table-608827

    v = 6.022 : ' plus change.... 1.8 worldwide acid example update

    ' H                                                                   He
    ' Li  Be                                          B   C   N   O   F   Ne
    ' Na  Mg                                          Al  Si  P   S   Cl  Ar
    ' K   Ca  Sc  Ti  V   Cr  Mn  Fe  Co  Ni  Cu  Zn  Ga  Ge  As  Se  Br  Kr
    ' Rb  Sr  Y   Zr  Nb  Mo  Tc  Ru  Rh  Pd  Ag  Cd  In  Sn  Sb  Te  I   Xe
    ' Cs  Ba  La  Hf  Ta  W   Re  Os  Ir  Pt  Au  Hg  Tl  Pb  Bi  Po  At  Rn
    ' Fr  Ra  Ac  Rf  Db  Sg  Bh  Hs  Mt  Ds  Rg  Cn  Nh  Fl  Mc  Lv  Ts  Og
    '         Ce  Pr  Nd  Pm  Sm  Eu  Gd  Tb  Dy  Ho  Er  Tm  Yb  Lu
    '         Th  Pa  U   Np  Pu  Am  Cm  Bk  Cf  Es  Fm  Md  No  Lr

    ? chr$(27) "[?25l" ; : ' hide cursor

    '    num , sym, nam           , mu      , pe, gr , c
    data 1   , H  , Hydrogen      , 1.007   , 1 , 1  , 1
    data 2   , He , Helium        , 4.002   , 1 , 18 , 2
    data 3   , Li , Lithium       , 6.941   , 2 , 1  , 11
    data 4   , Be , Beryllium     , 9.012   , 2 , 2  , 10
    data 5   , B  , Boron         , 10.811  , 2 , 13 , 0
    data 6   , C  , Carbon        , 12.011  , 2 , 14 , 6
    data 7   , N  , Nitrogen      , 14.007  , 2 , 15 , 5
    data 8   , O  , Oxygen        , 15.999  , 2 , 16 , 4
    data 9   , F  , Fluorine      , 18.998  , 2 , 17 , 3
    data 10  , Ne , Neon          , 20.18   , 2 , 18 , 2
    data 11  , Na , Sodium        , 22.99   , 3 , 1  , 11
    data 12  , Mg , Magnesium     , 24.305  , 3 , 2  , 10
    data 13  , Al , Aluminium     , 26.982  , 3 , 13 , 0
    data 14  , Si , Silicone      , 28.086  , 3 , 14 , 6
    data 15  , P  , Phosphorus    , 30.974  , 3 , 15 , 5
    data 16  , S  , Sulfur        , 32.065  , 3 , 16 , 4
    data 17  , Cl , Chlorine      , 35.453  , 3 , 17 , 3
    data 18  , Ar , Argon         , 39.948  , 3 , 18 , 2
    data 19  , K  , Potassium     , 39.098  , 4 , 1  , 11
    data 20  , Ca , Calcium       , 40.078  , 4 , 2  , 10
    data 21  , Sc , Scandium      , 44.956  , 4 , 3  , 7
    data 22  , Ti , Titanium      , 47.867  , 4 , 4  , 7
    data 23  , V  , Vanadium      , 50.942  , 4 , 5  , 7
    data 24  , Cr , Chromium      , 51.996  , 4 , 6  , 7
    data 25  , Mn , Manganese     , 54.938  , 4 , 7  , 7
    data 26  , Fe , Iron          , 55.845  , 4 , 8  , 7
    data 27  , Co , Cobalt        , 58.933  , 4 , 9  , 7
    data 28  , Ni , Nickel        , 58.693  , 4 , 10 , 7
    data 29  , Cu , Copper        , 63.546  , 4 , 11 , 7
    data 30  , Zn , Zinc          , 65.38   , 4 , 12 , 7
    data 31  , Ga , Gallium       , 69.723  , 4 , 13 , 0
    data 32  , Ge , Germanium     , 72.64   , 4 , 14 , 6
    data 33  , As , Arsenic       , 74.922  , 4 , 15 , 5
    data 34  , Se , Selenium      , 78.96   , 4 , 16 , 4
    data 35  , Br , Bromine       , 79.904  , 4 , 17 , 3
    data 36  , Kr , Krypton       , 83.798  , 4 , 18 , 2
    data 37  , Rb , Rubidium      , 85.468  , 5 , 1  , 11
    data 38  , Sr , Strontium     , 87.62   , 5 , 2  , 10
    data 39  , Y  , Yttrium       , 88.906  , 5 , 3  , 7
    data 40  , Zr , Zirconium     , 91.224  , 5 , 4  , 7
    data 41  , Nb , Niobium       , 92.906  , 5 , 5  , 7
    data 42  , Mo , Molybdenum    , 95.96   , 5 , 6  , 7
    data 43  , Tc , Technetium    , 98      , 5 , 7  , 7
    data 44  , Ru , Ruthenium     , 101.07  , 5 , 8  , 7
    data 45  , Rh , Rhodium       , 102.906 , 5 , 9  , 7
    data 46  , Pd , Palladium     , 106.42  , 5 , 10 , 7
    data 47  , Ag , Silver        , 107.868 , 5 , 11 , 7
    data 48  , Cd , Cadmium       , 112.411 , 5 , 12 , 7
    data 49  , In , Indium        , 114.818 , 5 , 13 , 0
    data 50  , Sn , Tin           , 118.71  , 5 , 14 , 6
    data 51  , Sb , Antimony      , 121.76  , 5 , 15 , 5
    data 52  , Te , Tellurium     , 127.6   , 5 , 16 , 4
    data 53  , I  , Iodine        , 126.904 , 5 , 17 , 3
    data 54  , Xe , Xenon         , 131.293 , 5 , 18 , 2
    data 55  , Cs , Caesium       , 132.905 , 6 , 1  , 11
    data 56  , Ba , Barium        , 137.327 , 6 , 2  , 10
    data 57  , La , Lanthanum     , 138.905 , 6 , 3  , 12
                                                     : '12 was 8
    data 58  , Ce , Cerium        , 140.116 , 8 , 3  , 12
    data 59  , Pr , Praseodymium  , 140.908 , 8 , 4  , 12
    data 60  , Nd , Neodymium     , 144.242 , 8 , 5  , 12
    data 61  , Pm , Promethium    , 145     , 8 , 6  , 12
    data 62  , Sm , Samarium      , 150.36  , 8 , 7  , 12
    data 63  , Eu , Europium      , 151.964 , 8 , 8  , 12
    data 64  , Gd , Gadolinium    , 157.25  , 8 , 9  , 12
    data 65  , Tb , Terbium       , 158.925 , 8 , 10 , 12
    data 66  , Dy , Dysprosium    , 162.5   , 8 , 11 , 12
    data 67  , Ho , Holmium       , 164.93  , 8 , 12 , 12
    data 68  , Er , Erbium        , 167.259 , 8 , 13 , 12
    data 69  , Tm , Thulium       , 168.934 , 8 , 14 , 12
    data 70  , Yb , Ytterbium     , 173.054 , 8 , 15 , 12
    data 71  , Lu , Lutetium      , 174.967 , 8 , 16 , 12
    data 72  , Hf , Hafnium       , 178.49  , 6 , 4  , 7
    data 73  , Ta , Tantalum      , 180.948 , 6 , 5  , 7
    data 74  , W  , Tungsten      , 183.84  , 6 , 6  , 7
    data 75  , Re , Rhenium       , 186.207 , 6 , 7  , 7
    data 76  , Os , Osmium        , 190.23  , 6 , 8  , 7
    data 77  , Ir , Iridium       , 192.217 , 6 , 9  , 7
    data 78  , Pt , Platinum      , 195.084 , 6 , 10 , 7
    data 79  , Au , Gold          , 196.967 , 6 , 11 , 7
    data 80  , Hg , Mercury       , 200.59  , 6 , 12 , 7
    data 81  , Tl , Thallium      , 204.383 , 6 , 13 , 0
    data 82  , Pb , Lead          , 207.2   , 6 , 14 , 6
    data 83  , Bi , Bismuth       , 208.98  , 6 , 15 , 5
    data 84  , Po , Polonium      , 210     , 6 , 16 , 4
    data 85  , At , Astatine      , 210     , 6 , 17 , 3
    data 86  , Rn , Radon         , 222     , 6 , 18 , 2
    data 87  , Fr , Francium      , 223     , 7 , 1  , 11
    data 88  , Ra , Radium        , 226     , 7 , 2  , 10
    data 89  , Ac , Actinium      , 227     , 7 , 3  , 13
                                                     :'13 was 9
    data 90  , Th , Thorium       , 232.038 , 9 , 3  , 13
    data 91  , Pa , Protactinium  , 231.036 , 9 , 4  , 13
    data 92  , U  , Uranium       , 238.029 , 9 , 5  , 13
    data 93  , Np , Neptunium     , 237     , 9 , 6  , 13
    data 94  , Pu , Plutonium     , 244     , 9 , 7  , 13
    data 95  , Am , Americium     , 243     , 9 , 8  , 13
    data 96  , Cm , Curium        , 247     , 9 , 9  , 13
    data 97  , Bk , Berkelium     , 247     , 9 , 10 , 13
    data 98  , Cf , Californium   , 251     , 9 , 11 , 13
    data 99  , Es , Einsteinium   , 252     , 9 , 12 , 13
    data 100 , Fm , Fermium       , 257     , 9 , 13 , 13
    data 101 , Md , Mendelevium   , 258     , 9 , 14 , 13
    data 102 , No , Nobelium      , 259     , 9 , 15 , 13
    data 103 , Lr , Lawrencium    , 262     , 9 , 16 , 13
    data 104 , Rf , Rutherfordium , 261     , 7 , 4  , 7
    data 105 , Db , Dubnium       , 262     , 7 , 5  , 7
    data 106 , Sg , Seaborgium    , 266     , 7 , 6  , 7
    data 107 , Bh , Bohrium       , 264     , 7 , 7  , 7
    data 108 , Hs , Hassium       , 267     , 7 , 8  , 7
    data 109 , Mt , Meitnerium    , 268     , 7 , 9  , 7
    data 110 , Ds , Darmstadtium  , 271     , 7 , 10 , 7
    data 111 , Rg , Roentgenium   , 272     , 7 , 11 , 7
    data 112 , Cn , Copernicium   , 285     , 7 , 12 , 7
    data 113 , Nh , Nihonium      , 284     , 7 , 13 , 0
    data 114 , Fl , Flerovium     , 289     , 7 , 14 , 6
    data 115 , Mc , Moscovium     , 288     , 7 , 15 , 5
    data 116 , Lv , Livermorium   , 292     , 7 , 16 , 4
    data 117 , Ts , Tennessine    , 295     , 7 , 17 , 3
    data 118 , Og , Oganesson     , 294     , 7 , 18 , 2
    '    num , sym, nam           , mu      , pe, gr , c
    for i = 1 to 118
        read anum, sym$
        asym$(anum) = sym$
        anum(sym$) = anum
        read anam$(sym$), amu(sym$)
        read period, group, f(anum)
        p( period, group ) = anum ' The P T of E, yeah?
    next i

    ' ... Hey, that's ...

    data NH3           , Ammonia
    data C2H6          , Ethane
    data CH4           , Methane
    data C6H6          , Benzene
    data C6H14         , Hexane
    data C8H18         , Octane
    data C2H5OH        , Ethanol
    data CH3OH         , Methanol
    data C6H14O        , Hexanol
    data C8H18O        , Octanol
    data H2O           , Dihydrogen Monoxide
    data H2SO4         , Sulfuric Acid
    data H2O2          , Hydrogen Peroxide
    data CO2           , Carbon Dioxide
    data SO4           , Sulfur Dioxide
    data SF6           , Sulfur Hexafluoride
    data NaCl          , Sodium Chloride
    data CaCO3         , Calcium Carbonate
    data NaHCO3        , Sodium Bicarbonate
    data C15H31N3O13P2 , Deoxyribonucleic Acid
    data C21H30O2      , Tetrahydrocannabinol
    data C7H5N3O6      , Trinitrotoluene
    data C8H10N4O2     , Caffeine
    data C2H2          , Acetylene
    data C10H8         , Naphthalene
    data C7H8          , Toluene
    data ClH3O         , Hydrochloric Acid
    data HCl           , Hydrogen Chloride
    data HNO3          , Nitric Acid
    data HClO3         , Chloric Acid
    data C20H25N3O     , Lysergic Acid Diethylamide
    excompoundlen = 31
    for i = 1 to excompoundlen : read excompound$(i), cnam$(excompound$(i)) : next i

    colourname$(1)  = "Hydrogen"
    colourname$(2)  = "G 18"
    colourname$(3)  = "G 17"
    colourname$(4)  = "G 16"
    colourname$(5)  = "G 15"
    colourname$(6)  = "G 14"
    colourname$(7)  = "G 13"
    colourname$(8)  = "G 3-12"
    colourname$(9)  = "G 2"
    colourname$(10) = "G 1-H"
    colourname$(11) = "Lanthanides"
    colourname$(12) = "Actinides"
''    colourname$(11) = "Lanthanum"
''    colourname$(12) = "Actinium"
''    colourname$(13) = "Lanthanides"
''    colourname$(14) = "Actinides"

    cheat = ( th_re( ups$( arg$ ), "CHEAT" ) )
    hue = 8 : dev = 32
    def fnc$(n) = str$((hue+f(n)+dev)mod 255)
    def fnhigbygroup$(s$,n)=string$( not mono, chr$(27)+"[38;5;"+str$(int(hue+(f(n)*dev)mod 255))+"m" )+s$+chr$(27)+"[m"
    def fnpitem$(n) = fnhigbygroup$( asym$(n)+spc$(2-len(asym$(n)))+" ", f(n) ) + " "
    def fnfullpitem$(n) = fnhigbygroup$( anam$(asym$(n)), f(n) ) + " "
    elpat$ = "[A-Z][a-z]?"
    pgkey = 1

    ' Avocado's Constant
    ' 6.02214076 * 10^23
    'let avo = 6.0221e+23 ....... nah.
    'let avo = 6.02214e23 ....... nope.
    let avo = 6.02214076e23 : '.. bingo!

    cls

    if ( arg$="colour" ) or ( arg$="color" ) or ( arg$="c" ) then comode = 1 goto 80
    if ( arg$="dump" ) or ( arg$="d" ) then goto 100

1   compound$ = "" : gosub 50

    ? chr$(27) "[?25h" ;

    ? "Enter any chemical element or compound, e.g: " excompound$( 1+int( rnd(22) ) )
    input "Compound? " ; compound$ : home : ? chr$(27) "[0J" ; : gosub 10

    ? chr$(27) "[?25l" ;
    cls
    goto 1

10  ' Compound Summary

    compound$ = th_sed$(compound$,"^\s+|\s+$","","g")
    if compound$ = "?" then gosub 110 : return
    if th_re( ups$( compound$ ), "COLO(U)?R" ) then goto 80
    err1$ = "%unknown character(s) in input: "
    err2$ = "%malformed input"
    ill$ = th_re$( compound$, "[^A-Za-z0-9]" )
    if th_re( compound$, "[^A-Za-z0-9]" ) then print err1$ chr$(34) ill$ chr$(34) : k$ = polkey$(3) : return
    if th_re( compound$, "[a-z]{2,}" ) then print err2$ : k$ = polkey$(3) : return
    if th_re( compound$, "\d[a-z]" ) then print err2$ : k$ = polkey$(3) : return

    dcomp = 0
    for df = 1 to nel

    next df

    for i = 1 to th_re( compound$, "[A-Z][a-z]?\d+?", 1 )
        m$ = th_re$( compound$, "[A-Z][a-z]?\d+", i )
        el$ = th_sed$( m$, "\d+", "", "g" )
        mult = val( th_re$( m$, "\d+$" ) )
        mult = mult - 1
        c$( el$ ) = "amu * " + str$( mult + 1 ) + " = "
        c$( el$ ) = c$( el$ ) + str$( amu( el$ ) * ( mult + 1 ) ) + " amu)"
        inc( el$ ) = ( amu( el$ ) * mult )
    next i
    compoundmass = 0
    for i = 1 to th_re( compound$, elpat$, 1 )
        element$ = th_re$( compound$, elpat$, i )
        compoundmass = compoundmass + amu( element$ )
    next i

    if not compoundmass then ? "%please input an element or compound" : failz = 1 : k$ = polkey$(3) : return

    ex = 0
    o$ = ""
    cstr$ = ""
    nel = th_re( compound$, elpat$, 1 )
    for i = 1 to nel
        element$ = th_re$( compound$, elpat$, i )
        cstr$ = cstr$ + element$ + " "
        if not anum( element$ ) then ? "%invalid input" : failz = 1 : k$ = polkey$(3) : return
        n$ = "{atomic number " + str$( anum( element$ ) ) + "}"
        colr$ = fnfullpitem$( anum( element$ ) )
        if c$( element$ ) = "" then c$( element$ ) = "amu * 1 = " + str$( amu( element$ ) ) + " amu)"
        o$ = o$ + " " + str$( i ) + ":"
        o$ = o$ + spc$( 16 - len( anam$( element$ ) ) ) + colr$ + " [" + element$ + "] " + n$ + " ("
        o$ = o$ + str$( amu( element$ ) ) + " " + c$( element$ ) : c$( element$ ) = ""
        'if ( i < nel ) then o$ = o$ + chr$(13) + chr$(10)
        o$ = o$ + chr$(13) + chr$(10)
        ex = ex + inc( element$ )
    next i
    propermass = 0
    for i = 1 to th_re(o$,".+\r\n",1)
        nv = abs( th_sed$( th_re$(o$,"[^\s]+\samu\)\r\n",i), "\s.+\r\n" ) )
        propermass = propermass + nv
    next i

    'number of molecules in 1 gram of compound) = (6.022e23 amu/gram) / (mass in amu of 1 molecule of compound)

    mult2 = 0
    mm = 0
    cnm$ = string$( cnam$(compound$) <> "", " (" + cnam$(compound$) + ")" )
    for o = 1 to th_re( compound$, "[0-9]+", 1 )
        mult2 = mult2 + int( th_re$( compound$, "[0-9]+", o ) )
        mm = mm + 1
    next o

    compoundmass = compoundmass + ex
    atoms = avo / compoundmass * ( nel + mult2 )
    bold$ = chr$(27) + "[1m"
    unbold$ = chr$(27) + "[m"

    gosub 50

    gmult = 1
    if th_re( compound$, "^\d+" ) then gmult = val( th_re$( compound$, "^\d+" ) )

    if ( cnam$(compound$) = "" ) then cnam$(compound$) = anam$(th_sed$(compound$,"[0-9]+"))
    isele = th_re( compound$, "^..?$" )
    cdescr$ = " The compound "+compound$+string$(cnam$(compound$)<>""," ("+cnam$(compound$)+")")+" is comprised of the element(s): "
    if not isele then ? cdescr$
    ? o$
    if not isele then ? " There are " bold$ str$(( nel - (mm*sgn(mult2)) + mult2 ) * gmult) " " unbold$ "atoms in a molecule of " compound$
    ? " There are " bold$ str$( ( propermass ) * gmult ) " " unbold$ "grams per mole of " compound$
    ? " There are " bold$ str$(( avo / propermass * ( nel - (mm*sgn(mult2)) + mult2 ) ) * gmult ) " " unbold$ "atoms in a gram of " compound$
    'atoms = avo / compoundmass * ( nel + mult2 )
    j$=" ( 6.02214076e23 / "+str$(propermass * gmult )+" * "+str$((nel-(mm*sgn(mult2))+mult2)* gmult)+" = "+str$((avo/propermass*(nel-(mm*sgn(mult2))+mult2))*gmult)+" )"
    if cheat then ? bold$ : ? j$
    ? unbold$ ;
    ? chr$(27) "[?25h"
    ? "Press any key to continue ..." ;
    k$ = inkey$
    ? chr$(27) "[?25l"
    return

50  ' ptofe


    ital$ = chr$(27) + "[3m"
    faint$ = chr$(27) + "[2m"
    crst$ = chr$(27) + "[m"
    if not comode then ? chr$(27) "[?25l" ; : ' hide cursor
    if not comode then ? chr$(27) "[1mPTOE" chr$(27) "[m" " v" abs( v ) ital$ faint$ "(Type COLOUR to set colours)" crst$
''    if not comode then ? "A handy reference to the Periodic Table of Elements"
''    if not comode then ? "`RUN " ups$( argv$(0) ) " COLOUR` for an interactive table"
    if not comode then ?
    ptoe$ = " "
    for period = 1 to 9
        for group = 1 to 18
            ppg = p( period, group )
            if asym$(ppg) <> "" and th_re( cstr$, "\b\Q" + asym$( ppg ) + "\E\b" ) then ptoe$ = ptoe$ + chr$(27) + "[7m"
            ptoe$ = ptoe$ + string$( ( ppg > 0 ), fnpitem$( ppg ) ) + string$( not ppg, spc$(4) )
            if asym$(ppg) <> "" and th_re( cstr$, "\b\Q" + asym$( ppg ) + "\E\b" ) then ptoe$ = ptoe$ + chr$(27) + "[27m"
        next group
        ptoe$ = ptoe$ + chr$(13) + chr$(10) + " "
    next period
    ? ptoe$
    cstr$ = ""

    return

80  ' colours thing

    ? chr$(27) "[?25l" ;
    comode = 1
    for q = 1 to -1 step 0
        home
        huexplain$ = "Hit J/K to increment index, H/L to increase variation" + chr$(13) + chr$(10)
        huexplain$ = huexplain$ + "Hit G to hide/show colour key" + chr$(13) + chr$(10)
        huexplain$ = huexplain$ + "Hit M to enable/disable colours " + chr$(27) + "[0K" + string$( cheat, "cheat mode: on" ) + chr$(13) + chr$(10)
        huexplain$ = huexplain$ + "colour index: " + bold$ + str$(hue) + unbold$ + ", colour variation: " + bold$ + str$(dev) + unbold$
        ? huexplain$ ". Hit return to save and continue" chr$(27) "[0K" : ?
        gosub 50
        ? chr$(27) + "[0J" ;
        if pgkey then gosub 90

81      ? chr$(27) "[?25l" ; : k$ = inkey$ : if ( k$ <> chr$(13) ) and not pos( "CcDdGgHhJjKkLlMm", k$ ) then ? chr$(27) "[?25h" ; : goto 81
        'home :
        sleep 0.03
        if k$ = "d" then goto 100
        if k$ = "k" then hue = hue + 1
        if k$ = "j" then hue = hue - 1
        if k$ = "l" then dev = dev + 1
        if k$ = "h" then dev = dev - 1
        if k$ = "g" then pgkey = not pgkey
        if k$ = "m" then mono = not mono
        if k$ = "c" then cheat = not cheat
        if k$ = chr$(13) then cls : ? chr$(27) "[?25h" ; :comode=0: goto 1
        if dev < 0 then dev = 0
        if hue < 0 then hue = 0
    next q
    ? chr$(27) "[?25h" ;
    end

90  ' colour key

    gex(1)  = anum("H")
    gex(2)  = anum("He")
    gex(3)  = anum("F")
    gex(4)  = anum("O")
    gex(5)  = anum("N")
    gex(6)  = anum("C")
    gex(7)  = anum("B")
    gex(8)  = anum("Zn")
    gex(9)  = anum("Be")
    gex(10) = anum("Li")
    gex(11) = anum("La")
    gex(12) = anum("Ac")
''    gex(13) = anum("Ce")
''    gex(14) = anum("Th")
    gex(13) = anum("La")
    gex(14) = anum("Ac")
    ck$ = ""
    for gy = 1 to 12
        ck$ = ck$ + "  " + chr$(27) + "[7m" + fnpitem$( gex(gy) ) + " "
        kw$ = colourname$( gy )
        ck$ = ck$ + kw$ + spc$( 12 - len( kw$ ) )
        if not ( gy mod 4 ) then ck$ = ck$ + chr$(13) + chr$(10) + chr$(13) + chr$(10)
    next gy
    ? ck$
    return

100 ' dump data

    def fnIf$(c%,x$,y$)=mid$(x$,1,(c%<>0)*len(x$))+mid$(y$,1,(c%=0)*len(y$))
    def fnMax(x%,y%)=(x%>=y%)*x%+(x%<y%)*y%
    def fnAt$(s$,i%)=mid$(s$,i%,1)
    def fnPadRight$(c$,l%,p$)=c$+string$(fnMax(l%-len(c$),0),fnIf$(len(p$)>0,fnAt$(p$,1)," "))

    & "         num , sym, nam           , mu      , pe, gr , c"
    for i = 1 to 118
        d$ = "    data "
        d$ = d$ + fnPadRight$( str$( anum( asym$(i) ) ), 3, " " ) + " , "
        d$ = d$ + fnPadRight$( asym$(i), 2, " " ) + " , "
        d$ = d$ + fnPadRight$( anam$( asym$(i) ), 13, " " ) + " , "
        d$ = d$ + fnPadRight$( str$( amu( asym$(i) ) ), 7, " " ) + " , "
        for period = 1 to 9
            for group = 1 to 18
                ppg = p( period, group )
                if ppg = i then d$ = d$ + fnPadRight$( str$( period ), 1, " " ) + " , "
                if ppg = i then d$ = d$ + fnPadRight$( str$( group ), 2, " " ) + " , "
            next group
        next period
        d$ = d$ + fnPadRight$( str$( f(i) ), 1, " " )
        & d$
    next i
    &
    for i = 1 to 1e3 : excompoundlen = fnMax( excompoundlen, len( excompound$(i) ) ) : next i
    for i = 1 to 1e3
        d$ = "    data "
        d$ = d$ + fnPadRight$( excompound$(i), excompoundlen, " " ) + " , "
        d$ = d$ + fnPadRight$( cnam$(excompound$(i)), 1, " " )
        & d$
        if excompound$( i + 1 ) = "" then & "    excompoundlen ="i : i = 1e3
    next i
    end

110 '   Examples
    ? "Formula        Name"
    ? "-------        ----"
    k$ = ""
    for dx = 1 to excompoundlen
        ? excompound$(dx), cnam$(excompound$(dx))
111     if dx >= height - 3 then ? "--More--" ; : k$ = inkey$ : ? chr$(13) "" ; : if k$ = chr$(27) then goto 111
        if k$ = "q" then dx = excompoundlen
    next dx
    if ( k$ <> "q" ) and dx < excompoundlen then k$ = inkey$
    return
