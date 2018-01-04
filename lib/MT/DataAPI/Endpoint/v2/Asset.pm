# Movable Type (r) (C) 2001-2018 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Endpoint::v2::Asset;

use strict;
use warnings;

use MT::DataAPI::Endpoint::Asset;
use MT::DataAPI::Endpoint::Common;
use MT::DataAPI::Endpoint::v2::Tag;
use MT::DataAPI::Resource;

sub list {
    my ( $app, $endpoint ) = @_;

    my $res = filtered_list( $app, $endpoint, 'asset' )
        or return;

    +{  totalResults => $res->{count} + 0,
        items =>
            MT::DataAPI::Resource::Type::ObjectList->new( $res->{objects} ),
    };
}

sub get {
    my ( $app, $endpoint ) = @_;

    my ( $blog, $asset ) = context_objects(@_)
        or return;

    run_permission_filter( $app, 'data_api_view_permission_filter',
        'asset', $asset->id, obj_promise($asset) )
        or return;

    $asset;
}

sub get_thumbnail {
    my ( $app, $endpoint ) = @_;

    my $asset = get(@_) or return;

    if ( !$asset->isa('MT::Asset::Image') ) {
        return $app->error(
            $app->translate(
                'The asset does not support generating a thumbnail file.'),
            400
        );
    }

    my $width  = $app->param('width');
    my $height = $app->param('height');
    my $scale  = $app->param('scale');
    my $square = $app->param('square');

    if ( $width && $width !~ m/^\d+$/ ) {
        return $app->error( $app->translate( 'Invalid width: [_1]', $width ),
            400 );
    }
    if ( $height && $height !~ m/^\d+$/ ) {
        return $app->error(
            $app->translate( 'Invalid height: [_1]', $height ), 400 );
    }
    if ( $scale && $scale !~ m/^\d+$/ ) {
        return $app->error( $app->translate( 'Invalid scale: [_1]', $scale ),
            400 );
    }

    my %param = (
        $width  ? ( Width  => $width )  : (),
        $height ? ( Height => $height ) : (),
        $scale  ? ( Scale  => $scale )  : (),
        ( $square && $square eq 'true' ) ? ( Square => 1 ) : (),
    );

    my ( $thumbnail, $w, $h ) = $asset->thumbnail_url(%param)
        or return $app->error( $asset->error, 500 );

    return +{
        url    => $thumbnail,
        width  => $w,
        height => $h,
    };
}

sub update {
    my ( $app, $endpoint ) = @_;

    my ( $blog, $orig_asset ) = context_objects(@_)
        or return;
    my $new_asset = $app->resource_object( 'asset', $orig_asset )
        or return;

    save_object( $app, 'asset', $new_asset, $orig_asset, ) or return;

    $new_asset;
}

sub delete {
    my ( $app, $endpoint ) = @_;

    my ( $blog, $asset ) = context_objects(@_)
        or return;

    run_permission_filter( $app, 'data_api_delete_permission_filter',
        'asset', $asset )
        or return;

    $asset->remove
        or return $app->error(
        $app->translate(
            'Removing [_1] failed: [_2]', $asset->class_label,
            $asset->errstr
        ),
        500
        );

    $app->run_callbacks( 'data_api_post_delete.asset', $app, $asset );

    $asset;
}

sub list_for_entry {
    my ( $app, $endpoint ) = @_;
    return _list_for_entry( $app, $endpoint, 'entry' );
}

sub list_for_page {
    my ( $app, $endpoint ) = @_;
    return _list_for_entry( $app, $endpoint, 'page' );
}

sub _list_for_entry {
    my ( $app, $endpoint, $class ) = @_;

    my ( $blog, $entry ) = context_objects(@_)
        or return;

    run_permission_filter( $app, 'data_api_view_permission_filter',
        $class, $entry->id, obj_promise($entry) )
        or return;

    my %terms = ( class => '*' );
    my %args = (
        join => MT->model('objectasset')->join_on(
            'asset_id',
            {   blog_id   => $blog->id,
                object_ds => 'entry',
                object_id => $entry->id,
            },
        ),
    );
    my $res = filtered_list( $app, $endpoint, 'asset', \%terms, \%args )
        or return;

    +{  totalResults => $res->{count},
        items =>
            MT::DataAPI::Resource::Type::ObjectList->new( $res->{objects} ),
    };
}

sub list_for_tag {
    my ( $app, $endpoint ) = @_;

    my $tag = MT::DataAPI::Endpoint::v2::Tag::_retrieve_tag($app) or return;

    run_permission_filter( $app, 'data_api_view_permission_filter',
        'tag', $tag->id, obj_promise($tag) )
        or return;

    my %terms = ( class => '*' );
    my %args = (
        join => MT->model('objecttag')->join_on(
            undef,
            {   object_id         => \'= asset_id',
                object_datasource => 'asset',
                blog_id           => \'= asset_blog_id',
                tag_id            => $tag->id,
            },
        ),
    );
    my $res = filtered_list( $app, $endpoint, 'asset', \%terms, \%args )
        or return;

    return +{
        totalResults => ( $res->{count} || 0 ),
        items =>
            MT::DataAPI::Resource::Type::ObjectList->new( $res->{objects} ),
    };
}

sub list_for_site_and_tag {
    my ( $app, $endpoint ) = @_;

    my ( $tag, $site_id )
        = MT::DataAPI::Endpoint::v2::Tag::_retrieve_tag_related_to_site($app)
        or return;

    run_permission_filter( $app, 'data_api_view_permission_filter',
        'tag', $tag->id, obj_promise($tag) )
        or return;

    my %terms = ( class => '*' );
    my %args = (
        join => MT->model('objecttag')->join_on(
            undef,
            {   object_id         => \'= asset_id',
                object_datasource => 'asset',
                blog_id           => $site_id,
                tag_id            => $tag->id,
            },
        ),
    );
    my $res = filtered_list( $app, $endpoint, 'asset', \%terms, \%args )
        or return;

    return +{
        totalResults => ( $res->{count} || 0 ),
        items =>
            MT::DataAPI::Resource::Type::ObjectList->new( $res->{objects} ),
    };
}

sub upload {
    my ( $app, $endpoint ) = @_;

    my $site_id = $app->param('site_id');
    if ( !( defined($site_id) && $site_id =~ m/^\d+$/ ) ) {
        return $app->error(
            $app->translate( 'A parameter "[_1]" is required.', 'site_id' ),
            400 );
    }

    $app->param( 'blog_id', $site_id );
    $app->delete_param('site_id');

    my $site = MT->model('blog')->load($site_id);
    $app->blog($site);

    MT::DataAPI::Endpoint::Asset::upload( $app, $endpoint );
}

1;

__END__

=head1 NAME

MT::DataAPI::Endpoint::v2::Asset - Movable Type class for endpoint definitions about the MT::Asset.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
