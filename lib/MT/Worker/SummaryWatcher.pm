# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package MT::Worker::SummaryWatcher;

use strict;
use base qw( TheSchwartz::Worker );
use MT::Summary;

use TheSchwartz::Job;

sub work {
    my $class                = shift;
    my TheSchwartz::Job $job = shift;
    #my $registry            = MT->registry;
    my $registry            = MT->registry("summaries");
    use Data::Dumper;
    #for my $summarizable ( keys %{ $registry->{summaries} } ) {
    for my $summarizable ( keys %{ $registry } ) {
        my $meta_pkg = MT->model($summarizable)->meta_pkg('summary');
        my $summ_iter
            = $meta_pkg->search( { expired => MT::Summary::NEEDS_JOB(), } );
        my $class = MT->model($summarizable);
        my $id_field = ( $class->class_type || $class->datasource ) . '_id';
        while ( my $summary = $summ_iter->() ) {
            my $priority
#                = $registry->{summaries}->{$summarizable}->{ $summary->class }
                = $registry->{$summarizable}->{ $summary->class }
                ->{priority};
            $priority ||= undef;
            my $id        = $summary->$id_field;
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
