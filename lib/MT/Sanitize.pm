# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

# Original Copyright (c) 2002 Brad Choate

package MT::Sanitize;
use strict;
use warnings;

use MT::Util qw(decode_html);

sub parse_spec {
    my $class = shift;
    my ($a) = @_;
    my ( %ok_tags, %tag_attr );
    for my $rule ( split /\s*,\s*/, $a ) {
        my ( %ok_attr, $tag, $style );
        $tag = lc $rule;
        if ( $tag =~ m|^([^\s]+)\s+(.+)$| ) {
            ( $tag, my ($attrs) ) = ( $1, $2 );
            $style = $1 if $tag =~ s|(/)$||;
            %ok_attr = map { $_ => 1 } split /\s+/, $attrs;
        }
        else {
            $style = $1 if $tag =~ s|(/)$||;
        }
        $tag_attr{$tag} = $style if $style;
        $ok_tags{$tag} = keys %ok_attr ? \%ok_attr : 1;
    }
    { ok => \%ok_tags, tag_attr => \%tag_attr };
}

my %Strip = (
    '%'   => '%>',
    '?'   => '?>',
    '!--' => '-->',
);
my $Strip_RE = join '|', map quotemeta($_), keys %Strip;
my $InvalidAttribute_RE
    = qr#@{[join '|', map quotemeta("<$_"), keys %Strip]}#;

