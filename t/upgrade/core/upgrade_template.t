use strict;
use warnings;
use utf8;
use FindBin;
use POSIX qw(ceil);
use lib "$FindBin::Bin/../../lib";    # t/lib
use Mock::MonkeyPatch;
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new(
        PluginPath => ['TEST_ROOT/plugins'],
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
    $test_env->save_file("plugins/UpgradeTemplateTest/config.yaml", <<"PLUGIN" );
id: UpgradeTemplateTest
name: UpgradeTemplateTest
version: 1.0
l10n_lexicon:
  ja:
    Test Template: テストテンプレート
    Test Title: テストタイトル
default_templates:
  base_path: default_templates
  system:
    test_system_template:
      label: Test Template
PLUGIN
    $test_env->save_file("plugins/UpgradeTemplateTest/default_templates/test_system_template.mtml", <<"MTML" );
<title><__trans phrase="Test Title"></title>
MTML
}

use MT;
use MT::Test::Permission;
use MT::Test::Upgrade;
use MT::Template;

$test_env->prepare_fixture('db');

my @global_tmpl_names     = ();
my @blog_system_tmpl_keys = ();
for my $tmpl (@{ MT::DefaultTemplates->templates }) {
    if ($tmpl->{global}) {
        push @global_tmpl_names, $tmpl->{name};
        next;
    }

    next if $tmpl->{set} ne 'system';    # only system templates will by installed
    push @blog_system_tmpl_keys, $tmpl->{type};
}
@global_tmpl_names     = sort @global_tmpl_names;
@blog_system_tmpl_keys = sort @blog_system_tmpl_keys;

my $website = MT::Test::Permission->make_website(
    language => 'en_US',
);
my $blog = MT::Test::Permission->make_blog(
    language => 'ja',
);

my %added_steps     = ();
my $mocked_add_step = Mock::MonkeyPatch->patch(
    'MT::Upgrade::add_step' => sub {
        $added_steps{ $_[1] }++;
        Mock::MonkeyPatch::ORIGINAL(@_);
    },
);

subtest 'step: upgrade_templates' => sub {
    subtest 'created all system templates' => sub {
        %added_steps = ();
        MT::Template->remove;
        MT::Test::Upgrade->upgrade(from => 8.0000);

        my @global_installed_tmpl_names = map { $_->name } MT::Template->load(
            { blog_id => 0 },
            { sort    => 'name' },
        );
        is_deeply \@global_installed_tmpl_names, \@global_tmpl_names, 'created all global templates';

        my @website_tmpl_keys = map { $_->type } MT::Template->load({
                blog_id => $website->id,
                type    => \@blog_system_tmpl_keys,
            },
            { sort => 'type' },
        );
        is_deeply \@website_tmpl_keys, \@blog_system_tmpl_keys, 'created all system templates for website';
        my @blog_tmpl_keys = map { $_->type } MT::Template->load({
                blog_id => $blog->id,
                type    => \@blog_system_tmpl_keys,
            },
            { sort => 'type' },
        );
        is_deeply \@blog_tmpl_keys, \@blog_system_tmpl_keys, 'created all system templates for blog';

        my $website_tmpl = MT::Template->load({
            blog_id => $website->id,
            type    => 'test_system_template'
        });
        ok $website_tmpl, 'created new website template';
        is $website_tmpl->name, 'Test Template';
        is $website_tmpl->text, "<title>Test Title</title>\n";

        my $blog_tmpl = MT::Template->load({
            blog_id => $blog->id,
            type    => 'test_system_template'
        });
        ok $blog_tmpl, 'created new blog template';
        is $blog_tmpl->name, 'テストテンプレート';
        is $blog_tmpl->text, "<title>テストタイトル</title>\n";

        is $added_steps{'core_upgrade_templates'}, 1, 'called core_upgrade_templates step';
    };

    subtest 'performed in several steps' => sub {
        my $batch_size;
        my $blog_count     = MT::Blog->count({ class => '*' });
        my $template_count = $blog_count * scalar @blog_system_tmpl_keys;
        my $runner         = sub {
            no warnings 'once';
            local $MT::Upgrade::Core::INSTALL_TEMPLATE_BATCH_SIZE = $batch_size;

            %added_steps = ();
            MT::Template->remove;
            MT::Test::Upgrade->upgrade(from => 8.0000);

            my @website_tmpl_keys = map { $_->type } MT::Template->load({
                    blog_id => $website->id,
                    type    => \@blog_system_tmpl_keys,
                },
                { sort => 'type' },
            );
            is_deeply \@website_tmpl_keys, \@blog_system_tmpl_keys, 'created all system templates for website';
            my @blog_tmpl_keys = map { $_->type } MT::Template->load({
                    blog_id => $blog->id,
                    type    => \@blog_system_tmpl_keys,
                },
                { sort => 'type' },
            );
            is_deeply \@blog_tmpl_keys, \@blog_system_tmpl_keys, 'created all system templates for blog';

            is $added_steps{'core_upgrade_templates'}, ceil($template_count / $batch_size);
        };

        subtest 'divisible batch size' => sub {
            $batch_size = $blog_count;
            $runner->();
        };

        subtest 'indivisible batch size' => sub {
            $batch_size = $blog_count + 1;
            $runner->();
        };
    };
};

done_testing;
