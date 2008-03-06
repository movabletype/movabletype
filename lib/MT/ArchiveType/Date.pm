package MT::ArchiveType::Date;

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
        my $archiver = MT->publisher->archiver($at);
        if ( $archiver ) {
            ( $start, $end ) = $archiver->date_range($ts);
            $ctx->{current_timestamp}     = $start;
            $ctx->{current_timestamp_end} = $end;
        }
    }
    else {
        $start = $ctx->{current_timestamp};
        $end   = $ctx->{current_timestamp_end};
    }
    require MT::Entry;
    my @entries = MT::Entry->load(
        {
            blog_id     => $blog->id,
            status      => MT::Entry::RELEASE(),
            authored_on => [ $start, $end ]
        },
        {
            range_incl  => { authored_on => 1 },
            'sort' => 'authored_on',
            'direction' => 'descend',
            ( $limit ? ( 'limit' => $limit ) : () ),
        }
    ) or return $ctx->error("Couldn't get $at archive list");
    \@entries;
}

sub dated_category_entries {
    my $obj = shift;
    my ( $ctx, $at, $cat, $ts ) = @_;

    my $blog     = $ctx->stash('blog');
    my $archiver = MT->publisher->archiver($at);
    my ( $start, $end );
    if ($ts) {
        ( $start, $end ) = $archiver->date_range($ts);
    }
    else {
        $start = $ctx->{current_timestamp};
        $end   = $ctx->{current_timestamp_end};
    }
    my @entries = MT::Entry->load(
        {
            blog_id     => $blog->id,
            status      => MT::Entry::RELEASE(),
            authored_on => [ $start, $end ]
        },
        {
            range => { authored_on => 1 },
            'join' =>
              [ 'MT::Placement', 'entry_id', { category_id => $cat->id } ],
            'sort' => 'authored_on',
            'direction' => 'descend',
        }
    ) or return $ctx->error("Couldn't get $at archive list");
    \@entries;
}

sub dated_author_entries {
    my $obj = shift;
    my ( $ctx, $at, $author, $ts ) = @_;

    my $blog     = $ctx->stash('blog');
    my $archiver = MT->publisher->archiver($at);
    my ( $start, $end );
    if ($ts) {
        ( $start, $end ) = $archiver->date_range->($ts);
    }
    else {
        $start = $ctx->{current_timestamp};
        $end   = $ctx->{current_timestamp_end};
    }
    my @entries = MT::Entry->load(
        {
            blog_id     => $blog->id,
            author_id   => $author->id,
            status      => MT::Entry::RELEASE(),
            authored_on => [ $start, $end ]
        },
        {
            range => { authored_on => 1 },
            'sort' => 'authored_on',
            'direction' => 'descend',
        }
    ) or return $ctx->error("Couldn't get $at archive list");
    \@entries;
}

1;
