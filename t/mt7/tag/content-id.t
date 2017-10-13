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
MT::Test::Permission->make_content_data(
    blog_id         => $blog_id,
    content_type_id => $ct->id,
) for ( 0, 1 );

MT::Test::Tag->run_perl_tests($blog_id);
# MT::Test::Tag->run_php_tests($blog_id);

__END__

=== MT::ContentID
--- template
<mt:Contents blog_id="1" name="test content data"><mt:ContentID> </mt:Contents>
--- expected
2 1

=== MT::ContentID with pad modifier
--- template
<mt:Contents blog_id="1" name="test content data"><mt:ContentID pad="1"> </mt:Contents>
--- expected
000002 000001

=== MT::ContentID without content context
--- template
<mt:ContentID>
--- error
You used an 'mtContentID' tag outside of the context of a content; Perhaps you mistakenly placed it outside of an 'MTContents' container tag?

