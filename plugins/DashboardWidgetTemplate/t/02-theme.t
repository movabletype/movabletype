#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new(ThemesDirectory => [qw(TEST_ROOT/themes)]);
    $ENV{MT_CONFIG} = $test_env->config_file;

    $test_env->save_file('themes/dashboard_widget_template/theme.yaml', <<'YAML');
id: dashboard_widget_template
class: website
elements:
  template_set: 
    component: ~
    data: 
      base_path: templates
      label: exported_template set
      templates: 
        dashboard_widget: 
          unpinned_widget: 
            label: Unpinned Widget
          pinned_widget: 
            label: Pinned Widget
            pinned: 1
    importer: template_set
YAML

    $test_env->save_file('themes/dashboard_widget_template/templates/unpinned_widget.mtml', <<'YAML');
Unpinned Widget
YAML

    $test_env->save_file('themes/dashboard_widget_template/templates/pinned_widget.mtml', <<'YAML');
Pinned Widget
YAML
}

use MT;
use MT::Test;
use MT::Test::Permission;

$test_env->prepare_fixture('db');

MT::Test->init_cms;

my $admin   = MT::Author->load(1);
my $website = MT::Website->load();
my $theme   = MT::Theme->load('dashboard_widget_template');

subtest 'apply theme' => sub {
    $theme->apply($website);
    my @templates = MT->model('template')->load({
        blog_id => $website->id,
        type    => 'dashboard_widget',
    });
    my ($unpinned, $pinned) = sort { ($a->dashboard_widget_pinned // 0) <=> ($b->dashboard_widget_pinned // 0) } @templates;
    is $unpinned->name,                  'Unpinned Widget';
    is $pinned->name,                    'Pinned Widget';
    is $pinned->dashboard_widget_pinned, 1;
};

subtest 'export theme' => sub {
    my $exporter = MT->registry('theme_element_handlers')->{template_set}{exporter};
    my $code = MT->handler_to_coderef($exporter->{export});
    my $data = $code->( MT->instance, $website, undef );

    is_deeply $data->{templates}{dashboard_widget}, {
        unpinned_widget => {
            label => 'Unpinned Widget',
        },
        pinned_widget => {
            label => 'Pinned Widget',
            pinned => 1,
        },
    };
};

done_testing;
