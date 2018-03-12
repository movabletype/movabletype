#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test::Tag;

# plan tests => 2 * blocks;
plan tests => 1 * blocks;

use MT;
use MT::Test;
use MT::Test::Permission;
my $app = MT->instance;

my $blog_id = 1;

filters {
    template => [qw( chomp )],
    expected => [qw( chomp )],
    error    => [qw( chomp )],
};

$test_env->prepare_fixture(
    sub {
        MT::Test->init_db;

        my $ct1 = MT::Test::Permission->make_content_type(
            name    => 'test content type 1',
            blog_id => $blog_id,
        );
        MT::Test::Permission->make_content_data(
            blog_id         => $blog_id,
            content_type_id => $ct1->id,
            label           => 'test label 1',
        );

        my $ct2 = MT::Test::Permission->make_content_type(
            name    => 'test content type 2',
            blog_id => $blog_id,
        );
        my $cf = MT::Test::Permission->make_content_field(
            blog_id         => $blog_id,
            content_type_id => $ct2->id,
            type            => 'single_line_text',
        );
        my $fields = [
            {   id      => $cf->id,
                order   => $cf->id,
                type    => $cf->type,
                options => {
                    label    => $cf->name,
                    required => 1,
                },
                unique_id => $cf->unique_id,
            },
        ];
        $ct2->fields($fields);
        $ct2->data_label( $cf->unique_id );
        $ct2->save or die $ct2->errstr;
        my $cd2 = MT::Test::Permission->make_content_data(
            blog_id         => $blog_id,
            content_type_id => $ct2->id,
            label           => 'test label 2 (not used)',
        );
        my $data = { $cf->id => 'test label 2', };
        $cd2->data($data);
        $cd2->save or die $cd2->errstr;
    }
);

print MT->model('content_data')->load->label;
print "\n";

MT::Test::Tag->run_perl_tests($blog_id);

# MT::Test::Tag->run_php_tests($blog_id);

__END__

=== MT::ContentLabel (test content type 1)
--- template
<mt:Contents content_type="test content type 1"><mt:ContentLabel></mt:Contents>
--- expected
test label 1

=== MT::ContentLabel (test content type 2)
--- template
<mt:Contents content_type="test content type 2"><mt:ContentLabel></mt:Contents>
--- expected
test label 2

