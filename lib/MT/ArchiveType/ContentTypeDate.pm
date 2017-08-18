# Movable Type (r) (C) 2001-2017 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::ArchiveType::ContentTypeDate;

use base qw( MT::ArchiveType::Date );

sub archive_contents_count {
    my $obj = shift;
    my ( $blog, $at, $content_data, $timestamp ) = @_;
    return $obj->SUPER::archive_contents_count(
        {   Blog        => $blog,
            ArchiveType => $at,
        }
    ) unless $content_data;
    return $obj->SUPER::archive_contents_count(
        {   Blog        => $blog,
            ArchiveType => $at,
            Timestamp   => $timestamp,
        }
    );
}

sub does_publish_file {
    my $obj    = shift;
    my %params = %{ shift() };

    $obj->archive_contents_count(
        $params{Blog},        $params{ArchiveType},
        $params{ContentData}, $params{Start}
    );
}

sub target_dt {
    my $archiver = shift;
    my ( $content_data, $map ) = @_;

    my $target_dt;
    my $dt_field_id = $map->dt_field_id;
    if ($dt_field_id) {
        my $data = $content_data->data;
        $target_dt = $data->{$dt_field_id};
    }
    $target_dt = $content_data->authored_on unless $target_dt;

    return $target_dt;
}

1;
