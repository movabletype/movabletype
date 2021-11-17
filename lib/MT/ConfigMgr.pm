# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::ConfigMgr;

use strict;
use warnings;
use base qw( MT::ErrorHandler );

our $cfg;

sub instance {
    return $cfg if $cfg;
    $cfg = __PACKAGE__->new;
}

sub new {
    my $mgr = bless {
        __var               => {},
        __dbvar             => {},
        __paths             => [],
        __dirty             => 0,
        __overwritable_keys => {},
        },
        $_[0];
    $mgr->init;
    $mgr;
}

sub init {
}

sub define {
    my $mgr = shift;
    my ($vars);
    if ( ref $_[0] eq 'ARRAY' ) {
        $vars = shift;
    }
    elsif ( ref $_[0] eq 'HASH' ) {
        $vars = shift;
    }
    else {
        my ( $var, %param ) = @_;
        $vars = [ [ $var, \%param ] ];
    }
    if ( ref($vars) eq 'ARRAY' ) {
        foreach my $def (@$vars) {
            my ( $var, $param ) = @$def;
            my $lcvar = lc $var;
            $mgr->{__var}{$lcvar}           = undef;
            $mgr->{__settings}{$lcvar}      = keys %$param ? {%$param} : {};
            $mgr->{__settings}{$lcvar}{key} = $var;
            if ( $mgr->{__settings}{$lcvar}{path} ) {
                push @{ $mgr->{__paths} }, $var;
            }
        }
    }
    elsif ( ref($vars) eq 'HASH' ) {
        foreach my $var ( keys %$vars ) {
            my $param = $vars->{$var};
            my $lcvar = lc $var;
            $mgr->{__settings}{$lcvar} = $param;
            if ( ref $param eq 'ARRAY' ) {
                $mgr->{__settings}{$lcvar} = $param->[0];
            }
            $mgr->{__settings}{$lcvar}{key} = $var;
            if ( $mgr->{__settings}{$lcvar}{path} ) {
                push @{ $mgr->{__paths} }, $var;
            }
        }
    }
}

sub paths {
    my $mgr = shift;
    wantarray ? @{ $mgr->{__paths} } : $mgr->{__paths};
}

our $depth = 0;
my $max_depth = 5;

sub get_internal {
    my $mgr = shift;
    my $var = lc shift;
    my $val;
    if ( defined( my $alias = $mgr->{__settings}{$var}{alias} ) ) {
        if ( $max_depth < $depth ) {
            die MT->translate(
                'Alias for [_1] is looping in the configuration.', $alias );
        }
        local $depth = $depth + 1;
        return $mgr->get($alias);
    }

    $val = $mgr->{__dbvar}{$var} if $mgr->is_overwritable($var);
    $val = $mgr->{__var}{$var} unless defined($val);
    $val = { %{ $mgr->{__dbvar}{$var} }, %$val } if ($mgr->type($var) eq 'HASH' && $val && $mgr->{__dbvar}{$var});
    $val = $mgr->{__dbvar}{$var} unless defined($val);
    return $mgr->default($var) unless defined($val);

    $val = $val->() if ref($val) eq 'CODE';
    wantarray && ( $mgr->{__settings}{$var}{type} || '' ) eq 'ARRAY'
        ? @$val
        : ( ( ref $val ) eq 'ARRAY' && @$val ? $val->[0] : $val );
}

sub get {
    my $mgr = shift;
    my $var = lc shift;
    if ( my $h = $mgr->{__settings}{$var}{handler} ) {
        $h = MT->handler_to_coderef($h) unless ref $h;
        return $h->($mgr);
    }
    return $mgr->get_internal( $var, @_ );
}

sub type {
    my $mgr = shift;
    my $var = lc shift;
    return undef unless exists $mgr->{__settings}{$var};
    return $mgr->{__settings}{$var}{type} || 'SCALAR';
}

sub default {
    my $mgr = shift;
    my $var = lc shift;
    $mgr->{__settings}{$var}{default} = shift if @_;
    my $def = $mgr->{__settings}{$var}{default};
    return wantarray ? () : undef unless defined $def;
    if ( ref($def) eq 'CODE' ) {
        $def = $def->( $mgr, $var, $mgr->{__settings}{$var} );
    }
    if ( my $type = $mgr->{__settings}{$var}{type} ) {
        if ( $type eq 'ARRAY' ) {
            return wantarray ? ($def) : $def;
        }
        elsif ( $type eq 'HASH' ) {
            if ( ref $def ne 'HASH' ) {
                ( my ($key), my ($val) ) = split /=/, $def;
                return { $key => $val };
            }
        }
    }
    $def;
}

