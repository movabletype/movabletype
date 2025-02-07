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
use MT::Test::Permission;

$test_env->prepare_fixture('db');

subtest 'MTC-30082' => sub {
    my $author      = MT::Test::Permission->make_author;
    my $parent_site = MT::Test::Permission->make_website;
    my $child_site  = MT::Test::Permission->make_blog(parent_id => $parent_site->id);

    my ($role_administer_site) = MT->model('role')->load_by_permission('administer_site');
    die unless $role_administer_site;

    MT->model('association')->link($author => $role_administer_site => $parent_site);
    MT->model('association')->link($author => $role_administer_site => $child_site);

    my $perm_parent_site = $author->permissions($parent_site->id) or die;
    $perm_parent_site->set_these_restrictions('edit_tags');
    ok $perm_parent_site->can_edit_tags, 'When a permission has administer_site in parent site, dynamic permission method does not check restrictions';

    my $perm_child_site = $author->permissions($child_site->id) or die;
    $perm_child_site->set_these_restrictions('create_site');
    ok $perm_child_site->can_create_site, 'When a permission has administer_site in child site, dynamic permission method does not check restrictions';
};

done_testing;
