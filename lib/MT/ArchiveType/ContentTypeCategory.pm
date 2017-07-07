# Movable Type (r) (C) 2001-2017 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::ArchiveType::ContentTypeCategory;

use strict;
use base qw( MT::ArchiveType::ContentType );

use MT::Util qw( remove_html encode_html );

sub name {
    return 'ContentType-Category';
}

sub archive_label {
    return MT->translate("CONTENTTYPE-CATEGORY_ADV");
}

sub template_params {
    return {
        archive_class => "contenttype-category-archive",
    };
}

sub archive_file {
    my $obj = shift;
    my ( $ctx, %param ) = @_;
}

sub archive_title {
}

1;


