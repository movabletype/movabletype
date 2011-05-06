# Movable Type (r) Open Source (C) 2001-2011 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package MT::Test::Tags;
use strict;
use warnings;
use base qw( Exporter );
our @EXPORT = qw( run_tests run_tests_by_data run_tests_by_files );
use Test::More;

BEGIN {
    $ENV{MT_CONFIG} = 'mysql-test.cfg';
}

$| = 1;

use MT::Test qw(:db :data);
use MT;
use MT::Util qw(ts2epoch epoch2ts);
use MT::Template::Context;
use MT::Builder;
use IPC::Open2;
require POSIX;

our $test_section = 0;
our ( %PRERUN, %SETUP, %PRERUN_PHP, %SETUP_PHP );

sub run_tests {
    my ($test_suite) = @_;
    prepare_test_suite($test_suite);
    $test_section++;
    my $tmpl_vars = prepare_tmpl_vars();
    # Ok. We are now ready to test!
    perl_tests( $test_suite, $tmpl_vars );
    php_tests(  $test_suite, $tmpl_vars );
}

sub run_tests_by_data {
    my $test_suite = load_tests_from_data_section()
        or return;
    prepare_test_suite($test_suite);

    # Ok. We are now ready to test!
    plan tests => ( scalar(@$test_suite) * 2 ) + 2;
    my $tmpl_vars = prepare_tmpl_vars();
    # Ok. We are now ready to test!
    perl_tests( $test_suite, $tmpl_vars );
    php_tests(  $test_suite, $tmpl_vars );
}

sub run_tests_by_files {
    for my $fn ( @_ ) {
        note( "Testing data in $fn..." );
        $test_section = $fn;
        my $test_suite = load_tests_from_file($fn)
            or return;
        prepare_test_suite($test_suite);
        my $tmpl_vars = prepare_tmpl_vars();
        # Ok. We are now ready to test!
        perl_tests( $test_suite, $tmpl_vars );
        php_tests(  $test_suite, $tmpl_vars );
    }
}

sub load_tests_from_file {
    ## At first, test YAML::Syck.
    ## This style of tests can't run without it.
    eval { require YAML::Syck };
    if ( $@ ) {
        plan skip_all => "YAML::Syck is not installed.";
        return;
    }
    my ($fn) = @_;
    my $test_suite = YAML::Syck::LoadFile($fn);
    return $test_suite;
}

sub load_tests_from_data_section {
    ## At first, test YAML::Syck.
    ## This style of tests can't run without it.
    eval { require YAML::Syck };
    if ( $@ ) {
        plan skip_all => "YAML::Syck is not installed.";
        return;
    }
    ## This logic was taken from Data::Section::Simple
    my $data = do { no strict 'refs'; \*main::DATA };
    die "No Data section found" unless defined fileno $data;
    seek $data, 0, 0;
    my $content = join '', <$data>;
    $content =~ s/^.*\n__DATA__\n/\n/s;    # for win32
    $content =~ s/\n__END__\n.*$/\n/s;
    my $test_suite = YAML::Syck::Load($content);
    return $test_suite;
}

{
    my $test_total_number = 1;
    my %aliases           = qw(
        name     n
        template t
        expected e
        run      r
        skip     s
        like     l
    );

    sub prepare_test_suite {
        my ($test_suite) = @_;
        for my $item (@$test_suite) {
            for my $longname ( keys %aliases ) {
                my $alias = $aliases{$longname};
                if ( !defined $item->{$longname} && defined $item->{$alias} )
                {
                    $item->{$longname} = $item->{$alias};
                }
            }

            $item->{num} = $test_total_number;
            $item->{name} ||= "test item $test_total_number";
            $item->{skip} = 'NO REASON GIVEN'
                if !defined $item->{skip}
                    && defined $item->{run}
                    && !$item->{run};
            $item->{trim} = 1 if !defined $item->{trim};
            $test_total_number++;
        }
    }
}

sub prepare_tmpl_vars {
    my $blog = MT::Blog->load(1);
    # entry we want to capture is dated: 19780131074500
    my $tsdiff = time - ts2epoch( $blog, '19780131074500' );
    my $daysdiff = int( $tsdiff / ( 60 * 60 * 24 ) );
    return {
        CFG_FILE                  => MT->instance->{cfg_file},
        VERSION_ID                => MT->instance->version_id,
        CURRENT_WORKING_DIRECTORY => MT->instance->server_path,
        STATIC_CONSTANT           => '1',
        DYNAMIC_CONSTANT          => '',
        DAYS_CONSTANT1            => $daysdiff + 1,
        DAYS_CONSTANT2            => $daysdiff - 1,
        CURRENT_YEAR              => POSIX::strftime( "%Y", localtime ),
        CURRENT_MONTH             => POSIX::strftime( "%m", localtime ),
        STATIC_FILE_PATH          => MT->instance->static_file_path . '/',
    };
}

