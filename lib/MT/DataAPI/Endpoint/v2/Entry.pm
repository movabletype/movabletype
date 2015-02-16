# Movable Type (r) (C) 2001-2015 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Endpoint::v2::Entry;

use strict;
use warnings;

use MT::I18N qw( const );
use MT::App;
use MT::App::CMS;
use MT::Entry;
use MT::Import;
use MT::Util;
use MT::CMS::Import;
use MT::CMS::Export;
use MT::DataAPI::Endpoint::Common;
use MT::DataAPI::Endpoint::Entry;
use MT::DataAPI::Resource;

sub create {
    my ( $app, $endpoint ) = @_;

    my ($blog) = context_objects(@_);
    return unless $blog && $blog->id;

    my $author = $app->user;

    my $orig_entry = $app->model('entry')->new;
    $orig_entry->set_values(
        {   blog_id        => $blog->id,
            author_id      => $author->id,
            allow_comments => $blog->allow_comments_default,
            allow_pings    => $blog->allow_pings_default,
            convert_breaks => $blog->convert_paras,
            status         => (
                (          $app->can_do('publish_own_entry')
                        || $app->can_do('publish_all_entry')
                )
                ? MT::Entry::RELEASE()
                : MT::Entry::HOLD()
            )
        }
    );

    my $new_entry = $app->resource_object( 'entry', $orig_entry )
        or return;

    if (  !$new_entry->basename
        || $app->model('entry')
        ->exist( { blog_id => $blog->id, basename => $new_entry->basename } )
        )
    {
        $new_entry->basename( MT::Util::make_unique_basename($new_entry) );
    }
    MT::Util::translate_naughty_words($new_entry);

    my $post_save
        = MT::DataAPI::Endpoint::Entry::build_post_save_sub( $app, $blog,
        $new_entry, $orig_entry );

    # Check whether or not assets can attach.
    my $entry_json = $app->param('entry');
    my $entry_hash = $app->current_format->{unserialize}->($entry_json);

    my @attach_cats;
    if ( exists $entry_hash->{categories} ) {
        my $cats_hash = $entry_hash->{categories};
        $cats_hash = [$cats_hash] if ref $cats_hash ne 'ARRAY';

        my @cat_ids = map { $_->{id} }
            grep { ref $_ eq 'HASH' && $_->{id} } @$cats_hash;
        @attach_cats = MT->model('category')->load(
            {   id      => \@cat_ids,
                blog_id => $blog->id,
                class   => 'category',
            }
        );

        return $app->error( "'categories' parameter is invalid.", 400 )
            if scalar @$cats_hash == 0
            || scalar @$cats_hash != scalar @attach_cats;

        # Restore order.
        my %attach_cats_hash = map { +( $_->id => $_ ) } @attach_cats;
        @attach_cats = map { $attach_cats_hash{$_} } @cat_ids;
    }

    my @attach_assets;
    if ( exists $entry_hash->{assets} ) {
        my $assets_hash = $entry_hash->{assets};
        $assets_hash = [$assets_hash] if ref $assets_hash ne 'ARRAY';

        my @asset_ids = map { $_->{id} }
            grep { ref $_ eq 'HASH' && $_->{id} } @$assets_hash;
        my @blog_ids = ( $blog->id );
        if ( !$blog->is_blog ) {
            my @child_blogs = @{ $blog->blogs };
            my @child_blog_ids = map { $_->id } @child_blogs;
            push @blog_ids, @child_blog_ids;
        }
        @attach_assets = MT->model('asset')->load(
            {   id      => \@asset_ids,
                blog_id => \@blog_ids,
            }
        );

        return $app->error( "'assets' parameter is invalid.", 400 )
            if scalar @$assets_hash == 0
            || scalar @$assets_hash != scalar @attach_assets;
    }

    save_object( $app, 'entry', $new_entry )
        or return;

    # Attach categories and assets.
    if (@attach_cats) {
        $new_entry->attach_categories(@attach_cats)
            or return $app->error( $new_entry->errstr );
    }
    if (@attach_assets) {
        $new_entry->attach_assets(@attach_assets)
            or return $app->error( $new_entry->errstr );
    }

    $post_save->();

    $new_entry;
}

