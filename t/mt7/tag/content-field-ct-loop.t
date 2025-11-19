#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new(DefaultLanguage => 'en_US');
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test::Tag;
use MT;
use MT::Test;
use MT::Test::Permission;
use MT::Test::Fixture;
use MT::Test::Fixture::ContentData;

my $app     = MT->instance;
my $blog_id = 1;

$test_env->prepare_fixture('db');
my $ct1 = MT::Test::Permission->make_content_type(blog_id => $blog_id, name => 'Place');
my $ct2 = MT::Test::Permission->make_content_type(blog_id => $blog_id, name => 'Event');
my $cf1 = MT::Test::Permission->make_content_field(
    blog_id => $blog_id, content_type_id => $ct1->id, name => 'Addr', type => 'single_line_text',
);
my $cf2 = MT::Test::Permission->make_content_field(
    blog_id => $blog_id, content_type_id => $ct2->id, name => 'At', type => 'content_type',
);
$ct1->fields([{
    id        => $cf1->id,
    order     => 1,
    type      => $cf1->type,
    unique_id => $cf1->unique_id,
}]);
$ct1->save or die $ct1->errstr;
$ct2->fields([{
        id        => $cf2->id,
        order     => 1,
        type      => $cf2->type,
        unique_id => $cf2->unique_id,
        options   => {
            label  => $cf2->name,
            source => $cf2->id,
        },
    },
]);
$ct2->save or die $ct2->errstr;

my $cd1 = MT::Test::Permission->make_content_data(
    blog_id => $blog_id, content_type_id => $ct1->id, label => "Home", data => { $cf1->id => "Tokyo, Japan" },
);

my %props = (blog_id => $blog_id, content_type_id => $ct2->id, data => { $cf2->id => [$cd1->id] });
MT::Test::Permission->make_content_data(%props, label => 'Interview');
MT::Test::Permission->make_content_data(%props, label => 'Lunch meeting');
MT::Test::Permission->make_content_data(%props, label => 'Piano Lesson');

MT::Test::Tag->run_perl_tests($blog_id);
MT::Test::Tag->run_php_tests($blog_id);

done_testing;

__END__

=== MTContents loop
--- template
<mt:Contents content_type="Event">[<mt:ContentLabel>]</mt:Contents>
--- expected
[Piano Lesson][Lunch meeting][Interview]

=== MTContents loop with conten_type field
--- template
<mt:Contents content_type="Event">[<mt:ContentLabel>][<mt:ContentField content_field="At"><mt:ContentFieldValue></mt:ContentField>]</mt:Contents>
--- expected
[Piano Lesson][Home][Lunch meeting][Home][Interview][Home]
