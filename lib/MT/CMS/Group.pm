# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::CMS::Group;

use strict;
use warnings;
use MT::Util qw( encode_html make_string_csv encode_url );

# This package simply holds code that is being grafted onto the CMS
# application; the namespace of the package is different, but the 'app'
# variable is going to be a MT::App::CMS object.

sub CMSSaveFilter_group {
    my ( $eh, $app ) = @_;

    require MT::Group;
    my $status = $app->param('status') || 0;
    return 1 if $status == MT::Group::INACTIVE();

    my $name = $app->param('name');
    if ( defined $name ) {
        $name =~ s/(^\s+|\s+$)//g;
        $app->param( 'name', $name );
    }
    return $app->error( $app->translate("Each group must have a name.") )
        if ( !$name );
    1;
}

sub CMSViewPermissionFilter_group {
    my ( $eh, $app, $id ) = @_;
    return $id && ( $app->user->can_manage_users_groups() );
}

sub CMSPreLoadFilteredList_group {
    my ( $cb, $app, $filter, $opts, $cols ) = @_;
    if ( !$app->can_do('access_to_any_group_list') ) {
        $filter->append_item(
            {   type => 'author_id',
                args => {
                    option => 'eq',
                    value  => $app->user->id,
                },
            }
        );
    }
}

# TBD: group management capability
sub CMSSavePermissionFilter_group {
    my ( $eh, $app, $id ) = @_;
    return $app->user->can_manage_users_groups();
}

# TBD: group management capability
sub CMSDeletePermissionFilter_group {
    my ( $eh, $app, $obj ) = @_;
    return $app->user->can_manage_users_groups();
}

