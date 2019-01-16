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

plan tests => 2 * blocks;

use MT;
use MT::Test;
use MT::Test::Permission;

use MT::ContentStatus;
use MT::ContentPublisher;

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

$test_env->prepare_fixture('db_data');

my $site = MT->model('website')->load or die;
$site->archive_type('ContentType');
$site->save or die;

my $ct1 = MT::Test::Permission->make_content_type(
    blog_id => $site->id,
    name    => 'ct1',
);
my $ct2 = MT::Test::Permission->make_content_type(
    blog_id => $site->id,
    name    => 'ct2',
);

my $cd1 = MT::Test::Permission->make_content_data(
    authored_on     => '20181127033202',
    blog_id         => $site->id,
    content_type_id => $ct1->id,
    identifier      => 'cd1',
    status          => 2,
);

my $tmpl = MT::Test::Permission->make_template(
    blog_id         => $site->id,
    content_type_id => $ct1->id,
    name            => 'ct1',
    type            => 'ct',
);
my $map = MT::Test::Permission->make_templatemap(
    archive_type  => 'ContentType',
    blog_id       => $site->id,
    file_template => '%y/%m/%-f',
    is_preferred  => 1,
    template_id   => $tmpl->id,
);

MT->rebuild(
    ArchiveType => $map->archive_type,
    Blog        => $site,
    Force       => 1,
    TemplateMap => ($map),
) or die MT->errstr;

$vars->{ct1_unique_id} = $ct1->unique_id;
$vars->{ct2_unique_id} = $ct2->unique_id;

MT::Test::Tag->run_perl_tests( $site->id );
MT::Test::Tag->run_php_tests( $site->id );

done_testing;

__END__

=== MTContentPermalink
--- template
<MTContents content_type="[% ct1_unique_id %]"><MTContentPermalink>
</MTContents>
--- expected
http://narnia.na/2018/11/cd1.html

=== MTContentPermalink type="ContentType"
--- template
<MTContents content_type="[% ct1_unique_id %]"><MTContentPermalink type="ContentType">
</MTContents>
--- expected
http://narnia.na/2018/11/cd1.html

=== MTContentPermalink type="ContentType-Daily"
--- template
<MTContents content_type="[% ct1_unique_id %]"><MTContentPermalink type="ContentType-Daily">
</MTContents>
--- expected_error
Error in <mtContentPermalink> tag: You used an <$MTEntryPermalink$> tag for linking into 'ContentType-Daily' archives, but that archive type is not published.
--- expected_php_todo
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26176
