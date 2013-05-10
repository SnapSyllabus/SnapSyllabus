use strict;
use warnings;
use Test::More;

BEGIN { use_ok( 'SyllabusAnalyzer::Extraction::Grammar' ); }
require_ok( 'SyllabusAnalyzer::Extraction::Grammar' );

my $ex;
ok( $ex = SyllabusAnalyzer::Extraction::Grammar->new() , 'built grammar' );

#use DDP; p $ex->extract('january');
#use DDP; p $ex->extract('12/32/2012');

use DDP; p $ex->extract('Jan 15 2012');
use DDP; p $ex->extract('2/20/2012');
use DDP; p $ex->extract('january 31, 2012');
use DDP; p $ex->extract('january 31 2012');
use DDP; p $ex->extract('jan 31, 2012');
use DDP; p $ex->extract('february 31, 2012');
use DDP; p $ex->extract('jan 31 2012');
use DDP; p $ex->extract('2/20/12');
use DDP; p $ex->extract('2/20');

#use DDP; p $ex->extract("Jan 15 2012 j
#2/20/2012 c
#january 31, 2012 o
#january 31 2012 i
#jan 31, 2012 u
#jan 31 2012 o");

done_testing;
