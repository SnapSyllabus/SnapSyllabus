package SyllabusAnalyzer::Extraction::Grammar;

use strict;
use warnings;

use Moo;
use Pegex;


my $g = "

";

use constant DATE_GRAMMAR => <<EOF
date: english_date | numeric_date

english_date: month ws2 numeric_day  ( /(?:<ws1>,)?<ws2>/ numeric_year)?

numeric_date: numeric_month numeric_date_sep numeric_day (numeric_date_sep numeric_year)?

numeric_year: /((?:19|20)?<DIGIT>{2})/

numeric_date_sep: ws1 /[<DASH><SLASH>]/ ws1

numeric_month: / ( 1[0-2] | 0?[1-9] ) /

numeric_day: / ( 1[0-9] | 2[0-9] | 3[0-1] | 0?[0-9] ) /

month: month00 | month01 | month02 | month03 | month04 | month05 |
       month06 | month07 | month08 | month09 | month10 | month11

# month name tokens
month00: /( (?i:jan(?:uary)?) )/
month01: /( (?i:feb(?:ruary)?) )/
month02: /( (?i:mar(?:ch)?) )/
month03: /( (?:apr(?:il)?) )/
month04: /( (?i:may) )/
month05: /( (?i:jun(?:e)?) )/
month06: /( (?i:jul(?:y)?) )/
month07: /( (?i:aug(?:ust)?) )/
month08: /( (?i:sep(t(?:ember)?)?) )/
month09: /( (?i:oct(?:ober)?) )/
month10: /( (?i:nov(?:ember)?) )/
month11: /( (?i:dec(?:ember)?) )/

EOF
;

use constant GRAMMAR => <<EOF

top: ( date ( !<date> )* <EOL> )+

EOF
. DATE_GRAMMAR
;


has parser => ( is => 'lazy', builder => 1 );


sub _build_parser {
	#pegex( GRAMMAR, receiver => 'SyllabusAnalyzer::Extraction::Grammar::Receiver' );
	pegex( GRAMMAR, receiver => 'Pegex::Tree' );
}

sub extract {
	my ($self, $input) = @_;
	$self->parser->parse( $input );
}


{
package SyllabusAnalyzer::Extraction::Grammar::Receiver;

}

1;
