package DateTime::TimeZone::Floating;

use strict;

use vars qw ($VERSION @ISA);
$VERSION = 0.01;

use DateTime::TimeZone;
use base 'DateTime::TimeZone::OffsetOnly';

sub new
{
    my $class = shift;

    return bless { name => 'floating',
                   offset => 0 }, $class;
}

sub is_floating { 1 }

__END__

=head1 NAME

DateTime::TimeZone::Floating - A time zone that is always local

=head1 SYNOPSIS

  my $floating_tz = DateTime::TimeZone::Floating->new;

=head1 DESCRIPTION

This class is used to provide the DateTime::TimeZone API needed by
DateTime.pm, but for floating times, as defined by the RFC 2445 spec.
A floating time has no time zone, and has an effective offset of zero.

=head1 USAGE

This class has the same methods as a real time zone object, but the
C<short_name_for_datetime()>, and C<category()> methods both return
undef.

=cut
