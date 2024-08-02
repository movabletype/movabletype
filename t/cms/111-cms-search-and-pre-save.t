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
use MT::Test::Permission;
use MT::PublishOption;
use MT::Test::App;

$test_env->prepare_fixture('db_data');

my $admin = MT::Author->load(1);
my $site  = MT::Website->load(2);

subtest 'template attributes' => sub {
    my %params_to_test = (
        include_with_ssi => 1,
        cache_path => '/path/to/cache',
        cache_expire_type => 1,
        cache_expire_interval => 30,
        build_interval => 60,
        build_type => MT::PublishOption::SCHEDULED(),
    );
    MT::Test::Permission->make_template(
        blog_id => $site->id,
        name => 'template to replace',
        text => 'Text to replace',
        type => 'module',
        outfile => '',
        %params_to_test,
    );

    my $app = MT::Test::App->new;
    $app->login($admin);
    $app->post_ok({
        __mode => 'search_replace',
        _type => 'template',
        blog_id => $site->id,
        search => 'replace',
        do_search => 1,
    });
    my @ids;
    $app->wq_find('#template-listing-table tr td.cb input[type="checkbox"]')->each(sub {
        push @ids, $_->attr('value');
    });

    my $form = $app->form;
    my %param = (
        do_search => '',
        do_replace => 1,
        orig_search => 'replace',
        replace => 'replaced',
        'search-replace-toggle' => 'replace',
        replace_ids => join(',', @ids),
    );
    for my $key (keys %param) {
        my $input = $form->find_input($key);
        if ($input) {
            $input->readonly(0);
            $input->value($param{$key});
        }
    }
    $app->post_ok($form->click);

    $test_env->clear_mt_cache;

    my $tmpl = MT->model('template')->load($ids[0]);
    for my $key (keys %params_to_test) {
        is $tmpl->$key => $params_to_test{$key}, "$key is intact";
    }
};

subtest 'blog attributes' => sub {
    my %params_to_test = (
        sanitize_spec => 1,
    );
    MT::Test::Permission->make_blog(
        parent_id => $site->id,
        name => 'Site to replace',
        %params_to_test,
    );

    my $app = MT::Test::App->new;
    $app->login($admin);
    $app->post_ok({
        __mode => 'search_replace',
        _type => 'blog',
        blog_id => $site->id,
        search => 'replace',
        do_search => 1,
    });
    my @ids;
    $app->wq_find('#blog-listing-table tr td.cb input[type="checkbox"]')->each(sub {
        push @ids, $_->attr('value');
    });

    my $form = $app->form;
    my %param = (
        do_search => '',
        do_replace => 1,
        orig_search => 'replace',
        replace => 'replaced',
        'search-replace-toggle' => 'replace',
        replace_ids => join(',', @ids),
    );
    for my $key (keys %param) {
        my $input = $form->find_input($key);
        if ($input) {
            $input->readonly(0);
            $input->value($param{$key});
        }
    }
    $app->post_ok($form->click);

    $test_env->clear_mt_cache;

    my $blog = MT->model('blog')->load($ids[0]);
    for my $key (keys %params_to_test) {
        is $blog->$key => $params_to_test{$key}, "$key is intact";
    }
};

done_testing;
