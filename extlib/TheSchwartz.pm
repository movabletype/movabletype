# $Id: TheSchwartz.pm 1406 2008-02-23 01:33:03Z bchoate $

package TheSchwartz;
use strict;
use fields qw( databases retry_seconds dead_dsns retry_at funcmap_cache verbose all_abilities current_abilities current_job cached_drivers driver_cache_expiration scoreboard prioritize );

our $VERSION = "1.07";

use Carp qw( croak );
use Data::ObjectDriver::Errors;
use Data::ObjectDriver::Driver::DBI;
use Digest::MD5 qw( md5_hex );
use List::Util qw( shuffle );
use TheSchwartz::FuncMap;
use TheSchwartz::Job;
use TheSchwartz::JobHandle;

use constant RETRY_DEFAULT => 30;
use constant OK_ERRORS => { map { $_ => 1 } Data::ObjectDriver::Errors->UNIQUE_CONSTRAINT, };

# test harness hooks
our $T_AFTER_GRAB_SELECT_BEFORE_UPDATE;
our $T_LOST_RACE;

## Number of jobs to fetch at a time in find_job_for_workers.
our $FIND_JOB_BATCH_SIZE = 50;

sub new {
    my TheSchwartz $client = shift;
    my %args = @_;
    $client = fields::new($client) unless ref $client;

    croak "databases must be an arrayref if specified"
        unless !exists $args{databases} || ref $args{databases} eq 'ARRAY';
    my $databases = delete $args{databases};

    $client->{retry_seconds} = delete $args{retry_seconds} || RETRY_DEFAULT;
    $client->set_prioritize(delete $args{prioritize});
    $client->set_verbose(delete $args{verbose});
    $client->set_scoreboard(delete $args{scoreboard});
    $client->{driver_cache_expiration} = delete $args{driver_cache_expiration} || 0;
    croak "unknown options ", join(', ', keys %args) if keys %args;

    $client->hash_databases($databases);
    $client->reset_abilities;
    $client->{dead_dsns} = {};
    $client->{retry_at} = {};
    $client->{funcmap_cache} = {};

    return $client;
}

sub debug {
    my TheSchwartz $client = shift;
    return unless $client->{verbose};
    $client->{verbose}->(@_);  # ($msg, $job)   but $job is optional
}

sub hash_databases {
    my TheSchwartz $client = shift;
    my($list) = @_;
    for my $ref (@$list) {
        my $full = join '|', map { $ref->{$_} || '' } qw( dsn user pass );
        $client->{databases}{ md5_hex($full) } = $ref;
    }
}

sub driver_for {
    my TheSchwartz $client = shift;
    my($hashdsn) = @_;
    my $driver;
    my $t = time;
    my $cache_duration = $client->{driver_cache_expiration};
    if ($cache_duration && $client->{cached_drivers}{$hashdsn}{create_ts} && $client->{cached_drivers}{$hashdsn}{create_ts} + $cache_duration > $t) {
        $driver = $client->{cached_drivers}{$hashdsn}{driver};
    } else {
        my $db = $client->{databases}{$hashdsn};
        $driver = Data::ObjectDriver::Driver::DBI->new(
                dsn      => $db->{dsn},
                username => $db->{user},
                password => $db->{pass},
                ($db->{prefix} ? (prefix   => $db->{prefix}) : ()),
        );
        if ($cache_duration) {
            $client->{cached_drivers}{$hashdsn}{driver} = $driver;
            $client->{cached_drivers}{$hashdsn}{create_ts} = $t;
        }
    }
    return $driver;
}

sub mark_database_as_dead {
    my TheSchwartz $client = shift;
    my($hashdsn) = @_;
    $client->{dead_dsns}{$hashdsn} = 1;
    $client->{retry_at}{$hashdsn} = time + $client->{retry_seconds};
}

