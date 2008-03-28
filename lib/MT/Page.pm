# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package MT::Page;

use strict;
use base qw( MT::Entry );
use MT::Util qw( archive_file_for );

__PACKAGE__->install_properties({
    class_type => 'page',
    child_of => 'MT::Blog',
    child_classes => ['MT::Comment','MT::Placement','MT::Trackback','MT::FileInfo'],
});

sub class_label {
    return MT->translate("Page");
}

sub class_label_plural {
    MT->translate("Pages");
}

sub container_label {
    MT->translate("Folder");
}

sub container_type {
    return "folder";
}

sub folder {
    return $_[0]->category;
}

sub archive_file {
    my $page = shift;
    my $blog = $page->blog() || return $page->error(MT->translate(
                                                     "Load of blog failed: [_1]",
                                                     MT::Blog->errstr));
    return archive_file_for($page, $blog, 'Page');
}

sub archive_url {
    my $page = shift;
    my $blog = $page->blog() || return $page->error(MT->translate(
                                                     "Load of blog failed: [_1]",
                                                     MT::Blog->errstr));
    my $url = $blog->site_url || "";
    $url .= '/' unless $url =~ m!/$!;
    return $url . $page->archive_file(@_);
}

sub permalink {
    my $page = shift;
    return $page->archive_url(@_);
}

sub all_permalinks {
    my $page = shift;
    return ($page->permalink(@_));
}

1;
