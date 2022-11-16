# $Id$

package Data::ObjectDriver::Driver::DBD::MariaDB;
use strict;
use warnings;
use base qw( Data::ObjectDriver::Driver::DBD::mysql );

sub fetch_id { $_[3]->{mariadb_insertid} || $_[3]->{insertid} }

1;