sub is_database_dead {
    my TheSchwartz $client = shift;
    my($hashdsn) = @_;
    ## If this database is marked as dead, check the retry time. If
    ## it has passed, try the database again to see if it's undead.
    if ($client->{dead_dsns}{$hashdsn}) {
        if ($client->{retry_at}{$hashdsn} < time) {
            delete $client->{dead_dsns}{$hashdsn};
            delete $client->{retry_at}{$hashdsn};
            return 0;
        } else {
            return 1;
        }
    }
    return 0;
}

sub lookup_job {
    my TheSchwartz $client = shift;
    my $handle = $client->handle_from_string(@_);
    my $driver = $client->driver_for($handle->dsn_hashed);

    my $id = $handle->jobid;
    my $job = $driver->lookup('TheSchwartz::Job' => $handle->jobid)
        or return;

    $job->handle($handle);
    $job->funcname( $client->funcid_to_name($driver, $handle->dsn_hashed, $job->funcid) );
    return $job;
}

sub list_jobs {
    my TheSchwartz $client = shift;
    my $arg = shift;
    my @options;
    push @options, run_after     => { op => '<=', value => $arg->{run_after} }     if exists $arg->{run_after};
    push @options, grabbed_until => { op => '<=', value => $arg->{grabbed_until} } if exists $arg->{grabbed_until};
    die "No funcname" unless exists $arg->{funcname};

    $arg->{want_handle} = 1 unless defined $arg->{want_handle};
    my $limit = $arg->{limit} || $FIND_JOB_BATCH_SIZE;

    if ($arg->{coalesce}) {
        $arg->{coalesce_op} ||= '=';
        push @options, coalesce => { op => $arg->{coalesce_op}, value => $arg->{coalesce}};
    }

    my @jobs;
    for my $hashdsn ($client->shuffled_databases) {
        ## If the database is dead, skip it
        next if $client->is_database_dead($hashdsn);
        my $driver = $client->driver_for($hashdsn);
        my $funcid;
        if (ref($arg->{funcname})) {
            $funcid = [map { $client->funcname_to_id($driver, $hashdsn, $_) } @{$arg->{funcname}}];
        } else {
            $funcid = $client->funcname_to_id($driver, $hashdsn, $arg->{funcname});
        }

        if ($arg->{want_handle}) {
            push @jobs, map {
                my $handle = TheSchwartz::JobHandle->new({
                    dsn_hashed => $hashdsn,
                    client     => $client,
                    jobid      => $_->jobid
                    });
                $_->handle($handle);
                $_;
            } $driver->search('TheSchwartz::Job' => {
                funcid        => $funcid,
                @options
                }, { limit => $limit,
                    ( $client->prioritize ? ( sort => 'priority',
                    direction => 'descend' ) : () )
                });
        } else {
            push @jobs, $driver->search('TheSchwartz::Job' => {
                funcid        => $funcid,
                @options
                }, { limit => $limit,
                    ( $client->prioritize ? ( sort => 'priority',
                        direction => 'descend' ) : () )
                }
            );
        }
    }
    return @jobs;
}

sub find_job_with_coalescing_prefix {
    my TheSchwartz $client = shift;
    my ($funcname, $coval) = @_;
    $coval .= "%";
    return $client->_find_job_with_coalescing('LIKE', $funcname, $coval);
}

sub find_job_with_coalescing_value {
    my TheSchwartz $client = shift;
    return $client->_find_job_with_coalescing('=', @_);
}

