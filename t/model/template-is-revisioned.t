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
use MT::Test::Permission;

MT->instance;

$test_env->prepare_fixture('db');

my $website = MT->model('website')->load or die;
my $blog_id = $website->id;

my $tmpl = MT::Test::Permission->make_template( blog_id => $blog_id );

ok( !$tmpl->is_revisioned, q{created mt_template's is_revisioned is false} );
is( $tmpl->current_revision, 0, 'current_revision is 0' );

my $orig = $tmpl->clone;
$tmpl->text(123);
$tmpl->save or die $tmpl->errstr;

$tmpl->gather_changed_cols($orig);
my $revision = $tmpl->save_revision('changed text colun to "123"');
$tmpl->current_revision($revision);
$tmpl->update or die $tmpl->errstr;
$tmpl->refresh;

ok( !$tmpl->is_revisioned, q{updated mt_template's is_revisioned is false} );
is( $tmpl->current_revision, 1, 'current_revision is 1' );

my $rev      = $tmpl->load_revision( { rev_number => 1 } );
my $rev_tmpl = $rev->[0];
ok( !$tmpl->is_revisioned, q{original mt_template's is_revisioned is false} );
ok( $rev_tmpl->is_revisioned,
    q{revision mt_template's is_revisioned is true } );
ok( !$rev_tmpl->clone->is_revisioned,
    q{cloned revision mt_template's is_revisioned is false} );

$rev_tmpl->needs_db_sync(1);
$rev_tmpl->_resync_to_db;
ok( scalar( $rev_tmpl->changed_cols ),
    q{revision mt_template is not saved after called needs_db_sync} );

done_testing;

