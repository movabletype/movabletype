# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package MT::ConfigMgr;

use strict;
use base qw( MT::ErrorHandler );

use vars qw( $cfg );
sub instance {
    return $cfg if $cfg;
    $cfg = __PACKAGE__->new;
}

sub new {
    my $mgr = bless { __var => { }, __dbvar => { }, __paths => [], __dirty => 0 }, $_[0];
    $mgr->init;
    $mgr;
}

sub init {
}

sub define {
    my $mgr = shift;
    my($vars);
    if (ref $_[0] eq 'ARRAY') {
        $vars = shift;
    } elsif (ref $_[0] eq 'HASH') {
        $vars = shift;
    } else {
        my($var, %param) = @_;
        $vars = [ [ $var, \%param ] ];
    }
    if (ref($vars) eq 'ARRAY') {
        foreach my $def (@$vars) {
            my($var, $param) = @$def;
            my $lcvar = lc $var;
            $mgr->{__var}{$lcvar} = undef;
            $mgr->{__settings}{$lcvar} = keys %$param ? { %$param } : {};
            $mgr->{__settings}{$lcvar}{key} = $var;
            if ($mgr->{__settings}{$lcvar}{path}) {
                push @{$mgr->{__paths}}, $var;
            }
        }
    } elsif (ref($vars) eq 'HASH') {
        foreach my $var (keys %$vars) {
            my $param = $vars->{$var};
            my $lcvar = lc $var;
            $mgr->{__settings}{$lcvar} = $param;
            if (ref $param eq 'ARRAY') {
                $mgr->{__settings}{$lcvar} = $param->[0];
            }
            $mgr->{__settings}{$lcvar}{key} = $var;
            if ($mgr->{__settings}{$lcvar}{path}) {
                push @{$mgr->{__paths}}, $var;
            }
        }
    }
}

sub paths {
    my $mgr = shift;
    wantarray ? @{$mgr->{__paths}} : $mgr->{__paths};
}

our $depth = 0;
my $max_depth = 5;
sub get_internal {
    my $mgr = shift;
    my $var = lc shift;
    my $val;
    if (defined(my $alias = $mgr->{__settings}{$var}{alias})) {
        if ($max_depth < $depth) {
            die MT->translate('Alias for [_1] is looping in the configuration.', $alias);
        }
        local $depth = $depth + 1;
        $mgr->get($alias);
    } elsif (defined($val = $mgr->{__var}{$var})) {
        $val = $val->() if ref($val) eq 'CODE';
        wantarray && ($mgr->{__settings}{$var}{type}||'') eq 'ARRAY' ?
            @$val : ((ref $val) eq 'ARRAY' && @$val ? $val->[0] : $val);
    } elsif (defined($val = $mgr->{__dbvar}{$var})) {
        wantarray && ($mgr->{__settings}{$var}{type}||'') eq 'ARRAY' ?
            @$val : ((ref $val) eq 'ARRAY' && @$val ? $val->[0] : $val);
    } else {
        $mgr->default($var);
    }
}

sub get {
    my $mgr = shift;
    my $var = lc shift;
    if (my $h = $mgr->{__settings}{$var}{handler}) {
        $h = MT->handler_to_coderef($h) unless ref $h;
        return $h->($mgr);
    }
    return $mgr->get_internal($var, @_);
}

sub type {
    my $mgr = shift;
    my $var = lc shift;
    $mgr->{__settings}{$var}{type} || 'SCALAR';
}

sub default {
    my $mgr = shift;
    my $var = lc shift;
    my $def = $mgr->{__settings}{$var}{default};
    return wantarray ? () : undef unless defined $def;
    if (my $type = $mgr->{__settings}{$var}{type}) {
        if ($type eq 'ARRAY') {
            return wantarray ? ( $def ) : $def;
        } elsif ($type eq 'HASH') {
            if (ref $def ne 'HASH') {
                (my($key), my($val)) = split /=/, $def;
                return { $key => $val };
            }
        }
    }
    $def;
}

