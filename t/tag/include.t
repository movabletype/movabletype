#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT;
use MT::Test;
use MT::Test::Permission;
use MT::Test::Tag;
use MT::Memcached;
use MT::Touch;

my $app = MT->instance;

$test_env->prepare_fixture('db');

my $blog = MT::Blog->load(1);
$blog->include_cache(1);
$blog->include_system('php');
$blog->save;

my $template = MT::Test::Permission->make_template(
    blog_id          => $blog->id,
    type             => 'custom',
    name             => 'MyTemplate',
    text             => 'MODULE-CONTENT',
    include_with_ssi => 0,
);

$ENV{MT_TEST_ENABLE_SSI_PHP_MOCK} = 1;

my $i;

MT::Test::Tag->run_perl_tests($blog->id, sub { setup($_[1]); });
MT::Test::Tag->run_php_tests($blog->id, sub { setup($_[0]); return; });

sub setup {
    my ($block) = @_;

    if (defined($block->reset_test_count)) {
        $i = 1;
        require MT::Cache::Negotiate;
        my $cache_driver = MT::Cache::Negotiate->new;
        $cache_driver->flush_all;

        require File::Path;
        require File::Basename;
        my $dummy = $blog->include_path({id => 1});
        File::Path::rmtree(File::Basename::dirname($dummy));
    }

    if (my $str = $block->template_module_cache_setting) {
        my $hash = eval($str);
        while (my ($key, $val) = each(%$hash)) {
            $template->$key($val);
        }
    }

    $template->text('MODULE-CONTENT' . $i++);
    $template->modified_by(1) if defined($block->set_template_modified_on);
    $template->save;
    sleep(1);    # make sure cache get ttl is 1 second at least
}

sub Test::Base::Filter::embed_file_path {
    my ($self, $in) = @_;
    my $field = filter_arguments;
    my $cont = $self->{current_block}->$field;
    chomp($cont);
    require File::Temp;
    my ( $fh, $file ) = File::Temp::tempfile();
    print $fh $cont;
    close $fh;
    $in =~ s{PATH}{$file};
    $in;
}

done_testing;

__DATA__

=== test 883-1
--- reset_test_count
--- file_content
FILE-CONTENT
--- mt_config
{AllowFileInclude => 1}
--- template embed_file_path=file_content
left <mt:Include file="PATH"> right
--- expected
left FILE-CONTENT right

=== test 883-2
--- mt_config
{AllowFileInclude => 0}
--- template
left <mt:Include file="PATH"> right
--- expected_error
File inclusion is disabled by "AllowFileInclude" config directive.
--- expected_php_error
left File include is disabled by "AllowFileInclude" config directive. right

=== test 883-3 include php file
--- file_content
<?php echo 3+4;
--- mt_config
{AllowFileInclude => 1, DynamicTemplateAllowPHP => 0}
--- template embed_file_path=file_content
<mt:Include ssi="1" file="PATH">
--- expected
7
--- expected_php_todo
<?php echo 3+4;

=== test 883-4 include php file
--- file_content
<?php echo 5+6;
--- mt_config
{AllowFileInclude => 1, DynamicTemplateAllowPHP => 1}
--- template embed_file_path=file_content
<mt:Include ssi="1" file="PATH">
--- expected
11

=== include module with ssi 1
--- reset_test_count
--- template
<MTInclude module="MyTemplate" ssi="1">
--- expected
MODULE-CONTENT1

=== include module with ssi 2
--- template
<MTInclude module="MyTemplate" ssi="1" cache="1">
--- expected
MODULE-CONTENT2

=== include module with ssi 3
--- template
<MTInclude module="MyTemplate" ssi="1" cache="1">
--- expected
MODULE-CONTENT2

=== include module with ssi 4 (see MTC-29994)
--- template
<MTInclude module="MyTemplate" ssi="1">
--- expected
MODULE-CONTENT4
--- expected_php_todo
MODULE-CONTENT4
