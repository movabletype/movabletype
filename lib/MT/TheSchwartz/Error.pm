# $Id$

package MT::TheSchwartz::Error;

use strict;
use base qw( MT::Object );

__PACKAGE__->install_properties({
    column_defs => {
        jobid => 'integer not null', # bigint unsigned not null
        funcid => 'integer not null', # int unsigned not null default 0
        message => 'string(255) not null', # varchar(255) not null
        error_time => 'integer not null', # integer unsigned not null
    },
    datasource  => 'ts_error',
    indexes => {
        error_time => 1,
        jobid => 1,
        funcid => 1,
    },
    defaults => {
        funcid => 0,
    }
    # not captured:
    # index (funcid, error_time)
});

1;
