#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib"; # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

plan tests => 6;
use Data::Dumper;

use MT::Test;

MT::Test->init_app;

$test_env->prepare_fixture('db_data');

use MT::Blog;

my $blog = MT::Blog->load(1);
$blog->commenter_authenticators('xyzzy');
$blog->save;

ok( ! defined($blog->captcha_provider), q{Initial template set is undef} );

my $is_changed = {};

require MT::Meta::Proxy;

local $SIG{__WARN__} = sub { };
my $orig_save = \&MT::Meta::Proxy::save;

*MT::Meta::Proxy::save = sub {
    my $proxy = shift;
    foreach my $field (keys %{ $proxy->{__objects} } ) {
        next if $field eq '';
        if ($proxy->is_changed($field)) {
            $is_changed->{$field} = 1;
        }
    }
    $orig_save->( $proxy, @_ );
};

$blog->touch;
$blog->save;
is ( scalar (keys %$is_changed), 0, q{$blog->touch doesn't change any meta value} );

$is_changed = {};

$blog->captcha_provider('foo');
$blog->save;

my $blog2 = MT::Blog->load(1);
is( $blog2->captcha_provider, q{foo}, q{Captcha provider meta value saved successfully});
is ( scalar (keys %$is_changed), 1, q{$blog->captcha_provider update touches one meta value} );

$is_changed = {};
$blog->captcha_provider('bar');
$blog->update_pings('baz');
$blog->include_system('zap');
$blog->save;

my $blog3 = MT::Blog->load(1);
ok( ($blog3->captcha_provider eq q{bar} and $blog3->update_pings eq q{baz} and $blog3->include_system eq q{zap}),
    q{Multiple meta values saved successfully});

is ( scalar (keys %$is_changed), 3, q{Multiple meta value saves correctly identify number of saved meta columns} );
