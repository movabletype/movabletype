# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::TheSchwartz::Job;

use strict;
use warnings;
use base qw( MT::Object );

__PACKAGE__->install_properties(
    {   column_defs => {
            jobid => 'integer not null auto_increment'
            ,    # bigint unsigned primary key not null auto_increment
            funcid        => 'integer not null',   # int unsigned not null
            arg           => 'blob',               # mediumblob
            uniqkey       => 'string(255)',        # varchar(255) null
            insert_time   => 'integer',            # integer unsigned
            run_after     => 'integer not null',   # integer unsigned not null
            grabbed_until => 'integer not null',   # integer unsigned not null
            priority      => 'integer',            # smallint unsigned
            coalesce      => 'string(255)',        # varchar(255)
        },
        datasource  => 'ts_job',
        primary_key => 'jobid',
        indexes     => {
            funccoal => { columns => [ 'funcid', 'coalesce' ], },
            funcrun  => { columns => [ 'funcid', 'run_after' ], },
            funcpri  => { columns => [ 'funcid', 'priority' ], },
            uniqfunc => {
                columns => [ 'funcid', 'uniqkey' ],
                unique  => 1,
            },
        },
        role => q{global},
    }
);

sub class_label {
    MT->translate("Job");
}

1;
