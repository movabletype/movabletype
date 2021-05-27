# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Comment;

use strict;
use warnings;
use base qw( MT::Object MT::Scorable );
use MT::Util qw( weaken );

sub JUNK ()     {-1}
sub NOT_JUNK () {1}

__PACKAGE__->install_properties(
    {   column_defs => {
            'id'            => 'integer not null auto_increment',
            'blog_id'       => 'integer not null',
            'entry_id'      => 'integer not null',
            'author'        => 'string(100)',
            'commenter_id'  => 'integer',
            'visible'       => 'boolean',
            'junk_status'   => 'smallint',
            'email'         => 'string(127)',
            'url'           => 'string(255)',
            'text'          => 'text',
            'ip'            => 'string(50)',
            'last_moved_on' => 'datetime not null',
            'junk_score'    => 'float',
            'junk_log'      => 'text',
            'parent_id'     => 'integer',
        },
        indexes => {
            entry_visible =>
                { columns => [ 'entry_id', 'visible', 'created_on' ], },
            author        => 1,
            email         => 1,
            commenter_id  => 1,
            last_moved_on => 1,  # used for junk expiration
                                 # for blog dashboard - visible comments count
            blog_visible_entry =>
                { columns => [ 'blog_id', 'visible', 'entry_id' ], },

            # For URL lookups to aid spam filtering
            blog_url => { columns => [ 'blog_id', 'visible', 'url' ], },
            blog_stat =>
                { columns => [ 'blog_id', 'junk_status', 'created_on' ], },
            blog_visible =>
                { columns => [ 'blog_id', 'visible', 'created_on', 'id' ], },
            dd_coment_vis_mod => { columns => [ 'visible', 'modified_on' ], },
            visible_date      => { columns => [ 'visible', 'created_on' ], },
            blog_ip_date => { columns => [ 'blog_id', 'ip', 'created_on' ], },
            blog_junk_stat =>
                { columns => [ 'blog_id', 'junk_status', 'last_moved_on' ], },
        },
        meta     => 1,
        defaults => {
            junk_status   => NOT_JUNK,
            last_moved_on => '20000101000000',
        },
        audit       => 1,
        datasource  => 'comment',
        primary_key => 'id',
    }
);

# Register Comment post-save callbacks for rebuild triggers
MT::Comment->add_callback(
    'post_save',
    10,
    MT->component('core'),
    sub {
        MT->model('rebuild_trigger')->runner( 'post_feedback_save_comment_pub', @_ );
    }
);

my %blocklists = ();

sub class_label {
    return MT->translate("Comment");
}

sub class_label_plural {
    return MT->translate("Comments");
}

sub is_junk {
    $_[0]->junk_status == JUNK;
}

sub is_not_junk {
    $_[0]->junk_status != JUNK;
}

sub is_not_blocked {
    my ( $eh, $cmt ) = @_;

    # other URI schemes?
    require MT::Util;
    my @hosts = MT::Util::extract_urls( $cmt->text );

    my $not_blocked = 1;
    my $blog_id     = $cmt->blog_id;
    if ( !$blocklists{$blog_id} ) {
        require MT::Blocklist;
        my @blocks = MT::Blocklist->load( { blog_id => $blog_id } );
        $blocklists{$blog_id} = [@blocks];
    }
    if ( @{ $blocklists{$blog_id} } ) {
        for my $h (@hosts) {
            for my $b ( @{ $blocklists{$blog_id} } ) {
                $not_blocked = 0 if ( $h eq $b->text );
            }
        }
    }
    $not_blocked;
}

sub next {
    my $comment = shift;
    my ($publish_only) = @_;
    $publish_only = $publish_only ? { 'visible' => 1 } : {};
    $comment->_nextprev( 'next', $publish_only );
}

sub previous {
    my $comment = shift;
    my ($publish_only) = @_;
    $publish_only = $publish_only ? { 'visible' => 1 } : {};
    $comment->_nextprev( 'previous', $publish_only );
}

sub _nextprev {
    my $obj   = shift;
    my $class = ref($obj);
    my ( $direction, $terms ) = @_;
    return undef unless ( $direction eq 'next' || $direction eq 'previous' );
    my $next = $direction eq 'next';

    my $label = '__' . $direction;
    return $obj->{$label} if $obj->{$label};

    my $o = $obj->nextprev(
        direction => $direction,
        terms     => { blog_id => $obj->blog_id, %$terms },
        by        => 'created_on',
    );
    weaken( $o->{$label} = $o ) if $o;
    return $o;
}

