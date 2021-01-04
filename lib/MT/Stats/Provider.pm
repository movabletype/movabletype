# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Stats::Provider;

use strict;
use warnings;

use base qw( Class::Accessor::Fast );
__PACKAGE__->mk_accessors(qw( id blog ));

sub new {
    my $class = shift;
    my ( $id, $blog ) = @_;
    my $self = { id => $id, blog => $blog, };
    bless $self, $class;
    $self->init();
    $self;
}

sub init { }

sub snippet {
    q();
}

sub to_resource {
    my $self = shift;
    +{ id => $self->id, };
}

1;

__END__

=head1 NAME

MT::Stats::Provider - Movable Type base class for access stats provider object.

=head1 SYNOPSIS

    package SomeStatsService::Provider;

    use base qw(MT::Stats::Provider);

=head1 DESCRIPTION

I<MT::Stats::Provider> is the base class for access stats provider object.
A provider object is used in Data API, dashboard widget, and some other features.

=head1 SUBCLASSING

Creating a subclass of I<MT::Stats::Provider> is very simple.
You simply need to overwrite some methods.

=head1 METHODS TO BE OVERWRITE (REQUREDS)

=head2 SomeStatsService::Provider->is_ready($app, $blog)

Returns 1 if this provider has been set up for specified C<$blog>.

=head2 $provider->snipet($ctx, $args)

This method is a handler of the template-tag.
Returns HTML-snipet needed by current blog.

=head2 $provider->pageviews_for_path($params)

Returns pageviews count for each path.

=head3 C<$params>

C<$params> can take these parameters.

=over 4

=item startDate

Start date of data.

=item endDate

End date of data.

=item offset

Maximum number of items to retrieve.

=item limit

0-indexed offset.

=item path

The target path of data to retrieve.

=back

=head3 return

A returned hash object has these structure.

=over 4

=item $result->{totalResults}

The total number of items.

=item $result->{totals}{pageviews}

The sum total of the pageviews.

=item $result->{items}

An array of a hash.

=item $result->{items}[$i]

A $i-th result.

=item $result->{items}[$i]{path}

A path of this result.

=item $result->{items}[$i]{title}

A page title of this result.

=item $result->{items}[$i]{pageviews}

A pageviews of this result.

=back

=head2 $provider->pageviews_for_date($params)

Returns pageviews count for each date.
The spec of C<$params> is same as L<$provider-E<gt>pageviews_for_path>.

=head3 return

A returned hash object has these structure.

=over 4

=item $result->{totalResults}

The total number of items.

=item $result->{totals}{pageviews}

The sum total of the pageviews.

=item $result->{items}

An array of a hash.

=item $result->{items}[$i]

A $i-th result.

=item $result->{items}[$i]{date}

A date of this result.

=item $result->{items}[$i]{title}

A page title of this result.

=item $result->{items}[$i]{pageviews}

A pageviews of this result.

=back

=head2 $provider->visits_for_path($params)

Returns pageviews count for each path.
The spec of C<$params> is same as L<$provider-E<gt>pageviews_for_path>.

=head3 return

A returned hash object has these structure.

=over 4

=item $result->{totalResults}

The total number of items.

=item $result->{totals}{visits}

The sum total of the visits.

=item $result->{items}

An array of a hash.

=item $result->{items}[$i]

A $i-th result.

=item $result->{items}[$i]{path}

A path of this result.

=item $result->{items}[$i]{title}

A page title of this result.

=item $result->{items}[$i]{visits}

A visits of this result.

=back

=head2 $provider->visits_for_date($params)

Returns visits count for each date.
The spec of C<$params> is same as L<$provider-E<gt>pageviews_for_path>.

=head3 return

A returned hash object has these structure.

=over 4

=item $result->{totalResults}

The total number of items.

=item $result->{totals}{visits}

The sum total of the visits.

=item $result->{items}

An array of a hash.

=item $result->{items}[$i]

A $i-th result.

=item $result->{items}[$i]{date}

A date of this result.

=item $result->{items}[$i]{title}

A page title of this result.

=item $result->{items}[$i]{visits}

A visits of this result.

=back

=head1 METHODS TO BE OVERWRITE (OPTIONAL)

=head2 $provider->init

Will be called in initializing object.

=head2 $provider->to_resource

Will be called in converting provider object to resource.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
