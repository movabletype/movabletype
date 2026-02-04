#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../../t/lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT;
use MT::Test;
use MT::Test::Permission;
use MT::CMS::RebuildTrigger;
use MT::Test::App;
use JSON;

$test_env->prepare_fixture(sub {
    MT::Test->init_db;

    my $site = MT::Test::Permission->make_website(name => 'my test website');

    my $blog = MT::Test::Permission->make_blog(parent_id => $site->id, name => 'my test blog');

    my $ct  = MT::Test::Permission->make_content_type(blog_id => $blog->id, name => 'testct_a',);
    my $ct2 = MT::Test::Permission->make_content_type(blog_id => $blog->id, name => 'testct_b',);
    my $ct3 = MT::Test::Permission->make_content_type(blog_id => $site->id, name => 'testct_c',);

    my $cf = MT::Test::Permission->make_content_field(
        blog_id         => $ct->blog_id,
        content_type_id => $ct->id,
        name            => 'single text',
        type            => 'single_line_text',
    );
    $ct->fields([{
        id        => $cf->id,
        label     => 1,
        name      => $cf->name,
        order     => 1,
        type      => $cf->type,
        unique_id => $cf->unique_id,
    }]);
    $ct->save or die $ct->errstr;

    my $cd = MT::Test::Permission->make_content_data(
        blog_id         => $ct->blog_id,
        author_id       => 1,
        content_type_id => $ct->id,
        data            => { $cf->id => 'test text' },
    );
});

my $site = MT->model('website')->load({ name => 'my test website' });
my $blog = MT->model('blog')->load({ name => 'my test blog' });
my $ct   = MT->model('content_type')->load({ name => 'testct_a' });
my $ct2  = MT->model('content_type')->load({ name => 'testct_b' });

require MT::RebuildTrigger;

my $app     = MT->instance;
my $request = MT::Request->instance;

subtest 'ct_count' => sub {
    my @blogs = MT::CMS::RebuildTrigger::ct_count();
    is(@blogs,             2,         'right number');
    is($blogs[0]->{id},    $site->id, 'right blog_id');
    is($blogs[0]->{value}, 1,         'right blog_id');
    is($blogs[1]->{id},    $blog->id, 'right blog_id');
    is($blogs[1]->{value}, 2,         'right blog_id');
};

subtest 'load_config for empty' => sub {
    my $json = MT::CMS::RebuildTrigger::load_config($app, $site->id);
    is($json, '[]', 'right json for empty');
};

subtest 'load_config' => sub {
    my $rt1 = MT::RebuildTrigger->new;
    $rt1->blog_id($site->id);
    $rt1->object_type(MT::RebuildTrigger::TYPE_CONTENT_TYPE());
    $rt1->action(MT::RebuildTrigger::ACTION_RI());
    $rt1->event(MT::RebuildTrigger::EVENT_SAVE());
    $rt1->target(MT::RebuildTrigger::TARGET_BLOG());
    $rt1->target_blog_id($blog->id);
    $rt1->ct_id($ct->id);
    $rt1->save;
    my $rt2 = MT::RebuildTrigger->new;
    $rt2->blog_id($site->id);
    $rt2->object_type(MT::RebuildTrigger::TYPE_CONTENT_TYPE());
    $rt2->action(MT::RebuildTrigger::ACTION_RI());
    $rt2->event(MT::RebuildTrigger::EVENT_PUBLISH());
    $rt2->target(MT::RebuildTrigger::TARGET_BLOG());
    $rt2->target_blog_id($blog->id);
    $rt2->ct_id($ct->id);
    $rt2->save;
    my $rt3 = MT::RebuildTrigger->new;
    $rt3->blog_id($site->id);
    $rt3->object_type(MT::RebuildTrigger::TYPE_ENTRY_OR_PAGE());
    $rt3->action(MT::RebuildTrigger::ACTION_RI());
    $rt3->event(MT::RebuildTrigger::EVENT_UNPUBLISH());
    $rt3->target(MT::RebuildTrigger::TARGET_ALL());
    $rt3->target_blog_id(0);
    $rt3->ct_id($ct->id);
    $rt3->save;
    my $rt4 = $rt3->clone();
    $rt4->id(undef);
    $rt4->blog_id($blog->id);
    $rt4->ct_id($ct2->id);
    $rt4->save;
    my $rt5 = $rt4->clone();
    $rt5->id(undef);
    $rt5->blog_id(100);
    $rt5->save;

    my $json  = MT::CMS::RebuildTrigger::load_config($app, $site->id);
    my $param = JSON->new->utf8(0)->decode(MT::Util::decode_js($json));
    is(ref $param, 'ARRAY', 'right ref');
    is(@$param,    3,       'right number');

    is($param->[0]->{id},             '1',                                          'right value');
    is($param->[0]->{object_type},    MT::RebuildTrigger::TYPE_CONTENT_TYPE(),      'right value');
    is($param->[0]->{object_label},   'testct_a',                                   'right value');
    is($param->[0]->{action},         MT::RebuildTrigger::ACTION_RI(),              'right value');
    is($param->[0]->{action_label},   'rebuild indexes.',                           'right value');
    is($param->[0]->{event},          MT::RebuildTrigger::EVENT_SAVE(),             'right value');
    is($param->[0]->{event_label},    'Save',                                       'right value');
    is($param->[0]->{target},         MT::RebuildTrigger::TARGET_BLOG(),            'right value');
    is($param->[0]->{target_blog_id}, $blog->id,                                    'right value');
    is($param->[0]->{blog_name},      'my test blog',                               'right value');
    is($param->[0]->{ct_id},          $ct->id,                                      'right value');
    is($param->[0]->{ct_name},        'testct_a',                                   'right value');
    is($param->[1]->{id},             '2',                                          'right value');
    is($param->[1]->{object_type},    MT::RebuildTrigger::TYPE_CONTENT_TYPE(),      'right value');
    is($param->[1]->{object_label},   'testct_a',                                   'right value');
    is($param->[1]->{action},         MT::RebuildTrigger::ACTION_RI(),              'right value');
    is($param->[1]->{action_label},   'rebuild indexes.',                           'right value');
    is($param->[1]->{event},          MT::RebuildTrigger::EVENT_PUBLISH(),          'right value');
    is($param->[1]->{event_label},    'Publish',                                    'right value');
    is($param->[1]->{target},         MT::RebuildTrigger::TARGET_BLOG(),            'right value');
    is($param->[1]->{target_blog_id}, $blog->id,                                    'right value');
    is($param->[1]->{blog_name},      'my test blog',                               'right value');
    is($param->[1]->{ct_id},          $ct->id,                                      'right value');
    is($param->[1]->{ct_name},        'testct_a',                                   'right value');
    is($param->[2]->{id},             '3',                                          'right value');
    is($param->[2]->{object_type},    MT::RebuildTrigger::TYPE_ENTRY_OR_PAGE(),     'right value');
    is($param->[2]->{object_label},   'testct_a',                                   'right value');
    is($param->[2]->{action},         MT::RebuildTrigger::ACTION_RI(),              'right value');
    is($param->[2]->{action_label},   'rebuild indexes.',                           'right value');
    is($param->[2]->{event},          MT::RebuildTrigger::EVENT_UNPUBLISH(),        'right value');
    is($param->[2]->{event_label},    'Unpublish',                                  'right value');
    is($param->[2]->{target},         MT::RebuildTrigger::TARGET_ALL(),             'right value');
    is($param->[2]->{target_blog_id}, 0,                                            'right value');
    is($param->[2]->{blog_name},      '(All sites and child sites in this system)', 'right value');
    is($param->[2]->{ct_id},          $ct->id,                                      'right value');
    is($param->[2]->{ct_name},        'testct_a',                                   'right value');
};

