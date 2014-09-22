# Movable Type (r) (C) 2001-2014 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::DataAPI::Endpoint::Blog::v2;

use strict;
use warnings;

use MT::DataAPI::Endpoint::Common;
use MT::DataAPI::Resource;

sub list {
    my ( $app, $endpoint ) = @_;

    my %terms = ( class => '*' );
    my $res = filtered_list( $app, $endpoint, 'blog', \%terms ) or return;

    +{  totalResults => $res->{count} + 0,
        items =>
            MT::DataAPI::Resource::Type::ObjectList->new( $res->{objects} ),
    };
}

sub list_by_parent {
    my ( $app, $endpoint ) = @_;

    my ($blog) = context_objects(@_);
    return unless $blog && $blog->id;

    my %terms = ( class => 'blog', parent_id => $blog->id );
    my $res = filtered_list( $app, $endpoint, 'blog', \%terms ) or return;

    +{  totalResults => $res->{count} + 0,
        items =>
            MT::DataAPI::Resource::Type::ObjectList->new( $res->{objects} ),
    };
}

1;

__END__

=head1 NAME

MT::DataAPI::Endpoint::Blog::v2 - Movable Type class for endpoint definitions about the MT::Blog.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
