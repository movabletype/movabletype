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
use MT::Permission;

$test_env->prepare_fixture('db');

subtest 'can_upload' => sub {
    my $perm = MT::Permission->new(author_id => 1, blog_id => 1);
    ok !$perm->permissions, 'has no permissions';

    $perm->can_upload(1);
    ok $perm->has('upload'), 'has upload permission after call "can_upload(1)"';

    $perm->can_upload(0);
    ok !$perm->has('upload'), 'has no upload permission after call "can_upload(0)"';
};

subtest 'remove_permissions' => sub {
    my $perm = MT::Permission->new(author_id => 1, blog_id => 1);
    ok !$perm->permissions, 'has no permissions';

    $perm->set_these_permissions('create_post', 'edit_templates', 'rebuild', 'create_site');
    ok $perm->has('create_post'),    'has create_post permission';
    ok $perm->has('edit_templates'), 'has edit_templates permission';
    ok $perm->has('rebuild'),        'has rebuild permission';
    ok $perm->has('create_site'),    'has create_site permissions';

    $perm->remove_permissions('create_post', 'rebuild', 'manage_users');
    ok !$perm->has('create_post'),   'has no create_post permission';
    ok $perm->has('edit_templates'), 'has edit_templates permission';
    ok !$perm->has('rebuild'),       'has no rebuild permission';
    ok $perm->has('create_site'),    'has create_site permission';
    ok !$perm->has('manage_users'),  'has no manage_users permission';
};

subtest 'remove_restrictions' => sub {
    my $perm = MT::Permission->new(author_id => 1, blog_id => 1);
    ok !$perm->restrictions, 'has no restrictions';

    $perm->set_these_restrictions('create_post', 'edit_templates', 'rebuild', 'create_site');
    ok $perm->is_restricted('create_post'),    'has create_post restriction';
    ok $perm->is_restricted('edit_templates'), 'has edit_templates restriction';
    ok $perm->is_restricted('rebuild'),        'has rebuild restriction';
    ok $perm->is_restricted('create_site'),    'has create_site restriction';

    $perm->remove_restrictions('create_post', 'rebuild', 'manage_users');
    ok !$perm->is_restricted('create_post'),   'has no create_post restriction';
    ok $perm->is_restricted('edit_templates'), 'has edit_templates restriction';
    ok !$perm->is_restricted('rebuild'),       'has no rebuild restriction';
    ok $perm->is_restricted('create_site'),    'has create_site restriction';
    ok !$perm->is_restricted('manage_users'),  'has no manage_users restriction';
};

done_testing;
