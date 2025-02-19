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

$test_env->prepare_fixture('content_data');

use MT;
use MT::Test::Tag;

plan tests => (1 + 2) * blocks;

my $blog_id = MT::Blog->load({name => 'My Site'})->id;
my $ct = MT::ContentType->load({name => 'test content data'});

my $vars = {
    ct_id        => $ct->id,
    ct_unique_id => $ct->unique_id,
    ct_name      => $ct->name,
};

sub var {
    for my $line (@_) {
        for my $key ( keys %{$vars} ) {
            my $replace = quotemeta "[% ${key} %]";
            my $value   = $vars->{$key};
            $line =~ s/$replace/$value/g;
        }
    }
    @_;
}

filters {
    template => [qw( var chomp )],
    expected => [qw( var chomp )],
};

MT::Test::Tag->run_perl_tests($blog_id);
MT::Test::Tag->run_php_tests($blog_id);

__END__

=== MT:Tags with content_type="ct_id"
--- template
<mt:Tags type="content_type" content_type="[% ct_id %]"><mt:ContentTypeName>: <mt:TagName>
</mt:Tags>
--- expected
test content data: tag1
test content data: tag2

=== MT:Tags with content_type="ct_unique_id"
--- template
<mt:Tags type="content_type" content_type="[% ct_unique_id %]"><mt:ContentTypeName>: <mt:TagName>
</mt:Tags>
--- expected
test content data: tag1
test content data: tag2

=== MT:Tags with content_type="ct_name"
--- template
<mt:Tags type="content_type" content_type="[% ct_name %]"><mt:ContentTypeName>: <mt:TagName>
</mt:Tags>
--- expected
test content data: tag1
test content data: tag2
