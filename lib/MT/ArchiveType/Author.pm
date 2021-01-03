# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::ArchiveType::Author;

use strict;
use warnings;
use base qw( MT::ArchiveType );

use MT::Util qw( remove_html encode_html );

sub name {
    return 'Author';
}

sub archive_label {
    return MT->translate('AUTHOR_ADV');
}

sub order {
    return 70;
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

sub dynamic_template {
    return 'author/<$MTEntryAuthorID$>/<$MTEntryID$>';
}

sub template_params {
    return {
        archive_class        => "author-archive",
        author_archive       => 1,
        archive_template     => 1,
        archive_listing      => 1,
        author_based_archive => 1,
    };
}

sub archive_title {
    my $obj   = shift;
    my ($ctx) = @_;
    my $a     = $ctx->stash('author');
    encode_html(
        remove_html(
            $a ? $a->nickname || MT->translate('(Display Name not set)') : ''
        )
    );
}

sub archive_file {
    my $archiver = shift;
    my ( $ctx, %param ) = @_;
    my $file_tmpl = $param{Template};
    my $author    = $ctx->{__stash}{author};
    my $obj       = $archiver->get_content($ctx);
    my $file;

    my $this_author = $author ? $author : ( $obj ? $obj->author : undef );
    return "" unless $this_author;

    if ( !$file_tmpl ) {
        $file = sprintf( "%s/index", $this_author->basename );
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
    require MT::Entry;
    require MT::Author;
    my $auth_iter = MT::Author->load_iter(
        undef,
        {   sort      => 'name',
            direction => $auth_order,
            join      => [
                'MT::Entry', 'author_id',
                { status => MT::Entry::RELEASE(), blog_id => $blog->id },
                { unique => 1 }
            ]
        }
    );
    my $i = 0;
    return sub {

        while ( my $a = $auth_iter->() ) {
            last if defined($limit) && $i == $limit;
            my $count = MT::Entry->count(
                {   blog_id   => $blog->id,
                    status    => MT::Entry::RELEASE(),
                    author_id => $a->id
                }
            );
            next if $count == 0 && !$args->{show_empty};
            $i++;
            return ( $count, author => $a );
        }
        undef;
    };
}

sub archive_group_entries {
    my $obj = shift;
    my ( $ctx, %param ) = @_;
    my $blog  = $ctx->stash('blog');
    my $a     = $param{author} || $ctx->stash('author');
    my $limit = $param{limit};
    if ( $limit && ( $limit eq 'auto' ) ) {
        my $blog = $ctx->stash('blog');
        $limit = $blog->entries_on_index if $blog;
    }
    return [] unless $a;
    require MT::Entry;
    my @entries = MT::Entry->load(
        {   blog_id   => $blog->id,
            author_id => $a->id,
            status    => MT::Entry::RELEASE()
        },
        {   'sort'      => 'authored_on',
            'direction' => 'descend',
            ( $limit ? ( 'limit' => $limit ) : () ),
        }
    );
    \@entries;
}

sub archive_entries_count {
    my $obj = shift;
    my ( $blog, $at, $entry ) = @_;
    return $obj->SUPER::archive_entries_count(
        {   Blog        => $blog,
            ArchiveType => $at,
        }
    ) unless $entry;
    my $auth = $entry->author;
    return $obj->SUPER::archive_entries_count(
        {   Blog        => $blog,
            ArchiveType => $at,
            Author      => $auth
        }
    );
}

sub does_publish_file {
    my $obj    = shift;
    my %params = %{ shift() };

    if ( !$params{Author} && $params{Entry} ) {
        $params{Author} = $params{Entry}->author;
    }
    return 0 unless $params{Author};

    MT::ArchiveType::archive_entries_count( $obj, \%params );
}

sub display_name {
    my $obj    = shift;
    my ($ctx)  = shift;
    my $tmpl   = $ctx->stash('template');
    my $at     = $ctx->{archive_type};
    my $author = '';
    if (   ( $tmpl && ( $tmpl->type eq 'index' || $tmpl->type eq 'widget' ) )
        || !$obj
        || ( $obj && !$obj->author_based )
        || !$ctx->{inside_archive_list} )
    {
        $author = $ctx->stash('author');
        $author
            = $author
            ? $author->nickname
                ? $author->nickname . ": "
                : MT->translate('(Display Name not set)')
            : '';
    }
    return $author;
}

sub author_based {
    return 1;
}

sub group_based {
    return 1;
}

sub get_content {
    my ( $archiver, $ctx ) = @_;
    return $ctx->{__stash}{entry};
}

1;
