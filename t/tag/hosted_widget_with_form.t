use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new(
        PluginPath => [qw(TEST_ROOT/plugins)],
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
    $test_env->save_file('plugins/WidgetTest/config.yaml', <<'YAML');
id: WidgetTest
name: WidgetTest
version: 0.01
widgets:
    with_a_form:
        label: With a form
        template: widget/with_a_form.tmpl
        handler: |
            sub {
                return 1;
            }
        singular: 1
        set: sidebar
        view:
            - user
            - system
            - website
            - blog
        order: 1
        default: 1
    with_a_simple_form:
        label: With a form
        template: widget/with_a_simple_form.tmpl
        handler: |
            sub {
                return 1;
            }
        singular: 1
        set: sidebar
        view:
            - user
            - system
            - website
            - blog
        order: 1
        default: 1
    without_a_form:
        label: With a form
        template: widget/without_a_form.tmpl
        handler: |
            sub {
                return 1;
            }
        singular: 1
        set: sidebar
        view:
            - user
            - system
            - website
            - blog
        order: 1
        default: 1
YAML

    $test_env->save_file('plugins/WidgetTest/tmpl/widget/with_a_form.tmpl', <<'TMPL');
<mtapp:widget id="test_widget_with_a_form" label="Test Widget With A Form">
<form method="post" id="my_form">
inside of my form
</form>
</mtapp:widget>
TMPL

    $test_env->save_file('plugins/WidgetTest/tmpl/widget/with_a_simple_form.tmpl', <<'TMPL');
<mtapp:widget id="test_widget_with_a_simple_form" label="Test Widget With A Simple Form">
<form>
inside of my simple form
</form>
</mtapp:widget>
TMPL

    $test_env->save_file('plugins/WidgetTest/tmpl/widget/without_a_form.tmpl', <<'TMPL');
<mtapp:widget id="test_widget_without_a_form" label="Test Widget Without A Form">
inside of my widget
</mtapp:widget>
TMPL
}

use MT;
use MT::Test::App;

MT->instance;

$test_env->prepare_fixture('db');

my $admin = MT::Author->load(1);

my $app = MT::Test::App->new;
$app->login($admin);
$app->get_ok({__mode => 'dashboard'});

subtest 'hosted widget with a form' => sub {
    my $test_widget = $app->wq_find('div#test_widget_with_a_form');
    ok $test_widget->html, "test widget exists";
    ok $test_widget->find('form#my_form')->html, "my form exists";
    ok !$test_widget->find('form#test_widget_with_a_form-form')->html, "generated form does not exist";
};

subtest 'hosted widget with a simple form' => sub {
    my $test_widget = $app->wq_find('div#test_widget_with_a_simple_form');
    ok $test_widget->html, "test widget exists";
    ok $test_widget->find('form')->html, "my form exists";
    ok !$test_widget->find('form#test_widget_with_a_simple_form-form')->html, "generated form does not exist";
};

subtest 'hosted widget without a form' => sub {
    my $test_widget = $app->wq_find('div#test_widget_without_a_form');
    ok $test_widget->html, "test widget exists";
    ok $test_widget->find('form#test_widget_without_a_form-form')->html, "generated form exists";
};

subtest 'widget not hosted' => sub {
    my $test_widget = $app->wq_find('div#mt_news');
    ok $test_widget->html, "mt_news widget exists";
    ok $test_widget->find('form#mt_news-form')->html, "generated form exists";
};

done_testing;
