# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Association;

use strict;
use warnings;
use base qw( MT::Object );

__PACKAGE__->install_properties(
    {   column_defs => {
            'id'        => 'integer not null auto_increment',
            'type'      => 'integer not null',
            'author_id' => 'integer',
            'blog_id'   => 'integer',
            'group_id'  => 'integer',
            'role_id'   => 'integer',
        },
        indexes => {
            blog_id    => 1,
            author_id  => 1,
            role_id    => 1,
            group_id   => 1,
            type       => 1,
            created_on => 1,
        },
        defaults => {
            author_id => 0,
            group_id  => 0,
            blog_id   => 0,
            role_id   => 0,
        },
        audit       => 1,
        datasource  => 'association',
        primary_key => 'id',
    }
);

sub USER_BLOG_ROLE ()  {1}
sub GROUP_BLOG_ROLE () {2}
sub USER_GROUP ()      {3}
sub USER_ROLE ()       {4}
sub GROUP_ROLE ()      {5}

sub class_label {
    MT->translate("Association");
}

sub class_label_plural {
    MT->translate("Associations");
}

sub list_props {
    return {
        user_name => {
            label        => 'User/Group',
            filter_label => 'User/Group Name',
            base         => '__virtual.string',
            display      => 'force',
            order        => 100,
            col          => 'name',               # this looks up author table
            html         => sub {
                my ( $prop, $obj, $app ) = @_;
                require MT::Author;
                my $type
                    = $obj->type == MT::Association::USER_BLOG_ROLE()
                    ? 'user'
                    : 'group';
                my $icon_type = $type eq 'user' ? 'ic_user' : 'ic_member';
                my $name      = MT::Util::encode_html( $obj->$type->name );
                my $edit_link = $app->uri(
                    mode => 'view',
                    args => {
                        _type => $type eq 'user' ? 'author' : 'group',
                        id => $obj->$type->id,
                        blog_id => 0,
                    },
                );
                my $static_uri = $app->static_path;
                return qq{
                                    <a href="$edit_link">$name</a>
                                    <span class="target-type $type">
                                        <svg role="img" class="mt-icon mt-icon--sm">
                                            <title>$type</title>
                                            <use xlink:href="${static_uri}images/sprite.svg#$icon_type"></use>
                                        </svg>
                                    </span>
                                };
            },
            terms => sub {
                my $prop = shift;
                my ( $args, $db_terms, $db_args ) = @_;
                my $author_terms = $prop->super(@_);
                my @authors
                    = MT->model('author')->load( { %$author_terms, }, );
                my @groups = MT->model('group')->load( { %$author_terms, }, );
                if ( scalar @authors && scalar @groups ) {
                    return [
                        [   { author_id => [ map { $_->id } @authors ] },
                            '-or',
                            { group_id => [ map { $_->id } @groups ] },
                        ]
                    ];
                }
                elsif ( scalar @authors ) {
                    return { author_id => [ map { $_->id } @authors ] };
                }
                elsif ( scalar @groups ) {
                    return { group_id => [ map { $_->id } @groups ] };
                }
                return { author_id => { '<' => 0 } };
            },
            bulk_sort => sub {
                my $prop = shift;
                my ($objs) = @_;
                sort {
                    (     $a->type == MT::Association::USER_BLOG_ROLE()
                        ? $a->user->name
                        : $a->group->name
                        ) cmp(
                        $b->type == MT::Association::USER_BLOG_ROLE()
                        ? $b->user->name
                        : $b->group->name
                        )
                } @$objs;
            },
            sort => 0,
        },
        role_name => {
            label        => 'Role',
            filter_label => 'Role Name',
            display      => 'force',
            order        => 200,
            base         => '__virtual.string',
            col          => 'name',               # this looks up role table
            sub_fields   => [
                {   class   => 'role-detail',
                    label   => 'Role Detail',
                    display => 'optional',
                },
            ],
            html => sub {
                my ( $prop, $obj, $app ) = @_;
                my $role      = $obj->role;
                my $name      = MT::Util::encode_html( $role->name );
                my $edit_link = $app->uri(
                    mode => 'view',
                    args => {
                        _type   => 'role',
                        id      => $role->id,
                        blog_id => 0,
                    },
                );
                my $detail = $role->permissions;
                if ( defined $detail ) {
                    my @perms = map { $_ =~ s/'//g; $_; } split ',', $detail;
                    my $all_perms
                        = MT->model('permission')->perms_from_registry;
                    my @permhashes
                        = map { $all_perms->{ 'blog.' . $_ } } @perms;
                    $detail = join ', ', (
                        sort
                            map {
                            ref $_->{label}
                                ? $_->{label}->()
                                : $_->{label}
                            } @permhashes
                    );
                }
                else {
                    $detail = '';
                }
                if ( $app->can_do('edit_role') ) {
                    return qq{
                        <span class="rolename"><a href="$edit_link">$name</a></span>
                        <p class="role-detail description">$detail<p>
                    };
                }
                else {
                    return qq{
                        <span class="rolename">$name</span>
                        <p class="role-detail description">$detail<p>
                    };
                }
            },
            terms => sub {
                my $prop = shift;
                my ( $args, $db_terms, $db_args ) = @_;
                my $role_terms = $prop->super(@_);
                my @roles = MT->model('role')->load( { %$role_terms, }, );
                if ( scalar @roles < 1 ) {
                    return { role_id => \'< 0' };    # FOR-EDITOR '};
                }
                return { role_id => [ map { $_->id } @roles ], };
            },
            bulk_sort => sub {
                my $prop = shift;
                my ($objs) = @_;
                sort {
                    (     $a->type == MT::Association::USER_BLOG_ROLE()
                        ? $a->user->name
                        : $a->group->name
                        ) cmp(
                        $b->type == MT::Association::USER_BLOG_ROLE()
                        ? $b->user->name
                        : $b->group->name
                        )
                } @$objs;
            },
        },
        group_id => {
            auto            => 1,
            label           => 'Group',
            display         => 'none',
            filter_editable => 0,
            label_via_param => sub {
                my ( $prop, $app, $val ) = @_;
                my $group = MT->model('group')->load($val)
                    or return $prop->error(
                    MT->translate('Invalid parameter.') );
                return MT->translate(
                    'Permissions of group: [_1]',
                    $group->display_name || $group->name,
                );
            },
            args_via_param => sub {
                my $prop = shift;
                my ( $app, $val ) = @_;
                return { option => 'equal', value => $val };
            },

        },
        type => {
            base                  => '__virtual.single_select',
            display               => 'none',
            col                   => 'type',
            label                 => 'Type',
            single_select_options => sub {
                my @sso;

                push @sso,
                    {
                    label => MT->translate('User'),
                    value => 1
                    };
                push @sso,
                    {
                    label => MT->translate('Group'),
                    value => 2
                    };
                return \@sso;
            },
        },
        blog_name => {
            label        => 'Site Name',
            filter_label => 'Site Name',
            base         => '__virtual.string',
            display      => 'default',
            order        => 300,
            col => 'name',    # this looks up mt_blog.blog_nam column
            default_sort_order => 'ascend',
            bulk_html          => sub {
                my $prop = shift;
                my ( $objs, $app ) = @_;
                my %blog_ids = map { $_->blog_id => 1 } @$objs;
                my @blogs = MT->model('blog')->load(
                    { id => [ keys %blog_ids ], },
                    {   fetchonly => {
                            id   => 1,
                            name => 1,
                        }
                    }
                );
                my %names = map { $_->id => $_->name } @blogs;
                my @outs;
                for my $obj (@$objs) {
                    my $name
                        = MT::Util::encode_html( $names{ $obj->blog_id } );
                    my $dashboard_url = $app->uri(
                        mode => 'dashboard',
                        args => { blog_id => $obj->blog_id, },
                    );
                    push @outs, $name;
                }
                @outs;
            },
            terms => sub {
                my $prop = shift;
                my ( $args, $db_terms, $db_args ) = @_;
                my $blog_terms = $prop->super(@_);
                my @blogs      = MT->model('blog')->load(
                    {   class => '*',
                        %$blog_terms,
                    },
                );
                return
                    scalar @blogs
                    ? { blog_id => [ map { $_->id } @blogs ], }
                    : { blog_id => -1 };
            },
            sort      => 0,
            bulk_sort => sub {
                my $prop    = shift;
                my ($objs)  = @_;
                my %blog_id = map { $_->blog_id => 1 } @$objs;
                my @blogs
                    = MT->model('blog')->load( { id => [ keys %blog_id ] } );
                my %blogname = map { $_->id => $_->name } @blogs;
                return sort {
                    $blogname{ $a->blog_id } cmp $blogname{ $b->blog_id }
                } @$objs;
            },
        },
        created_on => {
            base    => '__virtual.created_on',
            display => 'default',
            order   => 400,
        },
        role_id => {
            auto            => 1,
            label           => 'Role',
            display         => 'none',
            filter_editable => 0,
            label_via_param => sub {
                my ( $prop, $app, $val ) = @_;
                my $role = MT->model('role')->load($val)
                    or
                    return $prop->error( MT->translate('Invalid parameter') );
                return MT->translate( 'Permissions with role: [_1]',
                    $role->name, );
            },
        },
        author_id => {
            base            => '__virtual.hidden',
            col             => 'author_id',
            display         => 'none',
            filter_editable => 0,
            label           => sub {
                my ( $prop, $app, $val ) = @_;
                my $author = MT->model('author')->load($val)
                    or
                    return $prop->error( MT->translate('Invalid parameter') );
                my $label
                    = MT->translate( 'User is [_1]', $author->nickname, );
                return $label;
            },
            label_via_param => sub {
                my ( $prop, $app, $val ) = @_;
                my $author = MT->model('author')->load($val)
                    or
                    return $prop->error( MT->translate('Invalid parameter') );
                my $label = MT->translate( 'Permissions for [_1]',
                    $author->nickname, );
                return $label;
            },
            args_via_param => sub {
                my ( $prop, $app, $val ) = @_;
                my $author = MT->model('author')->load($val)
                    or
                    return $prop->error( MT->translate('Invalid parameter') );
                my $label = MT->translate( 'Permissions for [_1]',
                    $author->nickname, );
                return {
                    value => $val,
                    label => $label,
                };
            },
        },
        _type => {
            view  => [],
            terms => sub {
                my $types = [
                    MT::Association::USER_BLOG_ROLE(),
                    MT::Association::GROUP_BLOG_ROLE()
                ];
                return { type => $types };
            }
        },
        modified_on => {
            display => 'none',
            base    => '__virtual.modified_on',
        },
        blog_id => { auto => 1, display => 'none', filter_editable => 0, },
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
    if ( ref $assoc ) {
        $assoc->rebuild_permissions;
    }
    $res;
}

sub rebuild_permissions {
    my $assoc = shift;
    require MT::Permission;
    MT::Permission->rebuild($assoc);

    $assoc->_rebuild_favorite;
}

sub user {
    my $assoc = shift;
    $assoc->cache_property(
        'user',
        sub {
            require MT::Author;
            $assoc->author_id ? MT::Author->load( $assoc->author_id ) : undef;
        }
    );
}

sub blog {
    my $assoc = shift;
    $assoc->cache_property(
        'blog',
        sub {
            require MT::Blog;
            $assoc->blog_id ? MT::Blog->load( $assoc->blog_id ) : undef;
        }
    );
}

sub group {
    my $assoc = shift;
    $assoc->cache_property(
        'group',
        sub {
            require MT::Group;
            $assoc->group_id ? MT::Group->load( $assoc->group_id ) : undef;
        }
    );
}

sub role {
    my $assoc = shift;
    $assoc->cache_property(
        'role',
        sub {
            require MT::Role;
            $assoc->role_id ? MT::Role->load( $assoc->role_id ) : undef;
        }
    );
}

# Creates an association between 2 or 3 objects
sub link {
    my $pkg   = shift;
    my $terms = $pkg->objects_to_terms(@_);
    return unless $terms;
    my $assoc = $pkg->get_by_key($terms);
    if ( !$assoc->id ) {
        if ( MT->instance->isa('MT::App') ) {
            $assoc->created_by( MT->instance->user->id )
                if ( defined( MT->instance->user ) );
        }
        $assoc->save or return;
    }
    $assoc;
}

# Removes an association between 2 or 3 objects
sub unlink {
    my $pkg   = shift;
    my $terms = $pkg->objects_to_terms(@_);
    return unless $terms;
    my $assoc = $pkg->get_by_key($terms);
    $assoc->id ? $assoc->remove : 1;
}

sub objects_to_terms {
    my $pkg   = shift;
    my %param = map { ref $_ => $_ } @_;
    my $terms = {};
    $terms->{author_id} = $param{'MT::Author'}->id  if $param{'MT::Author'};
    $terms->{group_id}  = $param{'MT::Group'}->id   if $param{'MT::Group'};
    $terms->{role_id}   = $param{'MT::Role'}->id    if $param{'MT::Role'};
    $terms->{blog_id}   = $param{'MT::Blog'}->id    if $param{'MT::Blog'};
    $terms->{blog_id}   = $param{'MT::Website'}->id if $param{'MT::Website'};
    if ( $terms->{author_id} && $terms->{blog_id} && $terms->{role_id} ) {
        $terms->{type} = USER_BLOG_ROLE;
    }
    elsif ( $terms->{group_id} && $terms->{blog_id} && $terms->{role_id} ) {
        $terms->{type} = GROUP_BLOG_ROLE;
    }
    elsif ( $terms->{group_id} && $terms->{author_id} ) {
        $terms->{type} = USER_GROUP;

        # To be defined...
        #} elsif ($terms->{user_id} && $terms->{role_id}) {
        #    $terms->{type} = USER_ROLE;
        #} elsif ($terms->{group_id} && $terms->{role_id}) {
        #    $terms->{type} = GROUP_ROLE;
    }
    else {
        return undef;
    }
    $terms;
}

sub _rebuild_favorite {
    my ($obj) = @_;

    my $app = MT->instance;
    return if !$app or $app->isa('MT::App::Upgrader');
    return if $obj->type != USER_BLOG_ROLE;

    my $user = $obj->user;
    $user->rebuild_favorite_sites;
}

sub system_filters {
    return {
        for_user => {
            label => 'Permissions for Users',
            items => [
                {   type => 'type',
                    args => { value => 1, }
                },
            ],
            order => 100,
        },
        for_group => {
            label => 'Permissions for Groups',
            items => [
                {   type => 'type',
                    args => { value => 2, }
                },
            ],
            order => 200,
        },
    };
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

=head2 MT::Association->link(@things)

Creates a new association record that ties the elements of C<@things>
together. The list of C<@things> may contain:

=over 4

=item 1. user, role, blog

=item 2. group, role, blog

=item 3. user, group

=item 4. user, role

=item 5. group, role

=item 6. user, role, website

=item 7. group, role, website

=back

Any other combination will fail horribly.

=head2 MT::Association->unlink(@things)

Removes any association record that exists that ties the elements of
C<@things> together. See the L<link> method for valid values to pass
for the C<@things> parameter.

=head2 $assoc->rebuild_permissions()

Update permissions affected by this association object. Will be called
automatically after save and remove operations.

=head2 $assoc->user()

Returns the L<MT::Author> object tied to this association. Returns undef if
the author_id property is undefined.

=head2 $assoc->blog()

Returns the L<MT::Blog> object tied to this association. Returns undef if
the blog_id property is undefined.

IF this association is with a website instead of a blog, this function
will return a L<MT::Website> object

=head2 $assoc->group()

Returns the L<MT::Group> object tied to this association. Returns undef if
the group_id property is undefined.

=head2 $assoc->role()

Returns the L<MT::Role> object tied to this association. Returns undef if
the role_id property is undefined.

=head2 $assoc->save()

Saves this association and rebuilds its permission.

=head2 $assoc->remove([\%terms])

Removes this association and optionally, constrains the set with I<%terms>.

=head2 MT::Association->class_label

Returns the localized descriptive name for this class.

=head2 MT::Association->class_label_plural

Returns the localized, plural descriptive name for this class.

=head2 MT::Association->list_props

Returns the list_properties registry of this class.

=head2 MT::Association->objects_to_terms(@things)

Utility method that takes an array containing user, group, role, blog
or website objects and returns a hashref suitable to use for terms for the
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

=item * MT::Association::USER_ROLE

=item * MT::Association::GROUP_ROLE

=back

Even if this association is with a website instead of a blog,
still USER_BLOG_ROLE and GROUP_BLOG_ROLE should be used

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
