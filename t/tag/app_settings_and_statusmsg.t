use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new(
        PluginPath      => ['TEST_ROOT/plugins'],
        DefaultLanguage => 'ja',
    );
    $ENV{MT_CONFIG} = $test_env->config_file;

    $test_env->save_file('plugins/MockFA/config.yaml', <<'YAML');
id: MockFA
name: MockFA
version: 0.1

applications:
  cms:
    methods:
      mockfa_login_form:
        handler: $MockFA::MockFA::login_form
        requires_login: 0
YAML

    $test_env->save_file('plugins/MockFA/lib/MockFA.pm', <<'PM');
package MockFA;
use strict;
use warnings;

sub login_form {
    my $app = shift;

    my $param = {
        templates => [],
        scripts   => [],
    };

    $app->run_callbacks('mfa_render_form', $app, $param);

    unless (@{ $param->{templates} }) {
        return $app->json_result({});
    }

    return $app->json_result({
        html => [ map { ref $_ ? MT->build_page_in_mem($_) : $_ } @{ $param->{templates} } ],
    });
}
1;
PM

    $test_env->save_file('plugins/MockFAT/config.yaml', <<'YAML');
id: MockFAT
name: MockFAT
version: 0.1

callbacks:
  mfa_render_form: $MockFAT::MockFAT::render_form

l10n_lexicon:
  ja:
    Security token: 確認コード
    "Enter the security token.": 確認コードを入力してください
    "MockFAT is translated successfully.": MockFAT の翻訳に成功しました
YAML

    $test_env->save_file('plugins/MockFAT/lib/MockFAT.pm', <<'PM');
package MockFAT;
use strict;
use warnings;

sub render_form {
    my ($cb, $app, $param) = @_;

    push @{ $param->{templates} }, MT->component('MockFAT')->load_tmpl('form.tmpl');

    return 1;
}
1;
PM

    $test_env->save_file('plugins/MockFAT/tmpl/form.tmpl', <<'TMPL');
<mtapp:setting
   id="mockfat-token"
   label="<__trans phrase="Security token">"
   label_for="mockfat-token"
   label_class="top-label form-group"
   hint="<__trans phrase="Enter the security token.">"
   show_hint="1"
   class="mb-3"
   >
  <input type="text" name="mockfat_token" id="mockfat-token" class="form-control text full" required />
</mtapp:setting>

<mtapp:statusmsg
    id="mockfat-status"
    class="success">
    <__trans phrase="MockFAT is translated successfully.">
</mtapp:statusmsg>
TMPL
}

use MT::Test;
use MT::Test::Fixture;
use MT::Test::App;
use JSON;
use Mojo::DOM;
use utf8;

$test_env->prepare_fixture('db');

my $app = MT::Test::App->new;
$app->get_ok({
    __mode => 'mockfa_login_form',
});

my $html  = decode_json($app->content)->{result}{html}[0];
my $dom   = Mojo::DOM->new($html);
my $label = $dom->find('div#mockfat-token-field label')->first->text;
like $label => qr/確認コード/, "app:setting is translated";

my $status = $dom->find('div#mockfat-status')->first->text;
like $status => qr/MockFAT の翻訳に成功しました/, "app:statusmsg is translated";

done_testing;
