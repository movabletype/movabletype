# ---------------------------------------------------------------------------
# This software is provided as-is.
# You may use it for commercial or personal use.
# If you distribute it, please keep this notice intact.
#
# Original Copyright (c) 2002 Brad Choate
# ---------------------------------------------------------------------------
# Modifications and integration Copyright 2002-2006 Six Apart.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Sanitize;
use strict;

use MT::Util qw(decode_html);

sub parse_spec {
    my $class = shift;
    my($a) = @_;
    my(%ok_tags, %tag_attr);
    for my $rule (split /\s*,\s*/, $a) {
        my(%ok_attr, $tag, $style);
        $tag = lc $rule;
        if ($tag =~ m|^([^\s]+)\s+(.+)$|) {
            ($tag, my($attrs)) = ($1, $2);
            $style = $1 if $tag =~ s|(/)$||;
            %ok_attr = map { $_ => 1 } split /\s+/, $attrs;
        } else {
            $style = $1 if $tag =~ s|(/)$||;
        }
        $tag_attr{$tag} = $style if $style;
        $ok_tags{$tag} = keys %ok_attr ? \%ok_attr : 1;
    }
    { ok => \%ok_tags, tag_attr => \%tag_attr }
}

my %Strip = (
    '%' => '%>',
    '?' => '?>',
    '!--' => '-->',
);
my $Strip_RE = join '|', map quotemeta($_), keys %Strip;

sub sanitize {
    my $class = shift;
    my($s, $arg) = @_;
    $arg = '1' unless defined $arg;
    return $s if $arg eq '0';
    unless (!$arg || ref($arg)) {
        $arg = $class->parse_spec($arg);
    }
    my $ok_tags = $arg->{ok};
    my $tag_attr = $arg->{tag_attr};
    my(@open_tags, %open_tags);
    my $out = '';
    my $start = 0;
    my $last_pos = 0;
    my $seq = 0;
    while ($s =~ m|<|gs) {
        my $start = (pos $s) - 1;
        my $inside = substr($s, $start + 1, 5); # 5 chars should do it...
        if ($last_pos < $start) {
            $out .= substr($s, $last_pos, $start - $last_pos);
        }
        if ($inside =~ m|^($Strip_RE)|) {
            my $tag = $1;
            pos $s = $start + length($tag) + 1;
            if ($s =~ m|\Q$Strip{$tag}\E|gs) {
                $last_pos = pos $s;
            } else {
                # can't find the closure.
                $last_pos = pos $s;
                last;
            }
        } elsif ($inside =~ m|^[<>]|) {
            $last_pos = $start + 1;
        } elsif ($s =~ m|(.+?)>|gs) {
            $inside = $1;
            $last_pos = pos $s;
            my $name;
            my $closure = 0;
            if ($inside =~ m/^([^ ]+) (.+)$/s) {
                $name = lc($1);
                $inside = $2;
            } else {
                $name = lc($inside);
                $inside = '';
            }
            if ($name =~ m|^/|) {
                $name =~ s|^/||;
                $closure = 1;
            }
            if ($inside =~ m|/$|s) {
                $inside =~ s|/$||s;
                $closure = 2;
            }
            if ($ok_tags->{$name} ||
                (exists $tag_attr->{$name} && $tag_attr->{$name} eq '/')) {
                if ($inside) {
                    my @attrs;
                    while ($inside =~ m/([:\w]+)\s*=\s*(['"])(.*?)\2/gs) {  #"'
                        my ($attr, $q, $val) = (lc($1), $2, $3);
                        if ($ok_tags->{'*'}{$attr} ||
                           (ref $ok_tags->{$name} && $ok_tags->{$name}{$attr})) {
                            my $dec_val = decode_html($val);
                            if ($attr =~ m/^(src|href|dynsrc)$/) {
                                $dec_val =~ s/&#0*58(?:=;|[^0-9])/:/;
                                $dec_val =~ s/&#x0*3[Aa](?:=;|[^a-fA-F0-9])/:/;

                                if ((my $prot) = $dec_val =~ m/^(.+?):/) {
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
                if (exists $tag_attr->{$name} && ($tag_attr->{$name} eq '/')) {
                    $closure = 2;
                }
                if ($closure != 1 || ($closure == 1 && $open_tags{$name})) {
                    if ($closure == 1) {
                        $out .= _expel_up_to(\@open_tags, \%open_tags, $name);
                    } elsif (!$closure) {
                        ###if (@open_tags &&
                        ###    ($open_tags{$name}) &&
                        ###    (exists $tag_attr{$name}) &&
                        ###    ($tag_attr{$name} eq '!')) {
                        ###    # unnestable tag-- expel stuff
                        ###    $out .= _expel_up_to(\@open_tags, \%open_tags, $name);
                        ###    $out .= '</' . $name . '>';
                        ###}
                        push @open_tags, $name;
                        $open_tags{$name}++; 
                    }
                    $out .= '<'.($closure==1?'/':'').
                        $name.
                        ($inside ? ' '.$inside : '').
                        ($closure==2?' /':'').'>';
                    if ($closure == 1) {
                        $open_tags{$name}--;
                    }
                }
            }
        } else {
            last;
        }
    }
    if (defined $last_pos && ($last_pos < length($s))) {
        $out .= substr($s, $last_pos);
    }
    for my $tag (@open_tags) {
        $out .= '</' . $tag . '>';
    }
    $out;
}

sub _expel_up_to {
    my ($open_tags, $open_hash, $stop_tag) = @_;
    my $out = '';
    while (@$open_tags &&
           (!defined $stop_tag || $open_tags->[$#$open_tags] ne $stop_tag)) {
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

=cut
