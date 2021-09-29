use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test::Tag;
use MT::Util qw(ts2epoch epoch2ts);
use MT::Test::Permission;

$test_env->prepare_fixture('db');

my $entry = MT::Test::Permission->make_entry(blog_id => 1, status => 2, author_id => 1);

my $asset = MT::Test::Permission->make_asset(
    class   => 'image',
    blog_id => 1,
    url     => 'http://narnia.na/nana/images/test2.jpg',
    file_path => File::Spec->catfile( $ENV{MT_HOME}, "t", 'images', 'test2.jpg' ),
    file_name    => 'test2.jpg',
    file_ext     => 'jpg',
    image_width  => 640,
    image_height => 480,
    mime_type    => 'image/jpeg',
    label        => 'Sample Image',
    description  => 'Sample photo',
);

my $score = MT::Test::Permission->make_objectscore(
    object_ds => 'asset',
    object_id => $asset->id,
    score     => 3,
    author_id => 1,
    namespace => 'foo',
);

MT::Test::Tag->run_perl_tests(1);
MT::Test::Tag->run_php_tests(1);

done_testing;

__DATA__

=== test 1
--- template
<mt:Assets namespace="foo" scored_by="Melody">a</mt:Assets>
--- expected
a
