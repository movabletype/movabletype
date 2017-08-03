# Movable Type (r) (C) 2001-2017 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::ArchiveType::ContentTypeDaily;

use strict;
use base qw( MT::ArchiveType::ContentTypeDate );

use MT::Util qw( remove_html encode_html );

sub name {
    return 'ContentTypeDaily';
}

sub archive_label {
    return MT->translate("CONTENTTYPE-DAILY_ADV");
}

sub default_archive_templates {
    return [
        {   label    => MT->translate('yyyy/mm/dd/index.html'),
            template => '%y/%m/%d/%f',
            default  => 1
        },
    ];
}

1;
