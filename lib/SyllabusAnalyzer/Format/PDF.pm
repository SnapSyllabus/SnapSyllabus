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
	use DDP; p $stripped;
	return $stripped;
}

sub run_pdftohtml {
	my ($self, $data) = @_;
	my ($out, $err);
	my $tmp = File::Temp->new( SUFFIX => '.pdf' );

	write_file( $tmp->filename, {binmode => ':raw'}, $data );
	my $html_file = $tmp->filename . ".html";

	my @cmd = ( 'pdftohtml', '-i', '-noframes', $tmp->filename, $html_file );
	run3 \@cmd, \undef, \undef, \$err or die "pdftotext: $?";
	print "$err"; # TODO logging

	$out = read_file( $html_file ) or die "could not read output of pdftohtml: $!";
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
