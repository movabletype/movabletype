package URI::_idna;

# This module implements the RFCs 3490 (IDNA) and 3491 (Nameprep)
# based on Python-2.6.4/Lib/encodings/idna.py

use strict;
use warnings;

use URI::_punycode     qw(decode_punycode encode_punycode);
use Unicode::Normalize qw(NFC);
use Carp               qw(croak);

our $VERSION = '5.36';

BEGIN {
    *URI::_idna::_ENV_::JOIN_LEAKS_UTF8_FLAGS
        = "$]" < 5.008_003 ? sub () {1} : sub () {0};
}

my $ASCII = qr/^[\x00-\x7F]*\z/;

sub encode {
    my $idomain = shift;
    my @labels  = split(/\./, $idomain, -1);
    my @last_empty;
    push(@last_empty, pop @labels) if @labels > 1 && $labels[-1] eq "";
    for (@labels) {
        $_ = ToASCII($_);
    }

    return eval 'join(".", @labels, @last_empty)'
        if URI::_idna::_ENV_::JOIN_LEAKS_UTF8_FLAGS;
    return join(".", @labels, @last_empty);
}

sub decode {
    my $domain = shift;
    return join(".", map ToUnicode($_), split(/\./, $domain, -1));
}

sub nameprep {
    my $label = shift;

    # Lowercase, then normalize. Without normalization a non-NFC label encodes
    # to a non-standard A-label that other IDNA implementations reject, so a
    # host used for a security check can differ from the host actually fetched.
    # We normalize with NFC (canonical composition): RFC 3491 (IDNA2003)
    # nominally called for NFKC, but RFC 5891 (IDNA2008) replaced that with NFC,
    # which is also what UTS #46 applies in browsers and other clients. The
    # prohibited-character and bidi tables that a full nameprep would enforce
    # remain unimplemented. A host passed as bytes rather than decoded
    # characters is treated as Latin-1 per URI's documented contract (see the
    # host/ihost examples in URI.pm), so pass decoded characters for UTF-8.
    return NFC(lc $label);
}

sub check_size {
    my $label = shift;
    croak "Label empty"    if $label eq "";
    croak "Label too long" if length($label) > 63;
    return $label;
}

sub ToASCII {
    my $label = shift;
    return check_size($label) if $label =~ $ASCII;

    # Step 2: nameprep
    $label = nameprep($label);

    # Step 3: UseSTD3ASCIIRules is false
    # Step 4: try ASCII again
    return check_size($label) if $label =~ $ASCII;

    # Step 5: Check ACE prefix
    if ($label =~ /^xn--/) {
        croak "Label starts with ACE prefix";
    }

    # Step 6: Encode with PUNYCODE
    $label = encode_punycode($label);

    # Step 7: Prepend ACE prefix
    $label = "xn--$label";

    # Step 8: Check size
    return check_size($label);
}

sub ToUnicode {
    my $label = shift;
    $label = nameprep($label) unless $label =~ $ASCII;
    return $label unless $label =~ /^xn--/;
    my $result = decode_punycode(substr($label, 4));
    my $label2 = ToASCII($result);
    if (lc($label) ne $label2) {
        croak "IDNA does not round-trip: '\L$label\E' vs '$label2'";
    }
    return $result;
}

1;