sub set_internal {
    my $mgr = shift;
    my ( $var, $val, $db_flag ) = @_;
    $var = lc $var;
    $mgr->set_dirty() if defined($db_flag) && $db_flag;
    my $set = $db_flag ? '__dbvar' : '__var';
    if ( defined( my $alias = $mgr->{__settings}{$var}{alias} ) ) {
        if ( $max_depth < $depth ) {
            die MT->translate(
                'Alias for [_1] is looping in the configuration.', $alias );
        }
        local $depth = $depth + 1;
        $mgr->set( $alias, $val, $db_flag );
    }
    elsif ( my $type = $mgr->{__settings}{$var}{type} ) {
        if ( $type eq 'ARRAY' ) {
            if ( ref $val eq 'ARRAY' ) {
                $mgr->{$set}{$var} = $val;
            }
            else {
                $mgr->{$set}{$var} ||= [];
                push @{ $mgr->{$set}{$var} }, $val if defined $val;
            }
        }
        elsif ( $type eq 'HASH' ) {
            if ( ref $val eq 'HASH' ) {
                $mgr->{$set}{$var} = $val;
            }
            else {
                ( my ($key), $val ) = split /=/, $val;
                $mgr->{$set}{$var}{$key} = $val;
            }
        }
        else {
            $mgr->{$set}{$var} = $val;
        }
    }
    else {
        $mgr->{$set}{$var} = $val;
    }
    return $val;
}

sub set {
    my $mgr = shift;
    my ( $var, $val, $db_flag ) = @_;
    $var = lc $var;
    $mgr->set_dirty($var);
    if ( my $h = $mgr->{__settings}{$var}{handler} ) {
        $h = MT->handler_to_coderef($h) unless ref $h;
        return $h->( $mgr, $val, $db_flag );
    }
    return $mgr->set_internal(@_);
}

sub is_readonly {
    my $class = shift;
    my ($var) = @_;
    return ( !$class->is_overwritable($var)
            && defined $class->instance->{__var}{ lc $var } ) ? 1 : 0;
}

sub overwritable_keys {
    my $mgr = shift;
    $mgr = $mgr->instance unless ref($mgr);

    if (@_) {
        my @keys = ref $_[0] ? @{ $_[0] } : @_;
        $mgr->{__overwritable_keys} = { map { lc $_ => 1 } @keys };
    }

    [ keys %{ $mgr->{__overwritable_keys} } ];
}

sub is_overwritable {
    my $class = shift;
    my $var   = lc shift;
    return $class->instance->{__overwritable_keys}{$var};
}

sub read_config {
    my $class = shift;
    return $class->read_config_file(@_);
}

sub set_dirty {
    my $mgr = shift;
    my ($var) = @_;
    $mgr = $mgr->instance unless ref($mgr);
    return $mgr->{__settings}{ lc $var }{dirty} = 1 if defined $var;
    return $mgr->{__dirty} = 1;
}

sub clear_dirty {
    my $mgr = shift;
    my ($var) = @_;
    $mgr = $mgr->instance unless ref($mgr);
    return delete $mgr->{__settings}{ lc $var }{dirty} if defined $var;
    foreach my $var ( keys %{ $mgr->{__settings} } ) {
        if ( $mgr->{__settings}{$var}{dirty} ) {
            delete $mgr->{__settings}{$var}{dirty};
        }
    }
    return $mgr->{__dirty} = 0;
}

sub is_dirty {
    my $mgr = shift;
    $mgr = $mgr->instance unless ref($mgr);
    return $mgr->{__settings}{ lc $_[0] }{dirty} ? 1 : 0 if @_;
    return $mgr->{__dirty};
}

