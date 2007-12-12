
package MIME::Charset;
use 5.005;

=head1 NAME

MIME::Charset - Charset Informations for MIME

=head1 SYNOPSIS

Getting charset informations:

    use MIME::Charset qw(:info);

    $benc = body_encoding("iso-8859-2"); # "Q"
    $cset = canonical_charset("ANSI X3.4-1968"); # "US-ASCII"
    $henc = header_encoding("utf-8"); # "S"
    $cset = output_charset("shift_jis"); # "ISO-2022-JP"

Translating text data:

    use MIME::Charset qw(:trans);

    ($text, $charset, $encoding) =
        header_encode(
           "\xc9\xc2\xc5\xaa\xc0\xde\xc3\xef\xc5\xaa".
           "\xc7\xd1\xca\xaa\xbd\xd0\xce\xcf\xb4\xef",
           "euc-jp");
    # ...returns (<converted>, "ISO-2022-JP", "B");

    ($text, $charset, $encoding) =
        body_encode(
            "Collectioneur path\xe9tiquement ".
            "\xe9clectique de d\xe9chets",
            "latin1");
    # ...returns (<original>, "ISO-8859-1", "QUOTED-PRINTABLE");

    $len = encoded_header_len(
        "Perl\xe8\xa8\x80\xe8\xaa\x9e", "b", "utf-8"); # 28

Manipulating module defaults:

    use MIME::Charset;

    MIME::Charset::alias("csEUCKR", "euc-kr");
    MIME::Charset::default("iso-8859-1");
    MIME::Charset::fallback("us-ascii");

=head1 DESCRIPTION

MIME::Charset provides informations about character sets used for
MIME messages on Internet.

=head2 DEFINITIONS

The B<charset> is ``character set'' used in MIME to refer to a
method of converting a sequence of octets into a sequence of characters.
It includes both concepts of ``coded character set'' (CCS) and
``character encoding scheme'' (CES) of ISO/IEC.

The B<encoding> is that used in MIME to refer to a method of representing
a body part or a header body as sequence(s) of printable US-ASCII
characters.

=over 4

=cut

use strict;
use vars qw(@ISA $VERSION @EXPORT @EXPORT_OK %EXPORT_TAGS);
use Exporter;
@ISA = qw(Exporter);
@EXPORT = qw(body_encoding canonical_charset header_encoding output_charset
	     body_encode encoded_header_len header_encode);
@EXPORT_OK = qw(alias default fallback recommended);
%EXPORT_TAGS = (
		"info" => [qw(body_encoding header_encoding
			      canonical_charset output_charset)],
		"trans" =>[ qw(body_encode encoded_header_len
			       header_encode)],
		);
use Carp qw(croak);

use constant USE_ENCODE => ($] >= 5.008001)? 'Encode': '';

my @ENCODE_SUBS = qw(FB_CROAK FB_PERLQQ FB_HTMLCREF FB_XMLCREF
		     decode encode from_to is_utf8 resolve_alias);
if (USE_ENCODE) {
    eval "use ".USE_ENCODE." \@ENCODE_SUBS;";
} else {
    require MIME::Charset::_Compat;
    for my $sub (@ENCODE_SUBS) {
	no strict "refs";
	*{$sub} = \&{"MIME::Charset::_Compat::$sub"};
    }
}

$VERSION = '0.044';

######## Private Attributes ########

my $DEFAULT_CHARSET = 'US-ASCII';
my $FALLBACK_CHARSET = 'UTF-8';

# This table was borrwed from Python email package.

