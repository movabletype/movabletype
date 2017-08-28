# Movable Type (r) (C) 2001-2017 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::ArchiveType::ContentTypeAuthorWeekly;

use strict;
use base
    qw( MT::ArchiveType::ContentTypeAuthor MT::ArchiveType::ContentTypeWeekly MT::ArchiveType::AuthorWeekly );

use MT::Util qw( start_end_week week2ymd );

sub name {
    return 'ContentType-Author-Weekly';
}

sub archive_label {
    return MT->translate("CONTENTTYPE-AUTHOR-WEEKLY_ADV");
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
    return { archive_class => "contenttype-author-weekly-archive" };
}

sub archive_group_contents {
    my $obj = shift;
    my ( $ctx, %param ) = @_;
    my $ts
        = $param{year}
        ? sprintf( "%04d%02d%02d000000",
        week2ymd( $param{year}, $param{week} ) )
        : $ctx->stash('current_timestamp');
    my $author = $param{author} || $ctx->stash('author');
    my $limit = $param{limit};
    $obj->dated_author_contents( $ctx, 'Author-Weekly', $author, $ts, $limit );
}

*date_range    = \&MT::ArchiveType::Weekly::date_range;
*archive_file  = \&MT::ArchiveType::AuthorWeekly::archive_file;
*archive_title = \&MT::ArchiveType::AuthorWeekly::archive_title;

1;
