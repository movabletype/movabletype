#!/usr/bin/perl
use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../lib";    # t/lib
use Test::More;
use MT::Test::Env;

our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new(

        # to serve actual js libraries
        StaticFilePath => "MT_HOME/mt-static/",

        BaseSitePath => "/tmp/dummy_path",
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test;
use MT;
use MT::Test::Selenium;
use Selenium::Waiter;

$test_env->prepare_fixture('db_data');

my $author = MT->model('author')->load(1);    # Melody
$author->set_password('Nelson');
$author->save or die;

my $blog_id = MT->model('blog')->load->id;

my $selenium = MT::Test::Selenium->new($test_env);

$selenium->login($author);
my $magic_token = $selenium->get_current_value('input[name=magic_token]', 'value');

$selenium->request({
    __request_method => 'GET',
    __mode           => 'dialog_adjust_sitepath',
    blog_ids         => $blog_id,
    magic_token      => $magic_token,
});
$selenium->wait_until_ready;

my $use_absolute = wait_until { $selenium->driver->find_elements('div.option.use-absolute') };
is scalar @{$use_absolute}, 0, 'does not exist div.option.use-abosolute';

my $relative_site_path_hint = wait_until {
    $selenium->driver->find_elements('small.relative-site_path-hint')
};
is scalar @{$relative_site_path_hint}, 2, 'exists two div.relative-site_path-hint';

ok $relative_site_path_hint->[0]->is_displayed, 'visible div.relative-site_path-hint (site path)';
ok $relative_site_path_hint->[1]->is_displayed, 'visible div.relative-site_path-hint (archive path)';

my $absolute_site_path_hint = wait_until {
    $selenium->driver->find_elements('small.absolute-site_path-hint')
};
is scalar @{$absolute_site_path_hint}, 0, 'does not exist div.absolute-site_path-hint';

done_testing;

