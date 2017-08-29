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

sub dynamic_template {
    return 'archives/week/<$MTArchiveDate format="%Y%m%d"$>';
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

sub template_params {
    return {
        archive_class                => "contenttype-datebased-weekly-archive",
        datebased_weekly_archive     => 1,
        archive_template             => 1,
        archive_listing              => 1,
        datebased_archive            => 1,
        datebased_only_archive       => 1,
        contenttype_archive_lisrting => 1,
    };
}

sub archive_group_contents {
    my $obj = shift;
    my ( $ctx, %param ) = @_;
    my $ts
        = $param{year}
        ? sprintf( "%04d%02d%02d000000",
        week2ymd( $param{year}, $param{week} ) )
        : undef;
    my $limit = $param{limit};
    $obj->dated_group_contents( $ctx, 'Weekly', $ts, $limit );
}

*date_range    = \&MT::ArchiveType::Weekly::date_range;
*archive_file  = \&MT::ArchiveType::Weekly::archive_file;
*archive_title = \&MT::ArchiveType::Weekly::archive_title;

1;

