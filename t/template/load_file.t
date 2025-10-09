use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use File::Temp;
use Test::More;
use Test::Exception;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new(
        PluginPath => [qw(
            MT_HOME/plugins
            TEST_ROOT/plugins
        )],
    );
    $ENV{MT_CONFIG} = $test_env->config_file;

    $test_env->save_file('plugins/TmplLoadFilePluginYaml/config.yaml', <<'YAML');
id: TmplLoadFilePluginYaml
key: TmplLoadFilePluginYaml
name: TmplLoadFilePluginYaml
version: 0.1.0
author: test
YAML

    $test_env->save_file('plugins/TmplLoadFilePluginYaml/tmpl/test_yaml.tmpl', <<'TMPL');
test_yaml.tmpl
TMPL

    $test_env->save_file('plugins/TmplLoadFilePluginPl/plugin.pl', <<'PL');
package MT::PluginTmplLoadFilePluginPl;
use strict;
use warnings;
use base qw(MT::Plugin);
use MT;
my $plugin = __PACKAGE__->new({
  id => 'TmplLoadFilePluginPl',
  key => 'TmplLoadFilePluginPl',
  name => 'TmplLoadFilePluginPl',
  version => '0.2.0',
  author => 'test',
});
1;
PL

    $test_env->save_file('plugins/TmplLoadFilePluginPl/tmpl/test_pl.tmpl', <<'TMPL');
test_pl.tmpl
TMPL
}

use MT;

$test_env->prepare_fixture('db');

my $mt = MT->new or die MT->errstr;

subtest 'relative path' => sub {
    subtest 'found in the include_path' => sub {
        my $file = 'error.tmpl';    # tmpl/error.tmpl
        my $tmpl = _get_tmpl();
        ok $tmpl->load_file($file);
        ok !$tmpl->errstr;
    };

    subtest 'found in the outside of include_path' => sub {
        my $file = 'plugins/FormattedText/tmpl/cms/edit_formatted_text.tmpl';
        my $tmpl = _get_tmpl();
        throws_ok {
            $tmpl->load_file($file);
        }
        qr/\ATemplate load error: Tried to load the template file from outside of the include path/;
    };

    subtest 'not found' => sub {
        my $file = 'not_found.tmpl';
        my $tmpl = _get_tmpl();
        ok !$tmpl->load_file($file);
        is $tmpl->errstr, "File not found: ${file}\n";
    };
};

subtest 'absolute path' => sub {
    subtest 'found in the include_path (core)' => sub {
        my $file = $mt->mt_dir . '/tmpl/error.tmpl';
        my $tmpl = _get_tmpl();
        ok $tmpl->load_file($file);
        ok !$tmpl->errstr;
    };

    subtest 'found in the include_path (core yaml plugin)' => sub {
        my $file = $mt->mt_dir . '/plugins/FormattedText/tmpl/cms/edit_formatted_text.tmpl';
        my $tmpl = _get_tmpl();
        ok $tmpl->load_file($file);
        ok !$tmpl->errstr;
    };

    subtest 'found in the include_path (not core yaml plugin)' => sub {
        my $file = $ENV{MT_TEST_ROOT} . '/plugins/TmplLoadFilePluginYaml/tmpl/test_yaml.tmpl';
        my $tmpl = _get_tmpl();
        ok $tmpl->load_file($file);
        ok !$tmpl->errstr;
    };

    subtest 'found in the include_path (not core pl plugin)' => sub {
        my $file = $ENV{MT_TEST_ROOT} . '/plugins/TmplLoadFilePluginPl/tmpl/test_pl.tmpl';
        my $tmpl = _get_tmpl();
        ok $tmpl->load_file($file);
        ok !$tmpl->errstr;
    };

    subtest 'not found in outside of the include_path' => sub {
        my $file = '/not_found.tmpl';
        my $tmpl = _get_tmpl();
        throws_ok {
            $tmpl->load_file($file);
        }
        qr/Template load error: Tried to load the template file from outside of the include path/;
    };

    subtest 'not found in the include_path' => sub {
        my $file = $mt->mt_dir . '/tmpl/not_found.tmpl';
        my $tmpl = _get_tmpl();
        ok !$tmpl->load_file($file);
        is $tmpl->errstr, "File not found: ${file}\n";
    };

    subtest 'found in the outside of include_path' => sub {
        my $file = $mt->mt_dir . '/search_templates/default.tmpl';
        my $tmpl = _get_tmpl();
        throws_ok {
            $tmpl->load_file($file);
        }
        qr/Template load error: Tried to load the template file from outside of the include path/;
    };

};

done_testing;

sub _get_tmpl {
    my $tmpl = MT::Template->new;
    $tmpl->{include_path} = [$mt->template_paths];
    return $tmpl;
}
