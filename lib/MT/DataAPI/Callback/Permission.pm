# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
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

    return $user->id == $options->{user}->id;
}

sub cms_pre_load_filtered_list {
    my ( $cb, $app, $filter, $load_options, $cols ) = @_;
    my $terms = $load_options->{terms} ||= {};

    if ( my $user = $load_options->{user} ) {
        $terms->{author_id} = $user->id;
    }

    return 1 if $app->current_api_version == 1;

    # Version 2 or later.
    # Do not output system permissions.
    if ( exists $terms->{blog_id} ) {
        my $blog_id = $terms->{blog_id};
        if ( ref $blog_id eq 'ARRAY' ) {
            @$blog_id = grep { $_ != 0 } @$blog_id;
        }
        elsif ( ref $blog_id eq 'HASH' && exists $blog_id->{not} ) {
            my $not = $blog_id->{not};
            $not = [$not] unless ref $not;
            push @$not, 0 if ( !( grep { $_ == 0 } @$not ) );
            $blog_id->{not} = $not;
        }
        elsif ( !$blog_id ) {
            $terms->{blog_id} = { not => 0 };
        }
    }
    else {
        $terms->{blog_id} = { not => 0 };
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
