package SnapSyllabus;
use Dancer ':syntax';

use FindBin;
use lib "$FindBin::Bin/../../SyllabusAnalyzer/lib";

use SyllabusAnalyzer::Analyze;
use SyllabusAnalyzer::Calendar::RenderHTMLTable;
use SyllabusAnalyzer::Calendar::RenderICal;

set 'session'      => 'Simple';
set 'template'      => 'template_toolkit';
set 'layout'      => 'main';


use Data::UUID;
my $calendar_store = {};
my $ug = Data::UUID->new;

get '/' => sub {
    template 'index';
};

post '/upload' => sub {
	my $upload = request->uploads()->{upload};
	use DDP; p $upload;
	my $filename = $upload->tempname;
	use DDP; p $filename;
	my $sa = SyllabusAnalyzer::Analyze->new();
	$sa->analyze_file($filename);
	use DDP; p $sa->extraction_strategy->calendar;
	my $calendar = $sa->extraction_strategy->calendar;

	my $data = '';

	my $table = SyllabusAnalyzer::Calendar::RenderHTMLTable->render($calendar);

	my $uuid = $ug->create_str() . ".ics"; # NOTE appending ICS so that the extension is there
	my $ics = SyllabusAnalyzer::Calendar::RenderICal->render($calendar);
	$calendar_store->{$uuid} = $ics;

	my $cal_http = uri_for( '/cal/' . $uuid );
	my $cal_webcal = uri_for( '/cal' . $uuid );
	my $gcal_http = URI->new('https://www.google.com/calendar/render')
	$gcal_http->query_form( cid => $cal_http );
	$cal_webcal->scheme('webcal');

	template 'upload', { data => $data , table => $table, ics => $ics,
		cal_http_uri => $cal_http, cal_webcal_uri => $cal_webcal,
		google_calendar_uri => $gcal_http };
};

get '/cal/:id' => sub {
	if( exists $calendar_store->{param('id')} ) {
		content_type 'text/calendar';
		return $calendar_store->{param('id')};
	}
	send_error('Invalid calendar ID', 400);
};

true;

__END__

=head1 NAME

   SnapSyllabus - 3DS product

=head1 DESCRIPTION

A webapp developed at 3DS University of Houston.

=cut

# ABSTRACT: turns a syllabus into a calendar
