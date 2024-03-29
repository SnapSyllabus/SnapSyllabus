package SyllabusAnalyzer::Calendar::RenderHTMLTable;

use strict;
use HTML::Table;
use HTML::Entities;
use DateTime::Format::Strptime;
use Encode qw/decode_utf8/;

my $dt_fmt = DateTime::Format::Strptime->new( pattern => '%Y&#8209;%m&#8209;%d' ); # year-month-day with non-breaking hyphen

sub render {
	my ($self, $calendar) = @_;
	my $html_table = HTML::Table->new( -class=> 'table table-striped table-condensed table-hover' );
	for my $day ($calendar->days) {
		my $info = join "<br/>", map { encode_entities($_, '<>&') } @{ $calendar->get_info($day) };
		$info =~ s,$,<br/>,mg;
		$html_table->addRow(
			'<span class="event_dt">'.$self->render_date($day).'</span>',
			'<span class="event_info">'.$info.'</span>'
		);
	}
	decode_utf8($html_table->getTable);
}

sub render_date {
	my ($self, $date) = @_;
	return $dt_fmt->format_datetime( $date );
}


1;
