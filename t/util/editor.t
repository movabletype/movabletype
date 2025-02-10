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

    $test_env->save_file('plugins/MyEditor/config.yaml', <<'YAML');
id: MyEditor
name: MyEditor
version: 0.1

editors:
  my_editor:
    label: My Editor
YAML
}

use utf8;
use Test::Base::Less;
use MT::Util::Editor;

my $app = MT->instance;

sub set_config {
    my ($config) = @_;

    $MT::Util::Editor::current_editor         = undef;
    $MT::Util::Editor::current_wysiwyg_editor = undef;
    $MT::Util::Editor::current_source_editor  = undef;

    $app->config($_, undef)         for qw(Editor WYSIWYGEditor SourceEditor);
    $app->config($_, $config->{$_}) for keys %$config;
}

subtest 'When the editor specified by the environment variable exists' => sub {
    set_config({
        Editor => 'tinymce',
    });

    is MT::Util::Editor::current_editor($app),         'tinymce';
    is MT::Util::Editor::current_wysiwyg_editor($app), 'tinymce';
    is MT::Util::Editor::current_source_editor($app),  'tinymce';
};

subtest 'When the editor specified by the environment variable does not exist' => sub {
    set_config({
        Editor => 'my_unreleased_editor',
    });

    like MT::Util::Editor::current_editor($app),         qr/\A(tinymce|my_editor)\z/;
    like MT::Util::Editor::current_wysiwyg_editor($app), qr/\A(tinymce|my_editor)\z/;
    like MT::Util::Editor::current_source_editor($app),  qr/\A(tinymce|my_editor)\z/;
};

subtest 'When the wysiwyg editor specified' => sub {
    set_config({
        Editor        => 'my_editor',
        WYSIWYGEditor => 'tinymce',
    });

    is MT::Util::Editor::current_editor($app),         'my_editor';
    is MT::Util::Editor::current_wysiwyg_editor($app), 'tinymce';
    is MT::Util::Editor::current_source_editor($app),  'my_editor';
};

subtest 'When the source editor specified' => sub {
    set_config({
        Editor       => 'my_editor',
        SourceEditor => 'tinymce',
    });

    $app->config('Editor',        'my_editor');
    $app->config('WYSIWYGEditor', 'my_editor');
    $app->config('SourceEditor',  'tinymce');

    is MT::Util::Editor::current_editor($app),         'my_editor';
    is MT::Util::Editor::current_wysiwyg_editor($app), 'my_editor';
    is MT::Util::Editor::current_source_editor($app),  'tinymce';
};

done_testing;
