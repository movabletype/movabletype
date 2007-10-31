
package MIME::EncWords;
use 5.005;

=head1 NAME

MIME::EncWords - deal with RFC-1522 encoded words (improved)

=head1 SYNOPSIS

I<L<MIME::EncWords> is aimed to be another implimentation
of L<MIME::Words> so that it will achive more exact conformance with
MIME specifications.  Additionally, it contains some improvements.
Following synopsis and descriptions are inherited from its inspirer,
with description of improvements and clarifications added.>

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
C<:-)>.

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
use vars qw($VERSION @EXPORT_OK %EXPORT_TAGS @ISA);

### Exporting:
use Exporter;

%EXPORT_TAGS = (all => [qw(decode_mimewords
			   encode_mimeword
			   encode_mimewords)]);
Exporter::export_ok_tags(qw(all));

### Inheritance:
@ISA = qw(Exporter);

### Other modules:
use Carp;
use MIME::Base64;
use MIME::Charset qw(:trans);

my @ENCODE_SUBS = qw(FB_CROAK decode encode from_to is_utf8 resolve_alias);
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
$VERSION = '0.040';

### Nonprintables (controls + x7F + 8bit):
#my $NONPRINT = "\\x00-\\x1F\\x7F-\\xFF";
my $PRINTABLE = "\\x21-\\x7E";
my $NONPRINT = qr{[^$PRINTABLE]}; # Improvement: Unicode support.
my $UNSAFE = qr{[^\x01-\x20$PRINTABLE]};
my $WIDECHAR = qr{[^\x00-\xFF]};

