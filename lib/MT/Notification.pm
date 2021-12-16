# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Notification;
use strict;
use warnings;

use MT::Blog;
use MT::Object;
@MT::Notification::ISA = qw( MT::Object );
__PACKAGE__->install_properties(
    {   column_defs => {
            'id'      => 'integer not null auto_increment',
            'blog_id' => 'integer not null',
            'name'    => 'string(50)',
            'email'   => 'string(75)',
            'url'     => 'string(255)',
        },
        indexes => {
            blog_id => 1,
            email   => 1,
        },
        child_of       => 'MT::Blog',
        datasource     => 'notification',
        audit          => 1,
        primary_key    => 'id',
        listing_screen => 1,
    }
);

sub class_label {
    MT->translate('Contact');
}

sub class_label_plural {
    MT->translate('Contacts');
}

sub list_props {
    return {
        email => {
            auto    => 1,
            label   => 'Email Address',
            display => 'force',
            order   => 100,
            html    => sub {
                my $prop = shift;
                my ( $obj, $app ) = @_;
                require MT::Util;
                my $email = MT::Util::encode_html( $obj->email );
                my $id    = $obj->id;
                my $title = MT->translate('Click to edit contact');
                return qq{
                    <a href="javascript:void(0)" title="$title" class="edit-link note-email-link start-edit" id="note-email-link-$id" data-id="$id">$email</a>
                    <span id="note-email-field-$id" style="display: none">
                    <input type="text" name="note-email-$id" id="note-email-$id" class="form-control text required email" value="$email" />
                    </span>
                };
            },
        },
        url => {
            auto    => 1,
            label   => 'URL',
            display => 'force',
            order   => 200,
            html    => sub {
                my $prop = shift;
                my ( $obj, $app ) = @_;
                require MT::Util;
                my $url   = MT::Util::encode_html( $obj->url );
                my $id    = $obj->id;
                my $title = MT->translate('Click to edit contact');
                my $save_changes_label = MT->translate('Save Changes');
                my $save_label         = MT->translate('Save');
                my $cancel_label       = MT->translate('Cancel');
                my $view_img
                    = MT->static_path . 'images/status_icons/view.gif';
                return qq{
                    <span id="note-url-link-$id" class="view-link"><a href="javascript:void(0)" class="edit-link start-edit" title="$title" data-id="$id">$url</a>}
                    . (
                    $url
                    ? qq{&nbsp;<a href="$url" target="_blank">                        <img alt="View" src="$view_img" loading="lazy" decoding="async" /></a>}
                    : ''
                    )
                    . qq{</span>
                    <span id="note-url-field-$id" style="display: none">
                      <input type="text" name="note-url-$id" id="note-url-$id" class="form-control text url" value="$url" />
                      <span class="d-block float-right my-3">
                        <a href="javascript:void(0)" class="mr-3 btn btn-secondary submit-note" data-id="$id">$save_label</button>
                        <a href="javascript:void(0)" class="cancel-edit" data-id="$id">$cancel_label</button>
                      </span>
                    </span>
                };
            },
        },
        blog_name => {
            base  => '__common.blog_name',
            order => 300,
        },
        created_on => {
            base    => '__virtual.created_on',
            display => 'default',
            order   => 400,
        },
        modified_on => {
            base    => '__virtual.modified_on',
            display => 'none',
        },
    };
}

1;
__END__

=head1 NAME

MT::Notification - Movable Type notification list record

=head1 SYNOPSIS

    use MT::Notification;
    my $note = MT::Notification->new;
    $note->blog_id($blog->id);
    $note->email($email_address);
    $note->save
        or die $note->errstr;

=head1 DESCRIPTION

An I<MT::Notification> object represents an email address in the notification
list for your blog in the Movable Type system. It contains the email address,
as well as some metadata about the record.

=head1 USAGE

As a subclass of I<MT::Object>, I<MT::Notification> inherits all of the
data-management and -storage methods from that class; thus you should look
at the I<MT::Object> documentation for details about creating a new object,
loading an existing object, saving an object, etc.

=head1 METHODS

=head2 MT::Notification->class_label

Returns the localized descriptive name for this class.

=head2 MT::Notification->class_label_plural

Returns the localized, plural descriptive name for this class.

=head2 MT::Notification->list_props

Returns the list_properties registry of this class.

=head1 DATA ACCESS METHODS

The I<MT::Notification> object holds the following pieces of data. These
fields can be accessed and set using the standard data access methods
described in the I<MT::Object> documentation.

=over 4

=item * id

The numeric ID of the notification record.

=item * blog_id

The numeric ID of the blog to which this notification record belongs.

=item * email

The email address of the user in the notification record.

=item * name

The name of the user in the notification record.

=item * url

The homepage URL of the user in the notification record.

=item * created_on

The timestamp denoting when the notification record was created, in the format
C<YYYYMMDDHHMMSS>. Note that the timestamp has already been adjusted for the
selected timezone.

=item * modified_on

The timestamp denoting when the notification record was last modified, in the
format C<YYYYMMDDHHMMSS>. Note that the timestamp has already been adjusted
for the selected timezone.

=back

=head1 DATA LOOKUP

In addition to numeric ID lookup, you can look up or sort records by any
combination of the following fields. See the I<load> documentation in
I<MT::Object> for more information.

=over 4

=item * blog_id

=back

=head1 AUTHOR & COPYRIGHTS

Please see the I<MT> manpage for author, copyright, and license information.

=cut
