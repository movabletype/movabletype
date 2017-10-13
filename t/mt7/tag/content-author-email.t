#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../lib"; # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use utf8;

use lib qw(lib t/lib);

use MT::Test::Tag;

# plan tests => 2 * blocks;
plan tests => 1 * blocks;

use MT;
use MT::Test qw(:db);
use MT::Test::Permission;
my $app = MT->instance;

my $blog_id = 1;

filters {
    template => [qw( chomp )],
    expected => [qw( chomp )],
    error    => [qw( chomp )],
};

my $mt = MT->instance;

my $ct = MT::Test::Permission->make_content_type(
    name    => 'test content data',
    blog_id => $blog_id,
);
my $cd = MT::Test::Permission->make_content_data(
    blog_id         => $blog_id,
    content_type_id => $ct->id,
);
my $author = $cd->author;
$author->email( 'abby@example.com' );
$author->save or die $author->errstr;

MT::Test::Tag->run_perl_tests($blog_id);
# MT::Test::Tag->run_php_tests($blog_id);

__END__

=== MT::ContentAuthorEmail
--- template
<mt:Contents blog_id="1" name="test content data"><mt:ContentAuthorEmail></mt:Contents>
--- expected
abby@example.com

=== MT::ContentAuthorEmail with span_protect="1"
--- template
<mt:Contents blog_id="1" name="test content data"><mt:ContentAuthorEmail spam_protect="1"></mt:Contents>
--- expected
abby&#64;example&#46;com

