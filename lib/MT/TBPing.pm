# Copyright 2001-2006 Six Apart. This code cannot be redistributed without
# permission from www.sixapart.com.  For more information, consult your
# Movable Type license.
#
# $Id$

package MT::TBPing;
use strict;

use constant JUNK => -1;
use constant NOT_JUNK => 1;
use MT::Trackback;

use MT::Object;
@MT::TBPing::ISA = qw( MT::Object );
__PACKAGE__->install_properties({
    column_defs => {
        'id' => 'integer not null auto_increment',
        'blog_id' => 'integer not null',
        'tb_id' => 'integer not null',
        'title' => 'string(255)',
        'excerpt' => 'text',
        'source_url' => 'string(255)',
        'ip' => 'string(15) not null',
        'blog_name' => 'string(255)',
        'visible' => 'boolean',
        'junk_status' => 'smallint not null',
        'last_moved_on' => 'datetime not null',
        'junk_score' => 'float',
        'junk_log' => 'text',
    },
    indexes => {
        created_on => 1,
        blog_id => 1,
        tb_id => 1,
        ip => 1,
        visible => 1,
        junk_status => 1,
        last_moved_on => 1,
        junk_score => 1,
    },
    defaults => {
        junk_status => 0,
        last_moved_on => '20000101000000',
    },
    audit => 1,
    datasource => 'tbping',
    primary_key => 'id',
});

sub is_junk {
    $_[0]->junk_status == JUNK;
}
sub is_not_junk {
    $_[0]->junk_status != JUNK;
}

sub is_published {
    return $_[0]->visible && !$_[0]->is_junk;
}

sub is_moderated {
    return !$_[0]->visible() && !$_[0]->is_junk();
}

sub blog {
    my ($ping) = @_;
    my $blog = $ping->{__blog};
    unless ($blog) {
        my $blog_id = $ping->blog_id;
        require MT::Blog;
        $blog = MT::Blog->load($blog_id) or
            return $ping->error(MT->translate(
                "Load of blog '[_1]' failed: [_2]", $blog_id, MT::Blog->errstr));   
        $ping->{__blog} = $blog;
    }
    return $blog;
}

sub parent {
    my ($ping) = @_;
    require MT::Trackback;
    my $tb = MT::Trackback->load($ping->tb_id);
    if ($tb->entry_id) {
        return MT::Entry->load($tb->entry_id);
    } else {
        return MT::Category->load($tb->category_id);
    }
}

sub parent_id {
    my ($ping) = @_;
    require MT::Trackback;
    my $tb = MT::Trackback->load($ping->tb_id);
    if ($tb->entry_id) {
        return ('MT::Entry', $tb->entry_id);
    } else {
        return ('MT::Category', $tb->category_id);
    }
}

sub next {
    my $ping = shift;
    my($publish_only) = @_;
    $publish_only = $publish_only ? {'visible' => 1} : {};
    $ping->_nextprev('next', $publish_only);
}

sub previous {
    my $ping = shift;
    my($publish_only) = @_;
    $publish_only = $publish_only ? {'visible' => 1} : {};
    $ping->_nextprev('previous', $publish_only);
}