$PRERUN{__default__} = sub {
    my ( $stock ) = @_;
    $stock->{blog}  = MT::Blog->load(1);
    $stock->{entry} = MT::Entry->load(1);
};

$PRERUN_PHP{__default__} = <<'PHP';
    $stock["blog"]  = $db->fetch_blog(1);
    $stock["entry"] = $db->fetch_entry(1);
PHP

$SETUP{__default__} = sub {
    my ( $test, $ctx, $stock ) = @_;
    $ctx->stash( 'blog',    $stock->{blog} );
    $ctx->stash( 'blog_id', $stock->{blog}->id );
    $ctx->stash( 'builder', MT::Builder->new );
    $ctx->{current_timestamp} = '20040816135142';
    my $template = $test->{template};
    $ctx->{__stash}{entry} = $stock->{entry}
        if $template =~ m/<MTEntry/;
    $ctx->{__stash}{entry} = undef
        if $template =~ m/MTComments|MTPings/;
    $ctx->{__stash}{entries} = undef
        if $template =~ m/MTEntries|MTPages/;
    $ctx->stash( 'comment', undef );
};

$SETUP_PHP{__default__} = <<'PHP';
    $ctx->stash('blog_id', 1);
    $ctx->stash('blog', $stock["blog"]);
    $ctx->stash('current_timestamp', '20040816135142');
    if ( preg_match('/MT(Entry|Link)/', $test_item["template"]) 
      && !preg_match('/MT(Comments|Pings)/', $test_item["template"]) )
    {
        $ctx->stash('entry', $stock["entry"]);
    }
    else {
        $ctx->__stash['entry'] = null;
    }
    if ( preg_match('/MTEntries|MTPages/', $test_item["template"]) ) {
        $ctx->__stash['entries'] = null;
        $ctx->__stash['author'] = null;
        $ctx->__stash['category'] = null;
    }
    if ( preg_match('/MTCategoryArchiveLink/', $test_item["template"]) ) {
        $ctx->stash('current_archive_type', 'Category');
    } else {
        $ctx->stash('current_archive_type', '');
    }
PHP

sub perl_tests {
    my ($test_suite, $tmpl_vars) = @_;

    # Clear cache
    my $request = MT::Request->instance;
    my $stock = {};
    for my $sub ( values %PRERUN ) {
        $sub->($stock, $tmpl_vars);
    }
    my $rest = scalar @$test_suite;
    TEST: foreach my $test_item (@$test_suite) {
        my $ctx  = MT::Template::Context->new;
        $request->{__stash} = {};
        for my $sub ( values %SETUP ) {
            $sub->($test_item, $ctx, $stock, $tmpl_vars);
        }
        SKIP: {
            if ( $test_item->{skip} ) {
                $rest--;
                skip( $test_item->{skip}, 1 )
            }
            my $template = defined $test_item->{template} ? $test_item->{template}
                         :                                  '';
            my $expected = defined $test_item->{expected} ? $test_item->{expected}
                         :                                  '';
            my $like     = $test_item->{like};
            $template =~ s/\Q$_\E/$tmpl_vars->{$_}/g for keys %$tmpl_vars;
            $expected =~ s/\Q$_\E/$tmpl_vars->{$_}/g for keys %$tmpl_vars;
            my $result = build( $ctx, $template );
            if ( $test_item->{error} ) {
                if ( defined $result ) {
                    fail( $test_item->{name} );
                    $rest--;
                    next TEST;
                }
                if ( !$expected && !$like ) {
                    pass( $test_item->{name} );
                    $rest--;
                    next TEST;
                }
                $result = $ctx->stash('builder')->errstr;
            }
            else {
                if ( !defined $result ) {
                    fail( $test_item->{name} );
                    note( "got error: " . $ctx->stash('builder')->errstr );
                    $rest--;
                    next TEST;
                }
            }
            if ( $test_item->{trim} ) {
                $result   =~ s/^\s*//;
                $result   =~ s/\s*$//;
                $expected =~ s/^\s*//;
                $expected =~ s/\s*$//;
            }
            if ( $like ) {
                like( $result, $like, $test_item->{name} );
            }
            else {
                is( $result, $expected, $test_item->{name} );
            }
            $rest--;
        }
    }
    is( $rest, 0, "Done all perl tests" . ( $test_section ? " in section $test_section" : "" ) );
}

