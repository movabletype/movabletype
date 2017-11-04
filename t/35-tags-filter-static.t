#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/lib"; # t/lib
use Test::More;
use MT::Test::Env;
BEGIN {
    eval qq{ use Test::Base; 1 }
        or plan skip_all => 'Test::Base is not installed';
}

our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

plan tests => 1 * blocks;

use MT;
use MT::Test;
my $app = MT->instance;

my $blog_id = 2;

filters {
    template => [qw( chomp )],
    expected => [qw( chomp )],
};

$test_env->prepare_fixture('db_data');

run {
    my $block = shift;

SKIP:
    {
        skip $block->skip, 1 if $block->skip;

        my $name = $block->name || $block->template;
        $name =~ s/\n//g;

        my $tmpl = $app->model('template')->new;
        $tmpl->text( $block->template );
        my $ctx = $tmpl->context;

        my $blog = MT::Blog->load($blog_id);
        $ctx->stash( 'blog',          $blog );
        $ctx->stash( 'blog_id',       $blog->id );
        $ctx->stash( 'local_blog_id', $blog->id );
        $ctx->stash( 'builder',       MT::Builder->new );

        my $result = $tmpl->build;
        $result =~ s/^(\r\n|\r|\n|\s)+|(\r\n|\r|\n|\s)+\z//g;

        is( $result, $block->expected, $name );
    }
};

__END__

===
--- template
<mt:Unless regex_replace="/ab/","ab@example.com ">abc</mt:Unless>
--- expected
ab@example.com c

===
--- template
<mt:Unless regex_replace="/a(b)c/","A$1C">abc</mt:Unless>
--- expected
AbC

===
--- template
<mt:Unless regex_replace="/a(b)c/","A\1C">abc</mt:Unless>
--- expected
AbC

===
--- template
<mt:Unless regex_replace="/a(b)c/","A$C">abc</mt:Unless>
--- expected
A$C

===
--- template
<mt:Unless regex_replace="/a(b)c/","A\nC">abc</mt:Unless>
--- expected
A
C

===
--- template
<mt:Unless regex_replace="/abc/","'$&'">abc</mt:Unless>
--- expected
'abc'
