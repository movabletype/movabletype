# Movable Type (r) (C) 2001-2017 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::ArchiveType::ContentTypeCategoryYearly;

use strict;
use base
    qw( MT::ArchiveType::ContentTypeCategory MT::ArchiveType::ContentTypeYearly );

use MT::Util qw( remove_html encode_html );

sub name {
    return 'ContentType-Catogery-Yearly';
}

sub archive_label {
    return MT->translate("CONTENTTYPE-CATEGORY-YEARLY_ADV");
}

sub default_archive_templates {
    return [
        {   label    => 'category/sub-category/yyyy/index.html',
            template => '%-c/%y/%i',
            default  => 1
        },
        {   label    => 'category/sub_category/yyyy/index.html',
            template => '%c/%y/%i'
        },
    ];
}

sub template_params {
    return { archive_class => "contenttype-category-yearlyarchive" };
}

sub archive_file {
    my $obj = shift;
    my ( $ctx, %param ) = @_;
}

sub archive_title {
}

1;

