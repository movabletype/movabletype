# Copyright 2001-2007 Six Apart. This code cannot be redistributed without
# permission from www.sixapart.com.  For more information, consult your
# Movable Type license.
#
# $Id: Object.pm 822 2006-12-04 09:21:08Z fumiakiy $

package BackupRestoreSample::Object;
use strict;

use MT::Object;
@BackupRestoreSample::Object::ISA = qw( MT::Object );
__PACKAGE__->install_properties({
    column_defs => {
        'id' => 'integer not null auto_increment',
        'blog_id' => 'integer not null',
        'role_id' => 'integer not null',
        'description' => 'text',
    },
    indexes => {
        blog_id => 1,
        role_id => 1,
    },
    child_of => 'MT::Blog',
    datasource => 'backup_restore_sample_object',
    primary_key => 'id',
});

sub parent_names {
    my $obj = shift;
    my $parents = {
        blog => 'MT::Blog',
        role => 'MT::Role',
    };
    $parents;
}

1;
