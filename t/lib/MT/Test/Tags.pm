# Movable Type (r) Open Source (C) 2001-2011 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package MT::Test::Tags;
use strict;
use warnings;

use base qw( Exporter );
our @EXPORT = qw( run_tests );

use IPC::Open2;

BEGIN {
    $ENV{MT_CONFIG} = 'mysql-test.cfg';
}

$| = 1;

use MT::Test qw(:db :data);
use Test::More;
use JSON -support_by_pp;
use MT;
use MT::Util qw(ts2epoch epoch2ts);
use MT::Template::Context;
use MT::Builder;

require POSIX;
our %const;

sub run_tests {
    my ( $test_suite ) = @_;
    if ( !defined $test_suite ) {
        $test_suite = load_tests_from_data_section();
    }
    prepare_test_data($test_suite);
    # Ok. We are now ready to test!
    plan tests => (scalar(@$test_suite) * 2) + 3;
    perl_tests($test_suite);
    php_tests($test_suite);
}

sub load_tests_from_data_section {
    ## Taken from Data::Section::Simple
    my $data = do { no strict 'refs'; \*main::DATA };
    die "No Data section found" unless defined fileno $data;
    seek $data, 0, 0;
    my $content = join '', <$data>;
    $content =~ s/^.*\n__DATA__\n/\n/s;    # for win32
    $content =~ s/\n__END__\n.*$/\n/s;
    require YAML::Tiny;
    my $test_suite = YAML::Tiny::Load($content);
    return $test_suite;
}

{
    my %aliases = qw(
        template t
        expected e
        run      r
        skip     s
    );

    sub prepare_test_data {
        my ($test_suite) = @_;
        for my $item (@$test_suite) {
            for my $longname ( keys %aliases ) {
                my $alias = $aliases{$longname};
                if ( !defined $item->{$longname} && defined $item->{$alias} ) {
                    $item->{$longname} = $item->{$alias};
                }
            }

            $item->{skip} = 'NO REASON GIVEN'
                if !defined $item->{skip}
                    && defined $item->{run}
                    && !$item->{run};
        }
    }
}

sub perl_tests {
    my ( $test_suite ) = @_;
    # Clear cache
    my $request = MT::Request->instance;
    $request->{__stash} = {};

    my $blog_name_tmpl = MT::Template->load({name => "blog-name", blog_id => 1});
    ok($blog_name_tmpl, "'blog-name' template found");

    my $ctx = MT::Template::Context->new;
    my $blog = MT::Blog->load(1);
    ok($blog, "Test blog loaded");
    $ctx->stash('blog', $blog);
    $ctx->stash('blog_id', $blog->id);
    $ctx->stash('builder', MT::Builder->new);

    my $entry  = MT::Entry->load( 1 );
    ok($entry, "Test entry loaded");

    # entry we want to capture is dated: 19780131074500
    my $tsdiff = time - ts2epoch($blog, '19780131074500');
    my $daysdiff = int($tsdiff / (60 * 60 * 24));
    %const = (
        CFG_FILE => MT->instance->{cfg_file},
        VERSION_ID => MT->instance->version_id,
        CURRENT_WORKING_DIRECTORY => MT->instance->server_path,
        STATIC_CONSTANT => '1',
        DYNAMIC_CONSTANT => '',
        DAYS_CONSTANT1 => $daysdiff + 1,
        DAYS_CONSTANT2 => $daysdiff - 1,
        CURRENT_YEAR => POSIX::strftime("%Y", localtime),
        CURRENT_MONTH => POSIX::strftime("%m", localtime),
        STATIC_FILE_PATH => MT->instance->static_file_path . '/',
    );

    $ctx->{current_timestamp} = '20040816135142';

    my $num = 1;
    foreach my $test_item (@$test_suite) {
        SKIP: {
            $num++;
            skip( $test_item->{skip}, 1 )
                if $test_item->{skip};
            local $ctx->{__stash}{entry} = $entry
                if $test_item->{template} =~ m/<MTEntry/;
            $ctx->{__stash}{entry} = undef
                if $test_item->{template} =~ m/MTComments|MTPings/;
            $ctx->{__stash}{entries} = undef
                if $test_item->{template} =~ m/MTEntries|MTPages/;
            $ctx->stash( 'comment', undef );
            $request->{__stash} = {};
            my $result = build( $ctx, $test_item->{template} );
            is( $result, $test_item->{expected}, "perl test " . $num++ );
        }
    }
}

sub build {
    my($ctx, $markup) = @_;
    my $b = $ctx->stash('builder');
    my $tokens = $b->compile($ctx, $markup);
    print('# -- error compiling: ' . $b->errstr), return undef
        unless defined $tokens;
    my $res = $b->build($ctx, $tokens);
    print '# -- error building: ' . ($b->errstr ? $b->errstr : '') . "\n"
        unless defined $res;
    return $res;
}

