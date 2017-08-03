# Movable Type (r) (C) 2001-2017 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::ArchiveType::ContentTypeMonthly;

use strict;
use base qw( MT::ArchiveType::Date );

use MT::Util qw( remove_html encode_html );

sub name {
    return 'ContentTypeMonthly';
}

sub archive_label {
    return MT->translate("CONTENTTYPE-MONTHLY_ADV");
}

sub default_archive_templates {
    return [
        {   label    => MT->translate('yyyy/mm/index.html'),
            template => '%y/%m/%i',
            default  => 1
        },
    ];
}

1;

