# Movable Type (r) (C) 2001-2017 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::ArchiveType::ContentType;

use strict;
use base qw( MT::ArchiveType::Individual );

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
}

sub archive_title {
}

sub default_archive_templates {
    return [
        {   label    => MT->translate('yyyy/mm/base-name.html'),
            template => '%y/%m/%-f',
            default  => 1
        },
        {   label    => MT->translate('yyyy/mm/base_name.html'),
            template => '%y/%m/%f'
        },
        {   label    => MT->translate('yyyy/mm/base-name/index.html'),
            template => '%y/%m/%-b/%i'
        },
        {   label    => MT->translate('yyyy/mm/base_name/index.html'),
            template => '%y/%m/%b/%i'
        },
        {   label    => MT->translate('yyyy/mm/dd/base-name.html'),
            template => '%y/%m/%d/%-f'
        },
        {   label    => MT->translate('yyyy/mm/dd/base_name.html'),
            template => '%y/%m/%d/%f'
        },
        {   label    => MT->translate('yyyy/mm/dd/base-name/index.html'),
            template => '%y/%m/%d/%-b/%i'
        },
        {   label    => MT->translate('yyyy/mm/dd/base_name/index.html'),
            template => '%y/%m/%d/%b/%i'
        },
        {   label    => MT->translate('category/sub-category/base-name.html'),
            template => '%-c/%-f'
        },
        {   label =>
                MT->translate('category/sub-category/base-name/index.html'),
            template => '%-c/%-b/%i'
        },
        {   label    => MT->translate('category/sub_category/base_name.html'),
            template => '%c/%f'
        },
        {   label =>
                MT->translate('category/sub_category/base_name/index.html'),
            template => '%c/%b/%i'
        },
    ];
}

1;
