package SyllabusAnalyzer::Calendar;

use strict;
use warnings;
use Moo;
use Data::ICal::DateTime;
use Tie::RefHash::Weak;

has _events => ( is => 'lazy', builder => 1 );

sub add_event {
	my ($self, $date, $info) = @_;
	push @{ $self->_events->{$date} }, $info;
}

sub get_ical {
	# TODO
}

sub _build_events {
	my %h = ();
	tie %h, 'Tie::RefHash::Weak';
	return \%h;
}


1;
