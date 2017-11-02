#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/lib"; # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test::Tag;
plan tests => 2 * blocks;

use MT;

use MT::Test;
my $app = MT->instance;

$test_env->prepare_fixture('db_data');

my $blog_id = 2;

filters {
    template              => [qw( chomp )],
    expected              => [qw( chomp )],
    current_mapping_url   => [qw( chomp )],
    preferred_mapping_url => [qw( chomp )],
};

sub undef_to_empty_string {
    defined( $_[0] ) ? $_[0] : '';
}

MT::Test::Tag->run_perl_tests($blog_id, \&_set_mapping_url_perl);
MT::Test::Tag->run_php_tests($blog_id, \&_set_mapping_url_php);

sub _set_mapping_url_perl {
    my ($ctx, $block) = @_;
    $ctx->stash( 'current_mapping_url',   $block->current_mapping_url );
    $ctx->stash( 'preferred_mapping_url', $block->preferred_mapping_url );
}

sub _set_mapping_url_php {
    my ($block) = @_;
    my $current_mapping_url = $block->current_mapping_url;
    my $preferred_mapping_url = $block->preferred_mapping_url;
    return <<"PHP";
\$ctx->stash('current_mapping_url', '$current_mapping_url');
\$ctx->stash('preferred_mapping_url', '$preferred_mapping_url');
PHP
}

__END__

=== mt:CanonicalURL to an "index" file
--- template
<mt:CanonicalURL />
--- expected
http://example.com/preferred_mapping_url/
--- current_mapping_url
http://example.com/current_mapping_url/index.html
--- preferred_mapping_url
http://example.com/preferred_mapping_url/index.html

=== mt:CanonicalURL to a not "index" file
--- template
<mt:CanonicalURL />
--- expected
http://example.com/preferred_mapping_url/file.html
--- current_mapping_url
http://example.com/current_mapping_url/file.html
--- preferred_mapping_url
http://example.com/preferred_mapping_url/file.html

=== mt:CanonicalURL with a "with_index" attribute
--- template
<mt:CanonicalURL with_index="1" />
--- expected
http://example.com/preferred_mapping_url/index.html
--- current_mapping_url
http://example.com/current_mapping_url/index.html
--- preferred_mapping_url
http://example.com/preferred_mapping_url/index.html

=== mt:CanonicalURL with a "current_mapping" attribute
--- template
<mt:CanonicalURL current_mapping="1" />
--- expected
http://example.com/current_mapping_url/
--- current_mapping_url
http://example.com/current_mapping_url/index.html
--- preferred_mapping_url
http://example.com/preferred_mapping_url/index.html

=== mt:CanonicalLink to an "index" file
--- template
<mt:CanonicalLink />
--- expected
<link rel="canonical" href="http://example.com/preferred_mapping_url/" />
--- current_mapping_url
http://example.com/current_mapping_url/index.html
--- preferred_mapping_url
http://example.com/preferred_mapping_url/index.html

=== mt:CanonicalLink to a not "index" file
--- template
<mt:CanonicalLink />
--- expected
<link rel="canonical" href="http://example.com/preferred_mapping_url/file.html" />
--- current_mapping_url
http://example.com/current_mapping_url/file.html
--- preferred_mapping_url
http://example.com/preferred_mapping_url/file.html

=== mt:CanonicalLink with a "with_index" attribute
--- template
<mt:CanonicalLink with_index="1" />
--- expected
<link rel="canonical" href="http://example.com/preferred_mapping_url/index.html" />
--- current_mapping_url
http://example.com/current_mapping_url/index.html
--- preferred_mapping_url
http://example.com/preferred_mapping_url/index.html

=== mt:CanonicalLink with a "current_mapping" attribute
--- template
<mt:CanonicalLink current_mapping="1" />
--- expected
<link rel="canonical" href="http://example.com/current_mapping_url/" />
--- current_mapping_url
http://example.com/current_mapping_url/index.html
--- preferred_mapping_url
http://example.com/preferred_mapping_url/index.html
