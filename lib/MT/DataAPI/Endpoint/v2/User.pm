# Movable Type (r) (C) 2001-2017 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Endpoint::v2::User;

use strict;
use warnings;

use MT::Lockout;
use MT::CMS::Tools;
use MT::DataAPI::Endpoint::Common;
use MT::DataAPI::Resource;

sub list {
    my ( $app, $endpoint ) = @_;

    my $res = filtered_list( $app, $endpoint, 'author' ) or return;

    return +{
        totalResults => $res->{count},
        items =>
            MT::DataAPI::Resource::Type::ObjectList->new( $res->{objects} ),
    };
}

sub create {
    my ( $app, $endpoint ) = @_;

    my $orig_user = $app->model('author')->new;

    $orig_user->set_values(
        {   nickname    => '',
            text_format => 0,
        }
    );

    my $new_user = $app->resource_object( 'user', $orig_user )
        or return;

    save_object( $app, 'author', $new_user, $orig_user ) or return;

    return $new_user;
}

sub delete {
    my ( $app, $endpoint ) = @_;

    my ($user) = context_objects(@_)
        or return;

    run_permission_filter( $app, 'data_api_delete_permission_filter',
        'author', $user )
        or return;

    $user->remove
        or return $app->error(
        $app->translate(
            'Removing [_1] failed: [_2]', $user->class_label,
            $user->errstr
        ),
        500
        );

    $app->run_callbacks( 'data_api_post_delete.author', $app, $user );

    return $user;
}

sub unlock {
    my ( $app, $endpoint ) = @_;

    return $app->error(403) if !$app->user->is_superuser;

    my ($user) = context_objects(@_) or return;

    MT::Lockout->unlock($user);
    $user->save
        or $app->error(
        $app->translate( 'Saving object failed: [_1]', $user->errstr ), 500 );

    return +{ status => 'success' };
}

sub recover_password {
    my ( $app, $endpoint ) = @_;

    if ( !( $app->user->is_superuser() && MT::Auth->can_recover_password ) ) {
        return $app->error(403);
    }

    my ($user) = context_objects(@_) or return;

    require MT::App::CMS;
    my $cms = MT::App::CMS->new;
    my ( $rc, $res )
        = MT::CMS::Tools::reset_password( $cms, $user );

    if ($rc) {
        return +{ status => 'success', message => $res };
    }
    else {
        return $app->error( $res, 500 );
    }
}

sub recover {
    my ( $app, $endpoint ) = @_;

    my $param;

    no warnings 'once';
    local *MT::App::DataAPI::start_recover = sub { $param = $_[1] };

    MT::CMS::Tools::recover_password($app);

    return if $app->errstr;
    return $app->error( $param->{error}, 400 ) if $param->{error};

    if ( $param->{not_unique_email} ) {
        return $app->error(
            $app->translate(
                'The email address provided is not unique. Please enter your username by "name" parameter.'
            ),
            409
        );
    }

    my $message = $app->translate(
        'An email with a link to reset your password has been sent to your email address ([_1]).',
        $app->param('email')
    );
    return +{ status => 'success', message => $message };
}

1;

__END__

=head1 NAME

MT::DataAPI::Endpoint::v2::User - Movable Type class for endpoint definitions about the MT::Author.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
