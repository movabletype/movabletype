# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::ArchiveType::AuthorYearly;

use strict;
use warnings;
use base qw( MT::ArchiveType::Author MT::ArchiveType::Yearly );
use MT::Util qw( dirify start_end_year );

sub name {
    return 'Author-Yearly';
}

sub archive_label {
    return MT->translate('AUTHOR-YEARLY_ADV');
}

sub order {
    return 110;
}

sub default_archive_templates {
    return [
        {   label    => 'author/author-basename/yyyy/index.html',
            template => 'author/%-a/%y/%f',
            default  => 1
        },
        {   label    => 'author/author_basename/yyyy/index.html',
            template => 'author/%a/%y/%f'
        },
    ];
}

sub dynamic_template {
    return 'author/<$MTEntryAuthorID$>/<$MTArchiveDate format="%Y"$>';
}

sub template_params {
    return {
        archive_class         => "author-yearly-archive",
        author_yearly_archive => 1,
        archive_template      => 1,
        archive_listing       => 1,
        datebased_archive     => 1,
        author_based_archive  => 1,
    };
}

sub archive_title {
    my $obj = shift;
    my ( $ctx, $entry_or_ts ) = @_;
    my $stamp = ref $entry_or_ts ? $entry_or_ts->authored_on : $entry_or_ts;
    my $start = start_end_year($stamp);
    my $year  = MT::Template::Context::_hdlr_date( $ctx,
        { ts => $start, 'format' => "%Y" } );
    my $lang = lc MT->current_language || 'en_us';
    $lang = 'ja' if lc($lang) eq 'jp';
    my $author = $obj->display_name($ctx);

    sprintf( "%s%s%s", $author, $year, ( $lang eq 'ja' ? '&#24180;' : '' ) );
}

sub archive_file {
    my $obj = shift;
    my ( $ctx, %param ) = @_;
    my $timestamp = $param{Timestamp};
    my $file_tmpl = $param{Template};
    my $author    = $ctx->{__stash}{author};
    my $entry     = $ctx->{__stash}{entry};
    my $file;
    my $this_author = $author ? $author : ( $entry ? $entry->author : undef );
    return "" unless $this_author;

    if ( !$file_tmpl ) {
        return "" unless $this_author;
        my $name  = $this_author->basename;
        my $start = start_end_year($timestamp);
        my ($year) = unpack 'A4', $start;
        $file = sprintf( "author/%s/%04d/index", $name, $year );
    }
    else {
        ( $ctx->{current_timestamp}, $ctx->{current_timestamp_end} )
            = start_end_year($timestamp);
    }
    $file;
}

sub archive_group_iter {
    my $obj = shift;
    my ( $ctx, $args ) = @_;
    my $blog = $ctx->stash('blog');
    my $sort_order
        = ( $args->{sort_order} || '' ) eq 'ascend' ? 'ascend' : 'descend';
    my $auth_order = $args->{sort_order} ? $args->{sort_order} : 'ascend';
    my $order = ( $sort_order eq 'ascend' ) ? 'asc' : 'desc';
    my $limit = exists $args->{lastn} ? delete $args->{lastn} : undef;

    my $tmpl  = $ctx->stash('template');
    my @data  = ();
    my $count = 0;

    # my $at       = $ctx->{archive_type};
    # my $archiver = MT->publisher->archiver($at);
    my $author;

    # if (($tmpl && $tmpl->type ne 'index') &&
    #     ($archiver && $archiver->author_based))
    # {
    $author = $ctx->stash('author');

    # }

    require MT::Entry;
    my $loop_sub = sub {
        my $auth       = shift;
        my $count_iter = MT::Entry->count_group_by(
            {   blog_id   => $blog->id,
                author_id => $auth->id,
                status    => MT::Entry::RELEASE()
            },
            {   group  => ["extract(year from authored_on) AS year"],
                'sort' => [
                    {   column => "extract(year from authored_on)",
                        desc   => $order
                    }
                ]
            }
        ) or return $ctx->error("Couldn't get monthly archive list");

        while ( my @row = $count_iter->() ) {
            my $hash = {
                year   => $row[1],
                author => $auth,
                count  => $row[0],
            };
            push( @data, $hash );
            return $count + 1
                if ( defined($limit) && ( $count + 1 ) == $limit );
            $count++;
        }
        return $count;
    };

    # Count entry by author
    if ($author) {
        $loop_sub->($author);
    }
    else {

        # load authors
        require MT::Author;
        my $iter;
        $iter = MT::Author->load_iter(
            undef,
            {   sort      => 'name',
                direction => $auth_order,
                join      => [
                    'MT::Entry',
                    'author_id',
                    { status => MT::Entry::RELEASE(), blog_id => $blog->id },
                    { unique => 1 }
                ]
            }
        );

        while ( my $a = $iter->() ) {
            $loop_sub->($a);
            last if ( defined($limit) && $count == $limit );
        }
    }

    my $loop = @data;
    my $curr = 0;

    return sub {
        if ( $curr < $loop ) {
            my $date
                = sprintf( "%04d%02d%02d000000", $data[$curr]->{year}, 1, 1 );
            my ( $start, $end ) = start_end_year($date);
            my $count = $data[$curr]->{count};
            my %hash  = (
                author => $data[$curr]->{author},
                year   => $data[$curr]->{year},
                start  => $start,
                end    => $end
            );
            $curr++;
            return ( $count, %hash );
        }
        undef;
        }
}

sub archive_group_entries {
    my $obj = shift;
    my ( $ctx, %param ) = @_;
    my $ts
        = $param{year}
        ? sprintf( "%04d%02d%02d000000", $param{year}, 1, 1 )
        : $ctx->{current_timestamp};
    my $author = $param{author} || $ctx->stash('author');
    my $limit = $param{limit};
    $obj->dated_author_entries( $ctx, 'Author-Yearly', $author, $ts, $limit );
}

sub archive_entries_count {
    my $obj = shift;
    my ( $blog, $at, $entry ) = @_;
    my $auth = $entry->author;
    return MT::ArchiveType::archive_entries_count(
        $obj,
        {   Blog        => $blog,
            ArchiveType => $at,
            Timestamp   => $entry->authored_on,
            Author      => $auth
        }
    );
}

*date_range             = \&MT::ArchiveType::Yearly::date_range;
*next_archive_entry     = \&MT::ArchiveType::Date::next_archive_entry;
*previous_archive_entry = \&MT::ArchiveType::Date::previous_archive_entry;

1;
