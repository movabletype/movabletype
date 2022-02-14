package Daemon::Device;
# ABSTRACT: Forking daemon device construct

use 5.012;
use strict;
use warnings;

use Daemon::Control;
use Carp qw( croak carp );
use POSIX ":sys_wait_h";
use IO::Pipe;

our $VERSION = '1.09'; # VERSION

sub new {
    my $class = shift;
    croak 'new() called with uneven number of parameters' if ( @_ % 2 );

    my $self = bless( {@_}, $class );

    $self->{ '_' . $_ } = delete $self->{$_} for ( qw(
        daemon
        spawn
        replace_children
        parent_hup_to_child
        parent
        child
        on_startup
        on_shutdown
        on_spawn
        on_parent_hup
        on_child_hup
        on_parent_death
        on_child_death
        on_replace_child
        on_message
        data
    ) );

    if ( not $self->{_daemon}{user} ) {
        my $user = getlogin || getpwuid($<) || 'root';
        $self->{_daemon}{user} ||= $user;
    }
    $self->{_daemon}{group} ||= ( getgrgid( (getpwnam( $self->{_daemon}{user} ) )[3] ) )[0];

    croak 'new() called without "daemon" parameter as a hashref' unless ( ref( $self->{_daemon} ) eq 'HASH' );
    for ( qw( program program_args ) ) {
        croak qq{new() called with "daemon" hashref containing "$_" key} if ( $self->{_daemon}{$_} );
    }
    for ( qw(
        parent child
        on_startup on_shutdown on_spawn on_parent_hup on_child_hup
        on_parent_death on_child_death on_replace_child
    ) ) {
        croak qq{new() called with "$_" parameter not a coderef}
            if ( exists $self->{$_} and ref( $self->{$_} ) ne 'CODE' );
    }

    $self->{_daemon}{program}      = \&_parent;
    $self->{_daemon}{program_args} = [$self];

    $self->{_spawn}               ||= 1;
    $self->{_replace_children}    //= 1;
    $self->{_parent_hup_to_child} //= 1;
    $self->{_data}                //= {};

    $self->{_children} = [];
    $self->{_daemon}   = Daemon::Control->new( %{ $self->{_daemon} } );

    return $self;
}

sub run {
    my ($self) = @_;
    return $self->{_daemon}->run;
}

sub daemon {
    my ($self) = @_;
    return $self->{_daemon};
}

sub _parent {
    my ( $daemon, $self ) = @_;

    $self->{_ppid} = $$;

    $SIG{'HUP'} = sub {
        $self->{_on_parent_hup}->($self) if ( $self->{_on_parent_hup} );
        if ( $self->{_parent_hup_to_child} ) {
            kill( 'HUP', $_->{pid} ) for ( @{ $self->{_children} } );
        }
    };

    my $terminate = sub {
        $self->{_on_parent_death}->($self) if ( $self->{_on_parent_death} );
        kill( 'TERM', $_->{pid} ) for ( @{ $self->{_children} } );
        $self->{_on_shutdown}->($self) if ( $self->{_on_shutdown} );
        exit;
    };
    $SIG{$_} = $terminate for ( qw( TERM INT ABRT QUIT ) );

    $SIG{'CHLD'} = sub {
        if ( $self->{_replace_children} ) {
            $self->{_on_replace_child}->($self) if ( $self->{_on_replace_child} );
            for ( @{ $self->{_children} } ) {
                $_ = _spawn($self) if ( waitpid( $_->{pid}, WNOHANG ) );
            }
        }
    };

    $SIG{'URG'} = sub {
        if ( $self->{_on_message} ) {
            my @messages = map { split(/\r?\n/) } map { $_->{io_up}->getlines } @{ $self->{_children} };
            $self->{_on_message}->( $self, @messages );
        }
    };

    $self->{_on_startup}->($self) if ( $self->{_on_startup} );

    for ( 1 .. $self->{_spawn} ) {
        push( @{ $self->{_children} }, _spawn($self) );
    }

    if ( $self->{_parent} ) {
        $self->{_parent}->($self);
    }
    else {
        wait;
    }

    return;
}

