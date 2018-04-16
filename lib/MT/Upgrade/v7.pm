# Movable Type (r) (C) 2001-2018 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::Upgrade::v7;
use strict;
use warnings;

sub upgrade_functions {
    return {
        'v7_reset_default_widget' => {
            version_limit => 7.0012,
            priority      => 5.0,
            updater       => {
                type  => 'author',
                label => "Reset default dashboard widgets...",
                code  => \&_v7_reset_default_widget,
            },
        },
        'v7_create_new_role' => {
            version_limit => 7.0012,
            priority      => 3.1,
            code          => \&_v7_create_new_role,
        },
        'v7_migrate_website_administrator' => {
            version_limit => 7.0012,
            priority      => 3.2,
            code          => \&_v7_migrate_role,
        },
        'v7_migrate_privileges' => {
            version_limit => 7.0012,
            priority      => 3.3,
            code          => \&_v7_migrate_privileges,
        },
        'v7_migrate_blog_templatemap_archive_type' => {
            code          => \&_v7_migrate_blog_templatemap_archive_type,
            version_limit => 7.0014,
            priority      => 3.1,
        },
        'v7_migrate_child_site_role' => {
            code          => \&_v7_migrate_child_site_role,
            version_limit => 7.0017,
            priority      => 3.5,
        },
        'v7_rebuild_object_categories' => {
            code          => \&_v7_rebuild_object_categories,
            version_limit => 7.0019,
            priority      => 3.2,
        },
        'v7_rebuild_object_tags' => {
            code          => \&_v7_rebuild_object_tags,
            version_limit => 7.0020,
            priority      => 3.2,
        },
        'v7_rebuild_object_assets' => {
            code          => \&_v7_rebuild_object_assets,
            version_limit => 7.0021,
            priority      => 3.2,
        },
        'v7_rebuild_content_field_permissions' => {
            code          => \&_v7_rebuild_content_field_permissions,
            version_limit => 7.0022,
            priority      => 3.2,
        },
        'v7_migrate_system_privileges' => {
            code          => \&_migrate_system_privileges,
            version_limit => 7.0023,
            priority      => 3.5,
        },
        'v7_remove_create_child_sites' => {
            code          => \&_v7_remove_create_child_sites,
            version_limit => 7.0024,
            priority      => 3.2,
        },
        'v7_migrate_rebuild_trigger' => {
            code          => \&v7_migrate_rebuild_trigger,
            version_limit => 7.0025,
            priority      => 3.2,
        },
        'v7_migrate_content_type_fields_column' => {
            code          => \&_v7_migrate_content_type_fields_column,
            version_limit => 7.0027,
            priority      => 3.2,
        },
        'v7_migrate_content_data_data_column' => {
            code          => \&_v7_migrate_content_data_data_column,
            version_limit => 7.0027,
            priority      => 3.3,
        },
        'v7_rebuild_number_filed_indexes' => {
            code          => \&_v7_rebuild_number_field_indexes,
            version_limit => 7.0029,
            priority      => 3.2,
        },
        'v7_rebuild_multi_line_text_field_indexes' => {
            code          => \&_v7_rebuild_multi_line_text_field_indexes,
            version_limit => 7.0031,
            priority      => 3.2,
        },
        'v7_rebuild_tables_field_indexes' => {
            code          => \&_v7_rebuild_tables_field_indexes,
            version_limit => 7.0032,
            priority      => 3.2,
        },
        'v7_rebuild_embedded_text_field_indexes' => {
            code          => \&_v7_rebuild_embedded_text_field_indexes,
            version_limit => 7.0033,
            priority      => 3.2,
        },
        'v7_rebuild_url_field_indexes' => {
            code          => \&_v7_rebuild_url_field_indexes,
            version_limit => 7.0034,
            priority      => 3.2,
        },
        'v7_rebuild_single_line_text_field_indexes' => {
            code          => \&_v7_rebuild_single_line_text_field_indexes,
            version_limit => 7.0036,
            priority      => 3.2,
        },
        'v7_rebuild_permissions' => {
            code          => \&_v7_rebuild_permissions,
            version_limit => 7.0039,
            priority      => 3.2,
        },
        'v7_cleanup_content_field_indexes' => {
            code          => \&_v7_cleanup_content_field_indexes,
            version_limit => 7.0040,
            priority      => 3.2,
        },
        'v7_cleanup_object_assets_for_content_data' => {
            code          => \&_v7_cleanup_object_assets_for_content_data,
            version_limit => 7.0040,
            priority      => 3.2,
        },
        'v7_cleanup_object_categories_for_content_data' => {
            code          => \&_v7_cleanup_object_categories_for_content_data,
            version_limit => 7.0040,
            priority      => 3.2,
        },
        'v7_cleanup_object_tags_for_content_data' => {
            code          => \&_v7_cleanup_object_tags_for_content_data,
            version_limit => 7.0040,
            priority      => 3.2,
        },
        'v7_migrate_category_set_categories' => {
            version_limit => 7.0041,
            priority      => 3.6,
            updater       => {
                type      => 'category',
                condition => sub {
                    $_[0]->class eq 'category' && $_[0]->category_set_id > 0;
                },
                code  => sub { $_[0]->class('category_set_category') },
                label => 'Migrating category records for category set...',
                sql   => <<__SQL__,
UPDATE mt_category
SET    category_class = 'category_set_category'
WHERE  category_class = 'category'
  AND  category_category_set_id > 0;
__SQL__
            },
        },
    };
}

