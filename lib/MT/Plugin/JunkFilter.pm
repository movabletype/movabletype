# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Plugin::JunkFilter;

use strict;
use warnings;

use MT::Plugin;
@MT::Plugin::JunkFilter::ISA = qw( MT::Plugin );

use MT::JunkFilter qw(:constants);
use MT::Util qw(extract_urls);

sub new {
    my $class = shift || __PACKAGE__;
    my $self = $class->SUPER::new(@_);
    $self->{tests} = [];
    $self->{rules} = [];
    $self;
}

sub add_test {
    my $self = shift;
    my ($param) = @_;
    if ( ref $param eq 'ARRAY' ) {
        push @{ $self->{tests} }, @$param;
    }
    elsif ( ref $param eq 'HASH' ) {
        push @{ $self->{tests} }, $param;
    }
    $self;
}

sub add_rule {
    my $self = shift;
    my ($param) = @_;
    if ( ref $param eq 'ARRAY' ) {
        push @{ $self->{rules} }, @$param;
    }
    elsif ( ref $param eq 'HASH' ) {
        push @{ $self->{rules} }, $param;
    }
    $self;
}

sub rules {
    $_[0]->{rules};
}

sub tests {
    $_[0]->{tests};
}

sub parse_domains {
    my $self  = shift;
    my ($obj) = @_;
    my $text  = $obj->column('text') || $obj->column('excerpt') || '';
    my $url   = $obj->column('url') || $obj->column('source_url') || '';
    $text .= ' ' . $url;
    my %domains = MT::Util::extract_urls($text);
    values %domains;
}

sub all_text {
    my $self  = shift;
    my ($obj) = @_;
    my $text  = $obj->column('author') || $obj->column('blog_name') || '';
    $text .= "\n" . ( $obj->column('email') || '' );
    $text
        .= "\n" . ( $obj->column('url') || $obj->column('source_url') || '' );
    $text .= "\n" . ( $obj->column('text') || $obj->column('excerpt') || '' );
    $text;
}

sub score_rules {
    my $self = shift;
    my ($obj) = @_;

    my $total = 0;
    my $rules = $self->rules;
    my @log;
    foreach my $rule (@$rules) {
        my $type  = $rule->{type};
        my $test  = $rule->{test};
        my $score = $rule->{score};
        my $meth  = "rule_$type";
        if ( $self->can($meth) ) {
            if ( my $result = $self->$meth( $obj, $test ) ) {
                $total += $score;
                push @log,
                    MT->translate(
                    '[_1]: [_2][_3] from rule [_4][_5]',
                    $self->{name}, ( $score < 0 ? '' : '+' ),
                    $score, $type, $test
                    );
            }
        }
    }
    if (@log) {
        ( $total, \@log );
    }
    else {
        ( ABSTAIN, undef );
    }
}

sub score {
    my $self = shift;
    my ($obj) = @_;

    my $tests = [ @{ $self->tests } ];
    my $total = 0;
    my @log;
    push @$tests, { code => 'score_rules' } if ( $self->rules );
    foreach (@$tests) {
        my $meth = $_->{code};
        my ( $score, $log )
            = ref $meth eq 'CODE'
            ? $meth->( $self, $obj )
            : $self->$meth($obj);
        $score = ABSTAIN unless defined $score;
        if ( $score !~ m/\d/ ) {
            $score = -1  if $score eq HAM;
            $score = 1   if $score eq SPAM;
            $score = -10 if $score eq APPROVE;
            $score = 10  if $score eq JUNK;
        }
        if ( $score =~ m/\d/ ) {
            $total += $score;
        }
        if ( $log && @$log ) {
            push @log, @$log;
        }
        else {
            if ( $score ne ABSTAIN ) {
                push @log,
                    MT->translate(
                    '[_1]: [_2][_3] from test [_4]',
                    $self->{name}, ( $score < 0 ? '' : '+' ),
                    $score, $_->{name}
                    );
            }
        }
    }
    if (@log) {
        ( $total, \@log );
    }
    else {
        ( ABSTAIN, undef );
    }
}

sub rule_body {
    my ( $self, $obj, $test ) = @_;
    my $text = $self->all_text($obj);
    if ( $test =~ m!^/! ) {
        my $re = $test;
        my ($opt) = $re =~ m!/([^/]*)$!;
        $re =~ s!^/!!;
        $re =~ s!/[^/]*$!!;
        $re = '(?' . $opt . ':' . $re . ')' if $opt;
        $re = eval {qr/$re/};
        $re = '\b' . quotemeta($test) . '\b' if $@;
        return 'Match on pattern: ' . $test if $text =~ m/$re/;
        return 'Match on pattern: ' . $test
            if $self->decode_entities($text) =~ m/$re/;
    }
    else {
        my $re = '\b' . quotemeta($test) . '\b';
        return 'Match on phrase: ' . $test if $text =~ m/$re/i;
        return 'Match on phrase: ' . $test
            if $self->decode_entities($text) =~ m/$re/i;
    }
    0;
}

sub decode_entities {
    my ($str) = @_;
    $str = shift if ref $str;    # in case we're called like a method...
    $str ||= '';
    if ( eval { require HTML::Entities; 1 } ) {
        return HTML::Entities::decode($str);
    }
    else {

        # yanked from HTML::Entities, since some users don't have the module
        my $c;
        for ($str) {
            s/(&\#(\d+);?)/$2 < 256 ? chr($2) : $1/eg;
            s/(&\#[xX]([0-9a-fA-F]+);?)/$c = hex($2); $c < 256 ? chr($c) : $1/eg;
        }
        $str;
    }
}

1;
__END__

=head1 NAME

MT::Plugin::JunkFilter

=head1 METHODS

TODO

=head1 AUTHOR & COPYRIGHT

Please see L<MT/AUTHOR & COPYRIGHT>.

=cut
