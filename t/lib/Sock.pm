# $Id$

package Classfree::Sock;

use strict;
use base qw( MT::Object );

__PACKAGE__->install_properties({
    column_defs => {
        'id'    => 'integer not null auto_increment',
        'text'  => 'text',

        class       => 'string(255)',
        created_on  => 'datetime',
        created_by  => 'integer',
        modified_on => 'datetime',
        modified_by => 'integer',
    },
    datasource => 'sock',
    primary_key => 'id',
    cacheable => 0,
});

package Sock;

use strict;
use base qw( MT::Object );

__PACKAGE__->install_properties({
    column_defs => {
        'id' => 'integer not null auto_increment',
        'text' => 'text',
    },
    audit => 1,
    datasource => 'sock',
    primary_key => 'id',
    class_type => 'sock',
    cacheable => 0,
});

package Sock::Monkey;

use strict;
use base qw( Sock );

__PACKAGE__->install_properties({
    class_type => 'monkey',
});

package Sock::Fish;

use strict;
use base qw( Sock );

__PACKAGE__->install_properties({
    class_type => 'fish',
});

1;