sub _find_job_with_coalescing {
    my TheSchwartz $client = shift;
    my ($op, $funcname, $coval) = @_;

    for my $hashdsn ($client->shuffled_databases) {
        ## If the database is dead, skip it
        next if $client->is_database_dead($hashdsn);

        my $driver = $client->driver_for($hashdsn);
        my $unixtime = $driver->dbd->sql_for_unixtime;

        my @jobs;
        eval {
            ## Search for jobs in this database where:
            ## 1. funcname is in the list of abilities this $client supports;
            ## 2. the job is scheduled to be run (run_after is in the past);
            ## 3. no one else is working on the job (grabbed_until is in
            ##    in the past).
            my $funcid = $client->funcname_to_id($driver, $hashdsn, $funcname);

            @jobs = $driver->search('TheSchwartz::Job' => {
                    funcid        => $funcid,
                    run_after     => \ "<= $unixtime",
                    grabbed_until => \ "<= $unixtime",
                    coalesce      => { op => $op, value => $coval },
                }, { limit => $FIND_JOB_BATCH_SIZE,
                    ( $client->prioritize ? ( sort => 'priority',
                        direction => 'descend' ) : () )
                }
            );
        };
        if ($@) {
            unless (OK_ERRORS->{ $driver->last_error || 0 }) {
                $client->mark_database_as_dead($hashdsn);
            }
        }

        my $job = $client->_grab_a_job($hashdsn, @jobs);
        return $job if $job;
    }
}

sub find_job_for_workers {
    my TheSchwartz $client = shift;
    my($worker_classes) = @_;
    $worker_classes ||= $client->{current_abilities};

    for my $hashdsn ($client->shuffled_databases) {
        ## If the database is dead, skip it.
        next if $client->is_database_dead($hashdsn);

        my $driver = $client->driver_for($hashdsn);
        my $unixtime = $driver->dbd->sql_for_unixtime;

        my @jobs;
        eval {
            ## Search for jobs in this database where:
            ## 1. funcname is in the list of abilities this $client supports;
            ## 2. the job is scheduled to be run (run_after is in the past);
            ## 3. no one else is working on the job (grabbed_until is in
            ##    in the past).
            my @ids = map { $client->funcname_to_id($driver, $hashdsn, $_) }
                      @$worker_classes;

            @jobs = $driver->search('TheSchwartz::Job' => {
                    funcid        => \@ids,
                    run_after     => \ "<= $unixtime",
                    grabbed_until => \ "<= $unixtime",
                }, { limit => $FIND_JOB_BATCH_SIZE,
                    ( $client->prioritize ? ( sort => 'priority',
                    direction => 'descend' ) : () )
                }
            );
        };
        if ($@) {
            unless (OK_ERRORS->{ $driver->last_error || 0 }) {
                $client->mark_database_as_dead($hashdsn);
            }
        }

        # for test harness race condition testing
        $T_AFTER_GRAB_SELECT_BEFORE_UPDATE->() if $T_AFTER_GRAB_SELECT_BEFORE_UPDATE;

        my $job = $client->_grab_a_job($hashdsn, @jobs);
        return $job if $job;
    }
}

sub get_server_time {
    my TheSchwartz $client = shift;
    my($driver) = @_;
    my $unixtime_sql = $driver->dbd->sql_for_unixtime;
    return $driver->rw_handle->selectrow_array("SELECT $unixtime_sql");
}

sub _grab_a_job {
    my TheSchwartz $client = shift;
    my $hashdsn = shift;
    my $driver = $client->driver_for($hashdsn);

    ## Got some jobs! Randomize them to avoid contention between workers.
    my @jobs = shuffle(@_);

  JOB:
    while (my $job = shift @jobs) {
        ## Convert the funcid to a funcname, based on this database's map.
        $job->funcname( $client->funcid_to_name($driver, $hashdsn, $job->funcid) );

        ## Update the job's grabbed_until column so that
        ## no one else takes it.
        my $worker_class = $job->funcname;
        my $old_grabbed_until = $job->grabbed_until;

        my $server_time = $client->get_server_time($driver)
            or die "expected a server time";

        $job->grabbed_until($server_time + ($worker_class->grab_for || 1));

        ## Update the job in the database, and end the transaction.
        if ($driver->update($job, { grabbed_until => $old_grabbed_until }) < 1) {
            ## We lost the race to get this particular job--another worker must
            ## have got it and already updated it. Move on to the next job.
            $T_LOST_RACE->() if $T_LOST_RACE;
            next JOB;
        }

        ## Now prepare the job, and return it.
        my $handle = TheSchwartz::JobHandle->new({
            dsn_hashed => $hashdsn,
            jobid      => $job->jobid,
        });
        $handle->client($client);
        $job->handle($handle);
        return $job;
    }

    return undef;
}


