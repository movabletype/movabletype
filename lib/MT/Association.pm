# Movable Type (r) Open Source (C) 2001-2010 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package MT::Association;

use strict;
use base qw( MT::Object );

__PACKAGE__->install_properties({
    column_defs => {
        'id'           => 'integer not null auto_increment',
        'type'         => 'integer not null',
        'author_id'    => 'integer',
        'blog_id'      => 'integer',
        'group_id'     => 'integer',
        'role_id'      => 'integer',
    },
    indexes => {
        blog_id        => 1,
        author_id      => 1,
        role_id        => 1,
        group_id       => 1,
        type           => 1,
        created_on     => 1,
    },
    defaults => {
        author_id      => 0,
        group_id       => 0,
        blog_id        => 0,
        role_id        => 0,
    },
    audit => 1,
    datasource  => 'association',
    primary_key => 'id',
});

sub USER_BLOG_ROLE ()  { 1 }
sub GROUP_BLOG_ROLE () { 2 }
sub USER_GROUP ()      { 3 }
sub USER_ROLE ()       { 4 }
sub GROUP_ROLE ()      { 5 }

sub class_label {
    MT->translate("Association");
}

sub class_label_plural {
    MT->translate("Associations");
}

sub list_props {
    return {
        user_name => {
            label => 'User/Group',
            base => '__virtual.string',
            display => 'force',
            order   => 100,
            col => 'name',  # this looks up author/group table
            html => sub {
                my ( $prop, $obj, $app ) = @_;
                my $type = $obj->type == USER_BLOG_ROLE() ? 'user' : 'group';
                my $icon_url = MT->static_path . 'images/nav_icons/color/' . $type . '.gif';
                my $name = $obj->$type->name;
                my $edit_link = $app->uri(
                    mode => 'view',
                    args => {
                        _type   => $type eq 'user' ? 'author' : 'group',
                        id      => $obj->$type->id,
                        blog_id => 0,
                    },
                );
                return qq{
                    <a href="$edit_link">$name</a>
                    <span class="target-type $type">
                        <img src="$icon_url" />
                    </span>
                };
            },
            terms => sub {
                my $prop = shift;
                my ( $args, $db_terms, $db_args ) = @_;
                my $author_terms = $prop->super(@_);
                my @authors = MT->model('author')->load(
                    {
                        %$author_terms,
                    },
                );
                my @groups = MT->model('group')->load(
                    {
                        %$author_terms,
                    },
                );
                return [
                    { author_id => [ map { $_->id } @authors ] },
                    '-or',
                    { group_id => [ map { $_->id } @groups ] },
                ];
            },
            bulk_sort => sub {
                my $prop = shift;
                my ( $objs ) = @_;
                sort {
                    ( $a->type == USER_BLOG_ROLE() ? $a->user->name
                                                   : $a->group->name )
                    cmp
                    ( $b->type == USER_BLOG_ROLE() ? $b->user->name
                                                   : $b->group->name )
                } @$objs;
            },
            sort => 0,
        },
        role_name => {
            label => 'Role',
            display => 'force',
            order   => 200,
            base => '__virtual.string',
            col => 'name',  # this looks up role table
            html => sub {
                my ( $prop, $obj, $app ) = @_;
                my $role = $obj->role;
                my $name = $role->name;
                my $edit_link = $app->uri(
                    mode => 'view',
                    args => {
                        _type   => 'role',
                        id      => $role->id,
                        blog_id => 0,
                    },
                );
                return qq{
                    <a href="$edit_link">$name</a>
                };
            },
            terms => sub {
                my $prop = shift;
                my ( $args, $db_terms, $db_args ) = @_;
                my $role_terms = $prop->super(@_);
                my @roles = MT->model('role')->load(
                    {
                        %$role_terms,
                    },
                );
                return {
                    role_id => [ map { $_->id } @roles ],
                };
            },
            sort => sub {
                my $prop = shift;
                my ( $terms, $args ) = @_;
                $args->{joins} ||= [];
                push @{ $args->{joins} }, MT->model('role')->join_on(
                    undef,
                    {
                        id => \'= association_role_id',
                    },
                    {
                        sort => 'name',
                    },
                );
                return;
            },
        },
        blog_name => {
            label => 'Blog/Website',
            base => '__virtual.string',
            display => 'default',
            order   => 300,
            col => 'name',  # this looks up mt_blog.blog_nam column
            default_sort_order => 'ascend',
            bulk_html => sub {
                my $prop = shift;
                my ( $objs, $app ) = @_;
                my %blog_ids  = map { $_->blog_id => 1 } @$objs;
                my @blogs = MT->model('blog')->load({
                    id => [ keys %blog_ids ], },{
                    fetchonly => {
                        id   => 1,
                        name => 1,
                }});
                my %names = map { $_->id => $_->name } @blogs;
                my @outs;
                for my $obj ( @$objs ) {
                    my $name = $names{$obj->blog_id};
                    my $dashboard_url = $app->uri(
                        mode => 'dashboard',
                        args => {
                            blog_id => $obj->blog_id,
                        },
                    );
                    push @outs, qq{
                        <a href="$dashboard_url">$name</a>
                    };
                }
                @outs;
            },
            terms => sub {
                my $prop = shift;
                my ( $args, $db_terms, $db_args ) = @_;
                my $blog_terms = $prop->super(@_);
                my @blogs = MT->model('blog')->load(
                    {
                        class => '*',
                        %$blog_terms,
                    },
                );
                return {
                    blog_id => [ map { $_->id } @blogs ],
                };
            },
            sort => 0,
            bulk_sort => sub {
                my $prop = shift;
                my ( $objs ) = @_;
                my %blog_id = map { $_->blog_id => 1 } @$objs;
                my @blogs = MT->model('blog')->load({ id => [ keys %blog_id ] });
                my %blogname = map { $_->id => $_->name } @blogs;
                return sort { $blogname{ $a->blog_id } cmp $blogname{ $b->blog_id } } @$objs;
            },
        },
        created_on => {
            base  => '__virtual.created_on',
            order => 400,
        },

        role_id => {
            auto    => 1,
            label   => 'Role',
            display => 'none',
            filter_editable => 0,
            args_via_param => sub {
                my ( $prop, $app ) = @_;
                return { option => 'equal', value => $app->param('filter_val') };
            },
            label_via_param => sub {
                my ( $prop, $app ) = @_;
                my $role = MT->model('role')->load( $app->param('filter_val') );
                return MT->translate(
                    'Associations with role: [_1]',
                    $role->name,
                );
            },
        },
        author_id => {
            auto    => 1,
            label   => 'Author',
            display => 'none',
            filter_editable => 0,
            args_via_param => sub {
                my ( $prop, $app ) = @_;
                return { option => 'equal', value => $app->param('filter_val') };
            },
            label_via_param => sub {
                my ( $prop, $app ) = @_;
                my $author = MT->model('author')->load( $app->param('filter_val') );
                return MT->translate(
                    'Associations of author: [_1]',
                    $author->nickname,
                );
            },
        },

        _type => {
            view => [],
            terms => sub {
               return { type => [ 1, 2 ] };
            }
        },
        type => {
            base    => '__virtual.single_select',
            display => 'none',
            col     => 'type',
            label   => 'Type',
            single_select_options => [
                { label => 'User', value => 1, },
                { label => 'Group', value => 2, },
            ],
        },
        modified_on => {
            display => 'none',
            base => '__virtual.modified_on',
        },
    };
}

