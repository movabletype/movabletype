# Movable Type (r) (C) 2001-2017 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::ArchiveType::ContentTypeAuthorDaily;

use strict;
use base
    qw( MT::ArchiveType::AuthorDaily MT::ArchiveType::ContentTypeAuthor MT::ArchiveType::ContentTypeDaily );

use MT::Util qw( remove_html encode_html );

sub name {
    return 'ContentType-Author-Daily';
}

sub archive_label {
    return MT->translate("CONTENTTYPE-AUTHOR-DAILY_ADV");
}

sub template_params {
    return { archive_class => "contenttype-author-daily-archive" };
}

sub archive_file {
    my $obj = shift;
    my ( $ctx, %param ) = @_;
}

sub archive_title {
}

1;