### Max line length:
my $MAXLINELEN = 76;

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
    # $str =~ s{([_\?\=$NONPRINT])}{sprintf("=%02X", ord($1))}eog;
    $str =~ s{(\x20)|([_?=]|$NONPRINT)}{
	defined $1? "_": sprintf("=%02X", ord($2))
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

B<In a scalar context,> joins the "data" elements of the above
list together, and returns that.  I<Warning: this is information-lossy,>
and probably I<not> what you want, but if you know that all charsets
in the ENCODED string are identical, it might be useful to you.
(Before you use this, please see L<MIME::WordDecoder/unmime>,
which is probably what you want.)
B<Note>: See also "Charset" option below.

In the event of a syntax error, $@ will be set to a description
of the error, but parsing will continue as best as possible (so as to
get I<something> back when decoding headers).
$@ will be false if no error was detected.

Any arguments past the ENCODED string are taken to define a hash of options:

=over 4

=item Charset

B<Improvement by this module>:
Name of character set by which data elements in scalar context
will be converted.
If this option is specified as special value C<"_UNICODE_">,
returned value will be Unicode string.

When Unicode/multibyte support is disabled
(see L<MIME::Charset/USE_ENCODE>),
this option will not have any effects.

B<Note>:
This feature is still information-lossy, I<except> when C<"_UNICODE_"> is
specified.

=item Field

Name of the mail field this string came from.  I<Currently ignored.>

=back

B<Improvement by this module>:
Adjacent encoded-words with same charset will be concatenated
to handle multibyte sequences safely.

B<Change by this module>:
Malformed base64 encoded-words will be kept encoded.
In this case $@ will be set.

B<Compatibility with MIME::Words>:
Whitespaces surrounding unencoded data will not be stripped.

=cut

sub decode_mimewords {
    my $encstr = shift;
    my %params = @_;
    my $cset = $params{"Charset"};
    my @tokens;
    $@ = '';           ### error-return

    ### Decode:
    my ($word, $charset, $encoding, $enc, $dec);
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
		lc($charset) eq lc(${$tokens[-1]}[1]) and
		resolve_alias($charset)) { # Concat words if possible.
		${$tokens[-1]}[0] .= $dec;
	    } else {
		push @tokens, [$dec, $charset];
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

    return (wantarray ? @tokens : join('',map {
	&_convert($_->[0], $_->[1], $cset)
	} @tokens));
}

#------------------------------

# _convert RAW, FROMCHARSET, TOCHARSET
#     Private: used by encode_mimewords() to convert string by other charset
#     or to decode to Unicode.
#     When source charset is unknown and Unicode string is requested, at first
#     try well-formed UTF-8 then fallback to ISO-8859-1 so that almost all
#     non-ASCII bytes will be preserved.
sub _convert($$$) {
    my $s = shift;
    my $charset = shift || "";
    my $cset = shift;
    return $s unless MIME::Charset::USE_ENCODE;
    return $s unless $cset;
    return $s if uc($charset) eq uc($cset);

    my $preserveerr = $@;

    my $converted = $s;
    if (is_utf8($s) or $s =~ $WIDECHAR) {
	if ($cset ne "_UNICODE_") {
	    $converted = encode($cset, $converted);
	}
    } elsif ($cset eq "_UNICODE_") {
	if (!resolve_alias($charset)) {
	    if ($s =~ $UNSAFE) {
		$@ = '';
		eval {
		    $converted = decode("UTF-8", $converted, FB_CROAK());
		};
		if ($@) {
		    $converted = $s;
		    $converted = decode("ISO-8859-1", $converted);
		}
	    }
	} else {
	    $converted = decode($charset, $converted);
	}
    } elsif (resolve_alias($charset)) {
	from_to($converted, $charset, $cset);
    }

    $@ = $preserveerr;
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
B<Improvement by this module>:
You may also specify it as ``special'' value: C<"S"> to choose shorter
one of either C<"Q"> or C<"B">.

You may specify the CHARSET, which defaults to C<iso-8859-1>.

B<Change by this module>:
Spaces will be escaped with ``_'' by C<"Q"> encoding.

=cut

sub encode_mimeword {
    my $word = shift;
    my $encoding = uc(shift || 'Q');
    my $charset  = uc(shift || 'ISO-8859-1');

    my $encstr;
    if ($encoding eq 'Q') {
	$encstr = &_encode_Q($word);
    } elsif ($encoding eq "S") {
	if (encoded_header_len($word, "B", $charset) <
	    encoded_header_len($word, "Q", $charset)) {
	    $encoding = "B";
	    $encstr = &_encode_B($word);
	} else {
	    $encoding = "Q";
	    $encstr = &_encode_Q($word);
	}
    } else { # "B"
	$encoding = "B";
	$encstr = &_encode_B($word);
    }

    "=?$charset?$encoding?$encstr?=";
}

#------------------------------

=item encode_mimewords RAW, [OPTS]

I<Function.>
Given a RAW string, try to find and encode all "unsafe" sequences
of characters:

    ### Encode a string with some unsafe "words":
    $encoded = encode_mimewords("Me and \xABFran\xE7ois\xBB");

Returns the encoded string.

B<Improvement by this module>:
RAW may be a Unicode string when Unicode/multibyte support is enabled
(see L<MIME::Charset/USE_ENCODE>).
Furthermore, RAW may be a reference to that returned
by L<"decode_mimewords"> on array context.  In latter case "Charset"
option (see below) will be overridden (see also notes below).

Any arguments past the RAW string are taken to define a hash of options:

=over 4

=item Charset

Encode all unsafe stuff with this charset.  Default is 'ISO-8859-1',
a.k.a. "Latin-1".

=item Detect7bit

B<Improvement by this modlue>:
When "Encoding" option (see below) is specified as C<"a"> and "Charset"
option is unknown, try to detect 7-bit charset on given RAW string.
Default is C<"YES">.
When Unicode/multibyte support is disabled,
this option will not have any effects
(see L<MIME::Charset/USE_ENCODE>).

=item Encoding

The encoding to use, C<"q"> or C<"b">.  The default is C<"q">.
B<Improvement by this module>:
You may also specify ``special'' values: C<"a"> will automatically choose
recommended encoding to use (with charset conversion if alternative
charset is recommended: see L<MIME::Charset>);
C<"s"> will choose shorter one of either C<"q"> or C<"b">.

=item Field

Name of the mail field this string will be used in.
B<Improvement by this module>:
Length of mail field name will be considered in the first line of
encoded header.

=item Minimal

B<Improvement by this module>:
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

=back

B<Notes on improvement by this module>:
When RAW is an arrayref,
adjacent encoded-words are concatenated.  Then they are splitted taking
care of character boundaries of multibyte sequences, when Unicode/multibyte
support is enabled.
Portions for unencoded data should include surrounding whitespace(s), or
they will be merged into adjoining encoded word(s).

=cut

sub encode_mimewords  {
    my $words = shift;
    my %params = @_;
    my $charset = uc($params{'Charset'});
    my $detect7bit = uc($params{'Detect7bit'} || "YES");
    my $encoding = uc($params{'Encoding'});
    my $header_name = $params{'Field'};
    my $minimal = uc($params{'Minimal'} || "YES");
    my $firstlinelen = $MAXLINELEN;
    if ($header_name) {
	$firstlinelen -= length($header_name.': ');
    }

    unless (ref($words) eq "ARRAY") {
	if ($minimal eq "YES") {
	    my @words = map {[$_, $charset]} split(/((?:\A|[\t ])[\t \x21-\x7E]+(?:[\t ]|\Z))/, $words);
	    $words = \@words;
	} else {
	    $words = [[$words, $charset]];
	}
    }

    # Translate / concatenate words.
    my @triplets;
    foreach (@$words) {
	my ($s, $cset) = @$_;
	my $enc;

	next unless length($s);

	# Unicode string should be encoded by given charset.
	# Unsupported charset will be fallbacked to UTF-8.
	if (is_utf8($s) or $s =~ $WIDECHAR) {
	    unless (resolve_alias($cset)) {
		if ($s !~ $UNSAFE) {
		    $cset = "US-ASCII";
		} else {
		    $cset = "UTF-8";
		}
	    }
	    $s = encode($cset, $s);
	}

	# Determine charset and encoding.
	if ($encoding eq "A") {
	    ($s, $cset, $enc) =
		header_encode($s, $cset || $charset,
			      Detect7bit => $detect7bit);
	} else {
	    $cset ||= ($charset || ($s !~ $UNSAFE)? "US-ASCII": "ISO-8859-1");
	    $enc = $encoding ||
		(($s !~ $UNSAFE and $cset eq "US-ASCII")? undef: "Q");
	}

	# Concatenate adjacent ``words'' so that multibyte sequences will
	# be handled safely.
	# Note: Encoded-word and unencoded text must not adjoin without
	# separating whitespace(s).
	if (scalar(@triplets)) {
	    my ($last, $lastenc, $lastcset) = @{$triplets[-1]};
	    if (uc($lastcset) eq uc($cset) and uc($lastenc) eq uc($enc) and
		resolve_alias($cset)) {
		${$triplets[-1]}[0] .= $s;
		next;
	    } elsif (!$lastenc and $enc and $last !~ /[\t ]$/) {
		if ($last =~ /^(.*)[\t ]([$PRINTABLE]+)$/s) {
		    ${$triplets[-1]}[0] = $1." ";
		    $s = $2.$s;
		} elsif (uc($lastcset) eq "US-ASCII") {
		    ${$triplets[-1]}[0] .= $s;
		    ${$triplets[-1]}[1] = $enc;
		    ${$triplets[-1]}[2] = $cset;
		    next;
		}
	    } elsif ($lastenc and !$enc and $s !~ /^[\t ]/) {
		if ($s =~ /^([$PRINTABLE]+)[\t ](.*)$/s) {
		    ${$triplets[-1]}[0] .= $1;
		    $s = " ".$2;
		} elsif (uc($cset) eq "US-ASCII") {
		    ${$triplets[-1]}[0] .= $s;
		    next;
		}
	    }
	}
	push @triplets, [$s, $enc, $cset];
    }

    # Split long ``words''.
    my @splitted;
    my $restlen = $firstlinelen;
    my $lastlen = 0;
    foreach (@triplets) {
	my ($s, $enc, $cset) = @$_;

	my $restlen = $restlen - $lastlen - 1;
	if ($restlen < ($enc? encoded_header_len('', $enc, $cset): 1)) {
	    $restlen = $MAXLINELEN - 1;
	}

	push @splitted, &_split($s, $enc, $cset, $restlen);
	my ($last, $lastenc, $lastcset) = @{$splitted[-1]};
	if ($lastenc) {
	    $lastlen = encoded_header_len($last, $lastenc, $lastcset);
	} else {
	    $lastlen = length($last);
	}
    }

    # Do encoding.
    my @lines;
    my $linelen = $firstlinelen;
    foreach (@splitted) {
	my ($str, $encoding, $charset) = @$_;
	next unless length($str);

	my $s;
	if (!$encoding) {
	    $s = $str;
	} else {
	    $s = &encode_mimeword($str, $encoding, $charset);
	}

	my $spc = (scalar(@lines) and $lines[-1] =~ /[\t ]$/)? '': ' ';
	if (!scalar(@lines)) {
	    $s =~ s/^[\r\n\t ]+//;
	    push @lines, $s;
	} elsif (length($lines[-1]) + length($s) <= $linelen) {
	    $lines[-1] .= $spc.$s;
	} else {
	    $s =~ s/^[\r\n\t ]+//;
	    push @lines, $s;
	    $linelen = $MAXLINELEN - 1;
	}
    }

    join("\n ", @lines);
}

#------------------------------

# _split RAW, ENCODING, CHARSET, ROOM_OF_FIRST_LINE
#     Private: used by encode_mimewords() to split a string into
#     (encoded or non-encoded) words.
#     Returns an array of arrayrefs [SUBSTRING, ENCODING, CHARSET].
sub _split {
    my $str = shift;
    my $encoding = shift;
    my $charset = shift;
    my $restlen = shift;

    if (!$charset or $charset eq '8BIT') {	# Undecodable.
	$str =~ s/[\r\n]+[\t ]*|\x00/ /g;	# Eliminate hostile characters.
	return ([$str, undef, $charset]);
    }
    unless (resolve_alias($charset)) {		# Unsupported charset.
	return ([$str, $encoding, $charset]);
    }
    if (!$encoding and $charset eq 'US-ASCII') {
	return &_split_ascii($str, $restlen);
    }

    my (@splitted, $ustr, $first);
    while (length($str)) {
	if (encoded_header_len($str, $encoding, $charset) <= $restlen) {
	    push @splitted, [$str, $encoding, $charset];
	    last;
	}
	$ustr = $str;
	$ustr = decode($charset, $ustr);
	($first, $str) = &_clip_unsafe($ustr, $encoding, $charset, $restlen);
	push @splitted, [$first, $encoding, $charset];
	$restlen = $MAXLINELEN - 1;
    }
    return @splitted;
}

# _split_ascii RAW, ROOM_OF_FIRST_LINE
#     Private: used by encode_mimewords() to split an US-ASCII string into
#     (encoded or non-encoded) words.
#     Returns an array of arrayrefs [SUBSTRING, ENCODING, "US-ASCII"],
#     where ENCODING is either undef or (if any unsafe sequences are
#     included) "Q".
sub _split_ascii {
    my $s = shift;
    my $restlen = shift || $MAXLINELEN - 1;

    my @splitted;
    foreach my $line (split(/[\r\n]+/, $s)) {
	$line =~ s/^[\t ]+//;

	if (length($line) < $restlen and $line !~ /=\?|$UNSAFE/) {
	    push @splitted, [$line, undef, "US-ASCII"];
	    $restlen = $MAXLINELEN - 1;
	    next;
	}

        my ($spc, $enc);
	foreach my $word (split(/([\t ]+)/, $line)) {
	    if ($word =~ /[\t ]/) {
		$spc = $word;
		next;
	    }

	    $enc = ($word =~ /=\?|$UNSAFE/)? "Q": undef;
	    if (scalar(@splitted)) {
		my ($last, $lastenc, $lastcset) = @{$splitted[-1]};
		my ($elen, $cont, $appe);

		# Concatenate adjacent words so that encoded-word and
		# unencoded text will adjoin with separating whitespace.
		if (!$lastenc and !$enc) {
		    $elen = length($spc.$word);
		    ($cont, $appe) = ($spc.$word, "");
		} elsif (!$lastenc and $enc) {
		    $elen = length($spc) +
			encoded_header_len($word, "Q", "US-ASCII");
		    ($cont, $appe) = ($spc, $word);
		} elsif ($lastenc and !$enc) {
		    $elen = length($spc.$word);
		    ($cont, $appe) = ("", $spc.$word);
		} else {
		    $elen = encoded_header_len($spc.$word, "Q",
					       "US-ASCII") - 15;
		    ($cont, $appe) = ($spc.$word, "");
		}

		if ($elen <= $restlen) {
		    ${$splitted[-1]}[0] .= $cont if length($cont);
		    push @splitted, [$appe, $enc, "US-ASCII"] if length($appe);
		    $restlen -= $elen;
		    next;
		}
		$restlen = $MAXLINELEN - 1;
	    }
	    push @splitted, [$word, $enc, "US-ASCII"];
	    $restlen -= ($enc?
		encoded_header_len($word, "Q", "US-ASCII"):
		length($word));
	}
    }
    return @splitted;
}

# _clip_unsafe UNICODE, ENCODING, CHARSET, ROOM_OF_FIRST_LINE
#     Private: used by encode_mimewords() to bite off one encodable
#     ``word'' from a Unicode string.
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
	my $enc = encode($charset, substr($ustr, 0, $cur));
	my $elen = encoded_header_len($enc, $encoding, $charset);
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
	    $fenc = encode($charset, $fenc, FB_CROAK());
	    $renc = encode($charset, $renc, FB_CROAK());
	};
	last unless ($@);

	$shorter++;
	unless ($shorter < $max) { # Unencodable characters are included.
	    return (encode($charset, $ustr), "");
	}
    }

    if (length($fenc)) {
	return ($fenc, $renc);
    } else {
	return ($renc, "");
    }
}

#------------------------------

=back

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

All rights reserved.  This program is free software; you can redistribute
it and/or modify it under the same terms as Perl itself.

=cut

1;
