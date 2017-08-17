# Movable Type (r) (C) 2001-2017 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::ArchiveType::ContentTypeAuthor;

use strict;
use base qw( MT::ArchiveType::Author );

use MT::Util qw( remove_html encode_html );

sub name {
    return 'ContentType-Author';
}

sub archive_label {
    return MT->translate("CONTENTTYPE-AUTHOR_ADV");
}

sub default_archive_templates {
    return [
        {   label    => 'author/author-basename/index.html',
            template => 'author/%-a/%f',
            default  => 1
        },
        {   label    => 'author/author_basename/index.html',
            template => 'author/%a/%f'
        },
    ];
}

sub template_params {
    return { archive_class => "contenttype-author-archive" };
}

sub archive_contents_count {
    my $obj = shift;
    my ( $blog, $at, $content_data ) = @_;
    return $obj->SUPER::archive_contents_count(
        {   Blog        => $blog,
            ArchiveType => $at,
        }
    ) unless $content_data;
    my $auth = $content_data->author;
    return $obj->SUPER::archive_contents_count(
        {   Blog        => $blog,
            ArchiveType => $at,
            Author      => $auth
        }
    );
}

sub does_publish_file {
    my $obj    = shift;
    my %params = %{ shift() };

    if ( !$params{Author} && $params{ContentData} ) {
        $params{Author} = $params{ContentData}->author;
    }
    return 0 unless $params{Author};

    MT::ArchiveType::archive_contents_count( $obj, \%params );
}

sub _get_content {
    my $ctx = shift;
    return $ctx->{__stash}{content};
}

1;

