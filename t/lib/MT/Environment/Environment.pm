package MT::Test::Environment;

use strict;
use warnings;
use Carp;

use MT;

#my $data = {
#    blogs => { blog_key => { values => { name => 'Blog Name' } } },
#    roles => {
#        role_key => {
#            values => {
#                name        => 'Role Name',
#                description => 'Role Description'
#            },
#            permissions => ( 'list', 'of', 'permissions' ),
#        },
#    },
#    groups => { group_key => { values => { name => 'Group Name' } } },
#    users  => {
#        user_key => {
#            values => { name     => 'User Name' },
#            roles  => { blog_key => [ 'role_key', 'role_key' ] }
#        }
#    },
#    entries =>
#        { entry_key => { title => 'Entry Title', text => 'Entry Text!!' } },
#};

sub setup {

    my ($data_ref) = @_;
    my $env_data_ref = {};

    # Blogs first since they don't depend on users/group3s/roles
    if ( $data_ref->{blogs} ) {
        $env_data_ref->{blogs}
            = create_blogs( $data_ref->{blogs}, $env_data_ref );
    }

    # Roles next
    if ( $data_ref->{roles} ) {
        $env_data_ref->{roles}
            = create_roles( $data_ref->{roles}, $env_data_ref );
    }

    # Groups next so that they can be linked to blogs and roles now if need be
    if ( MT->model('group') && $data_ref->{groups} ) {
        $env_data_ref->{groups}
            = create_groups( $data_ref->{groups}, $env_data_ref );

    }

    # Users next so that they can be linked (associated) with blogs, roles,
    # or groups.
    if ( $data_ref->{users} ) {
        $env_data_ref->{users}
            = create_users( $data_ref->{users}, $env_data_ref );
    }

    # Entries
    # The Aptly Named Sir Not Appearing In This Module
    if ( $data_ref->{entries} ) {
        $env_data_ref->{entries}
            = create_entries( $data_ref->{entries}, $env_data_ref );
    }

    return $env_data_ref;
}

sub create_role {
    my ( $role_data_ref, $env_data_ref ) = @_;
    croak('No values for role') if ( !$role_data_ref->{values} );
    my $v = $role_data_ref->{values};
    my $role = MT->model('role')->get_by_key( { name => $v->{name} } );
    $role->set_values($v);

    $role->clear_full_permissions;
    $role->set_these_permissions( $role_data_ref->{permissions} );
    if ( $v->{name} =~ m/^System/ ) {
        $role->is_system(1);
    }
    $role->role_mask( $role_data_ref->{role_mask} )
        if exists $role_data_ref->{role_mask};
    $role->save or croak $role->errstr;
    return $role;
}

sub create_roles {
    my ( $roles_data_ref, $env_data_ref ) = @_;
    my $roles_ref = {};
    foreach my $r_key ( keys %{$roles_data_ref} ) {
        $roles_ref->{$r_key} = create_role( $roles_data_ref->{$r_key} );
    }
    return $roles_ref;
}

sub create_user {
    my ( $user_data_ref, $env_data_ref ) = @_;
    croak('No values for user') if ( !$user_data_ref->{values} );
    my $v = $user_data_ref->{values};
    my $user = MT->model('author')->get_by_key( { name => $v->{name} } );
    my $pwd = delete $v->{password} || "password";
    
    $user->set_values($v);
    $user->set_password($pwd);
    
    $user->save or croak $user->errstr;
    if ( $user_data_ref->{roles} ) {
        foreach my $blog_key ( keys %{ $user_data_ref->{roles} } ) {
            my $blog = $env_data_ref->{blogs}->{$blog_key};
            croak(    "Cannot setup user roles for user "
                    . $user->name
                    . ": cannot get blog "
                    . $blog_key )
                unless $blog;
            foreach my $role_key ( @{ $user_data_ref->{roles}->{$blog_key} } )
            {
                my $role = $env_data_ref->{roles}->{$role_key};
                if ( !$role ) {
                    $role = MT->model('role')->load( { name => $role_key } );
                }
                croak(    "Cannot setup user roles for user "
                        . $user->name
                        . ": cannot get role "
                        . $role_key )
                    unless $role;
                if ( $user && $blog && $role ) {
                    require MT::Association;
                    my $assoc
                        = MT::Association->link( $user => $blog => $role );
                }
                else {

                }
            }
        }
    }
    return $user;
}

sub create_users {
    my ( $users_data_ref, $env_data_ref ) = @_;
    my $users_ref = {};
    foreach my $user_key ( keys %{$users_data_ref} ) {
        $users_ref->{$user_key}
            = create_user( $users_data_ref->{$user_key}, $env_data_ref );
    }
    return $users_ref;
}

sub create_blog {
    my ( $blog_data_ref, $env_data_ref ) = @_;
    croak('No values for blog') if ( !$blog_data_ref->{values} );
    my $v = $blog_data_ref->{values};
    my $blog = MT->model('blog')->get_by_key( { name => $v->{name} } );
    $blog->set_values($v);
    $blog->save or croak( $blog->errstr );
    return $blog;
}

sub create_blogs {
    my ( $blogs_data_ref, $env_data_ref ) = @_;
    my $blogs_ref = {};
    foreach my $blog_key ( keys %{$blogs_data_ref} ) {
        $blogs_ref->{$blog_key}
            = create_blog( $blogs_data_ref->{$blog_key}, $env_data_ref );
    }
    return $blogs_ref;
}

sub create_group {
    my ( $group_data_ref, $env_data_ref ) = @_;
    croak('No values for group') if ( !$group_data_ref->{values} );
    my $v = $group_data_ref->{values};
    require MT::Group;
    my $group = MT->model('group')->get_by_key( { name => $v->{name} } );

    $group->set_values($v);
    $group->status( MT::Group::ACTIVE() );
    $group->save or croak( $group->errstr );
    return $group;
}

sub create_groups {
    my ( $groups_data_ref, $env_data_ref ) = @_;
    my $groups_ref = {};

    for my $group_key ( keys %{$groups_data_ref} ) {
        $groups_ref->{$group_key}
            = create_group( $groups_data_ref->{$group_key}, $env_data_ref );
    }
    return $groups_ref;
}

sub create_entry {
    my ( $entry_data_ref, $env_data_ref ) = @_;
    croak('No values for entry') if ( !$entry_data_ref->{values} );
    my $v = $entry_data_ref->{values};

    my $author_key = delete $v->{author}
        or croak('No author key for entry!');
    my $author = $env_data_ref->{users}->{$author_key}
        or croak("Could not get author $author_key for entry!");
    $v->{author_id} = $author->id;

    my $blog_key = delete $v->{blog} or croak('No blog key for entry!');
    my $blog = $env_data_ref->{blogs}->{$blog_key} or croak ("Could not get blog $blog_key for entry!");
    $v->{blog_id} = $blog->id;

    require MT::Entry;
    my $entry = MT->model('entry')->get_by_key( { title => $v->{title} } );
    $entry->set_values($v);
    $entry->status( MT::Entry::RELEASE() );
    $entry->save() or croak( $entry->errstr );
    return $entry;
}

sub create_entries {
    my ( $entries_data_ref, $env_data_ref ) = @_;
    my $entries_ref = {};
    for my $entry_key ( keys %{$entries_data_ref} ) {
        $entries_ref->{$entry_key}
            = create_entry( $entries_data_ref->{$entry_key}, $env_data_ref );
    }
    return $entries_ref;
}

1;
