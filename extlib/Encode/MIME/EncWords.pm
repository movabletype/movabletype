# -*- perl -*-

package Encode::MIME::EncWords;
require 5.007003;

use strict;
use warnings;
use Carp qw(croak carp);
use MIME::EncWords;

our $VERSION = '0.03';

# Default of options
my $Config = {
    Charset => 'UTF-8',
    # Encoding => specified by each subclass.
    # Folding => fixes to "\n".
    # Replacement => given by encode()/decode().
    # others => derived from MIME::EncWords:
    map { ($_ => $MIME::EncWords::Config->{$_}) }
	qw(Detect7bit Field Mapping MaxLineLen Minimal)
};

$Encode::Encoding{'MIME-EncWords'} = bless {
    Encoding => 'A',
    Name     => 'MIME-EncWords',
} => __PACKAGE__;

$Encode::Encoding{'MIME-EncWords-B'} = bless {
    Encoding => 'B',
    Name     => 'MIME-EncWords-B',
} => __PACKAGE__;

$Encode::Encoding{'MIME-EncWords-Q'} = bless {
    Encoding => 'Q',
    Name     => 'MIME-EncWords-Q',
} => __PACKAGE__;

$Encode::Encoding{'MIME-EncWords-ISO_2022_JP'} = bless {
    Charset  => 'ISO-2022-JP',
    Encoding => 'B',
    Name     => 'MIME-EncWords-ISO_2022_JP',
} => __PACKAGE__;

use base qw(Encode::Encoding);

sub needs_lines { 1 }
sub perlio_ok   { 0 }

sub decode($$;$) {
    my ($obj, $str, $chk) = @_;

    my %opts = map { ($_ => ($obj->{$_} || $Config->{$_})) }
        qw(Detect7bit Mapping);
    $chk = 0 if ref $chk; # coderef not supported.
    my $repl = ($chk & 4) ? ($chk & ~4 | 1) : $chk;

    local $@;
    my $skip = 0; # for RETURN_ON_ERR
    my $ret = undef;
    pos($str) = 0;
    foreach my $line (
	$str =~ m{ \G (.*?) (?:\r\n|[\r\n]) (?![ \t]) }cgsx,
	substr($str, pos($str))
    ) {
	if (defined $ret) {
	    $ret .= "\n" unless $skip;
	} else {
	    $ret = '';
	}
	if ($skip) {
	    $_[1] .= "\n";
	    $_[1] .= $line;
	    next;
	}
	next unless length $line;

	my @words = MIME::EncWords::decode_mimewords($line, %opts);
	if ($@) { # broken MIME encoding.
	    croak $@ if $chk & 1;   # DIE_ON_ERR
	    carp $@ if $chk & 2;    # WARN_ON_ERR
	    if ($chk & 4) {         # RETURN_ON_ERR
		$_[1] = $line;
		$skip = 1;
		next;
	    }
	}
	for (my $i = 0; $i <= $#words; $i++) {
	    my $word = $words[$i];
	    my $cset = MIME::Charset->new(($word->[1] || 'US-ASCII'),
					  Mapping => $opts{Mapping});
	    if (! $cset->decoder) { # unknown charset or ``8BIT''.
		$@ = 'Unknown charset "'.$cset->as_string.'"';
		croak $@ if $chk & 1;
		carp $@ if $chk & 2;
		if ($chk & 4) {
		    # already decoded... re-encoding
		    $_[1] =
			MIME::EncWords::encode_mimewords([splice @words, $i],
							 Encoding => 'B',
							 Folding => '',
							 MaxLineLen => -1);
		    $skip = 1;
		    last;
		}
		$ret .= Encode::decode("ISO-8859-1", $word->[0], 0); #FIXME

		next;
	    }
	    eval {
		$ret .= $cset->decode($word->[0], $repl);
	    };
	    if ($@) {
		$@ =~ s/ at .+? line \d+[.\n]*$//; 
		croak $@ if $chk & 1;
		carp $@ if $chk & 2;
		if ($chk & 4) {
		    # already decoded... re-encoding
		    $_[1] =
			MIME::EncWords::encode_mimewords([splice @words, $i],
							 Encoding => 'B',
							 Folding => '',
							 MaxLineLen => -1);
		    $skip = 1;
		    last;
		}
	    }
	}
    }

    if ($chk & 4) { # RETURN_ON_ERR
	$_[1] = '' unless $skip;
    } elsif ($chk) { # ! LEAVE_SRC
	$_[1] = $ret unless $chk & 8;
    }
    return $ret;
}

