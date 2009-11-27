#-*- perl -*-

package MIME::EncWords;
require 5.005;

=head1 NAME

MIME::EncWords - deal with RFC 2047 encoded words (improved)

=head1 SYNOPSIS

I<L<MIME::EncWords> is aimed to be another implimentation
of L<MIME::Words> so that it will achive more exact conformance with
RFC 2047 (former RFC 1522) specifications.  Additionally, it contains
some improvements.
Following synopsis and descriptions are inherited from its inspirer,
then added descriptions on improvements (B<**>) or changes and
clarifications (B<*>).>

Before reading further, you should see L<MIME::Tools> to make sure that
you understand where this module fits into the grand scheme of things.
Go on, do it now.  I'll wait.

Ready?  Ok...

    use MIME::EncWords qw(:all);

    ### Decode the string into another string, forgetting the charsets:
    $decoded = decode_mimewords(
          'To: =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@dkuug.dk>',
          );

    ### Split string into array of decoded [DATA,CHARSET] pairs:
    @decoded = decode_mimewords(
          'To: =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@dkuug.dk>',
          );

    ### Encode a single unsafe word:
    $encoded = encode_mimeword("\xABFran\xE7ois\xBB");

    ### Encode a string, trying to find the unsafe words inside it:
    $encoded = encode_mimewords("Me and \xABFran\xE7ois\xBB in town");

=head1 DESCRIPTION

Fellow Americans, you probably won't know what the hell this module
is for.  Europeans, Russians, et al, you probably do.  C<:-)>.

For example, here's a valid MIME header you might get:

      From: =?US-ASCII?Q?Keith_Moore?= <moore@cs.utk.edu>
      To: =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@dkuug.dk>
      CC: =?ISO-8859-1?Q?Andr=E9_?= Pirard <PIRARD@vm1.ulg.ac.be>
      Subject: =?ISO-8859-1?B?SWYgeW91IGNhbiByZWFkIHRoaXMgeW8=?=
       =?ISO-8859-2?B?dSB1bmRlcnN0YW5kIHRoZSBleGFtcGxlLg==?=
       =?US-ASCII?Q?.._cool!?=