sub system_filters {
    return {
        for_user => {
            label => 'Associations for User',
            items => [
                { type => 'type', args => { value => '1' }, },
            ],
        },
        for_group => {
            label => 'Associations for Group',
            items => [
                { type => 'type', args => { value => '2' }, },
            ],
        },
    };
}

sub save {
    my $assoc = shift;
    my $res = $assoc->SUPER::save(@_) or return;
    $assoc->rebuild_permissions;
    $res;
}

sub remove {
    my $assoc = shift;
    my $res = $assoc->SUPER::remove(@_) or return;
    if (ref $assoc) {
        $assoc->rebuild_permissions;
    }
    $res;
}

sub rebuild_permissions {
    my $assoc = shift;
    require MT::Permission;
    MT::Permission->rebuild($assoc);
}

sub user {
    my $assoc = shift;
    $assoc->cache_property('user', sub {
        require MT::Author;
        $assoc->author_id ? MT::Author->load($assoc->author_id) : undef;
    });
}

sub blog {
    my $assoc = shift;
    $assoc->cache_property('blog', sub {
        require MT::Blog;
        $assoc->blog_id ? MT::Blog->load($assoc->blog_id) : undef;
    });
}

sub group {
    my $assoc = shift;
    $assoc->cache_property('group', sub {
        require MT::Group;
        $assoc->group_id ? MT::Group->load($assoc->group_id) : undef;
    });
}

sub role {
    my $assoc = shift;
    $assoc->cache_property('role', sub {
        require MT::Role;
        $assoc->role_id ? MT::Role->load($assoc->role_id) : undef;
    });
}

# Creates an association between 2 or 3 objects
sub link {
    my $pkg = shift;
    my $terms = $pkg->objects_to_terms(@_);
    return unless $terms;
    my $assoc = $pkg->get_by_key($terms);
    if (!$assoc->id) {
        if (MT->instance->isa('MT::App')) {
            $assoc->created_by(MT->instance->user->id) if (defined(MT->instance->user));
        }
        $assoc->save or return;
    }
    $assoc;
}