sub _v7_reset_default_widget {
    my $user        = shift;
    my $widgets     = $user->widgets;
    my $new_widgets = {};

    # System
    $new_widgets->{'dashboard:system'}->{'notification_dashboard'} = {
        order => 0,
        set   => 'main',
    };
    $new_widgets->{'dashboard:system'}->{'system_information'} = {
        order => 100,
        set   => 'main',
    };
    $new_widgets->{'dashboard:system'}->{'updates'} = {
        order => 0,
        set   => 'sidebar',
    };
    $new_widgets->{'dashboard:system'}->{'mt_news'} = {
        order => 100,
        set   => 'sidebar',
    };
    $new_widgets->{'dashboard:system'}->{'activity_log'} = {
        order => 200,
        set   => 'sidebar',
    };

    # User Dashboard
    $new_widgets->{'dashboard:system'}->{'updates'} = {
        order => 0,
        set   => 'sidebar',
    };
    $new_widgets->{'dashboard:user'}->{'mt_news'} = {
        order => 100,
        set   => 'sidebar',
    };
    $new_widgets->{'dashboard:user'}->{'activity_log'} = {
        order => 200,
        set   => 'sidebar',
    };
    $new_widgets->{'dashboard:user'}->{'notification_dashboard'} = {
        order => 0,
        set   => 'main',
    };
    $new_widgets->{'dashboard:user'}->{'site_list'} = {
        order => 100,
        set   => 'main',
    };

    # Site
    foreach my $key ( keys %$widgets ) {
        if ( $key =~ m/^dashboard:blog:/ ) {
            $new_widgets->{$key}->{'site_list'} = {
                order => 100,
                set   => 'main',
            };
            $new_widgets->{$key}->{'site_stats'} = {
                order => 200,
                set   => 'main',
            };
            $new_widgets->{$key}->{'activity_log'} = {
                order => 200,
                set   => 'sidebar',
            };
        }
    }

    # Reset user settings
    $user->widgets($new_widgets);
    $user->save;
}

sub _v7_create_new_role {
    my $self       = shift;
    my $role_class = MT->model('role');

    my @default_roles = $role_class->_default_roles();
    foreach my $r (@default_roles) {
        next if ( $role_class->exist( { name => $r->{name} } ) );
        $self->progress(
            $self->translate_escape( 'Create new role: [_1]...', $r->{name} )
        );
        my $new_role = $role_class->new();
        $new_role->name( $r->{name} );
        $new_role->description( $r->{description} );
        $new_role->clear_full_permissions;
        $new_role->set_these_permissions( $r->{perms} );

        if ( $r->{name} =~ m/^System/ ) {
            $new_role->is_system(1);
        }
        $new_role->role_mask( $r->{role_mask} ) if exists $r->{role_mask};
        $new_role->save or return $self->error( $new_role->errstr );
    }
}

sub _v7_migrate_role {
    my $self = shift;

    my $role_class = MT->model('role');

    $self->progress(
        $self->translate_escape('Updating existing role name...') );

    my @role_names = ( 'Designer', 'Author', 'Contributor', 'Editor' );
    my @default_roles = $role_class->_default_roles();
    foreach my $r (@default_roles) {
        next unless grep { $r->{name} eq MT->translate($_) } @role_names;
        $self->progress(
            $self->translate_escape(
                'change [_1] to [_2]',
                $r->{name},
                MT->translate( $r->{name} . ' (MT6)' )
            )
        );

        my $iter = $role_class->load_iter( { name => $r->{name} } );
        while ( my $role = $iter->() ) {
            $role->name( MT->translate( $r->{name} . ' (MT6)' ) );
            $role->save
                or return $self->error(
                $self->translate_escape(
                    "Error saving record: [_1].",
                    $role->errstr
                )
                );
        }

        $self->progress(
            $self->translate_escape( 'Create new role: [_1]...', $r->{name} )
        );

        my $role = MT::Role->new();
        $role->name( $r->{name} );
        $role->description( $r->{description} );
        $role->clear_full_permissions;
        $role->set_these_permissions( $r->{perms} );
        if ( $r->{name} =~ m/^System/ ) {
            $role->is_system(1);
        }
        $role->role_mask( $r->{role_mask} ) if exists $r->{role_mask};
        $role->save
            or return $role->error( $role->errstr );
    }

    # Website Administrator
    my $webadmin_role = MT->translate('Website Administrator');
    my $iter = $role_class->load_iter( { name => $webadmin_role } );
    while ( my $role = $iter->() ) {
        $self->progress(
            $self->translate_escape(
                'change [_1] to [_2]',
                $webadmin_role,
                MT->translate( $webadmin_role . ' (MT6)' )
            )
        );
        $role->name( MT->translate( $webadmin_role . ' (MT6)' ) );
        $role->set_these_permissions( ['administer_site'] );
        $role->save
            or return $self->error(
            $self->translate_escape(
                "Error saving record: [_1].",
                $role->errstr
            )
            );
    }

}