sub save_config {
    my $class = shift;
    my $mgr   = $class->instance;

    # prevent saving when the db row wasn't read already
    return 0 unless $mgr->{__read_db};
    return 0 unless $mgr->is_dirty();
    my $data     = '';
    my $settings = $mgr->{__dbvar};
    foreach ( sort keys %$settings ) {
        my $type = ( $mgr->{__settings}{$_}{type} || '' );
        delete $mgr->{__settings}{$_}{dirty}
            if exists $mgr->{__settings}{$_}{dirty};
        if ( $type eq 'HASH' ) {
            my $h = $settings->{$_};
            foreach my $k ( sort keys %$h ) {
                $data
                    .= $mgr->{__settings}{$_}{key} . ' '
                    . $k . '='
                    . $h->{$k} . "\n";
            }
        }
        elsif ( $type eq 'ARRAY' ) {
            my $a = $settings->{$_};
            foreach my $v (@$a) {
                $data .= $mgr->{__settings}{$_}{key} . ' ' . $v . "\n";
            }
        }
        elsif ( defined $settings->{$_} and $settings->{$_} ne '' ) {
            $data
                .= $mgr->{__settings}{$_}{key} . ' ' . $settings->{$_} . "\n";
        }
    }

    my $cfg_class = MT->model('config') or return;

    my $config;
    eval { $config = $cfg_class->load(); };
    if ($@) {
        warn "An error occurred when loading the config class: $@" if $MT::DebugMode;
        return;
    }
    unless ($config) {
        $config = $cfg_class->new;
    }

    if ( $data !~ m/^schemaversion/im ) {
        if ( $config->id
            && ( ( $config->data || '' ) =~ m/^schemaversion/im ) )
        {
            require Carp;
            MT->log(
                {   message => Carp::longmess(
                        "Caught attempt to clear SchemaVersion setting. New config settings were:\n$data"
                    ),
                    category => 'config',
                }
            );
            return;
        }
    }

    $config->data($data);

    # Ignore any error returned for the sake of MT-Wizard,
    # where the mt_config table doesn't actually exist yet.
    $config->save;
    $mgr->clear_dirty;
    1;
}

sub read_config_file {
    my $class      = shift;
    my ($cfg_file) = @_;
    my $mgr        = $class->instance;
    $mgr->{__var} = {};
    local $_;
    local $/ = "\n";
    die "Cannot read config without config file name" if !$cfg_file;
    open my $FH, "<", $cfg_file
        or return $class->error(
        MT->translate( "Error opening file '[_1]': [_2]", $cfg_file, "$!" ) );
    my $line = 0;

    while (<$FH>) {
        chomp;
        $line++;
        next if !/\S/ || /^#/;
        my ( $var, $val ) = $_ =~ /^\s*(\S+)\s+(.*)$/;
        return $class->error(
            MT->translate(
                "Config directive [_1] without value at [_2] line [_3]",
                $var, $cfg_file, $line
            )
        ) unless defined($val) && $val ne '';
        $val =~ s/\s*$// if defined($val);
        next unless $var && defined($val);
        $mgr->set( $var, $val );
    }
    close $FH;
    1;
}

sub read_config_db {
    my $class     = shift;
    my $mgr       = $class->instance;
    my $cfg_class = MT->model('config') or return;

    $mgr->{__dbvar} = {};

    my $driver = $MT::Object::DRIVER;
    $driver->clear_cache if $driver && $driver->can('clear_cache');

    my ($config) = eval { $cfg_class->search };
    if ($config) {
        my $was_dirty = $mgr->is_dirty;
        my $data      = $config->data;
        my @data      = split /[\r\n]/, $data;
        my $line      = 0;
        foreach (@data) {
            $line++;
            chomp;
            next if !/\S/ || /^#/;
            my ( $var, $val ) = $_ =~ /^\s*(\S+)\s+(.+)$/;
            $val =~ s/\s*$// if defined($val);
            next unless $var && defined($val);
            $mgr->set( $var, $val, 1 );
        }
        $mgr->clear_dirty unless $was_dirty;
    }
    $mgr->{__read_db} = 1;
    1;
}

sub DESTROY {

    # save_config here so not to miss any dirty config change to persist
    # particularly for those which does not construct MT::App.
    $_[0]->save_config;
}

use vars qw( $AUTOLOAD );

sub AUTOLOAD {
    my $mgr = $_[0];
    ( my $var = $AUTOLOAD ) =~ s!.+::!!;
    $var = lc $var;
    return $mgr->error(
        MT->translate( "No such config variable '[_1]'", $var ) )
        unless exists $mgr->{__settings}->{$var};
    no strict 'refs';
    *$AUTOLOAD = sub {
        my $mgr = shift;
        @_ ? $mgr->set( $var, @_ ) : $mgr->get($var);
    };
    goto &$AUTOLOAD;
}

1;
__END__

=head1 NAME

MT::ConfigMgr - Movable Type configuration manager

=head1 SYNOPSIS

    use MT::ConfigMgr;
    my $cfg = MT::ConfigMgr->instance;

    $cfg->read_config('/path/to/mt.cfg')
        or die $cfg->errstr;

=head1 DESCRIPTION

L<MT::ConfigMgr> is a singleton class that manages the Movable Type
configuration file (F<mt-config.cgi>), allowing access to the config
directives contained therin.

=head1 USAGE

=head2 MT::ConfigMgr->new

Creates a new instance of L<MT::ConfigMgr> and initializes it. It does not
read any configuration file data. This is done using the L<read_config>
method.

=head2 $cfg->init