sub update {
    my ( $app, $endpoint ) = @_;

    my ( $blog, $orig_entry ) = context_objects(@_)
        or return;
    my $new_entry = $app->resource_object( 'entry', $orig_entry )
        or return;

    my $post_save
        = MT::DataAPI::Endpoint::Entry::build_post_save_sub( $app, $blog,
        $new_entry, $orig_entry );

    # Check whether or not assets can attach/detach.
    my $entry_json = $app->param('entry');
    my $entry_hash = $app->current_format->{unserialize}->($entry_json);

    my @update_cats;
    if ( exists $entry_hash->{categories} ) {
        my $cats_hash = $entry_hash->{categories};
        $cats_hash = [$cats_hash] if ref $cats_hash ne 'ARRAY';

        my @cat_ids = map { $_->{id} }
            grep { ref $_ eq 'HASH' && $_->{id} } @$cats_hash;
        @update_cats = MT->model('category')->load(
            {   id      => \@cat_ids,
                blog_id => $blog->id,
                class   => 'category',
            }
        );

        return $app->error( "'categories' parameter is invalid.", 400 )
            if scalar @$cats_hash == 0
            || scalar @$cats_hash != scalar @update_cats;

        # Restore order.
        my %update_cats_hash = map { +( $_->id => $_ ) } @update_cats;
        @update_cats = map { $update_cats_hash{$_} } @cat_ids;
    }

    my @update_assets;
    if ( exists $entry_hash->{assets} ) {
        my $assets_hash = $entry_hash->{assets};
        $assets_hash = [$assets_hash] if ref $assets_hash ne 'ARRAY';

        my @asset_ids = map { $_->{id} }
            grep { ref $_ eq 'HASH' && $_->{id} } @$assets_hash;
        my @blog_ids = ( $blog->id );
        if ( !$blog->is_blog ) {
            my @child_blogs = @{ $blog->blogs };
            my @child_blog_ids = map { $_->id } @child_blogs;
            push @blog_ids, @child_blog_ids;
        }
        @update_assets = MT->model('asset')->load(
            {   id      => \@asset_ids,
                blog_id => \@blog_ids,
            }
        );

        return $app->error( "'assets' parameter is invalid.", 400 )
            if scalar @$assets_hash == 0
            || scalar @$assets_hash != scalar @update_assets;
    }

    save_object(
        $app, 'entry',
        $new_entry,
        $orig_entry,
        sub {
          # Setting modified_by updates modified_on which we want to do before
          # a save but after pre_save callbacks fire.
            $new_entry->modified_by( $app->user->id );

            $_[0]->();
        }
    ) or return;

    # Update categories and assets.
    if (@update_cats) {
        $new_entry->update_categories(@update_cats)
            or return $app->error( $new_entry->errstr );
    }
    if (@update_assets) {
        $new_entry->update_assets(@update_assets)
            or return $app->error( $new_entry->errstr );
    }

    $post_save->();

    $new_entry;
}

sub list_for_category {
    my ( $app, $endpoint ) = @_;
    list_for_category_common( $app, $endpoint, 'entry' );
}

sub list_for_category_common {
    my ( $app, $endpoint, $class ) = @_;

    my ( $blog, $cat ) = context_objects(@_)
        or return;

    run_permission_filter( $app, 'data_api_view_permission_filter',
        $cat->class, $cat->id, obj_promise($cat) )
        or return;

    my %args = (
        join => MT->model('placement')->join_on(
            'entry_id',
            {   blog_id     => $cat->blog_id,
                category_id => $cat->id,
            },
        ),
    );
    my $res = filtered_list( $app, $endpoint, $class, undef, \%args );

    +{  totalResults => $res->{count} + 0,
        items =>
            MT::DataAPI::Resource::Type::ObjectList->new( $res->{objects} ),
    };
}

sub list_for_asset {
    my ( $app, $endpoint ) = @_;
    list_for_asset_common( $app, $endpoint, 'entry' );
}

sub list_for_asset_common {
    my ( $app, $endpoint, $class ) = @_;

    my ( $blog, $asset ) = context_objects(@_)
        or return;

    run_permission_filter( $app, 'data_api_view_permission_filter',
        'asset', $asset->id, obj_promise($asset) )
        or return;

    my %args = (
        join => MT->model('objectasset')->join_on(
            undef,
            {   blog_id   => $asset->blog_id,
                object_ds => 'entry',
                object_id => \'= entry_id',
                asset_id  => $asset->id,
            },
        ),
    );
    my $res = filtered_list( $app, $endpoint, $class, undef, \%args );

    +{  totalResults => $res->{count} + 0,
        items =>
            MT::DataAPI::Resource::Type::ObjectList->new( $res->{objects} ),
    };
}

sub list_for_tag {
    my ( $app, $endpoint ) = @_;
    list_for_tag_common( $app, $endpoint, 'entry' );
}

sub list_for_tag_common {
    my ( $app, $endpoint, $class ) = @_;

    require MT::DataAPI::Endpoint::v2::Tag;
    my $tag = MT::DataAPI::Endpoint::v2::Tag::_retrieve_tag($app) or return;

    run_permission_filter( $app, 'data_api_view_permission_filter',
        'tag', $tag->id, obj_promise($tag) )
        or return;

    my %args = (
        join => MT->model('objecttag')->join_on(
            undef,
            {   object_datasource => 'entry',
                object_id         => \'= entry_id',
                tag_id            => $tag->id,
            },
        ),
    );
    my $res = filtered_list( $app, $endpoint, $class, undef, \%args );

    +{  totalResults => $res->{count} + 0,
        items =>
            MT::DataAPI::Resource::Type::ObjectList->new( $res->{objects} ),
    };
}

sub list_for_site_and_tag {
    my ( $app, $endpoint ) = @_;
    list_for_site_and_tag_common( $app, $endpoint, 'entry' );
}

