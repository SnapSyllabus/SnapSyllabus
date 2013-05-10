package SnapSyllabus;
use Dancer ':syntax';

use FindBin;
use lib "$FindBin::Bin/../SyllabusAnalyzer/lib";

set 'session'      => 'Simple';
set 'template'      => 'template_toolkit';
set 'layout'      => 'main';

get '/' => sub {
    template 'index';
};

post '/upload' => sub {
	my $upload = request->uploads;
	#use DDP; p $upload;
	my $j = join ", ", keys $upload;
	#my $filename = $upload->tempname;
	my $data = <<EOF
{
		"prefix":"ICS starts here", 
		"suffix":"ICS Ends here", 
		"EventData":
		[
			{
				"Date": "01/19/2013",
				"Text": "Sat January 19 First day of class",
			},
			{
				"Date": "01/30/2013",
				"Text": "Wed January 30 Last Day to Drop without receiving a grade",
			},
			{
				"Date": "01/30/2013",
				"Text": "Sat February 9 Exam 1",
			},
			{
				"Date": "03/09/2013",
				"Text": "Sat March 9 Exam 2",
			},
			{
				"Date": "03/16/2013",
				"Text": "Sat March 16 Spring Break",
			},
			{
				"Date": "03/27/2013",
				"Text": "Wed March 27 Last Day to Drop with a “W” Sat April 6 Exam 3",
			},
			{
				"Date": "05/04/2013",
				"Text": "Sat May 4 Final Exam (in class) Drop Policy It is the student’s responsibility to know published drop dates and to act on those dates if necessary or desired.  Course Evaluations",
			},
			{
				"Date": "05/05/2013",
				"Text": "Final Exam – May 5 25 points Total Possible 100 points Less Deducted Points for Non Excused Non Attendance",
			},
			{
				"Date": "01/19/2013",
				"Text": "Week 1 (1/19/2013) Lecture & Lab • Introduction to class • Class expectations (Roles and Responsibilities) • Syl abus review • Introduction to the industry 4",
			},
			{
				"Date": "01/26/2013",
				"Text": "Week 2 (1/26/2013) Lecture & Lab • Industry Overview • Systems Overview • Market Data • Establish Teams",
			},
			{
				"Date": "02/02/2013",
				"Text": "Week 3 (2/2/2013) Lecture & Lab • Physical Trading • Implementing ETRMs",
			},
			{
				"Date": "02/09/2013",
				"Text": "Week 4 (2/9/2013) • Discussion or Speaker •  EXAM 1",
			},
			{
				"Date": "02/16/2013",
				"Text": "Week 5 (2/16/2013) Lecture & Lab • Financial Trading • Implementation Key Success Factors",
			},
			{
				"Date": "02/23/2013",
				"Text": "Week 6 (2/23/2013) Lecture & Lab • Storage and Imbalances • The importance of testing",
			},
			{
				"Date": "03/02/2013",
				"Text": "Week 7 (3/2/2013) Lecture & Lab • Processing • Maintaining your ETRM system 5",
			},
			{
				"Date": "03/09/2013",
				"Text": "Week 8 (3/9/2013) • Discussion or Speaker •  EXAM 2",
			},
			{
				"Date": "03/16/2013",
				"Text": "Week 9 (3/16/2013) Spring Break",
			},
			{
				"Date": "03/23/2013",
				"Text": "Week 10 (3/23/2013) Lecture & Lab • Scheduling • Understanding the ETRM business model",
			},
			{
				"Date": "03/30/2013",
				"Text": "Week 11 (3/30/2013) Lecture & Lab • System Controls and Compliance",
			},
			{
				"Date": "04/06/2012",
				"Text": "Week 12 (4/6/2012) Lecture & Lab • Risk and Credit • Regulatory Reporting and Compliance",
			},
			{
				"Date": "04/13/2013",
				"Text": "Week 13 (4/13/2013) • Discussion or Speaker •  EXAM 3",
			},
			{
				"Date": "04/20/2013",
				"Text": "Week 14 (4/20/2013) Lecture & Lab • Accounting Close • Audit 6",
			},
			{
				"Date": "04/27/2013",
				"Text": "Week 15 (4/27/2013) Lecture & Lab • Systems Overview",
			},
			{
				"Date": "05/04/2013",
				"Text": "Week 16 (5/4/2013) Final Exam 7",
			}
		]
	};
EOF
;

my $table = <<EOF

<table border=1>
<tr>
<th> Date </th>
<th> Description </th>
</tr>
<tr>
	<td>01/19/2013</td>
	<td>Sat January 19 First day of class</td>
</tr>
<tr>
	<td>01/30/2013</td>
	<td>Wed January 30 Last Day to Drop without receiving a grade</td>
</tr>
<tr>
	<td>01/30/2013</td>
	<td>Sat February 9 Exam 1</td>
</tr>
<tr>
	<td>03/09/2013</td>
	<td>Sat March 9 Exam 2</td>
</tr>
<tr>
	<td>03/16/2013</td>
	<td>Sat March 16 Spring Break</td>
</tr>
<tr>
	<td>03/27/2013</td>
	<td>Wed March 27 Last Day to Drop with a “W” Sat April 6 Exam 3</td>
</tr>
<tr>
	<td>05/04/2013</td>
	<td>Sat May 4 Final Exam (in class) Drop Policy It is the student’s responsibility to know published drop dates and to act on those dates if necessary or desired.  Course Evaluations</td>
</tr>
<tr>
	<td>05/05/2013</td>
	<td>Final Exam – May 5 25 points Total Possible 100 points Less Deducted Points for Non Excused Non Attendance</td>
</tr>
<tr>
	<td>01/19/2013</td>
	<td>Week 1 (1/19/2013) Lecture & Lab • Introduction to class • Class expectations (Roles and Responsibilities) • Syl abus review • Introduction to the industry 4</td>
</tr>
<tr>
	<td>01/26/2013</td>
	<td>Week 2 (1/26/2013) Lecture & Lab • Industry Overview • Systems Overview • Market Data • Establish Teams</td>
</tr>
<tr>
	<td>02/02/2013</td>
	<td>Week 3 (2/2/2013) Lecture & Lab • Physical Trading • Implementing ETRMs</td>
</tr>
<tr>
	<td>02/09/2013</td>
	<td>Week 4 (2/9/2013) • Discussion or Speaker •  EXAM 1</td>
</tr>
<tr>
	<td>02/16/2013</td>
	<td>Week 5 (2/16/2013) Lecture & Lab • Financial Trading • Implementation Key Success Factors</td>
</tr>
<tr>
	<td>02/23/2013</td>
	<td>Week 6 (2/23/2013) Lecture & Lab • Storage and Imbalances • The importance of testing</td>
</tr>
<tr>
	<td>03/02/2013</td>
	<td>Week 7 (3/2/2013) Lecture & Lab • Processing • Maintaining your ETRM system 5</td>
</tr>
<tr>
	<td>03/09/2013</td>
	<td>Week 8 (3/9/2013) • Discussion or Speaker •  EXAM 2</td>
</tr>
<tr>
	<td>03/16/2013</td>
	<td>Week 9 (3/16/2013) Spring Break</td>
</tr>
<tr>
	<td>03/23/2013</td>
	<td>Week 10 (3/23/2013) Lecture & Lab • Scheduling • Understanding the ETRM business model</td>
</tr>
<tr>
	<td>03/30/2013</td>
	<td>Week 11 (3/30/2013) Lecture & Lab • System Controls and Compliance</td>
</tr>
<tr>
	<td>04/06/2012</td>
	<td>Week 12 (4/6/2012) Lecture & Lab • Risk and Credit • Regulatory Reporting and Compliance</td>
</tr>
<tr>
	<td>04/13/2013</td>
	<td>Week 13 (4/13/2013) • Discussion or Speaker •  EXAM 3</td>
</tr>
<tr>
	<td>04/20/2013</td>
	<td>Week 14 (4/20/2013) Lecture & Lab • Accounting Close • Audit 6</td>
</tr>
<tr>
	<td>04/27/2013</td>
	<td>Week 15 (4/27/2013) Lecture & Lab • Systems Overview</td>
</tr>
<tr>
	<td>05/04/2013</td>
	<td>Week 16 (5/4/2013) Final Exam 7</td>
</tr>
</table>

EOF
;


	template 'upload', { data => $data , table => $table };
};

true;

=head1 NAME

   SnapSyllabus - 3DS product

=head1 DESCRIPTION

A webapp developed at 3DS University of Houston.

=cut

# ABSTRACT: turns a syllabus into a calendar
