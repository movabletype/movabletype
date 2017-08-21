# Movable Type (r) (C) 2001-2017 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::ArchiveType::ContentTypeWeekly;

use strict;
use base qw( MT::ArchiveType::ContentTypeDate MT::ArchiveType::Weekly );

use MT::Util qw( start_end_week week2ymd );

sub name {
    return 'ContentTypeWeekly';
}

sub archive_label {
    return MT->translate("CONTENTTYPE-WEEKLY_ADV");
}

sub default_archive_templates {
    return [
        {   label           => MT->translate('yyyy/mm/day-week/index.html'),
            template        => '%y/%m/%d-week/%i',
            default         => 1,
            required_fields => { date_and_time => 1 }
        },
    ];
}

*date_range = \&MT::ArchiveType::Weekly::date_range;

1;

