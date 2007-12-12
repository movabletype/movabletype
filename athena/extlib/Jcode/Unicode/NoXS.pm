#
# $Id: NoXS.pm,v 0.77 2002/01/14 11:06:55 dankogai Exp $
#

package Jcode::Unicode::NoXS;

use strict;
use vars qw($RCSID $VERSION);

$RCSID = q$Id: NoXS.pm,v 0.77 2002/01/14 11:06:55 dankogai Exp $;
$VERSION = do { my @r = (q$Revision: 0.77 $ =~ /\d+/g); sprintf "%d."."%02d" x $#r, @r };

use Carp;

use Jcode::Constants qw(:all);
use Jcode::Unicode::Constants;

use vars qw(*_E2U *_U2E $PEDANTIC);

$PEDANTIC = 0;

# Quick and dirty import

*_E2U = *Jcode::Unicode::Constants::_E2U;
*_U2E = *Jcode::Unicode::Constants::_U2E;

sub _init_u2e{
    unless ($PEDANTIC){
	$_U2E{"\xff\x3c"} = "\xa1\xc0"; # ¡À
    }else{
	delete $_U2E{"\xff\x3c"};
	$_U2E{"\x00\x5c"} = "\xa1\xc0";     #\
	$_U2E{"\x00\x7e"} = "\x8f\xa2\xb7"; # ~
    }
}

sub _init_e2u{
    unless (%_E2U){
	%_E2U = 
	    reverse %_U2E;
    }
    unless ($PEDANTIC){
	$_E2U{"\xa1\xc0"} = "\xff\x3c"; # ¡À
    }else{
	delete $_E2U{"\xa1\xc0"};
	$_E2U{"\xa1\xc0"} = "\x00\x5c";     #\
	$_E2U{"\x8f\xa2\xb7"} = "\x00\x7e"; # ~
    }
}


# Yuck! but this is necessary because this module is 'require'd 
# instead of being 'use'd (No package export done) subs below
# belong to Jcode, not Jcode::Unicode

sub Jcode::ucs2_euc{
    my $thingy = shift;
    my $r_str = ref $thingy ? $thingy : \$thingy;
    _init_u2e();

    $$r_str =~ s(
		 ([\x00-\xff][\x00-\xff])
		 )
    {
	exists $_U2E{$1} ? $_U2E{$1} : $CHARCODE{UNDEF_JIS};
    }geox;

    $$r_str;
}

sub Jcode::euc_ucs2{
    my $thingy = shift;
    my $r_str = ref $thingy ? $thingy : \$thingy;
    _init_e2u();

    # 3 bytes
    $$r_str =~ s(
		 ($RE{EUC_0212}|$RE{EUC_C}|$RE{EUC_KANA}|[\x00-\xff])
		 )
    {
	exists $_E2U{$1} ? $_E2U{$1} : $CHARCODE{UNDEF_UNICODE};
    }geox;

    $$r_str;
}

sub Jcode::euc_utf8{
    my $thingy = shift;
    my $r_str = ref $thingy ? $thingy : \$thingy;
    &Jcode::euc_ucs2($r_str);
    &Jcode::ucs2_utf8($r_str);
}

sub Jcode::utf8_euc{
    my $thingy = shift;
    my $r_str = ref $thingy ? $thingy : \$thingy;
    &Jcode::utf8_ucs2($r_str);
    &Jcode::ucs2_euc($r_str);
}

sub Jcode::ucs2_utf8{
    my $thingy = shift;
    my $r_str = ref $thingy ? $thingy : \$thingy;
    my $result;
    for my $uc (unpack("n*", $$r_str)) {
        if ($uc < 0x80) {
            # 1 byte representation
            $result .= chr($uc);
        } elsif ($uc < 0x800) {
            # 2 byte representation
            $result .= chr(0xC0 | ($uc >> 6)) .
                chr(0x80 | ($uc & 0x3F));
        } else {
            # 3 byte representation
            $result .= chr(0xE0 | ($uc >> 12)) .
                chr(0x80 | (($uc >> 6) & 0x3F)) .
                    chr(0x80 | ($uc & 0x3F));
        }

    }
    $$r_str = $result;
}

sub Jcode::utf8_ucs2{
    my $thingy = shift;
    my $r_str = ref $thingy ? $thingy : \$thingy;
    my $result;
    $$r_str =~ s/^[\200-\277]+//o;  # can't start with 10xxxxxx
    $$r_str =~ 
	s[
	  ($RE{ASCII} | $RE{UTF8})
	  ]{
	      my $str = $1;
	      if (length($str) == 1){
		  pack("n", unpack("C", $str));
	      }elsif(length($str) == 2){
		  my ($c1,$c2) = unpack("C2", $str);
		  pack("n", (($c1 & 0x1F)<<6)|($c2 & 0x3F));
	      }else{
		  my ($c1,$c2,$c3) = unpack("C3", $str);
		  pack("n",
		       (($c1 & 0x0F)<<12)|(($c2 & 0x3F)<<6)|($c3 & 0x3F));
	      }
	  }egox;
    $$r_str;
}

1;
__END__

=head1 NAME

Jcode::Unicode::NoXS - Non-XS version of Jcode::Unicode

=head1 SYNOPSIS

NONE

=head1 DESCRIPTION

This module is called by Jcode.pm on demand.  This module is not intended for
direct use by users.  This modules implements functions related to Unicode.  
Following functions are defined here;

=over 4

=item Jcode::ucs2_euc();

=item Jcode::euc_ucs2();

=item Jcode::ucs2_utf8();

=item Jcode::utf8_ucs2();

=item Jcode::euc_utf8();

=item Jcode::utf8_euc();

=back

=cut

=head1 VARIABLES

=over 4

=item B<$Jcode::Unicode::PEDANTIC>

When set to non-zero, x-to-unicode conversion becomes pedantic.  
That is, '\' (chr(0x5c)) is converted to zenkaku backslash and 
'~" (chr(0x7e)) to JIS-x0212 tilde.

By Default, Jcode::Unicode leaves ascii ([0x00-0x7f]) as it is.

=back

=head1 MODULES

=over 4

=item Jcode::Unicode::Constants

Jumbo hash that contains UCS2-EUC conversion table is there.

=back

=head1 BUGS

 * It's very slow to initialize, due to the size of the conversion
   table it has to load.  Once loaded, however, the perfomance is not
   too bad (But still much slower than XS version).
 * Besides that, that is Unicode, Inc. to Blame (Especially JIS0201.TXT).

=head1 SEE ALSO

http://www.unicode.org/

=head1 COPYRIGHT

Copyright 1999 Dan Kogai <dankogai@dan.co.jp>

This library is free software; you can redistribute it
and/or modify it under the same terms as Perl itself.

Unicode conversion table used here are based uponon files at
ftp://ftp.unicode.org/Public/MAPPINGS/EASTASIA/JIS/,
Copyright (c) 1991-1994 Unicode, Inc.

=cut

