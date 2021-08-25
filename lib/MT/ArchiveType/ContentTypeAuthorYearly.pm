# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::ArchiveType::ContentTypeAuthorYearly;

use strict;
use warnings;
use base
    qw( MT::ArchiveType::ContentTypeAuthor MT::ArchiveType::ContentTypeYearly MT::ArchiveType::AuthorYearly );

use MT::ContentStatus;
use MT::Util qw( start_end_year );

sub name {
    return 'ContentType-Author-Yearly';
}

sub archive_label {
    return MT->translate("CONTENTTYPE-AUTHOR-YEARLY_ADV");
}

sub archive_short_label {
    return MT->translate("AUTHOR-YEARLY_ADV");
}

sub order {
    return 260;
}

sub dynamic_template {
    return 'author/<$MTContentAuthorID$>/<$MTArchiveDate format="%Y"$>';
}

sub default_archive_templates {
    return [
        {   label           => 'author/author-basename/yyyy/index.html',
            template        => 'author/%-a/%y/%f',
            default         => 1,
            required_fields => { date_and_time => 1 }
        },
        {   label           => 'author/author_basename/yyyy/index.html',
            template        => 'author/%a/%y/%f',
            required_fields => { date_and_time => 1 }
        },
    ];
}

sub template_params {
    return {
        archive_class               => "contenttype-author-yearly-archive",
        author_yearly_archive       => 1,
        archive_template            => 1,
        archive_listing             => 1,
        author_based_archive        => 1,
        datebased_archive           => 1,
        contenttype_archive_listing => 1,
    };
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
            = $obj->make_archive_group_terms( $blog->id, $dt_field_id, '', '',
            $auth->id, $content_type_id );
        my $group_args
            = $obj->make_archive_group_args( 'author', 'yearly',
            $map, '', '', $args->{lastn}, $order, '' );

        my $count_iter
            = MT::ContentData->count_group_by( $group_terms, $group_args )
            or return $ctx->error("Couldn't get monthly archive list");

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

sub archive_group_contents {
    my $obj = shift;
    my ( $ctx, $param, $content_type_id ) = @_;
    my $ts
        = $param->{year}
        ? sprintf( "%04d%02d%02d000000", $param->{year}, 1, 1 )
        : $ctx->{current_timestamp};
    my $author = $param->{author} || $ctx->stash('author');
    my $limit = $param->{limit};
    $obj->dated_author_contents( $ctx, $obj->name, $author,
        $ts, $limit, $content_type_id );
}

*date_range    = \&MT::ArchiveType::Yearly::date_range;
*archive_file  = \&MT::ArchiveType::AuthorYearly::archive_file;
*archive_title = \&MT::ArchiveType::AuthorYearly::archive_title;
*next_archive_content_data
    = \&MT::ArchiveType::ContentTypeDate::next_archive_content_data;
*previous_archive_content_data
    = \&MT::ArchiveType::ContentTypeDate::previous_archive_content_data;

1;
