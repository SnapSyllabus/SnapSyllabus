package SyllabusAnalyzer::Calendar;

use strict;
use warnings;
use Moo;
use Tie::RefHash;

has _events => ( is => 'rw', builder => 1 );

sub add_event {
	my ($self, $date, $info) = @_;
	push @{ $self->_events->{$date} }, $info;
}

sub days {
	my ($self) = @_;
	sort keys $self->_events;
}

sub get_info {
	my ($self, $date) = @_;
	$self->_events->{$date};
}


sub _build__events {
	my %h = ();
	tie %h, 'Tie::RefHash';
	return \%h;
}


1;
