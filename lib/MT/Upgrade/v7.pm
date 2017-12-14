# Movable Type (r) (C) 2001-2017 Six Apart, Ltd. All Rights Reserved.
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
        'v7_rebuild_permissions' => {
            version_limit => 7.0012,
            priority      => 3.4,
            updater       => {
                type  => 'permission',
                label => 'Rebuilding permissions...',
                code  => sub { $_[0]->rebuild; },
            },
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
            'add administer_site permission for Blog Administrator...'
        )
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
    my $self             = shift;
    my $permission_class = MT->model('permission');

    $self->progress(
        $self->translate_escape(
            'Migrating system level permissions to new structure...')
    );

    my $perm_iter
        = $permission_class->load_iter(
        { permissions => { not => '\'comment\'' } },
        { group       => 'author_id' } );
    while ( my $perm = $perm_iter->() ) {
        my $author = $perm->user;
        $author->is_superuser(1) if $author->is_superuser();
        $author->can_sign_in_cms(1);
        $author->can_sign_in_data_api(1);
        $author->can_create_site(1)
            if ( $perm->permissions =~ /create_website/ );
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
    my @unique_archive_type = keys %hash;
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

    $self->progress(
        $self->translate_escape('Removing create child site permissions...')
    );

    my $iter = MT->model('permission')->load_iter( { blog_id => 0 } );
    while ( my $perm = $iter->() ) {
        if ( $perm->can_create_blog ) {
            $perm->can_create_blog(0);
            $perm->save();
        }
    }

}

1;
