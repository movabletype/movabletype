# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package MT::ObjectDriverFactory;

use strict;
use base qw( MT::ErrorHandler );

use MT::ObjectDriver::Driver::DBI;
use MT::ObjectDriver::SQL;

# Mapping of aliases/identifiers to a particular implementation.
our $drivers = [
    [ qr/(db[id]::)?(postgres|pg(sql)?)/ => 'Pg' ],
    [ qr/(db[id]::)?mysql/               => 'mysql' ],
    [ qr/(db[id]::)?u(ms)?sqlserver/     => 'UMSSQLServer' ],
    [ qr/(db[id]::)?(ms)?sqlserver/      => 'MSSQLServer' ],
    [ qr/(db[id]::)?sqlite/              => 'SQLite' ],
    [ qr/(db[id]::)?oracle/              => 'Oracle' ],
];

our @drivers;

#sub init {
#    @drivers = ();
#    __PACKAGE__->new();
#}

sub new {
    my $pkg = shift;
    my ($type) = @_;
    $type ||= MT->config('ObjectDriver');

    my $class;
    foreach my $driver (@$drivers) {
        if ((lc $type) =~ m/^$driver->[0]$/) {
            $class = $driver->[1];
            last;
        }
    }
    $class ||= $type;
    die "Unsupported driver :" unless $class;
    $class = 'MT::ObjectDriver::Driver::DBD::' . $class
        unless $class =~ m/::/;
    eval "use $class;";
    die "Unsupported driver $type: $@" if $@;

    my $cfg = MT->config;
    my $Password ||= $cfg->DBPassword;
    my $Username = $cfg->DBUser;

    my $dbi_driver = MT::ObjectDriver::Driver::DBI->new(
        dsn => $class->dsn_from_config($cfg),
        ($Username ? ( username => $Username) : ()),
        ($Password ? ( password => $Password) : ()),
        ($class ? ( dbd => $class) : ()),
    );

    require MT::ObjectDriver::Driver::Cache::RAM;
    require MT::Memcached;

    my $driver;
    if (MT::Memcached->is_available) {
        require Data::ObjectDriver::Driver::Cache::Memcached;
        $driver = MT::ObjectDriver::Driver::Cache::RAM->new(
            fallback => Data::ObjectDriver::Driver::Cache::Memcached->new(
                cache => MT::Memcached->instance,
                fallback => $dbi_driver,
            ),
        );
    } else {
        $driver = MT::ObjectDriver::Driver::Cache::RAM->new(
            fallback => $dbi_driver,
        );
    }

    push @drivers, $driver;
    return $driver;
}

sub configure {
    my $pkg = shift;
    $_->configure(@_) for @drivers;
}

sub cleanup {
    @drivers = ();
    if ( my $driver = $MT::Object::DRIVER ) {
        if ( my $dbh = $driver->dbh ) {
            $dbh->disconnect;
        }
        $MT::Object::DRIVER = undef;
    }
}

1;
__END__

=head1 NAME

MT::ObjectDriverFactory

=head1 METHODS

TODO

=head1 AUTHOR & COPYRIGHT

Please see L<MT/AUTHOR & COPYRIGHT>.

=cut