sub _nextprev {
    my $obj = shift;
    my $class = ref($obj);
    my ($direction, $publish_only) = @_;
    return undef unless ($direction eq 'next' || $direction eq 'previous');
    my $next = $direction eq 'next';

    my $label = '__' . $direction;
    return $obj->{$label} if $obj->{$label};

    # Selecting the adjacent object can be tricky since timestamps
    # are not necessarily unique for entries. If we find that the
    # next/previous object has a matching timestamp, keep selecting entries
    # to select all entries with the same timestamp, then compare them using
    # id as a secondary sort column.

    my ($id, $ts) = ($obj->id, $obj->created_on);
    my $iter = $class->load_iter({
        blog_id => $obj->blog_id,
        created_on => ($next ? [ $ts, undef ] : [ undef, $ts ]),
        %{$publish_only}
    }, {
        'sort' => 'created_on',
        'direction' => $next ? 'ascend' : 'descend',
        'range_incl' => { 'created_on' => 1 },
    });

    # This selection should always succeed, but handle situation if
    # it fails by returning undef.
    return unless $iter;

    # The 'same' array will hold any entries that have matching
    # timestamps; we will then sort those by id to find the correct
    # adjacent object.
    my @same;
    while (my $e = $iter->()) {
        # Don't consider the object that is 'current'
        next if $e->id == $id;
        my $e_ts = $e->created_on;
        if ($e_ts eq $ts) {
            # An object with the same timestamp should only be
            # considered if the id is in the scope we're looking for
            # (greater than for the 'next' object; less than for
            # the 'previous' object).
            push @same, $e
                if $next && $e->id > $id or !$next && $e->id < $id;
        } else {
            # We found an object with a timestamp different than
            # the 'current' object.
            if (!@same) {
                push @same, $e;
                # We should check to see if this new timestamped object also
                # has entries adjacent to _it_ that have the same timestamp.
                while (my $e = $iter->()) {
                    push(@same, $e), next if $e->created_on eq $e_ts;
                    $iter->('finish'), last;
                }
            } else {
                $iter->('finish');
            }
            return $obj->{$label} = $e unless @same;
            last;
        }
    }
    if (@same) {
        # If we only have 1 element in @same, return that.
        return $obj->{$label} = $same[0] if @same == 1;
        # Sort remaining elements in @same by id.
        @same = sort { $a->id <=> $b->id } @same;
        # Return front of list (smallest id) if selecting 'next'
        # object. Return tail of list (largest id) if selection 'previous'.
        return $obj->{$label} = $same[$next ? 0 : $#same];
    }
    return;
}

sub junk {
    my $ping = shift;
    if (($ping->junk_status || 0) != JUNK) {
        require MT::Util;
        my @ts = MT::Util::offset_time_list(time, $ping->blog_id);
        my $ts = sprintf("%04d%02d%02d%02d%02d%02d",
                         $ts[5]+1900, $ts[4]+1, @ts[3,2,1,0]);
        $ping->last_moved_on($ts);
    }
    $ping->junk_status(JUNK);
    $ping->visible(0);
}

sub moderate {
    my $ping = shift;
    $ping->visible(0);
}

sub approve {
    my $ping = shift;
    $ping->visible(1);
    $ping->junk_status(NOT_JUNK);
}

sub all_text {
    my $this = shift;
    my $text = $this->column('blog_name') || '';
    $text .= "\n" . ($this->column('email') || '');
    $text .= "\n" . ($this->column('source_url') || '');
    $text .= "\n" . ($this->column('excerpt') || '');
    $text;
}

sub to_hash {
    my $ping = shift;
    my $hash = $ping->SUPER::to_hash(@_);
    require MT::Sanitize;
    $hash->{tbping_excerpt} = MT::Sanitize->sanitize($ping->excerpt || '');
    $hash->{'tbping.created_on_iso'} = sub { MT::Util::ts2iso(undef, $ping->created_on) };
    $hash->{'tbping.modified_on_iso'} = sub { MT::Util::ts2iso(undef, $ping->modified_on) };
    $hash;
}

1;
__END__

=head1 NAME

MT::TBPing - Movable Type TrackBack Ping record

=head1 SYNOPSIS

    use MT::TBPing;
    my $ping = MT::TBPing->new;
    $ping->blog_id($tb->blog_id);
    $ping->tb_id($tb->id);
    $ping->title('Foo');
    $ping->excerpt('This is from a TrackBack ping.');
    $ping->source_url('http://www.foo.com/bar');
    $ping->save
        or die $ping->errstr;

=head1 DESCRIPTION

An I<MT::TBPing> object represents a TrackBack ping in the Movable Type system.
It contains all of the metadata about the ping (title, excerpt, URL, etc).

=head1 USAGE

As a subclass of I<MT::Object>, I<MT::TBPing> inherits all of the
data-management and -storage methods from that class; thus you should look
at the I<MT::Object> documentation for details about creating a new object,
loading an existing object, saving an object, etc.

=head1 DATA ACCESS METHODS

The I<MT::TBPing> object holds the following pieces of data. These fields can
be accessed and set using the standard data access methods described in the
I<MT::Object> documentation.

=over 4

=item * id

The numeric ID of the ping.

=item * blog_id

The numeric ID of the blog in which the ping is found.

=item * tb_id

The numeric ID of the TrackBack record (I<MT::Trackback> object) to which
the ping was sent.

=item * title

The title of the ping item.

=item * ip

The IP address of the server that sent the ping.

=item * excerpt

The excerpt of the ping item.

=item * source_url

The URL of the item pointed to by the ping.

=item * blog_name

The name of the blog on which the original item was posted.

=item * created_on

The timestamp denoting when the ping record was created, in the format
C<YYYYMMDDHHMMSS>. Note that the timestamp has already been adjusted for the
selected timezone.

=item * modified_on

The timestamp denoting when the ping record was last modified, in the
format C<YYYYMMDDHHMMSS>. Note that the timestamp has already been adjusted
for the selected timezone.

=back

=head1 DATA LOOKUP

In addition to numeric ID lookup, you can look up or sort records by any
combination of the following fields. See the I<load> documentation in
I<MT::Object> for more information.

=over 4

=item * created_on

=item * tb_id

=item * blog_id

=item * ip

=back

=head1 AUTHOR & COPYRIGHTS

Please see the I<MT> manpage for author, copyright, and license information.

=cut
