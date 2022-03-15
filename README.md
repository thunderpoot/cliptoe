# CLI-PToE
Command Line Interactive Periodic Table of Elements. _(It's a pretty stupid name.)_ 📋🦶

![ezgif-2-5c289550e5](https://user-images.githubusercontent.com/54200401/146476909-0a99cc8e-73b7-41ee-9ca6-74fe06c93858.gif)

### What?

 - ✅ Highlight elements on Periodic Table
 - ✅ Parse chemical formulas
 - ✅ Calculate atomic mass of compounds
 - ✅ Pretty colours!

### Usage:

```
$ cliptoe -h
Command Line Interactive Periodic Table of Elements

Usage:
cliptoe [atom]         show details for element by atomic symbol or number
cliptoe [compound]     list elements in compound

Options:
cliptoe --animate=<n>  scroll through colours, speed is <n>
cliptoe --var=<n>      set colour variation
cliptoe --ind=<n>      set colour start index
cliptoe --label        show period and group labels
cliptoe --compounds    show list of example compounds
cliptoe --key          show colour key
cliptoe --table        show table / highlight elements on table
cliptoe --mono         disable colours
```

### Examples:

<img width="796" alt="Screenshot 2021-12-17 at 02 21 04" src="https://user-images.githubusercontent.com/54200401/146478333-0c055e48-503f-4038-afba-a7b451684524.png">

<img width="797" alt="Screenshot 2021-12-16 at 23 21 41" src="https://user-images.githubusercontent.com/54200401/146463348-203dc15b-2afc-4971-863c-f53712fbe4c0.png">

<img width="796" alt="Screenshot 2021-12-17 at 01 49 23" src="https://user-images.githubusercontent.com/54200401/146476257-dd5d420f-5c7c-4987-b6fc-089632c800ee.png">

<img width="796" alt="Screenshot 2021-12-16 at 23 25 35" src="https://user-images.githubusercontent.com/54200401/146463668-d257bdf7-6e5a-4380-804a-2a4659b7615a.png">

## Concept
The idea was originally a TeleBASIC code-golf exercise, then was ported to Perl.
The example screenshots are from the Perl version.

Creating this program in whatever language has been helpful for me in familiarising myself with syntax,
using the same (fairly naïve) approaches.  I plan to add more 'translations' eventually.

In Perl, the `ptoe_parse_input` function turns a chemical formula into its component items:
```perl
sub ptoe_parse_input
{
    my ( $query ) = @_;

    # Parse chemical formula, input a string and get an array
    # e.g 'H2O' => $VAR1 = [ 'H', '2' ]; $VAR2 = [ 'O', '1' ];

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
```
```
$ cliptoe -d C21H30O2
$VAR1 = [
          [
            'C',
            '21'
          ],
          [
            'H',
            '30'
          ],
          [
            'O',
            '2'
          ]
        ];

$ cliptoe -d NaHCO3
$VAR1 = [
          [
            'Na',
            '1'
          ],
          [
            'H',
            '1'
          ],
          [
            'C',
            '1'
          ],
          [
            'O',
            '3'
          ]
        ];
$
```
## Caveats
These programs are only able to handle formulas like `C15H31N3O13P2`, but formulas like `Fe2(SO4)3` are not supported (yet).

## Disclaimer
I'm not a chemist, and there are probably all kinds of bugs / problems that I'm not aware of.
I plan to address any such issues to the best of my ability, but cannot make any promises.
If you find this helpful, please consider [supporting me via PayPal](https://www.paypal.com/donate/?hosted_button_id=NCGGHVES859DA) ❤️

## Thanks
[@telnet23](https://github.com/telnet23)
[@kelturio](https://github.com/Kelturio)