sub list_for_site_and_tag_common {
    my ( $app, $endpoint, $class ) = @_;

    require MT::DataAPI::Endpoint::v2::Tag;
    my ( $tag, $site_id )
        = MT::DataAPI::Endpoint::v2::Tag::_retrieve_tag_related_to_site($app)
        or return;

    run_permission_filter( $app, 'data_api_view_permission_filter',
        'tag', $tag->id, obj_promise($tag) )
        or return;

    my %args = (
        join => MT->model('objecttag')->join_on(
            undef,
            {   object_datasource => 'entry',
                object_id         => \'= entry_id',
                tag_id            => $tag->id,
                blog_id           => $site_id,
            },
        ),
    );
    my $res = filtered_list( $app, $endpoint, $class, undef, \%args );

    +{  totalResults => $res->{count} + 0,
        items =>
            MT::DataAPI::Resource::Type::ObjectList->new( $res->{objects} ),
    };
}

sub _check_import_parameters {
    my ( $app, $endpoint ) = @_;

    # blog_id
    my ($site) = context_objects(@_) or return;
    if ( !$site->id ) {
        return $app->error( $app->translate('Site not found'), 404 );
    }

    # import_as_me
    if ( !defined $app->param('import_as_me') ) {
        $app->param( 'import_as_me', 1 );
    }

    # password
    if ( !$app->param('import_as_me') ) {
        my $password = $app->param('password');
        if ( !defined $password || $password eq '' ) {
            return $app->error(
                $app->translate(
                    'You need to provide a parameter "password" if you are going to create new users for each user listed in your blog.'
                ),
                400,
            );
        }
        elsif ( my $error
            = $app->verify_password_strength( undef, $password ) )
        {
            return $app->error( $error, 400 );
        }
    }

    # import_type
    if ( !defined $app->param('import_type') ) {
        $app->param( 'import_type', 'import_mt' );
    }
    else {
        my $import_type = $app->param('import_type');
        my $imp         = MT::Import->new;
        my %keys        = map { $_ => 1 } $imp->importer_keys;
        if ( !$keys{$import_type} ) {
            return $app->error(
                $app->translate( 'Invalid import_type: [_1]', $import_type ),
                400
            );
        }
    }

    # default_status (when import_type is "import_mt_format").
    if ( ( $app->param('import_type') || '' ) eq 'import_mt_format'
        && !defined $app->param('default_status') )
    {
        $app->param( 'default_status', $app->blog->status_default );
    }

    # encoding
    if ( !defined $app->param('encoding') ) {
        $app->param( 'encoding', 'guess' );
    }
    else {
        my $encoding = $app->param('encoding');
        my %valid_encodings
            = map { $_->{name} => 1 } @{ const('ENCODING_NAMES') };
        if ( !$valid_encodings{$encoding} ) {
            return $app->error(
                $app->translate( 'Invalid encoding: [_1]', $encoding ), 400 );
        }
    }

    # convert_breaks
    my $text_filters
        = MT::App::CMS::load_text_filters( $app, $site->convert_paras,
        'entry' );
    if ( !defined $app->param('convert_breaks') ) {
        my $selected_key
            = map { $_->{key} } grep { $_->{selected} } @$text_filters;
        $app->param( 'convert_breaks', $selected_key );
    }
    else {
        my $convert_breaks = $app->param('convert_breaks');
        my %filter_keys = map { $_->{key} => 1 } @$text_filters;
        $filter_keys{1} = 1;
        if ( !$filter_keys{$convert_breaks} ) {
            return $app->error(
                $app->translate(
                    'Invalid convert_breaks: [_1]',
                    $convert_breaks
                ),
                400
            );
        }
    }

    # default_cat_id
    if ( my $default_cat_id = $app->param('default_cat_id') ) {
        if ( !$app->model('category')
            ->exist( { id => $default_cat_id, blog_id => $site->id } ) )
        {
            return $app->error(
                $app->translate(
                    'Invalid default_cat_id: [_1]',
                    $default_cat_id
                ),
                400
            );
        }
    }

    return 1;
}

sub import {
    my ( $app, $endpoint ) = @_;

    _check_import_parameters(@_) or return;

    local $app->{no_print_body};

    no warnings 'redefine';
    my $param;
    local *MT::build_page = sub { $param = $_[2] };
    local *MT::App::print = sub { };

    MT::CMS::Import::do_import($app) or return;

    if ( !$param->{import_success} ) {
        return $app->error(
            $app->translate(
                'An error occurred during the import process: [_1]. Please check your import file.',
                $param->{error}
            ),
            500
        );
    }

    return +{
        status => 'success',
        !$param->{import_upload}
        ? ( message => $app->translate(
                "Make sure that you remove the files that you imported from the 'import' folder, so that if/when you run the import process again, those files will not be re-imported."
            )
            )
        : (),
    };
}

sub export {
    my ( $app, $endpoint ) = @_;

    if ( !$app->param('site_id') ) {
        return $app->error( $app->translate('Site not found'), 404 );
    }

    MT::CMS::Export::export($app);

    return;
}

1;

__END__

=head1 NAME

MT::DataAPI::Endpoint::v2::Entry - Movable Type class for endpoint definitions about the MT::Entry.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
