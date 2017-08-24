# Movable Type (r) (C) 2001-2017 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::ArchiveType::ContentTypeAuthorMonthly;

use strict;
use base
    qw( MT::ArchiveType::ContentTypeAuthor MT::ArchiveType::ContentTypeMonthly MT::ArchiveType::AuthorMonthly );

use MT::Util qw( start_end_month );

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

sub archive_group_contents {
    my $obj = shift;
    my ( $ctx, %param ) = @_;
    Carp::confess("ctx is undef") unless defined $ctx;
    my $ts
        = $param{year}
        ? sprintf( "%04d%02d%02d000000", $param{year}, $param{month}, 1 )
        : $ctx->stash('current_timestamp');
    my $author = $param{author} || $ctx->stash('author');
    my $limit = $param{limit};
    $obj->dated_author_contents( $ctx, 'Author-Monthly', $author, $ts,
        $limit );
}

*date_range    = \&MT::ArchiveType::Monthly::date_range;
*archive_file  = \&MT::ArchiveType::AuthorMonthly::archive_file;
*archive_title = \&MT::ArchiveType::AuthorMonthly::archive_title;

1;
