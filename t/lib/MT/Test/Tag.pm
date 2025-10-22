# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#

package MT::Test::Tag;

use strict;
use warnings;
use Encode;
use v5.10;
use Test::More;
use MT::Test 'has_php';
use MT::I18N;
use MT::Test::PHP;
use File::Spec;
use Text::Diff 'diff';

BEGIN {
    eval qq{ use Test::Base -Base; 1 }
        or plan skip_all => 'Test::Base is not installed';
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

            my $prev_config = __PACKAGE__->_update_config($block->mt_config);

            MT::Request->instance->reset;

            my $tmpl = MT::Template->new( type => 'index' );
            $tmpl->text( _filter_vars( $block->template ) );
            my $ctx = $tmpl->context;

            my $blog = MT::Blog->load( $block->blog_id || $blog_id );
            $ctx->stash( 'blog',          $blog );
            $ctx->stash( 'blog_id',       $blog->id );
            $ctx->stash( 'local_blog_id', $blog->id );
            $ctx->stash( 'local_lang_id', lc(MT->current_language) );
            $ctx->stash( 'builder',       MT->builder );

            $callback->( $ctx, $block ) if $callback;

            my $got = eval { $tmpl->build };
            diag $@ if $@;

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
                local $TODO = "may fail" if $expected_error_method =~ /^expected_todo_/;
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
                    if (exists $block->{$method}) {
                        $expected_method = $method;
                        last;
                    }
                }

                $got =~ s/^(\r\n|\r|\n|\s)+|(\r\n|\r|\n|\s)+\z//g if defined $got;

                if ($ENV{MT_TEST_ENABLE_SSI_PHP_MOCK} && $blog->include_system eq 'php') {
                    $got = MT::Test::PHP->run($got);
                }

                local $TODO = "may fail" if $expected_method =~ /^expected_todo/;

                my $expected     = _filter_vars($block->$expected_method);
                my $expected_ref = ref($expected);
                my $name         = $test_name_prefix . $block->name;

                if ($expected_ref && $expected_ref eq 'Regexp') {
                    like($got, $expected, $name);
                } else {
                    ok($got eq $expected, $name) or diag diff(\$expected, \$got, {STYLE => 'Unified'});
                }
            }
            __PACKAGE__->_update_config($prev_config);
        }
    }
}

