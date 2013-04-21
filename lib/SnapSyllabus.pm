package SnapSyllabus;
use Dancer ':syntax';

set 'session'      => 'Simple';
set 'template'      => 'template_toolkit';
set 'layout'      => 'main';

get '/' => sub {
    template 'index', {}, { layout => undef };
};

true;

=head1 NAME

   SnapSyllabus - 3DS product

=head1 DESCRIPTION

A webapp developed at 3DS University of Houston.

=cut

# ABSTRACT: turns a syllabus into a calendar
