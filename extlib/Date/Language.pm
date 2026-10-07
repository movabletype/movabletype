
package Date::Language;

use     strict;
use     Time::Local;
use     Carp;

require Date::Format;

our $VERSION = '2.35'; # VERSION: generated
# ABSTRACT: Language specific date formatting and parsing

use base qw(Date::Format::Generic);

sub _build_lookups
{
 my $pkg = caller;
 no strict 'refs';
 @{"${pkg}::MoY"}{@{"${pkg}::MoY"}}  = (0 .. scalar(@{"${pkg}::MoY"}));
 @{"${pkg}::MoY"}{@{"${pkg}::MoYs"}} = (0 .. scalar(@{"${pkg}::MoYs"}));
 @{"${pkg}::DoW"}{@{"${pkg}::DoW"}}  = (0 .. scalar(@{"${pkg}::DoW"}));
 @{"${pkg}::DoW"}{@{"${pkg}::DoWs"}} = (0 .. scalar(@{"${pkg}::DoWs"}));
}

sub new
{
 my $self = shift;
 my $type = shift || $self;

 $type =~ s/^(\w+)$/Date::Language::$1/;

 croak "Bad language"
    unless $type =~ /^[\w:]+$/;

 eval "require $type"
    or croak $@;

 bless [], $type;
}

# Stop AUTOLOAD being called ;-)
sub DESTROY {}

sub AUTOLOAD
{
 our $AUTOLOAD;
 if($AUTOLOAD =~ /::strptime\Z/o)
  {
   my $self = $_[0];
   my $type = ref($self) || $self;
   require Date::Parse;

   no strict 'refs';
   *{"${type}::strptime"} = Date::Parse::gen_parser(
    \%{"${type}::DoW"},
    \%{"${type}::MoY"},
    \@{"${type}::Dsuf"},
    1);

   goto &{"${type}::strptime"};
  }

 croak "Undefined method &$AUTOLOAD called";
}

sub format_Z {
    my $tz = Date::Format::Generic::format_Z(@_);
    my $pkg = ref($_[0]) || 'Date::Language';
    no strict 'refs';
    my $tz_map = \%{"${pkg}::TZ"};
    return exists $tz_map->{$tz} ? $tz_map->{$tz} : $tz;
}

sub str2time
{
 my $me = shift;
 my @t = $me->strptime(@_);

 return undef
    unless @t;

 my($ss,$mm,$hh,$day,$month,$year,$zone) = @t;
 my @lt  = localtime(time);

 $hh    ||= 0;
 $mm    ||= 0;
 $ss    ||= 0;

 $month = $lt[4]
    unless(defined $month);

 $day  = $lt[3]
    unless(defined $day);

 $year = ($month > $lt[4]) ? ($lt[5] - 1) : $lt[5]
    unless(defined $year);

 return defined $zone ? timegm($ss,$mm,$hh,$day,$month,$year) - $zone
                      : timelocal($ss,$mm,$hh,$day,$month,$year);
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Date::Language - Language specific date formatting and parsing

=head1 VERSION

version 2.35

=head1 SYNOPSIS

  use Date::Language;

  my $lang = Date::Language->new('German');
  $lang->time2str("%a %b %e %T %Y\n", time);

=head1 DESCRIPTION

L<Date::Language> provides objects to parse and format dates for specific languages. Available languages are

  Afar                    French                  Russian_cp1251
  Amharic                 Gedeo                   Russian_koi8r
  Austrian                German                  Sidama
  Brazilian               Greek                   Somali
  Chinese                 Hungarian               Spanish
  Chinese_GB              Icelandic               Swedish
  Czech                   Italian                 Tigrinya
  Danish                  Norwegian               TigrinyaEritrean
  Dutch                   Oromo                   TigrinyaEthiopian
  English                 Romanian                Turkish
  Finnish                 Russian                 Bulgarian
  Occitan

=head1 NAME

Date::Language - Language specific date formatting and parsing

=head1 METHODS

=over

=item time2str

See L<Date::Format/time2str>

=item strftime

See L<Date::Format/strftime>

=item ctime

See L<Date::Format/ctime>

=item asctime

See L<Date::Format/asctime>

=item str2time

See L<Date::Parse/str2time>

=item strptime

See L<Date::Parse/strptime>

=back

=head1 AUTHOR

Graham <gbarr@pobox.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2020 by Graham Barr.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
