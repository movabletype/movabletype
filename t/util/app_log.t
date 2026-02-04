use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib"; # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new(
        LoggerModule => 'Log::Minimal',
        LoggerLevel  => 'INFO',
        LoggerPath   => 'TEST_ROOT',
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT;
use MT::App;
use MT::Test;
use MT::Test::Permission;

$test_env->prepare_fixture('db');

my $app = MT::App->instance;

my $blog    = MT::Test::Permission->make_website( name => 'first site' );
my $blog2   = MT::Test::Permission->make_website( name => 'second site' );
my $author  = MT::Test::Permission->make_author( name => 'foo' );
my $author2 = MT::Test::Permission->make_author( name => 'bar' );


MT->log('log 1');
$app->log('log 2');

$app->blog($blog);
$app->user($author);

MT->log('log 3');
$app->log('log 4');

MT->log( { message => 'log 5' } );

$app->log( { message => 'log 6' } );

MT->log(
    {
        message => 'log 7',
        author_id => $author2->id,
        blog_id => $blog2->id,
    }
);

$app->log(
    {
        message => 'log 8',
        author_id => $author2->id,
        blog_id => $blog2->id,
    }
);

my @logs = MT::Log->load;
is @logs => 8;

is $logs[0]->blog_id   => 0;
is $logs[0]->author_id => 0;
is $logs[0]->message   => 'log 1';

is $logs[1]->blog_id   => 0;
is $logs[1]->author_id => 0;
is $logs[1]->message   => 'log 2';

is $logs[2]->blog_id   => 0;
is $logs[2]->author_id => 0;
is $logs[2]->message   => 'log 3';

is $logs[3]->blog_id   => $blog->id;
is $logs[3]->author_id => $author->id;
is $logs[3]->message   => 'log 4';

is $logs[4]->blog_id   => 0;
is $logs[4]->author_id => 0;
is $logs[4]->message   => 'log 5';

is $logs[5]->blog_id   => $blog->id;
is $logs[5]->author_id => $author->id;
is $logs[5]->message   => 'log 6';

is $logs[6]->blog_id   => $blog2->id;
is $logs[6]->author_id => $author2->id;
is $logs[6]->message   => 'log 7';

is $logs[7]->blog_id   => $blog2->id;
is $logs[7]->author_id => $author2->id;
is $logs[7]->message   => 'log 8';

done_testing;

END {
    # to close filehandle (for Win32)
    no warnings 'once';
    undef $Log::Minimal::PRINT;
}
