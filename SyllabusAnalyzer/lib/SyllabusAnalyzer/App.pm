package SyllabusAnalyzer::App;

use strict;
use warnings;
use Moo;

use aliased 'SyllabusAnalyzer::Analyze' => 'Analyze';

sub run {
	my ($self, $args) = @_;
	return unless @$args;
	die "can not read file $args->[0]" unless -r $args->[0];
	Analyze->analyze_file($args->[0])
}

1;

# ABSTRACT: analyses documents and extracts events
