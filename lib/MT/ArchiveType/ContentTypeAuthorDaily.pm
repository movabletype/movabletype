# Movable Type (r) (C) 2001-2017 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::ArchiveType::ContentTypeAuthorDaily;

use strict;
use base
    qw( MT::ArchiveType::ContentTypeAuthor MT::ArchiveType::ContentTypeDaily MT::ArchiveType::AuthorDaily );

use MT::Util qw( dirify start_end_day );

sub name {
    return 'ContentType-Author-Daily';
}

sub archive_label {
    return MT->translate("CONTENTTYPE-AUTHOR-DAILY_ADV");
}

sub default_archive_templates {
    return [
        {   label           => 'author/author-basename/yyyy/mm/dd/index.html',
            template        => 'author/%-a/%y/%m/%d/%f',
            default         => 1,
            required_fields => { date_and_time => 1 }
        },
        {   label           => 'author/author_basename/yyyy/mm/dd/index.html',
            template        => 'author/%a/%y/%m/%d/%f',
            required_fields => { date_and_time => 1 }
        },
    ];
}

sub template_params {
    return { archive_class => "contenttype-author-daily-archive" };
}

sub archive_file {
    my $obj = shift;
    my ( $ctx, %param ) = @_;
    my $timestamp    = $param{Timestamp};
    my $file_tmpl    = $param{Template};
    my $author       = $ctx->{__stash}{author};
    my $content_data = $ctx->{__stash}{content};
    my $file;
    my $this_author
        = $author
        ? $author
        : ( $content_data ? $content_data->author : undef );
    return "" unless $this_author;

    if ( !$file_tmpl ) {
        my $name  = $this_author->basename;
        my $start = start_end_day($timestamp);
        my ( $year, $month, $day ) = unpack 'A4A2A2', $start;
        $file = sprintf( "author/%s/%04d/%02d/%02d/index",
            $name, $year, $month, $day );
    }
    else {
        ( $ctx->{current_timestamp}, $ctx->{current_timestamp_end} )
            = start_end_day($timestamp);
    }
    $file;
}

*date_range    = \&MT::ArchiveType::Daily::date_range;
*archive_title = \&MT::ArchiveType::AuthorDaily::archive_title;

1;
