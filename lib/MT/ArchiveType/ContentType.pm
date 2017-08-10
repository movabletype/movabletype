# Movable Type (r) (C) 2001-2017 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::ArchiveType::ContentType;

use strict;
use base qw( MT::ArchiveType );

use MT::Util qw( remove_html encode_html );

sub name {
    return 'ContentType';
}

sub archive_label {
    return MT->translate("CONTENTTYPE_ADV");
}

sub template_params {
    return { archive_class => "contenttype-archive" };
}

sub archive_file {
    my $obj = shift;
    my ( $ctx, %param ) = @_;
    my $timestamp = $param{Timestamp};
    my $file_tmpl = $param{Template};
    my $blog      = $ctx->{__stash}{blog};
    my $content   = $ctx->{__stash}{content};

    my $file;
    Carp::confess("archive_file_for ContentType archive needs an content")
        unless $content;
    if ($file_tmpl) {
        $ctx->{current_timestamp} = $content->authored_on;
    }
    else {
        my $basename = $content->identifier();
        $basename ||= dirify( $content->label() );
        $file = sprintf( "%04d/%02d/%s",
            unpack( 'A4A2', $content->authored_on ), $basename );
    }
    $file;
}

sub archive_title {
}

sub default_archive_templates {
    return [
        {   label           => MT->translate('yyyy/mm/base-name.html'),
            template        => '%y/%m/%-f',
            default         => 1,
            required_fields => { date_and_time => 1 }
        },
        {   label           => MT->translate('yyyy/mm/base_name.html'),
            template        => '%y/%m/%f',
            required_fields => { date_and_time => 1 }
        },
        {   label           => MT->translate('yyyy/mm/base-name/index.html'),
            template        => '%y/%m/%-b/%i',
            required_fields => { date_and_time => 1 }
        },
        {   label           => MT->translate('yyyy/mm/base_name/index.html'),
            template        => '%y/%m/%b/%i',
            required_fields => { date_and_time => 1 }
        },
        {   label           => MT->translate('yyyy/mm/dd/base-name.html'),
            template        => '%y/%m/%d/%-f',
            required_fields => { date_and_time => 1 }
        },
        {   label           => MT->translate('yyyy/mm/dd/base_name.html'),
            template        => '%y/%m/%d/%f',
            required_fields => { date_and_time => 1 }
        },
        {   label    => MT->translate('yyyy/mm/dd/base-name/index.html'),
            template => '%y/%m/%d/%-b/%i',
            required_fields => { date_and_time => 1 }
        },
        {   label    => MT->translate('yyyy/mm/dd/base_name/index.html'),
            template => '%y/%m/%d/%b/%i',
            required_fields => { date_and_time => 1 }
        },
        {   label    => MT->translate('category/sub-category/base-name.html'),
            template => '%-c/%-f',
            required_fields => { category => 1 }
        },
        {   label =>
                MT->translate('category/sub-category/base-name/index.html'),
            template        => '%-c/%-b/%i',
            required_fields => { category => 1 }
        },
        {   label    => MT->translate('category/sub_category/base_name.html'),
            template => '%c/%f',
            required_fields => { category => 1 }
        },
        {   label =>
                MT->translate('category/sub_category/base_name/index.html'),
            template        => '%c/%b/%i',
            required_fields => { category => 1 }
        },
    ];
}

1;
