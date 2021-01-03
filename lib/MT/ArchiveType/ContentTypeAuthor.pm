# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::ArchiveType::ContentTypeAuthor;

use strict;
use warnings;
use base qw( MT::ArchiveType::Author );

use MT::ContentStatus;
use MT::Util qw( remove_html encode_html );

sub name {
    return 'ContentType-Author';
}

sub archive_label {
    return MT->translate("CONTENTTYPE-AUTHOR_ADV");
}

sub archive_short_label {
    return MT->translate("AUTHOR_ADV");
}

sub order {
    return 220;
}

sub dynamic_template {
    return 'author/<$MTContentAuthorID$>/<$MTContentID$>';
}

sub default_archive_templates {
    return [
        {   label    => 'author/author-basename/index.html',
            template => 'author/%-a/%f',
            default  => 1
        },
        {   label    => 'author/author_basename/index.html',
            template => 'author/%a/%f'
        },
    ];
}

sub template_params {
    return {
        archive_class               => "contenttype-author-archive",
        author_archive              => 1,
        archive_template            => 1,
        archive_listing             => 1,
        author_based_archive        => 1,
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
    require MT::ContentData;
    require MT::Author;
    my $auth_iter = MT::Author->load_iter(
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
    my $i = 0;
    return sub {

        while ( my $a = $auth_iter->() ) {
            last if defined($limit) && $i == $limit;
            my $count = MT::ContentData->count(
                {   blog_id   => $blog->id,
                    status    => MT::ContentStatus::RELEASE(),
                    author_id => $a->id,
                    (   $ctx->stash('content_type')
                        ? ( content_type_id =>
                                $ctx->stash('content_type')->id )
                        : ()
                    ),
                }
            );
            next if $count == 0 && !$args->{show_empty};
            $i++;
            return ( $count, author => $a );
        }
        undef;
    };
}

sub archive_contents_count {
    my $obj = shift;
    my ( $blog, $at, $content_data ) = @_;
    return $obj->SUPER::archive_contents_count(
        {   Blog        => $blog,
            ArchiveType => $at,
        }
    ) unless $content_data;
    my $auth = $content_data->author;
    return $obj->SUPER::archive_contents_count(
        {   Blog        => $blog,
            ArchiveType => $at,
            Author      => $auth,
            ContentData => $content_data,
        }
    );
}

sub archive_group_contents {
    my $obj = shift;
    my ( $ctx, $param, $content_type_id ) = @_;

    $content_type_id ||=
          $ctx->stash('content_type') ? $ctx->stash('content_type')->id
        : $ctx->stash('template') ? $ctx->stash('template')->content_type_id
        :                           undef;

    my $blog  = $ctx->stash('blog');
    my $a     = $param->{author} || $ctx->stash('author');
    my $limit = $param->{limit};
    $limit = 0 if defined $limit && $limit eq 'none';
    return [] unless $a;
    require MT::ContentData;
    my @contents = MT::ContentData->load(
        {   blog_id => $blog->id,
            (   $content_type_id
                ? ( content_type_id => $content_type_id )
                : ()
            ),
            author_id => $a->id,
            status    => MT::ContentStatus::RELEASE()
        },
        {   'sort'      => 'authored_on',
            'direction' => 'descend',
            ( $limit ? ( 'limit' => $limit ) : () ),
        }
    );
    \@contents;
}

sub does_publish_file {
    my $obj    = shift;
    my %params = %{ shift() };

    if ( !$params{Author} && $params{ContentData} ) {
        $params{Author} = $params{ContentData}->author;
    }
    return 0 unless $params{Author};

    MT::ArchiveType::archive_contents_count( $obj, \%params );
}

sub get_content {
    my ( $archiver, $ctx ) = @_;
    return $ctx->{__stash}{content};
}

sub contenttype_group_based {
    return 1;
}

1;

