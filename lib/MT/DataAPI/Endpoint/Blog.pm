# Movable Type (r) (C) 2001-2018 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::DataAPI::Endpoint::Blog;

use warnings;
use strict;

use MT::DataAPI::Endpoint::Common;

sub list {
    my ( $app, $endpoint ) = @_;

    my $user = get_target_user(@_)
        or return;

    my $res = filtered_list(
        $app, $endpoint, 'blog', { class => '*' },
        undef, { user => $user }
    ) or return;

    +{  totalResults => $res->{count} + 0,
        items =>
            MT::DataAPI::Resource::Type::ObjectList->new( $res->{objects} ),
    };
}

sub get {
    my ( $app, $endpoint ) = @_;

    my ($blog) = context_objects(@_);
    return unless $blog && $blog->id;

    run_permission_filter( $app, 'data_api_view_permission_filter',
        'blog', $blog->id, obj_promise($blog) )
        or return;

    $blog;
}

1;

__END__

=head1 NAME

MT::DataAPI::Endpoint::Blog - Movable Type class for endpoint definitions about the MT::Blog.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
