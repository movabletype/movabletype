use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new(
        DefaultLanguage => 'en_US',    ## for now
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test;
use MT::Test::App;
use MT::Test::Fixture;

$test_env->prepare_fixture('db');
my $objs = MT::Test::Fixture->prepare({
    website => [{ name => 'My Site' }],
    entry   => [{
        basename => 'entry',
        title    => 'entry',
        status   => 'publish',
    }],
    template => [{
            archive_type => 'Individual',
            name         => 'tmpl_entry',
            text         => 'entry test',
            mapping      => [{
                file_template => 'entry/%-f',
                is_preferred  => 1,
            }],
        }, {
            type    => 'index',
            name    => 'tmpl_index',
            outfile => 'index.html',
            text    => 'index test',
        }
    ],
});

my $admin      = MT::Author->load(1);
my $site_id    = $objs->{blog_id};
my $tmpl_index = MT::Template->load({ name => 'tmpl_index' });
my $tmpl_entry = MT::Template->load({ name => 'tmpl_entry' });

subtest 'outfile: ok' => sub {
    my @ok_patterns = (
        'index/test.html',
        'index/f o o.html',
    );
    for my $pattern (@ok_patterns) {
        my $app = MT::Test::App->new;
        $app->login($admin);
        $app->get_ok({
            __mode  => 'view',
            _type   => 'template',
            id      => $tmpl_index->id,
            blog_id => $site_id,
        });
        my $form  = $app->form;
        my $input = $form->find_input('#outfile');
        $input->value($pattern);
        $app->post_ok($form->click);
        like $app->message_text => qr/Your changes have been saved/, "successfully saved: '$pattern'";
        $test_env->clear_mt_cache;
        my $tmpl = MT::Template->load($tmpl_index->id);
        is $tmpl->outfile => $pattern, "outfile is updated";
    }
};

subtest 'outfile: ng' => sub {
    my @ng_patterns = (
        ' index/test.html',
        'index /test.html',
        'index/ test.html',
        'index/test.html ',
    );
    for my $pattern (@ng_patterns) {
        my $app = MT::Test::App->new;
        $app->login($admin);
        $app->get_ok({
            __mode  => 'view',
            _type   => 'template',
            id      => $tmpl_index->id,
            blog_id => $site_id,
        });
        my $form  = $app->form;
        my $input = $form->find_input('#outfile');
        $input->value($pattern);
        $app->post_ok($form->click);
        like $app->generic_error => qr/Save failed: Output filename contains an inappropriate whitespace./, "save failed: '$pattern'";
        $test_env->clear_mt_cache;
        my $tmpl = MT::Template->load($tmpl_index->id);
        isnt $tmpl->outfile => $pattern, "outfile is not updated";
    }
};

subtest 'entry: ok' => sub {
    my @ok_patterns = (
        'entry/%-f',
        'entry/f o o.html',
        '<mt:var name="dir">/%-f',
        'entry/<mt:var name="path">/%-f.html',
        '<$mt:if name="var"$>entry/%-f.html</mt:if>',
        '<mt:var name="<mt:var name="var_name">" >entry/%-f.html',
    );
    for my $pattern (@ok_patterns) {
        my $app = MT::Test::App->new;
        $app->login($admin);
        $app->get_ok({
            __mode  => 'view',
            _type   => 'template',
            id      => $tmpl_entry->id,
            blog_id => $site_id,
        });
        my $form = $app->form;
        my ($input) = grep { $_->name && $_->name =~ /^archive_file_tmpl_/ } $form->inputs;
        $input->value($pattern);
        $app->post_ok($form->click);
        like $app->message_text => qr/Your changes have been saved/, "successfully saved: '$pattern'";
        $test_env->clear_mt_cache;
        my $map = MT::TemplateMap->load({ template_id => $tmpl_entry->id });
        is $map->file_template => $pattern, "mapping is updated";
    }
};

subtest 'entry: ng' => sub {
    my @ng_patterns = (
        ' entry/%-f',
        'entry /%-f',
        'entry/ %-f',
        'entry/%-f ',
        '<mt:if name="var"> entry/%-f</mt:if>',
        '<mt:var name="dir"> /%-f',
        ' <mt:var name="dir">/%-f',
        'entry/ <mt:var name="path"> /%-f.html',
        '<mt:if name="var">entry/%-f </mt:if>',
        '<mt:var name="<mt:var name="var_name">"> entry/%-f.html',
    );
    for my $pattern (@ng_patterns) {
        my $app = MT::Test::App->new;
        $app->login($admin);
        $app->get_ok({
            __mode  => 'view',
            _type   => 'template',
            id      => $tmpl_entry->id,
            blog_id => $site_id,
        });
        my $form = $app->form;
        my ($input) = grep { $_->name && $_->name =~ /^archive_file_tmpl_/ } $form->inputs;
        $input->value($pattern);
        $app->post_ok($form->click);
        like $app->generic_error => qr/Save failed: Archive mapping '[^']*?' contains an inappropriate whitespace./, "save failed: '$pattern'";
        $test_env->clear_mt_cache;
        my $map = MT::TemplateMap->load({ template_id => $tmpl_entry->id });
        isnt $map->file_template => $pattern, "mapping is not updated";
    }
};

done_testing;
