# Movable Type (r) (C) 2001-2018 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Endpoint::v2::Log;

use strict;
use warnings;

use MT::I18N qw( const );
use MT::Log;
use MT::Permission;
use MT::App;
use MT::CMS::Log;
use MT::DataAPI::Resource;
use MT::DataAPI::Endpoint::Common;

sub list {
    my ( $app, $endpoint ) = @_;

    my $res = filtered_list( $app, $endpoint, 'log' ) or return;

    return +{
        totalResults => ( $res->{count} || 0 ),
        items =>
            MT::DataAPI::Resource::Type::ObjectList->new( $res->{objects} ),
    };
}

sub get {
    my ( $app, $endpoint ) = @_;

    my ( $site, $log ) = context_objects(@_)
        or return;

    run_permission_filter( $app, 'data_api_view_permission_filter',
        'log', $log->id, obj_promise($log) )
        or return;

    return $log;
}

sub create {
    my ( $app, $endpoint ) = @_;

    my ($site) = context_objects(@_)
        or return;

    my $orig_log = $app->model('log')->new;
    $orig_log->set_values(
        {   author_id => $app->user->id,
            blog_id   => $site->id,
            ip        => $app->remote_ip,
        }
    );

    my $new_log = $app->resource_object( 'log', $orig_log )
        or return;

    save_object( $app, 'log', $new_log )
        or return;

    return $new_log;
}

sub update {
    my ( $app, $endpoint ) = @_;

    my ( $site, $orig_log ) = context_objects(@_)
        or return;

    my $new_log = $app->resource_object( 'log', $orig_log )
        or return;

    save_object( $app, 'log', $new_log )
        or return;

    return $new_log;
}

sub delete {
    my ( $app, $endpoint ) = @_;

    my ( $site, $log ) = context_objects(@_)
        or return;

    run_permission_filter( $app, 'data_api_delete_permission_filter',
        'log', $log )
        or return;

    $log->remove
        or return $app->error(
        $app->translate(
            'Removing [_1] failed: [_2]', MT->translate('Log message'),
            $log->errstr
        ),
        500
        );

    $app->run_callbacks( 'data_api_post_delete.log', $app, $log );

    $log;
}

sub reset {
    my ( $app, $endpoint ) = @_;

    my ($site) = context_objects(@_)
        or return;

    my $user = $app->user or return;

    if ( $site->id ) {
        return $app->error(403)
            if !$user->permissions( $site->id )->can_do('reset_blog_log');

        MT::Log->remove( { blog_id => $site->id, class => '*' } )
            and $app->log(
            {   message => $app->translate(
                    "Activity log for blog '[_1]' (ID:[_2]) reset by '[_3]'",
                    $site->name, $site->id, $user->name
                ),
                level    => MT::Log::INFO(),
                class    => 'system',
                category => 'reset_log',
                blog_id  => $site->id,
            }
            );

    }
    else {

        if ( $user->permissions(0)->can_do('reset_system_log') ) {

            MT::Log->remove( { class => '*' } )
                and $app->log(
                {   message => $app->translate(
                        "Activity log reset by '[_1]'",
                        $user->name
                    ),
                    level    => MT::Log::INFO(),
                    class    => 'system',
                    category => 'reset_log'
                }
                );

        }
        else {

            my $iter = MT::Permission->load_iter( { author_id => $user->id } )
                or return $app->error(403);

            my @sites;
            while ( my $p = $iter->() ) {
                push @sites, $p->blog if $p->can_do('reset_blog_log');
            }

            return $app->error(403) if !@sites;

            for my $site (@sites) {
                MT::Log->remove( { blog_id => $site->id, class => '*' } )
                    and $app->log(
                    {   message => $app->translate(
                            "Activity log for blog '[_1]' (ID:[_2]) reset by '[_3]'",
                            $site->name, $site->id, $user->name
                        ),
                        level    => MT::Log::INFO(),
                        class    => 'system',
                        category => 'reset_log'
                    }
                    );
            }
        }
    }

    return +{ status => 'success' };
}

sub export {
    my ( $app, $endpoint ) = @_;

    # Check encoding parameter
    my $encoding = $app->config->ExportEncoding;
    if ( defined $app->param('encoding') ) {
        $encoding = $app->param('encoding');
        my %valid_encodings
            = map { $_->{name} => 1 } @{ const('ENCODING_NAMES') };
        if (  !$valid_encodings{$encoding}
            || $encoding eq 'guess'
            || $encoding eq 'WinLatin1' )
        {
            return $app->error(
                $app->translate( 'Invalid encoding: [_1]', $encoding ), 400 );
        }
    }

    # Change ExportEncoding
    my $current = $app->config->ExportEncoding;
    $app->config->ExportEncoding($encoding);

    MT::CMS::Log::export($app);

    # Revert ExportEncoding
    $app->config->ExportEncoding($current);
}

1;

__END__

=head1 NAME

MT::DataAPI::Endpoint::v2::Log - Movable Type class for endpoint definitions about the MT::Log.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
