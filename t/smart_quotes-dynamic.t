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

use IPC::Open2;

use Test::Base;
plan tests => 1 * blocks;

use MT;
use MT::Test;
use MT::Test::Permission;
my $app = MT->instance;

$test_env->prepare_fixture('db');

my $blog_id = 1;

filters {
    template => [qw( chomp )],
    expected => [qw( chomp )],
};

my $mt = MT->instance;

my $blog = MT::Blog->load($blog_id);
$blog->archive_type('Category');
$blog->save or die $blog->errstr;

my $entry = MT::Test::Permission->make_entry( blog_id => $blog_id );
my $cat = MT::Test::Permission->make_category( blog_id => $blog_id, label => 'foo_bar' );
MT::Test::Permission->make_placement(
    blog_id => $blog_id,
    entry_id => $entry->id,
    category_id => $cat->id,
);

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

=== smart_quotes = 1 Double quotation
--- template
<mt:Unless smart_quotes="1">"test"</mt:Unless>
--- expected
&#8220;test&#8221;

=== smart_quotes = 1 Double Single quotation
--- template
<mt:Unless smart_quotes="1">'test'</mt:Unless>
--- expected
&#8216;test&#8217;

=== smart_quotes = 1 Back quotation
--- template
<mt:Unless smart_quotes="1">``test``</mt:Unless>
--- expected
``test``

=== smart_quotes = 1 escape
--- template
<mt:Unless smart_quotes="1">\\test\\</mt:Unless>
--- expected
\test\

=== smart_quotes = 1 period
--- template
<mt:Unless smart_quotes="1">\.test\.</mt:Unless>
--- expected
\.test\.

=== smart_quotes = 1 hyphen
--- template
<mt:Unless smart_quotes="1">\-test\-</mt:Unless>
--- expected
\-test\-

=== smart_quotes = 1 escape double quotation
--- template
<mt:Unless smart_quotes="1">\"test\"</mt:Unless>
--- expected
\&#8221;test\&#8221;

=== smart_quotes = 1 escape single quotation
--- template
<mt:Unless smart_quotes="1">\'test\'</mt:Unless>
--- expected
\&#8217;test\&#8217;

=== smart_quotes = 1 escape back quotation
--- template
<mt:Unless smart_quotes="1">\`test\`</mt:Unless>
--- expected
\`test\`

=== smart_quotes = 2 Double quotation
--- template
<mt:Unless smart_quotes="2">"test"</mt:Unless>
--- expected
&#8220;test&#8221;

=== smart_quotes = 2 Single quotation
--- template
<mt:Unless smart_quotes="2">'test'</mt:Unless>
--- expected
&#8216;test&#8217;

=== smart_quotes = 2 Back quotation
--- template
<mt:Unless smart_quotes="2">``test``</mt:Unless>
--- expected
&#8220;test&#8220;

=== smart_quotes = 2 escape
--- template
<mt:Unless smart_quotes="2">\\test\\</mt:Unless>
--- expected
\test\

=== smart_quotes = 2 period
--- template
<mt:Unless smart_quotes="2">\.test\.</mt:Unless>
--- expected
\.test\.

=== smart_quotes = 2 hyphen
--- template
<mt:Unless smart_quotes="2">\-test\-</mt:Unless>
--- expected
\-test\-

=== smart_quotes = 2 escape double quotation
--- template
<mt:Unless smart_quotes="2">\"test\"</mt:Unless>
--- expected
\&#8221;test\&#8221;

=== smart_quotes = 2 escape single quotation
--- template
<mt:Unless smart_quotes="2">\'test\'</mt:Unless>
--- expected
\&#8217;test\&#8217;

=== smart_quotes = 2 escape back quotation
--- template
<mt:Unless smart_quotes="2">\`test\`</mt:Unless>
--- expected
\`test\`
