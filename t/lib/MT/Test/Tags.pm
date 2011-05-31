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

use MT::Test qw(:quickdata);
use MT;
use MT::Util qw(ts2epoch epoch2ts);
use MT::Template::Context;
use MT::Builder;
use IPC::Open2;
require POSIX;

our $test_section = 0;
our ( $PRERUN, $SETUP, $PRERUN_PHP, $SETUP_PHP );

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


sub load_yaml_syck {
    ## At first, test YAML::Syck.
    ## This style of tests can't run without it.
    eval { require YAML::Syck };
    if ( $@ ) {
        plan tests => 1;
        fail("This suite needs YAML::Syck installed");
        return;
    }
    return 1;
}

sub load_tests_from_file {
    load_yaml_syck() or return;
    my ($fn) = @_;
    my $test_suite = YAML::Syck::LoadFile($fn);
    return $test_suite;
}

sub load_tests_from_data_section {
    load_yaml_syck() or return;
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

sub perl_tests {
    my ($test_suite, $tmpl_vars) = @_;

    # Clear cache
    my $request = MT::Request->instance;
    my $stock = {};

    $stock->{blog}  = MT::Blog->load(1);
    $stock->{entry} = MT::Entry->load(1);
    if ( 'CODE' eq ref $PRERUN ) {
        $PRERUN->($stock, $tmpl_vars);
    }

    my $rest = scalar @$test_suite;
    TEST: foreach my $test_item (@$test_suite) {
        my $ctx  = MT::Template::Context->new;
        $request->{__stash} = {};
        my $template = defined $test_item->{template} ? $test_item->{template}
                     :                                  '';
        my $expected = defined $test_item->{expected} ? $test_item->{expected}
                     :                                  '';

        $ctx->stash( 'blog',    $stock->{blog} );
        $ctx->stash( 'blog_id', $stock->{blog}->id );
        $ctx->stash( 'builder', MT::Builder->new );
        $ctx->{current_timestamp} = '20040816135142';
        $ctx->{__stash}{entry} = $stock->{entry}
            if $template =~ m/<MTEntry/;
        $ctx->{__stash}{entry} = undef
            if $template =~ m/MTComments|MTPings/;
        $ctx->{__stash}{entries} = undef
            if $template =~ m/MTEntries|MTPages/;
        $ctx->stash( 'comment', undef );

        if ( 'CODE' eq ref $SETUP ) {
            $SETUP->($test_item, $ctx, $stock, $tmpl_vars);
        }
        for my $area (qw( stash var )) {
            if ( my $conf = $test_item->{$area} ) {
                for my $k ( keys %$conf ) {
                    my $v = $conf->{$k};
                    $ctx->$area( $k => (( defined $v && $v =~ s/^\$// ) ? $stock->{$v} : $v) );
                }
            }
        }
        SKIP: {
            if ( $test_item->{skip} ) {
                $rest--;
                skip( $test_item->{skip}, 1 )
            }
            my $like     = $test_item->{like};
            $template =~ s/\Q$_\E/$tmpl_vars->{$_}/g for keys %$tmpl_vars;
            $expected =~ s/\Q$_\E/$tmpl_vars->{$_}/g for keys %$tmpl_vars;
            my $result;
            eval { $result = build( $ctx, $template ) };
            if ( $@ ) {
                fail( $test_item->{name} );
                note( "Died: " . $@ );
                next TEST;
            }
            if ( $test_item->{error} ) {
                if ( defined $result ) {
                    fail( $test_item->{name} );
                    note( "There should be error, but got no error" );
                    $rest--;
                    next TEST;
                }
                if ( !$expected && !$like ) {
                    ## If expected error string is undefined in test,
                    ## just ok if there is some error.
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
                $result   =~ s/^\s+//mg;
                $expected =~ s/^\s+//mg;
                $result   =~ s/\s+$//mg;
                $expected =~ s/\s+$//mg;
                $result   =~ s/^\n//mg;
                $expected =~ s/^\n//mg;
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
            push @elements, "'$key' => $val";
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

    my $data_section = do { local $/; <DATA> };
    my ($test_script) = $data_section =~ m/__START_PHP_CODE__\n(.*)__STOP_PHP_CODE__/s;
    die "Failed to load PHP test script" unless defined $test_script;

    my $rest = scalar @$test_suite;
    my %snipet;
    $snipet{CFG_FILE} = MT->instance->{cfg_file};
    {
        local $tmpl_vars->{STATIC_CONSTANT} = '';
        local $tmpl_vars->{DYNAMIC_CONSTANT} = 1;
        $snipet{TMPL_VARS} = _dump_php($tmpl_vars);
    }
    $snipet{TEST_SUITE_PHP} = _dump_php($test_suite);
    $snipet{PRERUN_PHP} = $PRERUN_PHP || '';
    $snipet{SETUP_PHP} = $SETUP_PHP || '';
    $test_script =~ s/<\Q$_\E>/$snipet{$_}/g for keys %snipet;

    # now run the test suite through PHP!
    my $pid = open2( \*IN, \*OUT, "php" );
    print OUT $test_script;
    close OUT;

    while (my $result = <IN>) {
        chomp $result;
        if ( $result =~ s/^ok - // ) {
            $rest--;
            pass("$result");
        }
        elsif ( $result =~ s/^not ok - // ) {
            $rest--;
            fail($result);
        }
        elsif ( $result =~ s/^skip - // ) {
            $rest--;
            SKIP: {
                skip( $result, 1 );
            }
        }
        elsif ( $result =~ m/503 Service Unavailable/ ) {
            fail("Connection to the Database failed: 503 Service Unavailable");
            diag("PHP could not find a database server. possible solutions:");
            diag("1. (recommanded) change in the machine's php.ini file two directives");
            diag("   pdo_mysql.default_socket and pdo_mysql.default_socket");
            diag("   to your correct mysql unix-socket");
            diag("2. Please add the following line to mysql-test.cfg");
            diag("   DBHost 127.0.0.1");
        }
        elsif ( $result =~ s/^#\s// ) {
            note($result);
        }
        else {
            diag($result);
        }
    }
    close IN;
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

=head2 TEST DATA STRUCTURE

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
trimed (ignore the first and last whitespaces of each line).
If you don't want that, set 0 for this.

=item * expected_php

This value is used for matching only at php testing.

=item * like_php

This value is used for matching only at php testing.

=item * stash

Set stash to context only for this test item. In simple way, just add
plain value like this;

    template: <mt:entries></mt:entries>
    stash:
        current_timestamp: 20110429000000
        current_timestamp: 20110508235959

If you add a doller sign at the head of the value, you can call any perl
structure from B<$stock> hash.

    # set entry in PRERUN
    local $MT::Test::Tags::PRERUN = sub {
        my ( $stock ) = @_;
        $stock->{my_entry} = MT->model('entry')->load(42);
    };
    # Don't forget about PHP
    local $MT::Test::Tags::PRERUN_PHP = q{
        $stock["my_entry"] = $db->fetch_entry(42);
    };
    # ...And in test suite
    template: <mtEntryTitle>
    expected: foo
    stash:
        entry: $my_entry

=item * var

Set variable to context object only for this test item like L<stash> but
set in to template variables.

=back

=head2 CONSTANT MACRO

Before do test, some constant values in L<template> and L<expected>
could be replaced for convinience. here is the list of constants.

    CFG_FILE
    VERSION_ID
    CURRENT_WORKING_DIRECTORY
    STATIC_CONSTANT
    DYNAMIC_CONSTANT
    DAYS_CONSTANT1
    DAYS_CONSTANT2
    CURRENT_YEAR
    CURRENT_MONTH
    STATIC_FILE_PATH

=head1 VARIABLES

=over 4

=item * PRERUN

You can set a B<reference of subroutine> for modifying some values before
run perl tests.

    local $MT::Test::Tags::PRERUN = sub {
        my ( $stock, $tmpl_vars ) = @_;
        $stock->{blog} = undef;
        $tmpl_vars->{CURRENT_YEAR} = 2012;
    };

=item * PRERUN_PHP

You can set B<strings of PHP code snipet> for midifying some values before
run php tests.

    local $MT::Test::Tags::PRERUN_PHP = q{
        $stock["blog"] = null;
        $tmpl_vars["CURRENT_YEAR"] = 2012;
    };

=item * SETUP

You can set a B<reference of subroutine> for modifying context and values
before run each perl test items.

    local $MT::Test::Tags::SETUP = sub {
        my ($test_item, $ctx, $stock, $tmpl_vars) = @_;
        $ctx->{foo} = 1l
    };

=item * SETUP_PHP

You can set B<strings of PHP code snipet> for midifying context and values
before run each php test items.

    local $MT::Test::Tags::SETUP_PHP = q{
        $ctx["foo"] = 1;
    };

=back

=cut

__DATA__
__START_PHP_CODE__
<?php
include_once("php/mt.php");
include_once("php/lib/MTUtil.php");

if (!ini_get('date.timezone')) {
    date_default_timezone_set('Asia/Tokyo');
}

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
$tmpl_vars['CURRENT_WORKING_DIRECTORY'] = $path;
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
    global $tmpl_vars;
    $base_stash = $ctx->__stash;
    $stock = array();
    $stock["blog"]  = $db->fetch_blog(1);
    $stock["entry"] = $db->fetch_entry(1);
    <PRERUN_PHP>
    TEST: foreach ($suite as $test_item) {
        $ctx->__stash = $base_stash;
        $mt->db()->savedqueries = array();

        $ctx->stash('blog_id', $stock["blog"]->id);
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
        <SETUP_PHP>

        if ( $stash = $test_item["stash"] ) {
            foreach ( $stash as $k => $v ) {
                if ( preg_match('/^\$/',$v) ) {
                    $v = preg_replace('/^\$/', '', $v);
                    $ctx->stash( $k, $stock[$v] );
                }
                else {
                    $ctx->stash( $k, $v );
                }
            }
        }
        if ( $var = $test_item["var"] ) {
            $vars =& $ctx->__stash['vars'];
            foreach ( $var as $k => $v ) {
                if ( preg_match('/^\$/',$v) ) {
                    $v = preg_replace('/^\$/', '', $v);
                    $vars[$k] = $stock[$v];
                }
                else {
                    $vars[$k] = $v;
                }
            }
        }

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

            try {
                $result = build($ctx, $template);
            }
            catch ( Exception $e ) {
                echo "not ok - php: $test_name\n"
                   . "# Fatal error occured: "
                   . $e->getMessage() . "\n";
                continue TEST;
            }
            if ( $test_item["error"] ) {
                if ( !is_null( $result ) ) {
                    echo "not ok - php: $test_name\n";
                    echo "# Should be error, but got no error.\n";
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
                $result   = preg_replace('/^\s+/m', '', $result);
                $expected = preg_replace('/^\s+/m', '', $expected);
                $result   = preg_replace('/\s+$/m', '', $result);
                $expected = preg_replace('/\s+$/m', '', $expected);
                $result   = preg_replace('/^\n/m', '', $result);
                $expected = preg_replace('/^\n/m', '', $expected);
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
__STOP_PHP_CODE__