sub shuffled_databases {
    my TheSchwartz $client = shift;
    my @dsns = keys %{ $client->{databases} };
    return shuffle(@dsns);
}

sub insert_job_to_driver {
    my $client = shift;
    my($job, $driver, $hashdsn) = @_;
    eval {
        ## Set the funcid of the job, based on the funcname. Since each
        ## database has a separate cache, this needs to be calculated based
        ## on the hashed DSN. Also: this might fail, if the database is dead.
        $job->funcid( $client->funcname_to_id($driver, $hashdsn, $job->funcname) );

        ## This is sub-optimal because of clock skew, but something is
        ## better than a NULL value. And currently, nothing in TheSchwartz
        ## code itself uses insert_time. TODO: use server time, but without
        ## having to do a roundtrip just to get the server time.
        $job->insert_time(time);

        ## Now, insert the job. This also might fail.
        $driver->insert($job);
    };
    if ($@) {
        unless (OK_ERRORS->{ $driver->last_error || 0 }) {
            $client->mark_database_as_dead($hashdsn);
        }
    } elsif ($job->jobid) {
        ## We inserted the job successfully!
        ## Attach a handle to the job, and return the handle.
        my $handle = TheSchwartz::JobHandle->new({
                dsn_hashed => $hashdsn,
                client     => $client,
                jobid      => $job->jobid
            });
        $job->handle($handle);
        return $handle;
    }
    return undef;
}

sub insert_jobs {
    my TheSchwartz $client = shift;
    my (@jobs) = @_;

    ## Try each of the databases that are registered with $client, in
    ## random order. If we successfully create the job, exit the loop.
    my @handles;
  DATABASE:
    for my $hashdsn ($client->shuffled_databases) {
        ## If the database is dead, skip it.
        next if $client->is_database_dead($hashdsn);

        my $driver = $client->driver_for($hashdsn);
        $driver->begin_work;
        for my $j (@jobs) {
            my $h = $client->insert_job_to_driver($j, $driver, $hashdsn);
            if ($h) {
                push @handles, $h;
            } else {
                $driver->rollback;
                @handles = ();
                next DATABASE;
            }
        }
        last if eval { $driver->commit };
        @handles = ();
        next DATABASE;
    }

    return wantarray ? @handles : scalar @handles;
}

sub insert {
    my TheSchwartz $client = shift;
    my $job = shift;
    if (ref($_[0]) eq "TheSchwartz::Job") {
        croak "Can't insert multiple jobs with method 'insert'\n";
    }
    unless (ref($job) eq 'TheSchwartz::Job') {
        $job = TheSchwartz::Job->new_from_array($job, $_[0]);
    }

    ## Try each of the databases that are registered with $client, in
    ## random order. If we successfully create the job, exit the loop.
    for my $hashdsn ($client->shuffled_databases) {
        ## If the database is dead, skip it.
        next if $client->is_database_dead($hashdsn);

        my $driver = $client->driver_for($hashdsn);

        ## Try to insert the job into this database. If we get a handle
        ## back, return it.
        my $handle = $client->insert_job_to_driver($job, $driver, $hashdsn);
        return $handle if $handle;
    }

    ## If the job wasn't submitted successfully to any database, return.
    return undef;
}

sub handle_from_string {
    my TheSchwartz $client = shift;
    my $handle = TheSchwartz::JobHandle->new_from_string(@_);
    $handle->client($client);
    return $handle;
}

