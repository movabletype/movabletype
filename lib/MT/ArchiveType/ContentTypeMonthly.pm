# Movable Type (r) (C) 2001-2017 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::ArchiveType::ContentTypeMonthly;

use strict;
use base qw( MT::ArchiveType::ContentTypeDate );

use MT::Util qw( start_end_month );

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

sub archive_file {
    my $obj = shift;
    my ( $ctx, %param ) = @_;
    my $timestamp = $param{Timestamp};
    my $file_tmpl = $param{Template};
    my $blog      = $ctx->{__stash}{blog};

    my $file;
    if ($file_tmpl) {
        ( $ctx->{current_timestamp}, $ctx->{current_timestamp_end} )
            = start_end_month( $timestamp, $blog );
    }
    else {
        my $start = start_end_month( $timestamp, $blog );
        my ( $year, $mon ) = unpack 'A4A2', $start;
        $file = sprintf( "%04d/%02d/index", $year, $mon );
    }

    $file;
}

1;

