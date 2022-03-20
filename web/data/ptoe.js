let isinverted = false;
let colourindex = 0;
let colourvariation = 1;

$(document).ready(function () {
    let ourRequest = new XMLHttpRequest();
    let theURL = './data/data.json';
    ourRequest.open('GET',theURL);
    ourRequest.onload = function () {
        const elements = JSON.parse(ourRequest.responseText);
        let compound_list = elements['compounds'];

        for ( formula in compound_list ) {
            $('#compounds').append("<option value='" + formula + "'>");
        }

        $('input').on('input', function() {
            let formula = $('input').val();
            let matches = [...formula.matchAll(/([A-Z][a-z]?)([0-9]+)?/g)];

            drawAtmolCalc(elements,matches);
            drawPeriodicTable(elements,matches);
            var c = this.selectionStart,
                r = /[^a-z0-9]/gi,
                v = $(this).val();
            if(r.test(v)) {
                $(this).val(v.replace(r, ''));
                c--;
            }
            this.setSelectionRange(c, c);
        });
        $(document).keydown(function () { $('input').focus(); });
        $('input').keyup(function (e) {
            let formula = $('input').val();
            $('td.atmolcalc').html('');
            $('.atmolcalc').append(summary(elements));
            let out = '';
            let matches = [...formula.matchAll(/([A-Z][a-z]?)([0-9]+)?/g)];
            drawAtmolCalc(elements,matches);
            drawPeriodicTable(elements,matches);
        });

        $('#logo').click(function () {
            $('ul.menu').toggle(100);
        });

        $('.iplus').click(function () {
            colourindex++;
            if (colourindex > 99) {colourindex = 99};
            $('.iresult').html(colourindex+('&nbsp;'.repeat(2-colourindex.toString().length)));
            let formula = $('input').val();
            let matches = [...formula.matchAll(/([A-Z][a-z]?)([0-9]+)?/g)];
            drawPeriodicTable(elements,matches)
            drawAtmolCalc(elements,matches);
        });
        $('.iminus').click(function () {
            colourindex--;
            if (colourindex < 0) {colourindex = 0};
            $('.iresult').html(colourindex+('&nbsp;'.repeat(2-colourindex.toString().length)));
            let formula = $('input').val();
            let matches = [...formula.matchAll(/([A-Z][a-z]?)([0-9]+)?/g)];
            drawPeriodicTable(elements,matches)
            drawAtmolCalc(elements,matches);
        });
        $('.vplus').click(function () {
            colourvariation++;
            if (colourvariation > 99) {colourvariation = 99};
            $('.vresult').html(colourvariation+('&nbsp;'.repeat(2-colourvariation.toString().length)));
            let formula = $('input').val();
            let matches = [...formula.matchAll(/([A-Z][a-z]?)([0-9]+)?/g)];
            drawPeriodicTable(elements,matches)
            drawAtmolCalc(elements,matches);
        });
        $('.vminus').click(function () {
            colourvariation--;
            if (colourvariation < 1) {colourvariation = 1};
            $('.vresult').html(colourvariation+('&nbsp;'.repeat(2-colourvariation.toString().length)));
            let formula = $('input').val();
            let matches = [...formula.matchAll(/([A-Z][a-z]?)([0-9]+)?/g)];
            drawPeriodicTable(elements,matches)
            drawAtmolCalc(elements,matches);
        });

        $('#but_dark').click(function () {
            if (isinverted) {
                isinverted = !isinverted;
                // $('#darkBG').animate({opacity:0},400, function () {
                $('body').animate({ backgroundColor: "#fff" }, "slow");
                $('#container').removeClass("inverted");
                    // $('#container').removeClass("inverted");
                // });
            } else {
                isinverted = !isinverted;
                $('body').animate({ backgroundColor: "#000" }, "slow");
                $('#container').addClass("inverted");
                // $('#darkBG').animate({opacity:1},400);
                // $('#container').addClass("inverted");
            }
        });

        $('.clr').click(function () {
            $('input').val('');
            drawPeriodicTable(elements,[]);
            drawAtmolCalc(elements, []);
            $('input').focus();
        });
        $('td').click(function (e) {
                let sym = ''
                if (e.target.childNodes[0]) {sym = e.target.childNodes[0].textContent};
                if (sym.length <= 2 && isNaN(sym) && e.currentTarget.className == 'forminput' ) {
                    let f = $('input').val();

                    let formula = $('input').val();
                    const a = [...formula.matchAll(/([A-Z][a-z]?)([0-9]+)?/g)].pop();

                    if ( a != undefined ) {
                        if (a[2] == undefined) {a[2] = '1'};
                        if ( a[1] == sym ) { sym = Number(a[2]) + 1; f = f.replace(/[0-9]+$/,''); };
                    };
                    $('input').val(f+sym);
                    formula = $('input').val();
                    let matches = [...formula.matchAll(/([A-Z][a-z]?)([0-9]+)?/g)];

                    drawPeriodicTable(elements,matches);
                    drawAtmolCalc(elements, matches);
                    return false;
                };
            });
        drawPeriodicTable(elements, []);
        drawAtmolCalc(elements, []);
    }
    ourRequest.send();
});

