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

sub _test_name_prefix {
    my ($archive_type) = @_;
    $archive_type ? "$archive_type: " : '';
}

sub run_perl_tests {
    my ( $blog_id, $callback, $archive_type ) = @_;

    if ( $callback && !ref $callback ) {
        $archive_type = $callback;
        $callback     = undef;
    }
    if ($archive_type) {
        $vars->{archive_type} = $archive_type;
    }
    $archive_type ||= '';

    my $test_name_prefix = $self->_test_name_prefix($archive_type);

    MT->instance;

    run {
        my $block = shift;
    SKIP: {
            skip $block->skip, 1 if $block->skip;

            MT::Request->instance->reset;

            my $tmpl = MT::Template->new( type => 'index' );
            $tmpl->text( _filter_vars( $block->template ) );
            my $ctx = $tmpl->context;

            my $blog = MT::Blog->load( $block->blog_id || $blog_id );
            $ctx->stash( 'blog',          $blog );
            $ctx->stash( 'blog_id',       $blog->id );
            $ctx->stash( 'local_blog_id', $blog->id );
            $ctx->stash( 'builder',       MT::Builder->new );

            $callback->( $ctx, $block ) if $callback;

            my $result = eval { $tmpl->build };

            ( my $method_name = $archive_type ) =~ tr|A-Z-|a-z_|;

            if ( my $error = $ctx->errstr ) {
                my $expected_error_method = "expected";
                my @extra_error_methods   = (
                    "expected_todo_error_$method_name",
                    "expected_todo_error",
                    "expected_error_$method_name",
                    "expected_error"
                );
                for my $method (@extra_error_methods) {
                    if ( exists $block->{$method} ) {
                        $expected_error_method = $method;
                        last;
                    }
                }
                $error =~ s/^(\r\n|\r|\n|\s)+|(\r\n|\r|\n|\s)+\z//g;
                local $TODO = "may fail"
                    if $expected_error_method =~ /^expected_todo_/;
                is( $error,
                    _filter_vars( $block->$expected_error_method ),
                    $test_name_prefix . $block->name . ' (error)'
                );
            }
            else {
                my $expected_method = 'expected';
                my @extra_methods   = (
                    "expected_todo_$method_name",
                    "expected_$method_name", "expected_todo"
                );
                for my $method (@extra_methods) {
                    if ( exists $block->{$method} ) {
                        $expected_method = $method;
                        last;
                    }
                }

                $result =~ s/^(\r\n|\r|\n|\s)+|(\r\n|\r|\n|\s)+\z//g
                    if defined $result;

                local $TODO = "may fail"
                    if $expected_method =~ /^expected_todo/;

                is( $result,
                    _filter_vars( $block->$expected_method ),
                    $test_name_prefix . $block->name
                );
            }
        }
    }
}

sub run_php_tests {
    my ( $blog_id, $callback, $archive_type ) = @_;

SKIP: {
        unless ( has_php() ) {
            skip "Can't find executable file: php", 1 * blocks;
        }

        if ( $callback && !ref $callback ) {
            $archive_type = $callback;
            $callback     = undef;
        }
        if ($archive_type) {
            $vars->{archive_type} = $archive_type;
        }
        $archive_type ||= '';

        my $test_name_prefix = $self->_test_name_prefix($archive_type);

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

                ( my $method_name = $archive_type ) =~ tr|A-Z-|a-z_|;

                my @extra_methods = (
                    "expected_php_error_$method_name",
                    "expected_php_todo_$method_name",
                    "expected_php_todo",
                    "expected_todo_$method_name",
                    "expected_$method_name",
                    "expected_todo",
                );
                my $expected_method = "expected";
                for my $method (@extra_methods) {

                    if ( exists $block->{$method} ) {
                        $expected_method = $method;
                        last;
                    }
                }
                my $expected = $block->$expected_method;
                $expected = '' unless defined $expected;
                $expected =~ s/\\r/\\n/g;
                $expected =~ s/\r/\n/g;

                local $TODO = "may fail"
                    if $expected_method =~ /^expected_(?:php_)?todo/;

                my $name = $test_name_prefix . $block->name . ' - dynamic';
                is( MT::I18N::encode_text( $php_result, undef, 'utf-8' ),
                    _filter_vars(
                        MT::I18N::encode_text( $expected, undef, 'utf-8' )
                    ),
                    $name
                );
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

$ctx->stash('index_archive', true);

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
