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

plan skip_all => "new UI" unless $ENV{MT_TEST_NEW_UI};
plan tests => 1 * blocks;

use MT;
use MT::Test;

$test_env->prepare_fixture('db_data');

my $app  = MT->instance;
my $blog_id = 1;

filters {
    template => [qw( chomp )],
    expected => [qw( chomp )],
};

run {
    my $block = shift;

SKIP:
    {
        skip $block->skip, 1 if $block->skip;

        my $tmpl = $app->model('template')->new;
        $tmpl->text( $block->template );
        my $ctx = $tmpl->context;

        my $blog = $app->model('blog')->load($blog_id);
        $ctx->stash( 'blog',          $blog );
        $ctx->stash( 'blog_id',       $blog->id );
        $ctx->stash( 'local_blog_id', $blog->id );
        $ctx->stash( 'builder',       MT::Builder->new );

        my $result = $app->translate_templatized($tmpl->build);
        $result =~ s/\A(\r\n|\r|\n|\s)+|(\r\n|\r|\n|\s)+\z//g;
        $result =~ s/^\s*$(\r\n|\r|\n)//gm;

        is( $result, $block->expected, $block->name );
    }
};

__END__

=== mtapp:settinggroup
--- template
<mtapp:settinggroup id="test-group">
<mtapp:setting id="test" label="<__trans phrase="Phrase" />">
Test: <input id="test" />
</mtapp:setting>
</mtapp:settinggroup>
--- expected
<fieldset id="test-group">
<div id="test-field" class="field field-left-label ">
    <div class="field-header">
      <label id="test-label" for="test">Phrase</label>
    </div>
    <div class="field-content ">
Test: <input id="test" />
    </div>
</div>
</fieldset>
