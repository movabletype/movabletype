# $Id: ExitStatus.pm 1098 2007-12-12 01:47:58Z hachi $

package TheSchwartz::ExitStatus;
use strict;
use base qw( Data::ObjectDriver::BaseObject );

__PACKAGE__->install_properties({
               columns     => [ qw( jobid status funcid
                                    completion_time delete_after ) ],
               datasource  => 'exitstatus',
               primary_key => 'jobid',
           });

1;
