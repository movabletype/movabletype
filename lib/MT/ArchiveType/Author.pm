# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package MT::ArchiveType::Author;

use strict;
use base qw( MT::ArchiveType );

sub name {
    return 'Author';
}

sub archive_label {
    return MT->translate('AUTHOR_ADV');
}

sub default_archive_templates {
    return [
        {
            label    => 'author/author-display-name/index.html',
            template => 'author/%-a/%f',
            default  => 1
        },
        {
            label    => 'author/author_display_name/index.html',
            template => 'author/%a/%f'
        },
    ];
}

sub dynamic_template {
    return 'author/<$MTEntryAuthorID$>/<$MTEntryID$>';
}

sub template_params {
    return {
        archive_class                    => "author-archive",
        'module_author-monthly_archives' => 1,
        author_archive                   => 1,
        archive_template                 => 1,
        archive_listing                  => 1,
    };
}

sub archive_title {
    my $obj = shift;
    my ($ctx) = @_;
    my $a = $ctx->stash('author');
    $a ? $a->nickname || MT->translate( '(Display Name not set)' ) : '';
}

sub archive_file {
    my $obj = shift;
    my ( $ctx, %param ) = @_;
    my $file_tmpl = $param{Template};
    my $author    = $ctx->{__stash}{author};
    my $entry     = $ctx->{__stash}{entry};
    my $file;

    my $this_author = $author ? $author : ( $entry ? $entry->author : undef );
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
    my $sort_order =
      ( $args->{sort_order} || '' ) eq 'ascend' ? 'ascend' : 'descend';
    my $auth_order = $args->{sort_order} ? $args->{sort_order} : 'ascend';
    my $order = ( $sort_order eq 'ascend' ) ? 'asc' : 'desc';
    my $limit = exists $args->{lastn} ? delete $args->{lastn} : undef;
    require MT::Entry;
    require MT::Author;
    my $auth_iter = MT::Author->load_iter(
        undef,
        {
            sort      => 'name',
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
                {
                    blog_id   => $blog->id,
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
    my $blog = $ctx->stash('blog');
    my $a = $param{author} || $ctx->stash('author');
    my $limit = $param{limit};
    if ( $limit eq 'auto' ) {
        my $blog = $ctx->stash('blog');
        $limit = $blog->entries_on_index if $blog;
    }
    return [] unless $a;
    require MT::Entry;
    my @entries = MT::Entry->load(
        {
            blog_id   => $blog->id,
            author_id => $a->id,
            status    => MT::Entry::RELEASE()
        },
        {
            'sort'      => 'authored_on',
            'direction' => 'descend',
            ( $limit ? ( 'limit' => $limit ) : () ),
        }
    );
    \@entries;
}

sub archive_entries_count {
    my $obj = shift;
    my ( $blog, $at, $entry ) = @_;
    return $obj->SUPER::archive_entries_count(@_) unless $entry;
    my $auth = $entry->author;
    return $obj->SUPER::archive_entries_count(
        {
            Blog        => $blog,
            ArchiveType => $at,
            Author      => $auth
        }
    );
}

sub display_name {
    my $obj = shift;
    my ($ctx)    = shift;
    my $tmpl     = $ctx->stash('template');
    my $at       = $ctx->{archive_type};
    my $author   = '';
    if (   ( $tmpl && $tmpl->type eq 'index' )
        || !$obj
        || ( $obj && !$obj->author_based )
        || !$ctx->{inside_archive_list} )
    {
        $author = $ctx->stash('author');
        $author =
            $author
          ? $author->nickname
          ? $author->nickname . ": "
          : MT->translate( '(Display Name not set)' )
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

sub date_based_author_entries {
    my $obj = shift;
    my ( $ctx, $at, $author, $ts ) = @_;

    my $blog     = $ctx->stash('blog');
    my ( $start, $end );
    if ($ts) {
        ( $start, $end ) = $obj->date_range($ts);
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
