# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package MT::Folder;

use strict;
use base qw( MT::Category );

__PACKAGE__->install_properties({
    class_type => 'folder',
    child_of => 'MT::Blog',
    child_classes => ['MT::Placement', 'MT::FileInfo'],
});

sub class_label {
    return MT->translate("Folder");
}

sub class_label_plural {
    MT->translate("Folders");
}

sub basename_prefix {
    "folder";
}

1;