sub entry {
    my ($comment) = @_;
    my $entry = $comment->{__entry};
    unless ($entry) {
        my $entry_id = $comment->entry_id;
        return undef unless $entry_id;
        require MT::Entry;
        $entry = MT::Entry->load($entry_id)
            or return $comment->error(
            MT->translate(
                "Loading entry '[_1]' failed: [_2]", $entry_id,
                MT::Entry->errstr
            )
            );
        $comment->{__entry} = $entry;
    }
    return $entry;
}

sub blog {
    my ($comment) = @_;
    my $blog = $comment->{__blog};
    unless ($blog) {
        my $blog_id = $comment->blog_id;
        require MT::Blog;
        $blog = MT::Blog->load($blog_id)
            or return $comment->error(
            MT->translate(
                "Loading blog '[_1]' failed: [_2]", $blog_id,
                MT::Blog->errstr
            )
            );
        $comment->{__blog} = $blog;
    }
    return $blog;
}

sub junk {
    my ($comment) = @_;
    if ( ( $comment->junk_status || 0 ) != JUNK ) {
        require MT::Util;
        my @ts = MT::Util::offset_time_list( time, $comment->blog_id );
        my $ts = sprintf(
            "%04d%02d%02d%02d%02d%02d",
            $ts[5] + 1900,
            $ts[4] + 1,
            @ts[ 3, 2, 1, 0 ]
        );
        $comment->last_moved_on($ts);
    }
    $comment->junk_status(JUNK);
    $comment->visible(0);
}

sub moderate {
    my ($comment) = @_;
    $comment->visible(0);
    $comment->junk_status(NOT_JUNK);
}

sub approve {
    my ($comment) = @_;
    $comment->visible(1);
    $comment->junk_status(NOT_JUNK);
}

{
    no warnings 'once';
    *publish = \&approve;
}

sub author {
    my $comment = shift;
    if ( !@_ && $comment->commenter_id ) {
        require MT::Author;
        if ( my $auth = MT::Author->load( $comment->commenter_id ) ) {
            return $auth->nickname;
        }
    }
    return $comment->column( 'author', @_ );
}

sub all_text {
    my $this = shift;
    my $text = $this->column('author') || '';
    $text .= "\n" . ( $this->column('email') || '' );
    $text .= "\n" . ( $this->column('url')   || '' );
    $text .= "\n" . ( $this->column('text')  || '' );
    $text;
}

sub permalink {
    my $self = shift;

    my $id    = $self->id;
    my $entry = $self->entry;
    if ( $id && $entry ) {
        my $archive_url = $entry->archive_url;
        $archive_url = '' unless defined $archive_url;
        $archive_url . '#comment-' . $id;
    }
    else {
        '#';
    }
}

sub is_published {
    return $_[0]->visible && !$_[0]->is_junk;
}

sub is_moderated {
    return !$_[0]->visible() && !$_[0]->is_junk();
}

sub log {

    # TBD: pre-load __junk_log when loading the comment
    my $comment = shift;
    push @{ $comment->{__junk_log} }, @_;
}

sub save {
    my $comment = shift;
    $comment->junk_log( join "\n", @{ $comment->{__junk_log} } )
        if ref $comment->{__junk_log} eq 'ARRAY';
    my $ret = $comment->SUPER::save();
    delete $comment->{__changed}{visibility} if $ret;
    return $ret;
}

sub to_hash {
    my $cmt  = shift;
    my $hash = $cmt->SUPER::to_hash();

    $hash->{'comment.created_on_iso'}
        = sub { MT::Util::ts2iso( $cmt->blog, $cmt->created_on ) };
    $hash->{'comment.modified_on_iso'}
        = sub { MT::Util::ts2iso( $cmt->blog, $cmt->modified_on ) };
    if ( my $blog = $cmt->blog ) {
        $hash->{'comment.text_html'} = sub {
            my $txt = defined $cmt->text ? $cmt->text : '';
            require MT::Util;
            $txt = MT::Util::munge_comment( $txt, $blog );
            my $convert_breaks = $blog->convert_paras_comments;
            $txt
                = $convert_breaks
                ? MT->apply_text_filters( $txt, $blog->comment_text_filters )
                : $txt;
            my $sanitize_spec = $blog->sanitize_spec
                || MT->config->GlobalSanitizeSpec;
            require MT::Sanitize;
            MT::Sanitize->sanitize( $txt, $sanitize_spec );
            }
    }
    if ( my $entry = $cmt->entry ) {
        my $entry_hash = $entry->to_hash;
        $hash->{"comment.$_"} = $entry_hash->{$_} foreach keys %$entry_hash;
    }
    if ( $cmt->commenter_id ) {

        # commenter record exists... populate it
        require MT::Author;
        if ( my $auth = MT::Author->load( $cmt->commenter_id ) ) {
            my $auth_hash = $auth->to_hash;
            $hash->{"comment.$_"} = $auth_hash->{$_} foreach keys %$auth_hash;
        }
    }

    $hash;
}

