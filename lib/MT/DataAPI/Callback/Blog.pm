# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Callback::Blog;

use strict;
use warnings;

use File::Spec;

use MT::Theme;
use MT::PublishOption;
use MT::CMS::Common;
use MT::CMS::Blog;

sub save_filter {
    my ( $eh, $app, $obj, $original ) = @_;

    # Check empty fields.
    my @not_empty_fields;
    if ( $obj->class eq 'blog' ) {
        @not_empty_fields = (
            { field => 'name',      parameter => 'name' },
            { field => 'site_path', parameter => 'sitePath' },
        );
    }
    else {
        @not_empty_fields = (
            { field => 'name',      parameter => 'name' },
            { field => 'site_url',  parameter => 'url' },
            { field => 'site_path', parameter => 'sitePath' },
        );
    }
    for (@not_empty_fields) {
        my $field = $_->{field};
        if ( !( defined $obj->column($field) ) || $obj->column($field) eq '' )
        {
            return $app->errtrans( 'A parameter "[_1]" is required.',
                $_->{parameter} );
        }
    }

    # Check positive interger fields when set.
    my @positive_integer_columns
        = qw( max_revisions_entry max_revisions_template );
    for my $col (@positive_integer_columns) {
        if ( defined $obj->$col && $obj->$col !~ m/^\d+$/ ) {
            return $eh->error(
                $app->translate(
                    "The number of revisions to store must be a positive integer."
                )
            );
        }
    }

    # Check whether blog has a preferred archive type or not.
    if ( _blog_has_archive_type($obj) && !$obj->archive_type_preferred ) {
        return $eh->error(
            $app->translate("Please choose a preferred archive type.") );
    }

    # Check site_path.
    my $site_path = $obj->column('site_path');
    if ( $obj->class eq 'blog' ) {

        # Check whether site_path is within BaseSitePath or not,
        # if site_path is absolute.
        if ( $app->config->BaseSitePath
            && File::Spec->file_name_is_absolute($site_path) )
        {
            my $l_path = $app->config->BaseSitePath;
            unless (
                MT::CMS::Common::is_within_base_sitepath( $app, $site_path ) )
            {
                return $app->errtrans(
                    "The blog root directory must be within [_1].", $l_path );
            }
        }

    }
    else {

        # Check whether site_path is within BaseSitePath or not.
        if ( $site_path and $app->config->BaseSitePath ) {
            my $l_path = $app->config->BaseSitePath;
            unless (
                MT::CMS::Common::is_within_base_sitepath( $app, $site_path ) )
            {
                return $app->errtrans(
                    "The website root directory must be within [_1].",
                    $l_path );
            }
        }

        # Check whether site_path is absolute or not.
        if ( $site_path
            and not File::Spec->file_name_is_absolute($site_path) )
        {
            return $app->errtrans(
                "The website root directory must be an absolute path: [_1]",
                $site_path );
        }

    }

    my $theme = MT::Theme->load( $obj->theme_id );

    # Check whether theme_id is valid or not.
    if ( !$theme ) {
        return $app->errtrans( 'Invalid theme_id: [_1]', $obj->theme_id );
    }

    # Cannot aplly website theme to blog.
    if ( $obj->is_blog && $theme->{class} eq 'website' ) {
        return $app->errtrans( 'Cannot apply website theme to blog: [_1]',
            $obj->theme_id );
    }

    return 1;
}

