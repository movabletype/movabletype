# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#

package MT::Test::TextFilter;

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
use MT::Test::Permission;

BEGIN {
    eval qq{ use Test::Base -Base; 1 }
        or plan skip_all => 'Test::Base is not installed';
}

my $vars = {};

sub vars {
    $vars = shift if @_;
    $vars;
}

my $convert_breaks;

sub set { $convert_breaks = shift }

sub run_perl_tests {
    my ($blog_id, $callback) = @_;

    MT->instance;

    run {
        my $block = shift;
    SKIP: {
            skip $block->skip, 1 if $block->skip;

            my $prev_config = __PACKAGE__->_update_config($block->mt_config);

            MT::Request->instance->reset;

            my $entry = MT::Test::Permission->make_entry(
                blog_id        => $blog_id,
                author_id      => 1,
                title          => 'Test',
                text           => _filter_vars($block->text),
                convert_breaks => $convert_breaks,
            );
            my $entry_id = $entry->id;

            my $tmpl = MT::Template->new(type => 'index');
            $tmpl->text(qq{<mt:Entries id="$entry_id"><mt:EntryBody></mt:Entries>});
            my $ctx = $tmpl->context;

            my $blog = MT::Blog->load($block->blog_id || $blog_id);
            $ctx->stash('blog',          $blog);
            $ctx->stash('blog_id',       $blog->id);
            $ctx->stash('local_blog_id', $blog->id);
            $ctx->stash('local_lang_id', lc(MT->current_language));
            $ctx->stash('builder',       MT->builder);

            $callback->($ctx, $block) if $callback;

            my $got = eval { $tmpl->build };
            diag $@ if $@;

            if (my $error = $ctx->errstr) {
                my $expected_error_method = "expected";
                my @extra_error_methods   = (
                    "expected_todo_error",
                    "expected_error"
                );
                for my $method (@extra_error_methods) {
                    if (exists $block->{$method}) {
                        $expected_error_method = $method;
                        last;
                    }
                }
                $error =~ s/^(\r\n|\r|\n|\s)+|(\r\n|\r|\n|\s)+\z//g;
                local $TODO = "may fail" if $expected_error_method =~ /^expected_todo_/;
                is(
                    $error,
                    _filter_vars($block->$expected_error_method),
                    $block->name . ' (error)'
                );
            } else {
                my $expected_method = 'expected';
                my @extra_methods   = ("expected_todo");
                for my $method (@extra_methods) {
                    if (exists $block->{$method}) {
                        $expected_method = $method;
                        last;
                    }
                }

                $got =~ s/^(\r\n|\r|\n|\s)+|(\r\n|\r|\n|\s)+\z//g if defined $got;

                if ($ENV{MT_TEST_ENABLE_SSI_PHP_MOCK} && $blog->include_system eq 'php') {
                    $got = MT::Test::PHP->run(encode_utf8($got));
                }

                local $TODO = "may fail" if $expected_method =~ /^expected_todo/;

                my $expected     = _filter_vars($block->$expected_method);
                my $expected_ref = ref($expected);
                my $name         = $block->name;

                $got      = _trim($got);
                $expected = _trim($expected);

                if ($expected_ref && $expected_ref eq 'Regexp') {
                    like($got, $expected, $name);
                } else {
                    ok($got eq $expected, $name) or diag diff(\$expected, \$got, { STYLE => 'Unified' });
                }
            }
            __PACKAGE__->_update_config($prev_config);
        }
    }
}

sub run_php_tests {
    my ($blog_id, $callback) = @_;

SKIP: {
        unless (has_php()) {
            skip "Can't find executable file: php", 2 * blocks;
        }

        my $blog = MT::Blog->load($blog_id);
        if ($blog and $blog->language ne lc MT->config->DefaultLanguage) {
            $blog->language(MT->config->DefaultLanguage);
            $blog->date_language(MT->config->DefaultLanguage);
            $blog->save;
        }

        run {
            my $block = shift;
        SKIP: {
                skip $block->skip,    2 if $block->skip;
                skip 'skip php test', 2 if __PACKAGE__->_check_skip_php($block);

                my $prev_config = __PACKAGE__->_update_config($block->mt_config);

                my $entry = MT::Test::Permission->make_entry(
                    blog_id        => $blog_id,
                    author_id      => 1,
                    title          => 'Test',
                    text           => _filter_vars($block->text),
                    convert_breaks => $convert_breaks,
                );
                my $entry_id = $entry->id;

                my $template = qq{<mt:Entries id="$entry_id"><mt:EntryBody></mt:Entries>};
                my $text     = $block->text || '';
                my $extra    = $callback ? ($callback->($block) || '') : '';

                my $log;
                require MT::Util::UniqueID;
                local $ENV{MT_TEST_PHP_ERROR_LOG_FILE_PATH} =
                      $ENV{MT_TEST_PHP_ERROR_LOG_FILE_PATH}
                    ? $ENV{MT_TEST_PHP_ERROR_LOG_FILE_PATH}
                    : $log = File::Spec->catfile($ENV{MT_TEST_ROOT}, 'php-' . MT::Util::UniqueID::create_session_id() . '.log');
                my $block_name = $block->name || $block->seq_num;
                $ENV{REQUEST_URI} = "$0 [$block_name]";
                my $got;

                if ($^O eq 'MSWin32' or $ENV{MT_TEST_NO_PHP_DAEMON} or lc($ENV{MT_TEST_BACKEND} // '') eq 'sqlite') {
                    my $php_script = php_test_script($block_name, $block->blog_id || $blog_id, $template, $text, $extra);
                    $got = Encode::decode_utf8(MT::Test::PHP->run(encode_utf8($php_script)));
                } else {
                    $got = Encode::decode_utf8(MT::Test::PHP->daemon($template, $block->blog_id || $blog_id, $extra, $text));
                }

                my $php_error = MT::Test::PHP->retrieve_php_logs($log);

                # those with $method_name have higher precedence
                # and todo does, too
                my @extra_methods = (
                    "expected_php_todo",
                    "expected_todo_error",
                    "expected_todo",
                    "expected_php_error",
                    "expected_error",
                    "expected_php",
                );
                my $expected_method = "expected";
                for my $method (@extra_methods) {

                    if (exists $block->{$method}) {
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

                my $expected = _filter_vars($expected_src);
                my $name     = $block->name . ' - dynamic';

                $got      = _trim($got);
                $expected = _trim($expected);

                if ($expected_ref && $expected_ref eq 'Regexp') {
                    $expected = qr{$expected} if ref($expected) ne 'Regexp';
                    like($got, $expected, $name);
                } else {
                    is($got, $expected, $name);
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

sub MT::Test::TextFilter::_filter_vars {
    my $str = shift;
    return $str unless defined $str;
    $str =~ s/\[% $_ %\]/$vars->{$_}/g for keys %$vars;
    chomp $str;
    $str;
}

sub MT::Test::TextFilter::php_test_script {    # full qualified to avoid Spiffy magic
    my ($block_name, $blog_id, $template, $text, $extra) = @_;
    $text ||= '';

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
\$text = <<<__TMPL__
$text
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

sub MT::Test::TextFilter::_trim {
    my $str = shift;
    $str = '' unless defined $str;
    $str =~ s/\n+//g;
    $str =~ s/^\s+//;
    $str =~ s/\s+$//;
    $str;
}

1;