Initialization method called by the L<new> constructor prior to returning
a new instance of L<MT::ConfigMgr>.

=head2 MT::ConfigMgr->instance

Returns the singleton L<MT::ConfigMgr> object. Note that when you want
the object, you should always call L<instance>, never L<new>; L<new>
will construct a B<new> L<MT::ConfigMgr> object, and that isn't what you
want. You want the object that has already been initialized with the
contents of the configuration file. This initialization is done
by L<MT::new>.

=head2 $cfg->read_config($file)

Calls L<read_config_file>.

=head2 $cfg->save_config()

Saves any configuration settings that originated from the database, or
were set with the I<persist> option. Settings are stored using the
L<MT::Config> class.

=head2 $cfg->read_config_file($file)

Reads the config file at the path I<$file> and initializes the I<$cfg> object
with the directives in that file. Returns true on success, C<undef> otherwise;
if an error occurs you can obtain the error message with C<$cfg-E<gt>errstr>.

=head2 $cfg->read_config_db()

Reads any configuration settings from the L<MT::Config> class. Note that
these settings are always overridden by settings in the MT configuration
file.

=head2 $cfg->define($directive[, %arg ])

Defines the directive I<$directive> as a valid configuration directive. For
special configuration directives (HASH or ARRAY types), you must define them
B<before> you the configuration file is read.

=head2 $cfg->set($directive, $value[, $persist])

The handler method for assigning a value to a specific directive. The
C<$value> should be a SCALAR value for simple configuration settings.

    $cfg->set('EmailAddressMain', 'user@example.com');

For an ARRAY type, C<$value> should be an array reference; if it is a
SCALAR value, then it is added to any existing array held for the
directive.

    # Replaces any existing array value for 'MemcachedServers':
    $cfg->set('MemcachedServers', ['127.0.0.1', '127.0.0.2']);

    # Adds '127.0.0.3' to the existing array held for 'MemcachedServers':
    $cfg->set('MemcachedServers', '127.0.0.3');

For a HASH type, C<$value> should be a hash reference; if it is a SCALAR
value, it should be in the format "key=value", and will be added any
existing hash held for the directive.

    # Replaces any existing hash value for 'AtomApp':
    $cfg->set('AtomApp', { pings => 'Example::AtomPingServer' });

    # Adds a new service declaration to the existing hash held for 'AtomApp':
    $cfg->set('AtomApp', 'foo=Example::Foo');

=head2 $cfg->paths

Returns a list or array reference (depending on whether it is called in
an array or scalar context) of configuration directive names that are
declared as path directives.

=head2 $cfg->get($directive)

=head2 $cfg->get_internal($directive)

The low-level method for getting a configuration setting and bypasses any
declared 'handler'.

=head2 $cfg->set_internal($directive, $value[, $persist])

The low-level method for setting a configuration setting that bypasses any
declared 'handler' and prevents the directive from having its "dirty"
state set.

=head2 $cfg->type($directive)

Returns the type of the configuration directive (returns 'SCALAR', 'ARRAY'
or 'HASH'). If the directive is unregistered, this method will return
undef.

=head2 $cfg->is_readonly($directive)

Returns true when there exists a user-defined value for the configuration
directive that was read from the MT configuration file. Such a value cannot
be overridden through the database, so it is considered a read-only
setting.

=head2 $cfg->set_dirty([$directive])

Assigns a dirty state to the configuration settings as a whole, or to
an individual directive. The former controls whether or not the
L<save_config> method will actually rewrite the configuration settings
to the L<MT::Config> object. The latter is used to identify when a
setting has been set to something other than the default.

=head2 $cfg->is_dirty([$directive])

Returns the 'dirty' state of the configuration settings as a whole, or
for an individual directive.

=head2 $cfg->clear_dirty([$directive])

Clears the 'dirty' state of the configuration settings as a whole, or
for an individual directive.

=head2 $cfg->default($directive)

Returns the default setting for the specified directive, if one exists.

=head1 CONFIGURATION DIRECTIVES

Once the I<ConfigMgr> object has been constructed, you can use it to obtain
the configuration settings. Any of the defined settings may be gathered
using a dynamic method invoked directly from the object:

    my $path = $cfg->CGIPath

To set the value of a directive, do the same as the above, but pass in a
value to the method:

    $cfg->CGIPath('http://www.foo.com/mt/');

If you wish to progammatically assign a configuration setting that will
persist, add an extra parameter when doing an assignment, passing '1'
(this second parameter is a boolean that will cause the value to persist,
using the L<MT::Config> class to store the settings into the datatbase):

    $cfg->EmailAddressMain('user@example.com', 1);
    $cfg->save_config;

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