sub build {
    my ( $ctx, $markup ) = @_;
    my $b = $ctx->stash('builder');
    my $tokens = $b->compile( $ctx, $markup );
    if ( !defined $tokens ) {
        return;
    }
    return $b->build( $ctx, $tokens );
}

sub _dump_php {
    my ($data) = @_;
    my $out;
    if ( ref $data eq 'HASH' ) {
        my @elements;
        for my $key ( keys %$data ) {
            my $val = _dump_php( $data->{$key} );
            push @elements, "$key => $val";
        }
        return sprintf 'array(%s)', join( ',', @elements );
    }
    elsif ( ref $data eq 'ARRAY' ) {
        my @elements;
        for my $val (@$data) {
            push @elements, _dump_php($val);
        }
        return sprintf 'array(%s)', join( ',', @elements );
    }
    elsif ( !ref $data ) {
        $data =~ s!\\!\\\\!g;
        $data =~ s!'!\\'!g;
        return qq{'$data'};
    }
    die "unsupported type: " . ref $data;
}

sub php_tests {
    my ($test_suite, $tmpl_vars) = @_;
    my $test_script = <<'PHP';
<?php
include_once("php/mt.php");
include_once("php/lib/MTUtil.php");

$cfg_file  = '<CFG_FILE>';
$tmpl_vars = <TMPL_VARS>;
$output_results = 0;
$mt = MT::get_instance(1, $cfg_file);
$ctx =& $mt->context();
$path = $mt->config('mtdir');
if (substr($path, strlen($path) - 1, 1) == '/')
    $path = substr($path, 1, strlen($path)-1);
if (substr($path, strlen($path) - 2, 2) == '/t')
    $path = substr($path, 0, strlen($path) - 2);
$const['CURRENT_WORKING_DIRECTORY'] = $path;
$db = $mt->db();
$db->db()->Execute( "SET time_zone = '-7:00'" );
$mt->init_plugins();
$suite = <TEST_SUITE_PHP>;
set_error_handler('error_handler');
run($ctx, $suite);

function run(&$ctx, $suite) {
    $test_num = 0;
    global $mt;
    global $ctx;
    global $db;
    global $error_messages;
    $base_stash = $ctx->__stash;
    <PRERUN_PHP>
    TEST: foreach ($suite as $test_item) {
        $ctx->__stash = $base_stash;
        $mt->db()->savedqueries = array();
        <SETUP_PHP>
        if ($test_item["skip"] ) {
            echo "skip - php: " . $test_item["skip"] . "\n";
        } else {
            $test_name = $test_item["name"];
            $template  = $test_item["template"];
            $expected  = $test_item["expected_php"] ? $test_item["expected_php"]
                       :                              $test_item["expected"];
            $like      = $test_item["like_php"] ? $test_item["like_php"]
                       :                          $test_item["like"];
            global $const;
            foreach ($tmpl_vars as $c => $r) {
                $template = preg_replace('/' . $c . '/', $r, $template);
                $expected = preg_replace('/' . $c . '/', $r, $expected);
            }
            $result = build($ctx, $template);
            if ( $test_item["error"] ) {
                if ( !is_null( $result ) ) {
                    echo "not ok - php: $test_name\n";
                    continue TEST;
                }
                if ( !$expected && !$like ) {
                    echo "ok - php: $test_name\n";
                    continue TEST;
                }
                $result = join('', $error_messages);
            }
            else {
                if ( is_null( $result ) ) {
                    echo "not ok - php: $test_name\n"
                       . "# got error: "
                       . join( '#    ', $error_messages )
                       . "\n";
                    continue TEST;
                }
            }
            if ( $test_item["trim"] ) {
                $result   = trim($result);
                $expected = trim($expected);
            }
            $like ? ok($result, $like, $test_name, true) : ok($result, $expected, $test_name, false);
        }
    }
}

function build(&$ctx, $tmpl) {
    global $error_messages;
    $error_messages = array();
    if ($ctx->_compile_source('evaluated template', $tmpl, $_var_compiled)) {
        ob_start();
        $ctx->_eval('?>' . $_var_compiled);
        $_contents = ob_get_contents();
        ob_end_clean();
        if ( count($error_messages) ) {
            return null;
        }
        else {
            return $_contents;
        }
    } else {
        return $ctx->error("Error compiling template module '$module'");
    }
}

function ok($str, $that, $test_name, $like) {
    $success = null;
    if ( $like ) {
        $success = preg_match($that, $str);
    }
    else {
        $success = ( $str === $that );
    }
    if ($success) {
        echo "ok - php: $test_name\n";
        return true;
    } else {
        echo "not ok - php: $test_name\n".
             "#          got: $str\n".
             "#     expected: $that\n";
        return false;
    }
}

function error_handler($errno, $errstr, $errfile, $errline) {
    global $error_messages;
    if ($errno & (E_ALL ^ E_NOTICE)) {
        array_push($error_messages, $errstr . "\n");
    }
}

?>
PHP
    my $rest = scalar @$test_suite;
    my %snipet;
    $snipet{CFG_FILE} => MT->instance->{cfg_file};
    {
        local $tmpl_vars->{STATIC_CONSTANT} = '';
        local $tmpl_vars->{DYNAMIC_CONSTANT} = 1;
        $snipet{TMPL_VARS} = _dump_php($tmpl_vars);
    }
    $snipet{TEST_SUITE_PHP} = _dump_php($test_suite);
    $snipet{PRERUN_PHP} = '';
    for my $snipet ( values %PRERUN_PHP ) {
        $snipet{PRERUN_PHP} .= $snipet;
    }
    $snipet{SETUP_PHP} = '';
    for my $snipet ( values %SETUP_PHP ) {
        $snipet{SETUP_PHP} .= $snipet;
    }
    $test_script =~ s/<\Q$_\E>/$snipet{$_}/g for keys %snipet;

    # now run the test suite through PHP!
    my $pid = open2( \*IN, \*OUT, "php" );
    print OUT $test_script;
    close OUT;
    select IN;
    $| = 1;
    select STDOUT;

    my @lines;
    my $num = 1;

    my $test = sub {
        while (@lines) {
        SKIP: {
                my $result = shift @lines;
                if ( $result =~ s/^ok - // ) {
                    $rest--;
                    pass($result);
                }
                elsif ( $result =~ s/^not ok - // ) {
                    $rest--;
                    fail($result);
                }
                elsif ( $result =~ s/^skip - // ) {
                    $rest--;
                    skip( $result, 1 );
                }
                elsif ( $result =~ s/^#\s// ) {
                    note($result);
                }
                else {
                    diag($result);
                }
            }
        }
    };

    my $output = '';
    while (<IN>) {
        $output = $_;
        push @lines, split( "\n", $output );
        $test->();
    }
    close IN;
    $test->() if @lines;
    is( $rest, 0, "Done all php tests" . ( $test_section ? " in section $test_section" : "" ) );
}

