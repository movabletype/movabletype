# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::Test::Util::Plugin;
use strict;
use warnings;
use MT::Test::Env;

sub new {
    my $class = shift;
    my ( $env, $plugin_dir ) = @_;
    $plugin_dir //= 'plugins';
    my $self = { env => $env, plugin_dir => $plugin_dir };
    bless $self, $class;
    $self;
}

sub gen_dir_with_pl {
    my ( $self, $name, $version, $dir, $pl_file ) = @_;
    my $plugin_dir = $self->{plugin_dir};
    my $id = lc $name;
    $self->{env}->save_file("${plugin_dir}/${dir}/${pl_file}", <<"PLUGIN" );
package $name;
our \$VERSION = '$version';
require MT;
require MT::Plugin;
my \$plugin = MT::Plugin->new({
    id => '$id',
    name => '$name',
    version => \$VERSION,
});
MT->add_plugin(\$plugin);
1;
PLUGIN
}

sub gen_dir_with_yaml {
    my ( $self, $name, $version, $dir ) = @_;
    my $plugin_dir = $self->{plugin_dir};
    my $id = lc $name;
    $self->{env}->save_file("${plugin_dir}/${dir}/config.yaml", <<"YAML" );
id: $id
name: $name
version: $version
YAML
}

sub gen_pl {
    my ( $self, $name, $version, $pl_file ) = @_;
    my $plugin_dir = $self->{plugin_dir};
    my $id = lc $name;
    $self->{env}->save_file("${plugin_dir}/${pl_file}", <<"PLUGIN" );
package $name;
our \$VERSION = '$version';
require MT;
require MT::Plugin;
my \$plugin = MT::Plugin->new({
    id => '$id',
    name => '$name',
    version => \$VERSION,
});
MT->add_plugin(\$plugin);
1;
PLUGIN
}

1;
