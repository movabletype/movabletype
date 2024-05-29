#!/usr/bin/perl
use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new(
        DefaultLanguage => 'en_US',
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

$test_env->prepare_fixture('db');

use MT;
use MT::Test::App;

my $admin = MT->model('author')->load(1);

subtest 'Load system check' => sub {
    my $app = MT::Test::App->new;
    $app->login($admin);
    $app->get_ok({
        __mode  => 'tools',
        blog_id => 0,
    });
    my @items;
    my $version_info = $app->wq_find('.version li')->each(sub {
        my $text = $_->text;
        $text =~ s/^\s+|\s+$//sg;
        push @items, $text;
    });

    my %check_mt;
    require MT::Util::SystemCheck;
    MT::Util::SystemCheck->check_mt(\%check_mt);
    my $mt_version = $check_mt{version};
    ok grep(/Movable Type version: $mt_version/, @items), "MT version: $mt_version";

    my $packs = MT->find_addons('pack');
    if ($packs) {
        my $has_pack;
        for my $pack (@$packs) {
            my $c = MT->component(lc $pack->{id});
            if ($c) {
                my $label   = $c->label || $pack->{label};
                $label      = $label->() if ref($label) eq 'CODE';
                my $version = $c->version;
                ok grep(/$label  $version/, @items), "$label version: $version";
                $has_pack++;
            }
        }
        if ($has_pack) {
            ok grep(/Addon version:/, @items);
        }
    }
};

done_testing();
