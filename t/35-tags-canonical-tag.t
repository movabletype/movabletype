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

use MT::Test qw(:db :data);
my $app = MT->instance;

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

        $ctx->stash( 'current_mapping_url',   $block->current_mapping_url );
        $ctx->stash( 'preferred_mapping_url', $block->preferred_mapping_url );

        my $result = $tmpl->build;
        $result =~ s/^(\r\n|\r|\n|\s)+|(\r\n|\r|\n|\s)+\z//g;

        is( $result, $block->expected, $block->name );
    }
};

sub php_test_script {
    my ( $template, $current_mapping_url, $preferred_mapping_url ) = @_;

    my $test_script = <<PHP;
<?php
\$MT_HOME   = '@{[ $ENV{MT_HOME} ? $ENV{MT_HOME} : '.' ]}';
\$MT_CONFIG = '@{[ $app->find_config ]}';
\$blog_id   = '$blog_id';
\$tmpl = <<<__TMPL__
$template
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
PHP

    $test_script .= <<PHP;
\$ctx->stash('current_mapping_url', '$current_mapping_url');
\$ctx->stash('preferred_mapping_url', '$preferred_mapping_url');
PHP

    $test_script .= <<'PHP';
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
            print $php_out &php_test_script( $block->template,
                $block->current_mapping_url, $block->preferred_mapping_url );
            close $php_out;
            my $php_result = do { local $/; <$php_in> };
            $php_result =~ s/^(\r\n|\r|\n|\s)+|(\r\n|\r|\n|\s)+\z//g;

            my $name = $block->name . ' - dynamic';
            is( $php_result, $block->expected, $name );
        }
    };
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
