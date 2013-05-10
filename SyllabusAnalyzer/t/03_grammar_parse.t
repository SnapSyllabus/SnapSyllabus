use strict;
use warnings;
use Test::More;

use File::Spec;
use File::Slurp;

BEGIN { use_ok( 'SyllabusAnalyzer::Format::PDF' ); }
require_ok( 'SyllabusAnalyzer::Format::PDF' );

BEGIN { use_ok( 'SyllabusAnalyzer::Extraction::Grammar' ); }
require_ok( 'SyllabusAnalyzer::Extraction::Grammar' );

my $ex;
ok( $ex = SyllabusAnalyzer::Extraction::Grammar->new() , 'built grammar' );

my $data_d = "$ENV{HOME}/SnapSyllabus/data";
$data_d = "$ENV{HOME}/sw_projects/SnapSyllabus/data" unless -r $data_d;
my $syllabus_f = File::Spec->catfile( $data_d, 'MIS 4397 7397 Spring 2013 Syllabus.pdf' );
#my $syllabus_f = File::Spec->catfile( $data_d, 'spring2013syll2143.pdf' );

my $syllabus_dat = read_file( $syllabus_f );

my $fmt_pdf;
ok( $fmt_pdf = SyllabusAnalyzer::Format::PDF->new( pdf => $syllabus_dat ), 'build PDF format' );

use DDP; p $ex->extract( $fmt_pdf->text );

done_testing;
