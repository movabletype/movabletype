# Copyright 2001-2007 Six Apart. This code cannot be redistributed without
# permission from www.sixapart.com.  For more information, consult your
# Movable Type license.
#
# $Id$

package MT::Page;

use strict;
use base qw( MT::Entry );
use MT::Util qw( archive_file_for );

__PACKAGE__->install_properties({
    class_type => 'page',
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
    my $url = $blog->archive_url || "";
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

# This routine is declared to avoid building 'previous'/'next' pages
# by MT's rebuild process.
sub get_entry {
    return undef;
}

1;
