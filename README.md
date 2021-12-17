# CLI-PTOE
Command Line Interactive Periodic Table Of Elements.
_It's a pretty stupid name._ 📋🦶

![ezgif-2-3019f6a5c2](https://user-images.githubusercontent.com/54200401/146476275-4ebccbcc-572b-475b-9653-fcc0375bc4ae.gif)

### Usage:

```
$ cliptoe -h
Command Line Interactive Periodic Table of Elements

Usage:
cliptoe [atom]         show details for element by atomic symbol or number
cliptoe [compound]     list elements in compound [q]

Options:
cliptoe --animate=<n>  scroll through colours, speed is <n>
cliptoe --var=<n>      set colour variation
cliptoe --ind=<n>      set colour start index
cliptoe --label        show period and group labels
cliptoe --compounds    show list of example compounds
cliptoe --key          show colour key
cliptoe --table [q]    show table / highlight elements on table
cliptoe --mono         disable colours
```

### Examples:

<img width="797" alt="Screenshot 2021-12-16 at 23 21 41" src="https://user-images.githubusercontent.com/54200401/146463348-203dc15b-2afc-4971-863c-f53712fbe4c0.png">

<img width="796" alt="Screenshot 2021-12-17 at 01 49 23" src="https://user-images.githubusercontent.com/54200401/146476257-dd5d420f-5c7c-4987-b6fc-089632c800ee.png">

<img width="796" alt="Screenshot 2021-12-16 at 23 25 35" src="https://user-images.githubusercontent.com/54200401/146463668-d257bdf7-6e5a-4380-804a-2a4659b7615a.png">

## Concept
The `ptoe_parse_input` function turns a chemical formula into its component items:
```perl
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

$ 
```
_This assumes that the input has already been checked for validity._

## Disclaimer
I'm not a chemist, and there are probably all kinds of bugs / problems that I'm not aware of.
I plan to address any such issues to the best of my ability, but cannot make any promises.
If you find this helpful, please consider [supporting me via PayPal](https://www.paypal.com/donate/?hosted_button_id=NCGGHVES859DA) ❤️