sub _update_dynamicity {

    my $app = shift;
    my ( $blog, $blog_hash ) = @_;

    my $mtview_path = File::Spec->catfile( $blog->site_path(), "mtview.php" );
    my $cache       = 0;
    my $conditional = 0;
    if ( -f $mtview_path ) {
        open my $fh, "<", $mtview_path
            or die "Couldn't open $mtview_path: $!";
        while ( my $line = <$fh> ) {
            $cache = 1
                if $line =~ m/^\s*\$mt->caching\(true\);/i;
            $conditional = 1
                if $line =~ /^\s*\$mt->conditional\(true\);/i;
        }
        close $fh;
    }

    $cache       = 1 if $blog_hash->{dynamicCache};
    $conditional = 1 if $blog_hash->{dynamicConditional};

    if ($app->model('template')->exist(
            {   blog_id    => $blog->id,
                build_type => MT::PublishOption::DYNAMIC()
            }
        )
        || $app->model('templatemap')->exist(
            {   blog_id    => $blog->id,
                build_type => MT::PublishOption::DYNAMIC()
            }
        )
        )
    {

        # dynamic publishing enabled
        MT::CMS::Blog::prepare_dynamic_publishing( $app, $blog, $cache,
            $conditional, $blog->site_path, $blog->site_url );
        if ( $blog->archive_path ) {
            MT::CMS::Blog::prepare_dynamic_publishing( $app, $blog, $cache,
                $conditional, $blog->archive_path, $blog->archive_url );
        }
    }

}

# This method is not registered to callback.
# This method is called from MT::CMS::Blog::post_save().
sub post_save {
    my $eh = shift;
    my ( $app, $obj, $original ) = @_;

    my $blog_id = $obj->id;

    # Generate site_url and set.
    my $site_json = $app->param( $obj->class );
    my $site_hash = $app->current_format->{unserialize}->($site_json);

    if ( ( $obj->custom_dynamic_templates || '' ) ne
        ( $original->custom_dynamic_templates || '' ) )
    {

        my $dcty = $obj->custom_dynamic_templates;

# Apply publishing rules for templates based on
# publishing method selected:
#     none (0% publish queue, all static)
#     async_all (100% publish queue)
#     async_partial (high-priority templates publish synchronously (main index, preferred entry_based/contenttype_based archives, feed templates))
#     all (100% dynamic)
#     archives (archives dynamic, static indexes)
#     custom (custom configuration)

        MT::CMS::Blog::update_publishing_profile( $app, $obj );

        if ( ( $dcty eq 'none' ) || ( $dcty =~ m/^async/ ) ) {
            MT::CMS::Blog::_update_finfos( $app, 0 );
        }
        elsif ( $dcty eq 'all' ) {
            MT::CMS::Blog::_update_finfos( $app, 1 );
        }
        elsif ( $dcty eq 'archives' ) {

            # Only archives have template maps.
            MT::CMS::Blog::_update_finfos( $app, 1,
                { templatemap_id => \'is not null' } );
            MT::CMS::Blog::_update_finfos( $app, 0,
                { templatemap_id => \'is null' } );
        }
    }

    MT::CMS::Blog::cfg_publish_profile_save( $app, $obj ) or return;

    # Update dynamic_cache and dynamic_conditional.
    if ((   $app->model('template')->exist(
                {   blog_id    => $obj->id,
                    build_type => MT::PublishOption::DYNAMIC()
                }
            )
            || $app->model('templatemap')->exist(
                {   blog_id    => $obj->id,
                    build_type => MT::PublishOption::DYNAMIC()
                }
            )
        )
        )
    {

        # dynamic enabled and caching option may have changed - update mtview
        my $cache       = $site_hash->{dynamicCache}       ? 1 : 0;
        my $conditional = $site_hash->{dynamicConditional} ? 1 : 0;
        MT::CMS::Blog::_create_mtview( $obj, $obj->site_path, $cache,
            $conditional );
        MT::CMS::Blog::_create_dynamiccache_dir( $obj, $obj->site_path )
            if $cache;
        if ( $obj->archive_path ) {
            MT::CMS::Blog::_create_mtview( $obj, $obj->archive_path, $cache,
                $conditional );
            MT::CMS::Blog::_create_dynamiccache_dir( $obj,
                $obj->archive_path )
                if $cache;
        }
    }

    # If either of the publishing paths changed, rebuild the fileinfos.
    my $path_changed = 0;
    for my $path_field (qw( site_path archive_path site_url archive_url )) {
        if (( defined $obj->$path_field() ? $obj->$path_field() : '' ) ne (
                defined $original->$path_field()
                ? $original->$path_field()
                : ''
            )
            )
        {
            $path_changed = 1;
            last;
        }
    }

    if ($path_changed) {
        _update_dynamicity( $app, $obj, $site_hash );
        $app->rebuild( BlogID => $obj->id, NoStatic => 1 )
            or $app->publish_error();
    }

 #    # Update entry_custom_prefs and page_custom_prefs.
 #    # FIXME: Needs to exclude MT::Permission records for groups
 #    my $perms = $app->model('permission')
 #        ->load( { blog_id => $blog_id, author_id => 0 } );
 #    if ( !$perms ) {
 #        $perms = $app->model('permission')->new;
 #        $perms->blog_id($blog_id);
 #        $perms->author_id(0);
 #    }
 #    foreach my $type (qw(entry page)) {
 #        my $prefs = join ',', @{ $site_hash->{$type.'CustomPrefs'} };
 #        if ($prefs) {
 #            my $prefs_type = $type . '_prefs';
 #            $perms->$prefs_type($prefs);
 #            $perms->save
 #                or return $app->errtrans( "Saving permissions failed: [_1]",
 #                $perms->errstr );
 #        }
 #    }

    # Update DefaultAssignments.
    my $new_default_roles = $site_hash->{newCreatedUserRoles};
    if ( ref($new_default_roles) eq 'ARRAY' ) {
        my @hash_role_ids = grep {$_} map { $_->{id} } @$new_default_roles;
        my @roles = MT->model('role')->load( { id => \@hash_role_ids } );
        my @role_ids = map { $_->id } @roles;

        my @def = split ',', $app->config('DefaultAssignments');
        my @defaults;
        while ( my $r_id = shift @def ) {
            my $b_id = shift @def;
            next if $b_id eq $blog_id;
            push @defaults, join( ',', $r_id, $b_id );
        }
        push @defaults, join( ',', $_, $blog_id ) for @role_ids;
        $app->config( 'DefaultAssignments', join( ',', @defaults ), 1 );
        $app->config->save_config;
    }

    return 1;
}

