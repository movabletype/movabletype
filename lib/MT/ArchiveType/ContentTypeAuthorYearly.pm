# Movable Type (r) (C) 2001-2017 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::ArchiveType::ContentTypeAuthorYearly;

use strict;
use base
    qw( MT::ArchiveType::ContentTypeAuthor MT::ArchiveType::ContentTypeYearly MT::ArchiveType::AuthorYearly );

use MT::Util qw( dirify start_end_day );

sub name {
    return 'ContentType-Author-Yearly';
}

sub archive_label {
    return MT->translate("CONTENTTYPE-AUTHOR-YEARLY_ADV");
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
    return { archive_class => "contenttype-author-yearly-archive" };
}

*date_range    = \&MT::ArchiveType::Yearly::date_range;
*archive_file  = \&MT::ArchiveType::AuthorYearly::archive_file;
*archive_title = \&MT::ArchiveType::AuthorYearly::archive_title;

1;
