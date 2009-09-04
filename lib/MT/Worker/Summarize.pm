# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package MT::Worker::Summarize;

use strict;
use base qw( TheSchwartz::Worker );

use TheSchwartz::Job;

sub work {
    my $class                = shift;
    my TheSchwartz::Job $job = shift;
    my $hash                 = $job->arg;
    my ( $class_type, $object_id, $summary_type )
        = split( /:::/, $job->uniqkey );
    my ( $obj, $model );
    my $good = 1;
    if ( ! defined($class_type) or ! defined($object_id) or ! defined($summary_type) ) {
        MT::TheSchwartz->debug( qq{Bad MT::Worker::Summarize key: } . $job->uniqkey );
        $good = 0;
    }
    if ( $good ) {
        $model = MT->model( $class_type );
        if ( ! $model ) {
            MT::TheSchwartz->debug( qq{Bad MT::Worker::Summarize key (bad class type): } .
                $job->uniqkey );
            $good = 0;
        }
    }
    if ( $good ) {
        $obj = $model->load( $object_id );
        if ( ! $obj ) {
            MT::TheSchwartz->debug( qq{Bad MT::Worker::Summarize key (can't load object $object_id): } .
                $job->uniqkey );
            $good = 0;
        }
    }
    if ( $good ) {
        if ( ! $obj->has_summary ) {
            MT::TheSchwartz->debug( qq{Bad MT::Worker::Summarize key ($class_type not summarizable): } .
                $job->uniqkey );
            $good = 0;
        }
    }
    if ( $good ) {
        my $result;
        eval {
            $result = $obj->summarize( $summary_type );
        };
        if ( $@ ) {
            $job->failed( qq{MT::Worker::Summarize could not summarize } .
                    $job->uniqkey . ': ' . $@ );
            $good = 0;
        }
        else {
            $job->completed();
        }
    }
    else {
        # We've failed in a way we don't want to retry
        $job->completed();
    }
}

sub grab_for    {120}
sub max_retries {3}
sub retry_delay {120}

1;