sub _v7_migrate_privileges {
    my $self = shift;

    my $role_class  = MT->model('role');
    my $assoc_class = MT->model('association');

    $self->progress(
        $self->translate_escape(
            'Assign a Site Administrator Role for Manage Website...')
    );

    my $site_admin_role
        = $role_class->load(
        { name => MT->translate('Site Administrator') } );

    my @website_admin_roles
        = $role_class->load_by_permission("administer_website");
    foreach my $website_admin_role (@website_admin_roles) {
        $website_admin_role->set_these_permissions( ['administer_site'] );
        $website_admin_role->save
            or return $self->error(
            $self->translate_escape(
                "Error saving record: [_1].",
                $website_admin_role->errstr
            )
            );

        my $assoc_iter
            = $assoc_class->load_iter(
            { role_id => $website_admin_role->id } );
        while ( my $assoc = $assoc_iter->() ) {
            my $blog   = $assoc->blog;
            my $author = $assoc->user;
            $author->add_role( $site_admin_role, $blog );

        }
    }

    $self->progress(
        $self->translate_escape(
            'Assign a Site Administrator Role for Manage Website with Blogs...'
        )
    );

    my @member_blogs_roles
        = $role_class->load_by_permission("manage_member_blogs");

    foreach my $member_role (@member_blogs_roles) {
        my $assoc_iter
            = $assoc_class->load_iter( { role_id => $member_role->id } );
        while ( my $assoc = $assoc_iter->() ) {
            my $blog   = $assoc->blog;
            my $author = $assoc->user;
            $author->add_role( $site_admin_role, $blog );
            if ( $blog && !$blog->is_blog ) {
                my @child_blogs = @{ $blog->blogs };
                foreach my $child_blog (@child_blogs) {
                    my $author = $assoc->user;
                    $author->add_role( $site_admin_role, $child_blog );
                }
            }
        }
    }

    $self->progress(
        $self->translate_escape(
            'add administer_site permission for Blog Administrator...')
    );
    my @blog_admin_roles = $role_class->load_by_permission("administer_blog");
    foreach my $blog_admin_role (@blog_admin_roles) {
        $blog_admin_role->set_these_permissions( ['administer_site'] );
        $blog_admin_role->save
            or return $self->error(
            $self->translate_escape(
                "Error saving record: [_1].",
                $blog_admin_role->errstr
            )
            );

        my $assoc_iter
            = $assoc_class->load_iter( { role_id => $blog_admin_role->id } );
        while ( my $assoc = $assoc_iter->() ) {
            my $blog   = $assoc->blog;
            my $author = $assoc->user;
            $author->add_role( $site_admin_role, $blog );

        }

    }

}

sub _migrate_system_privileges {
    my $self = shift;

    $self->progress(
        $self->translate_escape(
            'Migrating system level permissions to new structure...')
    );

    my $iter = MT->model('author')->load_iter(
        {   status => MT::Author::ACTIVE(),
            type   => MT::Author::AUTHOR(),
        }
    );
    while ( my $author = $iter->() ) {
        $author->can_sign_in_cms(1);
        $author->can_sign_in_data_api(1);
        $author->can_create_site(1)
            if ( $author->permissions(0)->permissions =~ /'create_website'/ );
        $author->save
            or return $self->error(
            $self->translate_escape(
                "Error saving record: [_1].",
                $author->errstr
            )
            );
    }
}

sub _v7_migrate_blog_templatemap_archive_type {
    my $self = shift;

    my @sites = MT->model('website')->load();
    foreach my $site (@sites) {
        _migrate_site_archive_type( $self, $site );
    }

    my @blogs = MT->model('blog')->load();
    foreach my $blog (@blogs) {
        _migrate_site_archive_type( $self, $blog );
    }

    my @maps = MT->model('templatemap')->load();
    foreach my $map (@maps) {
        my $type = $map->archive_type;
        $type =~ s/_/-/;
        $map->archive_type($type);
        $map->save
            or return $self->error(
            $self->translate_escape(
                "Error saving record: [_1].",
                $map->errstr
            )
            );
    }
}

sub _migrate_site_archive_type {
    my ( $self, $site ) = @_;

    my @archive_type = split ',', $site->archive_type;
    my %hash = map { $_, 1 } map { $_ =~ s/_/-/; $_; } @archive_type;
    my @unique_archive_type = sort keys %hash;
    $site->archive_type( join( ',', @unique_archive_type ) );
    $site->save
        or return $self->error(
        $self->translate_escape(
            "Error saving record: [_1].", $site->errstr
        )
        );
}

