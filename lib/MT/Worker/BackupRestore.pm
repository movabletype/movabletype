# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Worker::BackupRestore;
use strict;
use warnings;
use base qw( TheSchwartz::Worker );
use TheSchwartz::Job;

sub work {
    my $class = shift;
    my TheSchwartz::Job $job = shift;

    require MT::CMS::Tools;

    my $method = (split /:/, $job->uniqkey)[0];

    eval {
        if ($method eq 'backup') {
            MT::CMS::Tools::backup_internal(@{ $job->arg });
        } elsif ($method eq 'restore') {
            MT::CMS::Tools::restore_internal(@{ $job->arg });
        }
    };

    if ($@) {
        $job->permanent_failure();
        die $@;
    } else {
        $job->completed();
    }
}

sub grab_for    { 1 }
sub max_retries { 10 }
sub retry_delay { 1 }

1;
