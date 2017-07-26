# Movable Type (r) (C) 2001-2017 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::ArchiveType::ContentTypeCategoryWeekly;

use strict;
use base
    qw( MT::ArchiveType::ContentTypeCategory MT::ArchiveType::ContentTypeWeekly );

use MT::Util qw( remove_html encode_html );

sub name {
    return 'ContentType-Category-Weekly';
}

sub archive_label {
    return MT->translate("CONTENTTYPE-CATEGORY-WEEKLY_ADV");
}

sub default_archive_templates {
    return [
        {   label    => 'category/sub-category/yyyy/mm/day-week/index.html',
            template => '%-c/%y/%m/%d-week/%i',
            default  => 1,
        },
        {   label    => 'category/sub_category/yyyy/mm/day-week/index.html',
            template => '%c/%y/%m/%d-week/%i'
        },
    ];
}

sub template_params {
    return { archive_class => "contenttype-category-weekly-archive" };
}

sub archive_file {
    my $obj = shift;
    my ( $ctx, %param ) = @_;
}

sub archive_title {
}

1;