sub can_do {
    my TheSchwartz $client = shift;
    my($class) = @_;
    push @{ $client->{all_abilities} }, $class;
    push @{ $client->{current_abilities} }, $class;
}

sub reset_abilities {
    my TheSchwartz $client = shift;
    $client->{all_abilities} = [];
    $client->{current_abilities} = [];
}

sub restore_full_abilities {
    my $client = shift;
    $client->{current_abilities} = [ @{ $client->{all_abilities} } ];
}

sub temporarily_remove_ability {
    my $client = shift;
    my($class) = @_;
    $client->{current_abilities} = [
            grep { $_ ne $class } @{ $client->{current_abilities} }
        ];
    if (!@{ $client->{current_abilities} }) {
        $client->restore_full_abilities;
    }
}

sub work_on {
    my TheSchwartz $client = shift;
    my $hstr = shift;  # Handle string
    my $job = $client->lookup_job($hstr) or
        return 0;
    return $client->work_once($job);
}

sub work {
    my TheSchwartz $client = shift;
    my($delay) = @_;
    $delay ||= 5;
    while (1) {
        sleep $delay unless $client->work_once;
    }
}

sub work_until_done {
    my TheSchwartz $client = shift;
    while (1) {
        $client->work_once or last;
    }
}

## Returns true if it did something, false if no jobs were found
sub work_once {
    my TheSchwartz $client = shift;
    my $job = shift;  # optional specific job to work on

    ## Look for a job with our current set of abilities. Note that the
    ## list of current abilities may not be equal to the full set of
    ## abilities, to allow for even distribution between jobs.
    $job ||= $client->find_job_for_workers;

    ## If we didn't find anything, restore our full abilities, and try
    ## again.
    if (!$job &&
        @{ $client->{current_abilities} } < @{ $client->{all_abilities} }) {
        $client->restore_full_abilities;
        $job = $client->find_job_for_workers;
    }

    my $class = $job ? $job->funcname : undef;
    if ($job) {
        my $priority = $job->priority ? ", priority " . $job->priority : "";
        $job->debug("TheSchwartz::work_once got job of class '$class'$priority");
    } else {
        $client->debug("TheSchwartz::work_once found no jobs");
    }

    ## If we still don't have anything, return.
    return unless $job;

    ## Now that we found a job for this particular funcname, remove it
    ## from our list of current abilities. So the next time we look for a
    ## we'll find a job for a different funcname. This prevents starvation of
    ## high funcid values because of the way MySQL's indexes work.
    $client->temporarily_remove_ability($class);

    $class->work_safely($job);

    ## We got a job, so return 1 so work_until_done (which calls this method)
    ## knows to keep looking for jobs.
    return 1;
}

sub funcid_to_name {
    my TheSchwartz $client = shift;
    my($driver, $hashdsn, $funcid) = @_;
    my $cache = $client->_funcmap_cache($hashdsn);
    return $cache->{funcid2name}{$funcid};
}

sub funcname_to_id {
    my TheSchwartz $client = shift;
    my($driver, $hashdsn, $funcname) = @_;
    my $cache = $client->_funcmap_cache($hashdsn);
    unless (exists $cache->{funcname2id}{$funcname}) {
        my $map = TheSchwartz::FuncMap->create_or_find($driver, $funcname);
        $cache->{funcname2id}{ $map->funcname } = $map->funcid;
        $cache->{funcid2name}{ $map->funcid }   = $map->funcname;
    }
    return $cache->{funcname2id}{$funcname};
}

sub _funcmap_cache {
    my TheSchwartz $client = shift;
    my($hashdsn) = @_;
    unless (exists $client->{funcmap_cache}{$hashdsn}) {
        my $driver = $client->driver_for($hashdsn);
        my @maps = $driver->search('TheSchwartz::FuncMap');
        my $cache = { funcname2id => {}, funcid2name => {} };
        for my $map (@maps) {
            $cache->{funcname2id}{ $map->funcname } = $map->funcid;
            $cache->{funcid2name}{ $map->funcid }   = $map->funcname;
        }
        $client->{funcmap_cache}{$hashdsn} = $cache;
    }
    return $client->{funcmap_cache}{$hashdsn};
}