sub visible {
    my $comment = shift;
    return $comment->column('visible') unless @_;

    ## Note transitions in visibility in the object, so that
    ## other methods can act appropriately.
    my $was_visible = $comment->column('visible') || 0;
    my $is_visible = shift || 0;

    my $vis_delta = 0;
    if ( !$was_visible && $is_visible ) {
        $vis_delta = 1;
    }
    elsif ( $was_visible && !$is_visible ) {
        $vis_delta = -1;
    }
    $comment->{__changed}{visibility} ||= 0;
    $comment->{__changed}{visibility} += $vis_delta;

    return $comment->column( 'visible', $is_visible );
}

sub parent {
    my $comment = shift;
    $comment->cache_property(
        'parent',
        sub {
            if ( $comment->parent_id ) {
                return MT::Comment->load( $comment->parent_id );
            }
        }
    );
}

sub get_status_text {
    my $self = shift;
          $self->is_published ? 'Approved'
        : $self->is_moderated ? 'Pending'
        :                       'Spam';
}

sub set_status_by_text {
    my $self   = shift;
    my $status = lc $_[0];
    if ( $status eq 'approved' ) {
        $self->approve;
    }
    elsif ( $status eq 'pending' ) {
        $self->moderate;
    }
    else {
        $self->junk;
    }
}

# Reset parent_id of child comments after removing parent comment.
__PACKAGE__->add_trigger( 'post_remove', \&_update_parent_id );

sub _update_parent_id {
    my $comment = shift;
    my @children = MT::Comment->load( { parent_id => $comment->id } );
    for my $c (@children) {
        $c->parent_id(undef);
        $c->save;
    }
}

1;
__END__

=head1 NAME

MT::Comment - Movable Type comment record

=head1 SYNOPSIS

    use MT::Comment;
    my $comment = MT::Comment->new;
    $comment->blog_id($entry->blog_id);
    $comment->entry_id($entry->id);
    $comment->author('Foo');
    $comment->text('This is a comment.');
    $comment->save
        or die $comment->errstr;

=head1 DESCRIPTION

An I<MT::Comment> object represents a comment in the Movable Type system. It
contains all of the metadata about the comment (author name, email address,
homepage URL, IP address, etc.), as well as the actual body of the comment.

=head1 USAGE

As a subclass of I<MT::Object>, I<MT::Comment> inherits all of the
data-management and -storage methods from that class; thus you should look
at the I<MT::Object> documentation for details about creating a new object,
loading an existing object, saving an object, etc.

=head1 DATA ACCESS METHODS

The I<MT::Comment> object holds the following pieces of data. These fields can
be accessed and set using the standard data access methods described in the
I<MT::Object> documentation.

=over 4

=item * id

The numeric ID of the comment.

=item * blog_id

The numeric ID of the blog in which the comment is found.

=item * entry_id

The numeric ID of the entry on which the comment has been made.

=item * author

The name of the author of the comment.

=item * commenter_id

The author_id for the commenter; this will only be defined if the
commenter is registered, which is only required if the blog config
option allow_unreg_comments is false.

=item * ip

The IP address of the author of the comment.

=item * email

The email address of the author of the comment.

=item * url

The URL of the author of the comment.

=item * text

The body of the comment.

=item * visible

Returns a true value if the comment should be displayed. Comments can
be hidden if comment registration is required and the commenter is
pending approval.

=item * created_on

The timestamp denoting when the comment record was created, in the format
C<YYYYMMDDHHMMSS>. Note that the timestamp has already been adjusted for the
selected timezone.

=item * modified_on

The timestamp denoting when the comment record was last modified, in the
format C<YYYYMMDDHHMMSS>. Note that the timestamp has already been adjusted
for the selected timezone.

=back

=head1 DATA LOOKUP

In addition to numeric ID lookup, you can look up or sort records by any
combination of the following fields. See the I<load> documentation in
I<MT::Object> for more information.

=over 4

=item * created_on

=item * entry_id

=item * blog_id

=back

=head1 AUTHOR & COPYRIGHTS

Please see the I<MT> manpage for author, copyright, and license information.

=cut