sub sanitize {
    my $class = shift;
    my ( $s, $arg ) = @_;
    $s = '' unless defined $s;
    $s =~ tr/\x00//d;
    $arg = '1' unless defined $arg;
    return $s if $arg eq '0' || $arg eq '';
    unless ( !$arg || ref($arg) ) {
        $arg = $class->parse_spec($arg);
    }
    my $ok_tags  = $arg->{ok};
    my $tag_attr = $arg->{tag_attr};
    my ( @open_tags, %open_tags );
    my $out      = '';
    my $start    = 0;
    my $last_pos = 0;
    my $seq      = 0;

    while ( $s =~ m|<|gs ) {
        my $start = ( pos $s ) - 1;
        my $inside = substr( $s, $start + 1, 5 );    # 5 chars should do it...
        if ( $last_pos < $start ) {
            $out .= substr( $s, $last_pos, $start - $last_pos );
        }
        if ( $inside =~ m|^($Strip_RE)| ) {
            my $tag = $1;
            pos $s = $start + length($tag) + 1;
            if ( $s =~ m|\Q$Strip{$tag}\E|gs ) {
                $last_pos = pos $s;
            }
            else {

                # can't find the closure.
                $last_pos = pos $s;
                last;
            }
        }
        elsif ( $inside =~ m|^[<>]| ) {
            $last_pos = $start + 1;
        }
        elsif ( $s =~ m|(.+?)>|gs ) {
            $inside   = $1;
            $last_pos = pos $s;
            my $name;
            my $closure = 0;
            if ( $inside =~ m/^([^ ]+) (.+)$/s ) {
                $name   = lc($1);
                $inside = $2;
            }
            else {
                $name   = lc($inside);
                $inside = '';
            }
            if ( $name =~ m|^/| ) {
                $name =~ s|^/||;
                $closure = 1;
            }
            if ( $inside =~ m|/$|s ) {
                $inside =~ s|/$||s;
                $closure = 2;
            }
            if ( $ok_tags->{$name}
                || ( exists $tag_attr->{$name} && $tag_attr->{$name} eq '/' )
                )
            {
                if ($inside) {
                    my @attrs;
                    while ( $inside =~ m/([:\w]+)\s*=\s*(['"])(.*?)\2/gs ) {
                        my ( $attr, $q, $val ) = ( lc($1), $2, $3 );

                        # javascript event attributes explicitly not allowed
                        next if $attr =~ m/^on/;
                        if ($ok_tags->{'*'}{$attr}
                            || (ref $ok_tags->{$name}
                                && (   $ok_tags->{$name}{'*'}
                                    || $ok_tags->{$name}{$attr} )
                                && !exists( $ok_tags->{$name}{ '!' . $attr } )
                            )
                            )
                        {
                            next if $val =~ $InvalidAttribute_RE;
                            my $dec_val = decode_html($val);
                            if ( $attr =~ m/^(src|href|dynsrc)$/ ) {
                                $dec_val =~ s/&#0*58(?:=;|[^0-9])/:/;
                                $dec_val
                                    =~ s/&#x0*3[Aa](?:=;|[^a-fA-F0-9])/:/;

                                if ( ( my $prot )
                                    = $dec_val =~ m/^([\s\S]+?):/ )
                                {
                                    next if $prot =~ m/[\r\n\t]/;
                                    $prot =~ s/\s+//gs;
                                    next if $prot =~ m/[^a-zA-Z0-9\+]/;
                                    next if $prot =~ m/script$/i;
                                    next if $prot =~ m/&#/;
                                }
                            }
                            push @attrs, qq{$attr=$q$val$q};
                        }
                    }
                    $inside = @attrs ? join ' ', @attrs : '';
                }
                if ( exists $tag_attr->{$name}
                    && ( $tag_attr->{$name} eq '/' ) )
                {
                    $closure = 2;
                }
                if ( $closure != 1 || ( $closure == 1 && $open_tags{$name} ) )
                {
                    if ( $closure == 1 ) {
                        $out .= _expel_up_to( \@open_tags, \%open_tags,
                            $name );
                    }
                    elsif ( !$closure ) {
                        ###if (@open_tags &&
                        ###    ($open_tags{$name}) &&
                        ###    (exists $tag_attr{$name}) &&
                        ###    ($tag_attr{$name} eq '!')) {
                        ###    # unnestable tag-- expel stuff
                        ###    $out .= _expel_up_to(\@open_tags, \%open_tags, $name);
                        ###    $out .= '</' . $name . '>';
                        ###}

                        if ( $name
                            !~ /br|wbr|hr|img|col|base|link|meta|input|keygen|area|param|embed|source|track|command/
                            )
                        {
                            push @open_tags, $name;
                            $open_tags{$name}++;
                        }
                    }
                    $out
                        .= '<'
                        . ( $closure == 1 ? '/' : '' )
                        . $name
                        . ( $inside       ? ' ' . $inside : '' )
                        . ( $closure == 2 ? ' /'          : '' ) . '>';
                    if ( $closure == 1 ) {
                        $open_tags{$name}--;
                    }
                }
            }
        }
        else {
            last;
        }
    }
    if ( defined $last_pos && ( $last_pos < length($s) ) ) {
        if ( substr( $s, $last_pos ) !~ m/</ ) {
            $out .= substr( $s, $last_pos );
        }
    }
    if (@open_tags) {
        $out .= _expel_up_to( \@open_tags, \%open_tags, '' );
    }
    $out;
}

sub _expel_up_to {
    my ( $open_tags, $open_hash, $stop_tag ) = @_;
    my $out = '';
    while ( @$open_tags
        && ( !defined $stop_tag || $open_tags->[$#$open_tags] ne $stop_tag ) )
    {
        my $t = pop @$open_tags;
        $open_hash->{$t}--;
        $out .= '</' . $t . '>';
    }
    if (@$open_tags) {
        my $t = pop @$open_tags;
    }
    $out;
}

1;
__END__

=head1 NAME

MT::Sanitize - Sanitize HTML for Safety

=head1 SYNOPSIS

    use MT::Sanitize;
    my $html = <<HTML;
    <a name="foo.html" onclick="evilJS()">foolink</a>
    HTML
    my $str = MT::Sanitize->sanitize($html, 'a href');
    ## $str is now <a href="foo.html">foolink</a>

=head1 METHODS

=head2 parse_spec($tags)

Return a hash reference of allowed tags and their attributes.

=head2 sanitize($text, [0|1|\%args])

"Sanitize" the I<text> with the rules defined in I<args> (or by the
C<parse_spec> method if rules are not provided).

=head1 AUTHOR & COPYRIGHT

Please see L<MT/AUTHOR & COPYRIGHT>.

=cut
