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
        'v7_migrate_system_privileges' => {
            code          => \&_migrate_system_privileges,
            version_limit => 7.0012,
            priority      => 3.5,
        },
        'v7_migrate_child_site_role' => {
            code          => \&_v7_migrate_child_site_role,
            version_limit => 7.0017,
            priority      => 3.5,
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

sub _v7_migrate_child_site_role {
    my $self        = shift;
    my $role_class  = MT->model('role');
    my $assoc_class = MT->model('association');

    $self->progress(
        $self->translate_escape(
            'Changing the Child Site Administrator role to the Site Administrator role.')
    );

    my $site_admin_role = $role_class->load(
        { name => MT->translate('Site Administrator') } );
    my $child_site_admin_role = $role_class->load(
        { name => MT->translate('Child Site Administrator') } );

    if($child_site_admin_role){
        my $iter
            = $assoc_class->load_iter( { role_id => $child_site_admin_role->id } );
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

1;
