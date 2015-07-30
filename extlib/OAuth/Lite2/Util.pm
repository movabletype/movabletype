package OAuth::Lite2::Util;

use strict;
use warnings;

use base 'Exporter';
use URI::Escape;
use Scalar::Util qw(blessed);
use Hash::MultiValue;

our %EXPORT_TAGS = ( all => [qw(
    encode_param
    decode_param
    parse_content
    build_content
)] );

our @EXPORT_OK = map { @$_ } values %EXPORT_TAGS;

=head1 NAME

OAuth::Lite2::Util - utility methods for OAuth 2.0

=head1 SYNOPSIS

    use OAuth::Lite2::Util qw(encode_param, decode_param);
    my $encoded = encode_param($str);
    my $origin = decode_param($encoded);

=head1 DESCRIPTION

This module exports utility methods for OAuth 2.0.

=head1 METHODS

=head2 encode_param ($str)

=cut

sub encode_param {
    my $param = shift;
    return URI::Escape::uri_escape($param, '^\w.~-');
}

=head2 decode_param ($str)

=cut

sub decode_param {
    my $param = shift;
    return URI::Escape::uri_unescape($param);
}

=head2 parse_content ($content)

=cut

sub parse_content {
    my $content = shift;
    my $params  = Hash::MultiValue->new;
    for my $pair (split /\&/, $content) {
        my ($key, $value) = split /\=/, $pair;
        $key   = decode_param($key  ||'');
        $value = decode_param($value||'');
        $params->add($key, $value);
    }
    return $params;
}

=head2 build_content ($params)

=cut

sub build_content {
    my $params = shift;
    $params = $params->as_hashref_mixed
        if blessed($params) && $params->isa('Hash::MultiValue');
    my @pairs;
    for my $key (keys %$params) {
        my $k = encode_param($key);
        my $v = $params->{$key};
        if (ref($v) eq 'ARRAY') {
            for my $av (@$v) {
                push(@pairs, sprintf(q{%s=%s}, $k, encode_param($av)));
            }
        } else {
            push(@pairs, sprintf(q{%s=%s}, $k, encode_param($v)));
        }
    }
    return join("&", sort @pairs);
}

1;

=head1 AUTHOR

Lyo Kato, E<lt>lyo.kato@gmail.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2010 by Lyo Kato

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.

=cut
