package JSON::PP5005;

use 5.005;
use strict;

my @properties;

$JSON::PP5005::VERSION = '1.07';

BEGIN {
    *JSON::PP::JSON_PP_encode_ascii      = \&_encode_ascii;
    *JSON::PP::JSON_PP_encode_latin1     = \&_encode_latin1;
    *JSON::PP::JSON_PP_decode_surrogates = \&_decode_surrogates;
    *JSON::PP::JSON_PP_decode_unicode    = \&_decode_unicode;


    sub utf8::is_utf8 {
        0; # It is considered that UTF8 flag off for Perl 5.005.
    }

    sub utf8::upgrade {
    }

    sub utf8::downgrade {
        1; # must always return true.
    }

    sub utf8::encode  {
    }

    sub utf8::decode {
    }

    # missing in B module.
    sub B::SVf_IOK () { 0x00010000; }
    sub B::SVf_NOK () { 0x00020000; }
    sub B::SVf_POK () { 0x00040000; }
    sub B::SVp_IOK () { 0x01000000; }
    sub B::SVp_NOK () { 0x02000000; }

    $INC{'bytes.pm'} = 1; # dummy
}



sub _encode_ascii {
    join('', map { $_ <= 127 ? chr($_) : sprintf('\u%04x', $_) } unpack('C*', $_[0]) );
}


sub _encode_latin1 {
    join('', map { chr($_) } unpack('C*', $_[0]) );
}


sub _decode_surrogates { # from http://homepage1.nifty.com/nomenclator/unicode/ucs_utf.htm
    my $uni = 0x10000 + (hex($_[0]) - 0xD800) * 0x400 + (hex($_[1]) - 0xDC00); # from perlunicode
    my $bit = unpack('B32', pack('N', $uni));

    if ( $bit =~ /^00000000000(...)(......)(......)(......)$/ ) {
        my ($w, $x, $y, $z) = ($1, $2, $3, $4);
        return pack('B*', sprintf('11110%s10%s10%s10%s', $w, $x, $y, $z));
    }
    else {
        Carp::croak("Invalid surrogate pair");
    }
}


sub _decode_unicode {
    my ($u) = @_;
    my ($utf8bit);
    my $bit = unpack("B*", pack("H*", $u));

    if ( $bit =~ /^00000(.....)(......)$/ ) {
        $utf8bit = sprintf('110%s10%s', $1, $2);
    }
    elsif ( $bit =~ /^(....)(......)(......)$/ ) {
        $utf8bit = sprintf('1110%s10%s10%s', $1, $2, $3);
    }
    else {
        Carp::croak("Invalid escaped unicode");
    }

    return pack('B*', $utf8bit);
}


sub _is_valid_utf8 {
    my $str = $_[0];
    my $is_utf8;

    while ($str =~ /(?:
          (
             [\x00-\x7F]
            |[\xC2-\xDF][\x80-\xBF]
            |[\xE0][\xA0-\xBF][\x80-\xBF]
            |[\xE1-\xEC][\x80-\xBF][\x80-\xBF]
            |[\xED][\x80-\x9F][\x80-\xBF]
            |[\xEE-\xEF][\x80-\xBF][\x80-\xBF]
            |[\xF0][\x90-\xBF][\x80-\xBF][\x80-\xBF]
            |[\xF1-\xF3][\x80-\xBF][\x80-\xBF][\x80-\xBF]
            |[\xF4][\x80-\x8F][\x80-\xBF][\x80-\xBF]
          )
        | (.)
    )/xg)
    {
        if (defined $1) {
            $is_utf8 = 1 if (!defined $is_utf8);
        }
        else {
            $is_utf8 = 0 if (!defined $is_utf8);
            if ($is_utf8) { # eventually, not utf8
                return;
            }
        }
    }

    return $is_utf8;
}


sub JSON::PP::incr_parse {
    local $Carp::CarpLevel = 1;
    ( $_[0]->{_incr_parser} ||= JSON::PP::IncrParser->new )->incr_parse( @_ );
}


sub JSON::PP::incr_text {
    $_[0]->{_incr_parser} ||= JSON::PP::IncrParser->new;

    if ( $_[0]->{_incr_parser}->{incr_parsing} ) {
        Carp::croak("incr_text can not be called when the incremental parser already started parsing");
    }

    $_[0]->{_incr_parser}->{incr_text} = $_[1] if ( @_ > 1 );
    $_[0]->{_incr_parser}->{incr_text};
}


sub JSON::PP::incr_skip {
    ( $_[0]->{_incr_parser} ||= JSON::PP::IncrParser->new )->incr_skip;
}


sub JSON::PP::incr_reset {
    ( $_[0]->{_incr_parser} ||= JSON::PP::IncrParser->new )->incr_reset;
}


1;
__END__

=pod

=head1 NAME

JSON::PP5005 - Helper module in using JSON::PP in Perl 5.005

=head1 DESCRIPTION

JSON::PP calls internally.

=head1 AUTHOR

Makamaka Hannyaharamitu, E<lt>makamaka[at]cpan.orgE<gt>


=head1 COPYRIGHT AND LICENSE

Copyright 2007-2008 by Makamaka Hannyaharamitu

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself. 

=cut

