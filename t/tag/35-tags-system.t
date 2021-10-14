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

plan tests => (1 + 2) * blocks;

use MT;
use MT::Test;
use MT::Test::Permission;
my $app = MT->instance;

$test_env->prepare_fixture('db');
my $site        = MT::Test::Permission->make_website(name => 'test website');
my $child       = MT::Test::Permission->make_blog(parent_id => $site->id, name => 'test blog');
my $tmpl_site   = MT::Test::Permission->make_template(blog_id => $site->id,  name => 'vars', text => 'parent');

my %vars = (
    CHILD_ID => $child->id
);

sub var {
    for my $line (@_) {
        for my $key ( keys %vars ) {
            my $value = $vars{$key};
            $line =~ s/$key/$value/g;
        }
    }
    @_;
}

filters {
    template => [qw( chomp var )],
    expected => [qw( chomp )],
    error    => [qw( chomp )],
};

MT::Test::Tag->run_perl_tests($site->id);
MT::Test::Tag->run_php_tests($site->id);

__END__

=== mt:Include with parent=1 inside other site context
--- template
<mt:MultiBlog include_blogs="CHILD_ID">
<$mt:Include module="vars" parent="1"$>
</mt:MultiBlog>
--- expected
parent
