# Movable Type (r) (C) 2001-2017 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::ArchiveType::ContentTypeWeekly;

use strict;
use base qw( MT::ArchiveType::ContentTypeDate );

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

sub archive_file {
    my $obj = shift;
    my ( $ctx, %param ) = @_;
    my $timestamp = $param{Timestamp};
    my $file_tmpl = $param{Template};

    my $file;
    if ($file_tmpl) {
        ( $ctx->{current_timestamp}, $ctx->{current_timestamp_end} )
            = start_end_week($timestamp);
    }
    else {
        my $start = start_end_week($timestamp);
        my ( $year, $mon, $mday ) = unpack 'A4A2A2', $start;
        $file = sprintf( "%04d/%02d/%02d-week/index", $year, $mon, $mday );
    }
    $file;
}

1;

