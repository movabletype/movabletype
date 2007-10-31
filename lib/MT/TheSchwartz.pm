package MT::TheSchwartz;

use strict;
use base qw( TheSchwartz );
use MT::ObjectDriver::Driver::DBI;

my $instance;

sub instance {
    return $instance;
}

sub debug {
    my $class = shift;
    return unless $instance;
    $instance->SUPER::debug(@_);
}

sub new {
    my $class = shift;
    $class->mt_schwartz_init();
    my (%param) = @_;
    my $workers = delete $param{workers} if exists $param{workers};

    my $client = $class->SUPER::new(%param);

    if ($client) {
        $instance = $client;
        unless ( $workers ) {
            $workers = [];

            my $all_workers ||= MT->registry("task_workers") || {};

            foreach my $id (keys %$all_workers) {
                my $w = $all_workers->{$id};
                my $c = $w->{class} or next;
                push @$workers, $c;
            }
        }

        if (@$workers) {
            # Can we do this?
            foreach my $c ( @$workers ) {
                if (eval('require ' . $c)) {
                    # Yes, we can do this.
                    $client->can_do( $c );
                } else {
                    # No, we can't. Here's why...
                    print STDERR "Failed to load worker class '$c': $@\n";
                }
            }
        }
    }

    return $client;
}

our $initialized;

sub mt_schwartz_init {
    return if $initialized;

    # Update the datasource for these, since MT adds an addition 'schwartz_'
    # prefix for them.
    require TheSchwartz::FuncMap;
    require TheSchwartz::Job;
    require TheSchwartz::Error;
    require TheSchwartz::ExitStatus;
    TheSchwartz::FuncMap->properties->{datasource}    = 'ts_funcmap';
    TheSchwartz::Job->properties->{datasource}        = 'ts_job';
    TheSchwartz::Error->properties->{datasource}      = 'ts_error';
    TheSchwartz::ExitStatus->properties->{datasource} = 'ts_exitstatus';
    return $initialized = 1;
}

sub driver_for {
    my MT::TheSchwartz $client = shift;
    my ($hashdsn) = @_;
    my $driver;
    my $t              = time;
    my $cache_duration = $client->{driver_cache_expiration};
    if (   $cache_duration
        && $client->{cached_drivers}{$hashdsn}{create_ts}
        && $client->{cached_drivers}{$hashdsn}{create_ts} + $cache_duration >
        $t )
    {
        $driver = $client->{cached_drivers}{$hashdsn}{driver};
    }
    else {
        my $db = $client->{databases}{$hashdsn};
        $driver = MT::ObjectDriver::Driver::DBI->new(
            dsn      => $db->{dsn},
            username => $db->{user},
            password => $db->{pass},
            dbd      => 'MT::ObjectDriver::Driver::DBD::mysql',
        );
        # TheSchwartz expects errors to be raised by the
        # database, so lets make sure they are...
        $driver->{connection_options}{RaiseError} = 1;
        if ($cache_duration) {
            $client->{cached_drivers}{$hashdsn}{driver}    = $driver;
            $client->{cached_drivers}{$hashdsn}{create_ts} = $t;
        }
    }
    return $driver;
}

1;
