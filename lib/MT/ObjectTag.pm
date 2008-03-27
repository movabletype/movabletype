# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package MT::ObjectTag;

use strict;

use MT::Blog;
use base qw( MT::Object );

__PACKAGE__->install_properties({
    column_defs => {
        'id' => 'integer not null auto_increment',
        'blog_id' => 'integer',
        'object_id' => 'integer not null',
        'object_datasource' => 'string(50) not null',
        'tag_id' => 'integer not null',
    },
    indexes => {
        object_id => 1,
        tag_id => 1,
        object_datasource => 1,
        blog_ds => {
            columns => ['blog_id', 'object_datasource'],
        },
        # For MTTags
        blog_ds_tag => {
            columns => ['blog_id', 'object_datasource', 'tag_id'],
        },
        # For tag count
        blog_ds_object_tag => {
            Columns => ['blog_id', 'object_datasource', 'object_id', 'tag_id'],
        },
    },
    child_of => 'MT::Blog',
    datasource => 'objecttag',
    primary_key => 'id',
    cacheable => 0,
});

sub class_label {
    MT->translate("Tag Placement");
}

sub class_label_plural {
    MT->translate("Tag Placements");
}

1;
__END__

=head1 NAME

MT::ObjectTag

=head1 AUTHOR & COPYRIGHT

Please see L<MT/AUTHOR & COPYRIGHT>.

=cut