# accessors

sub verbose {
    my TheSchwartz $client = shift;
    return $client->{verbose};
}

sub set_verbose {
    my TheSchwartz $client = shift;
    my $logger = shift;   # or non-coderef to just print to stderr
    if ($logger && ref $logger ne "CODE") {
        $logger = sub {
            my $msg = shift;
            $msg =~ s/\s+$//;
            print STDERR "$msg\n";
        };
    }
    $client->{verbose} = $logger;
}

sub scoreboard {
    my TheSchwartz $client = shift;

    return $client->{scoreboard};
}

sub set_scoreboard {
    my TheSchwartz $client = shift;
    my ($dir) = @_;

    return unless $dir;

    # They want the scoreboard but don't care where it goes
    if (($dir eq '1') or ($dir eq 'on')) {
        # Find someplace in tmpfs to save this
        foreach my $d (qw(/var/run /dev/shm)) {
            $dir = $d;
            last if -e $dir;
        }
    }

    $dir .= '/theschwartz';
    unless (-e $dir) {
        mkdir($dir, 0755) or die "Can't create scoreboard directory '$dir': $!";
    }

    $client->{scoreboard} = $dir."/scoreboard.$$";
}

sub start_scoreboard {
    my TheSchwartz $client = shift;

    # Don't do anything if we're not configured to write to the scoreboard
    my $scoreboard = $client->scoreboard;
    return unless $scoreboard;

    # Don't do anything of (for some reason) we don't have a current job
    my $job = $client->current_job;
    return unless $job;

    my $class = $job->funcname;

    open(SB, '>', $scoreboard)
      or $job->debug("Could not write scoreboard '$scoreboard': $!");
    print SB join("\n", ("pid=$$",
                         'funcname='.($class||''),
                         'started='.($job->grabbed_until-($class->grab_for||1)),
                         'arg='._serialize_args($job->arg),
                        )
                 ), "\n";
    close(SB);

    return;
}

# Quick and dirty serializer.  Don't use Data::Dumper because we don't need to
# recurse indefinitely and we want to truncate the output produced
sub _serialize_args {
    my ($args) = @_;

    if (ref $args) {
        if (ref $args eq 'HASH') {
            return join ',',
                   map { ($_||'').'='.substr($args->{$_}||'', 0, 200) }
                   keys %$args;
        } elsif (ref $args eq 'ARRAY') {
            return join ',',
                   map { substr($_||'', 0, 200) }
                   @$args;
        }
    } else {
        return $args;
    }
}

sub end_scoreboard {
    my TheSchwartz $client = shift;

    # Don't do anything if we're not configured to write to the scoreboard
    my $scoreboard = $client->scoreboard;
    return unless $scoreboard;

    my $job = $client->current_job;

    open(SB, '>>', $scoreboard)
      or $job->debug("Could not append scoreboard '$scoreboard': $!");
    print SB "done=".time."\n";
    close(SB);

    return;
}

sub clean_scoreboard {
    my TheSchwartz $client = shift;

    # Don't do anything if we're not configured to write to the scoreboard
    my $scoreboard = $client->scoreboard;
    return unless $scoreboard;

    unlink($scoreboard);
}

sub prioritize {
    my TheSchwartz $client = shift;
    return $client->{prioritize};
}

sub set_prioritize {
    my TheSchwartz $client = shift;
    $client->{prioritize} = shift;
}

# current job being worked.  so if something dies, work_safely knows which to mark as dead.
sub current_job {
    my TheSchwartz $client = shift;
    $client->{current_job};
}

sub set_current_job {
    my TheSchwartz $client = shift;
    $client->{current_job} = shift;
}

