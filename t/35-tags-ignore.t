#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/lib"; # t/lib
use Test::More;
use MT::Test::Env;
BEGIN {
    eval { require Test::MockModule }
        or plan skip_all => 'Test::MockModule is not installed';
}

our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT;
use MT::Builder;
use MT::Template::Context;

use MT::Test qw( :app );

# setup
my %callbacks;
my $mock_mt = Test::MockModule->new('MT');
$mock_mt->mock(
    'run_callbacks',
    sub {
        my ( $app, $meth, @param ) = @_;
        $callbacks{$meth} ||= [];
        push @{ $callbacks{$meth} }, \@param;
        $mock_mt->original('run_callbacks')->(@_);
    }
);

my $app     = MT->instance;
my $builder = MT::Builder->new;
my $ctx     = MT::Template::Context->new;

# test
subtest
    'MTIgnore tags can be searched by getElementsByTagName method in edit_entry.tmpl'
    => sub {

    my $tmpl = $app->load_tmpl('edit_entry.tmpl');
    $app->build_page($tmpl);

    ok( exists $callbacks{'MT::App::template_param.edit_entry'},
        'MT::App::template_param.edit_entry was called'
    );

    my $param_tmpl = $callbacks{'MT::App::template_param.edit_entry'}->[0][2];
    is( ref $param_tmpl,
        'MT::Template', 'parameter\'s class is MT::Template' );

    ok( $param_tmpl->getElementsByTagName('ignore'),
        'MTIgnore tags can be searched by getElementsByTagName method in edit_entry.tmpl'
    );
    };

done_testing;
