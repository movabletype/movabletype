# Copyright 2001-2007 Six Apart. This code cannot be redistributed without
# permission from www.sixapart.com.  For more information, consult your
# Movable Type license.
#
# $Id$

package MT::Permission;
use strict;

use MT::Object;
use MT::Blog;
@MT::Permission::ISA = qw( MT::Object );
__PACKAGE__->install_properties({
    column_defs => {
        'id' => 'integer not null auto_increment',
        'author_id' => 'integer not null',
        'blog_id' => 'integer not null',
        'role_mask' => 'integer',
        'entry_prefs' => 'string(255)',
        'blog_prefs' => 'string(255)',
        'template_prefs' => 'string(255)',
    },
    child_of => 'MT::Blog',
    indexes => {
        blog_id => 1,
        author_id => 1,
        role_mask => 1,
    },
    datasource => 'permission',
    primary_key => 'id',
});

sub author {
    my $perm = shift;
#xxx Beware of circular references
    return $perm->{__author} if $perm->{__author};
    require MT::Author;
    $perm->{__author} = MT::Author->load($perm->author_id, {cached_ok=>1});
    return $perm->{__author};
}

{
    my @Perms = (
        [ 1, 'comment', 'Post Comments', ],
        [ 4096, 'administer_blog', 'Blog Administrator'],
        [ 2, 'post', 'Entry Creation', ],
        [ 4, 'upload', 'Upload File', ],
        [ 8, 'edit_all_posts', 'Edit All Entries', ],
        [ 16, 'edit_templates', 'Manage Templates', ],
#       [ 32, 'edit_authors', 'Edit Authors & Permissions', ],
        [ 64, 'edit_config', 'Configure Weblog', ],
        [ 128, 'rebuild', 'Rebuild Files', ],
        [ 256, 'send_notifications', 'Send Notifications', ],
        [ 512, 'edit_categories', 'Add/Manage Categories', ],
        [ 16384, 'edit_tags', 'Manage Tags' ],
        [ 1024, 'edit_notifications', 'Manage Notification List' ],
        [ 2048, 'not_comment', ''],  # not a real permission but a denial thereeof
        [ 8192, 'view_blog_log', 'View Activity Log For This Weblog']
    );

    sub set_full_permissions {
        my $perms = shift;
        my $mask = 0;
        for my $ref (@Perms) {
            next if ($ref->[1] =~ /^not_/);
            $mask += $ref->[0];
        }
        $perms->role_mask($mask);
    }

    sub perms { \@Perms }

    no strict 'refs';
    for my $ref (@Perms) {
        my $mask = $ref->[0];
        my $meth = 'can_' . $ref->[1];
        *$meth = sub {
            my $flags = $_[0]->role_mask || 0;
            if (@_ == 2) {
                $flags = $_[1] ? ($flags | $mask) :
                                 ($flags & ~$mask);
                $_[0]->role_mask($flags);
            } else {
                my $author = $_[0]->author;
                return $mask if ($author && $author->is_superuser)
                    || $_[0]->has('administer_blog');
            }
            $flags & $mask;
        };
    }

    # $perm->has() skips any fancy logic, returning true or false
    # depending only on whether the bit is set in this record.
    sub has {
        my $this = shift;
        my ($flag_name) = @_;
        my ($flag_info) = grep { $_->[1] eq $flag_name } @Perms;
        return ($this->role_mask || 0) & ($flag_info->[0] || 0);
    }
}

sub can_edit_authors {
    my $perms = shift;
    my $author = $perms->author;
    $perms->can_administer_blog || ($author && $author->is_superuser());
}

sub can_edit_entry {
    my $perms = shift;
    my($entry, $author) = @_;
    die unless $author->isa('MT::Author');
    return 1 if $author->is_superuser();
    unless (ref $entry) {
        require MT::Entry;
        $entry = MT::Entry->load($entry, {cached_ok=>1});
    }
    die unless $entry->isa('MT::Entry');
    $perms->can_edit_all_posts ||
        ($perms->can_post && $entry->author_id == $author->id);
}

