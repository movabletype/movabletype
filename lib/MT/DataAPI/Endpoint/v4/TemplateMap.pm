# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Endpoint::v4::TemplateMap;

use strict;
use warnings;

use MT::DataAPI::Endpoint::Common;
use MT::DataAPI::Endpoint::v2::TemplateMap;
use MT::DataAPI::Resource;

my %SupportedType
    = map { $_ => 1 } qw/ archive individual page category ct ct_archive /;

sub list_openapi_spec {
    return MT::DataAPI::Endpoint::v2::TemplateMap::list_openapi_spec;
}

sub list {
    my ( $app, $endpoint ) = @_;

    my ( $site, $tmpl ) = context_objects(@_) or return;

    return if !_is_archive_template( $app, $tmpl );

    my %terms = (
        blog_id     => $site->id,
        template_id => $tmpl->id,
    );

    my $res = filtered_list( $app, $endpoint, 'templatemap', \%terms )
        or return;

    return +{
        totalResults => $res->{count} + 0,
        items =>
            MT::DataAPI::Resource::Type::ObjectList->new( $res->{objects} ),
    };
}

sub get_openapi_spec {
    return MT::DataAPI::Endpoint::v2::TemplateMap::get_openapi_spec;
}

sub get {
    my ( $app, $endpoint ) = @_;

    my ( $site, $tmpl, $map ) = context_objects(@_) or return;

    return if !_is_archive_template( $app, $tmpl );

    run_permission_filter( $app, 'data_api_view_permission_filter',
        'templatemap', $map->id, obj_promise($map) )
        or return;

    return $map;
}

sub create_openapi_spec {
    return MT::DataAPI::Endpoint::v2::TemplateMap::create_openapi_spec;
}

sub create {
    my ( $app, $endpoint ) = @_;

    my ( $site, $tmpl ) = context_objects(@_) or return;

    return if !_is_archive_template( $app, $tmpl );

    my $orig_map = $app->model('templatemap')->new;
    $orig_map->set_values(
        {   blog_id      => $tmpl->blog_id,
            template_id  => $tmpl->id,
            is_preferred => 0,
        }
    );

    my $new_map = $app->resource_object( 'templatemap', $orig_map ) or return;

    save_object( $app, 'templatemap', $new_map ) or return;

    return $new_map;
}

sub update_openapi_spec {
    return MT::DataAPI::Endpoint::v2::TemplateMap::update_openapi_spec;
}

sub update {
    my ( $app, $endpoint ) = @_;

    my ( $site, $tmpl, $orig_map ) = context_objects(@_) or return;

    return if !_is_archive_template( $app, $tmpl );

    my $new_map = $app->resource_object( 'templatemap', $orig_map ) or return;

    save_object( $app, 'templatemap', $new_map, $orig_map ) or return;

    return $new_map;
}

sub delete_openapi_spec {
    return MT::DataAPI::Endpoint::v2::TemplateMap::delete_openapi_spec;
}

sub delete {
    my ( $app, $endpoint ) = @_;

    my ( $site, $tmpl, $map ) = context_objects(@_) or return;

    return if !_is_archive_template( $app, $tmpl );

    run_permission_filter( $app, 'data_api_delete_permission_filter',
        'templatemap', $map )
        or return;

    $map->remove
        or return $app->error(
        $app->translate(
            'Removing [_1] failed: [_2]',
            $map->class_label, $map->errstr
        ),
        500,
        );

    $app->run_callbacks( 'data_api_post_delete.templatemap', $app, $map );

    return $map;
}

sub _is_archive_template {
    my ( $app, $tmpl ) = @_;

    if ( !$SupportedType{ $tmpl->type } ) {
        return $app->error(
            $app->translate(
                'Template "[_1]" is not an archive template.',
                $tmpl->name
            ),
            400
        );
    }

    return 1;
}

1;

__END__

=head1 NAME

MT::DataAPI::Endpoint::v4::TemplateMap - Movable Type class for endpoint definitions about the MT::TemplateMap.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
