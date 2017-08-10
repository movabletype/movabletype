# Movable Type (r) (C) 2001-2017 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::ArchiveType::ContentTypeAuthor;

use strict;
use base qw( MT::ArchiveType );

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

sub archive_file {
    my $obj = shift;
    my ( $ctx, %param ) = @_;
    my $file_tmpl    = $param{Template};
    my $author       = $ctx->{__stash}{author};
    my $content_data = $ctx->{__stash}{content};
    my $file;

    my $this_author
        = $author
        ? $author
        : ( $content_data ? $content_data->author : undef );
    return "" unless $this_author;

    if ( !$file_tmpl ) {
        $file = sprintf( "%s/index", $this_author->basename );
    }
    $file;
}

sub archive_title {
}

1;

