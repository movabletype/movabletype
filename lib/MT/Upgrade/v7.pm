# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::Upgrade::v7;
use strict;
use warnings;

MT->add_callback( 'MT::Upgrade::upgrade_begin', 5, undef,
    \&_v7_truncate_value_varchar );

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
        'v7_migrate_max_length_option_of_single_line_text' => {
            code => \&_v7_migrate_max_length_option_of_single_line_text,
            version_limit => 7.0042,
            priority      => 3,
        },
        'v7_rebuild_ct_count_of_category_sets' => {
            version_limit => 7.0044,
            priority      => 3.3,
            condition     => sub {
                my ( $self, %param ) = @_;
                $param{from} && $param{from} >= 7;
            },
            updater => {
                type  => 'category_set',
                label => "Rebuilding Content Type count of Category Sets...",
                code => sub { },    # It's OK only to save category_set.
            },
        },
        'v7_add_mobile_site_list_dashboard_widget' => {
            version_limit => '7.0045',
            priority      => 5.1,
            updater       => {
                type  => 'author',
                label => 'Adding site list dashboard widget for mobile...',
                code  => \&_v7_add_mobile_site_list_dashboard_widget,
            },
        },
        'v7_remove_sql_set_names' => {
            version_limit => '7.0046',
            priority      => 3.1,
            code          => \&_v7_remove_sql_set_names,
        },
        'v7_reorder_warning_level' => {
            version_limit => '7.0050',
            priority      => 3.1,
            condition     => \&_v7_reorder_log_level_condition,
            updater       => {
                type  => 'log',
                label => 'Reorder WARNING level',
                sql   => 'UPDATE mt_log SET log_level = 3 WHERE log_level = 2',
            },
        },
        'v7_reorder_security_level' => {
            version_limit => '7.0050',
            priority      => 3.1,
            condition     => \&_v7_reorder_log_level_condition,
            updater       => {
                type   => 'log',
                label => 'Reorder SECURITY level',
                sql   => 'UPDATE mt_log SET log_level = 5 WHERE log_level = 8',
            },
        },
        'v7_reorder_debug_level' => {
            version_limit => '7.0050',
            priority      => 3.1,
            condition     => \&_v7_reorder_log_level_condition,
            updater       => {
                type   => 'log',
                label => 'Reorder DEBUG level',
                sql   => 'UPDATE mt_log SET log_level = 0 WHERE log_level = 16',
            },
        },
        'v7_migrate_filters_for_log_level' => {
            version_limit => '7.0050',
            priority      => 3.1,
            condition     => \&_v7_reorder_log_level_condition,
            updater       => {
                type  => 'filter',
                label => 'Migrating filters that have conditions on the log level...',
                terms => { object_ds => 'log' },
                code  => do {
                    my %map = (
                        2  => 3,
                        8  => 5,
                        16 => 0,
                    );
                    sub {
                        my $self  = shift;
                        my $items = $self->items
                            or return;
                        for my $item (@$items) {
                            if ($item->{type} eq 'level') {
                                if (defined(my $new_value = $map{ $item->{args}{value} })) {
                                    $item->{args}{value} = $new_value;
                                    $self->items($items);
                                }
                            }
                        }
                    };
                },
            },
        },
        'v7_remove_image_metadata' => {
            version_limit => '7.0051',
            priority      => 3.1,
            updater       => {
                type   => 'asset:meta',
                label => 'Remove image metadata',
                sql   => q{DELETE FROM mt_asset_meta WHERE asset_meta_type = 'image_metadata'},
            },
        },
        'v7_migrate_data_api_disable_site' => {
            version_limit => '7.0053',
            priority      => 3.2,
            code          => \&_v7_migrate_data_api_disable_site,
        },
        'v7_fill_with_missing_system_templates' => {
            version_limit => '7.0054',
            priority      => 3.2,
            code          => \&_v7_fill_with_missing_system_templates,
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
            my $blog = $assoc->blog;
            if ( my $author = $assoc->user ) {
                $author->add_role( $site_admin_role, $blog );
            }
            elsif ( my $group = $assoc->group ) {
                $group->add_role( $site_admin_role, $blog );
            }

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
            my $blog = $assoc->blog;
            if ( my $author = $assoc->user ) {
                $author->add_role( $site_admin_role, $blog );
            }
            elsif ( my $group = $assoc->group ) {
                $group->add_role( $site_admin_role, $blog );
            }
            if ( $blog && !$blog->is_blog ) {
                my @child_blogs = @{ $blog->blogs };
                foreach my $child_blog (@child_blogs) {
                    if ( my $author = $assoc->user ) {
                        $author->add_role( $site_admin_role, $child_blog );
                    }
                    elsif ( my $group = $assoc->group ) {
                        $group->add_role( $site_admin_role, $child_blog );
                    }
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
            my $blog = $assoc->blog;
            if ( my $author = $assoc->user ) {
                $author->add_role( $site_admin_role, $blog );
            }
            elsif ( my $group = $assoc->group ) {
                $group->add_role( $site_admin_role, $blog );
            }

        }

    }

}