my %CHARSETS = (# input		    header enc body enc output conv
		'ISO-8859-1' =>		['Q',	'Q',	undef],
		'ISO-8859-2' =>		['Q',	'Q',	undef],
		'ISO-8859-3' =>		['Q',	'Q',	undef],
		'ISO-8859-4' =>		['Q',	'Q',	undef],
		# ISO-8859-5 is Cyrillic, and not especially used
		# ISO-8859-6 is Arabic, also not particularly used
		# ISO-8859-7 is Greek, 'Q' will not make it readable
		# ISO-8859-8 is Hebrew, 'Q' will not make it readable
		'ISO-8859-9' =>		['Q',	'Q',	undef],
		'ISO-8859-10' =>	['Q',	'Q',	undef],
		# ISO-8859-11 is Thai, 'Q' will not make it readable
		'ISO-8859-13' =>	['Q',	'Q',	undef],
		'ISO-8859-14' =>	['Q',	'Q',	undef],
		'ISO-8859-15' =>	['Q',	'Q',	undef],
		'WINDOWS-1252' =>	['Q',	'Q',	undef],
		'VISCII' =>		['Q',	'Q',	undef],
		'US-ASCII' =>		[undef,	undef,	undef],
		'BIG5' =>		['B',	'B',	undef],
		'GB2312' =>		['B',	'B',	undef],
		'EUC-JP' =>		['B',	undef,	'ISO-2022-JP'],
		'SHIFT_JIS' =>		['B',	undef,	'ISO-2022-JP'],
		'ISO-2022-JP' =>	['B',	undef,	undef],
		'KOI8-R' =>		['B',	'B',	undef],
		'UTF-8' =>		['S',	'B',	undef],
		# We're making this one up to represent raw unencoded 8bit
		'8BIT' =>		[undef,	'B',	'ISO-8859-1'],
		);

# Fix some unexpected or unpreferred names returned by
# Encode::resolve_alias() or used by somebodies else.
my %CHARSET_ALIASES = (# unpreferred		preferred
		       "ASCII" =>		"US-ASCII",
		       "BIG5-ETEN" =>		"BIG5",
		       "CP1251" =>		"WINDOWS-1251",
		       "CP1252" =>		"WINDOWS-1252",
		       "CP936" =>		"GBK",
		       "CP949" =>		"KS_C_5601-1987",
		       "EUC-CN" =>		"GB2312",
		       "KS_C_5601" =>		"KS_C_5601-1987",
		       "SHIFTJIS" =>		"SHIFT_JIS",
		       "SHIFTJISX0213" =>	"SHIFT_JISX0213",
		       "UNICODE-1-1-UTF-7" =>	"UTF-7",
		       "UTF8" =>		"UTF-8",
		       "UTF-8-STRICT" =>	"UTF-8",
		       );

# ISO-2022-* escape sequnces to detect charset from unencoded data.
my @ISO2022_SEQ = (# escape seq	possible charset
		   # Following sequences are commonly used.
		   ["\033\$\@",	"ISO-2022-JP"],	# RFC 1468
		   ["\033\$B",	"ISO-2022-JP"],	# ditto
		   ["\033(J",	"ISO-2022-JP"],	# ditto
		   ["\033(I",	"ISO-2022-JP"],	# ditto (nonstandard)
		   ["\033\$(D",	"ISO-2022-JP"],	# RFC 2237 (note*)
		   # Folloing sequences are less commonly used.
		   ["\033\$)C",	"ISO-2022-KR"],	# RFC 1557
		   ["\033\$)A",	"ISO-2022-CN"], # RFC 1922
		   ["\033\$A",	"ISO-2022-CN"], # ditto (nonstandard)
		   ["\033\$)G",	"ISO-2022-CN"], # ditto
		   ["\033\$*H",	"ISO-2022-CN"], # ditto
		   # Other sequences will be used with appropriate charset
		   # parameters, or hardly used.
		   );

		   # note*: This RFC defines ISO-2022-JP-1, superset of
		   # ISO-2022-JP.  But that charset name is rarely used.
		   # OTOH many of codecs for ISO-2022-JP recognize this
		   # sequence so that comatibility with EUC-JP will be
		   # guaranteed.

######## Private Constants ########

my $NONASCIIRE = qr{
    [^\x01-\x7e]
}x;

my $ISO2022RE = qr{
    ^ISO-2022-
}ix;


######## Public Functions ########

=head2 GETTING INFORMATIONS OF CHARSETS

=item body_encoding CHARSET

Get recommended transfer-encoding of CHARSET for message body.

Returned value will be one of C<"B"> (BASE64), C<"Q"> (QUOTED-PRINTABLE) or
C<undef> (might not be transfer-encoded; either 7BIT or 8BIT).  This may
not be same as encoding for message header.

=cut

sub body_encoding($) {
    my $charset = shift;
    return undef unless $charset;
    return (&recommended($charset))[1];
}

