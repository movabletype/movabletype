#!/usr/bin/perl

use strict;
use warnings;

use lib qw(lib t/lib);

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

my $ct = MT::Test::Permission->make_content_type(
    name    => 'test content type 1',
    blog_id => $blog->id,
);

my $cd = MT::Test::Permission->make_content_data(
    blog_id         => $blog->id,
    content_type_id => $ct->id,
    title           => 'mt:ContentPermalink Test Data',
    status          => MT::Entry::RELEASE(),
    authored_on     => '20170927112314',
);

MT::Test::Tag->run_perl_tests( $blog->id );

__END__

=== MT::ContentPermalink
--- template
<mt:Contents><mt:ContentPermalink></mt:Contents>
--- expected
/test/archives/2017/09/mtcontentpermalink-test-data.html
