# Movable Type (r) (C) 2001-2017 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::ArchiveType::ContentTypeDaily;

use strict;
use base qw( MT::ArchiveType::ContentTypeDate MT::ArchiveType::Daily );

use MT::Util qw( start_end_day );

sub name {
    return 'ContentTypeDaily';
}

sub archive_label {
    return MT->translate("CONTENTTYPE-DAILY_ADV");
}

sub default_archive_templates {
    return [
        {   label           => MT->translate('yyyy/mm/dd/index.html'),
            template        => '%y/%m/%d/%f',
            default         => 1,
            required_fields => { date_and_time => 1 }
        },
    ];
}

sub archive_group_contents {
    my $obj = shift;
    my ( $ctx, %param ) = @_;
    my $ts
        = $param{year}
        ? sprintf( "%04d%02d%02d000000",
        $param{year}, $param{month}, $param{day} )
        : undef;
    my $limit = $param{limit};
    $obj->dated_group_contents( $ctx, 'Daily', $ts, $limit );
}

*date_range   = \&MT::ArchiveType::Daily::date_range;
*archive_file = \&MT::ArchiveType::Daily::archive_file;

1;
