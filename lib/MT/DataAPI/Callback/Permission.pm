# Movable Type (r) Open Source (C) 2001-2013 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
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
