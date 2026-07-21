#----------------------------------------------------#
#
# Turkish tables
# Burak Gürsoy <burak@cpan.org>
# Last modified: Sat Nov 15 20:28:32 2003
#
# use Date::Language;
# my $turkish = Date::Language->new('Turkish');
# print $turkish->time2str("%e %b %Y, %a %T\n", time);
# print $turkish->str2time("25 Haz 1996 21:09:55 +0100");
#----------------------------------------------------#

package Date::Language::Turkish;

use strict;
use warnings;
use utf8;
use base 'Date::Language';

our $VERSION = '2.35'; # VERSION: generated
# ABSTRACT: Turkish localization for Date::Format

our @DoW = qw(Pazar Pazartesi Salı Çarşamba Perşembe Cuma Cumartesi);
our @MoY = qw(Ocak Şubat Mart  Nisan Mayıs Haziran Temmuz Ağustos Eylül Ekim Kasım Aralık);
our @DoWs     = map { substr($_,0,3) } @DoW;
$DoWs[1]  = 'Pzt'; # Since we'll get two 'Paz' s
$DoWs[-1] = 'Cmt'; # Since we'll get two 'Cum' s
our @MoYs     = map { substr($_,0,3) } @MoY;
our @AMPM     = ('',''); # no am-pm thingy

# not easy as in english... maybe we can just use a dot "." ? :)
our %DsufMAP = (
(map {$_ => 'inci', $_+10 => 'inci', $_+20 => 'inci' } 1,2,5,8 ),
(map {$_ =>  'nci', $_+10 =>  'nci', $_+20 =>  'nci' } 7       ),
(map {$_ =>  'nci', $_+10 =>  'nci', $_+20 =>  'nci' } 2       ),
(map {$_ => 'üncü', $_+10 => 'üncü', $_+20 => 'üncü' } 3,4     ),
(map {$_ => 'uncu', $_+10 => 'uncu', $_+20 => 'uncu' } 9       ),
(map {$_ =>  'ncı', $_+10 =>  'ncı', $_+20 =>  'ncı' } 6       ),
(map {$_ => 'uncu',                                  } 10,30   ),
      20 =>  'nci',
      31 => 'inci',
);

our @Dsuf       = map{ $DsufMAP{$_} } sort {$a <=> $b} keys %DsufMAP;

our ( %MoY, %DoW );
Date::Language::_build_lookups();

# Formatting routines

sub format_a { $DoWs[$_[0]->[6]] }
sub format_A { $DoW[ $_[0]->[6]] }
sub format_b { $MoYs[$_[0]->[4]] }
sub format_B { $MoY[ $_[0]->[4]] }
sub format_h { $MoYs[$_[0]->[4]] }
sub format_p { '' } # disable
sub format_P { '' } # disable
sub format_o { sprintf("%2d%s",$_[0]->[3],$Dsuf[$_[0]->[3]-1]) }

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Date::Language::Turkish - Turkish localization for Date::Format

=head1 VERSION

version 2.35

=head1 AUTHOR

Graham <gbarr@pobox.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2020 by Graham Barr.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
