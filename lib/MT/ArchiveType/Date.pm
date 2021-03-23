# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::ArchiveType::Date;

use strict;
use warnings;
use base qw( MT::ArchiveType );

sub group_based {
    return 1;
}

sub dated_group_entries {
    my $obj = shift;
    my ( $ctx, $at, $ts, $limit ) = @_;
    my $blog = $ctx->stash('blog');
    my ( $start, $end );
    if ($ts) {
        ( $start, $end ) = $obj->date_range($ts);
        $ctx->{current_timestamp}     = $start;
        $ctx->{current_timestamp_end} = $end;
    }
    else {
        $start = $ctx->{current_timestamp};
        $end   = $ctx->{current_timestamp_end};
    }
    require MT::Entry;
    my @entries = MT::Entry->load(
        {   blog_id     => $blog->id,
            status      => MT::Entry::RELEASE(),
            authored_on => [ $start, $end ]
        },
        {   range_incl  => { authored_on => 1 },
            'sort'      => 'authored_on',
            'direction' => 'descend',
            ( $limit ? ( 'limit' => $limit ) : () ),
        }
    ) or return $ctx->error("Couldn't get $at archive list");
    \@entries;
}

sub dated_category_entries {
    my $obj = shift;
    my ( $ctx, $at, $cat, $ts ) = @_;

    my $blog = $ctx->stash('blog');
    my ( $start, $end );
    if ($ts) {
        ( $start, $end ) = $obj->date_range($ts);
    }
    else {
        $start = $ctx->{current_timestamp};
        $end   = $ctx->{current_timestamp_end};
    }
    my @entries = MT::Entry->load(
        {   blog_id     => $blog->id,
            status      => MT::Entry::RELEASE(),
            authored_on => [ $start, $end ]
        },
        {   range_incl => { authored_on => 1 },
            'join' =>
                [ 'MT::Placement', 'entry_id', { category_id => $cat->id } ],
            'sort'      => 'authored_on',
            'direction' => 'descend',
        }
    ) or return $ctx->error("Couldn't get $at archive list");
    \@entries;
}

sub dated_author_entries {
    my $obj = shift;
    my ( $ctx, $at, $author, $ts ) = @_;

    my $blog = $ctx->stash('blog');
    my ( $start, $end );
    if ($ts) {
        ( $start, $end ) = $obj->date_range($ts);
    }
    else {
        $start = $ctx->{current_timestamp};
        $end   = $ctx->{current_timestamp_end};
    }
    my @entries = MT::Entry->load(
        {   blog_id     => $blog->id,
            author_id   => $author->id,
            status      => MT::Entry::RELEASE(),
            authored_on => [ $start, $end ]
        },
        {   range_incl  => { authored_on => 1 },
            'sort'      => 'authored_on',
            'direction' => 'descend',
        }
    ) or return $ctx->error("Couldn't get $at archive list");
    \@entries;
}

sub get_entry {
    my $archiver = shift;
    my ( $ts, $blog_id, $order ) = @_;
    my ( $start, $end ) = $archiver->date_range($ts);
    if ( $order and $order eq 'previous' ) {
        $order = 'descend';
        $ts    = $start;
    }
    else {
        $order = 'ascend';
        $ts    = $end;
    }

    my $entry = MT->model('entry')->load(
        {   blog_id => $blog_id,
            status  => MT::Entry::RELEASE()
        },
        {   limit     => 1,
            'sort'    => 'authored_on',
            direction => $order,
            start_val => $ts
        }
    );
    $entry;
}

# get an entry in the next or previous archive for dated-based ArchiveType
sub next_archive_entry {
    $_[0]->adjacent_archive_entry( { %{ $_[1] }, order => 'next' } );
}

sub previous_archive_entry {
    $_[0]->adjacent_archive_entry( { %{ $_[1] }, order => 'previous' } );
}

sub adjacent_archive_entry {
    my $obj = shift;
    my ($param) = @_;

    my $order = ( $param->{order} eq 'previous' ) ? 'descend' : 'ascend';
    my ( $cat, $author );
    $cat    = $param->{category} if $obj->category_based;
    $author = $param->{author}   if $obj->author_based;

    my $ts      = $param->{ts};
    my $blog_id = $param->{blog_id}
        || ( $param->{blog} ? $param->{blog}->id : undef );

    # if $param->{entry} given, override $ts and $blog_id.
    if ( my $e = $param->{entry} ) {
        $ts      ||= $e->authored_on;
        $blog_id = $e->blog_id;
    }
    my ( $start, $end ) = $obj->date_range($ts);
    $ts = ( $order eq 'descend' ) ? $start : $end;

    require MT::Entry;
    require MT::Placement;
    my $entry = MT::Entry->load(
        {   status => MT::Entry::RELEASE(),
            $blog_id ? ( blog_id   => $blog_id )    : (),
            $author  ? ( author_id => $author->id ) : (),
        },
        {   limit     => 1,
            'sort'    => 'authored_on',
            direction => $order,
            start_val => $ts,
            $cat
            ? ( 'join' => [
                    'MT::Placement', 'entry_id',
                    { category_id => $cat->id }
                ]
                )
            : (),
        }
    );
    $entry;
}

sub archive_entries_count {
    my $obj = shift;
    my ( $blog, $at, $entry, $ts ) = @_;
    return $obj->SUPER::archive_entries_count(
        {   Blog        => $blog,
            ArchiveType => $at,
        }
    ) unless $entry;
    return $obj->SUPER::archive_entries_count(
        {   Blog        => $blog,
            ArchiveType => $at,
            Timestamp   => $ts || $entry->authored_on
        }
    );
}

sub does_publish_file {
    my $obj    = shift;
    my %params = %{ shift() };

    $obj->archive_entries_count( $params{Blog}, $params{ArchiveType},
        $params{Entry}, $params{Timestamp} );
}

1;