DESTROY {
    foreach my $arg (@_) {
        # Call 'clean_scoreboard' on TheSchwartz objects
        if (ref($arg) and $arg->isa('TheSchwartz')) {
            $arg->clean_scoreboard;
        }
    }
}

1;

__END__

=head1 NAME

TheSchwartz - reliable job queue

=head1 SYNOPSIS

    # MyApp.pm
    package MyApp;

    sub work_asynchronously {
        my %args = @_;

        my $client = TheSchwartz->new( databases => $DATABASE_INFO );
        $client->insert('MyWorker', \%args);
    }


    # myworker.pl
    package MyWorker;
    use base qw( TheSchwartz::Worker );

    sub work {
        my $class = shift;
        my TheSchwartz::Job $job = shift;

        print "Workin' hard or hardly workin'? Hyuk!!\n";

        $job->completed();
    }

    package main;

    my $client = TheSchwartz->new( databases => $DATABASE_INFO );
    $client->can_do('MyWorker');
    $client->work();


=head1 DESCRIPTION

TheSchwartz is a reliable job queue system. Your application can put jobs into
the system, and your worker processes can pull jobs from the queue atomically
to perform. Failed jobs can be left in the queue to retry later.

I<Abilities> specify what jobs a worker process can perform. Abilities are the
names of C<TheSchwartz::Worker> subclasses, as in the synopsis: the C<MyWorker>
class name is used to specify that the worker script can perform the job. When
using the C<TheSchwartz> client's C<work> functions, the class-ability duality
is used to automatically dispatch to the proper class to do the actual work.

TheSchwartz clients will also prefer to do jobs for unused abilities before
reusing a particular ability, to avoid exhausting the supply of one kind of job
while jobs of other types stack up.

Some jobs with high setup times can be performed more efficiently if a group of
related jobs are performed together. TheSchwartz offers a facility to
I<coalesce> jobs into groups, which a properly constructed worker can find and
perform at once. For example, if your worker were delivering email, you might
store the domain name from the recipient's address as the coalescing value. The
worker that grabs that job could then batch deliver all the mail for that
domain once it connects to that domain's mail server.

=head1 USAGE

=head2 C<TheSchwartz-E<gt>new( %args )>

Optional members of C<%args> are:

=over 4

=item * C<databases>

An arrayref of database information. TheSchwartz workers can use multiple
databases, such that if any of them are unavailable, the worker will search for
appropriate jobs in the other databases automatically.

Each member of the C<databases> value should be a hashref containing:

=over 4

=item * C<dsn>

The database DSN for this database.

=item * C<user>

The username to use when connecting to this database.

=item * C<pass>

The password to use when connecting to this database.

=back

=item * C<verbose>

A value indicating whether to log debug messages. If C<verbose> is a coderef,
it is called to log debug messages. If C<verbose> is not a coderef but is some
other true value, debug messages will be sent to C<STDERR>. Otherwise, debug
messages will not be logged.

=item * C<prioritize>

A value indicating whether to utilize the job 'priority' field when selecting
jobs to be processed. If unspecified, jobs will always be executed in a
randomized order.

=item * C<driver_cache_expiration>

Optional value to control how long database connections are cached for in seconds.
By default, connections are not cached. To re-use the same database connection for
five minutes, pass driver_cache_expiration => 300 to the constructor. Improves job
throughput in cases where the work to process a job is small compared to the database
connection set-up and tear-down time.

=item * C<retry_seconds>

The number of seconds after which to try reconnecting to apparently dead
databases. If not given, TheSchwartz will retry connecting to databases after
30 seconds.

=back

=head2 C<$client-E<gt>list_jobs( %args )>

Returns a list of C<TheSchwartz::Job> objects matching the given arguments. The
required members of C<%args> are:

=over 4

=item * C<funcname>

the name of the function or a reference to an array of functions

=item * C<run_after>

the value you want to check <= against on the run_after column