sub set_internal {
    my $mgr = shift;
    my($var, $val, $db_flag) = @_;
    $var = lc $var;
    $db_flag ||= exists $mgr->{__dbvar}{$var};
    $mgr->set_dirty() if defined($_[2]) && $_[2];
    my $set = $db_flag ? '__dbvar' : '__var';
    if (defined(my $alias = $mgr->{__settings}{$var}{alias})) {
        if ($max_depth < $depth) {
            die MT->translate('Alias for [_1] is looping in the configuration.', $alias);
        }
        local $depth = $depth + 1;
        $mgr->set($alias, $val, $db_flag);
    } elsif (my $type = $mgr->{__settings}{$var}{type}) {
        if ($type eq 'ARRAY') {
            if (ref $val eq 'ARRAY') {
                $mgr->{$set}{$var} = $val;
            } else {
                $mgr->{$set}{$var} ||= [];
                push @{ $mgr->{$set}{$var} }, $val if defined $val;
            }
        } elsif ($type eq 'HASH') {
            my $hash = $mgr->{$set}{$var};
            $hash = $mgr->default($var) unless defined $hash;
            if (ref $val eq 'HASH') {
                $mgr->{$set}{$var} = $val;
            } else {
                $hash ||= {};
                (my($key), $val) = split /=/, $val;
                $mgr->{$set}{$var}{$key} = $val;
            }
        } else {
            $mgr->{$set}{$var} = $val;
        }
    } else {
        $mgr->{$set}{$var} = $val;
    }
    return $val;
}

sub set {
    my $mgr = shift;
    my($var, $val, $db_flag) = @_;
    $var = lc $var;
    if (my $h = $mgr->{__settings}{$var}{handler}) {
        $h = MT->handler_to_coderef($h) unless ref $h;
        return $h->($mgr, $val, $db_flag);
    }
    return $mgr->set_internal(@_);
}

sub is_readonly {
    my $class = shift;
    my ($var) = @_;
    defined $class->instance->{__var}{lc $var} ? 1 : 0;
}

sub read_config {
    my $class = shift;
    $class->read_config_file(@_);
}

sub set_dirty {
    my $mgr = shift;
    $mgr = $mgr->instance unless ref($mgr);
    $mgr->{__dirty} = 1;
}

sub clear_dirty {
    my $mgr = shift;
    $mgr = $mgr->instance unless ref($mgr);
    $mgr->{__dirty} = 0;
}

sub is_dirty {
    my $mgr = shift;
    $mgr = $mgr->instance unless ref($mgr);
    $mgr->{__dirty};
}

sub save_config {
    my $class = shift;
    my $mgr = $class->instance;
    # prevent saving when the db row wasn't read already
    return 0 unless $mgr->{__read_db};
    return 0 unless $mgr->is_dirty();
    my $data = '';
    my $settings = $mgr->{__dbvar};
    foreach (sort keys %$settings) {
        my $type = ($mgr->{__settings}{$_}{type}||'');
        if ($type eq 'HASH') {
            my $h = $settings->{$_};
            foreach my $k (keys %$h) {
                $data .= $mgr->{__settings}{$_}{key} . ' ' . $k . '=' . $h->{$k} . "\n";
            }
        } elsif ($type eq 'ARRAY') {
            my $a = $settings->{$_};
            foreach my $v (@$a) {
                $data .= $mgr->{__settings}{$_}{key} . ' ' . $v . "\n";
            }
        } else {
            $data .= $mgr->{__settings}{$_}{key} . ' ' . $settings->{$_} . "\n";
        }
    }
    require MT::Config;
    my ($config) = MT::Config->load() || new MT::Config;

    if ($data !~ m/schemaversion/i) {
        if ($config->id && (($config->data || '') =~ m/schemaversion/i)) {
            require Carp;
            MT->log(Carp::longmess("Caught attempt to clear SchemaVersion setting. New config settings were:\n$data"));
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
    my $class = shift;
    my($cfg_file) = @_;
    my $mgr = $class->instance;
    $mgr->{__var} = {};
    local(*FH, $_, $/);
    $/ = "\n";
    die "Can't read config without config file name" if !$cfg_file;
    open FH, $cfg_file or
        return $class->error(MT->translate(
            "Error opening file '[_1]': [_2]", $cfg_file, "$!" ));
    my $line;
    while (<FH>) {
        chomp; $line++;
        next if !/\S/ || /^#/;
        my($var, $val) = $_ =~ /^\s*(\S+)\s+(.*)$/;
        return $class->error(MT->translate("Config directive [_1] without value at [_2] line [_3]", $var, $cfg_file, $line))
            unless defined($val) && $val ne '';
        $val =~ s/\s*$// if defined($val);
        next unless $var && defined($val);
        #return $class->error(MT->translate(
        #    "[_1]:[_2]: variable '[_3]' not defined", $cfg_file, $., $var
        #    )) unless exists $mgr->{__settings}->{$var};
        # next unless exists $mgr->{__settings}->{$var};
        $mgr->set($var, $val);
    }
    close FH;
    1;
}

sub read_config_db {
    my $class = shift;
    my $mgr = $class->instance;
    require MT::Config;
    my ($config) = eval { MT::Config->search };
    if ($config) {
        my $data = $config->data;
        my @data = split /[\r?\n]/, $data;
        my $line = 0;
        foreach (@data) {
            $line++;
            chomp;
            next if !/\S/ || /^#/;
            my($var, $val) = $_ =~ /^\s*(\S+)\s+(.+)$/;
            $val =~ s/\s*$// if defined($val);
            next unless $var && defined($val);
            #return $class->error(MT->translate(
            #    "[_1]:[_2]: variable '[_3]' not defined", "database", $line, $var
            #)) unless exists $mgr->{__settings}->{$var};

            # ignore setting if it isn't defined...
            # next unless exists $mgr->{__settings}->{$var};
            $mgr->set($var, $val, 1);
        }
    }
    $mgr->{__read_db} = 1;
    1;
}

sub DESTROY { }

use vars qw( $AUTOLOAD );
sub AUTOLOAD {
    my $mgr = $_[0];
    (my $var = $AUTOLOAD) =~ s!.+::!!;
    $var = lc $var;
    return $mgr->error(MT->translate("No such config variable '[_1]'", $var))
        unless exists $mgr->{__settings}->{$var};
    no strict 'refs';
    *$AUTOLOAD = sub {
        my $mgr = shift;
        @_ ? $mgr->set($var, @_) : $mgr->get($var);
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

I<MT::ConfigMgr> is a singleton class that manages the Movable Type
configuration file (F<mt.cfg>), allowing access to the config directives
contained therin.

=head1 USAGE

=head2 MT::ConfigMgr->instance

Returns the singleton I<MT::ConfigMgr> object. Note that when you want the
object, you should always call I<instance>, never I<new>; I<new> will construct
a B<new> I<MT::ConfigMgr> object, and that isn't what you want. You want the
object that has already been initialized with the contents of F<mt.cfg>. This
initialization is done by I<MT::new>.

=head2 $cfg->read_config($file)

Reads the config file at the path I<$file> and initializes the I<$cfg> object
with the directives in that file. Returns true on success, C<undef> otherwise;
if an error occurs you can obtain the error message with C<$cfg-E<gt>errstr>.

=head2 $cfg->define($directive [, %arg ])

Defines the directive I<$directive> as a valid configuration directive; you
must define new configuration directives B<before> you read the configuration
file, or else the read will fail.

=head2 $cfg->ExternalUserManagement()

Returns boolean value indicating whether the configuration is set so that
external users management feature in Movable Type Enterprise is turned on.

=head1 CONFIGURATION DIRECTIVES

The following configuration directives are allowed in F<mt.cfg>. To get the
value of a directive, treat it as a method that you are calling on the
I<$cfg> object. For example:

    $cfg->CGIPath

To set the value of a directive, do the same as the above, but pass in a value
to the method:

    $cfg->CGIPath('http://www.foo.com/mt/');

A list of valid configuration directives can be found in the
I<CONFIGURATION SETTINGS> section of the manual.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