sub dialog_select_group_user {
    my $app = shift;
    return $app->permission_denied()
        unless $app->user->can_manage_users_groups();

    my $type = $app->param('_type');

    my $hasher = sub {
        my ( $obj, $row ) = @_;
        if ( UNIVERSAL::isa( $obj, 'MT::Author' ) ) {
            $row->{label}       = $row->{name};
            $row->{description} = $row->{nickname};
        }
        elsif ( UNIVERSAL::isa( $obj, 'MT::Group' ) ) {
            $row->{label}       = $row->{name};
            $row->{description} = $row->{description};
        }
    };

    if ( $app->param('search') || $app->param('json') ) {
        my $params = {
            panel_type   => $type,
            list_noncron => 1,
            panel_multi  => 1,
        };

        my $terms = {};
        if ( $type && ( $type eq 'author' ) ) {
            require MT::Author;
            $terms->{status} = MT::Author::ACTIVE();
            $terms->{type}   = MT::Author::AUTHOR();
        }
        else {
            require MT::Group;
            $terms->{status} = MT::Group::ACTIVE();
        }

        $app->listing(
            {   terms    => $terms,
                args     => { sort => 'name' },
                type     => $type,
                code     => $hasher,
                params   => $params,
                template => 'include/listing_panel.tmpl',
                $app->param('search') ? ( no_limit => 1 ) : (),
            }
        );
    }
    else {
        my @panels     = qw{ author group };
        my $panel_info = {
            'author' => {
                panel_title       => $app->translate("Select Users"),
                panel_label       => $app->translate("Username"),
                items_prompt      => $app->translate("Users Selected"),
                search_label      => $app->translate("Search Users"),
                panel_description => $app->translate("Name"),
            },
            'group' => {
                panel_title       => $app->translate("Select Groups"),
                panel_label       => $app->translate("Group Name"),
                items_prompt      => $app->translate("Groups Selected"),
                search_label      => $app->translate("Search Groups"),
                panel_description => $app->translate("Description"),
            },
        };
        my $params;
        $params->{panel_multi}  = 1;
        $params->{dialog_title} = $app->translate("Add Users to Groups");
        $params->{panel_loop}   = [];

        for ( my $i = 0; $i <= $#panels; $i++ ) {
            my $source       = $panels[$i];
            my $panel_params = {
                panel_type => $source,
                %{ $panel_info->{$source} },
                list_noncron     => 1,
                panel_last       => $i == $#panels,
                panel_first      => $i == 0,
                panel_number     => $i + 1,
                panel_total      => $#panels + 1,
                panel_has_steps  => ( $#panels == '0' ? 0 : 1 ),
                panel_searchable => 1,
            };

            # Only show active user/groups.
            my $limit = $app->param('limit') || 25;
            my $terms = {};
            my $args  = {
                sort  => 'name',
                limit => $limit,
            };

            if ( $source eq 'author' ) {
                require MT::Author;
                $terms->{status} = MT::Author::ACTIVE();
                $terms->{type}   = MT::Author::AUTHOR();
            }
            else {
                require MT::Group;
                $terms->{status} = MT::Group::ACTIVE();
            }

            $app->listing(
                {   no_html => 1,
                    code    => $hasher,
                    type    => $source,
                    params  => $panel_params,
                    terms   => $terms,
                    args    => $args,
                }
            );
            if (!$panel_params->{object_loop}
                || ( $panel_params->{object_loop}
                    && @{ $panel_params->{object_loop} } < 1 )
                )
            {
                $params->{"missing_$source"} = 1;
                $params->{"missing_data"}    = 1;
            }
            push @{ $params->{panel_loop} }, $panel_params;
        }

        # save the arguments from whence we came...
        $params->{return_args} = $app->return_args;

        $app->load_tmpl( 'dialog/dialog_select_group_user.tmpl', $params );
    }
}

sub remove_member {
    my $app      = shift;
    my $user     = $app->user;
    my $group_id = $app->param('group_id');
    my @id       = $app->multi_param('id');

    $app->validate_magic or return;
    $user->can_manage_users_groups() or return $app->permission_denied();

    $app->setup_filtered_ids
        if $app->param('all_selected');

    my $cls = MT->model('association');
    foreach my $id (@id) {
        my $assoc = $cls->load($id)
            or
            return $app->error( $app->translate( "Load failed: [_1]", $id ) );
        my $group  = $assoc->group;
        my $member = $assoc->user;
        $group->remove_user($member);

        $app->log(
            {   message => $app->translate(
                    "User '[_1]' (ID:[_2]) removed from group '[_3]' (ID:[_4]) by '[_5]'",
                    $member->name, $member->id, $group->name,
                    $group->id,    $user->name
                ),
                level    => MT::Log::INFO(),
                class    => 'system',
                category => 'remove_group_member'
            }
        );
    }

    $app->add_return_arg( saved_removed => 1 );
    $app->call_return;
}

sub add_member {
    my $app  = shift;
    my $user = $app->user;

    $app->validate_magic or return;
    $user->can_manage_users_groups() or return $app->permission_denied();

    my $groups = $app->param('group');
    my $users  = $app->param('author');

    my @groups = $groups ? split( /\,/, $groups ) : ();
    my @users  = $users  ? split( /\,/, $users )  : ();
    my $grp_class = $app->model('group');
    my $usr_class = $app->model('author');

    foreach my $grp (@groups) {
        my $gid = $grp;
        $gid =~ s/\D//g;
        my $group = $grp_class->load($gid)
            or return $app->error(
            $app->translate( "Group load failed: [_1]", $gid ) );

        foreach my $usr (@users) {
            my $uid = $usr;
            $uid =~ s/\D//g;
            my $member = $usr_class->load($uid)
                or return $app->error(
                $app->translate( "User load failed: [_1]", $uid ) );

            $group->add_user($member);
            $app->log(
                {   message => $app->translate(
                        "User '[_1]' (ID:[_2]) was added to group '[_3]' (ID:[_4]) by '[_5]'",
                        $member->name, $member->id, $group->name,
                        $group->id,    $user->name
                    ),
                    level    => MT::Log::INFO(),
                    class    => 'system',
                    category => 'add_group_member'
                }
            );
        }

    }

    my $uri = $app->uri(
        mode => 'list',
        args => { '_type' => 'group_member', saved => 1, blog_id => 0 }
    );
    $app->redirect($uri);
}

sub delete_group {
    my $app = shift;

    # To avoid infinite loop
    no warnings 'once';
    local *MT::App::CMS::handlers_for_mode = sub {undef};
    return $app->delete(@_);
}

sub view_group {
    my $app = shift;

    $app->validate_param({
        blog_id => [qw/ID/],
        id      => [qw/ID/],
        saved   => [qw/MAYBE_STRING/],
    }) or return;

    return $app->return_to_dashboard( redirect => 1 )
        if $app->param('blog_id');

    return $app->permission_denied()
        unless $app->user->can_manage_users_groups();

    my ($params) = @_;
    my $id = $app->param('id');
    my %param;
    %param = (%$params) if defined $params;
    my $group_class = $app->model('group');
    my $cfg         = $app->config;

    return $app->errtrans('Invalid request')
        if $cfg->AuthenticationModule ne 'MT'
        && $cfg->ExternalGroupManagement
        && !$id;

    my $obj;
    $obj = $group_class->load($id) if $id;
    my $user_class = $app->model('user');
    $app->add_breadcrumb( $app->translate("Groups"),
        $app->uri( mode => 'list', args => { _type => 'group', blog_id => 0, } ) );
    if ($id) {
        %param = %{ $obj->column_values };
        delete $param{external_id};
        $app->add_breadcrumb( $obj->name );
        $param{nav_authors} = 1;
        $param{status_enabled} = 1 if $obj->is_active;
        if ( $cfg->AuthenticationModule ne 'MT' ) {
            if ( $cfg->ExternalGroupManagement ) {
                my $id = $obj->external_id;
                $id = '' unless defined $id;
                if ( length($id) && ( $id !~ m/[\x00-\x1f\x80-\xff]/ ) ) {
                    $param{show_external_id} = 1;
                    $param{external_id}      = $id;
                }
            }
        }

        if ( my $created_by = $user_class->load( $obj->created_by ) ) {
            $param{created_by} = $created_by->name;
        }
        else {
            $param{created_by} = '';
        }
        $param{user_count}       = $obj->user_count;
        $param{permission_count} = MT->model('association')->count(
            {   group_id => $id,
                type     => MT::Association::GROUP_BLOG_ROLE(),
            }
        );
        if ( $app->user->can_manage_users_groups() ) {
            if ( !$app->config->ExternalGroupManagement ) {
                $param{can_edit_groupname} = 1;
            }
        }
    }
    else {
        $app->add_breadcrumb( $app->translate("Create Group") );
        $param{nav_authors}    = 1;
        $param{new_object}     = 1;
        $param{status_enabled} = 1;
        if ( $app->user->can_manage_users_groups() ) {
            $param{can_edit_groupname} = 1;
        }
        if ( $cfg->AuthenticationModule ne 'MT' ) {
            if ( $cfg->ExternalGroupManagement ) {
                my $id = $obj->external_id;
                $id = '' unless defined $id;
                if ( length($id) && ( $id !~ m/[\x00-\x1f\x80-\xff]/ ) ) {
                    $param{show_external_id} = 1;
                    $param{external_id}      = $id;
                }
            }
        }
    }
    $param{group_support}       = 1;
    $param{search_label}        = $app->translate('Groups');
    $param{object_type}         = 'group';
    $param{object_label}        = MT::Group->class_label;
    $param{object_label_plural} = MT::Group->class_label_plural;
    $param{screen_class}        = "edit-group";
    $param{saved}               = $app->param('saved');
    $param{error}               = $app->errstr if $app->errstr;
    my $tmpl = $app->load_tmpl("edit_group.tmpl");
    $tmpl->param( \%param );
    return $tmpl;
}

sub build_group_table {
    my $app = shift;
    my (%args) = @_;

    my $i = 1;
    my @group;
    my $iter;
    if ( $args{load_args} ) {
        my $class = $app->model('group');
        $iter = $class->load_iter( @{ $args{load_args} } );
    }
    elsif ( $args{iter} ) {
        $iter = $args{iter};
    }
    elsif ( $args{items} ) {
        $iter = sub { pop @{ $args{items} } };
    }
    return [] unless $iter;
    my $param = $args{param};
    $param->{has_edit_access}  = $app->user->can_manage_users_groups();
    $param->{is_administrator} = $app->user->is_superuser();
    my %user_count_refs;
    while ( my $group = $iter->() ) {
        my $row = {
            name           => $group->name,
            description    => $group->description,
            display_name   => $group->display_name,
            status_enabled => $group->is_active,
            id             => $group->id,
            user_count     => 0
        };
        $user_count_refs{ $group->id } = \$row->{user_count};
        $row->{object} = $group;
        push @group, $row;
    }
    return [] unless @group;
    my $assoc_class       = $app->model('association');
    my $author_count_iter = $assoc_class->count_group_by(
        {   type     => MT::Association::USER_GROUP(),
            group_id => [ keys %user_count_refs ],
        },
        { group => ['group_id'], }
    );
    while ( my ( $count, $author_id ) = $author_count_iter->() ) {
        ${ $user_count_refs{$author_id} } = $count;
    }
    $param->{group_table}[0]{object_loop} = \@group;

    $app->load_list_actions( 'group', $param );
    $param->{object_loop} = $param->{group_table}[0]{object_loop};

    \@group;
}

# Handler for removing a member from a group, doesn't remove a group
sub remove_group {
    my $app       = shift;

    my $user      = $app->user;
    my $author_id = $app->param('author_id');
    my @id        = $app->multi_param('id');

    $app->validate_magic or return;
    $user->can_manage_users_groups() or return $app->permission_denied();

    my $grp_class    = $app->model('group');
    my $author_class = $app->model('author');
    my $author       = $author_class->load($author_id)
        or return $app->error(
        $app->translate( "User load failed: [_1]", $author_id ) );

    foreach (@id) {
        my $group_id = $_;
        my $group    = $grp_class->load($group_id)
            or return $app->error(
            $app->translate( "Group load failed: [_1]", $group_id ) );
        $author->remove_group($group);
        $app->log(
            {   message => $app->translate(
                    "User '[_1]' (ID:[_2]) removed from group '[_3]' (ID:[_4]) by '[_5]'",
                    $author->name, $author->id, $group->name,
                    $group->id,    $user->name
                ),
                level    => MT::Log::INFO(),
                class    => 'system',
                category => 'remove_group_member'
            }
        );
    }

    $app->add_return_arg( saved_removed => 1 );
    $app->call_return;
}

# Handler for adding a user to a group
sub add_group {
    my $app  = shift;
    my $user = $app->user;

    $app->validate_magic or return;
    $user->can_manage_users_groups() or return $app->permission_denied();

    my $author_id    = $app->param('author_id');
    my $ids          = $app->param('ids');
    my $author_class = $app->model('author');
    my $author       = $author_class->load($author_id)
        or return $app->error(
        $app->translate( "Author load failed: [_1]", $author_id ) );

    if ($ids) {
        my @id = split( /\,/, $ids );
        my $grp_class = $app->model('group');
        foreach (@id) {
            my $group_id = $_;
            if ($group_id) {
                my $group = $grp_class->load($group_id)
                    or return $app->error(
                    $app->translate( "Group load failed: [_1]", $group_id ) );
                $group->add_user($author);
                $app->log(
                    {   message => $app->translate(
                            "User '[_1]' (ID:[_2]) was added to group '[_3]' (ID:[_4]) by '[_5]'",
                            $author->name, $author->id, $author->name,
                            $group->id,    $user->name
                        ),
                        level    => MT::Log::INFO(),
                        class    => 'system',
                        category => 'add_group_member'
                    }
                );
            }
        }
    }

    my $uri = $app->uri(
        mode => 'list_group',
        args => { author_id => $author_id, saved => 1 }
    );
    $app->redirect($uri);
}

sub edit_role {
    my $app         = shift;
    my $role_id     = $app->param('id');
    my $tmpl        = $app->response_content or return;
    my $params      = $tmpl->param;
    my $assoc_class = $app->model('association');
    my $group_count = $assoc_class->count(
        {   role_id  => $role_id,
            group_id => [ 1, undef ],
        },
        {   unique     => 'group_id',
            range_incl => { group_id => 1 },
        }
    );
    $params->{members} += $group_count;
    $tmpl;
}

sub post_save {
    my $eh = shift;
    my ($app, $obj, $original) = @_;

    if (!$original->id) {
        $app->log({
            message => $app->translate(
                "Group '[_1]' created by '[_2]'.", $obj->name,
                $app->user->name
            ),
            level    => MT::Log::INFO(),
            class    => 'group',
            category => 'new',
        });
    }
    else {
        $app->log({
            message => $app->translate(
                "Group '[_1]' (ID:[_2]) edited by '[_3]'",
                $obj->name, $obj->id, $app->user->name
            ),
            level    => MT::Log::NOTICE(),
            class    => 'group',
            category => 'edit',
            metadata => $obj->id,
        });
    }
    1;
}

sub post_delete {
    my ($eh, $app, $obj) = @_;

    $app->log({
        message => $app->translate(
            "Group '[_1]' (ID:[_2]) deleted by '[_3]'",
            $obj->name, $obj->id, $app->user->name
        ),
        level    => MT::Log::NOTICE(),
        class    => 'group',
        category => 'delete'
    });
    1;
}

1;
