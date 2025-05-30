#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib"; # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test;
use Encode;
use Data::Visitor::Tiny;
use File::Find;

require_ok('MT::Util::YAML');

my @classes = qw( YAML::Tiny YAML::Syck YAML::PP YAML::XS );
my @files = ((glob "plugins/*/*.yaml"), (glob "addons/*/*.yaml"));

for my $class ( @classes ) {
    SKIP: {
        eval { MT::Util::YAML::_find_module($class) };
        skip "$class isn't installed." if $@;
        my $data;
        ok(($data) = MT::Util::YAML::LoadFile('t/util/71-yaml.yaml'), "$class: Loadfile");
        ok( 'HASH' eq ref $data, "$class: returns HASHREF");
        ok( defined $data->{TITANS}, "$class: exists key 'TITANS'" ) and
        is( scalar @{ $data->{TITANS} }, 2, "$class: number of array" );
        is($data->{AEUG}{"Hyaku Shiki"}, "Quattro Bajeena", "$class: get hash value" );
        ok(Encode::is_utf8($data->{AEUG}{Methuss}), "$class: wide character is utf8");
        my $str;
        ok( $str = MT::Util::YAML::Dump( $data ), "$class: Dump" );
        ok( Encode::is_utf8($str), "$class: Output of Dump is utf-8");

        for my $file (@files) {
            my $data = eval { MT::Util::YAML::LoadFile($file) };
            ok $data && ref $data, "$class: load $file";
            visit(
                $data,
                sub {
                    my ($key, $valueref) = @_;
                    return unless defined $$valueref;
                    if ($$valueref =~ /sub\s+\{/) {
                        eval "no strict; no warnings; $$valueref; 1" or fail "$class: $$valueref is broken: $@";
                    }
                },
            );
        }
    }
}

done_testing;
