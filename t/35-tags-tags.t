#!/usr/bin/perl

use strict;
use warnings;

use lib qw(lib t/lib);

BEGIN {
    $ENV{MT_CONFIG} = 'mysql-test.cfg';
}

use IPC::Open2;

use Test::Base;
plan tests => 2 * blocks;

use MT;
use MT::Test qw(:db);
my $app = MT->instance;

my $blog_id = 1;

filters {
    template => [qw( chomp )],
    expected => [qw( chomp )],
};

my $mt = MT->instance;

{
    my $b = $mt->model('blog')->new;
    $b->set_values({
        id => 1,
    });
    $b->save or die $b->errstr;
}

{
    my $e = $mt->model('entry')->new;
    $e->set_values({
        blog_id => 1,
        author_id => 1,
        status => MT::Entry::RELEASE,
    });
    $e->tags(qw(@1clm TEST));
    $e->save or die $e->errstr;
}

{
    my $p = $mt->model('page')->new;
    $p->set_values({
        blog_id => 1,
        author_id => 1,
        status => MT::Entry::RELEASE,
    });
    $p->tags(qw(@1clm TEST));
    $p->save or die $p->errstr;
}

{
    my $a = $mt->model('asset')->new;
    $a->set_values({
        blog_id => 1,
        author_id => 1,
    });
    $a->tags(qw(@1clm TEST));
    $a->save or die $a->errstr;
}

run {
    my $block = shift;

SKIP:
    {
        skip $block->skip, 1 if $block->skip;

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

        is( $result, $block->expected, $block->name );
    }
};

sub php_test_script {
    my ( $template, $text ) = @_;
    $text ||= '';

    my $test_script = <<PHP;
<?php
\$MT_HOME   = '@{[ $ENV{MT_HOME} ? $ENV{MT_HOME} : '.' ]}';
\$MT_CONFIG = '@{[ $app->find_config ]}';
\$blog_id   = '$blog_id';
\$tmpl = <<<__TMPL__
$template
__TMPL__
;
\$text = <<<__TMPL__
$text
__TMPL__
;
PHP
    $test_script .= <<'PHP';
include_once($MT_HOME . '/php/mt.php');
include_once($MT_HOME . '/php/lib/MTUtil.php');

$mt = MT::get_instance(1, $MT_CONFIG);
$mt->init_plugins();

$db = $mt->db();
$ctx =& $mt->context();

$ctx->stash('blog_id', $blog_id);
$ctx->stash('local_blog_id', $blog_id);
$blog = $db->fetch_blog($blog_id);
$ctx->stash('blog', $blog);

if ($ctx->_compile_source('evaluated template', $tmpl, $_var_compiled)) {
    $ctx->_eval('?>' . $_var_compiled);
} else {
    print('Error compiling template module.');
}

?>
PHP
}

SKIP:
{
    unless ( join( '', `php --version 2>&1` ) =~ m/^php/i ) {
        skip "Can't find executable file: php",
            1 * blocks('expected_dynamic');
    }

    run {
        my $block = shift;

    SKIP:
        {
            skip $block->skip, 1 if $block->skip;

            open2( my $php_in, my $php_out, 'php -q' );
            print $php_out &php_test_script( $block->template, $block->text );
            close $php_out;
            my $php_result = do { local $/; <$php_in> };
            $php_result =~ s/^(\r\n|\r|\n|\s)+|(\r\n|\r|\n|\s)+\z//g;

            my $name = $block->name . ' - dynamic';
            is( $php_result, $block->expected, $name );
        }
    };
}


__END__

=== mt:EntryTags
--- template
<mt:Entries><mt:EntryTags><mt:TagLabel /></mt:EntryTags></mt:Entries>
--- expected
TEST

=== mt:EntryTags with include_private="1"
--- template
<mt:Entries><mt:EntryTags include_private="1" glue=","><mt:TagLabel /></mt:EntryTags></mt:Entries>
--- expected
@1clm,TEST

=== mt:EntryIfTagged called twice
--- template
<mt:Entries><mt:EntryIfTagged></mt:EntryIfTagged><mt:EntryIfTagged tag="@1clm">OK</mt:EntryIfTagged></mt:Entries>
--- expected
OK

=== mt:PageTags
--- template
<mt:Pages><mt:PageTags><mt:TagLabel /></mt:PageTags></mt:Pages>
--- expected
TEST

=== mt:PageTags with include_private="1"
--- template
<mt:Pages><mt:PageTags include_private="1" glue=","><mt:TagLabel /></mt:PageTags></mt:Pages>
--- expected
@1clm,TEST

=== mt:PageIfTagged called twice
--- template
<mt:Pages><mt:PageIfTagged></mt:PageIfTagged><mt:PageIfTagged tag="@1clm">OK</mt:PageIfTagged></mt:Pages>
--- expected
OK

=== mt:AssetTags
--- template
<mt:Assets><mt:AssetTags><mt:TagLabel /></mt:AssetTags></mt:Assets>
--- expected
TEST

=== mt:AssetTags with include_private="1"
--- template
<mt:Assets><mt:AssetTags include_private="1" glue=","><mt:TagLabel /></mt:AssetTags></mt:Assets>
--- expected
@1clm,TEST

=== mt:AssetIfTagged called twice
--- template
<mt:Assets><mt:AssetIfTagged></mt:AssetIfTagged><mt:AssetIfTagged tag="@1clm">OK</mt:AssetIfTagged></mt:Assets>
--- expected
OK

