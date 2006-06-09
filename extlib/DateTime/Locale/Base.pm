package DateTime::Locale::Base;

use strict;

use DateTime::Locale;

use Params::Validate qw( validate_pos );

BEGIN
{
    foreach my $field ( qw( id en_complete_name native_complete_name
                            en_language en_territory en_variant
                            native_language native_territory native_variant
                          )
                      )
    {
        # remove leading 'en_' for method name
        (my $meth_name = $field) =~ s/^en_//;

        # also remove 'complete_'
        $meth_name =~ s/complete_//;

        no strict 'refs';
        *{$meth_name} = sub { $_[0]->{$field} };
    }
}

sub new
{
    my $c = shift;

    return bless { @_,
                   default_date_format_length => $c->_default_date_format_length,
                   default_time_format_length => $c->_default_time_format_length,
                 }, $c;
}

sub language_id  { ( split /_/, $_[0]->id )[0] }
sub territory_id { ( split /_/, $_[0]->id )[1] }
sub variant_id   { ( split /_/, $_[0]->id )[2] }

sub month_name               { $_[0]->month_names->        [ $_[1]->month_0           ] }
sub month_abbreviation       { $_[0]->month_abbreviations->[ $_[1]->month_0           ] }
sub day_name                 { $_[0]->day_names->          [ $_[1]->day_of_week_0     ] }
sub day_abbreviation         { $_[0]->day_abbreviations->  [ $_[1]->day_of_week_0     ] }
sub am_pm                    { $_[0]->am_pms->             [ $_[1]->hour < 12 ? 0 : 1 ] }
sub era;                     # TBD

sub    full_date_format      { $_[0]->date_formats->{full} }
sub    long_date_format      { $_[0]->date_formats->{long} }
sub  medium_date_format      { $_[0]->date_formats->{medium} }
sub   short_date_format      { $_[0]->date_formats->{short} }
sub default_date_format      { $_[0]->date_formats->{ $_[0]->{default_date_format_length} } }

sub    full_time_format      { $_[0]->time_formats->{full} }
sub    long_time_format      { $_[0]->time_formats->{long} }
sub  medium_time_format      { $_[0]->time_formats->{medium} }
sub   short_time_format      { $_[0]->time_formats->{short} }
sub default_time_format      { $_[0]->time_formats->{ $_[0]->{default_time_format_length} } }

sub _datetime_format_pattern_order { $_[0]->date_before_time ? (0, 1) : (1, 0) }

sub    full_datetime_format { join ' ', ( $_[0]->full_date_format, $_[0]->full_time_format )[ $_[0]->_datetime_format_pattern_order ] }
sub    long_datetime_format { join ' ', ( $_[0]->long_date_format, $_[0]->long_time_format )[ $_[0]->_datetime_format_pattern_order ] }
sub  medium_datetime_format { join ' ', ( $_[0]->medium_date_format, $_[0]->medium_time_format )[ $_[0]->_datetime_format_pattern_order ] }
sub   short_datetime_format { join ' ', ( $_[0]->short_date_format, $_[0]->short_time_format )[ $_[0]->_datetime_format_pattern_order ] }
sub default_datetime_format { join ' ', ( $_[0]->default_date_format, $_[0]->default_time_format )[ $_[0]->_datetime_format_pattern_order ] }

sub default_date_format_length { $_[0]->{default_date_format_length} }
sub default_time_format_length { $_[0]->{default_time_format_length} }

sub set_default_date_format_length
{
    my $self = shift;
    my ($l) = validate_pos( @_, { regex => qr/^(?:full|long|medium|short)$/i } );

    $self->{default_date_format_length} = lc $l;
}

sub set_default_time_format_length
{
    my $self = shift;
    my ($l) = validate_pos( @_, { regex => qr/^(?:full|long|medium|short)/i } );

    $self->{default_time_format_length} = lc $l;
}

sub STORABLE_freeze
{
    my $self = shift;

    return $self->id;
}

sub STORABLE_thaw
{
    my $self = shift;
    my $cloning = shift;
    my $serialized = shift;

    my $obj = DateTime::Locale->load( $serialized );

    %$self = %$obj;
}


1;

__END__

=head1 NAME

DateTime::Locale::Base - Base class for individual locale objects

=head1 SYNOPSIS

  use base 'DateTime::Locale::Base';

=head1 DEFAULT FORMATS

Each locale has a set of four default date and time formats.  They are
distinguished by length, and are called "full", "long", "medium", and
"short".  Each locale may have a different default length which it
uses when its C<default_date_format()>, C<default_time_format()>, or
C<default_datetime_format()> methods are called.

This can be changed by calling the C<set_default_date_format()> or
C<set_default_time_format()> methods.  These methods accept a string
which must be one of "full", "long", "medium", or "short".

=head1 SUBCLASSING

If you are writing a subclass of this class, then you must provide the
following methods:

=over 4

=item * month_names

Returns an array reference containing the full names of the months,
with January as the first month.

=item * month_abbreviations

Returns an array reference containing the abbreviated names of the
months, with January as the first month.

=item * day_names

Returns an array reference containing the full names of the days,
with Monday as the first day.

=item * day_abbreviations

Returns an array reference containing the abbreviated names of the
days, with Monday as the first day.

=item * am_pms

Returns an array reference containing the localized forms of "AM" and
"PM".

=item * date_formats

Returns a hash reference containing the date formats used for the
locale.  The hash must contain the keys "long", "full", "medium", and
"short".

=item * time_formats

Returns a hash reference containing the time formats used for the
locale.  The hash must contain the keys "long", "full", "medium", and
"short".

=item * date_before_time

This returns a boolean value indicating whether or not the date comes
before the time when formatting a complete date and time for
presentation.

=item * date_parts_order

This returns a string indicating the order of the parts of a date that
is in the form XX/YY/ZZ.  The possible values are "dmy", "mdy", "ydm"
and "ymd".

=item * _default_date_format_length

This should return a string which is one of "long", "full", "medium",
or "short".  It indicates the default date format length for the
locale.

=item * _default_time_format_length

This should return a string which is one of "long", "full", "medium",
or "short".  It indicates the default time format length for the
locale.

=back

=head1 SUPPORT

Support for this module is provided via the datetime@perl.org email
list. See http://lists.perl.org/ for more details.

=head1 AUTHORS

Richard Evans <rich@ridas.com>

Dave Rolsky <autarch@urth.org>

=head1 COPYRIGHT

Copyright (c) 2003 Richard Evans. All rights reserved.

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

The full text of the license can be found in the LICENSE file included
with this module.

=cut
