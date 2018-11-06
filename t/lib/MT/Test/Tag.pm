# Movable Type (r) (C) 2001-2017 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#

package MT::Test::Tag;

use strict;
use warnings;
use Encode;
use Test::More;
use MT::Test 'has_php';
use MT::I18N;

BEGIN {
    eval qq{ use Test::Base -Base; 1 }
        or plan skip_all => 'Test::Base is not installed';
    eval qq{ use IPC::Run3 'run3'; 1 }
        or plan skip_all => 'IPC::Run3 is not installed';
}

my $vars = {};

sub vars {
    $vars = shift if @_;
    $vars;
}

sub run_perl_tests {
    my ( $blog_id, $callback, $original_expected_method ) = @_;

    if ( $callback && !ref $callback ) {
        $original_expected_method = $callback;
        $callback                 = undef;
    }

    MT->instance;

    run {
        my $block = shift;
    SKIP: {
            skip $block->skip, 1 if $block->skip;

            MT::Request->instance->reset;

            my $tmpl = MT::Template->new;
            $tmpl->text( _filter_vars( $block->template ) );
            my $ctx = $tmpl->context;

            my $blog = MT::Blog->load( $block->blog_id || $blog_id );
            $ctx->stash( 'blog',          $blog );
            $ctx->stash( 'blog_id',       $blog->id );
            $ctx->stash( 'local_blog_id', $blog->id );
            $ctx->stash( 'builder',       MT::Builder->new );

            $callback->( $ctx, $block ) if $callback;

            my $expected_method = $original_expected_method;
            if ( !$expected_method or !exists $block->{$expected_method} ) {
                $expected_method = 'expected';
            }

            my $result = eval { $tmpl->build };
            if ( !$block->expected_error ) {
                $result =~ s/^(\r\n|\r|\n|\s)+|(\r\n|\r|\n|\s)+\z//g
                    if defined $result;
                is( $result, _filter_vars( $block->$expected_method ),
                    $block->name );
            }
            else {
                $result = $ctx->errstr;
                $result =~ s/^(\r\n|\r|\n|\s)+|(\r\n|\r|\n|\s)+\z//g;
                is( $result,
                    _filter_vars( $block->expected_error ),
                    $block->name . ' (error)'
                );
            }
        }
    }
}

sub run_php_tests {
    my ( $blog_id, $callback, $expected_method ) = @_;

SKIP: {
        unless ( has_php() ) {
            skip "Can't find executable file: php", 1 * blocks;
        }

        if ( $callback && !ref $callback ) {
            $expected_method = $callback;
            $callback        = undef;
        }

        run {
            my $block = shift;
        SKIP: {
                skip $block->skip, 1 if $block->skip;
                skip 'skip php test', 1 if $block->skip_php;

                my $template = _filter_vars( $block->template );
                my $text     = $block->text || '';
                my $extra    = $callback ? $callback->($block) : '';

                my $php_script = php_test_script( $block->blog_id || $blog_id,
                    $template, $text, $extra );

                run3 [ 'php', '-q' ], \$php_script, \my $php_result, undef,
                    { binmode_stdin => 1 }
                    or die $?;
                $php_result =~ s/^(\r\n|\r|\n|\s)+|(\r\n|\r|\n|\s)+\z//g;
                $php_result = Encode::decode_utf8($php_result);

                my $expected
                    = $block->expected_error ? $block->expected_error
                    : $block->error          ? $block->error
                    : ( $expected_method
                        && exists $block->{$expected_method} )
                    ? $block->$expected_method
                    : $block->expected;
                $expected =~ s/\\r/\\n/g;
                $expected =~ s/\r/\n/g;

                my $name = $block->name . ' - dynamic';
                is( MT::I18N::encode_text($php_result, undef, 'utf-8'), _filter_vars(MT::I18N::encode_text($expected, undef, 'utf-8')), $name );
            }
        }
    }
}

sub MT::Test::Tag::_filter_vars {
    my $str = shift;
    return $str unless defined $str;
    $str =~ s/\[% $_ %\]/$vars->{$_}/g for keys %$vars;
    chomp $str;
    $str;
}

sub MT::Test::Tag::php_test_script {    # full qualified to avoid Spiffy magic
    my ( $blog_id, $template, $text, $extra ) = @_;
    $text ||= '';

    $template =~ s/<\$(mt.+?)\$>/<$1>/gi;

    my $test_script = <<PHP;
<?php
\$MT_HOME   = '@{[ $ENV{MT_HOME} ? $ENV{MT_HOME} : '.' ]}';
\$MT_CONFIG = '@{[ MT->instance->find_config ]}';
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

$mt = MT::get_instance($blog_id, $MT_CONFIG);
$mt->init_plugins();

$db = $mt->db();
$ctx =& $mt->context();

$ctx->stash('blog_id', $blog_id);
$ctx->stash('local_blog_id', $blog_id);

$blog = $db->fetch_blog($blog_id);
$ctx->stash('blog', $blog);
PHP

    $test_script .= $extra if $extra;

    $test_script .= <<'PHP';
set_error_handler(function($error_no, $error_msg, $error_file, $error_line, $error_vars) {
    print($error_msg."\n");
}, E_USER_ERROR );

if ($ctx->_compile_source('evaluated template', $tmpl, $_var_compiled)) {
    $ctx->_eval('?>' . $_var_compiled);
} else {
    print('Error compiling template module.');
}

?>
PHP
}

1;
