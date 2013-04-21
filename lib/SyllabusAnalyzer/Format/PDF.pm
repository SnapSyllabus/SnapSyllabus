package SyllabusAnalyzer::Format::PDF;

use strict;
use warnings;
use Moo;
use IPC::Run3;
use File::Temp qw/ tempfile tempdir /;
use File::Slurp qw/ write_file read_file /;
use HTML::Strip;
use Encode qw/decode_utf8/;
use HTML::FormatText;

with qw(SyllabusAnalyzer::Format);

has text => ( is => 'lazy', builder => 1 );
has html => ( is => 'lazy', builder => 1 );
has pdf => ( is => 'ro' );

sub _build_text {
	my ($self) = @_;
	$self->run_pdftohtml_text($self->pdf);
}

sub _build_html {
	my ($self) = @_;
	$self->run_pdftohtml($self->pdf);
}

sub run_pdftohtml_text {
	my ($self) = @_;
	my $hs = HTML::Strip->new();
	my $stripped = $hs->parse( $self->html );
	$hs->eof;
	$stripped =~ s,\xa0, ,g; # nsbp
	return $stripped;
}

sub run_pdftohtml {
	my ($self, $data) = @_;
	my ($out);
	my $tmp = File::Temp->new();

	write_file( $tmp->filename, $data );
	my $html_file = $tmp->filename . ".html";

	my @cmd = ( 'pdftohtml', '-i', '-noframes', $tmp->filename );
	run3 \@cmd, \undef, \undef, \undef or die "pdftotext: $?";

	$out = read_file( $html_file );
	unlink $html_file;
	#$out =~ s,\x{F0B7}|\x{F02D},foobar,g; # symbol font bullets
	#$out =~ s,\x{F0B7}|\x{F02D},foobar,g; # symbol font bullets
	return $out;
}

sub run_pdftotext {
	my ($self, $data) = @_;
	my ($in, $out);
	$in .= $data;
	my @cmd = ( 'pdftotext', '-', '-' );
	run3 \@cmd, \$in, \$out, \undef or die "pdftotext: $?";
	return $out;
}

1;
