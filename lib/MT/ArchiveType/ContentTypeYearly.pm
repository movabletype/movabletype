# Movable Type (r) (C) 2001-2017 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::ArchiveType::ContentTypeYearly;

use strict;
use base qw( MT::ArchiveType::ContentTypeDate MT::ArchiveType::Yearly );

use MT::Util qw( start_end_year );

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

sub archive_group_contents {
    my $obj = shift;
    my ( $ctx, %param ) = @_;
    my $ts
        = $param{year}
        ? sprintf( "%04d%02d%02d000000", $param{year}, 1, 1 )
        : undef;
    my $limit = $param{limit};
    $obj->dated_group_contents( $ctx, 'Yearly', $ts, $limit );
}

*date_range    = \&MT::ArchiveType::Yearly::date_range;
*archive_file  = \&MT::ArchiveType::Yearly::archive_file;
*archive_title = \&MT::ArchiveType::Yearly::archive_title;

1;