=item canonical_charset CHARSET

Get canonical name for charset CHARSET.

=cut

sub canonical_charset($) {
    my $charset = shift;
    return undef unless $charset;
    my $cset = resolve_alias($charset) || $charset;
    return $CHARSET_ALIASES{uc($cset)} || uc($cset);
}

=item header_encoding CHARSET

Get recommended encoding scheme of CHARSET for message header.

Returned value will be one of C<"B">, C<"Q">, C<"S"> (shorter one of either)
or C<undef> (might not be encoded).  This may not be same as encoding
for message body.

=cut

sub header_encoding($) {
    my $charset = shift;
    return undef unless $charset;
    return (&recommended($charset))[0];
}

=item output_charset CHARSET

Get a charset which is compatible with given CHARSET and is recommended
to be used for MIME messages on Internet (if it is known by this module).

When Unicode/multibyte support is disabled (see L<"USE_ENCODE">),
this function will simply
return the result of L<"canonical_charset">.

=cut

sub output_charset($) {
    my $charset = shift;
    return undef unless $charset;
    return (&recommended($charset))[2] || uc($charset);
}

=head2 TRANSLATING TEXT DATA

=item body_encode STRING, CHARSET [, OPTS]

Get converted (if needed) data of STRING and recommended transfer-encoding
of that data for message body.  CHARSET is the charset by which STRING
is encoded.

OPTS may accept following key-value pairs.
B<NOTE>:
When Unicode/multibyte support is disabled (see L<"USE_ENCODE">),
conversion will not be performed.  So these options do not have any effects.

=over 4

=item Replacement => REPLACEMENT

Specifies error handling scheme.  See L<"ERROR HANDLING">.

=item Detect7bit => YESNO

Try auto-detecting 7-bit charset when CHARSET is not given.
Default is C<"YES">.

=back

3-item list of (I<converted string>, I<charset for output>,
I<transfer-encoding>) will be returned.
I<Transfer-encoding> will be either C<"BASE64">, C<"QUOTED-PRINTABLE">,
C<"7BIT"> or C<"8BIT">.  If I<charset for output> could not be determined
and I<converted string> contains non-ASCII byte(s), I<charset for output> will
be C<undef> and I<transfer-encoding> will be C<"BASE64">.
I<Charset for output> will be C<"US-ASCII"> if and only if string does not
contain any non-ASCII bytes.

=cut

sub body_encode {
    my ($encoded, $charset, $cset) = &_text_encode(@_);

    # Determine transfer-encoding.
    my $enc;
    my $dummy = $encoded;
    eval {
	from_to($dummy, $cset, "US-ASCII", FB_CROAK());
    };
    if (!$@ and $dummy eq $encoded) {
	$cset = "US-ASCII";
	$enc = undef;
    } else {
	$@ = '';
	$enc = &body_encoding($charset);
    }

    if (!$enc and $encoded !~ /\x00/) {	# Eliminate hostile NUL character.
        if ($encoded =~ $NONASCIIRE) {	# String contains 8bit char(s).
            $enc = '8BIT';
	} elsif ($cset =~ $ISO2022RE) {	# ISO-2022-* outputs are 7BIT.
            $enc = '7BIT';
        } else {			# Pure ASCII.
            $enc = '7BIT';
            $cset = 'US-ASCII';
        }
    } elsif ($enc eq 'B') {
        $enc = 'BASE64';
    } elsif ($enc eq 'Q') {
        $enc = 'QUOTED-PRINTABLE';
    } else {
        $enc = 'BASE64';
    }
    return ($encoded, $cset, $enc);
}

=item encoded_header_len STRING, ENCODING, CHARSET

Get length of encoded STRING for message header
(without folding).

ENCODING may be one of C<"B">, C<"Q"> or C<"S"> (shorter
one of either C<"B"> or C<"Q">).

=cut

sub encoded_header_len($$$) {
    my $s = shift;
    my $encoding = uc(shift);
    my $charset  = shift;

    my $enclen;
    if ($encoding eq 'Q') {
        $enclen = _enclen_Q($s);
    } elsif ($encoding eq "S") {
        my ($b, $q) = (_enclen_B($s), _enclen_Q($s));
	$enclen = ($b < $q)? $b: $q;
    } else { # "B"
        $enclen = _enclen_B($s);
    }

    length($charset)+$enclen+7;
}