The fields basically decode to (sorry, I can only approximate the
Latin characters with 7 bit sequences /o and 'e):

      From: Keith Moore <moore@cs.utk.edu>
      To: Keld J/orn Simonsen <keld@dkuug.dk>
      CC: Andr'e  Pirard <PIRARD@vm1.ulg.ac.be>
      Subject: If you can read this you understand the example... cool!

B<Supplement>: Fellow Americans, Europeans, you probably won't know
what the hell this module is for.  East Asians, et al, you probably do.
C<(^_^)>.

For example, here's a valid MIME header you might get:

      Subject: =?EUC-KR?B?sNTAuLinKGxhemluZXNzKSwgwvzB9ri7seIoaW1w?=
       =?EUC-KR?B?YXRpZW5jZSksILGzuLgoaHVicmlzKQ==?=

The fields basically decode to (sorry, I cannot approximate the
non-Latin multibyte characters with any 7 bit sequences):

      Subject: ???(laziness), ????(impatience), ??(hubris)

=head1 PUBLIC INTERFACE

=over 4

=cut

### Pragmas:
use strict;
use vars qw($VERSION @EXPORT_OK %EXPORT_TAGS @ISA $Config);

### Exporting:
use Exporter;

%EXPORT_TAGS = (all => [qw(decode_mimewords
			   encode_mimeword
			   encode_mimewords)]);
Exporter::export_ok_tags(qw(all));

### Inheritance:
@ISA = qw(Exporter);

### Other modules:
use Carp qw(croak carp);
use MIME::Base64;
use MIME::Charset qw(:trans);

my @ENCODE_SUBS = qw(FB_CROAK is_utf8 resolve_alias);
if (MIME::Charset::USE_ENCODE) {
    eval "use ".MIME::Charset::USE_ENCODE." \@ENCODE_SUBS;";
} else {
    require MIME::Charset::_Compat;
    for my $sub (@ENCODE_SUBS) {
        no strict "refs";
        *{$sub} = \&{"MIME::Charset::_Compat::$sub"};
    }
}

#------------------------------
#
# Globals...
#
#------------------------------

### The package version, both in 1.23 style *and* usable by MakeMaker:
$VERSION = '1.011.1';

### Public Configuration Attributes
$Config = {
    %{$MIME::Charset::Config}, # Detect7bit, Replacement, Mapping
    Charset => 'ISO-8859-1',
    Encoding => 'A',
    Field => undef,
    Folding => "\n",
    MaxLineLen => 76,
    Minimal => 'YES',
};
eval { require MIME::EncWords::Defaults; };

### Private Constants

### Nonprintables (controls + x7F + 8bit):
#my $NONPRINT = "\\x00-\\x1F\\x7F-\\xFF";
my $PRINTABLE = "\\x21-\\x7E";
my $NONPRINT = qr{[^$PRINTABLE]}; # Improvement: Unicode support.
my $UNSAFE = qr{[^\x01-\x20$PRINTABLE]};
my $WIDECHAR = qr{[^\x00-\xFF]};
my $ASCIITRANS = qr{^(?:HZ-GB-2312|UTF-7)$}i;

#------------------------------

# _decode_B STRING
#     Private: used by _decode_header() to decode "B" encoding.
#     Improvement by this module: sanity check on encoded sequence.
sub _decode_B {
    my $str = shift;
    unless ((length($str) % 4 == 0) and
	$str =~ m|^[A-Za-z0-9+/]+={0,2}$|) {
	return undef;
    }
    return decode_base64($str);
}

# _decode_Q STRING
#     Private: used by _decode_header() to decode "Q" encoding, which is
#     almost, but not exactly, quoted-printable.  :-P
sub _decode_Q {
    my $str = shift;
    $str =~ s/_/\x20/g;					# RFC-1522, Q rule 2
    $str =~ s/=([\da-fA-F]{2})/pack("C", hex($1))/ge;	# RFC-1522, Q rule 1
    $str;
}

# _encode_B STRING
#     Private: used by encode_mimeword() to encode "B" encoding.
sub _encode_B {
    my $str = shift;
    encode_base64($str, '');
}

# _encode_Q STRING
#     Private: used by encode_mimeword() to encode "Q" encoding, which is
#     almost, but not exactly, quoted-printable.  :-P
#     Improvement by this module: Spaces are escaped by ``_''.
sub _encode_Q {
    my $str = shift;
    # Restrict characters to those listed in RFC 2047 section 5 (3)
    $str =~ s{[^-!*+/0-9A-Za-z]}{
	$& eq "\x20"? "_": sprintf("=%02X", ord($&))
	}eog;
    $str;
}

#------------------------------

=item decode_mimewords ENCODED, [OPTS...]

I<Function.>
Go through the string looking for RFC-1522-style "Q"
(quoted-printable, sort of) or "B" (base64) encoding, and decode them.

B<In an array context,> splits the ENCODED string into a list of decoded
C<[DATA, CHARSET]> pairs, and returns that list.  Unencoded
data are returned in a 1-element array C<[DATA]>, giving an effective
CHARSET of C<undef>.

    $enc = '=?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@dkuug.dk>';
    foreach (decode_mimewords($enc)) {
        print "", ($_[1] || 'US-ASCII'), ": ", $_[0], "\n";
    }

B<**>
However, adjacent encoded-words with same charset will be concatenated
to handle multibyte sequences safely.

B<*>
Whitespaces surrounding unencoded data will not be stripped so that
compatibility with L<MIME::Words> will be ensured.

B<In a scalar context,> joins the "data" elements of the above
list together, and returns that.  I<Warning: this is information-lossy,>
and probably I<not> what you want, but if you know that all charsets
in the ENCODED string are identical, it might be useful to you.
(Before you use this, please see L<MIME::WordDecoder/unmime>,
which is probably what you want.)
B<**>
See also "Charset" option below.

In the event of a syntax error, $@ will be set to a description
of the error, but parsing will continue as best as possible (so as to
get I<something> back when decoding headers).
$@ will be false if no error was detected.

B<*>
Malformed base64 encoded-words will be kept encoded.
In this case $@ will be set.

Any arguments past the ENCODED string are taken to define a hash of options.
B<**>
When Unicode/multibyte support is disabled
(see L<MIME::Charset/USE_ENCODE>),
these options will not have any effects.

=over 4

=item Charset
B<**>

Name of character set by which data elements in scalar context
will be converted.
The default is no conversion.
If this option is specified as special value C<"_UNICODE_">,
returned value will be Unicode string.

B<Note>:
This feature is still information-lossy, I<except> when C<"_UNICODE_"> is
specified.

=item Detect7bit
B<**>

Try to detect 7-bit charset on unencoded portions.
Default is C<"YES">.

=cut

#=item Field
#
#Name of the mail field this string came from.  I<Currently ignored.>

=item Mapping
B<**>

In scalar context, specify mappings actually used for charset names.
C<"EXTENDED"> uses extended mappings.
C<"STANDARD"> uses standardized strict mappings.
Default is C<"EXTENDED">.

=back

=cut

sub decode_mimewords {
    my $encstr = shift;
    my %params = @_;
    my %Params = &_getparams(\%params,
			     NoDefault => [qw(Charset)], # default is no conv.
			     YesNo => [qw(Detect7bit)],
			     Others => [qw(Mapping)],
			     Obsoleted => [qw(Field)],
			     ToUpper => [qw(Charset Mapping)],
			    );
    my $cset = MIME::Charset->new($Params{Charset},
				  Mapping => $Params{Mapping});
    # unfolding: normalize linear-white-spaces and orphan newlines.
    $encstr =~ s/(?:[\r\n]+[\t ])*[\r\n]+([\t ]|\Z)/$1? " ": ""/eg;
    $encstr =~ s/[\r\n]+/ /g;

    my @tokens;
    $@ = '';           ### error-return

    ### Decode:
    my ($word, $charset, $language, $encoding, $enc, $dec);
    my $spc = '';
    pos($encstr) = 0;
    while (1) {
        last if (pos($encstr) >= length($encstr));
        my $pos = pos($encstr);               ### save it

        ### Case 1: are we looking at "=?..?..?="?
        if ($encstr =~    m{\G             # from where we left off..
                            =\?([^?]*)     # "=?" + charset +
                             \?([bq])      #  "?" + encoding +
                             \?([^?]+)     #  "?" + data maybe with spcs +
                             \?=           #  "?="
			     ([\r\n\t ]*)
                            }xgi) {
	    ($word, $charset, $encoding, $enc) = ($&, $1, lc($2), $3);
	    my $tspc = $4;

	    # RFC 2231 section 5 extension
	    if ($charset =~ s/^([^\*]*)\*(.*)/$1/) {
		$language = $2 || undef;
		$charset ||= undef;
	    } else {
		$language = undef;
	    }

	    if ($encoding eq 'q') {
		$dec = _decode_Q($enc);
	    } else {
		$dec = _decode_B($enc);
	    }
	    unless (defined $dec) {
		$@ .= qq|Illegal sequence in "$word" (pos $pos)\n|;
		push @tokens, [$spc.$word];
		$spc = '';
		next;
	    }

	    if (scalar(@tokens) and
		lc($charset || "") eq lc($tokens[-1]->[1] || "") and
		resolve_alias($charset) and
		(!${tokens[-1]}[2] and !$language or
		 lc(${tokens[-1]}[2]) eq lc($language))) { # Concat words if possible.
		$tokens[-1]->[0] .= $dec;
	    } elsif ($language) {
		push @tokens, [$dec, $charset, $language];
	    } elsif ($charset) {
		push @tokens, [$dec, $charset];
	    } else {
		push @tokens, [$dec];
	    }
	    $spc = $tspc;
            next;
        }

        ### Case 2: are we looking at a bad "=?..." prefix?
        ### We need this to detect problems for case 3, which stops at "=?":
        pos($encstr) = $pos;               # reset the pointer.
        if ($encstr =~ m{\G=\?}xg) {
            $@ .= qq|unterminated "=?..?..?=" in "$encstr" (pos $pos)\n|;
            push @tokens, [$spc.'=?'];
	    $spc = '';
            next;
        }

        ### Case 3: are we looking at ordinary text?
        pos($encstr) = $pos;               # reset the pointer.
        if ($encstr =~ m{\G                # from where we left off...
                         (.*?              #   shortest possible string,
                          \n*)             #   followed by 0 or more NLs,
                         (?=(\Z|=\?))      # terminated by "=?" or EOS
                        }xgs) {
            length($1) or croak "MIME::EncWords: internal logic err: empty token\n";
            push @tokens, [$spc.$1];
	    $spc = '';
            next;
        }

        ### Case 4: bug!
        croak "MIME::EncWords: unexpected case:\n($encstr) pos $pos\n\t".
            "Please alert developer.\n";
    }
    push @tokens, [$spc] if $spc;

    # Detect 7-bit charset
    if ($Params{Detect7bit} ne "NO") {
	foreach my $t (@tokens) {
	    unless ($t->[0] =~ $UNSAFE or $t->[1]) {
		my $charset = MIME::Charset::_detect_7bit_charset($t->[0]);
		if ($charset and $charset ne &MIME::Charset::default()) {
		    $t->[1] = $charset;
		}
	    }
	}
    }

    return (wantarray ? @tokens : join('',map {
	&_convert($_->[0], $_->[1], $cset, $Params{Mapping})
	} @tokens));
}

#------------------------------

# _convert RAW, FROMCHARSET, TOCHARSET, MAPPING
#     Private: used by decode_mimewords() to convert string by other charset
#     or to decode to Unicode.
#     When source charset is unknown and Unicode string is requested, at first
#     try well-formed UTF-8 then fallback to ISO-8859-1 so that almost all
#     non-ASCII bytes will be preserved.
sub _convert($$$$) {
    my $s = shift;
    my $charset = shift;
    my $cset = shift;
    my $mapping = shift;
    return $s unless MIME::Charset::USE_ENCODE;
    return $s unless $cset->as_string;
    croak "unsupported charset ``".$cset->as_string."''"
	unless $cset->decoder or $cset->as_string eq "_UNICODE_";

    local($@);
    $charset = MIME::Charset->new($charset, Mapping => $mapping);
    if ($charset->as_string and $charset->as_string eq $cset->as_string) {
	return $s;
    }
    # build charset object to transform string from $charset to $cset.
    $charset->encoder($cset);

    my $converted = $s;
    if (is_utf8($s) or $s =~ $WIDECHAR) {
	if ($charset->output_charset ne "_UNICODE_") {
	    $converted = $charset->encode($s);
	}
    } elsif ($charset->output_charset eq "_UNICODE_") {
	if (!$charset->decoder) {
	    if ($s =~ $UNSAFE) {
		$@ = '';
		eval {
		    $charset = MIME::Charset->new("UTF-8",
						  Mapping => 'STANDARD');
		    $converted = $charset->decode($converted, FB_CROAK());
		};
		if ($@) {
		    $converted = $s;
		    $charset = MIME::Charset->new("ISO-8859-1",
						  Mapping => 'STANDARD');
		    $converted = $charset->decode($converted, 0);
		}
	    }
	} else {
	    $converted = $charset->decode($s);
	}
    } elsif ($charset->decoder) {
	$converted = $charset->encode($s);
    }
    return $converted;
}

#------------------------------

=item encode_mimeword RAW, [ENCODING], [CHARSET]

I<Function.>
Encode a single RAW "word" that has unsafe characters.
The "word" will be encoded in its entirety.

    ### Encode "<<Franc,ois>>":
    $encoded = encode_mimeword("\xABFran\xE7ois\xBB");

You may specify the ENCODING (C<"Q"> or C<"B">), which defaults to C<"Q">.
B<**>
You may also specify it as ``special'' value: C<"S"> to choose shorter
one of either C<"Q"> or C<"B">.

You may specify the CHARSET, which defaults to C<iso-8859-1>.

B<*>
Spaces will be escaped with ``_'' by C<"Q"> encoding.

=cut

sub encode_mimeword {
    my $word = shift;
    my $encoding = uc(shift || 'Q');          # not overridden.
    my $charset  = shift || 'ISO-8859-1';     # ditto.
    my $language = uc(shift || "");	      # ditto.

    if (ref $charset) {
	if (is_utf8($word) or $word =~ /$WIDECHAR/) {
	    $word = $charset->undecode($word, 0);
	}
	$charset = $charset->as_string;
    } else {
	$charset = uc($charset);
    }
    my $encstr;
    if ($encoding eq 'Q') {
	$encstr = &_encode_Q($word);
    } elsif ($encoding eq "S") {
	my ($B, $Q) = (&_encode_B($word), &_encode_Q($word));
	if (length($B) < length($Q)) {
	    $encoding = "B";
	    $encstr = $B;
	} else {
	    $encoding = "Q";
	    $encstr = $Q;
	}
    } else { # "B"
	$encoding = "B";
	$encstr = &_encode_B($word);
    }

    if ($language) {
	return "=?$charset*$language?$encoding?$encstr?=";
    } else {
	return "=?$charset?$encoding?$encstr?=";
    }
}

#------------------------------

=item encode_mimewords RAW, [OPTS]

I<Function.>
Given a RAW string, try to find and encode all "unsafe" sequences
of characters:

    ### Encode a string with some unsafe "words":
    $encoded = encode_mimewords("Me and \xABFran\xE7ois\xBB");

Returns the encoded string.

B<**>
RAW may be a Unicode string when Unicode/multibyte support is enabled
(see L<MIME::Charset/USE_ENCODE>).
Furthermore, RAW may be a reference to that returned
by L</decode_mimewords> on array context.  In latter case "Charset"
option (see below) will be overridden (see also a note below).

B<Note>:
B<*>
When RAW is an arrayref,
adjacent encoded-words (i.e. elements having non-ASCII charset element)
are concatenated.  Then they are splitted taking
care of character boundaries of multibyte sequences when Unicode/multibyte
support is enabled.
Portions for unencoded data should include surrounding whitespace(s), or
they will be merged into adjoining encoded-word(s).

Any arguments past the RAW string are taken to define a hash of options:

=over 4

=item Charset

Encode all unsafe stuff with this charset.  Default is 'ISO-8859-1',
a.k.a. "Latin-1".

=item Detect7bit
B<**>

When "Encoding" option (see below) is specified as C<"a"> and "Charset"
option is unknown, try to detect 7-bit charset on given RAW string.
Default is C<"YES">.
When Unicode/multibyte support is disabled,
this option will not have any effects
(see L<MIME::Charset/USE_ENCODE>).

=item Encoding

The encoding to use, C<"q"> or C<"b">.
B<**>
You may also specify ``special'' values: C<"a"> will automatically choose
recommended encoding to use (with charset conversion if alternative
charset is recommended: see L<MIME::Charset>);
C<"s"> will choose shorter one of either C<"q"> or C<"b">.
B<Note>:
B<*>
As of release 1.005, The default was changed from C<"q">
(the default on MIME::Words) to C<"a">.

=item Field

Name of the mail field this string will be used in.
B<**>
Length of mail field name will be considered in the first line of
encoded header.

=item Folding
B<**>

A Sequence to fold encoded lines.  The default is C<"\n">.
If empty string C<""> is specified, encoded-words exceeding line length
(see L</MaxLineLen> below) will be splitted by SPACE.

B<Note>:
B<*>
Though RFC 2822 states that the lines are delimited by CRLF (C<"\r\n">), 
this module chose LF (C<"\n">) as a default to keep backward compatibility.
When you use the default, you might need converting newlines
before encoded headers are thrown into session.

=item Mapping
B<**>

Specify mappings actually used for charset names.
C<"EXTENDED"> uses extended mappings.
C<"STANDARD"> uses standardized strict mappings.
The default is C<"EXTENDED">.
When Unicode/multibyte support is disabled,
this option will not have any effects
(see L<MIME::Charset/USE_ENCODE>).

=item MaxLineLen
B<**>

Maximum line length excluding newline.
The default is 76.

=item Minimal
B<**>

Takes care of natural word separators (i.e. whitespaces)
in the text to be encoded.
If C<"NO"> is specified, this module will encode whole text
(if encoding needed) not regarding whitespaces;
encoded-words exceeding line length will be splitted based only on their
lengths.
Default is C<"YES">.

B<Note>:
As of release 0.040, default has been changed to C<"YES"> to ensure
compatibility with MIME::Words.
On earlier releases, this option was fixed to be C<"NO">.

=item Replacement
B<**>

See L<MIME::Charset/Error Handling>.

=back

=cut

sub encode_mimewords  {
    my $words = shift;
    my %params = @_;
    my %Params = &_getparams(\%params,
			     YesNo => [qw(Detect7bit Minimal)],
			     Others => [qw(Charset Encoding Field Folding
					   Mapping MaxLineLen Replacement)],
			     ToUpper => [qw(Charset Encoding Mapping
					    Replacement)],
			    );
    croak "unsupported encoding ``$Params{Encoding}''"
	unless $Params{Encoding} =~ /^[ABQS]$/;
    # newline and following WSP
    my ($fwsbrk, $fwsspc);
    if ($Params{Folding} =~ m/^([\r\n]*)([\t ]?)$/) {
	$fwsbrk = $1;
	$fwsspc = $2 || " ";
    } else {
	croak sprintf "illegal folding sequence ``\\x%*v02X''", '\\x',
		      $Params{Folding};
    }
    # charset objects
    my $charsetobj = MIME::Charset->new($Params{Charset},
					Mapping => $Params{Mapping});
    my $ascii = MIME::Charset->new("US-ASCII", Mapping => 'STANDARD');
    $ascii->encoder($ascii);
    # lengths
    my $firstlinelen = $Params{MaxLineLen} -
	($Params{Field}? length("$Params{Field}: "): 0);
    my $maxrestlen = $Params{MaxLineLen} - length($fwsspc);
    my $UNSAFEASCII = ($maxrestlen <= 1)?
	qr{(?: =\? )}ox:
	qr{(?: =\? | [$PRINTABLE]{$Params{MaxLineLen}} )}ox;

    unless (ref($words) eq "ARRAY") {
	my @words = ();
	# unfolding: normalize linear-white-spaces and orphan newlines.
	$words =~ s/(?:[\r\n]+[\t ])*[\r\n]+([\t ]|\Z)/$1? " ": ""/eg;
	$words =~ s/[\r\n]+/ /g;
	# split if required
	if ($Params{Minimal} eq "YES") {
	    my ($spc, $unsafe_last) = ('', 0);
	    foreach my $w (split(/([\t ]+)/, $words)) {
		next unless scalar(@words) or length($w); # skip garbage
		if ($w =~ /[\t ]/) {
		    $spc = $w;
		    next;
		}

		# workaround for ``ASCII transformation'' charsets
		my $u = $w;
		if ($charsetobj->as_string =~ /$ASCIITRANS/) {
		    if (MIME::Charset::USE_ENCODE) {
			if (is_utf8($w) or $w =~ /$WIDECHAR/) {
			    $w = $charsetobj->undecode($u);
			} else {
			    $u = $charsetobj->decode($w);
			}
		    } elsif ($w =~ /[+~]/) { #FIXME: for pre-Encode environment
		        $u = "x$w";
		    }
		}
		if (scalar(@words)) {
		    if (($w =~ /$NONPRINT|$UNSAFEASCII/ or $u ne $w) xor
			$unsafe_last) {
			if ($unsafe_last) {
			    push @words, $spc.$w;
			} else {
			    $words[-1] .= $spc;
			    push @words, $w;
			}
			$unsafe_last = not $unsafe_last;
		    } else {
			$words[-1] .= $spc.$w;
		    }
		} else {
		    push @words, $spc.$w;
		    $unsafe_last =
			($w =~ /$NONPRINT|$UNSAFEASCII/ or $u ne $w);
		}
		$spc = '';
	    }
	    if ($spc) {
		if (scalar(@words)) {
		    $words[-1] .= $spc;
		} else { # only WSPs
		    push @words, $spc;
		}
	    }
	} else {
	    @words = ($words);
	}
	$words = [map { [$_, $Params{Charset}] } @words];
    }

    # Translate / concatenate words.
    my @triplets;
    foreach (@$words) {
	my ($s, $cset) = @$_;
	next unless length($s);
	my $csetobj = MIME::Charset->new($cset || "",
					 Mapping => $Params{Mapping});
	# determine charset and encoding
	# try defaults only if 7-bit charset detection is not required
	my $enc;
	my $obj = $csetobj;
	unless ($obj->as_string) {
	    if ($Params{Encoding} ne "A" or $Params{Detect7bit} eq "NO" or
		$s =~ /$UNSAFE/) {
		$obj = $charsetobj;
	    }
	}
	($s, $cset, $enc) =
	    $obj->header_encode($s,
				Detect7bit => $Params{Detect7bit},
				Replacement => $Params{Replacement},
				Encoding => $Params{Encoding});
	# pure ASCII
	if ($cset eq "US-ASCII" and !$enc and $s =~ /$UNSAFEASCII/) {
	    # pure ASCII with unsafe sequences should be encoded
	    $cset = $csetobj->output_charset ||
		$charsetobj->output_charset ||
		$ascii->output_charset;
	    $csetobj = MIME::Charset->new($cset,
					  Mapping => $Params{Mapping});
	    $enc = $csetobj->header_encoding || 'Q';
	} else {
	    $csetobj = MIME::Charset->new($cset,
					  Mapping => $Params{Mapping});
	}

	# Now no charset translations are needed.
	$csetobj->encoder($csetobj);

	# Concatenate adjacent ``words'' so that multibyte sequences will
	# be handled safely.
	# Note: Encoded-word and unencoded text must not adjoin without
	# separating whitespace(s).
	if (scalar(@triplets)) {
	    my ($last, $lastenc, $lastcsetobj) = @{$triplets[-1]};
	    if ($csetobj->decoder and
		($lastcsetobj->as_string || "") eq $csetobj->as_string and
		($lastenc || "") eq ($enc || "")) {
		$triplets[-1]->[0] .= $s;
		next;
	    } elsif (!$lastenc and $enc and $last !~ /[\r\n\t ]$/) {
		if ($last =~ /^(.*)([\r\n\t ])([$PRINTABLE]+)$/s) {
		    $triplets[-1]->[0] = $1.$2;
		    $s = $3.$s;
		} elsif ($lastcsetobj->as_string eq "US-ASCII") {
		    $triplets[-1]->[0] .= $s;
		    $triplets[-1]->[1] = $enc;
		    $triplets[-1]->[2] = $csetobj;
		    next;
		}
	    } elsif ($lastenc and !$enc and $s !~ /^[\r\n\t ]/) {
		if ($s =~ /^([$PRINTABLE]+)([\r\n\t ])(.*)$/s) {
		    $triplets[-1]->[0] .= $1;
		    $s = $2.$3;
		} elsif ($csetobj->as_string eq "US-ASCII") {
		    $triplets[-1]->[0] .= $s;
		    next;
		}
	    }
	}
	push @triplets, [$s, $enc, $csetobj];
    }

    # chop leading FWS
    while (scalar(@triplets) and $triplets[0]->[0] =~ s/^[\r\n\t ]+//) {
	shift @triplets unless length($triplets[0]->[0]);
    }

    # Split long ``words''.
    my @splitted;
    my $restlen = $firstlinelen;
    foreach (@triplets) {
	my ($s, $enc, $csetobj) = @$_;

	push @splitted, &_split($s, $enc, $csetobj, $restlen, $maxrestlen);
	my ($last, $lastenc, $lastcsetobj) = @{$splitted[-1]};
	my $lastlen;
	if ($lastenc) {
	    $lastlen = $lastcsetobj->encoded_header_len($last, $lastenc);
	} else {
	    $lastlen = length($last);
	}
	$restlen -= $lastlen; # FIXME: Sometimes estimated longer
	$restlen = $maxrestlen if $restlen <= 1;
    }

    # Do encoding.
    my @lines;
    $restlen = $firstlinelen;
    foreach (@splitted) {
	my ($str, $encoding, $charsetobj) = @$_;
	next unless length($str);

	my $s;
	if (!$encoding) {
	    $s = $str;
	} else {
	    $s = encode_mimeword($str, $encoding, $charsetobj);
	}

	my $spc = (scalar(@lines) and $lines[-1] =~ /[\r\n\t ]$/ or
		   $s =~ /^[\r\n\t ]/)? '': ' ';
	if (!scalar(@lines)) {
	    push @lines, $s;
	} elsif (length($lines[-1].$spc.$s) <= $restlen) {
	    $lines[-1] .= $spc.$s;
	} else {
	    if ($lines[-1] =~ s/([\r\n\t ]+)$//) {
		$s = $1.$s;
	    }
	    $s =~ s/^[\r\n]*[\t ]//; # strip only one WSP replaced by FWS
	    push @lines, $s;
	    $restlen = $maxrestlen;
	}
    }

    join($fwsbrk.$fwsspc, @lines);
}

#------------------------------

# _split RAW, ENCODING, CHARSET_OBJECT, ROOM_OF_FIRST_LINE, MAXRESTLEN
#     Private: used by encode_mimewords() to split a string into
#     (encoded or non-encoded) words.
#     Returns an array of arrayrefs [SUBSTRING, ENCODING, CHARSET].
sub _split {
    my $str = shift;
    my $encoding = shift;
    my $charset = shift;
    my $restlen = shift;
    my $maxrestlen = shift;

    if (!$charset->as_string or $charset->as_string eq '8BIT') {# Undecodable.
	$str =~ s/[\r\n]+[\t ]*|\x00/ /g;	# Eliminate hostile characters.
	return ([$str, undef, $charset]);
    }
    if (!$encoding and $charset->as_string eq 'US-ASCII') { # Pure ASCII.
	return &_split_ascii($str, $restlen, $maxrestlen);
    }
    if (!$charset->decoder and MIME::Charset::USE_ENCODE) { # Unsupported.
	return ([$str, $encoding, $charset]);
    }

    my (@splitted, $ustr, $first);
    while (length($str)) {
	if ($charset->encoded_header_len($str, $encoding) <= $restlen) {
	    push @splitted, [$str, $encoding, $charset];
	    last;
	}
	$ustr = $str;
	if (!(is_utf8($ustr) or $ustr =~ /$WIDECHAR/) and
	    MIME::Charset::USE_ENCODE) {
	    $ustr = $charset->decode($ustr);
	}
	($first, $str) = &_clip_unsafe($ustr, $encoding, $charset, $restlen);
	# retry splitting if failed
	if ($first and !$str and
	    $maxrestlen < $charset->encoded_header_len($first, $encoding)) {
	    ($first, $str) = &_clip_unsafe($ustr, $encoding, $charset,
					   $maxrestlen);
	}
	push @splitted, [$first, $encoding, $charset];
	$restlen = $maxrestlen;
    }
    return @splitted;
}

# _split_ascii RAW, ROOM_OF_FIRST_LINE, MAXRESTLEN
#     Private: used by encode_mimewords() to split an US-ASCII string into
#     (encoded or non-encoded) words.
#     Returns an array of arrayrefs [SUBSTRING, undef, "US-ASCII"].
sub _split_ascii {
    my $s = shift;
    my $restlen = shift;
    my $maxrestlen = shift;
    $restlen ||= $maxrestlen;

    my @splitted;
    my $ascii = MIME::Charset->new("US-ASCII", Mapping => 'STANDARD');
    foreach my $line (split(/(?:[\t ]*[\r\n]+)+/, $s)) {
        my $spc = '';
	foreach my $word (split(/([\t ]+)/, $line)) {
	    next unless scalar(@splitted) or $word; # skip first garbage
	    if ($word =~ /[\t ]/) {
		$spc = $word;
		next;
	    }

	    my $cont = $spc.$word;
	    my $elen = length($cont);
	    next unless $elen;
	    if (scalar(@splitted)) {
		# Concatenate adjacent words so that encoded-word and
		# unencoded text will adjoin with separating whitespace.
		if ($elen <= $restlen) {
		    $splitted[-1]->[0] .= $cont;
		    $restlen -= $elen;
		} else {
		    push @splitted, [$cont, undef, $ascii];
		    $restlen = $maxrestlen - $elen;
		}
	    } else {
		push @splitted, [$cont, undef, $ascii];
		$restlen -= $elen;
	    }
	    $spc = '';
	}
	if ($spc) {
	    if (scalar(@splitted)) {
		$splitted[-1]->[0] .= $spc;
		$restlen -= length($spc);
	    } else { # only WSPs
		push @splitted, [$spc, undef, $ascii];
		$restlen = $maxrestlen - length($spc);
	    }
	}
    }
    return @splitted;
}

# _clip_unsafe UNICODE, ENCODING, CHARSET_OBJECT, ROOM_OF_FIRST_LINE
#     Private: used by encode_mimewords() to bite off one encodable
#     ``word'' from a Unicode string.
#     Note: When Unicode/multibyte support is not enabled, character
#     boundaries of multibyte string shall be broken!
sub _clip_unsafe {
    my $ustr = shift;
    my $encoding = shift;
    my $charset = shift;
    my $restlen = shift;
    return ("", "") unless length($ustr);

    # Seek maximal division point.
    my ($shorter, $longer) = (0, length($ustr));
    while ($shorter < $longer) {
	my $cur = int(($shorter + $longer + 1) / 2);
	my $enc = substr($ustr, 0, $cur);
	if (MIME::Charset::USE_ENCODE ne '') {
	    $enc = $charset->undecode($enc);
	}
	my $elen = $charset->encoded_header_len($enc, $encoding);
	if ($elen <= $restlen) {
	    $shorter = $cur;
	} else {
	    $longer = $cur - 1;
	}
    }

    # Make sure that combined characters won't be divided.
    my ($fenc, $renc);
    my $max = length($ustr);
    while (1) {
	$@ = '';
	eval {
	    ($fenc, $renc) =
		(substr($ustr, 0, $shorter), substr($ustr, $shorter));
	    if (MIME::Charset::USE_ENCODE ne '') {
		# FIXME: croak if $renc =~ /^\p{M}/
		$fenc = $charset->undecode($fenc, FB_CROAK());
		$renc = $charset->undecode($renc, FB_CROAK());
	    }
	};
	last unless ($@);

	$shorter++;
	unless ($shorter < $max) { # Unencodable character(s) may be included.
	    return ($charset->undecode($ustr), "");
	}
    }

    if (length($fenc)) {
	return ($fenc, $renc);
    } else {
	return ($renc, "");
    }
}

#------------------------------

# _getparams HASHREF, OPTS
#     Private: used to get option parameters.
sub _getparams {
    my $params = shift;
    my %params = @_;
    my %Params;
    my %GotParams;
    foreach my $k (qw(NoDefault YesNo Others Obsoleted ToUpper)) {
	$Params{$k} = $params{$k} || [];
    }
    foreach my $k (keys %$params) {
	my $supported = 0;
	foreach my $i (@{$Params{NoDefault}}, @{$Params{YesNo}},
		       @{$Params{Others}}, @{$Params{Obsoleted}}) {
	    if (lc $i eq lc $k) {
		$GotParams{$i} = $params->{$k};
		$supported = 1;
		last;
	    }
	}
	carp "unknown or deprecated option ``$k''" unless $supported;
    }
    # get defaults
    foreach my $i (@{$Params{YesNo}}, @{$Params{Others}}) {
	$GotParams{$i} = $Config->{$i} unless defined $GotParams{$i};
    }
    # yesno params
    foreach my $i (@{$Params{YesNo}}) {
        if (!$GotParams{$i} or uc $GotParams{$i} eq "NO") {
            $GotParams{$i} = "NO";
        } else {
            $GotParams{$i} = "YES";
        }
    }
    # normalize case
    foreach my $i (@{$Params{ToUpper}}) {
        $GotParams{$i} &&= uc $GotParams{$i};
    }
    return %GotParams;
}


#------------------------------

=back

=head2 Configuration Files
B<**>

Built-in defaults of option parameters for L</decode_mimewords>
(except 'Charset' option) and
L</encode_mimewords> can be overridden by configuration files:
F<MIME/Charset/Defaults.pm> and F<MIME/EncWords/Defaults.pm>.
For more details read F<MIME/EncWords/Defaults.pm.sample>.

=head1 VERSION

Consult $VERSION variable.

Development versions of this module may be found at
L<http://hatuka.nezumi.nu/repos/MIME-EncWords/>.

=head1 SEE ALSO

L<MIME::Charset>,
L<MIME::Tools>

=head1 AUTHORS

The original version of function decode_mimewords() is derived from
L<MIME::Words> module that was written by:
    Eryq (F<eryq@zeegee.com>), ZeeGee Software Inc (F<http://www.zeegee.com>).
    David F. Skoll (dfs@roaringpenguin.com) http://www.roaringpenguin.com

Other stuff are rewritten or added by:
    Hatuka*nezumi - IKEDA Soji <hatuka(at)nezumi.nu>.

This program is free software; you can redistribute
it and/or modify it under the same terms as Perl itself.

=cut

1;