sub _spawn {
    my ($self) = @_;

    $self->{_on_spawn}->($self) if ( $self->{_on_spawn} );

    my ( $io_up, $io_dn );
    if ( $self->{_on_message} ) {
        $io_up = IO::Pipe->new;
        $io_dn = IO::Pipe->new;
    }

    if ( my $pid = fork ) {
        my $child_data = { pid => $pid };

        if ( $self->{_on_message} ) {
            $io_up->reader;
            $io_dn->writer;
            for ( $io_up, $io_dn ) {
                $_->autoflush;
                $_->blocking(0);
            }
            $child_data->{io_up} = $io_up;
            $child_data->{io_dn} = $io_dn;
        }

        return $child_data;
    }
    else {
        if ( $self->{_on_message} ) {
            $io_up->writer;
            $io_dn->reader;
            for ( $io_up, $io_dn ) {
                $_->autoflush;
                $_->blocking(0);
            }
            $self->{_io_up} = $io_up;
            $self->{_io_dn} = $io_dn;
        }

        $self->{_cpid} = $$;
        _child($self);
        exit;
    }

    return;
}

sub _child {
    my ($self) = @_;

    $SIG{'HUP'} = sub {
        $self->{_on_child_hup}->($self) if ( $self->{_on_child_hup} );
    };

    my $terminate = sub {
        $self->{_on_child_death}->($self) if ( $self->{_on_child_death} );
        exit;
    };
    $SIG{$_} = $terminate for ( qw( TERM INT ABRT QUIT ) );

    $SIG{'URG'} = sub {
        if ( $self->{_on_message} ) {
            my @messages = map { split(/\r?\n/) } $self->{_io_dn}->getlines;
            $self->{_on_message}->( $self, @messages );
        }
    };

    if ( $self->{_child} ) {
        $self->{_child}->($self);
    }
    else {
        while (1) {
            exit unless ( $self->parent_alive );
            sleep 1;
        }
    }

    return;
}

sub ppid {
    return shift->{_ppid};
}

sub cpid {
    return shift->{_cpid};
}

sub children {
    return [ map { $_->{pid} } @{ shift->{_children} } ];
}

sub adjust_spawn {
    my ( $self, $new_spawn_count ) = @_;
    $self->{_spawn} = $new_spawn_count;

    if ( @{ $self->{_children} } > 0 and @{ $self->{_children} } < $self->{_spawn} ) {
        push( @{ $self->{_children} }, _spawn($self) ) while ( @{ $self->{_children} } < $self->{_spawn} );
    }
    elsif ( @{ $self->{_children} } > 0 and @{ $self->{_children} } > $self->{_spawn} ) {
        my $set_replace_children = $self->{_replace_children};
        $self->{_replace_children} = 0;

        my @killed_pids;
        while ( @{ $self->{_children} } > $self->{_spawn} ) {
            my $child = shift @{ $self->{_children} };
            kill( 'TERM', $child->{pid} );
            push( @killed_pids, $child->{pid} );
        }

        waitpid( $_, 0 ) for (@killed_pids);
        $self->{_replace_children} = $set_replace_children;
    }

    return;
}

sub replace_children {
    my $self = shift;
    $self->{_replace_children} = $_[0] if (@_);
    return $self->{_replace_children};
}

sub parent_hup_to_child {
    my $self = shift;
    $self->{_parent_hup_to_child} = $_[0] if (@_);
    return $self->{_parent_hup_to_child};
}

sub parent_alive {
    my ($self) = @_;
    return kill( 0, $self->{_ppid} );
}

sub data {
    my $self = shift;
    return $self->{'_data'} unless (@_);

    if ( @_ == 1 ) {
        return $self->{'_data'}{ $_[0] } if ( not ref $_[0] );
        $self->{'_data'}{$_} = $_[0]->{$_} for ( keys %{ $_[0] } );
        return $self;
    }

    if ( @_ % 2 != 0 ) {
        carp( 'data() called with uneven number of parameters' );
    }
    else {
        my %params = @_;
        $self->{'_data'}{$_} = $params{$_} for ( keys %params );
    }

    return $self;
}

sub message {
    my ( $self, $pid, $message ) = @_;

    unless ( $self->{_on_message} ) {
        carp('message() called without an on_message handler set');
        return;
    }

    my $io;
    eval {
        $io = ( $self->{_ppid} == $pid )
            ? $self->{_io_up}
            : ( grep { $_->{pid} == $pid } @{ $self->{_children} } )[0]->{io_dn}
    };
    if ($@) {
        carp("Failed to find IO path for message to $pid");
        return;
    }

    $io->say($message) or carp("Failed to send message to $pid");
    kill( 'URG', $pid ) or carp("Failed to signal process $pid to new message");
}