sub _enclen_B($) {
    int((length(shift) + 2) / 3) * 4;
}

sub _enclen_Q($) {
    my $s = shift;
    my @o;
    @o = ($s =~ /(\?|=|_|[^ \x21-\x7e])/gos);
    length($s) + scalar(@o) * 2;
}

=item header_encode STRING, CHARSET [, OPTS]

Get converted (if needed) data of STRING and recommended encoding scheme of
that data for message headers.  CHARSET is the charset by which STRING
is encoded.

OPTS may accept following key-value pairs.
B<NOTE>:
When Unicode/multibyte support is disabled (see L<"USE_ENCODE">),
conversion will not be performed.  So these options do not have any effects.

=over 4

=item Replacement => REPLACEMENT

Specifies error handling scheme.  See L<"ERROR HANDLING">.

=item Detect7bit => YESNO

Try auto-detecting 7-bit charset when CHARSET is not given.
Default is C<"YES">.

=back

3-item list of (I<converted string>, I<charset for output>,
I<encoding scheme>) will be returned.  I<Encoding scheme> will be
either C<"B">, C<"Q"> or C<undef> (might not be encoded).
If I<charset for output> could not be determined and I<converted string>
contains non-ASCII byte(s), I<charset for output> will be C<"8BIT">
(this is I<not> charset name but a special value to represent unencodable
data) and I<encoding scheme> will be C<undef> (should not be encoded).
I<Charset for output> will be C<"US-ASCII"> if and only if string does not
contain any non-ASCII bytes.

=back

=cut

sub header_encode {
    my ($encoded, $charset, $cset) = &_text_encode(@_);
    return ($encoded, '8BIT', undef) unless $cset;

    # Determine encoding scheme.
    my $enc;
    my $dummy = $encoded;
    eval {
	from_to($dummy, $cset, "US-ASCII", FB_CROAK());
    };
    if (!$@ and $dummy eq $encoded) {
	$cset = "US-ASCII";
	$enc = undef;
    } else {
	$@ = '';
	$enc = &header_encoding($charset);
    }

    if (!$enc and $encoded !~ $NONASCIIRE) {
	unless ($cset =~ $ISO2022RE) {	# ISO-2022-* outputs are 7BIT.
            $cset = 'US-ASCII';
        }
    } elsif ($enc eq 'S') {
	if (&encoded_header_len($encoded, "B", $cset) <
	    &encoded_header_len($encoded, "Q", $cset)) {
	    $enc = 'B';
	} else {
	    $enc = 'Q';
	}
    } elsif ($enc !~ /^[BQ]$/) {
        $enc = 'B';
    }
    return ($encoded, $cset, $enc);
}

