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

plan tests => 1 * blocks;

use MT;
use MT::Test qw(:db);
use MT::Test::Permission;

my $vars = {};

sub var {
    for my $line (@_) {
        for my $key ( keys %{$vars} ) {
            my $replace = quotemeta "[% ${key} %]";
            my $value   = $vars->{$key};
            $line =~ s/$replace/$value/g;
        }
    }
    @_;
}

filters {
    template => [qw( var chomp )],
    expected => [qw( var chomp )],
    error    => [qw( chomp )],
};

my $blog = MT::Test::Permission->make_blog();
$blog->archive_url('/::/test/archives/');
$blog->archive_type('ContentType');
$blog->save;

my $content_type_01 = MT::Test::Permission->make_content_type(
    name    => 'test content type 01',
    blog_id => $blog->id,
);

my $content_type_02 = MT::Test::Permission->make_content_type(
    name    => 'test content type 02',
    blog_id => $blog->id,
);

my $content_data_01 = MT::Test::Permission->make_content_data(
    blog_id         => $blog->id,
    content_type_id => $content_type_01->id,
    status          => MT::Entry::RELEASE(),
    authored_on     => '20170927112314',
    identifier      => 'mtcontentpermalink-test-data-01',
);

my $content_data_02 = MT::Test::Permission->make_content_data(
    blog_id         => $blog->id,
    content_type_id => $content_type_02->id,
    status          => MT::Entry::RELEASE(),
    authored_on     => '20170927112314',
    identifier      => 'mtcontentpermalink-test-data-02',
);

my $template_01 = MT::Test::Permission->make_template(
    blog_id         => $blog->id,
    content_type_id => $content_type_01->id,
    name            => 'ContentType Test 01',
    type            => 'ct',
    text            => 'test 01',
);

my $template_02 = MT::Test::Permission->make_template(
    blog_id         => $blog->id,
    content_type_id => $content_type_02->id,
    name            => 'ContentType Test 02',
    type            => 'ct',
    text            => 'test 02',
);

my $map_01 = MT::Test::Permission->make_templatemap(
    template_id   => $template_01->id,
    blog_id       => $blog->id,
    archive_type  => 'ContentType',
    file_template => '%y/%m/%-f',
    is_preferred  => 1,
);

my $map_02 = MT::Test::Permission->make_templatemap(
    template_id   => $template_02->id,
    blog_id       => $blog->id,
    archive_type  => 'ContentType',
    file_template => '%y/%m/%-b/%i',
    is_preferred  => 1,
);

$vars->{content_type_01_unique_id} = $content_type_01->unique_id;
$vars->{content_type_02_unique_id} = $content_type_02->unique_id;

MT::Test::Tag->run_perl_tests( $blog->id );

__END__

=== MT::ContentPermalink
--- template
<mt:Contents><mt:ContentPermalink></mt:Contents>
--- expected
/test/archives/2017/09/mtcontentpermalink-test-data-01.html

=== MT::ContentPermalink ContentType 01
--- template
<mt:Contents type="[% content_type_01_unique_id %]"><mt:ContentPermalink></mt:Contents>
--- expected
/test/archives/2017/09/mtcontentpermalink-test-data-01.html

=== MT::ContentPermalink ContentType 02
--- template
<mt:Contents type="[% content_type_02_unique_id %]"><mt:ContentPermalink></mt:Contents>
--- expected
/test/archives/2017/09/mtcontentpermalink-test-data-02/
