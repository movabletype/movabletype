# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.

package MT::CMS::Deprecated::User;

use strict;
use warnings;
use utf8;
use MT::Blog;
use MT::Author;

# DEPRECATED (MTC-30971)
sub dialog_grant_role_tree {
    my $app = shift;

    my $author_id = $app->param('author_id');
    my $blog_id   = $app->param('blog_id');
    my $role_id   = $app->param('role_id');

    my $this_user = $app->user;

PERMCHECK: {
        last PERMCHECK
            if $app->can_do('grant_role_for_all_blogs');
        last PERMCHECK
            if $blog_id
            && $this_user->permissions($blog_id)
            ->can_do('grant_role_for_blog');
        return $app->permission_denied();
    }

    my ( $user, $role );
    if ( $author_id && $author_id ne 'PSEUDO' ) {
        $user = MT::Author->load($author_id);
    }
    if ($role_id) {
        require MT::Role;
        $role = MT::Role->load($role_id);
    }

    my $hasher = sub {
        my ( $obj, $row ) = @_;
        $row->{label} = $row->{name};
        $row->{description} = $row->{nickname} if exists $row->{nickname};
        my $type = $app->param('type') || '';
        if ( $type && $type eq 'site' ) {
            if (   !$app->param('search')
                && UNIVERSAL::isa( $obj, 'MT::Website' )
                && $obj->has_blog() )
            {
                $row->{has_child} = 1;
                my $child_blogs = $obj->blogs();
                my $child_sites = [];
                push @$child_sites,
                    {
                    id          => $_->id,
                    label       => $_->name,
                    description => $_->description
                    } foreach @{$child_blogs};
                $row->{child_obj}       = $child_sites;
                $row->{child_obj_count} = scalar @{$child_blogs};
            }
        }
        $row->{disabled} = 1
            if UNIVERSAL::isa( $obj, 'MT::Role' )
            && $obj->has('administer_site')
            && !$app->can_do('grant_role_for_all_blogs')
            && !$this_user->permissions($blog_id)
            ->can_do('grant_role_for_blog');
        if ( UNIVERSAL::isa( $obj, 'MT::Author' ) ) {
            if ( $obj->userpic_url ) {
                $row->{icon} = $obj->userpic_url();
            }
            else {
                $row->{icon}
                    = MT->static_path . 'images/icons/ic_user-auth.svg';
            }
        }
        if ( UNIVERSAL::isa( $obj, 'MT::Group' ) ) {
            $row->{icon} = MT->static_path . 'images/icons/ic_group.svg';
        }

        if (UNIVERSAL::isa($obj, 'MT::Blog') && $obj->is_blog()) {
            if (my $parent = $obj->website) {
                # replace row only if the blog has a valid parent
                $row->{has_child} = 1;
                my $child_blogs = [$obj];
                my $child_sites = [];
                foreach (@{$child_blogs}) {
                    push @$child_sites, {
                        id          => $_->id,
                        label       => $_->name,
                        description => $_->description
                    };
                }
                $row->{child_obj}       = $child_sites;
                $row->{child_obj_count} = scalar @{$child_blogs};
                $row->{id}              = $parent->id;
                $row->{label}           = $parent->name;
                $row->{description}     = $parent->description;
            }
        }
    };
    my $pre_build = sub {
        my ($param) = @_;
        my $loop = $param->{object_loop};
        my @has_child_sites    = grep { $_->{has_child}; } @$loop;
        my %has_child_site_ids = map { $_->{id} => 1 } @has_child_sites;
        my @new_object_loop;
        my %seen;
        foreach my $data (@$loop) {

            # If you have has_child, it is created after the search,
            # so remove the retrieved object
            if ( !$data->{has_child} && $has_child_site_ids{$data->{id}} ) {
                next;
            }
            next if $seen{$data->{id}}++;
            push @new_object_loop, $data;
        }
        $param->{object_loop} = \@new_object_loop;
    };

    my $type = $app->param('_type') || '';  # user, author, group, site

    if ( $app->param('search') || $app->param('json') ) {
        my $params = {
            panel_type   => $type,
            list_noncron => 1,
            panel_multi  => 1,
            has_group    => 1,
        };
        if ($type eq 'user') {
            my $author_terms = {
                status => MT::Author::ACTIVE(),
                type   => MT::Author::AUTHOR()
            };
            require MT::Group;
            my $group_terms = { status => MT::Group::ACTIVE() };
            my $no_limit
                = $app->param('no_limit')
                ? 1
                : ( $app->param('search') ? 1 : 0 );
            $app->multi_listing(
                {   args => { sort => 'name' },
                    type         => [ 'group', 'author' ],
                    code         => $hasher,
                    params       => $params,
                    author_terms => $author_terms,
                    group_terms  => $group_terms,
                    template     => 'include/listing_panel.tmpl',
                    $no_limit ? ( no_limit => 1 ) : (),
                }
            );
        }
        else {
            my $terms = {};
            if ($type eq 'author') {
                $terms->{status} = MT::Author::ACTIVE();
                $terms->{type}   = MT::Author::AUTHOR();
            }
            if ($type eq 'group') {
                require MT::Group;
                $terms->{status} = MT::Group::ACTIVE();
            }
            if ($type eq 'site') {
                $terms->{class} = ['website', 'blog'];
            }
            $app->listing(
                {   terms    => $terms,
                    args     => { sort => 'name' },
                    type     => $type,
                    code     => $hasher,
                    params   => $params,
                    template => 'include/listing_panel.tmpl',
                    $type eq 'site'       ? ( pre_build => $pre_build ) : (),
                    $app->param('search') ? ( no_limit  => 1 )          : (),
                }
            );
        }
    }
    else {

        # traditional, full-screen listing
        my $params = {
            ( $author_id || 0 ) eq 'PSEUDO'
            ? ( edit_author_name => $app->translate('(newly created user)'),
                edit_author_id   => 'PSEUDO'
                )
            : $author_id ? (
                edit_author_name => $user->nickname
                ? $user->nickname
                : $user->name,
                edit_author_id => $user->id,
                )
            : (),
            $role_id
            ? ( role_name => $role->name,
                role_id   => $role->id,
                )
            : (),
        };

        my @panels;
        if ( !$role_id ) {
            push @panels, 'role';
        }
        if ( !$blog_id ) {
            my @blogs;
            my $iter = MT::Blog->load_iter( { class => '*' } );
            while ( my $blog = $iter->() ) {
                push @blogs, $blog->id;
            }

            # if only one blog exists, skip the blog selection step.
            if ( @blogs == 1 ) {
                $blog_id = $blogs[0];
            }
            else {
                push @panels, 'blog'
                    if ( $app->param('type')
                    && $app->param('type') eq 'blog' );
                push @panels, 'website'
                    if ( $app->param('type')
                    && $app->param('type') eq 'website' );

                if (   $app->param('type')
                    && $app->param('type') eq 'site' )
                {
                    push @panels, 'site';

                }
            }
        }

        if ( !$author_id ) {
            if ( $type eq 'user' ) {
                unshift @panels, 'author';
            }
        }

        my $panel_info = {
            'site' => {
                panel_title       => $app->translate("Select Site"),
                panel_label       => $app->translate("Site Name"),
                items_prompt      => $app->translate("Sites Selected"),
                panel_description => $app->translate("Description"),
            },
            'author' => {
                panel_title       => $app->translate("Select Users"),
                panel_label       => $app->translate("Username"),
                items_prompt      => $app->translate("Users Selected"),
                panel_description => $app->translate("Name"),
            },
            'role' => {
                panel_title       => $app->translate("Select Roles"),
                panel_label       => $app->translate("Role Name"),
                items_prompt      => $app->translate("Roles Selected"),
                panel_description => $app->translate("Description"),
            },
        };

        $params->{panel_multi}  = 1;
        $params->{blog_id}      = $blog_id;
        $params->{dialog_title} = $app->translate("Grant Permissions");
        $params->{panel_loop}   = [];
        $params->{has_group}    = 1;

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
                panel_searchable => ( $source eq 'role' ? 0 : 1 ),
            };

            # Only show active user/groups.
            my $limit = $app->param('limit') || 25;
            my $terms = {};
            my $args  = {
                sort  => 'name',
                limit => $limit,
            };
            if ( $source eq 'author' ) {
                $terms->{status} = MT::Author::ACTIVE();
                $terms->{type}   = MT::Author::AUTHOR();
            }

            if ( $source eq 'site' ) {
                $terms->{class} = 'website';
            }

            if ( $source eq 'author' ) {
                $panel_params->{panel_title}
                    = $app->translate("Select Groups And Users");
                $panel_params->{items_prompt}
                    = $app->translate("Groups/Users Selected");
                $panel_params->{panel_label}
                    = $app->translate("User/Group Name");
                $panel_params->{panel_description}
                    = $app->translate("Description");

                my $author_terms = {
                    status => MT::Author::ACTIVE(),
                    type   => MT::Author::AUTHOR()
                };
                require MT::Group;
                my $group_terms = { status => MT::Group::ACTIVE() };
                $app->multi_listing(
                    {   no_html      => 1,
                        code         => $hasher,
                        type         => [ 'group', 'author' ],
                        params       => $panel_params,
                        author_terms => $author_terms,
                        group_terms  => $group_terms,
                        args         => $args,
                    }
                );
            }
            else {

                $app->listing(
                    {   no_html => 1,
                        code    => $hasher,
                        type    => $source,
                        params  => $panel_params,
                        terms   => $terms,
                        args    => $args,
                    }
                );
            }
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

        if ( $app->param('role_selection') ) {
            $params->{role_selection} = 1;
        }

        $params->{build_compose_menus} = 0;
        $params->{build_user_menus}    = 0;

        $app->load_tmpl( 'dialog/create_association.tmpl', $params );
    }
}

1;
