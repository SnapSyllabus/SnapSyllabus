package SyllabusAnalyzer::Calendar::RenderICal;

use strict;
use warnings;

use Data::ICal;
use Data::ICal::DateTime;
use Data::ICal::Entry::Event;
use Encode qw/decode_utf8/;

sub render {
	my ($self, $calendar) = @_;
	my $ical = Data::ICal->new;
	for my $day ($calendar->days) {
		my $event = Data::ICal::Entry::Event->new();
		my $info = join "\n",  @{ $calendar->get_info($day) };
		$event->add_properties( summary => $info );
		$event->start($day);
		$ical->add_entry($event);
	}
	decode_utf8($ical->as_string);
}

1;
