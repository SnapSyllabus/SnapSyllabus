package SyllabusAnalyzer::Analyze;

use strict;
use warnings;
use Moo;

use File::Slurp;
use autodie;

use aliased 'SyllabusAnalyzer::Format::Image' => 'Format::Image';
use aliased 'SyllabusAnalyzer::Format::PDF' => 'Format::PDF';
use aliased 'SyllabusAnalyzer::Format::Text' => 'Format::Text';

use aliased 'SyllabusAnalyzer::Extraction::Grammar' => 'Extraction::Grammar';

sub analyze {
	my ($self, $format) = @_;
	my $calendar = Extraction::Grammar->extract($format->text);
}

sub analyze_text {
	my ($self, $data) = @_;
	$self->analyze(Format::Text->new( text => $data ));
}

sub analyze_pdf {
	my ($self, $data) = @_;
	$self->analyze(Format::PDF->new( pdf => $data ));
}

sub analyze_image {
	my ($self, $data) = @_;
	$self->analyze(Format::Image->new( image => $data ));
}

sub analyze_file {
	my ($self, $filename) = @_;
	if($filename =~ /\.pdf$/) {
		my $data = read_file( $filename, { binmode => ':raw' } );
		$self->analyze_pdf($data);
	}
}

1;

# ABSTRACT: analyses documents and extracts events
