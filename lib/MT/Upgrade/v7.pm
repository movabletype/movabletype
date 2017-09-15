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
                type      => 'permission',
                label     => 'Rebuilding permissions...',
                code      => sub { $_[0]->rebuild; },
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
    my $self = shift;

    my $role_class = MT->model('role');
    $self->progress(
        $self->translate_escape('Updating existing role name...') );

    $self->progress(
        $self->translate_escape(
            'Populating new role for Site Administrator...')
    );
    my $new_role = $role_class->new();
    $new_role->name( MT->translate('Site Administrator') );
    $new_role->description( MT->translate('Can administer the site.') );
    $new_role->clear_full_permissions;
    $new_role->set_these_permissions( ['administer_site'] );
    $new_role->save
        or return $self->error(
        $self->translate_escape(
            "Error saving record: [_1].",
            $new_role->errstr
        )
        );

    $self->progress(
        $self->translate_escape(
            'Populating new role for Child Site Administrator...')
    );
    $new_role = $role_class->new();
    $new_role->name( MT->translate('Child Site Administrator') );
    $new_role->description( MT->translate('Can administer the child site.') );
    $new_role->clear_full_permissions;
    $new_role->set_these_permissions( ['administer_site'] );
    $new_role->role_mask( 2**12 );
    $new_role->save
        or return $self->error(
        $self->translate_escape(
            "Error saving record: [_1].",
            $new_role->errstr
        )
        );

    $self->progress(
        $self->translate_escape(
            'Populating new role for Content Designer...')
    );
    $new_role = $role_class->new();
    $new_role->name( MT->translate('Content Designer') );
    $new_role->description(
        MT->translate(
            'Can manage content types, content datas, edit their own content types, contentdatas.'
        )
    );
    $new_role->clear_full_permissions;
    $new_role->set_these_permissions(
        [ 'manage_content_types', 'manage_content_datas' ] );
    $new_role->save
        or return $self->error(
        $self->translate_escape(
            "Error saving record: [_1].",
            $new_role->errstr
        )
        );
}

sub _v7_migrate_role {
    my $self = shift;

    my $role_class = MT->model('role');

    $self->progress(
        $self->translate_escape('Updating existing role name...') );

    my @role_names = (
        'Website Administrator', 'Designer',
        'Author',                'Contributor',
        'Editor'
    );
    foreach my $role_name (@role_names) {
        $self->progress( 'change '
                . MT->translate($role_name) . ' to '
                . MT->translate( $role_name . ' (MT6)' ) );

        my $iter
            = $role_class->load_iter( { name => MT->translate($role_name) } );

        while ( my $role = $iter->() ) {
            $role->name( MT->translate( $role_name . ' (MT6)' ) );
            $role->save
                or return $self->error(
                $self->translate_escape(
                    "Error saving record: [_1].",
                    $role->errstr
                )
                );
        }
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

        }
    }
}

1;
