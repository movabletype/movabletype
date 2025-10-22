use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new(
        PluginPath => ['TEST_ROOT/plugins'],
    );
    $ENV{MT_CONFIG} = $test_env->config_file;

    $test_env->save_file('plugins/MyPlugin/config.yaml', <<'YAML');
id: MyPlugin
name: MyPlugin
version: 0.1

applications:
  cms:
    methods:
      my_json_response:
        handler: $MyPlugin::MyPlugin::my_json_response
        app_mode: JSON
      test_page:
        handler: $MyPlugin::MyPlugin::test_page
YAML

    $test_env->save_file('plugins/MyPlugin/lib/MyPlugin.pm', <<'PM');
package MyPlugin;
use strict;
use warnings;

sub my_json_response {
    my $app   = shift;
    my %param = ref $_[0] eq 'HASH' ? %{$_[0]} : @_;

    return $app->json_result({ test => 'ok', %param });
}

sub test_page {
    my $app = shift;
    $app->load_tmpl('test_page.tmpl');
}
1;
PM

    $test_env->save_file('plugins/MyPlugin/tmpl/test_page.tmpl', <<'TMPL');
<div data-mt-response="<mtapp:EmbedJsonResponse mode="my_json_response" param="param_value" escape="html">"></div>
TMPL
}

use MT::Test::App;
use Mojo::DOM;
use JSON;

$test_env->prepare_fixture('db');

my $admin = MT::Author->load(1);

my $app = MT::Test::App->new;
$app->login($admin);
$app->get_ok({
    __mode => 'test_page',
});
ok my $json = Mojo::DOM->new($app->content)->at('div')->attr('data-mt-response'), "retrieve json";
ok my $data = eval { decode_json($json) },                                        "decode json";
is $data->{test}  => 'ok',          "test is ok";
is $data->{param} => 'param_value', "forwarded param is ok";

done_testing;
