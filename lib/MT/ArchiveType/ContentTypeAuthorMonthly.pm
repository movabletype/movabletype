# Movable Type (r) (C) 2001-2017 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::ArchiveType::ContentTypeAuthorMonthly;

use strict;
use base
    qw( MT::ArchiveType::AuthorMonthly MT::ArchiveType::ContentTypeAuthor MT::ArchiveType::ContentTypeMonthly );

use MT::Util qw( remove_html encode_html );

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
}

sub archive_title {
}

1;

