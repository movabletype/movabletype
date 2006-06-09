# $Id$

package Foo;
use strict;

use MT::Object;
use base qw( MT::Object );
__PACKAGE__->install_properties({
    column_defs => {
        'id' => 'integer not null auto_increment',
        'name' => 'string(25)',
        'status' => 'smallint',
        'text' => 'text',
        'data' => 'blob'
    },
    indexes => {
        name => 1,
        status => 1,
        created_on => 1,
    },
    audit => 1,
    datasource => 'foo',
    primary_key => 'id',
});

1;
