#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;

our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT;
use MT::Test;
use MT::Test::Permission;
use MT::ListProperty;

my $valid_msg  = 'blog_name bulk_sort valid';
my $system_msg = 'blog_name bulk_sort system';
my $orphan_msg = 'blog_name bulk_sort orphan';

$test_env->prepare_fixture(
    sub {
        MT::Test->init_db;

        my $website = MT::Test::Permission->make_website(
            name => 'bulk_sort website',
        );
        my $blog = MT::Test::Permission->make_blog(
            name      => 'bulk_sort blog',
            parent_id => $website->id,
        );

        MT::Test::Permission->make_log(
            blog_id => $blog->id,
            message => $valid_msg,
        );
        MT::Test::Permission->make_log(
            blog_id => 0,
            message => $system_msg,
        );
        MT::Test::Permission->make_log(
            blog_id => 99999999,
            message => $orphan_msg,
        );
    }
);

my $mt = MT->new;
ok( $mt, 'MT initializes' );

MT->request->reset;
my $prop = MT::ListProperty->instance( 'log', 'blog_name' );
ok( $prop, 'blog_name list property is available for logs' );

sub load_log_by_message {
    my ($message) = @_;
    my $log = MT->model('log')->load( { message => $message } );
    ok( $log, "loaded log: $message" ) or BAIL_OUT("missing test log: $message");
    return $log;
}

sub bulk_sort_without_warnings {
    my (@objs) = @_;
    my @warnings;
    local $SIG{__WARN__} = sub { push @warnings, @_ };
    my @sorted = $prop->bulk_sort( \@objs );
    return ( \@sorted, \@warnings );
}

subtest 'bulk_sort does not warn for undefined blog name cases' => sub {
    my $valid  = load_log_by_message($valid_msg);
    my $system = load_log_by_message($system_msg);
    my $orphan = load_log_by_message($orphan_msg);

    my ( $sorted, $warnings )
        = bulk_sort_without_warnings( $valid, $system, $orphan );

    is( scalar @$warnings, 0, 'no warnings are emitted' )
        or note explain $warnings;
    is( scalar @$sorted, 3, 'bulk_sort returns all objects' );
};

done_testing;
