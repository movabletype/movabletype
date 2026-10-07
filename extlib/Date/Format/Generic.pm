##
##
##

package Date::Format::Generic;

use strict;
use warnings;

our ($epoch, $tzname);
use Time::Zone;
use Time::Local;

our $VERSION = '2.35'; # VERSION: generated
# ABSTRACT: Date formatting subroutines

sub ctime
{
 my($me,$t,$tz) = @_;
 $me->time2str("%a %b %e %T %Y\n", $t, $tz);
}

sub asctime
{
 my($me,$t,$tz) = @_;
 $me->strftime("%a %b %e %T %Y\n", $t, $tz);
}

sub _subs
{
 my $fn;
 $_[1] =~ s/
        %(O?[%a-zA-Z])
       /
                ($_[0]->can("format_$1") || sub { $1 })->($_[0]);
       /sgeox;

 $_[1];
}

sub strftime
{
 my($pkg,$fmt,$time);

 ($pkg,$fmt,$time,$tzname) = @_;

 my $me = ref($pkg) ? $pkg : bless [];

 if(defined $tzname)
  {
   $tzname = uc $tzname;

   $tzname = sprintf("%+05d",$tzname)
    unless($tzname =~ /\D/);

   $epoch = timelocal(@{$time}[0..5]);

   @$me = gmtime($epoch + tz_offset($tzname));
  }
 else
  {
   @$me = @$time;
   undef $epoch;
  }

 _subs($me,$fmt);
}

sub time2str
{
 my($pkg,$fmt,$time);

 ($pkg,$fmt,$time,$tzname) = @_;

 my $me = ref($pkg) ? $pkg : bless [], $pkg;

 $epoch = $time;

 if(defined $tzname)
  {
   $tzname = uc $tzname;

   $tzname = sprintf("%+05d",$tzname)
    unless($tzname =~ /\D/);

   $time += tz_offset($tzname);
   @$me = gmtime($time);
  }
 else
  {
   @$me = localtime($time);
  }
 $me->[9] = $time;
 _subs($me,$fmt);
}

my(@DoW,@MoY,@DoWs,@MoYs,@AMPM,%format,@Dsuf);

@DoW = qw(Sunday Monday Tuesday Wednesday Thursday Friday Saturday);

@MoY = qw(January February March April May June
          July August September October November December);

@DoWs = map { substr($_,0,3) } @DoW;
@MoYs = map { substr($_,0,3) } @MoY;

@AMPM = qw(AM PM);

@Dsuf = (qw(th st nd rd th th th th th th)) x 3;
@Dsuf[11,12,13] = qw(th th th);
@Dsuf[30,31] = qw(th st);

%format = ('x' => "%m/%d/%y",
           'C' => "%a %b %e %T %Z %Y",
           'X' => "%H:%M:%S",
          );

my @locale;
my $locale = "/usr/share/lib/locale/LC_TIME/default";
local *LOCALE;

if(open(LOCALE,"$locale"))
 {
  chop(@locale = <LOCALE>);
  close(LOCALE);

  @MoYs = @locale[0 .. 11];
  @MoY  = @locale[12 .. 23];
  @DoWs = @locale[24 .. 30];
  @DoW  = @locale[31 .. 37];
  @format{"X","x","C"} =  @locale[38 .. 40];
  @AMPM = @locale[41 .. 42];
 }

sub wkyr {
    my($wstart, $wday, $yday) = @_;
    $wday = ($wday + 7 - $wstart) % 7;
    return int(($yday - $wday + 13) / 7 - 1);
}

##
## these 6 formatting routines need to be *copied* into the language
## specific packages
##

my @roman = ('',qw(I II III IV V VI VII VIII IX));
sub roman {
  my $n = shift;

  $n =~ s/(\d)$//;
  my $r = $roman[ $1 ];

  if($n =~ s/(\d)$//) {
    (my $t = $roman[$1]) =~ tr/IVX/XLC/;
    $r = $t . $r;
  }
  if($n =~ s/(\d)$//) {
    (my $t = $roman[$1]) =~ tr/IVX/CDM/;
    $r = $t . $r;
  }
  if($n =~ s/(\d)$//) {
    (my $t = $roman[$1]) =~ tr/IVX/M../;
    $r = $t . $r;
  }
  $r;
}

