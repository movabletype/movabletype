use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
use utf8;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file(
        DefaultLanguage => 'ja',
    );

    $test_env->save_file('themes/ContentTypeKey/theme.yaml', <<'YAML');
id: ContentTypeKey
name: ContentTypeKey
label: ContentType Key
class: both
l10n_lexicon:
  ja:
    By Name: 名前検索
elements:
  default_content_data:
    data:
      by_name:
        __ct_name: <__trans phrase="By Name">
        by_name.html:
          identifier: by_name.html
          label: by name
          status: 2
    importer: default_content_data
  default_content_types:
    data:
      - fields:
          - type: multi_line_text
            label: Content
        name: <__trans phrase="By Name">
    importer: default_content_types
YAML
}

use MT::Test;
use MT::Test::App;

MT->instance;

$test_env->prepare_fixture('db');

my $admin = MT->model('author')->load(1);
my $site = MT->model('website')->load(1);

$site->language('ja');
$site->save;

subtest 'By special keys' => sub {
    my $app = MT::Test::App->new;
    $app->login($admin);
    $app->post_ok({
        __mode   => 'apply_theme',
        blog_id  => $site->id,
        theme_id => 'ContentTypeKey',
    });
    $app->has_no_permission_error;

    ok($app->last_location->query_param('applied'), 'Theme has been applied.');

    $site = MT->model('website')->load($site->id);
    is(
        $site->theme_id, 'ContentTypeKey',
        'theme has correct theme_id.'
    );

    subtest 'By name' => sub {
        my $ct = MT->model('content_type')->load({name => '名前検索'});
        ok $ct, "content type is found by a translated name";
        my $cd = MT->model('content_data')->load({content_type_id => $ct->id});
        ok $cd, "content data is found";
    };
};

done_testing;
