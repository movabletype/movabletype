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

    $test_env->save_file('plugins/AwesomeEditor/config.yaml', <<'YAML');
id: AwesomeEditor
name: AwesomeEditor
version: 0.1

editors:
  awesome_editor:
    label: Awesome Editor
  another_editor:
    extension: extension.tmpl
YAML
}

use utf8;
use Test::Base::Less;
use MT::Util::Editor;

my $app = MT->instance;

sub set_config {
    my ($config) = @_;

    $MT::Util::Editor::current_wysiwyg_editor = undef;
    $MT::Util::Editor::current_source_editor  = undef;

    $app->config($_, undef)         for qw(Editor WYSIWYGEditor SourceEditor);
    $app->config($_, $config->{$_}) for keys %$config;
}

subtest 'When the Editor environment variable is defined' => sub {
    set_config({
        Editor => 'awesome_editor',
    });

    is MT::Util::Editor::current_wysiwyg_editor($app), 'awesome_editor';
    is MT::Util::Editor::current_source_editor($app),  'awesome_editor';
};

subtest 'When the Editor environment variable is not defined' => sub {
    set_config({});

    is MT::Util::Editor::current_wysiwyg_editor($app), 'tinymce';
    is MT::Util::Editor::current_source_editor($app),  'tinymce';
};

subtest 'When the Editor environment variable is specified as unavailable editor' => sub {
    set_config({
        Editor => 'non_existent_editor',
    });

    is MT::Util::Editor::current_wysiwyg_editor($app), 'tinymce';
    is MT::Util::Editor::current_source_editor($app),  'tinymce';
};

subtest 'When the WYSIWYGEditor environment variable is defined' => sub {
    set_config({
        WYSIWYGEditor => 'awesome_editor',
    });

    is MT::Util::Editor::current_wysiwyg_editor($app), 'awesome_editor';
    is MT::Util::Editor::current_source_editor($app),  'tinymce';
};

subtest 'When the SourceEditor environment variable is defined' => sub {
    set_config({
        SourceEditor => 'awesome_editor',
    });

    is MT::Util::Editor::current_wysiwyg_editor($app), 'tinymce';
    is MT::Util::Editor::current_source_editor($app),  'awesome_editor';
};

done_testing;