sub format_a { $DoWs[$_[0]->[6]] }
sub format_A { $DoW[$_[0]->[6]] }
sub format_b { $MoYs[$_[0]->[4]] }
sub format_B { $MoY[$_[0]->[4]] }
sub format_h { $MoYs[$_[0]->[4]] }
sub format_p { $_[0]->[2] >= 12 ?  $AMPM[1] : $AMPM[0] }
sub format_P { lc($_[0]->[2] >= 12 ?  $AMPM[1] : $AMPM[0]) }

sub format_d { sprintf("%02d",$_[0]->[3]) }
sub format_e { sprintf("%2d",$_[0]->[3]) }
sub format_H { sprintf("%02d",$_[0]->[2]) }
sub format_I { sprintf("%02d",$_[0]->[2] % 12 || 12)}
sub format_j { sprintf("%03d",$_[0]->[7] + 1) }
sub format_k { sprintf("%2d",$_[0]->[2]) }
sub format_l { sprintf("%2d",$_[0]->[2] % 12 || 12)}
sub format_L { $_[0]->[4] + 1 }
sub format_m { sprintf("%02d",$_[0]->[4] + 1) }
sub format_M { sprintf("%02d",$_[0]->[1]) }
sub format_q { sprintf("%01d",int($_[0]->[4] / 3) + 1) }
sub format_s {
   $epoch = timelocal(@{$_[0]}[0..5])
    unless defined $epoch;
   sprintf("%d",$epoch)
}
sub format_S { sprintf("%02d",$_[0]->[0]) }
sub format_U { wkyr(0, $_[0]->[6], $_[0]->[7]) }
sub format_w { $_[0]->[6] }
sub format_W { wkyr(1, $_[0]->[6], $_[0]->[7]) }
sub format_y { sprintf("%02d",$_[0]->[5] % 100) }
sub format_Y { sprintf("%04d",$_[0]->[5] + 1900) }

sub format_Z {
 my $o = tz_local_offset($_[0]->[9]);
 defined $tzname ? $tzname : uc tz_name($o, $_[0]->[8]);
}

sub format_z {
 my $t = $_[0]->[9];
 my $o = defined $tzname ? tz_offset($tzname, $t) : tz_offset(undef,$t);
 sprintf("%+03d%02d", int($o / 3600), int(abs($o) % 3600) / 60);
}

sub format_c { &format_x . " " . &format_X }
sub format_D { &format_m . "/" . &format_d . "/" . &format_y  }
sub format_r { &format_I . ":" . &format_M . ":" . &format_S . " " . &format_p  }
sub format_R { &format_H . ":" . &format_M }
sub format_T { &format_H . ":" . &format_M . ":" . &format_S }
sub format_t { "\t" }
sub format_n { "\n" }
sub format_o { sprintf("%2d%s",$_[0]->[3],$Dsuf[$_[0]->[3]]) }
sub format_x { my $f = $format{'x'}; _subs($_[0],$f); }
sub format_X { my $f = $format{'X'}; _subs($_[0],$f); }
sub format_C { my $f = $format{'C'}; _subs($_[0],$f); }

sub format_Od { roman(format_d(@_)) }
sub format_Oe { roman(format_e(@_)) }
sub format_OH { roman(format_H(@_)) }
sub format_OI { roman(format_I(@_)) }
sub format_Oj { roman(format_j(@_)) }
sub format_Ok { roman(format_k(@_)) }
sub format_Ol { roman(format_l(@_)) }
sub format_Om { roman(format_m(@_)) }
sub format_OM { roman(format_M(@_)) }
sub format_Oq { roman(format_q(@_)) }
sub format_Oy { roman(format_y(@_)) }
sub format_OY { roman(format_Y(@_)) }

sub format_G { int(($_[0]->[9] - 315993600) / 604800) }

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Date::Format::Generic - Date formatting subroutines

=head1 VERSION

version 2.35

=head1 AUTHOR

Graham <gbarr@pobox.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2020 by Graham Barr.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