1;

=head1 NAME

MT::Test::Tags

=head1 SYNOPSIS

  use MT::Test::Tags;
  use Test::More;
  run_tests([
      {
          template => '<mt:entries><mt:entryTitle /></mt:entries>',
          expected => 'foobar',
      },
  ]);
  done_testing();

  ## Alternative, write tests in YAML format in __DATA__ section.
  use MT::Test::Tags;
  run_tests_by_data();
  __DATA__
  -
    template: <mt:entries><mt:entryTitle></mt:entries>
    expected: foobar

  ## if you want to skip some tests, give a reason as skip
  __DATA__
  -
    skip: I don't wanna test this!
    template: <mt:var name="password_of_melody">
    expected: Nelson

=head1 TEST SUITE

Test suite must be an array of hash ref. in each hash must has "template"
and "expected" values. also you can add optional values for convenience.

=over 4

=item * name | n (optional)

A name or description of this test.

=item * template | t

Template which you want to test.

=item * expected | e

Expected string which the result the template was built.

=item * like | l

Like L<expected> but try to match with result string as RegExp.

=item * error

If L<error> is true, test tool understands that this template snipet
should get any errors. If both L<expected> and L<like> ain't given,
say OK just if got error. And if L<expected> or L<like> is given, try
them for matching for error messages.

=item * skip | s (optional)

If you want to skip this test for now, give the reason here.

=item * trim (optional)

By default, the result of L<template> and L<expected> are compared after
trimed (ignore the first and last whitespaces).
If you don't want that, set 0 for this.

=item * expected_php

This value is used for matching only at php testing.

=item * like_php

This value is used for matching only at php testing.

=back