=item * C<grabbed_until>

the value you want to check <= against on the grabbed_until column

=item * C<coalesce_op>

defaults to '=', set it to whatever you want to compare the coalesce field too
if you want to search, you can use 'LIKE'

=item * C<coalesce>

coalesce value to search for, if you set op to 'LIKE' you can use '%' here,
do remember that '%' searches anchored at the beginning of the string are
much faster since it is can do a btree index lookup

=item * C<want_handle>

if you want all your jobs to be set up using a handle.  defaults to true.
this option might be removed, as you should always have this on a Job object.

=back

It is important to remember that this function doesnt lock anything, it just
returns as many jobs as there is up to amount of databases * FIND_JOB_BATCH_SIZE

=head2 C<$client-E<gt>lookup_job( $handle_id )>

Returns a C<TheSchwartz::Job> corresponding to the given handle ID.

=head2 C<$client-E<gt>set_verbose( $verbose )>

Sets the current logging function to C<$verbose> if it's a coderef. If not a
coderef, enables debug logging to C<STDERR> if C<$verbose> is true; otherwise,
disables logging.

=head1 POSTING JOBS

The methods of TheSchwartz clients used by applications posting jobs to the
queue are:

=head2 C<$client-E<gt>insert( $job )>

Adds the given C<TheSchwartz::Job> to one of the client's job databases.

=head2 C<$client-E<gt>insert( $funcname, $arg )>

Adds a new job with funcname C<$funcname> and arguments C<$arg> to the queue.

=head2 C<$client-E<gt>insert_jobs( @jobs )>

Adds the given C<TheSchwartz::Job> objects to one of the client's job
databases. All the given jobs are recorded in I<one> job database.

=head1 WORKING

The methods of TheSchwartz clients for use in worker processes are:

=head2 C<$client-E<gt>can_do( $ability )>

Adds C<$ability> to the list of abilities C<$client> is capable of performing.
Subsequent calls to that client's C<work> methods will find jobs requiring the
given ability.

=head2 C<$client-E<gt>work_once()>

Find and perform one job C<$client> can do.

=head2 C<$client-E<gt>work_until_done()>

Find and perform jobs C<$client> can do until no more such jobs are found in
any of the client's job databases.

=head2 C<$client-E<gt>work( [$delay] )>

Find and perform any jobs C<$client> can do, forever. When no job is available,
the working process will sleep for C<$delay> seconds (or 5, if not specified)
before looking again.

=head2 C<$client-E<gt>work_on($handle)>

Given a job handle (a scalar string) I<$handle>, runs the job, then returns.

=head2 C<$client-E<gt>find_job_for_workers( [$abilities] )>

Returns a C<TheSchwartz::Job> for a random job that the client can do. If
specified, the job returned matches one of the abilities in the arrayref
C<$abilities>, rather than C<$client>'s abilities.

=head2 C<$client-E<gt>find_job_with_coalescing_value( $ability, $coval )>

Returns a C<TheSchwartz::Job> for a random job for a worker capable of
C<$ability> and with a coalescing value of C<$coval>.

=head2 C<$client-E<gt>find_job_with_coalescing_prefix( $ability, $coval )>

Returns a C<TheSchwartz::Job> for a random job for a worker capable of
C<$ability> and with a coalescing value beginning with C<$coval>.

Note the C<TheSchwartz> implementation of this function uses a C<LIKE> query to
find matching jobs, with all the attendant performance implications for your
job databases.

=head2 C<$client-E<gt>get_server_time( $driver )>

Given an open driver I<$driver> to a database, gets the current server time from the database.

=head1 COPYRIGHT, LICENSE & WARRANTY

This software is Copyright 2007-2010, Six Apart Ltd, cpan@sixapart.com. All
rights reserved.

TheSchwartz is free software; you may redistribute it and/or modify it
under the same terms as Perl itself.

TheScwhartz comes with no warranty of any kind.

=cut

