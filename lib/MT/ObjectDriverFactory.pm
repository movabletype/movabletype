# Copyright 2001-2007 Six Apart. This code cannot be redistributed without
# permission from www.sixapart.com.  For more information, consult your
# Movable Type license.
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

sub init {
    @drivers = ();
    __PACKAGE__->new();
}

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

    require Data::ObjectDriver::Driver::Cache::RAM;
    require MT::Memcached;

    my $driver;
    if (MT::Memcached->is_available) {
        require Data::ObjectDriver::Driver::Cache::Memcached;
        $driver = Data::ObjectDriver::Driver::Cache::RAM->new(
            fallback => Data::ObjectDriver::Driver::Cache::Memcached->new(
                cache => MT::Memcached->instance,
                fallback => $dbi_driver,
            ),
        );
    } else {
        $driver = Data::ObjectDriver::Driver::Cache::RAM->new(
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

1;
__END__

=head1 NAME

MT::ObjectDriverFactory

=head1 METHODS

TODO

=head1 AUTHOR & COPYRIGHT

Please see L<MT/AUTHOR & COPYRIGHT>.

=cut