function drawAtmolCalc(elements,matches) {
    let atmol = 0.00;
        $('td.atmolcalc').html('');
        $('.atmolcalc').append(summary(elements));
    for (match of matches) {
        if (match[2] == undefined) {match[2] = '1'}
        atmol += match[2];
        if (elements['symbols'][match[1]] == undefined) {
            $('td.atmolcalc').html('');
            $('.atmolcalc').append(summary(elements));
        }
        else {
            const element_found = elements['symbols'][match[1]];
            const enam = element_found['name'];
            const ecat = element_found['category'];
            const enumb = element_found['number'];
            const esym = element_found['symbol'];
            const eph = element_found['phase'];
            const efac = capitalizeFirstLetter(element_found['fact']);
            const edeets = "Period " + element_found['period'] + ", " +
                           "Group " + element_found['group'] + '.';
            let colour = element_found['colour'];
            colour += 1
            colour *= (999);
            colour += colourindex*10
            colour *= colourvariation
            colour %= 99000;
            hexColour = decimalToHex(colour, 6)

            let pad = '';
            if ( esym.length < 2 ) { pad = "&nbsp;" };
            $('.atmolcalc').append(
                '<div '+
                'style="padding: 1em; background-color: #'+hexColour+'" '+
                'class="atmol-item">'+
                '<details>'+
                '<summary>'+
                '<h1 class="symbol">'+esym+'&nbsp;&nbsp;'+pad+enam+'</h1>'+
                '<p></p>'+
                '</summary>'+
                '<p>Atomic number '+enumb+'.</p>'+
                '<p>'+capitalizeFirstLetter(eph) + ", " + ecat + "." + '</p><p>' + edeets+'</p>'+
                '<p>'+"Mass: " + element_found['amu'] + " amu"+'</p>'+
                '<p>'+efac+'</p></div>'+
                '</details>'+
                '<br />'+
                '</div>');
        }
    }
}

function drawPeriodicTable(data,hig) {

    $('#periodicTable').html('');
    for (pn = 1; pn <=9; pn++) {
        $('#periodicTable').append('<tr class="period'+pn+'"></tr>');
    }

    $('#periodicTable tr.pgLabel').append('<th></th>');
    for (i=1; i<=18; i++) {
        $('#periodicTable tr.pgLabel').append('<th scope="col">'+i+'</th>');
    }

    for (p=1; p<=9; p++) {
        $('#periodicTable tr.period'+p).append('<th class="pglabel" scope="row"></th>');
        for (g=1; g<=18; g++) {
            let item = ''
            let style = ''
            if ( data['epg'][p][g] ) {
                let symbol = data['epg'][p][g];
                item = data['symbols'][symbol]['symbol'];
                colour = data['symbols'][symbol]['colour'];
                colour += 1;
                colour *= (999);
                colour += colourindex*10;
                colour *= colourvariation;
                colour %= 99000;
                let hexColour = decimalToHex(colour, 6)
                let opa = 0.5;
                for (m of hig) {
                    if ( m[1] == 'D' ) { m[1] = "H" };
                    if ( m[1] == symbol ) {
                        opa = 1;
                    }
                }
                if (hig.includes(symbol)) { opa = 1 };
                style = ' class="sym" style="opacity: '+opa+'; background-color: #'+hexColour+'; border: #'+hexColour+' solid .1em; color: #fff;"';
            }
            else {
                style = ' style="color: #000"'
            }
            $('#periodicTable tr.period'+p).append('<td'+style+'>'+item+'</td>');
        }
    }
}

String.prototype.toProperCase = function () {
    return this.replace(/\w\S*/g, function(txt){return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase();});
};

function capitalizeFirstLetter(string) {
  return string.charAt(0).toUpperCase() + string.slice(1);
}

function decimalToHex(d, padding) {
    var hex = Number(d).toString(16);
    padding = typeof (padding) === "undefined" || padding === null ? padding = 2 : padding;

    while (hex.length < padding) {
        hex = "0" + hex;
    }

    return hex;
}

function get_compound_name(elements, formula) {
    let name = 'Unknown Compound';
    if (formula == '') { name = 'Unknown Compound' }
    let formulaStripped = formula.replace(/^[0-9]+/,'');
    formulaStripped = formulaStripped.replace(/[0-9]+$/,'');
    if (elements['symbols'][formulaStripped] != undefined)
    {
        name = elements['symbols'][formulaStripped]['name']
        return name;
    }
    else if (elements['compounds'][formula] != undefined) {
        name = elements['compounds'][formula];
        return name;
    }
    return name;
}

function get_compound_mass(elements, formula) {
    let matches = [...formula.matchAll(/([A-Z][a-z]?)([0-9]+)?/g)];
    let totalsum = 0.0;
    let atmol = 0.0;
    for (match of matches) {
        if (formula.match(/[a-z]{2,}/)) {return -1};
        if (match[2] == undefined) {match[2] = '1'}
        atmol += Number(match[2]);
        let sum = 0;
        if (elements['symbols'][match[1]] != undefined) { sum = elements['symbols'][match[1]]['amu'] * match[2] };
        totalsum += sum;
    }
    return totalsum.toFixed(3);
}

function summary(elements) {
    let formula = $('input').val();
    const compound = get_compound_name(elements, formula);
    formula = formula.replace(/^[0-9]+/,'');
    let dimstyle = '';
    if (compound == "Unknown Compound") { dimstyle = ' style="opacity: 0.5"' };
    const mass = get_compound_mass(elements, formula);
    if ( mass <= 0 ) { return '' };
    let compound_mass = "Mass of "+ formula +": " + mass + " amu";
    if (formula == '') { compound_mass = '' };
    return '<div id="summary" '+
                'style="padding: 1em; color: #000; background-color: rgba(0,0,0,0)" '+
                'class="atmol-item" id="summary">'+
                '<div><h2 '+dimstyle+' class="deets">'+compound.toProperCase()+'</h2>'+
                '<p>'+compound_mass+'</p></div>'+
                '<br />'+
                '</div>';
}