sub encode($$;$) {
    my ($obj, $str, $chk) = @_;

    my %opts = map { ($_ => ($obj->{$_} || $Config->{$_})) }
        qw(Charset Detect7bit Encoding Field Mapping MaxLineLen Minimal);
    $opts{Charset} ||= 'UTF-8';
    $opts{Folding} = "\n";
    $chk = 0 if ref $chk; # coderef not supported.
    my $repl = ($chk & 4) ? ($chk & ~4 | 1) : $chk;

    $str = Encode::decode('ISO-8859-1', $str)
        if ! Encode::is_utf8($str) and $str =~ /[^\x00-\x7F]/;

    local $@;
    my $skip = 0; # for RETURN_ON_ERR
    my $ret = undef;
    pos($str) = 0;
    foreach my $line (
        $str =~ m{ \G (.*?) (?:\r\n|[\r\n]) (?![ \t]) }cgsx,
        substr($str, pos($str))
    ) {
	if (defined $ret) {
	    $ret .= "\n" unless $skip;
	} else {
	    $ret = '';
	}
	if ($skip) {
	    $_[1] .= "\n";
	    $_[1] .= $line;
	    next;
	}
	next unless length $line;

	eval {
	    $ret .= MIME::EncWords::encode_mimewords($line, %opts,
						     Replacement => $repl);
	};
	if ($@) {
	    $@ =~ s/ at .+? line \d+[.\n]*$//;
	    croak $@ if $chk & 1;   # DIE_ON_ERR
	    carp $@ if $chk & 2;    # WARN_ON_ERR
	    if ($chk & 4) {         # RETURN_ON_ERR
		$_[1] = $line;
		$skip = 1;
		next;
	    }
	}
    }

    if ($chk & 4) { # RETURN_ON_ERR
	$_[1] = '' unless $skip;
    } elsif ($chk) { # ! LEAVE_SRC
	$_[1] = '' unless $chk & 8; # FIXME:spec?
    } 
    return $ret;
}

sub config {
    my $klass = shift if scalar @_ % 2;
    my %opts = @_;
    foreach my $key (keys %opts) {
        croak "Unknown config option: $key" unless exists $Config->{$key};
        $Config->{$key} = $opts{$key};
    }
}

1;
__END__

=head1 NAME

Encode::MIME::EncWords -- MIME 'B' and 'Q' header encoding (alternative)

=head1 SYNOPSIS

    use Encode::MIME::EncWords;
    use Encode qw/encode decode/;
    
    # decode header:
    $utf8   = decode('MIME-EncWords', $header);
    
    # encode header with default charset, UTF-8:
    $header = encode('MIME-EncWords', $utf8);
    
    # encode header with another charset:
    Encode::MIME::EncWords->config(Charset => 'GB2312');
    $header = encode('MIME-EncWords', $utf8);

=head1 ABSTRACT

This module implements MIME header encoding described in RFC 2047.
There are three variant encoding names and one shorthand special to a
charset:

  Encoding name              Result of encode()     Comment
  -------------------------------------------------------------------
  MIME-EncWords              (auto-detect B or Q)
  MIME-EncWords-B            =?XXXX?B?...?=         Default is UTF-8.
  MIME-EncWords-Q            =?XXXX?Q?...?=                ,,
  MIME-EncWords-ISO_2022_JP  =?ISO-2022-JP?B?...?=

All encodings generate the same result by decode().

=head1 DESCRIPTION

This module is intended to be an alternative of C<MIME-*> encodings
provided by L<Encode::MIME::Header> core module.
To find out how to use this module in detail, see L<Encode>.

=head2 Module specific feature

=over 4

=item config(KEY => VALUE, ...);

I<Class method.>
Set options by KEY => VALUE pairs.
Following options are available.

=over 4

=item Charset

[encode] Name of character set by which data elements will be converted.
Default is C<"UTF-8">.
On C<MIME-EncWords-ISO_2022_JP> it is fixed to C<"ISO-2022-JP">.

=item Detect7bit

[decode/encode] Try to detect 7-bit charset on unencoded portions.
Default is C<"YES">.

=item Field

[encode] Name of the header field which will be considered on the first line
of encoded result in its length.
Default is C<undef>.

=item Mapping

[decode/encode] Specify mappings actually used for charset names.
Default is C<"EXTENDED">.

=item MaxLineLen

[encode] Maximum line length excluding newline.
Default is C<76>.

=item Minimal

[encode] Whether to do minimal encoding or not.
Default is C<"YES">.

=back

For more details about options see L<MIME::EncWords>.

=back

=head1 CAVEAT

=over 4

=item *

The encoding modules for MIME header encoding are not the
magic porridge pot to cook complex header fields properly.

To decode address header fields (From:, To:, ...), at first parse
mailbox-list; then decode each element by encoding module.
To encode them, at first encode each element by encoding module; then
construct mailbox-list of encoded elements.
To construct or parse mailbox-list, some modules such as L<Mail::Address>
may be used.

=item *

Lines are delimited with LF (C<"\n">).
RFC5322 states that lines in Internet messages are delimited with
CRLF (C<"\r\n">).

=back

=head1 BUGS

Please report bugs or buggy behaviors to developer.

CPAN Request Tracker:
L<http://rt.cpan.org/Public/Dist/Display.html?Name=MIME-EncWords>.

=head1 VERSION

Consult C<$VERSION> variable.

B<This is experimental release>.
Features might be changed in the near future.

Development versions of this package may be found at
L<http://hatuka.nezumi.nu/repos/MIME-EncWords/>.

=head1 SEE ALSO

L<Encode>, L<Encode::MIME::Header>, L<MIME::EncWords>.

RFC 2047 I<MIME (Multipurpose Internet Mail Extensions) Part Three:
Message Header Extensions for Non-ASCII Text>.

=head1 AUTHOR

Hatuka*nezumi - IKEDA Soji <hatuka(at)nezumi.nu>

=head1 COPYRIGHT

Copyright (C) 2011 Hatuka*nezumi - IKEDA Soji.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut
