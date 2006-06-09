# Copyright 2001-2006 Six Apart. This code cannot be redistributed without
# permission from www.sixapart.com.  For more information, consult your
# Movable Type license.
#
# $Id$

package MT::ObjectDriver;
use strict;

use MT::ConfigMgr;

use MT::ErrorHandler;
@MT::ObjectDriver::ISA = qw( MT::ErrorHandler );

sub new {
    my $class = shift;
    my $type = shift;
    $class .= "::" . $type;
    eval "use $class;";
    die "Unsupported driver $class: $@" if $@;
    my $driver = bless {}, $class;
    $driver->init(@_) or return $class->error($driver->errstr);
    $driver;
}

sub init {
    my $driver = shift;
    $driver->{cfg} = MT::ConfigMgr->instance;
    $driver;
}

sub cfg { $_[0]->{cfg} }

sub load;
sub exists;
sub save;
sub clear_cache {}
sub configure {}

sub set_callback_routine {
    my $driver = shift;
    $driver->{callback_routine} = $_[0];
}

sub run_callbacks {
    my $driver = shift;
    my $cb;
    if (($cb = $driver->{callback_routine}) && (ref($cb) eq 'CODE')){
        $cb->('MT', @_);
    }
}

sub sql {0}
sub can_add_column {0}
sub can_alter_column {0}
sub can_drop_column {0}
sub column_defs {}
sub fix_class {()}
sub upgrade_begin {()}
sub upgrade_end {()}
sub add_column {()}
sub alter_column {()}
sub drop_column {()}
sub drop_table {()}
sub create_table {()}
sub index_table {()}
sub create_sequence {}
sub drop_sequence {}

1;
