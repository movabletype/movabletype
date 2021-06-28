# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::ArchiveType::ContentTypeAuthorWeekly;

use strict;
use warnings;
use base
    qw( MT::ArchiveType::ContentTypeAuthor MT::ArchiveType::ContentTypeWeekly MT::ArchiveType::AuthorWeekly );

use MT::ContentStatus;
use MT::Util qw( start_end_week week2ymd );

sub name {
    return 'ContentType-Author-Weekly';
}

sub archive_label {
    return MT->translate("CONTENTTYPE-AUTHOR-WEEKLY_ADV");
}

sub archive_short_label {
    return MT->translate("AUTHOR-WEEKLY_ADV");
}

sub order {
    return 240;
}

sub dynamic_template {
    return
        'author/<$MTContentAuthorID$>/week/<$MTArchiveDate format="%Y%m%d"$>';
}

sub default_archive_templates {
    return [
        {   label    => 'author/author-basename/yyyy/mm/day-week/index.html',
            template => 'author/%-a/%y/%m/%d-week/%f',
            default  => 1,
            required_fields => { date_and_time => 1 }
        },
        {   label    => 'author/author_basename/yyyy/mm/day-week/index.html',
            template => 'author/%a/%y/%m/%d-week/%f',
            required_fields => { date_and_time => 1 }
        },
    ];
}

sub template_params {
    return {
        archive_class               => "contenttype-author-weekly-archive",
        author_weekly_archive       => 1,
        archive_template            => 1,
        archive_listing             => 1,
        author_based_archive        => 1,
        datebased_archive           => 1,
        contenttype_archive_listing => 1,
        },
        ;
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

    my @data  = ();
    my $count = 0;

    my $ts    = $ctx->{current_timestamp};
    my $tsend = $ctx->{current_timestamp_end};

    my $author = $ctx->stash('author');

    my $content_type_id = $ctx->stash('content_type')->id;
    my $map             = $obj->get_preferred_map(
        {   blog_id         => $blog->id,
            content_type_id => $content_type_id,
            map             => $ctx->stash('template_map'),
        }
    );
    my $dt_field_id = $map ? $map->dt_field_id : '';

    require MT::ContentData;
    require MT::ContentFieldIndex;

    my $loop_sub = sub {
        my $auth = shift;

        my $group_terms
            = $obj->make_archive_group_terms( $blog->id, $dt_field_id, $ts,
            $tsend, $auth->id, $content_type_id );
        my $group_args
            = $obj->make_archive_group_args( 'author', 'weekly',
            $map, $ts, $tsend, $args->{lastn}, $order, '' );

        my $count_iter
            = MT::ContentData->count_group_by( $group_terms, $group_args )
            or return $ctx->error("Couldn't get weekly archive list");

        while ( my @row = $count_iter->() ) {
            my ( $year, $week ) = unpack 'A4A2', $row[1];
            my $hash = {
                year   => $year,
                week   => $week,
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

    # Count content data by author
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
                    'MT::ContentData',
                    'author_id',
                    {   status  => MT::ContentStatus::RELEASE(),
                        blog_id => $blog->id
                    },
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
            my $date = sprintf( "%04d%02d%02d000000",
                week2ymd( $data[$curr]->{year}, $data[$curr]->{week} ) );
            my ( $start, $end ) = start_end_week($date);
            my $count = $data[$curr]->{count};
            my %hash  = (
                author => $data[$curr]->{author},
                year   => $data[$curr]->{year},
                week   => $data[$curr]->{week},
                start  => $start,
                end    => $end
            );
            $curr++;
            return ( $count, %hash );
        }
        undef;
        }
}

sub archive_group_contents {
    my $obj = shift;
    my ( $ctx, $param, $content_type_id ) = @_;
    my $ts
        = $param->{year}
        ? sprintf( "%04d%02d%02d000000",
        week2ymd( $param->{year}, $param->{week} ) )
        : $ctx->{current_timestamp};
    my $author = $param->{author} || $ctx->stash('author');
    my $limit = $param->{limit};
    $obj->dated_author_contents( $ctx, $obj->name, $author,
        $ts, $limit, $content_type_id );
}

*date_range    = \&MT::ArchiveType::Weekly::date_range;
*archive_file  = \&MT::ArchiveType::AuthorWeekly::archive_file;
*archive_title = \&MT::ArchiveType::AuthorWeekly::archive_title;
*next_archive_content_data
    = \&MT::ArchiveType::ContentTypeDate::next_archive_content_data;
*previous_archive_content_data
    = \&MT::ArchiveType::ContentTypeDate::previous_archive_content_data;

1;
