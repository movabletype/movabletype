# Movable Type (r) (C) 2001-2009 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.

package MT::Worker::SummaryWatcher;

use strict;
use base qw( TheSchwartz::Worker );
use MT::Summary;

use TheSchwartz::Job;

sub work {
    my $class                = shift;
    my TheSchwartz::Job $job = shift;
    my $registry             = MT->registry;
    use Data::Dumper;
    for my $summarizable ( keys %{ $registry->{summaries} } ) {
        my $meta_pkg = MT->model($summarizable)->meta_pkg('summary');
        my $summ_iter
            = $meta_pkg->search( { expired => MT::Summary::NEEDS_JOB(), } );
        my $class = MT->model($summarizable);
        my $id_field = ( $class->class_type || $class->datasource ) . '_id';
        while ( my $summary = $summ_iter->() ) {
            my $priority
                = $registry->{summaries}->{$summarizable}->{ $summary->class }
                ->{priority};
            $priority ||= undef;
            my $id         = $summary->$id_field;
            my $class_type = MT->model($summarizable)->class_type
                || MT->model($summarizable)->datasource;
            MT::Summarizable->insert_summarize_worker( $class_type, $id,
                $summary->type, $priority );
            $summary->expired( MT::Summary::IN_QUEUE() );
            $summary->save;
        }
    }
    $job->completed();
}

sub grab_for    {120}
sub max_retries {0}
sub retry_delay {120}

1;
