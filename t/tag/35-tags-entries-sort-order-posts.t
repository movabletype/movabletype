#!/usr/bin/perl

use strict;
use warnings;
use lib qw(lib t/lib);
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use IPC::Open2;

use Test::Base;
plan tests => 2 * blocks;

use MT;
use MT::Util qw( epoch2ts );
use MT::Test qw(:db);
use MT::Test::Permission;
my $app = MT->instance;

filters {
    template => [qw( chomp )],
    expected => [qw( chomp )],
};

$test_env->prepare_fixture(
    sub {
        MT::Test->init_db;

        my $website = MT->model('website')->load or die;

        my $site = MT::Test::Permission->make_blog(
            parent_id   => $website->id,
            name        => 'test site',
            archive_url => 'http://example.com/sort-order-posts/'
        );

        $site->days_on_index(1);
        $site->sort_order_posts('ascend');
        $site->save;

        my $site_id = $site->id;

        my $time = time;
        my $now  = epoch2ts( $site, $time );
        my $next = epoch2ts( $site_id, $time + 1 );
        my $prev = epoch2ts( $site_id, $time - 1 );

        my $entry_now = MT::Test::Permission->make_entry(
            blog_id     => $site_id,
            title       => "now entry",
            authored_on => $now,
        );

        my $entry_next = MT::Test::Permission->make_entry(
            blog_id     => $site_id,
            title       => "next entry",
            authored_on => $next,
        );

        my $entry_prev = MT::Test::Permission->make_entry(
            blog_id     => $site_id,
            title       => "previous entry",
            authored_on => $prev,
        );
    }
);

my $site = MT->model('blog')->load( { name => 'test site' } );
my $site_id = $site->id;

run {
    my $block = shift;

SKIP:
    {
        skip $block->skip, 1 if $block->skip;

        my $tmpl = $app->model('template')->new;
        $tmpl->text( $block->template );
        my $ctx = $tmpl->context;

        $ctx->stash( 'blog',          $site );
        $ctx->stash( 'blog_id',       $site->id );
        $ctx->stash( 'local_blog_id', $site->id );
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
\$site_id   = '$site_id';
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

$ctx->stash('blog_id', $site_id);
$ctx->stash('local_blog_id', $site_id);
$site = $db->fetch_blog($site_id);
$ctx->stash('blog', $site);

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

=== no modifier (sort_oder_posts => 'ascend')
--- template
<mt:Entries><mt:EntryTitle>
</mt:Entries>
--- expected
previous entry
now entry
next entry

=== sort_order="descend"
--- template
<mt:Entries sort_order="descend"><mt:EntryTitle>
</mt:Entries>
--- expected
next entry
now entry
previous entry

=== sort_order="ascend"
--- template
<mt:Entries sort_order="ascend"><mt:EntryTitle>
</mt:Entries>
--- expected
previous entry
now entry
next entry

=== mt:EntryNext
--- template
<mt:Entries><mt:EntryNext><mt:EntryTitle></mt:EntryNext>
</mt:Entries>
--- expected
now entry
next entry

=== mt:EntryPrevious
--- template
<mt:Entries><mt:EntryPrevious><mt:EntryTitle></mt:EntryPrevious>
</mt:Entries>
--- expected
previous entry
now entry