sub _blog_has_archive_type {
    my ($blog) = @_;
    my $app = MT->instance;

    my $has_archive_type;
    for my $at ( split /\s*,\s*/, $blog->archive_type ) {
        my $archiver = $app->publisher->archiver($at);
        next unless $archiver;
        next if 'entry' ne $archiver->entry_class;
        $has_archive_type = 1;
        last;
    }

    return $has_archive_type;
}

sub cms_pre_load_filtered_list {
    my ( $cb, $app, $filter, $load_options, $cols ) = @_;

    my $terms = $load_options->{terms};
    delete $terms->{blog_id};
    $terms->{parent_id} = $load_options->{blog_id}
        if $app->blog;
    $terms->{class} = 'blog' unless $terms->{class} eq '*';

    if ( my $user = $load_options->{user} ) {

        return   if $user->is_superuser;
        return 1 if $user->permissions(0)->can_do('edit_templates');

        my $iter = MT::Permission->load_iter(
            {   author_id   => $user->id,
                blog_id     => { not => 0 },
                permissions => { not => 'comment' },
            }
        );

        my $blog_ids = [];
        while ( my $perm = $iter->() ) {
            push @$blog_ids, $perm->blog_id if $perm->blog_id;
        }
        if ( $terms->{class} eq '*' ) {
            push @$blog_ids,
                map { $_->parent_id } $app->model('blog')->load(
                { class     => 'blog', id => $blog_ids },
                { fetchonly => ['parent_id'] }
                );
        }

        if ( $blog_ids && @$blog_ids ) {
            if ( $terms->{class} eq '*' ) {
                delete $terms->{class};
                $load_options->{args}{no_class} = 1;
            }
            $terms->{id} = $blog_ids;
        }
        else {
            $terms->{id} = 0;
        }

    }

    $load_options->{terms} = $terms;
}

1;

__END__

=head1 NAME

MT::DataAPI::Callback::Blog - Movable Type class for Data API's callbacks about the MT::Blog.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
