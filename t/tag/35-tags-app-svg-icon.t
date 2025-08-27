#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;

our $test_env;

BEGIN {
    eval qq{ use Test::Base; 1 }
      or plan skip_all => 'Test::Base is not installed';
    $test_env = MT::Test::Env->new(
        StaticWebPath => '/mt-static/',
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT;
use MT::Test;
use MT::Util qw(ltrim);

$test_env->prepare_fixture(
    sub {
        MT::Test->init_db;
    }
);

my $app    = MT->instance;
my $config = $app->config;

filters {
    admin_theme_id => [qw( chomp )],
    template       => [qw( chomp )],
    expected       => [qw( chomp)],
    expected_error => [qw( chomp )],
};



use MT::Test::Tag;
plan tests => 1 * blocks;

MT::Test::Tag->run_perl_tests(
    1,
    sub {
        my ( $ctx, $block ) = @_;

        my $admin_theme_id = $block->admin_theme_id;
        $config->AdminThemeId($admin_theme_id);
        $app->{__template_paths} = undef;

    }
);

__END__

=== mtapp:svgicon admin_theme_id=admin2025, id=ic_user, title=User, size=small, color=primary
--- admin_theme_id
admin2025
--- template
<mt:app:svgicon id="ic_user" title="User" size="small" color="primary">ok
--- expected
<svg role="img" class="mt-icon--primary mt-icon--small"><title>User</title><use xlink:href="/mt-static/images/admin2025/sprite.svg#ic_user"></use></svg>ok

=== mtapp:svgicon admin_theme_id=admin2023
--- admin_theme_id
admin2023
--- template
<mt:app:svgicon id="ic_sites">ok
--- expected
<svg role="img" class="mt-icon"><use xlink:href="/mt-static/images/sprite.svg#ic_sites"></use></svg>ok

=== mtapp:svgicon admin_theme_id=''
--- admin_theme_id
''
--- template
<mt:app:svgicon id="ic_add">ok
--- expected
<svg role="img" class="mt-icon"><use xlink:href="/mt-static/images/sprite.svg#ic_add"></use></svg>ok

=== mtapp:svgicon id attribute is required
--- admin_theme_id
--- template
<mt:app:svgicon title="User" size="small">
--- expected_error
id attribute is required
