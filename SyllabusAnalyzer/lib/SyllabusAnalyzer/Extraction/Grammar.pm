package SyllabusAnalyzer::Extraction::Grammar;

use strict;
use warnings;

use Moo;
use DateTime;
use DateTime::Duration;

my $this_year = DateTime->now->year;
my $next_year = DateTime->now->add_duration( DateTime::Duration->new ( years => 1 ) );

use Regexp::Grammars;
qr&
    <nocontext:>
    <grammar: Grammar::Dates>
    #<debug: step>
    #( <[Date]> <.ws> )+

    <token: Date>
        #( <AmEnglishDate> | <AmNumericDate> )
        ( <D= AmEnglishDate> | <D= AmNumericDate> )
        <MATCH=  (?{ $MATCH = $MATCH{D} })>

    <token: AmEnglishDate>
        <.Weekday>? <.ws>+ <Month> <.ws>+ <Day= NumericDay>
            ( ,? <Year= NumericYear>
            | <.ws>+ <Year= NumericYear> )?
            #(?! <Digit>) <.ws>+
           <Year= (?{ $MATCH{Year} // $this_year })>

    <token: AmNumericDate>
       <.Weekday>? <.ws>+ <Month= NumericMonth> <.Numeric_DateSep> <Day= NumericDay>
           ( <.Numeric_DateSep> <Year= NumericYear> )?
               #(?! <Digit>) <.ws>+
               <Year= (?{ $MATCH{Year} // $this_year })>


    <token: Digit> \d

    <token: NumericMonth>  ( 1[0-2] | 0?[1-9] ) <MATCH= (?{ $MATCH = $CAPTURE })>
    <token: NumericDay> [12]\d | 3[01] | 0?[1-9]
    <token: NumericYear> (19|20)(\d{2}) <MATCH= (?{
        if(length $CAPTURE == 2) { # this is specific to the 19th / 20th centuries
            if( $CAPTURE <= $next_year->year ) {
                $MATCH = "20" . $CAPTURE;
            } else {
                $MATCH = "19" . $CAPTURE;
            }
        } else {
            $MATCH = $CAPTURE
        } })>
    # hyphen or slash
    <token: Numeric_DateSep> [\-/]

    <token: Month> (<M= month00> | <M= month01> | <M= month02> | <M= month03> | <M= month04> | <M= month05> |
                    <M= month06> | <M= month07> | <M= month08> | <M= month09> | <M= month10> | <M= month11> )
                    <MATCH= (?{ $MATCH = $MATCH{M} })>
    <token: Weekday> <weekday0> | <weekday1> | <weekday2> | <weekday3> | <weekday4> | <weekday5> | <weekday6>

    # month name tokens
    <token: month00> ( (?i:jan(?:uary)?) )          <MATCH= (?{  $MATCH =  1; })>
    <token: month01> ( (?i:feb(?:ruary)?) )         <MATCH= (?{  $MATCH =  2; })>
    <token: month02> ( (?i:mar(?:ch)?) )            <MATCH= (?{  $MATCH =  3; })>
    <token: month03> ( (?:apr(?:il)?) )             <MATCH= (?{  $MATCH =  4; })>
    <token: month04> ( (?i:may) )                   <MATCH= (?{  $MATCH =  5; })>
    <token: month05> ( (?i:jun(?:e)?) )             <MATCH= (?{  $MATCH =  6; })>
    <token: month06> ( (?i:jul(?:y)?) )             <MATCH= (?{  $MATCH =  7; })>
    <token: month07> ( (?i:aug(?:ust)?) )           <MATCH= (?{  $MATCH =  8; })>
    <token: month08> ( (?i:sep(?:t(?:ember)?)?) )   <MATCH= (?{  $MATCH =  9; })>
    <token: month09> ( (?i:oct(?:ober)?) )          <MATCH= (?{  $MATCH = 10; })>
    <token: month10> ( (?i:nov(?:ember)?) )         <MATCH= (?{  $MATCH = 11; })>
    <token: month11> ( (?i:dec(?:ember)?) )         <MATCH= (?{  $MATCH = 12; })>

    # weekday names
    <token: weekday0> ( (?i: m(?:o(?:n(?:day)?)?)?) )          <MATCH= (?{  $MATCH = 1; })>
    <token: weekday1> ( (?i: t(?:u(?:e(?:s(?:day)?)?)?)?) )    <MATCH= (?{  $MATCH = 2; })>
    <token: weekday2> ( (?i: w(?:ed(?:nesday)?)? ) )           <MATCH= (?{  $MATCH = 3; })>
    <token: weekday3> ( (?i: th(?:u(?:r(?:s(?:day)?)?)?)?  ) ) <MATCH= (?{  $MATCH = 4; })>
    <token: weekday4> ( (?i: f(?:r(?:i(?:day)?)?)?  ) )        <MATCH= (?{  $MATCH = 5; })>
    <token: weekday5> ( (?i: sa(?:t(?:urday)?)?  ) )           <MATCH= (?{  $MATCH = 6; })>
    <token: weekday6> ( (?i: s(?:u(?:n(?:day)?)?)?  ) )        <MATCH= (?{  $MATCH = 7; })>

&x;

my $grammar = qr&
    <nocontext:>
    #<debug: match>
    <extends: Grammar::Dates>

    <Date> <!Digit>

    #<[EventSentence]>+

    #<token: EventSentence>
        #( ( .*? <Date>  )
        #( .*? \n  ){0,5}?
         #) .*? (?:(?= <.Date>))
        ##<Text= (?{ $CAPTURE })>

    #( (<.Word>)+ % <.ws>+ )?
    #( (<Date>)+ % <.ws>+ )
    #( (<.Word>)+ % <.ws>+ )?
    #\n
    #<Text= (?{ $CAPTURE })>

    #<token: Capital> [A-Z]
    #<token: Word> \w+
    #<token: CapitalWord> <.Capital>+ \w+

    #<token: Events>
    #(<Date> <.ws>+ <!Date>+)
&x;
no Regexp::Grammars;

has parser => ( is => 'lazy', builder => 1 );

sub extract {
	my ($self, $input) = @_;
	#$self->parser->parse( $input );
    my $events;
    while($input =~ /$grammar/g) {
        my $h = \%/;
        $h->{pos} = pos($input) - length($&);
        $h->{linebeg} = rindex($input, "\n", $h->{pos});
        $h->{linebeg} = $h->{linebeg} == -1 ? 0 : $h->{linebeg};
        $h->{matched} = $&;
        push @$events, $h;
    }
    my $filtered_events;
    no Regexp::Grammars;
    for my $ev_idx (0..@$events-1) {
        my $this_event = $events->[$ev_idx];
        my $pos = $this_event->{linebeg};
        my $char_before =  substr($input, $this_event->{pos}-1, 1);
        next if $char_before =~ /\d/;
        my $to_len;
        if( $ev_idx == @$events - 1) {
            $to_len = length($input) - $events->[$ev_idx]{linebeg} - 1;
        } else {
            $to_len = $events->[$ev_idx + 1]{linebeg} - $events->[$ev_idx]{linebeg};
        }
        my $sub_to_next = substr $input, $pos, $to_len;
        $sub_to_next =~ s/\A(\s*\n)*|(\s*\n)*\z//gs;
        #use DDP; p $sub_to_next;
        
        if( number_of_lines($sub_to_next) > 5 ) {
            # the length between this even and the next is greater than 5
            #$sub_to_next =~ s/\A(([^\n]*\n){,5})(.*\n)*\z/$1/gs; # get the next 5 lines
            $sub_to_next = join("\n", ((split /\n/, $sub_to_next)[0..4]));
            #use DDP; p $sub_to_next;
        }
        $this_event->{desc} = $sub_to_next;
        push @$filtered_events, $this_event;
    }
    use DDP; p $filtered_events;
    undef;
}

sub number_of_lines {
    my ($str) = @_;
    scalar( @{[ $str =~ /\n/g ]} );
}

1;
