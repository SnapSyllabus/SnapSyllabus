use strict;
use warnings;
use Test::More;

use FindBin;
use File::Spec;
use File::Slurp;

BEGIN { use_ok( 'SyllabusAnalyzer::App' ); }
require_ok( 'SyllabusAnalyzer::App' );

BEGIN { use_ok( 'SyllabusAnalyzer::Format::PDF' ); }
require_ok( 'SyllabusAnalyzer::Format::PDF' );

#my $data_d = File::Spec->catfile($FindBin::Bin, ('..') x 2);
my $data_d = "$ENV{HOME}/SnapSyllabus/data";
$data_d = "$ENV{HOME}/sw_projects/SnapSyllabus/data" unless -r $data_d;
my $syllabus_f = File::Spec->catfile( $data_d, 'MIS 4397 7397 Spring 2013 Syllabus.pdf' );

my $syllabus_dat = read_file( $syllabus_f );

my $fmt_pdf;
ok( $fmt_pdf = SyllabusAnalyzer::Format::PDF->new( pdf => $syllabus_dat ), 'build PDF format' );

ok( $fmt_pdf->text, 'got text');
like( $fmt_pdf->text, qr/Week 1/, 'has expected text' );

done_testing;
