# Movable Type (r) (C) 2001-2014 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Endpoint::Template::v2;

use strict;
use warnings;

use MT::CMS::Template;
use MT::DataAPI::Endpoint::Common;
use MT::DataAPI::Resource;

sub list {
    my ( $app, $endpoint ) = @_;

    my %terms = ( type => { not => 'backup' }, );

    my $res = filtered_list( $app, $endpoint, 'template', \%terms ) or return;

    return +{
        totalResults => ( $res->{count} || 0 ),
        items =>
            MT::DataAPI::Resource::Type::ObjectList->new( $res->{objects} ),
    };
}

sub get {
    my ( $app, $endpoint ) = @_;

    my ( $site, $tmpl ) = context_objects(@_) or return;

    run_permission_filter( $app, 'data_api_view_permission_filter',
        'template', $tmpl->id, obj_promise($tmpl) )
        or return;

    return $tmpl;
}

sub create {
    my ( $app, $endpoint ) = @_;

    my ($site) = context_objects(@_) or return;

    my $orig_tmpl = $app->model('template')->new;
    $orig_tmpl->set_values( { blog_id => $site->id || 0, } );

    my $new_tmpl = $app->resource_object( 'template', $orig_tmpl )
        or return;

    save_object( $app, 'template', $new_tmpl )
        or return;

    return $new_tmpl;
}

sub update {
    my ( $app, $endpoint ) = @_;

    my ( $site, $orig_tmpl ) = context_objects(@_) or return;

    my $new_tmpl = $app->resource_object( 'template', $orig_tmpl )
        or return;

    save_object( $app, 'template', $new_tmpl )
        or return;

    return $new_tmpl;
}

sub delete {
    my ( $app, $endpoint ) = @_;

    my ( $site, $tmpl ) = context_objects(@_) or return;

    run_permission_filter( $app, 'data_api_delete_permission_filter',
        'template', $tmpl )
        or return;

    if (!(  grep { $tmpl->type eq $_ }
            qw/ index archive individual page category custom /
        )
        )
    {
        return $app->error(
            $app->translate( 'Cannot delete [_1] template.', $tmpl->type ),
            403 );
    }

    $tmpl->remove
        or return $app->error(
        $app->translate(
            'Removing [_1] failed: [_2]', $tmpl->class_label,
            $tmpl->errstr
        ),
        500
        );

    $app->run_callbacks( 'data_api_post_delete.template', $app, $tmpl );

    return $tmpl;
}

sub publish {
    my ( $app, $endpoint ) = @_;

    my ( $site, $tmpl ) = context_objects(@_) or return;

    my $type = defined( $tmpl->type ) ? $tmpl->type : '';
    if (!(  grep { $type eq $_ } qw/ index archive individual page category /
        )
        )
    {
        return $app->error(
            $app->translate( 'Cannot publish [_1] template.', $type ), 400 );
    }

    local $app->{return_args};
    local $app->{redirect};
    local $app->{redirect_use_meta};

    $app->param( 'id', $tmpl->id );

    if ( $type eq 'index' ) {
        MT::CMS::Template::publish_index_templates($app);
    }
    else {
        MT::CMS::Template::publish_archive_templates($app);
    }

    if ( $app->errstr ) {
        return $app->error(403);
    }

    return +{ status => 'success' };
}

sub refresh {
    my ( $app, $endpoint ) = @_;

    my ( $site, $tmpl ) = context_objects(@_) or return;

    my @messages;
    local *MT::App::DataAPI::build_page = sub {
        my ( $app, $page, $param ) = @_;
        @messages = map { $_->{message} } @{ $param->{message_loop} };
    };

    local $app->{mode};

    $app->param( 'id', $tmpl->id );

    require MT::CMS::Template;
    MT::CMS::Template::refresh_individual_templates($app);

    if ( $app->errstr ) {
        return $app->error(403);
    }

    return +{
        status   => 'success',
        messages => \@messages,
    };
}

sub clone {
    my ( $app, $endpoint ) = @_;

    my ( $site, $tmpl ) = context_objects(@_) or return;

    #    # Check permission.
    #    my %terms = (
    #        author_id => $app->user->id,
    #        $site->id ? ( blog_id => $site->id ) : (),
    #    );
    #    if ( !$app->model('permission')->count( \%terms ) ) {
    #        return $app->error(403);
    #    }
    #
    #    my $permitted;
    #    my $iter = $app->model('permission')->load_iter( \%terms );
    #    while ( my $p = $iter->() ) {
    #        $permitted = 1 if $p->can_do('copy_template_via_list');
    #    }
    #    if ( !$permitted ) {
    #        return $app->error( 403 );
    #    }

    # Check template type.
    my $type = defined( $tmpl->type ) ? $tmpl->type : '';
    if (!(  grep { $type eq $_ } qw/ index archive individual page category /
        )
        )
    {
        return $app->error(
            $app->translate( 'Cannot clone [_1] template.', $type ), 400 );
    }

    local $app->{return_args};
    local $app->{redirect};
    local $app->{redirect_use_meta};

    $app->param( 'id', $tmpl->id );

    MT::CMS::Template::clone_templates($app);

    if ( $app->errstr ) {
        return $app->error(403);
    }

    return +{ status => 'success' };
}

1;

__END__

=head1 NAME

MT::DataAPI::Endpoint::Template::v2 - Movable Type class for endpoint definitions about the MT::Template.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
