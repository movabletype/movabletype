#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../lib"; # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}


use lib qw(lib t/lib);

use MT::Test::Tag;

# plan tests => 2 * blocks;
plan tests => 1 * blocks;

use MT;
use MT::Test qw(:db);
use MT::Test::Permission;

use MT::Entry;

my $app = MT->instance;

my $blog_id = 1;

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

my $mt = MT->instance;

my $user2 = MT::Test::Permission->make_author;
$user2->is_superuser(1);
$user2->save or die $user2->errstr;
$vars->{user2_id} = $user2->id;

my $ct1   = MT::Test::Permission->make_content_type(
    name    => 'test content type 1',
    blog_id => $blog_id,
);
MT::Test::Permission->make_content_data(
    blog_id         => $blog_id,
    content_type_id => $ct1->id,
    status          => MT::Entry::RELEASE(),
) for ( 1 .. 5 );
MT::Test::Permission->make_content_data(
    blog_id         => $blog_id,
    content_type_id => $ct1->id,
    status          => MT::Entry::HOLD(),
);
MT::Test::Permission->make_content_data(
    author_id       => $user2->id,
    blog_id         => $blog_id,
    content_type_id => $ct1->id,
    status          => MT::Entry::HOLD(),
);

MT::Test::Tag->run_perl_tests($blog_id);
# MT::Test::Tag->run_php_tests($blog_id);

__END__

=== MT::AuthorHasContent (author_id=1)
--- template
<mt:Authors id="1"><mt:AuthorHasContent blog_id="1" name="test content type 1">true<mt:else>false</mt:AuthorHasContent></mt:Authors>
--- expected
true

=== MT::AuthorHasContent (author_id=2)
--- template
<mt:Authors id="2" need_entry="0"><mt:AuthorHasContent blog_id="1" name="test content type 1">true<mt:else>false</mt:AuthorHasContent></mt:Authors>
--- expected
false

