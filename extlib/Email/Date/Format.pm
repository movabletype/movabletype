use 5.006;
use strict;
use warnings;
package Email::Date::Format;
# ABSTRACT: produce RFC 2822 date strings
$Email::Date::Format::VERSION = '1.005';
our @EXPORT_OK = qw[email_date email_gmdate];

use Exporter 5.57 'import';
use Time::Local ();

#pod =head1 SYNOPSIS
#pod
#pod   use Email::Date::Format qw(email_date);
#pod   
#pod   my $header = email_date($date->epoch);
#pod   
#pod   Email::Simple->create(
#pod     header => [
#pod       Date => $header,
#pod     ],
#pod     body => '...',
#pod   );
#pod
#pod =head1 DESCRIPTION
#pod
#pod This module provides a simple means for generating an RFC 2822 compliant
#pod datetime string.  (In case you care, they're not RFC 822 dates, because they
#pod use a four digit year, which is not allowed in RFC 822.)
#pod
#pod =func email_date
#pod
#pod   my $date = email_date; # now
#pod   my $date = email_date( time - 60*60 ); # one hour ago
#pod
#pod C<email_date> accepts an epoch value, such as the one returned by C<time>.
#pod It returns a string representing the date and time of the input, as
#pod specified in RFC 2822. If no input value is provided, the current value
#pod of C<time> is used.
#pod
#pod C<email_date> is exported only if requested.
#pod
#pod =func email_gmdate
#pod
#pod   my $date = email_gmdate;
#pod
#pod C<email_gmdate> is identical to C<email_date>, but it will return a string
#pod indicating the time in Greenwich Mean Time, rather than local time.
#pod
#pod C<email_gmdate> is exported only if requested.
#pod
#pod =cut

sub _tz_diff {
  my ($time) = @_;

  my $diff  =   Time::Local::timegm(localtime $time)
              - Time::Local::timegm(gmtime    $time);

  my $direc = $diff < 0 ? '-' : '+';
  $diff  = abs $diff;
  my $tz_hr = int( $diff / 3600 );
  my $tz_mi = int( $diff / 60 - $tz_hr * 60 );

  return ($direc, $tz_hr, $tz_mi);
}

sub _format_date {
  my ($local) = @_;

  sub {
    my ($time) = @_;
    $time = time unless defined $time;

    my ($sec, $min, $hour, $mday, $mon, $year, $wday)
      = $local ? (localtime $time) : (gmtime $time);

    my $day   = (qw[Sun Mon Tue Wed Thu Fri Sat])[$wday];
    my $month = (qw[Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec])[$mon];
    $year += 1900;

    my ($direc, $tz_hr, $tz_mi) = $local ? _tz_diff($time)
      : ('+', 0, 0);

    sprintf "%s, %d %s %d %02d:%02d:%02d %s%02d%02d",
            $day, $mday, $month, $year, $hour, $min, $sec, $direc, $tz_hr, $tz_mi;
  }
}

BEGIN {
  *email_date   = _format_date(1);
  *email_gmdate = _format_date(0);
};

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Email::Date::Format - produce RFC 2822 date strings

=head1 VERSION

version 1.005

=head1 SYNOPSIS

  use Email::Date::Format qw(email_date);
  
  my $header = email_date($date->epoch);
  
  Email::Simple->create(
    header => [
      Date => $header,
    ],
    body => '...',
  );

=head1 DESCRIPTION

This module provides a simple means for generating an RFC 2822 compliant
datetime string.  (In case you care, they're not RFC 822 dates, because they
use a four digit year, which is not allowed in RFC 822.)

=head1 FUNCTIONS

=head2 email_date

  my $date = email_date; # now
  my $date = email_date( time - 60*60 ); # one hour ago

C<email_date> accepts an epoch value, such as the one returned by C<time>.
It returns a string representing the date and time of the input, as
specified in RFC 2822. If no input value is provided, the current value
of C<time> is used.

C<email_date> is exported only if requested.

=head2 email_gmdate

  my $date = email_gmdate;

C<email_gmdate> is identical to C<email_date>, but it will return a string
indicating the time in Greenwich Mean Time, rather than local time.

C<email_gmdate> is exported only if requested.

=head1 AUTHORS

=over 4

=item *

Casey West

=item *

Ricardo SIGNES <rjbs@cpan.org>

=back

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2004 by Casey West.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
