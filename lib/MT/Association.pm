# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
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
