use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new(
        PluginPath => [qw(
            MT_HOME/plugins
            MT_HOME/t/plugins
            TEST_ROOT/plugins
        )],
        YAMLModule => 'YAML::Tiny',
    );
    $ENV{MT_CONFIG} = $test_env->config_file;

    my $config_yaml = 'plugins/TestNewSystemPerm/config.yaml';
    $test_env->save_file( $config_yaml, <<'YAML' );
id: TestNewSystemPerm
name: TestNewSystemPerm
applications:
    cms:
        methods:
            new_system_perm_test: |
                sub {
                    my $app = shift;
                    return $app->permission_denied
                        unless $app->can_do('new_system_action');
                    $app->send_http_header('text/plain');
                    $app->print_encode("Test passes");
                    $app->{no_print_body} = 1;
                    return 1;
                }
permissions:
    system.administer:
        inherit_from:
            - system.new_system_permission
    system.new_system_permission:
        group: sys_admin
        label: new system permission
        order: 1500
        permitted_action:
            new_system_action: 1
            access_to_system_dashboard: 1
            access_to_website_list: 1
YAML
}

use MT::Test;
use MT::Test::Fixture;
use MT::Test::App;

### Make test data
$test_env->prepare_fixture('db');
my $objs = MT::Test::Fixture->prepare({
    author  => [{
        name         => 'author_with_perm',
        permissions  => [qw/new_system_permission/],
        is_superuser => 0,
    }, {
        name         => 'author_without_perm',
        is_superuser => 0,
    }],
    website => [{
        name => 'first_site',
    }],
});

my %authors = map {$_->name => $_} MT::Author->load;

subtest 'test new system permission' => sub {
    for my $name (keys %authors) {
        note $name;
        my $author = $authors{$name};
        my $app = MT::Test::App->new;
        $app->login($author);
        $app->get_ok({
            __mode      => 'new_system_perm_test',
            blog_id     => 0,
        });
        if ($name eq 'author_without_perm') {
            $app->has_permission_error("$name: error");
        } else {
            $app->has_no_permission_error("$name: no error");
            $app->content_like('Test passes', "$name: no error");
        }
    }
};

subtest 'assignt new system permission' => sub {
    my $app = MT::Test::App->new;
    $app->login($authors{Melody});
    $app->get_ok({
        __mode  => 'view',
        _type   => 'author',
        blog_id => 0,
        id      => $authors{author_without_perm}->id,
    });
    my $form  = $app->form;
    ok my $input = $form->find_input('can_new_system_permission');
    $input->check;
    $app->post_ok($form->click);
    ok !$app->generic_error, "no error";
};

done_testing;
