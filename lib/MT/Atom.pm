# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Atom;
use strict;
use warnings;

package MT::Atom::Entry;
use base qw( XML::Atom::Entry );

$XML::Atom::ForceUnicode = 1;

my $ns_prefix;

sub new {
    my $class = shift;
    my (%param) = @_;
    $ns_prefix = delete $param{_prefix} if $param{_prefix};
    $class->SUPER::new(@_);
}

sub element_name { $ns_prefix ? $ns_prefix . ":entry" : 'entry' }

sub _create_issued {
    my ( $ts, $blog ) = @_;
    my @co_list = unpack 'A4A2A2A2A2A2', $ts;
    my $co = sprintf "%04d-%02d-%02dT%02d:%02d:%02d", @co_list;
    my $epoch = Time::Local::timegm(
        $co_list[5], $co_list[4],     $co_list[3],
        $co_list[2], $co_list[1] - 1, $co_list[0]
    );
    my $so = $blog->server_offset;
    $so += 1 if ( localtime $epoch )[8];
    $so = sprintf( "%s%02d:%02d",
        $so < 0 ? '-' : '+',
        abs( int $so ),
        abs( $so - int $so ) * 60 );
    $co .= $so;
}

sub new_with_entry {
    my $class = shift;
    my ( $entry, %param ) = @_;
    my $rfc_compat = $param{Version} && $param{Version} eq '1';

    my $atom = $class->new(%param);
    $atom->title( $entry->title );
    $atom->summary( $entry->excerpt );
    $atom->content( $entry->text );

    # Old Atom API gets application/xhtml+xml for compatibility -- but why
    # do we say it's that when all we're guaranteed is it's an opaque blob
    # of text? So use 'html' for new RFC compatible output.
    # XML::Atom::Content intelligently determines content-type for rfc compat.
    unless ($rfc_compat) {
        $atom->content->type('application/xhtml+xml');
    }

    my $mt_author = MT::Author->load( $entry->author_id )
        or return undef;
    my $atom_author = new XML::Atom::Person(%param);
    $atom_author->name( $mt_author->nickname );
    $atom_author->email( $mt_author->email ) if $mt_author->email;
    my $author_url_field = $rfc_compat ? 'uri' : 'url';
    $atom_author->$author_url_field( $mt_author->url ) if $mt_author->url;
    $atom->author($atom_author);

    for my $cat ( @{ $entry->categories } ) {
        my $atom_cat = XML::Atom::Category->new(%param);
        $atom_cat->term( $cat->label );
        $atom->add_category($atom_cat);
    }

    my $blog = MT::Blog->load( $entry->blog_id )
        or return undef;
    my $co = _create_issued( $entry->authored_on, $blog );
    $atom->issued($co);
    my $upd = $entry->modified_on;
    if ($upd) {
        $atom->updated( _create_issued( $upd, $blog ) );
    }
    else {
        $atom->updated($co);
    }
    $atom->add_link(
        {   rel  => 'alternate',
            type => 'text/html',
            href => $entry->permalink
        }
    );
    my ($host) = $blog->site_url =~ m!^https?://([^/:]+)(:\d+)?/!;

    unless ( $entry->atom_id ) {

        # atom_id is not there - probably because
        # the entry is in HOLD state
        $entry->atom_id( $entry->make_atom_id() );

        # call update directly because MT::Entry::save
        # is overkill for the purpose.
        $entry->update if $entry->atom_id();
    }

    $atom->id( $entry->atom_id );

    #$atom->draft('true') if $entry->status != MT::Entry::RELEASE();

    $atom;
}

sub new_with_asset {
    my $class = shift;
    my ( $asset, %param ) = @_;
    my $atom = $class->new(%param);
    $atom->title( $asset->label );
    $atom->summary( $asset->description );
    my $blog = MT::Blog->load( $asset->blog_id )
        or return undef;
    $atom->issued( _create_issued( $asset->created_on, $blog ) );
    $atom->add_link(
        {   rel   => 'alternate',
            type  => $asset->mime_type,
            href  => $asset->url,
            title => $asset->label
        }
    );
    my ($host) = $blog->site_url =~ m!^https?://([^/:]+)(:\d+)?/!;
    $atom->id( 'tag:' . $host . ':asset-' . $asset->id );
    return $atom;
}

sub new_with_comment {
    my $class = shift;
    my ( $comment, %param ) = @_;
    my $rfc_compat = $param{Version} && $param{Version} eq '1';

    my $entry = $comment->entry;
    return unless $entry;
    my $blog = $comment->blog;
    return unless $blog;

    my $atom = $class->new(%param);
    $atom->title( $entry->title );
    $atom->content( $comment->text );

    # Old Atom API gets application/xhtml+xml for compatibility -- but why
    # do we say it's that when all we're guaranteed is it's an opaque blob
    # of text? So use 'html' for new RFC compatible output.
    # XML::Atom::Content intelligently determines content-type for rfc compat.
    unless ($rfc_compat) {
        $atom->content->type('application/xhtml+xml');
    }

    my $atom_author = new XML::Atom::Person(%param);
    $atom_author->name( $comment->author );
    $atom_author->email( $comment->email ) if $comment->email;
    my $author_url_field = $rfc_compat ? 'uri' : 'url';
    $atom_author->$author_url_field( $comment->url ) if $comment->url;
    $atom->author($atom_author);

    my $co = _create_issued( $comment->created_on, $blog );
    $atom->issued($co);
    my $upd = $comment->modified_on;
    if ($upd) {
        $atom->updated( _create_issued( $upd, $blog ) );
    }
    else {
        $atom->updated($co);
    }
    $atom->add_link(
        {   rel  => 'alternate',
            type => 'text/html',
            href => $entry->archive_url . '#comment-' . $comment->id
        }
    );
    my ($host) = $blog->site_url =~ m!^https?://([^/:]+)(:\d+)?/!;

    $atom->id( $entry->atom_id . '/' . $comment->id );
    $atom;
}

1;
__END__

=head1 NAME

MT::Atom::Entry - A single record in the MT::AtomServer's reply

=head1 SYNOPSIS

    use MT::Atom;
    
    $atom = MT::Atom::Entry->new_from_comment($comment);

=head1 DESCRIPTION

This module represent a single record in reply to an Atom request. 
this record can be a blog entry, asset or comment. 

Subclass of L<XML::Atom::Entry>

=head1 METHODS

=head2 MT::Atom::Entry->new_with_entry( $entry, %param )

An Atom record represents an entry. includes info about the author
and categories of this entry. $entry should be a MT::Entry object,
and %params are sent to any XML::Atom object that is created.

=head2 MT::Atom::Entry->new_with_asset( $asset, %param )

An Atom record represents an asset - that is just an URL and mime_type.
$asset should be a MT::Asset object,
and %params are sent to any XML::Atom object that is created.

=head2 MT::Atom::Entry->new_with_comment( $comment, %param )

An Atom record represents an entry. includes info about the author. 
$comment should be a MT::Comment object,
and %params are sent to any XML::Atom object that is created.

=head2 MT::Atom::Entry::_create_issued( $ts, $blog )

Create a time stamp for usage in Atom reply. $ts should be a string 
in the format "YYYYMMDDHHMMSS", and $blog is a MT::Blog object

=head1 AUTHOR & COPYRIGHT

Please see L<MT/AUTHOR & COPYRIGHT>.

=cut