# Removes an association between 2 or 3 objects
sub unlink {
    my $pkg = shift;
    my $terms = $pkg->objects_to_terms(@_);
    return unless $terms;
    my $assoc = $pkg->get_by_key($terms);
    $assoc->id ? $assoc->remove : 1;
}

sub objects_to_terms {
    my $pkg = shift;
    my %param = map { ref $_ => $_ } @_;
    my $terms = {};
    $terms->{author_id} = $param{'MT::Author'}->id if $param{'MT::Author'};
    $terms->{group_id} = $param{'MT::Group'}->id if $param{'MT::Group'};
    $terms->{role_id} = $param{'MT::Role'}->id if $param{'MT::Role'};
    $terms->{blog_id} = $param{'MT::Blog'}->id if $param{'MT::Blog'};
    $terms->{blog_id} = $param{'MT::Website'}->id if $param{'MT::Website'};
    if ($terms->{author_id} && $terms->{blog_id} && $terms->{role_id}) {
        $terms->{type} = USER_BLOG_ROLE;
    } elsif ($terms->{group_id} && $terms->{blog_id} && $terms->{role_id}) {
        $terms->{type} = GROUP_BLOG_ROLE;
    } elsif ($terms->{group_id} && $terms->{author_id}) {
        $terms->{type} = USER_GROUP;
    # To be defined...
    #} elsif ($terms->{user_id} && $terms->{role_id}) {
    #    $terms->{type} = USER_ROLE;
    #} elsif ($terms->{group_id} && $terms->{role_id}) {
    #    $terms->{type} = GROUP_ROLE;
    } else {
        return undef;
    }
    $terms;
}

1;

#trans('association')
#trans('associations')

__END__

=head1 NAME

MT::Association - Relational table for Author/Group-Role-Blog relationships.

=head1 SYNOPSIS

    use MT::Association;

    # Define a Group - Role - Blog relationship
    MT::Association->link( $group => $role => $blog );

    # Define a User - Role - Blog relationship
    MT::Association->link( $user => $role => $blog );

    # Define a User - Group relationship
    MT::Association->link( $user => $group );

=head1 DESCRIPTION

This module handles relational mappings between L<MT::Author>, L<MT::Group>,
L<MT::Role> and L<MT::Blog> objects.

=head1 METHODS

=head2 $assoc->save()

Saves the association and calls the L<rebuild_permissions> method to
ensure the related permissions are updated.

=head2 $assoc->remove()

Removes the association and calls the L<rebuild_permissions> method to
ensure the related permissions are updated.

=head2 $assoc->rebuild_permissions()

An alias for calling C<MT::Permission->rebuild($assoc)>.

=head2 $assoc->user()

Returns the L<MT::Author> object tied to this association. Returns undef if
the author_id property is undefined.

=head2 $assoc->blog()

Returns the L<MT::Blog> object tied to this association. Returns undef if
the blog_id property is undefined.

=head2 $assoc->group()

Returns the L<MT::Group> object tied to this association. Returns undef if
the group_id property is undefined.

=head2 $assoc->role()

Returns the L<MT::Role> object tied to this association. Returns undef if
the role_id property is undefined.

=head2 MT::Association->link(@things)

Creates a new association record that ties the elements of C<@things>
together. The list of C<@things> may contain:

=over 4

=item 1. user, role, blog

=item 2. group, role, blog

=item 3. user, group

=back

Any other combination will fail horribly.

=head2 MT::Association->unlink(@things)

Removes any association record that exists that ties the elements of
C<@things> together. See the L<link> method for valid values to pass
for the C<@things> parameter.

=head2 MT::Association->objects_to_terms(@things)

Utility method that takes an array containing user, group, role, blog
objects and returns a hashref suitable to use for terms for the
C<MT::Association-E<gt>load> method.

=head1 DATA ACCESS METHODS

The I<MT::Association> object holds the following pieces of data. These
fields can be accessed and set using the standard data access methods
described in the I<MT::Object> documentation.

=over 4

=item * id

Primary key for the association object.

=item * type

Identifies the type of relationship. Valid types are defined by the
following constants:

=over 4

=item * MT::Association::USER_BLOG_ROLE

=item * MT::Association::GROUP_BLOG_ROLE

=item * MT::Association::USER_GROUP

=back

=item * author_id

L<MT::Author> id for associations related to a user. For other
association types, this value is undefined.

=item * blog_id

L<MT::Blog> id for associations related to a blog. For other
association types, this value is undefined.

=item * group_id

L<MT::Group> id for associations related to a group. For other
association types, this value is undefined.

=item * role_id

L<MT::Role> id for associations related to a role. For other
association types, this value is undefined.

=back

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
