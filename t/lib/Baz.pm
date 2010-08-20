# $Id: Bar.pm 2185 2008-05-01 21:17:43Z mpaschal $

package Baz;
use strict;

use MT::Object;
use base qw( MT::Object );
__PACKAGE__->install_properties({
    column_defs => {
        'id' => 'integer not null auto_increment',
        'bar_id' => 'integer',
        'name' => 'string(25)',
        'status' => 'smallint',
    },
    indexes => {
        bar_id => 1,
        name => 1,
        created_on => 1,
        status => 1,
    },
    audit => 1,
    datasource => 'baz',
    primary_key => 'id',
    cacheable => 0,
});

1;
