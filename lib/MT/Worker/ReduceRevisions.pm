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

my $BULK_DELETE = 100;

sub work {
    my $class = shift;
    my TheSchwartz::Job $job = shift;

    require JSON;
    my $arg       = $job->arg ? JSON::decode_json($job->arg) : {};
    my $blog_id   = $arg->{blog_id};
    my $ds        = $arg->{ds};
    my $ds_label  = $arg->{ds_label};
    my $max       = $arg->{max};
    my $result    = $arg->{result};
    my $rev_class = MT->model($ds . ':revision');

    my $delete_count = 0;
    for my $row (@$result) {
        my $count = $row->{count};
        my $id    = $row->{id};
        my $plan = $count - $max;
        while ($plan > 0) {
            my $limit = $plan > $BULK_DELETE ? $BULK_DELETE : $plan;
            $plan -= $limit;
            my @ids = map { $_->id } $rev_class->load({
                    $ds . '_id' => $id
                }, {
                    fetchonly => { 'id' => 1 }, sort => 'created_on', direction => 'ascend',
                    limit     => $limit
                }
            );
            $delete_count += $rev_class->remove({ id => \@ids }, { nofetch => 1 });
        }
    }

    require MT::Util::Log;
    MT::Util::Log::init();
    MT->log({
        category => 'reduce_revisions',
        class    => 'system',
        level    => MT::Log::NOTICE(),
        message  => MT->translate('[_1] revisions have successfully removed.', $delete_count),
        metadata => MT->translate('Revision type ([_1])', MT->translate($ds_label)) . ' ' . MT->translate('Site ([_1])', $blog_id),
    });

    $job->completed();
}

sub grab_for    {120}
sub max_retries {0}
sub retry_delay {120}

1;
