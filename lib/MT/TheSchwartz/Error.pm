# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::TheSchwartz::Error;

use strict;
use warnings;
use base qw( MT::Object );

__PACKAGE__->install_properties(
    {   column_defs => {
            jobid   => 'integer not null',   # bigint unsigned not null
            funcid  => 'integer not null',   # int unsigned not null default 0
            message => 'text not null',      # text not null
            error_time => 'integer not null',    # integer unsigned not null
        },
        datasource => 'ts_error',
        indexes    => {
            jobid       => 1,
            error_time  => 1,
            funcid_time => { columns => [ 'funcid', 'error_time' ], },
            clustered =>
                { columns => [ 'jobid', 'funcid' ], ms_clustered => 1, },
        },
        defaults  => { funcid => 0, },
        cacheable => 0,
    }
);

sub class_label {
    MT->translate("Job Error");
}

1;
