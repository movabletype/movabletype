# Movable Type (r) (C) 2001-2017 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::ArchiveType::ContentTypeAuthorMonthly;

use strict;
use base
    qw( MT::ArchiveType::ContentTypeAuthor MT::ArchiveType::ContentTypeMonthly MT::ArchiveType::AuthorMonthly );

use MT::Util qw( dirify start_end_day );

sub name {
    return 'ContentType-Author-Monthly';
}

sub archive_label {
    return MT->translate("CONTENTTYPE-AUTHOR-MONTHLY_ADV");
}

sub default_archive_templates {
    return [
        {   label           => 'author/author-basename/yyyy/mm/index.html',
            template        => 'author/%-a/%y/%m/%f',
            default         => 1,
            required_fields => { date_and_time => 1 }
        },
        {   label           => 'author/author_basename/yyyy/mm/index.html',
            template        => 'author/%a/%y/%m/%f',
            required_fields => { date_and_time => 1 }
        },
    ];
}

sub template_params {
    return { archive_class => "contenttype-author-monthly-archive" };
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
        my $name = $this_author->basename;
        my ($start) = start_end_month($timestamp);
        my ( $year, $month ) = unpack 'A4A2', $start;
        $file = sprintf( "author/%s/%04d/%02d/index", $name, $year, $month );
    }
    else {
        ( $ctx->{current_timestamp}, $ctx->{current_timestamp_end} )
            = start_end_month($timestamp);
    }
    $file;
}

*date_range    = \&MT::ArchiveType::Monthly::date_range;
*archive_title = \&MT::ArchiveType::AuthorMonthly::archive_title;

1;
