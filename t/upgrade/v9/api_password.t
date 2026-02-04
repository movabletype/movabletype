use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../lib";    # t/lib
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
use MT::Test::Upgrade;

$test_env->prepare_fixture('db');

sub create_author {
    my ($column_values) = @_;
    my $author = MT::Test::Permission->make_author(
        name         => 'test_user',
        nickname     => 'User Test',
        api_password => 'foo',
    );
    $author->save;
    return $author;
}

subtest 'upgrade' => sub {

    subtest 'basic' => sub {
        my $author = create_author();

        MT::Test::Upgrade->upgrade(from => 8.0000);

        my $author2 = MT->model('author')->load($author->id);
        isnt $author2->api_password, 'foo';
        ok $author2->is_valid_api_password('foo');
    };

    subtest 'do not apply multiple times' => sub {
        my $author = create_author();

        MT::Test::Upgrade->upgrade(from => 8.0000);
        MT::Test::Upgrade->upgrade(from => 8.0000);

        my $author2 = MT->model('author')->load($author->id);
        isnt $author2->api_password, 'foo';
        ok $author2->is_valid_api_password('foo');
    };
};

done_testing;