sub _v7_migrate_child_site_role {
    my $self        = shift;
    my $role_class  = MT->model('role');
    my $assoc_class = MT->model('association');

    $self->progress(
        $self->translate_escape(
            'Changing the Child Site Administrator role to the Site Administrator role.'
        )
    );

    my $site_admin_role = $role_class->load(
        { name => MT->translate('Site Administrator') } );
    my $child_site_admin_role = $role_class->load(
        { name => MT->translate('Child Site Administrator') } );

    if ($child_site_admin_role) {
        my $iter
            = $assoc_class->load_iter(
            { role_id => $child_site_admin_role->id } );
        while ( my $assoc = $iter->() ) {
            my $blog   = $assoc->blog;
            my $author = $assoc->user;
            $author->add_role( $site_admin_role, $blog );

            # Child Site Administrator is remove
            $assoc->remove();
        }

        # Child Site Administrator Role is remove
        $child_site_admin_role->remove();
    }
}

sub _v7_rebuild_object_categories {
    my $self = shift;

    $self->progress(
        $self->translate_escape('Rebuilding object categories...') );

    MT->model('objectcategory')->remove( { object_ds => 'content_field' } )
        or return $self->error(
        $self->translate_escape(
            'Error removing records: [_1]',
            MT->model('objectcategory')->errstr,
        )
        );

    my @category_fields
        = MT->model('content_field')->load( { type => 'categories' } );
    for my $cat_field (@category_fields) {
        my @content_data = MT->model('content_data')
            ->load( { content_type_id => $cat_field->content_type_id } );
        for my $cd (@content_data) {
            my $category_ids = $cd->data->{ $cat_field->id } || [];
            if ( ref $category_ids ne 'ARRAY' ) {
                $category_ids = [$category_ids];
            }
            @$category_ids = grep {$_} @$category_ids;

            my $is_primary = 1;
            for my $cat_id (@$category_ids) {
                my $oc = MT->model('objectcategory')->new(
                    blog_id     => $cd->blog_id,
                    object_id   => $cd->id,
                    object_ds   => 'content_data',
                    category_id => $cat_id,
                    is_primary  => $is_primary,
                    cf_id       => $cat_field->id,
                );
                $oc->save
                    or return $self->error(
                    $self->translate_escape(
                        'Error saving record: [_1]',
                        $oc->errstr,
                    )
                    );

                $is_primary = 0;
            }
        }
    }
}

sub _v7_rebuild_object_tags {
    my $self = shift;

    $self->progress( $self->translate_escape('Rebuilding object tags...') );

    MT->model('objecttag')->remove( { object_datasource => 'content_field' } )
        or return $self->error(
        $self->translate_escape(
            'Error removing records: [_1]',
            MT->model('objecttag')->errstr,
        )
        );

    my @tag_fields = MT->model('content_field')->load( { type => 'tags' } );
    for my $tag_field (@tag_fields) {
        my @content_data = MT->model('content_data')
            ->load( { content_type_id => $tag_field->content_type_id } );
        for my $cd (@content_data) {
            my $tag_ids = $cd->data->{ $tag_field->id } || [];
            if ( ref $tag_ids ne 'ARRAY' ) {
                $tag_ids = [$tag_ids];
            }
            @$tag_ids = grep {$_} @$tag_ids;

            for my $tag_id (@$tag_ids) {
                my $ot = MT->model('objecttag')->new(
                    blog_id           => $cd->blog_id,
                    object_id         => $cd->id,
                    object_datasource => 'content_data',
                    tag_id            => $tag_id,
                    cf_id             => $tag_field->id,
                );
                $ot->save
                    or return $self->error(
                    $self->translate_escape(
                        'Error saving record: [_1]',
                        $ot->errstr,
                    )
                    );
            }
        }
    }
}

sub _v7_rebuild_object_assets {
    my $self = shift;

    $self->progress( $self->translate_escape('Rebuilding object assets...') );

    MT->model('objectasset')->remove( { object_ds => 'content_field' } )
        or return $self->error(
        $self->translate_escape(
            'Error removing records: [_1]',
            MT->model('objectasset')->errstr,
        )
        );

    my @asset_fields
        = MT->model('content_field')
        ->load(
        { type => [ 'asset', 'asset_audio', 'asset_video', 'asset_image' ] }
        );
    for my $asset_field (@asset_fields) {
        my @content_data = MT->model('content_data')
            ->load( { content_type_id => $asset_field->content_type_id } );
        for my $cd (@content_data) {
            my $asset_ids = $cd->data->{ $asset_field->id } || [];
            if ( ref $asset_ids ne 'ARRAY' ) {
                $asset_ids = [$asset_ids];
            }
            @$asset_ids = grep {$_} @$asset_ids;

            for my $asset_id (@$asset_ids) {
                my $oa = MT->model('objectasset')->new(
                    blog_id   => $cd->blog_id,
                    object_id => $cd->id,
                    object_ds => 'content_data',
                    asset_id  => $asset_id,
                    cf_id     => $asset_field->id,
                );
                $oa->save
                    or return $self->error(
                    $self->translate_escape(
                        'Error saving record: [_1]',
                        $oa->errstr,
                    )
                    );
            }
        }
    }
}

