# Movable Type (r) Open Source (C) 2001-2011 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package MT::Test::Tags;
use strict;
use warnings;
use base qw( Exporter );
our @EXPORT = qw( run_tests run_tests_by_data );
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
our %const;
our $test_section = 0;

sub run_tests {
    my ($test_suite) = @_;
    prepare_test_suite($test_suite);
    $test_section++;
    # Ok. We are now ready to test!
    perl_tests($test_suite);
    php_tests($test_suite);
}

sub run_tests_by_data {
    my $test_suite = load_tests_from_data_section();
    prepare_test_suite($test_suite);

    # Ok. We are now ready to test!
    plan tests => ( scalar(@$test_suite) * 2 ) + 2;
    perl_tests($test_suite);
    php_tests($test_suite);
}

sub load_tests_from_data_section {
    ## At first, test YAML::Syck.
    ## This style of tests can't run without it.
    eval { require YAML::Syck };
    plan skip_all => "YAML::Syck is not installed." if $@;

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
    );

    sub prepare_test_suite {
        my ($test_suite) = @_;
        prepare_consts();
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

sub prepare_consts {
    my $blog = MT::Blog->load(1);
    # entry we want to capture is dated: 19780131074500
    my $tsdiff = time - ts2epoch( $blog, '19780131074500' );
    my $daysdiff = int( $tsdiff / ( 60 * 60 * 24 ) );
    %const = (
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
    );
}

sub perl_tests {
    my ($test_suite) = @_;

    # Clear cache
    my $request = MT::Request->instance;
    $request->{__stash} = {};

    my $ctx  = MT::Template::Context->new;
    my $blog = MT::Blog->load(1);
    my $entry = MT::Entry->load(1);
    $ctx->stash( 'blog',    $blog );
    $ctx->stash( 'blog_id', $blog->id );
    $ctx->stash( 'builder', MT::Builder->new );
    $ctx->{current_timestamp} = '20040816135142';

    my $rest = scalar @$test_suite;
    foreach my $test_item (@$test_suite) {
        SKIP: {
            if ( $test_item->{skip} ) {
                $rest--;
                skip( $test_item->{skip}, 1 )
            }
            my $template = $test_item->{template};
            my $expected = $test_item->{expected};
            local $ctx->{__stash}{entry} = $entry
                if $template =~ m/<MTEntry/;
            $ctx->{__stash}{entry} = undef
                if $template =~ m/MTComments|MTPings/;
            $ctx->{__stash}{entries} = undef
                if $template =~ m/MTEntries|MTPages/;
            $ctx->stash( 'comment', undef );
            $request->{__stash} = {};
            $template =~ s/\Q$_\E/$const{$_}/g for keys %const;
            $expected =~ s/\Q$_\E/$const{$_}/g for keys %const;
            my $result = build( $ctx, $template );
            if ( $test_item->{trim} ) {
                $result   =~ s/^\s*//;
                $result   =~ s/\s*$//;
                $expected =~ s/^\s*//;
                $expected =~ s/\s*$//;
            }
            is( $result, $expected, $test_item->{name} );
            $rest--;
        }
    }
    is( $rest, 0, "Done all perl tests" . ( $test_section ? " in section $test_section" : "" ) );
}

sub build {
    my ( $ctx, $markup ) = @_;
    my $b = $ctx->stash('builder');
    my $tokens = $b->compile( $ctx, $markup );
    print( '# -- error compiling: ' . $b->errstr ), return undef
        unless defined $tokens;
    my $res = $b->build( $ctx, $tokens );
    print '# -- error building: ' . ( $b->errstr ? $b->errstr : '' ) . "\n"
        unless defined $res;
    return $res;
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
    my ($test_suite) = @_;
    my $test_script = <<'PHP';
<?php
include_once("php/mt.php");
include_once("php/lib/MTUtil.php");

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

        if ($test_item["skip"] ) {
            echo "skip - php: " . $test_item["skip"] . "\n";
        } else {
            $template = $test_item["template"];
            $expected = $test_item["expected"];
            global $const;
            foreach ($const as $c => $r) {
                $template = preg_replace('/' . $c . '/', $r, $template);
                $expected = preg_replace('/' . $c . '/', $r, $expected);
            }
            $result = build($ctx, $template);
            if ( $test_item["trim"] ) {
                $result   = trim($result);
                $expected = trim($expected);
            }
            ok($result, $expected, $test_item["name"]);
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
        return join('', $error_messages) . $_contents;
    } else {
        return $ctx->error("Error compiling template module '$module'");
    }
}

function ok($str, $that, $test_name) {
    if ($str === $that) {
        echo "ok - php: $test_name\n";
        return true;
    } else {
        echo "not ok - php: $test_name\n".
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
    my $rest = scalar @$test_suite;
    $const{TEST_SUITE_PHP} = _dump_php($test_suite);
    $test_script =~ s/<\Q$_\E>/$const{$_}/g for keys %const;

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
                elsif ( $result =~ m/^#/ ) {
                    print STDERR $result . "\n";
                }
                else {
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

=item * template | t

Template which you want to test.

=item * expected | e

Expected string which the result the template was built.

=item * name | n (optional)

A name or description of this test.

=item * skip | s (optional)

If you want to skip this test for now, give the reason.

=item * trim (optional)

By default, the result of template and expected are compared after
trimed (ignore the first and last whitespaces).
If you don't want that, set 0 for this.

=back
