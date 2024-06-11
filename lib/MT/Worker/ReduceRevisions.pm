# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Worker::ReduceRevisions;

use strict;
use warnings;
use base qw(TheSchwartz::Worker);

use TheSchwartz::Job;

sub work {
    my $class = shift;
    my TheSchwartz::Job $job = shift;
    $job->completed();
}

sub grab_for    {120}
sub max_retries {0}
sub retry_delay {120}

1;