sub to_hash {
    my $perms = shift;
    my $hash = {}; # $perms->SUPER::to_hash(@_);
    my $all_perms = MT::Permission->perms();
    foreach (@$all_perms) {
        my $perm = $_->[1];
        $hash->{"permission.can_$perm"} = $perms->has($perm);
    }
    $hash;
}

1;
__END__

=head1 NAME

MT::Permission - Movable Type permissions record

=head1 SYNOPSIS

    use MT::Permission;
    my $perms = MT::Permission->load({ blog_id => $blog->id,
                                       author_id => $author->id })
        or die "Author has no permissions for blog";
    $perms->can_post
        or die "Author cannot post to blog";

    $perms->can_edit_config(0);
    $perms->save
        or die $perms->errstr;

=head1 DESCRIPTION

An I<MT::Permission> object represents the permissions settings for an author
in a particular blog. Permissions are set on a role basis, and each permission
is either on or off for an author-blog combination; permissions are stored as
a bitmask.

=head1 USAGE

As a subclass of I<MT::Object>, I<MT::Permission> inherits all of the
data-management and -storage methods from that class; thus you should look
at the I<MT::Object> documentation for details about creating a new object,
loading an existing object, saving an object, etc.

The following methods are unique to the I<MT::Permission> interface. Each of
these methods, B<except> for I<set_full_permissions>, can be called with an
optional argument to turn the permission on or off. If the argument is some
true value, the permission is enabled; otherwise, the permission is disabled.
If no argument is provided at all, the existing permission setting is
returned.

=head2 $perms->set_full_permissions

Turns on all permissions for the author and blog represented by I<$perms>.

=head2 $perms->can_post

Returns true if the author can post to the blog, and edit the entries that
he/she has posted; false otherwise.

=head2 $perms->can_upload

Returns true if the author can upload files to the blog directories specified
for this blog, false otherwise.

=head2 $perms->can_edit_all_posts

Returns true if the author can edit B<all> entries posted to this blog (even
entries that he/she did not write), false otherwise.

=head2 $perms->can_edit_templates

Returns true if the author can edit the blog's templates, false otherwise.

=head2 $perms->can_send_notifications

Returns true if the author can send messages to the notification list, false
otherwise.

=head2 $perms->can_edit_categories

Returns true if the author can edit the categories defined for the blog, false
otherwise.

=head2 $perms->can_edit_notifications

Returns true if the author can edit the notification list for the blog, false
otherwise.

=head2 $perms->can_edit_authors

Returns true if the author can edit author permissions for the blog, and add
new authors who have access to the blog; false otherwise.

Note: you should be very careful when giving this permission to authors,
because an author could easily then block your access to the blog.

=head2 $perms->can_edit_config

Returns true if the author can edit the blog configuration, false otherwise.
Note that this setting also controls whether the author can import entries
to the blog, and export entries from the blog.

=head1 DATA ACCESS METHODS

The I<MT::Comment> object holds the following pieces of data. These fields can
be accessed and set using the standard data access methods described in the
I<MT::Object> documentation.

=over 4

=item * id

The numeric ID of this permissions record.

=item * author_id

The numeric ID of the author associated with this permissions record.

=item * blog_id

The numeric ID of the blog associated with this permissions record.

=item * role_mask

The permissions bitmask. You should not access this value directly; instead
use the I<can_*> methods, above.

=item * entry_prefs

The setting of display fields of "edit entry" page.  The value
at author_id 0 means default setting of a blog.

=item * template_prefs

The setting of display  "edit template" page.  The value
at author_id 0 means default setting of a blog.

=back

=head1 DATA LOOKUP

In addition to numeric ID lookup, you can look up or sort records by any
combination of the following fields. See the I<load> documentation in
I<MT::Object> for more information.

=over 4

=item * blog_id

=item * author_id

=back

=head1 AUTHOR & COPYRIGHTS

Please see the I<MT> manpage for author, copyright, and license information.

=cut