sub _dump_php {
    my ( $data ) = @_;
    my $out;
    if ( ref $data eq 'HASH' ) {
        my @elements;
        for my $key ( keys %$data ) {
            my $val = _dump_php( $data->{$key} );
            push @elements, "$key => $val";
        }
        return sprintf 'array(%s)', join(',', @elements);
    }
    elsif ( ref $data eq 'ARRAY' ) {
        my @elements;
        for my $val ( @$data ) {
            push @elements, _dump_php( $val );
        }
        return sprintf 'array(%s)', join(',', @elements);
    }
    elsif ( !ref $data ) {
        return $data =~ /^\d+$/ ? $data : sprintf( '"%s"', $data );
    }
    die "unsupported type: " . ref $data;
}

sub php_tests {
    my ($test_suite) = @_;
    my $test_script = <<'PHP';
<?php
include_once("php/mt.php");
include_once("php/lib/MTUtil.php");
require "t/lib/JSON.php";

$cfg_file = '<CFG_FILE>';

$const = array(
    'CFG_FILE' => $cfg_file,
    'VERSION_ID' => VERSION_ID,
    'CURRENT_WORKING_DIRECTORY' => '',
    'STATIC_CONSTANT' => '',
    'DYNAMIC_CONSTANT' => '1',
    'DAYS_CONSTANT1' => '<DAYS_CONSTANT1>',
    'DAYS_CONSTANT2' => '<DAYS_CONSTANT2>',
    'CURRENT_YEAR' => strftime("%Y"),
    'CURRENT_MONTH' => strftime("%m"),
    'STATIC_FILE_PATH' => '<STATIC_FILE_PATH>',
);

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

$ctx->stash('blog_id', 1);
$blog = $db->fetch_blog(1);
$ctx->stash('blog', $blog);
$ctx->stash('current_timestamp', '20040816135142');
$mt->init_plugins();
$entry = $db->fetch_entry(1);

$suite = <TEST_SUITE_PHP>;

set_error_handler('error_handler');

run($ctx, $suite);

function run(&$ctx, $suite) {
    $test_num = 0;
    global $entry;
    global $mt;
    global $tmpl;
    $base_stash = $ctx->__stash;
    foreach ($suite as $test_item) {
        $ctx->__stash = $base_stash;
        $mt->db()->savedqueries = array();
        if ( preg_match('/MT(Entry|Link)/', $test_item["template"]) 
          && !preg_match('/MT(Comments|Pings)/', $test_item["template"]) )
        {
            $ctx->stash('entry', $entry);
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
        $test_num++;
        if ($test_item["skip"] ) {
            echo "skip - " . $test_item["skip"] . "\n";
        } else {
            $tmpl = $test_item["template"];
            $result = build($ctx, $test_item["template"]);
            ok($result, $test_item["expected"], $test_num);
        }
    }
}

function cleanup($tmpl) {
    # Translating perl array/hash structures to PHP...
    # This is not a general solution... it's custom built for our input.
    $tmpl = preg_replace('/^ *#.*$/m', '', $tmpl);
    $tmpl = preg_replace('/# *\d+ *(?:TBD.*)? *$/m', '', $tmpl);
    return $tmpl;
}

function build(&$ctx, $tmpl) {
    global $error_messages;
    $error_messages = array();
    if ($ctx->_compile_source('evaluated template', $tmpl, $_var_compiled)) {
        ob_start();
        $ctx->_eval('?>' . $_var_compiled);
        $_contents = ob_get_contents();
        ob_end_clean();
        return join('', $error_messages) . $_contents;
    } else {
        return $ctx->error("Error compiling template module '$module'");
    }
}

function ok($str, $that, $test_num) {
    global $mt;
    global $tmpl;
    $str = trim($str);
    $that = trim($that);
    if ($str === $that) {
        echo "ok - php test $test_num\n";
        return true;
    } else {
        echo "not ok - php test $test_num\n".
             "#     expected: $that\n".
             "#          got: $str\n";
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
    $const{TEST_SUITE_PHP} = _dump_php($test_suite);
    $test_script =~ s/<\Q$_\E>/$const{$_}/g for keys %const;

    # now run the test suite through PHP!
    my $pid = open2(\*IN, \*OUT, "php");
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
                if ($result =~ m/^ok/) {
                    pass($result);
                } elsif ($result =~ m/^not ok/) {
                    fail($result);
                } elsif ($result =~ m/skip/ ) {
                    skip($result, 1);
                } elsif ($result =~ m/^#/) {
                    print STDERR $result . "\n";
                } else {
                    print $result . "\n";
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
}

1;

=head1 NAME

MT::Test::Tags

=head1 SYNOPSIS

  use MT::Test::Tags;
  run_tests([
      {
          template => '<mt:entries><mt:entryTitle /></mt:entries>',
          expected => 'foobar',
      },
  ]);

  ## Alternative, write tests in YAML format in __DATA__ section.
  use MT::Test::Tags;
  run_tests();
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
  ## you can also skip by give false value to the run.
  ## this is legacy behaviour.
  -
    run: 0
