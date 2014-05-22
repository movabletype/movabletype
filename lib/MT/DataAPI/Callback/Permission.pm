# Movable Type (r) (C) 2001-2014 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::DataAPI::Callback::Permission;

use strict;
use warnings;

sub can_list {
    my ( $eh, $app, $terms, $args, $options ) = @_;

    my $user = $app->user;
    return 1 if $user->is_superuser;

    $user->id == $options->{user}->id;
}

sub cms_pre_load_filtered_list {
    my ( $cb, $app, $filter, $load_options, $cols ) = @_;

    if ( my $user = $load_options->{user} ) {
        my $terms = $load_options->{terms} ||= {};
        $terms->{author_id} = $user->id;
    }

    1;
}

1;

__END__

=head1 NAME

MT::DataAPI::Callback::Permission - Movable Type class for Data API's callbacks about the MT::Permission.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
