# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: ObjectDriverFactory.pm 3531 2009-03-12 09:11:52Z fumiakiy $

package MT::ObjectDriverFactory;

use strict;
use base qw( MT::ErrorHandler );

use MT::ObjectDriver::Driver::DBI;
use MT::ObjectDriver::SQL;

# Mapping of aliases/identifiers to a particular implementation.
our $drivers = [
    [ qr/(db[id]::)?(postgres|pg(sql)?)/ => 'Pg' ],
    [ qr/(db[id]::)?mysql/               => 'mysql' ],
    [ qr/(db[id]::)?sqlite/              => 'SQLite' ],
];

our @drivers;

sub new {
    my $pkg = shift;
    my $get_driver = $pkg->driver_for_class();
    return $get_driver->();
}

our $DRIVER;
sub instance {
    my $pkg = shift;
    $DRIVER = $pkg->new unless $DRIVER;
    return $DRIVER;
}

# Returns a coderef for an object driver that is suitable
# for the $class given. $class is optional
sub driver_for_class {
    my $pkg = shift;
    my ($class) = @_;
    require MT::ObjectDriver::Driver::CacheWrapper;
    my $driver_code = MT::ObjectDriver::Driver::CacheWrapper->wrap(
        sub {
            my $cfg = MT->config;
            my $Password = $cfg->DBPassword;
            my $Username = $cfg->DBUser;
            my $dbd = $pkg->dbd_class;
            my $driver = MT::ObjectDriver::Driver::DBI->new(
                dbd => $dbd,
                dsn => $dbd->dsn_from_config($cfg),
                reuse_dbh => 1,
                ($Username ? ( username => $Username) : ()),
                ($Password ? ( password => $Password) : ()),
            );
            push @drivers, $driver;
            return $driver;
        }, $class
    );
    return $driver_code;
}

our $dbd_class;
sub dbd_class {
    return $dbd_class if defined $dbd_class;
    my $pkg = shift;

    my ($type) = @_;
    $type ||= MT->config('ObjectDriver');

    my $dbd_class;
    foreach my $driver (@$drivers) {
        if ((lc $type) =~ m/^$driver->[0]$/) {
            $dbd_class = $driver->[1];
            last;
        }
    }

    unless ( $dbd_class ) {
        my $all_drivers = MT->registry("object_drivers");
        foreach my $driver ( %$all_drivers ) {
            if ( my $re = $all_drivers->{$driver}{match} ) {
                if ( (lc $type) =~ m/^$re$/ ) {
                    $dbd_class = $all_drivers->{$driver}{config_package};
                    last;
                }
            }
        }
    }

    $dbd_class ||= $type;
    die "Unsupported driver $type" unless $dbd_class;

    $dbd_class = 'MT::ObjectDriver::Driver::DBD::' . $dbd_class
        unless $dbd_class =~ m/::/;

    eval "use $dbd_class;";
    die "Unsupported driver $type: $@" if $@;

    return $dbd_class;
}

sub configure {
    my $pkg = shift;
    $_->configure(@_) for @drivers;
}

sub cleanup {
    if ( my $driver = $MT::Object::DRIVER ) {
        if ( my $dbh = $driver->dbh ) {
            $dbh->disconnect;
            $driver->dbh(undef);
        }
        $MT::Object::DRIVER = undef;
        $MT::Object::DBI_DRIVER = undef;
    }
    foreach my $driver (@drivers) {
        if ( my $dbh = $driver->dbh ) {
            $dbh->disconnect;
            $driver->dbh(undef);
        }
    }
    @drivers = ();
    undef $DRIVER;
}

1;
__END__

=head1 NAME

MT::ObjectDriverFactory

=head1 AUTHOR & COPYRIGHT

Please see L<MT/AUTHOR & COPYRIGHT>.

=cut
