# Movable Type (r) Open Source (C) 2001-2010 Six Apart, Ltd.
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
__END__

=head1 NAME

MT::Page - Movable Type page record

=head1 SYNOPSIS

    use MT::Page;
    my $page = MT::Page->new;
    $page->blog_id($blog->id);
    $page->author_id($author->id);
    $page->title('Page title');
    $page->text('Some text');
    $page->save
        or die $page->errstr;

=head1 DESCRIPTION

The C<MT::Page> class is a subclass of L<MT::Entry>. Pages are very similar
to entries, except that they are not published in a reverse-chronological
listing, typically. Pages are published into folders, represented by
L<MT::Folder> instead of categories.

=head2 MT::Page->class_label

Returns the localized descriptive name for this class.

=head2 MT::Page->class_label_plural

Returns the localized, plural descriptive name for this class.

=head2 MT::Page->container_label

Returns the localized phrase identifying the "container" type for
pages (ie: "Folder").

=head2 MT::Page->container_type

Returns the string "folder", which is the MT type identifier for
the L<MT::Folder> class.

=head2 $page->folder

Returns the L<MT::Folder> the page is assigned to.

=head2 $page->archive_file

Returns the filename for the published page.

=head2 $page->archive_url

Returns the permalink for the page, based on the site_url of the
blog, and folder assignment for the page.

=head2 $page->permalink

Returns the permalink for the page.

=head2 $page->all_permalinks

Returns the permalink for the page.

=cut
