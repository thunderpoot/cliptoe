#!/usr/bin/env perl

use strict;

use Data::Dumper;
use JSON::XS;
use Getopt::Long qw(GetOptions);
use Time::HiRes qw(usleep);
use Text::CSV qw( csv );

my $ptoe_version = '1.1.2';

# Based on PTOE.BAS
# ,----------------------------------------------,
# | PTOE.BAS - by underwood, searinox, and devon |
# |          - December 2021                     |
# `----------------------------------------------'
# Command Line Interactive Periodic Table of Elements
# ' https://www.youtube.com/watch?v=wlOdUATGuQY
#
# ' "There is no standard set of colors used to identify element groups or other properties.
# ' Colors are selected based on how well the text shows up against them, but mostly it's a
# ' matter of personal preference." https://www.thoughtco.com/color-on-the-periodic-table-608827

our @ptoe_category_examples;
our @ptoe_colours;

# our $mole = 6.02214076e23;

our $elements = {
    'compounds' => {
        'C21H30O2'      => 'Tetrahydrocannabinol',
        'H2SO4'         => 'Sulfuric Acid',
        'NH3'           => 'Ammonia',
        'SF6'           => 'Sulfur Hexafluoride',
        'C7H8'          => 'Toluene',
        'H2O2'          => 'Hydrogen Peroxide',
        'C2H2'          => 'Acetylene',
        'CH3OH'         => 'Methanol',
        'C7H5N3O6'      => 'Trinitrotoluene',
        'SO4'           => 'Sulfur Dioxide',
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

my $aoh =  csv(in => "../elements.csv", headers => "auto");

for my $entry ( $aoh )
{
    for my $w ( @$entry )
    {
        $elements->{elementbysymbol}->{ $w->{symbol} } = $w;
    }
}

my $allsymbols =
    'HHeLiBeBCNOFNeNaMgAlSiPSClArKCaScTiVCrMnFeCoNiCuZnGaGeAsSeBrKrRbSrYZrNbMoTc'.
    'RuRhPdAgCdInSnSbTeIXeCsBaLaCePrNdPmSmEuGdTbDyHoErTmYbLuHfTaWReOsIrPtAuHgTl'.
    'PbBiPoAtRnFrRaAcThPaUNpPuAmCmBkCfEsFmMdNoLrRfDbSgBhHsMtDsRgCnNhFlMcLvTsOg';

my $cou;

while ( $allsymbols =~ /([A-Z][a-z]?)/g )
{
    $elements->{elementbynumber}->{ ++$cou } = $1;
}

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

sub load_ptoe_colours
{
    @ptoe_category_examples = ptoe_category_examples();
    @ptoe_colours           = ptoe_colours();
    return;
}

sub ptoe
{
    my ( $conn ) = @_;
    my $query = $conn->{arg};
    if ( $query =~ /([^A-Za-z0-9])/ )
    {
        return error( 'unknown symbol in query: "' . $1 . '"' );
    }
    if ( ( $query =~ /[a-z]{2,}/ ) || ( $query =~ /\d[a-z]/ ) )
    {
        # Search for element by name if query is not symbol, number, or formula
        my $found;
        for ( keys %{ $elements->{elementbysymbol} } )
        {
            my $nm = $elements->{elementbysymbol}->{$_}->{name};
            if ( uc( $nm ) eq uc( $query ) )
            {
                $found = 1;
                $query = $_;
                last;
            }
        }
        return error( 'invalid input' ) if ( !$found );
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
        # Query in Perl style
        println( Dumper( $query ) );
        exit;
    }
    elsif ( $conn->{options}->{json} )
    {
        # Query in pretty JSON style
        println( JSON::XS->new->pretty->encode( \@elem ) );
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
        $p[ ++$i ] = $elements->{elementbysymbol}->{$_}->{number};
    }
    return @p;
}

sub ptoe_colours
{
    my @c;

    # Colour categories
    my $i;
    $c[ ++$i ] = $_
      for (
        "Hydrogen", "G 18", "G 17", "G 16", "G 15",
        "G 14", "G 13", "G 3-12", "G 2", "G 1-H",
        "Lanthanides", "Actinides"
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
    my $json;
    my $debug;
    my $table;
    my $comp;

    GetOptions(
        "var=i"     => \$var,        # numeric
        "ind=i"     => \$ind,        # numeric
        "key"       => \$key,        # flag
        "label"     => \$label,      # flag
        "mono"      => \$mono,       # flag
        "json"      => \$json,       # flag
        "animate=i" => \$auto,       # numeric
        "table"     => \$table,      # flag
        "debug"     => \$debug,      # flag
        "help"      => \$help,       # flag
        "version"   => \$version,    # flag
        "compounds" => \$comp,       # flag
    ) or error( 'Error in command line arguments' );

    $conn->{options}->{var}       = $var;
    $conn->{options}->{ind}       = $ind;
    $conn->{options}->{key}       = $key;
    $conn->{options}->{label}     = $label;
    $conn->{options}->{mono}      = $mono;
    $conn->{options}->{auto}      = $auto;
    $conn->{options}->{json}      = $json;
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
    print( "\e[?25h^C\e[0K\n" );
    exit;
}

$SIG{INT} = \&repaint_cursor;

load_ptoe_colours();
do_ptoe();

1;
