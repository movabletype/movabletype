#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib",    # t/lib
    "$FindBin::Bin/../..";         # $ENV{MT_HOME}
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new(
        PluginPath => ['TEST_ROOT/plugins'],
    );
    $ENV{MT_CONFIG} = $test_env->config_file;

    $test_env->save_file('plugins/Awesome/config.yaml', <<'YAML');
name: Awesome
key:  awesome
id:   awesome

object_types:
    awesome:       MT::Awesome
    awesome_image: MT::Awesome::Image

backup_instructions:
    awesome:
        skip: 1
    awesome_image:
        skip: 1
YAML

    $test_env->save_file('plugins/Awesome/lib/MT/Awesome.pm', <<'PM');
package MT::Awesome;

use strict;
use warnings;
use base qw( MT::Object );

__PACKAGE__->install_properties(
    {   column_defs => {
            id        => 'integer not null auto_increment',
            title     => 'string(255)',
            file      => 'string(255)',
            mime_type => 'string meta',
        },
        meta        => 1,
        class_type  => 'foo',
        datasource  => 'awesome',
        primary_key => 'id',
    }
);

1;
PM

    $test_env->save_file('plugins/Awesome/lib/MT/Awesome/Image.pm', <<'PM');
package MT::Awesome::Image;

use strict;
use warnings;
use base qw( MT::Awesome );

__PACKAGE__->install_properties(
    {   class_type  => 'image',
        column_defs => {
            'width'  => 'integer meta',
            'height' => 'integer meta indexed',
        },
    }
);

1;
PM
}

use MT::Test;
use MT::Test::Memcached;

my $memcached = MT::Test::Memcached->new or plan skip_all => "Memcached is not available";
MT->config(MemcachedServers => $memcached->address);

my $m = MT::Memcached->instance;
$m->set(__FILE__, __FILE__, 1);

(my $filename = __FILE__) =~ s/-memcached\.t\z/.t/;
require("./$filename");    # t/64-objectmeta.t