sub _text_encode {
    my $s = shift;
    my $charset = &canonical_charset(shift);
    my %params = @_;
    my $replacement = uc($params{'Replacement'}) || "DEFAULT";
    my $detect7bit = uc($params{'Detect7bit'}) || "YES";

    if (!$charset) {
	if ($s =~ $NONASCIIRE) {
	    return ($s, undef, undef);
	} elsif ($detect7bit ne "NO") {
	    $charset = &_detect_7bit_charset($s);
	} else {
	    $charset = $DEFAULT_CHARSET;
	} 
    }

    # Unknown charset.
    return ($s, $charset, $charset)
	unless resolve_alias($charset);

    # Encode data by output charset if required.  If failed, fallback to
    # fallback charset.
    my $cset = &output_charset($charset);
    my $encoded;

    if (is_utf8($s) or $s =~ /[^\x00-\xFF]/) {
	if ($replacement =~ /^(?:CROAK|STRICT|FALLBACK)$/) {
	    eval {
		$encoded = $s;
		$encoded = encode($cset, $encoded, FB_CROAK());
	    };
	    if ($@) {
		if ($replacement eq "FALLBACK" and $FALLBACK_CHARSET) {
		    $cset = $FALLBACK_CHARSET;
		    $encoded = $s;
		    $encoded = encode($cset, $encoded);
		    $charset = $cset;
		} else {
		    croak $@;
		}
	    }
	} elsif ($replacement eq "PERLQQ") {
	    $encoded = encode($cset, $s, FB_PERLQQ());
	} elsif ($replacement eq "HTMLCREF") {
	    $encoded = encode($cset, $s, FB_HTMLCREF());
	} elsif ($replacement eq "XMLCREF") {
	    $encoded = encode($cset, $s, FB_XMLCREF());
	} else {
	    $encoded = encode($cset, $s);
	}
    } elsif ($charset ne $cset) {
	$encoded = $s;
	if ($replacement =~ /^(?:CROAK|STRICT|FALLBACK)$/) {
	    eval {
		from_to($encoded, $charset, $cset, FB_CROAK());
	    };
	    if ($@) {
		if ($replacement eq "FALLBACK" and $FALLBACK_CHARSET) {
		    $cset = $FALLBACK_CHARSET;
		    $encoded = $s;
		    from_to($encoded, $charset, $cset);
		    $charset = $cset;
		} else {
		    croak $@;
		}
	    }
        } elsif ($replacement eq "PERLQQ") {
            from_to($encoded, $charset, $cset, FB_PERLQQ());
        } elsif ($replacement eq "HTMLCREF") {
            from_to($encoded, $charset, $cset, FB_HTMLCREF());
        } elsif ($replacement eq "XMLCREF") {
            from_to($encoded, $charset, $cset, FB_XMLCREF());
        } else {
            from_to($encoded, $charset, $cset);
        }
    } else {
        $encoded = $s;
    }

    return ($encoded, $charset, $cset);
}

sub _detect_7bit_charset($) {
    return $DEFAULT_CHARSET unless USE_ENCODE;
    my $s = shift;
    return $DEFAULT_CHARSET unless $s;

    # Try to detect ISO-2022-* escape sequences.
    foreach (@ISO2022_SEQ) {
	my ($seq, $cset) = @$_;
	if (index($s, $seq) >= 0) {
            eval {
		my $dummy = $s;
		decode($cset, $dummy, FB_CROAK());
	    };
	    if ($@) {
		next;
	    }
	    return $cset;
	}
    }

    # How about HZ, VIQR, ...?

    return $DEFAULT_CHARSET;
}

=head2 MANIPULATING MODULE DEFAULTS

=over 4

=item alias ALIAS [, CHARSET]

Get/set charset alias for canonical names determined by
L<"canonical_charset">.

If CHARSET is given and isn't false, ALIAS will be assigned as an alias of
CHARSET.  Otherwise, alias won't be changed.  In both cases,
current charset name that ALIAS is assigned will be returned.

=cut

sub alias ($;$) {
    my $alias = uc(shift);
    my $charset = uc(shift);

    return $CHARSET_ALIASES{$alias} unless $charset;

    $CHARSET_ALIASES{$alias} = $charset;
    return $charset;
}

=item default [CHARSET]

Get/set default charset.

B<Default charset> is used by this module when charset context is
unknown.  Modules using this module are recommended to use this
charset when charset context is unknown or implicit default is
expected.  By default, it is C<"US-ASCII">.

If CHARSET is given and isn't false, it will be set to default charset.
Otherwise, default charset won't be changed.  In both cases,
current default charset will be returned.

B<NOTE>: Default charset I<should not> be changed.

=cut

sub default(;$) {
    my $charset = &canonical_charset(shift);

    if ($charset) {
	croak "Unknown charset '$charset'"
	    unless resolve_alias($charset);
	$DEFAULT_CHARSET = $charset;
    }
    return $DEFAULT_CHARSET;
}

=item fallback [CHARSET]

Get/set fallback charset.

B<Fallback charset> is used by this module when conversion by given
charset is failed and C<"FALLBACK"> error handling scheme is specified.
Modules using this module may use this charset as last resort of charset
for conversion.  By default, it is C<"UTF-8">.

If CHARSET is given and isn't false, it will be set to fallback charset.
If CHARSET is C<"NONE">, fallback charset will be undefined.
Otherwise, fallback charset won't be changed.  In any cases,
current fallback charset will be returned.

B<NOTE>: It I<is> useful that C<"US-ASCII"> is specified as fallback charset,
since result of conversion will be readable without charset informations.

=cut