subtest 'config' => sub {
    my $app = MT::Test::App->new;
    $app->login(MT::Author->load(1));

    my $script;
    $app->get_ok({ __mode => 'cfg_rebuild_trigger', blog_id => $site->id });
    $script = $app->wq_find("head script[data-rebuildtrigger]")->as_html;
    like($script, qr/testct_a/, 'right html');
    unlike($script, qr/testct_c/, 'right html');

    $app->get_ok({ __mode => 'cfg_rebuild_trigger', blog_id => $blog->id });
    $script = $app->wq_find("head script[data-rebuildtrigger]")->as_html;
    like($script, qr/testct_b/, 'right html');
    unlike($script, qr/testct_a/, 'right html');

    $app->get_ok({ __mode => 'add_rebuild_trigger', blog_id => $blog->id, dialog => 1 });
    $app->get_ok({ __mode => 'add_rebuild_trigger', blog_id => $site->id, dialog => 1 });

    # avoid searching just by a single word 'test' as the uppercased 'TEST' is a part of the TEST_ROOT template
    $app->post_ok({ __mode => 'add_rebuild_trigger', blog_id => $site->id, json => 1, _type => 'site', offset => 0, search => 'my test' });
    ok $app->content !~ /site-_1/, 'not include pre_build';
    ok $app->content !~ /site-_2/, 'not include pre_build';
    ok $app->content =~ /my test blog/, 'include my test blog';
    ok $app->content !~ /First Website/, 'not include First Website' or note $app->content;
    ok $app->content =~ /"pager":null/, 'page is null';

    $app->post_ok({ __mode => 'add_rebuild_trigger', blog_id => $site->id, json => 1, _type => 'site', offset => 0 });
    ok $app->content =~ /site-_1/,       'include pre_build selection';
    ok $app->content =~ /site-_2/,       'include pre_build selection';
    ok $app->content =~ /my test blog/,  'include my test blog';
    ok $app->content =~ /First Website/, 'include First Website';
    ok $app->content =~ /"listTotal":2/, 'right listTotal';

    $app->post_ok({
        __mode => 'add_rebuild_trigger', blog_id => $site->id, json => 1, _type => 'content_type',
        select_blog_id => $blog->id, offset => 0, search => 'testct_b'
    });
    ok $app->content !~ /testct_a/, 'not include testct_a';
    ok $app->content =~ /testct_b/, 'include testct_b';
    ok $app->content =~ /"pager":null/, 'page is null';

    $app->post_ok({
        __mode => 'add_rebuild_trigger', blog_id => $site->id, json => 1, _type => 'content_type',
        select_blog_id => $blog->id, offset => 0
    });
    ok $app->content =~ /testct_a/, 'include testct_a';
    ok $app->content =~ /testct_b/, 'include testct_b';
    ok $app->content =~ /"listTotal":2/, 'right listTotal';
};

done_testing;
