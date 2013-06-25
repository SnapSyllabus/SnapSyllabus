package SyllabusAnalyzer::App;

use strict;
use warnings;
use Moo;

use aliased 'SyllabusAnalyzer::Analyze' => 'Analyze';
use aliased 'SyllabusAnalyzer::Calendar::RenderHTMLTable' => 'RenderHTMLTable';

sub run {
	my ($self, $args) = @_;
	return unless @$args;
	die "can not read file $args->[0]" unless -r $args->[0];
	my $analyzer = Analyze->new();
	$analyzer->analyze_file($args->[0]);
	print RenderHTMLTable->render($analyzer->calendar);
}

1;

# ABSTRACT: analyses documents and extracts events
