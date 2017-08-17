# Movable Type (r) (C) 2001-2017 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::ArchiveType::ContentTypeYearly;

use strict;
use base qw( MT::ArchiveType::ContentTypeDate MT::ArchiveType::Yearly );

use MT::Util qw( remove_html encode_html );

sub name {
    return 'ContentTypeYearly';
}

sub archive_label {
    return MT->translate("CONTENTTYPE-YEARLY_ADV");
}

sub default_archive_templates {
    return [
        {   label           => MT->translate('yyyy/index.html'),
            template        => '%y/%i',
            default         => 1,
            required_fields => { date_and_time => 1 }
        }
    ];
}

1;
