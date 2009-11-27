# $Id: JobHandle.pm 1098 2007-12-12 01:47:58Z hachi $

package TheSchwartz::JobHandle;
use strict;
use base qw( Class::Accessor::Fast );

__PACKAGE__->mk_accessors(qw( dsn_hashed jobid client ));

use TheSchwartz::ExitStatus;
use TheSchwartz::Job;

sub new_from_string {
    my $class = shift;
    my($hstr) = @_;
    my($hashdsn, $jobid) = split /\-/, $hstr, 2;
    return TheSchwartz::JobHandle->new({
            dsn_hashed => $hashdsn,
            jobid      => $jobid,
        });
}

sub as_string {
    my $handle = shift;
    return join '-', $handle->dsn_hashed, $handle->jobid;
}

sub driver {
    my $handle = shift;
    unless (exists $handle->{__driver}) {
        $handle->{__driver} = $handle->client->driver_for($handle->dsn_hashed);
    }
    return $handle->{__driver};
}

sub job {
    my $handle = shift;
    my $job = $handle->client->lookup_job($handle->as_string) or return;
    $job->handle($handle);
    return $job;
}

sub is_pending {
    my $handle = shift;
    return $handle->job ? 1 : 0;
}

sub exit_status {
    my $handle = shift;
    my $status = $handle->driver->lookup(
            'TheSchwartz::ExitStatus' => $handle->jobid
        ) or return;
    return $status->status;
}

sub failure_log {
    my $handle = shift;
    my @failures = $handle->driver->search('TheSchwartz::Error' =>
            { jobid => $handle->jobid },
        );
    return map { $_->message } @failures;
}

sub failures {
    my $handle = shift;
    return scalar $handle->failure_log;
}

1;