sub _migrate_system_privileges {
    my $self = shift;

    $self->progress(
        $self->translate_escape(
            'Migrating system level permissions to new structure...')
    );

    my $iter = MT->model('author')->load_iter({ type => MT::Author::AUTHOR() });
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

    my @maps = MT->model('templatemap')->load(
        undef,
        {   join => MT->model('blog')
                ->join_on( undef, { id => \'= templatemap_blog_id' } ),
        },
    );
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
    my %hash = map { $_, 1 } map { my $tmp = $_; $tmp =~ s/_/-/; $tmp; } @archive_type;
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
            my $blog = $assoc->blog;
            if ( my $author = $assoc->user ) {
                $author->add_role( $site_admin_role, $blog );
            }
            elsif ( my $group = $assoc->group ) {
                $group->add_role( $site_admin_role, $blog );
            }

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
        @permissions = map { my $tmp = $_; $tmp =~ s/content-field:/content_field:/g; $tmp; } @permissions;
        @permissions = map { my $tmp = $_; $tmp =~ s/'//g;                            $tmp; } @permissions;

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
        @permissions = map { my $tmp = $_; $tmp =~ s/content-field:/content_field:/g; $tmp; } @permissions;
        @permissions = map { my $tmp = $_; $tmp =~ s/'//g;                            $tmp; } @permissions;

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

    $self->progress($self->translate_escape('Migrating MultiBlog settings...'));

    my $plugin = MT::Plugin->new({ id => 'multiblog', name => 'MultiBlog' });

    my $valid_config = sub {
        my $blog_id = shift;
        my $cfg     = $plugin->get_config_obj($blog_id ? 'blog:' . $blog_id : undef);
        return unless $cfg->id;
        my $data = $cfg->data;
        return $data if (ref $data eq 'HASH');

        MT->log({
              message => $blog_id
            ? MT->translate('MultiBlog migration for site(ID:[_1]) is skipped due to the data breakage.', $blog_id)
            : MT->translate('MultiBlog migration is skipped due to the data breakage.'),
            category => 'upgrade',
            level    => MT::Log::WARNING(),
            blog_id  => $blog_id ? $blog_id : undef,
        });

        return;
    };

    if (my $data = $valid_config->()) {
        MT->config('DefaultAccessAllowed', $data->{default_access_allowed}, 1) if defined $data->{default_access_allowed};
    }

    my $iter = MT::Blog->load_iter({ class => '*' });

    while (my $blog = $iter->()) {
        my $data = $valid_config->($blog->id) or next;

        # meta
        $blog->default_mt_sites_sites($data->{default_mtmulitblog_blogs})   if defined $data->{default_mtmulitblog_blogs};
        $blog->default_mt_sites_action($data->{default_mtmultiblog_action}) if defined $data->{default_mtmultiblog_action};
        $blog->blog_content_accessible($data->{blog_content_accessible})    if defined $data->{blog_content_accessible};
        $blog->save;

        next unless $data->{rebuild_triggers};

        my $skip_occur = 0;

        for my $single (split(/\|/, $data->{rebuild_triggers})) {
            next unless $single;
            if (my $rt = _v7_migrate_rebuild_trigger_unserialize($single)) {
                $rt->blog_id($blog->id);
                $rt->save or return $rt->error($rt->errstr);
            } else {
                $skip_occur = 1;
            }
        }

        if ($skip_occur) {
            MT->log({
                message  => MT->translate('Some MultiBlog migrations for site(ID:[_1]) are skipped due to the data breakage.', $blog->id),
                category => 'upgrade',
                level    => MT::Log::WARNING(),
                blog_id  => $blog->id,
            });
        }
    }
}

sub _v7_migrate_rebuild_trigger_unserialize {
    my ($string) = @_;
    my ($action, $id, $event) = split(/:/, $string);
    my @event_elems = split(/_/, $event);

    require MT::RebuildTrigger;
    
    $action =
          $action eq 'ri'  ? MT::RebuildTrigger::ACTION_RI()
        : $action eq 'rip' ? MT::RebuildTrigger::ACTION_RIP()
        :                    return;
    my $object_type =
          $event_elems[0] eq 'entry'   ? MT::RebuildTrigger::TYPE_ENTRY_OR_PAGE()
        : $event_elems[0] eq 'comment' ? MT::RebuildTrigger::TYPE_COMMENT()
        : $event_elems[0] eq 'tb'      ? MT::RebuildTrigger::TYPE_PING()
        :                                return;
    $event =
          $event_elems[1] eq 'save'  ? MT::RebuildTrigger::EVENT_SAVE()
        : $event_elems[1] eq 'pub'   ? MT::RebuildTrigger::EVENT_PUBLISH()
        : $event_elems[1] eq 'unpub' ? MT::RebuildTrigger::EVENT_UNPUBLISH()
        :                              return;
    my $target =
          $id eq '_all'              ? MT::RebuildTrigger::TARGET_ALL()
        : $id eq '_blogs_in_website' ? MT::RebuildTrigger::TARGET_BLOGS_IN_WEBSITE()
        : $id =~ /^[0-9]+$/          ? MT::RebuildTrigger::TARGET_BLOG()
        :                              return;

    my $rt = MT->model('rebuild_trigger')->new;
    $rt->object_type($object_type);
    $rt->action($action);
    $rt->event($event);
    $rt->target($target);
    $rt->target_blog_id($target == MT::RebuildTrigger::TARGET_BLOG() ? $id : 0);
    $rt->ct_id(0);
    return $rt;
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

sub _v7_truncate_value_varchar {
    my ( $cb, $self, %param ) = @_;

    my $from          = $param{from};
    my $version_limit = '7.0041';
    return 1 unless defined $from && $from < $version_limit;

    $self->progress(
        $self->translate_escape(
            'Truncating values of value_varchar column...')
    );

    eval {
        my $iter = MT->model('content_field_index')->load_iter;
        while ( my $cf_idx = $iter->() ) {
            next
                unless defined $cf_idx->value_varchar
                && length( $cf_idx->value_varchar ) > 255;
            my $truncated = substr $cf_idx->value_varchar, 0, 255;
            $cf_idx->value_varchar($truncated);
            $cf_idx->save;
        }
    };

    1;
}

sub _v7_migrate_max_length_option_of_single_line_text {
    my $self = shift;

    $self->progress(
        $self->translate_escape(
            'Migrating Max Length option of Single Line Text fields...')
    );

    my $iter = MT->model('content_type')->load_iter(
        undef,
        {   join => MT->model('content_field')
                ->join_on( 'content_type_id', { type => 'single_line_text' },
                ),
        }
    );
    while ( my $ct = $iter->() ) {
        my $changed;
        my $fields = $ct->fields;
        for my $f (@$fields) {
            next if ( $f->{type} || '' ) ne 'single_line_text';
            $f->{options} ||= {};
            my $max_length = $f->{options}{max_length};
            next if defined $max_length && $max_length <= 255;
            $f->{options}{max_length} = 255;
            $changed = 1;
        }
        next unless $changed;
        $ct->fields($fields);
        $ct->save;
    }
}

sub _v7_add_mobile_site_list_dashboard_widget {
    my $user    = shift;
    my $widgets = $user->widgets;
    return 1 unless $widgets;
    for my $key ( keys %$widgets ) {
        next unless $key =~ /^dashboard:(?:user|blog):/;
        $widgets->{$key}{site_list_for_mobile} = {
            order => 50,
            set   => 'main',
        };
    }
    $user->widgets($widgets);
    $user->save;
}

sub _v7_remove_sql_set_names {
    my $self      = shift;
    my $cfg_class = MT->model('config');
    my $data = $cfg_class->load(1)->data;
    return 1 if $data =~ /SQLSetNames\s1/;

    $self->progress( $self->translate_escape('Remove SQLSetNames...') );

    my $cfg       = MT->config;
    $cfg->SQLSetNames( undef, 1 );
    $cfg->save_config;
}

sub _v7_reorder_log_level_condition {
    my ( $self, %param ) = @_;
    my $from = $param{from};

    return unless $from;
    return if $from >= 6.0026 && $from < 7;

    1;
}

sub _v7_migrate_data_api_disable_site {
    my $self = shift;

    $self->progress($self->translate_escape('Migrating DataAPIDisableSite...'));

    # Load from DB directly. Do not refer to mt-config.cgi.
    my ($config) = MT->model('config')->search;
    if ($config) {
        my $data = $config->data;
        my $data_api_disable_site;
        if ($data =~ /DataAPIDisableSite\s(.*)/) {
            $data_api_disable_site = $1;
        }
        my %data_api_disable_site = map { $_ => 1 } split /,/, $data_api_disable_site || '';

        my @sites = MT->model('website')->load({
                class => '*',
            },
            {
                fetchonly => { id => 1 },
            },
        );
        my $from = int( MT->config->SchemaVersion || 0 );
        for my $site (@sites) {
            if ($from < 6) {
                $site->allow_data_api(0);
            } else {
                if ($data_api_disable_site{$site->id}) {
                    $site->allow_data_api(0);
                } else {
                    $site->allow_data_api(1);
                }
            }
            $site->save;
        }

        # Clean up
        if ($from < 6) {
            MT->config->DataAPIDisableSite('0', 1);
        } else {
            if ($data_api_disable_site{0}) {
                MT->config->DataAPIDisableSite('0', 1);
            } else {
                MT->config->DataAPIDisableSite('', 1);
            }
        }
        MT->config->save_config;
    }
}

sub _v7_fill_with_missing_system_templates {
    my $self = shift;

    $self->progress($self->translate_escape('Filling missing system templates...'));

    my %tmpls;
    require MT::DefaultTemplates;
    MT::DefaultTemplates->fill_with_missing_system_templates(\%tmpls);

    my @blog_ids = map { $_->id } MT->model('site')->load({ class => '*' }, { fetchonly => ['id'] });

    my @templates = MT->model('template')->load({ type => [keys %tmpls] }, { fetchonly => ['blog_id', 'type'] });
    my %map       = map { $_->blog_id . ':' . $_->type . ':' . $_->type => 1 } @templates;

    require MT::Template;
    for my $blog_id (@blog_ids) {
        for my $key (keys %tmpls) {    # $key = $type:$type (= $tmpl_id:$tmpl_id)
            next if $map{"$blog_id:$key"};
            my $tmpl = $tmpls{$key};
            my $p    = $tmpl->{plugin} || 'MT';
            $tmpl->{text} = $p->translate_templatized($tmpl->{text}) if defined $tmpl->{text};
            my $obj = MT::Template->new(
                blog_id       => $blog_id,
                build_dynamic => 0,
            );
            for my $col (keys %$tmpl) {
                $obj->column($col, $tmpl->{$col}) if $obj->has_column($col);
            }
            $obj->save;
        }
    }
}

1;
