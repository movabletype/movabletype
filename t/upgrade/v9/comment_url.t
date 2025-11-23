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
use MT::Test::Permission;
use MT::Test::Upgrade;

$test_env->prepare_fixture('db');

my $blog_id   = 1;
my $author_id = 1;
my $entry     = MT::Test::Permission->make_entry(
    blog_id     => $blog_id,
    author_id   => $author_id,
    authored_on => '20180829000000',
    title       => 'entry1',
);
my $no_url_comment = MT::Test::Permission->make_comment(
    blog_id  => $blog_id,
    entry_id => $entry->id,
    url      => '',
);
my $valid_url_comment = MT::Test::Permission->make_comment(
    blog_id  => $blog_id,
    entry_id => $entry->id,
    url      => 'http://example.com',
);
my $invalid_url_comment = MT::Test::Permission->make_comment(
    blog_id  => $blog_id,
    entry_id => $entry->id,
    url      => 'schemeless-url.example.com',
);

subtest 'Initialize link_default_target' => sub {
    MT::Test::Upgrade->upgrade(from => 9.0002);

    $no_url_comment->refresh;
    $valid_url_comment->refresh;
    $invalid_url_comment->refresh;

    is $no_url_comment->url,      '';
    is $valid_url_comment->url,   'http://example.com';
    is $invalid_url_comment->url, '';
};

done_testing;
