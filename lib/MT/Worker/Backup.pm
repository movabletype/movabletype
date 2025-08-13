# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Worker::Backup;

use strict;
use warnings;
use base qw( TheSchwartz::Worker );

use TheSchwartz::Job;
use MT::CMS::Tools;
use JSON;

sub work {
    my $class = shift;
    my TheSchwartz::Job $job = shift;

    # Build this
    my $mt = MT->instance;

    my $param = JSON->new->decode($job->arg);
    $param->{user} = MT->model('author')->load($param->{user_id});
    $param->{background} = 1;
    MT::CMS::Tools::_backup(%$param);

    # log and send notification
}

sub grab_for    {60}
sub max_retries {0}
sub retry_delay {60}

1;