sub run_php_tests {
    my ( $blog_id, $callback, $archive_type ) = @_;

SKIP: {
        unless ( has_php() ) {
            skip "Can't find executable file: php", 2 * blocks;
        }

        if ( $callback && !ref $callback ) {
            $archive_type = $callback;
            $callback     = undef;
        }
        if ($archive_type) {
            $vars->{archive_type} = $archive_type;
        }
        $archive_type ||= '';

        my $blog = MT::Blog->load($blog_id);
        if ($blog and $blog->language ne lc MT->config->DefaultLanguage) {
            $blog->language(MT->config->DefaultLanguage);
            $blog->date_language(MT->config->DefaultLanguage);
            $blog->save;
        }

        my $test_name_prefix = $self->_test_name_prefix($archive_type);

        run {
            my $block = shift;
        SKIP: {
                skip $block->skip, 2 if $block->skip;
                skip 'skip php test', 2 if __PACKAGE__->_check_skip_php($block);

                my $prev_config = __PACKAGE__->_update_config($block->mt_config);

                my $template = _filter_vars( $block->template );
                $template    = Encode::encode_utf8( $template ) if Encode::is_utf8( $template );
                my $extra    = $callback ? ($callback->($block) || '') : '';

                my $log;
                require MT::Util::UniqueID;
                local $ENV{MT_TEST_PHP_ERROR_LOG_FILE_PATH} = $ENV{MT_TEST_PHP_ERROR_LOG_FILE_PATH}
                    ? $ENV{MT_TEST_PHP_ERROR_LOG_FILE_PATH}
                    : $log = File::Spec->catfile($ENV{MT_TEST_ROOT}, 'php-' . MT::Util::UniqueID::create_session_id() . '.log');
                my $block_name = $block->name || $block->seq_num;
                $ENV{REQUEST_URI} = "$0 [$block_name]";
                my $got;
                if ($^O eq 'MSWin32' or $ENV{MT_TEST_NO_PHP_DAEMON} or lc($ENV{MT_TEST_BACKEND} // '') eq 'sqlite') {
                    my $php_script = php_test_script( $block_name, $block->blog_id || $blog_id, $template, $extra );
                    $got = Encode::decode_utf8(MT::Test::PHP->run($php_script));
                } else {
                    $got = Encode::decode_utf8(MT::Test::PHP->daemon($template, $block->blog_id || $blog_id, $extra));
                }

                my $php_error = MT::Test::PHP->retrieve_php_logs($log);

                ( my $method_name = $archive_type ) =~ tr|A-Z-|a-z_|;

                # those with $method_name have higher precedence
                # and todo does, too
                my @extra_methods = (
                    "expected_php_todo_error_$method_name",
                    "expected_php_todo_$method_name",
                    "expected_todo_$method_name",
                    "expected_php_error_$method_name",
                    "expected_error_$method_name",
                    "expected_$method_name",
                    "expected_php_todo",
                    "expected_todo_error",
                    "expected_todo",
                    "expected_php_error",
                    "expected_error",
                    "expected_php",
                );
                my $expected_method = "expected";
                for my $method (@extra_methods) {

                    if ( exists $block->{$method} ) {
                        $expected_method = $method;
                        last;
                    }
                }
                my $expected_src = $block->$expected_method // '';
                my $expected_ref = ref($expected_src);

                $expected_src =~ s/\\r/\\n/g;
                $expected_src =~ s/\r/\n/g;

                # for Smarty 3.1.32+
                $got          =~ s/\n//gs;
                $expected_src =~ s/\n//gs;

                local $TODO = "may fail" if $expected_method =~ /^expected_(?:php_)?todo/;

                $got = ($php_error =~ /\tstr:([^\t]+)/)[0] if $expected_method =~ /_error/;

                my $expected     = _filter_vars($expected_src);
                my $name         = $test_name_prefix . $block->name . ' - dynamic';

                if ($expected_ref && $expected_ref eq 'Regexp') {
                    $expected = qr{$expected} if ref($expected) ne 'Regexp';
                    like($got, $expected, $name);
                    $php_error =~ s/[^\n]+$expected[^\n]+\n//g if $expected_method =~ /_error/;
                } else {
                    is($got, $expected, $name);
                    $php_error =~ s/[^\n]+\Q$expected\E[^\n]+\n//g if $expected_method =~ /_error/;
                }
                my $ignore_php_warnings = __PACKAGE__->_check_ignore_php_warnings($block) || $ENV{MT_TEST_IGNORE_PHP_WARNINGS};
                if ($ignore_php_warnings && $php_error) {
                    SKIP: {
                        local $TODO = 'for now';
                        ok !$php_error, 'no php warnings';
                    }
                } else {
                    is($php_error, '', 'no php warnings');
                }
                __PACKAGE__->_update_config($prev_config);
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
    my ( $block_name, $blog_id, $template, $extra ) = @_;

    $template =~ s/<\$(mt.+?)\$>/<$1>/gi;
    $template =~ s/\$/\\\$/g;

    my $test_script = <<PHP;
<?php
\$MT_CONFIG = '@{[ MT->instance->find_config ]}';
\$blog_id   = '$blog_id';

\$tmpl = <<<__TMPL__
$template
__TMPL__
;
PHP
    $test_script .= <<'PHP';
$MT_HOME = $_ENV['MT_HOME'] ?? '.';
include_once($MT_HOME . '/php/mt.php');
include_once($MT_HOME . '/php/lib/MTUtil.php');
include_once($MT_HOME . '/t/lib/MT/Test/PHP/error_handler.php');

$error_handler = new MT_Test_Error_Handler();
set_error_handler([$error_handler, 'handler']);
$log = $_ENV['MT_TEST_PHP_ERROR_LOG_FILE_PATH'];
$error_handler->log = $log;
$error_handler->ignore_php_dynamic_properties_warnings = 
                $_ENV['MT_TEST_IGNORE_PHP_DYNAMIC_PROPERTIES_WARNINGS'] ?? false;

$mt = MT::get_instance($blog_id, $MT_CONFIG);
$mt->config('PHPErrorLogFilePath', $log);

$mt->init_plugins();

$db = $mt->db();
if (preg_match('/mysql/i', $mt->config('ObjectDriver'))) {
    $db->execute("SET time_zone = '+00:00'");
}
$ctx =& $mt->context();

$ctx->stash('index_archive', true);

$ctx->stash('blog_id', $blog_id);
$ctx->stash('local_blog_id', $blog_id);

$blog = $db->fetch_blog($blog_id);
$ctx->stash('blog', $blog);
PHP

    $test_script .= $extra if $extra;

    $test_script .= <<'PHP';
if ($ctx->_compile_source('evaluated template', $tmpl, $_var_compiled)) {
    echo $_var_compiled;
} else {
    print('Error compiling template module.');
}

?>
PHP
}

sub _update_config {
    my $config = shift || return;
    $config = eval($config) unless ref($config);

    my %prev;
    for my $key (keys %$config) {
        $prev{$key} = MT->instance->config($key);
        MT->config($key, $config->{$key});
        MT->config($key, $config->{$key}, 1);
    }
    MT->config->save_config;
    return \%prev;
}

sub _check_skip_php {
    my $block    = shift;
    my $skip_php = $block->skip_php;
    if (defined($skip_php)) {
        if (length($skip_php)) {
            return _filter_vars($skip_php);
        } else {
            return 1;
        }
    }
    return;
}

sub _check_ignore_php_warnings {
    my $block  = shift;
    my $ignore = $block->ignore_php_warnings;
    if (defined($ignore)) {
        if (length($ignore)) {
            return _filter_vars($ignore);
        } else {
            return 1;
        }
    }
    return;
}

1;