sub fallback(;$) {
    my $charset = &canonical_charset(shift);

    if ($charset eq "NONE") {
	$FALLBACK_CHARSET = undef;
    } elsif ($charset) {
	croak "Unknown charset '$charset'"
	    unless resolve_alias($charset);
	$FALLBACK_CHARSET = $charset;
    }
    return $FALLBACK_CHARSET;
}

=item recommended CHARSET [, HEADERENC, BODYENC [, ENCCHARSET]]

Get/set charset profiles.

If optional arguments are given and any of them are not false, profiles
for CHARSET will be set by those arguments.  Otherwise, profiles
won't be changed.  In both cases, current profiles for CHARSET will be
returned as 3-item list of (HEADERENC, BODYENC, ENCCHARSET).

HEADERENC is recommended encoding scheme for message header.
It may be one of C<"B">, C<"Q">, C<"S"> (shorter one of either) or
C<undef> (might not be encoded).

BODYENC is recommended transfer-encoding for message body.  It may be
one of C<"B">, C<"Q"> or C<undef> (might not be transfer-encoded).

ENCCHARSET is a charset which is compatible with given CHARSET and
is recommended to be used for MIME messages on Internet.
If conversion is not needed (or this module doesn't know appropriate
charset), ENCCHARSET is C<undef>.

B<NOTE>: This function in the future releases can accept more optional
arguments (for example, properties to handle character widths, line folding
behavior, ...).  So format of returned value may probably be changed.
Use L<"header_encoding">, L<"body_encoding"> or L<"output_charset"> to get
particular profile.

=cut

sub recommended ($;$;$;$) {
    my $charset = &canonical_charset(shift);
    my $henc = uc(shift) || undef;
    my $benc = uc(shift) || undef;
    my $cset = &canonical_charset(shift);

    croak "CHARSET is not specified" unless $charset;
    croak "Unknown header encoding" unless !$henc or $henc =~ /^[BQS]$/;
    croak "Unknown body encoding" unless !$benc or $benc =~ /^[BQ]$/;

    if ($henc or $benc or $cset) {
	$cset = undef if $charset eq $cset;
	my @spec = ($henc, $benc, USE_ENCODE? $cset: undef);
	$CHARSETS{$charset} = \@spec;
	return @spec;
    } else {
	my $spec = $CHARSETS{$charset};
	if ($spec) {
	    return ($$spec[0], $$spec[1], USE_ENCODE? $$spec[2]: undef);
	} else {
	    return ('S', 'B', undef);
	}
    }
}

=head2 CONSTANTS

=item USE_ENCODE

Unicode/multibyte support flag.
Non-null string will be set when Unicode and multibyte support is enabled.
Currently, this flag will be non-null on Perl 5.8.1 or later and
null string on earlier versions of Perl.

=head2 ERROR HANDLING

L<"body_encode"> and L<"header_encode"> accept following C<Replacement>
options:

=item C<"DEFAULT">

Put a substitution character in place of a malformed character.
For UCM-based encodings, <subchar> will be used.

=item C<"FALLBACK">

Try C<"DEFAULT"> scheme using I<fallback charset> (see L<"fallback">).
When fallback charset is undefined and conversion causes error,
code will die on error with an error message.

=item C<"CROAK">

Code will die on error immediately with an error message.
Therefore, you should trap the fatal error with eval{} unless you
really want to let it die on error.
Synonym is C<"STRICT">.

=item C<"PERQQ">

=item C<"HTMLCREF">

=item C<"XMLCREF">

Use C<FB_PERLQQ>, C<FB_HTMLCREF> or C<FB_XMLCREF>
scheme defined by L<Encode> module.

=back

If error handling scheme is not specified or unknown scheme is specified,
C<"DEFAULT"> will be assumed.

=head1 VERSION

Consult $VERSION variable.

Development versions of this module may be found at
L<http://hatuka.nezumi.nu/repos/MIME-Charset/>.

=head1 SEE ALSO

Multipurpose Internet Mail Extensions (MIME).

=head1 AUTHORS

Copyright (C) 2006 Hatuka*nezumi - IKEDA Soji <hatuka(at)nezumi.nu>.

All rights reserved.  This program is free software; you can redistribute
it and/or modify it under the same terms as Perl itself.

=cut

1;