sub _v7_rebuild_content_field_permissions {
    my $self = shift;

    $self->progress(
        $self->translate_escape('Rebuilding content field permissions...') );

    # because when role saved callback, add permissions.
    my $perm_iter = MT->model('permission')
        ->load_iter( { permissions => { 'like' => '%content-field:%' } } );
    while ( my $perm = $perm_iter->() ) {
        my $permissions = $perm->permissions;
        my @permissions = split ',', $permissions;
        @permissions = map { $_ =~ s/content-field:/content_field:/g; $_; }
            @permissions;
        @permissions = map { $_ =~ s/'//g; $_; } @permissions;

        # clear_permissions is content-field can not remove.
        $perm->permissions('');
        $perm->set_these_permissions(@permissions);
        $perm->save
            or return $self->error(
            $self->translate_escape(
                'Error saving record: [_1]',
                $perm->errstr,
            )
            );
    }

    my $iter = MT->model('role')
        ->load_iter( { permissions => { 'like' => '%content-field:%' } } );
    while ( my $role = $iter->() ) {
        my $permissions = $role->permissions;
        my @permissions = split ',', $permissions;
        @permissions = map { $_ =~ s/content-field:/content_field:/g; $_; }
            @permissions;
        @permissions = map { $_ =~ s/'//g; $_; } @permissions;

        # clear_permissions is content-field: can not remove.
        $role->permissions('');
        $role->set_these_permissions(@permissions);
        $role->save
            or return $self->error(
            $self->translate_escape(
                'Error saving record: [_1]',
                $role->errstr,
            )
            );

    }

}

sub _v7_remove_create_child_sites {
    my $self = shift;

    # Create a new role for migrate create_blog system privilege.
    my $create_role_job = sub {
        $self->progress(
            $self->translate_escape(
                'Create a new role for creating a child site...')
        );

        my $role_class = MT->model('role');
        my $new_role   = $role_class->new();
        $new_role->name( MT->translate('Create Child Site') );
        $new_role->description( MT->translate('Create Child Site') );
        $new_role->clear_full_permissions;
        $new_role->set_these_permissions( ['create_site'] );
        $new_role->save or return $self->error( $new_role->errstr );
        return $new_role;
    };

    # Find create_blog record then migratet it
    $self->progress(
        $self->translate_escape('Migrating create child site permissions...')
    );

    my $iter = MT->model('permission')->load_iter(
        {   blog_id     => 0,
            permissions => { like => '%\'create_blog\'%' },
        }
    );
    my $new_role;
    while ( my $perm = $iter->() ) {
        $new_role = $create_role_job->()
            unless $new_role;

        my $permission = $perm->permissions;
        my @new;
        for my $p ( split ',', $permission ) {
            push @new, $p if $p ne "'create_blog'";
        }
        if (@new) {
            $permission = join ',', @new;
            $perm->permissions($permission);
            $perm->save();
        }
        else {
            $perm->remove;
        }

        my $user         = $perm->user;
        my $website_iter = MT->model('website')->load_iter(
            undef,
            {   join => MT->model('permission')->join_on(
                    'blog_id',
                    {   author_id   => $user->id,
                        permissions => { like => '%\'administer_site\'%' },
                    }
                ),
            }
        );
        while ( my $site = $website_iter->() ) {
            MT->model('association')->link( $user => $new_role => $site );
        }
    }
}

sub v7_migrate_rebuild_trigger {
    my $self = shift;

    $self->progress(
        $self->translate_escape('Migrating MultiBlog settings...') );

    require MT::PluginData;
    my @config = MT::PluginData->load( { plugin => 'MultiBlog' } );
    foreach my $cfg (@config) {
        if ( $cfg->key =~ m/^configuration$/ ) {

            # Config
            my $default_access_allowed
                = ( $cfg->data || {} )->{default_access_allowed};
            MT->config( 'DefaultAccessAllowed', $default_access_allowed, 1 )
                if defined $default_access_allowed;
        }
        elsif ( $cfg->key =~ m/^configuration:blog:(\d+)/ ) {
            my $blog_id = $1;

            # meta
            my $default_mtmulitblog_blogs
                = ( $cfg->data || {} )->{default_mtmulitblog_blogs};
            my $default_mtmultiblog_action
                = ( $cfg->data || {} )->{default_mtmultiblog_action};
            my $blog_content_accessible
                = ( $cfg->data || {} )->{blog_content_accessible};
            my $blog = MT->model('blog')->load($blog_id) or next;
            $blog->default_mt_sites_sites($default_mtmulitblog_blogs)
                if defined $default_mtmulitblog_blogs;
            $blog->default_mt_sites_action($default_mtmultiblog_action)
                if defined $default_mtmultiblog_action;
            $blog->blog_content_accessible($blog_content_accessible)
                if defined $blog_content_accessible;
            $blog->save;

            # Trigger
            require MT::RebuildTrigger;
            my $rebuild_triggers = ( $cfg->data || {} )->{rebuild_triggers};
            foreach ( split( /\|/, $rebuild_triggers ) ) {
                my ( $action, $id, $event ) = split( /:/, $_ );
                $action
                    = $action eq 'ri'
                    ? MT::RebuildTrigger::ACTION_RI()
                    : MT::RebuildTrigger::ACTION_RIP();
                my $object_type
                    = $event =~ /^entry_.*/
                    ? MT::RebuildTrigger::TYPE_ENTRY_OR_PAGE()
                    : $event =~ /^comment_.*/
                    ? MT::RebuildTrigger::TYPE_COMMENT()
                    : MT::RebuildTrigger::TYPE_PING();
                $event
                    = $event =~ /.*_save$/ ? MT::RebuildTrigger::EVENT_SAVE()
                    : $event =~ /.*_pub$/
                    ? MT::RebuildTrigger::EVENT_PUBLISH()
                    : MT::RebuildTrigger::EVENT_UNPUBLISH();
                my $target
                    = $id eq '_all' ? MT::RebuildTrigger::TARGET_ALL()
                    : $id eq '_blogs_in_website'
                    ? MT::RebuildTrigger::TARGET_BLOGS_IN_WEBSITE()
                    : MT::RebuildTrigger::TARGET_BLOG();
                my $target_blog_id = $id =~ /\d+/ ? $id : 0;
                my $rt = MT->model('rebuild_trigger')->new;
                $rt->blog_id($blog_id);
                $rt->object_type($object_type);
                $rt->action($action);
                $rt->event($event);
                $rt->target($target);
                $rt->target_blog_id($target_blog_id);
                $rt->ct_id(0);
                $rt->save or return $rt->error( $rt->errstr );
            }
        }
    }
}

sub _v7_migrate_content_type_fields_column {
    my $self = shift;
    $self->progress(
        $self->translate_escape(
            'Migrating fields column of MT::ContentType...')
    );
    my $iter = MT->model('content_type')->load_iter;
    while ( my $content_type = $iter->() ) {
        $content_type->fields( $content_type->fields );
        $content_type->save
            or return $self->error(
            $self->translate_escape(
                "Error saving record: [_1].",
                $content_type->errstr
            )
            );
    }
}

sub _v7_migrate_content_data_data_column {
    my $self = shift;
    $self->progress(
        $self->translate_escape(
            'Migrating data column of MT::ContentData...')
    );
    my $iter = MT->model('content_data')->load_iter;
    while ( my $content_data = $iter->() ) {
        $content_data->data( $content_data->data );
        $content_data->save
            or return $self->error(
            $self->translate_escape(
                "Error saving record: [_1].",
                $content_data->errstr
            )
            );
    }
}

sub _v7_rebuild_number_field_indexes {
    my $self = shift;

    require MT::Log;

    $self->progress(
        $self->translate_escape(
            'Rebuilding MT::ContentFieldIndex of number field...')
    );

    my $join = MT->model('content_field')->join_on(
        undef,
        {   content_type_id => \'= cf_idx_content_type_id',
            type            => 'number',
        },
    );
    my $iter
        = MT->model('content_field_index')
        ->load_iter( undef, { join => $join } );
    while ( my $content_field_index = $iter->() ) {
        my $content_field = $content_field_index->content_field or next;
        my $content_data  = $content_field_index->content_data  or next;

        my $number_field_value = $content_data->data->{ $content_field->id };
        if ( !defined $number_field_value || $number_field_value eq '' ) {
            $content_field_index->remove
                or return $self->error(
                $self->translate_escape(
                    'Error removing record (ID:[_1]): [_2].',
                    $content_field_index->id,
                    $content_field_index->errstr,
                )
                );
            next;
        }

        if ( $number_field_value =~ /^-?\d+(\.\d+)?$/ ) {
            $content_field_index->value_double($number_field_value);
        }
        else {
            $content_field_index->value_double(
                $content_field_index->value_float );
        }
        $content_field_index->value_float(undef);

        my $saved = $content_field_index->save;
        unless ($saved) {
            MT->log(
                {   message => $self->translate_escape(
                        'Error saving record (ID:[_1]): [_2].',
                        $content_field_index->id,
                        $content_field_index->errstr,
                    ),
                    level    => MT::Log::ERROR(),
                    category => 'upgrade',
                }
            );
        }
    }
}

sub _v7_rebuild_multi_line_text_field_indexes {
    my $self = shift;

    require MT::Log;

    $self->progress(
        $self->translate_escape(
            'Rebuilding MT::ContentFieldIndex of multi_line_text field...')
    );

    my $join_content_field = MT->model('content_field')->join_on(
        undef,
        {   content_type_id => \'= cf_idx_content_type_id',
            type            => 'multi_line_text',
        },
    );
    my $iter
        = MT->model('content_field_index')
        ->load_iter( undef, { join => $join_content_field } );
    while ( my $content_field_index = $iter->() ) {
        my $content_field = $content_field_index->content_field or next;
        my $content_data  = $content_field_index->content_data  or next;

        my $multi_line_text_field_value
            = $content_data->data->{ $content_field->id };
        unless ( defined $multi_line_text_field_value ) {
            $content_field_index->remove
                or return $self->error(
                $self->translate_escape(
                    'Error removing record (ID:[_1]): [_2].',
                    $content_field_index->id,
                    $content_field_index->errstr,
                )
                );
            next;
        }

        $content_field_index->value_text($multi_line_text_field_value);
        $content_field_index->value_blob(undef);

        my $saved = $content_field_index->save;
        unless ($saved) {
            MT->log(
                {   message => $self->translate_escape(
                        'Error saving record (ID:[_1]): [_2].',
                        $content_field_index->id,
                        $content_field_index->errstr,
                    ),
                    level    => MT::Log::ERROR(),
                    category => 'upgrade',
                }
            );
        }
    }
}

sub _v7_rebuild_tables_field_indexes {
    my $self = shift;

    require MT::Log;

    $self->progress(
        $self->translate_escape(
            'Rebuilding MT::ContentFieldIndex of tables field...')
    );

    my $join_content_field = MT->model('content_field')->join_on(
        undef,
        {   content_type_id => \'= cf_idx_content_type_id',
            type            => 'tables',
        },
    );
    my $iter
        = MT->model('content_field_index')
        ->load_iter( undef, { join => $join_content_field } );
    while ( my $content_field_index = $iter->() ) {
        my $content_field = $content_field_index->content_field or next;
        my $content_data  = $content_field_index->content_data  or next;

        my $tables_field_value = $content_data->data->{ $content_field->id };
        if ( !defined $tables_field_value || $tables_field_value eq '' ) {
            $content_field_index->remove
                or return $self->error(
                $self->translate_escape(
                    'Error removing record (ID:[_1]): [_2].',
                    $content_field_index->id,
                    $content_field_index->errstr,
                )
                );
            next;
        }

        $content_field_index->value_text($tables_field_value);
        $content_field_index->value_blob(undef);

        my $saved = $content_field_index->save;
        unless ($saved) {
            MT->log(
                {   message => $self->translate_escape(
                        'Error saving record (ID:[_1]): [_2].',
                        $content_field_index->id,
                        $content_field_index->errstr,
                    ),
                    level    => MT::Log::ERROR(),
                    category => 'upgrade',
                }
            );
        }
    }
}

sub _v7_rebuild_embedded_text_field_indexes {
    my $self = shift;

    require MT::Log;

    $self->progress(
        $self->translate_escape(
            'Rebuilding MT::ContentFieldIndex of embedded_text field...')
    );

    my $join_content_field = MT->model('content_field')->join_on(
        undef,
        {   content_type_id => \'= cf_idx_content_type_id',
            type            => 'embedded_text',
        },
    );
    my $iter
        = MT->model('content_field_index')
        ->load_iter( undef, { join => $join_content_field } );
    while ( my $content_field_index = $iter->() ) {
        my $content_field = $content_field_index->content_field or next;
        my $content_data  = $content_field_index->content_data  or next;

        my $embedded_text_field_value
            = $content_data->data->{ $content_field->id };
        if ( !defined $embedded_text_field_value
            || $embedded_text_field_value eq '' )
        {
            $content_field_index->remove
                or return $self->error(
                $self->translate_escape(
                    'Error removing record (ID:[_1]): [_2].',
                    $content_field_index->id,
                    $content_field_index->errstr,
                )
                );
            next;
        }

        $content_field_index->value_text($embedded_text_field_value);
        $content_field_index->value_blob(undef);

        my $saved = $content_field_index->save;
        unless ($saved) {
            MT->log(
                {   message => $self->translate_escape(
                        'Error saving record (ID:[_1]): [_2].',
                        $content_field_index->id,
                        $content_field_index->errstr,
                    ),
                    level    => MT::Log::ERROR(),
                    category => 'upgrade',
                }
            );
        }
    }
}

sub _v7_rebuild_url_field_indexes {
    my $self = shift;

    require MT::Log;

    $self->progress(
        $self->translate_escape(
            'Rebuilding MT::ContentFieldIndex of url field...')
    );

    my $join_content_field = MT->model('content_field')->join_on(
        undef,
        {   content_type_id => \'= cf_idx_content_type_id',
            type            => 'url',
        },
    );
    my $iter
        = MT->model('content_field_index')
        ->load_iter( undef, { join => $join_content_field } );
    while ( my $content_field_index = $iter->() ) {
        my $content_field = $content_field_index->content_field or next;
        my $content_data  = $content_field_index->content_data  or next;

        my $url_field_value = $content_data->data->{ $content_field->id };
        if ( !defined $url_field_value || $url_field_value eq '' ) {
            $content_field_index->remove
                or return $self->error(
                $self->translate_escape(
                    'Error removing record (ID:[_1]): [_2].',
                    $content_field_index->id,
                    $content_field_index->errstr,
                )
                );
            next;
        }

        $content_field_index->value_text($url_field_value);
        $content_field_index->value_blob(undef);

        my $saved = $content_field_index->save;
        unless ($saved) {
            MT->log(
                {   message => $self->translate_escape(
                        'Error saving record (ID:[_1]): [_2].',
                        $content_field_index->id,
                        $content_field_index->errstr,
                    ),
                    level    => MT::Log::ERROR(),
                    category => 'upgrade',
                }
            );
        }
    }
}

sub _v7_rebuild_single_line_text_field_indexes {
    my $self = shift;

    require MT::Log;

    $self->progress(
        $self->translate_escape(
            'Rebuilding MT::ContentFieldIndex of single_line_text field...')
    );

    my $join_content_field = MT->model('content_field')->join_on(
        undef,
        {   content_type_id => \'= cf_idx_content_type_id',
            type            => 'single_line_text',
        },
    );
    my $iter
        = MT->model('content_field_index')
        ->load_iter( undef, { join => $join_content_field } );
    while ( my $content_field_index = $iter->() ) {
        my $content_field = $content_field_index->content_field or next;
        my $content_data  = $content_field_index->content_data  or next;

        my $content_field_value = $content_data->data->{ $content_field->id };
        if ( !defined $content_field_value || $content_field_value eq '' ) {
            $content_field_index->remove
                or return $self->error(
                $self->translate_escape(
                    'Error removing record (ID:[_1]): [_2].',
                    $content_field_index->id,
                    $content_field_index->errstr,
                )
                );
            next;
        }

        $content_field_index->value_varchar($content_field_value);

        my $saved = $content_field_index->save;
        unless ($saved) {
            MT->log(
                {   message => $self->translate_escape(
                        'Error saving record (ID:[_1]): [_2].',
                        $content_field_index->id,
                        $content_field_index->errstr,
                    ),
                    level    => MT::Log::ERROR(),
                    category => 'upgrade',
                }
            );
        }
    }
}

sub _v7_rebuild_permissions {
    my $self = shift;

    # Rebuild if having 'manage_category_set'
    $self->progress(
        $self->translate_escape(
            'Rebuilding MT::Permission records (remove edit_categories)...')
    );

    my $permission_class = MT->model('permission');

    my $perm_iter = $permission_class->load_iter(
        { permissions => { like => "%'manage_category_set'%" } } );
    while ( my $perm = $perm_iter->() ) {
        $perm->rebuild;
    }
}

sub _v7_cleanup_content_field_indexes {
    my $self = shift;

    $self->progress(
        $self->translate_escape('Cleaning up content field indexes...') );

    my $iter = MT->model('content_field_index')->load_iter;
    while ( my $cf_idx = $iter->() ) {
        next
            if MT->model('content_type')->exist( $cf_idx->content_type_id )
            && MT->model('content_field')->exist( $cf_idx->content_field_id )
            && MT->model('content_data')->exist( $cf_idx->content_data_id );
        $cf_idx->remove;
    }
}

sub _v7_cleanup_object_assets_for_content_data {
    my $self = shift;

    $self->progress(
        $self->translate_escape(
            'Cleaning up objectasset records for content data...')
    );

    my $iter = MT->model('objectasset')
        ->load_iter( { object_ds => 'content_data' } );
    while ( my $oa = $iter->() ) {
        next
            if MT->model('asset')->exist( $oa->asset_id )
            && MT->model('content_field')->exist( $oa->cf_id )
            && MT->model('content_data')->exist( $oa->object_id );
        $oa->remove;
    }
}

sub _v7_cleanup_object_categories_for_content_data {
    my $self = shift;

    $self->progress(
        $self->translate_escape(
            'Cleaning up objectcategory records for content data...')
    );

    my $iter = MT->model('objectcategory')
        ->load_iter( { object_ds => 'content_data' } );
    while ( my $oc = $iter->() ) {
        next
            if MT->model('category')->exist( $oc->category_id )
            && MT->model('content_field')->exist( $oc->cf_id )
            && MT->model('content_data')->exist( $oc->object_id );
        $oc->remove;
    }
}

sub _v7_cleanup_object_tags_for_content_data {
    my $self = shift;

    $self->progress(
        $self->translate_escape(
            'Cleaning up objecttag records for content data...')
    );

    my $iter = MT->model('objecttag')
        ->load_iter( { object_datasource => 'content_data' } );
    while ( my $ot = $iter->() ) {
        next
            if MT->model('tag')->exist( $ot->tag_id )
            && MT->model('content_field')->exist( $ot->cf_id )
            && MT->model('content_data')->exist( $ot->object_id );
        $ot->remove;
    }
}

1;