our $AUTOLOAD;
sub AUTOLOAD {
    my $self = shift;
    my $key = ( split( '::', $AUTOLOAD ) )[-1];
    return $self->data($key);
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Daemon::Device - Forking daemon device construct

=head1 VERSION

version 1.09

=for markdown [![test](https://github.com/gryphonshafer/Daemon-Device/workflows/test/badge.svg)](https://github.com/gryphonshafer/Daemon-Device/actions?query=workflow%3Atest)
[![codecov](https://codecov.io/gh/gryphonshafer/Daemon-Device/graph/badge.svg)](https://codecov.io/gh/gryphonshafer/Daemon-Device)

=head1 SYNOPSIS

    use Daemon::Device;

    exit Daemon::Device->new(
        daemon => {
            name        => 'server_thing',
            lsb_sdesc   => 'Server Thing',
            pid_file    => '/tmp/server_thing.pid',
            stderr_file => '/tmp/server_thing.err',
            stdout_file => '/tmp/server_thing.info',
        },

        spawn  => 3,        # number of children to spawn
        parent => \&parent, # code to run in the parent
        child  => \&child,  # code to run in the children

        replace_children    => 1, # if a child dies, replace it; default is 1
        parent_hup_to_child => 1, # a HUP sent to parent echos to children; default is 1
    )->run;

    sub parent {
        my ($device) = @_;

        while (1) {
            warn "Parent $$ exists (heartbeat)\n";
            $device->adjust_spawn(2);
            sleep 5;
        }
    }

    sub child {
        my ($device) = @_;

        while (1) {
            warn "Child $$ exists (heartbeat)\n";
            exit unless ( $device->parent_alive );
            sleep 5;
        }
    }

=head1 DESCRIPTION

This module provides a straight-forward and simple construct to creating
applications that run as daemons and fork some number of child processes.
This module leverages the excellent L<Daemon::Control> to provide the
functionality for the daemon itself, and it manages the spawning and
monitoring of the children. It also provides some hooks into various parts of
the daemon's lifecycle.

The basic idea is that you'll end up with program that can be interacted with
like a Linux service (i.e. in /etc/init.d or similar).

    ./your_program.pl start

On start, it will initiate a single parent process and a number of children
processes. See L<Daemon::Control> for additional information about the core
part of the daemon. What Daemon::Device does beyond this is setup parent and
child creation, monitor and replace children that die off, and offer hooks.

=head1 METHODS

The following are methods of this module.

=head2 new

The C<new()> method expects a series of parameters to setup the device. It
returns a Daemon::Device object that you should probably immediately call
C<run()> on.

    exit Daemon::Device->new(
        daemon => \%daemon_control_settings,
        spawn  => 3,        # number of children to spawn
        parent => \&parent, # code to run in the parent
        child  => \&child,  # code to run in the children
    )->run;

=head3 daemon

One of the most important parameters is the "daemon" parameter. It's required,
and it must contain a hashref of parameters that are passed as-is to
L<Daemon::Control>. (It is almost a certainty you'll want to read the
L<Daemon::Control> documentation to understand the details of the parameters
that go in this hashref.)

=head3 spawn

This is an integer and represents the number of child processes that should be
spawned off the parent process initially. The number of child processes can be
changed during runtime by calling C<adjust_spawn()>. During runtime, you can
also send INT or TERM signals to the children to kill them off. However, ensure
the "replace_children" parameter is set to false or else the parent will spawn
new children to replace the dead ones.

If "spawn" is not defined, the default of 1 child will be assumed.

=head3 parent

This is a reference to a subroutine containing the code that should be executed
in the parent process.

    exit Daemon::Device->new(
        daemon => \%daemon_control_settings,
        child  => \&child,
        parent => sub {
            my ($device) = @_;

            while (1) {
                warn "Parent $$ exists (heartbeat)\n";
                $device->adjust_spawn(2);
                sleep 5;
            }
        },
    )->run;

The subroutine is provided a reference to the device object. It's expected that
if you need to keep the parent running, you'll implement something in this
subroutine that will do that, like a C<while> loop.

If "parent" is not defined, then the parent will simply sit around and wait for
all the children to exit or for the parent to be told to exit by external
signal or other means.

=head3 child

This is a reference to a subroutine containing the code that should be executed
in every child process.

    exit Daemon::Device->new(
        daemon => \%daemon_control_settings,
        child  => sub {
            my ($device) = @_;

            while (1) {
                warn "Child $$ exists (heartbeat)\n";
                exit unless ( $device->parent_alive );
                sleep 5;
            }
        },
    )->run;

It's expected that if you need to keep the parent running, you'll implement
something in this subroutine that will do that, like a C<while> loop.
If "child" is not defined, then the child will sit around and wait forever.
Not sure why you'd want to spawn children and then let them be lazy like this
since idle hands are the devil's playthings, though.

=head3 replace_children

This is a boolean, which defaults to true, and indicates whether or not the
parent process should spawn additional children to replace children that die
for whatever reason.

=head3 parent_hup_to_child

This is a boolean, which defaults to true, and indicates whether or not the
parent process should, when it receives a HUP signal, should echo that signal
down to all its children.

=head3 on_startup

This optional parameter is a runtime hook. It expects a subroutine reference
for code that should be called from inside the parent process just prior to
the parent spawning the initial set of children. The subroutine will be passed
a reference to the device object.

=head3 on_shutdown

This optional parameter is a runtime hook. It expects a subroutine reference
for code that should be called from inside the parent process just prior to
the parent shutting down. This event happens after the parent tells all its
children to shutdown, but the children may or may not have actually shutdown
prior to this parent C<on_shutdown> event. The subroutine will be passed
a reference to the device object.

=head3 on_spawn

This optional parameter is a runtime hook. It expects a subroutine reference
for code that should be called from inside the parent process just prior to
the parent spawning any child, even children that are spawned to replace
dead children. The subroutine will be passed a reference to the device object.

=head3 on_parent_hup

This optional parameter is a runtime hook. It expects a subroutine reference
for code that should be called from inside the parent process when the parent
receives a HUP signal. The subroutine will be passed a reference to the device
object.

=head3 on_child_hup

This optional parameter is a runtime hook. It expects a subroutine reference
for code that should be called from inside child processes when the child
receives a HUP signal. The subroutine will be passed a reference to the device
object.

=head3 on_parent_death

This optional parameter is a runtime hook. It expects a subroutine reference
for code that should be called from inside the parent process just after the
parent receives an instruction to shutdown. So when a parent gets a shutdown
order, this hook gets called, then the parent sends termination orders to all
its children, then triggers the C<on_shutdown> hook. The subroutine will be
passed a reference to the device object.

=head3 on_child_death

This optional parameter is a runtime hook. It expects a subroutine reference
for code that should be called from inside child processes just prior to
the child shutting down. The subroutine will be passed a reference to the
device object and the "child data" hashref.

=head3 on_replace_child

If the C<replace_children> parameter is not defined or is set to a true value,
then the parent will spawn new children to replace children that die. The
C<on_replace_child> optional parameter is a runtime hook. It expects a
subroutine reference for code that should be called from inside the parent just
prior to replacing a dead child. The subroutine will be passed a reference to
the device object.

=head2 run

The C<run()> method calls the method of the same name from L<Daemon::Control>.
This will make your program act like an init file, accepting input from the
command line. Run will exit with 0 for success and uses LSB exit codes.

=head2 daemon

If you need to access the L<Daemon::Control> object inside the device, you can
do so with the C<daemon()> method.

=head2 ppid, cpid

These methods return the parent PID or child PID. From both parent processes
and child processes, C<ppid> will return the parent's PID. From only child
processes, C<cpid> will return the child's PID. From the parent, C<cpid> will
return undef.

=head2 children

This will return an arrayref of PIDs for all the children currently spawned.

=head2 adjust_spawn

The C<adjust_spawn> method accepts a positive integer, and from it tells the
parent process to set a new spawn numerical value during runtime. Lets say you
have 10 children and they're fat (i.e. hogging memory) and lazy (i.e. not doing
anything) and you want to "thin the herd," so to speak. Or perhaps you only
spawned 2 children and there's more work than the 2 can handle. The
C<adjust_spawn> method let's you spawn or terminate children.

When you raise the total number of spawn, the parent will order the spawning,
but the children may or may not be completely spawned by the time
C<adjust_spawn> returns. Normally, this shouldn't be a problem. When you lower
the total number of spawn, C<adjust_spawn> will not return until some children
are really dead sufficient to bring the total number of children to the spawn
number.

=head2 replace_children, parent_hup_to_child

These are simple get-er/set-er methods for the C<replace_children> and
C<parent_hup_to_child> values, allowing you to change them during runtime.
This should be done in parents. Remember that data values are copied into
children during spawning (i.e. forking), so changing these values in children
is meaningless.

=head2 parent_alive

The C<parent_alive> method returns true if the daemon parent still lives or
false if it doesn't live. This is useful when writing child code, since a child
should periodically check to see if it's an orphan.

    exit Daemon::Device->new(
        daemon => \%daemon_control_settings,
        child  => sub {
            my ($self) = @_;
            while (1) {
                exit unless ( $self->parent_alive );
                sleep 1;
            }
        },
    )->run;

=head1 DATA

Each parent and child have a simple data storage mechanism in them under the
"data" parameter and "data" method, all of which is optional. To use it,
you can, if you elect, pass the "data" parameter to C<new()>.

    exit Daemon::Device->new(
        daemon => \%daemon_control_settings,
        parent => \&parent,
        child  => \&child,
        data   => {
            answer => 42,
            thx    => 1138,
        },
    )->run;

This will result in the parent getting this data block, which can be accessed
via the C<data()> method from within the parent. The C<data()> method is a
fairly typical key/value parameter get-er/set-er.

    sub parent {
        my ($device) = @_;
        warn $device->data('answer');            # returns 42
        $device->data( 'answer' => 0 );          # sets "answer" to 0
        $device->data( 'a' => 1, 'b' => 2 );     # set multiple things
        $device->data( { 'a' => 1, 'b' => 2 } ); # set multiple things
        my $data = $device->data                 # hashref of all data
    }

When children are spawned, they will pick up a copy of whatever's in the
parent's data when the spawning takes place. This is a copy, so changing data
in one place does not change it elsewhere. Note also that in some cases you
can't guarentee the exact order or timing of spawning children.

=head2 Helper Methods

As a convenience, you can access any single data value by referencing a method
of the same name.

    $device->data(
        noun => 'World',
        hi   => sub { say "Hello $_[0]" },
    );

    say $device->hi( $device->noun );

=head1 MESSAGING

You can, of course, setup whatever interprocess communications you'd like. In
an attempt to be helpful, this module offers basic interprocess communications
messaging. Normally, this messaging is unused and not activated. However, by
defining an C<on_message> handler in C<new()>, you will be able to call a
method called C<message()> to send messages between a parent and its children
or from any child to its parent. (Child-to-child communication is unsupported,
so if you need that, you'll need to create your own, better communications.)

=head2 on_message

This optional parameter to C<new()> is a runtime hook. It expects a subroutine
reference for code that should be called from inside either the parent or
child process that receives a message sent via the C<message()> method.
The subroutine will be passed a reference to the device object and an array
of messages received from a buffer. This is almost always only 1, but it could
be more, so code accordingly.

    sub on_message {
        my $device = shift;
        say "Received message: $_" for (@_);
    }

=head2 message

This method sends a message to a parent from one of its children or from a
child to its parent. It expects the PID of the process to which the message
should be sent and the message itself, which is expected to be a simple text
string. It's up to you to encode/serialize your data for transport.

    $device->message( 1138, 'Message for you, sir.' );

=head2 Messaging Gotchas

If you provide a PID to C<message()> that is not valid (not a child of the
parent from which the message originates or not a parent from the child from
which the message originates), suffer an error you will.

Also note that sometimes during spawning of child processes it is possible
that a message from the parent can get sent to a child before that child is
ready to receive the message, in which case the message will be dropped.
If you want to get data from the parent to the child, have the child tell the
parent it's ready, then have the parent send the child data.

The C<on_message> hook is universal, meaning that it's the same subroutine
that's called from both the parent and children to handle incoming messages.
You'll therefore need to write a little logic to handle the differences if
the use cases requires that.

The messaging is provided through use of a couple of L<IO::Pipe> objects per
child. The messaging is simple, limited, but fast. If you need something better,
you'll need to construct it yourself, or perhaps consider something like ZeroMQ.

=head1 SEE ALSO

L<Daemon::Control>, L<IO::Pipe>.

You can also look for additional information at:

=over 4

=item *

L<GitHub|https://github.com/gryphonshafer/Daemon-Device>

=item *

L<MetaCPAN|https://metacpan.org/pod/Daemon::Device>

=item *

L<GitHub Actions|https://github.com/gryphonshafer/Daemon-Device/actions>

=item *

L<Codecov|https://codecov.io/gh/gryphonshafer/Daemon-Device>

=item *

L<CPANTS|http://cpants.cpanauthors.org/dist/Daemon-Device>

=item *

L<CPAN Testers|http://www.cpantesters.org/distro/D/Daemon-Device.html>

=back

=for Pod::Coverage BUILD is_authed json passwd ua user data

=head1 AUTHOR

Gryphon Shafer <gryphon@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2015-2021 by Gryphon Shafer.

This is free software, licensed under:

  The Artistic License 2.0 (GPL Compatible)

=cut
