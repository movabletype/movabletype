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

use Class::Unload;
no Carp::Always;

subtest 'Load ContentType after Website' => sub {
    ## Clean up
    Class::Unload->unload($_) for qw/MT::ContentType MT::Website/;
    $test_env->reset_cluck_errors;

    ## Initialize some
    $MT::plugins_installed = 0;
    my $mt = bless {}, 'MT';
    $mt->bootstrap unless $MT::MT_DIR;
    $mt->{mt_dir}     = $MT::MT_DIR;
    $mt->{config_dir} = $MT::CFG_DIR;
    $mt->{app_dir}    = $MT::APP_DIR;

    $mt->init_callbacks;
    $mt->init_config;

    ok !$INC{"MT/ContentType.pm"}, "ContentType is not loaded yet";
    ok !$INC{"MT/Website.pm"},     "Website is not loaded yet";

    ## Properties are not installed at this moment
    ## and kept in @MT::Object::PRE_INIT_PROPS
    require MT::Website;
    require MT::ContentType;

    ## Install properties actually
    $mt->init_schema;

    my $website_child_classes = MT::Website->__properties->{child_classes};
    ok exists $website_child_classes->{'MT::ContentType'},
        "ContentType exists";

    $test_env->prepare_fixture('db');

    MT::Website->remove;
    MT::ContentType->remove;

    my $site = MT::Website->new( name => 'site' );
    ok $site->save, "site is created";
    my $ct = MT::ContentType->new( blog_id => $site->id, name => 'ct' );
    ok $ct->save, "ct is created";

    ok $site->remove, "site is removed";

    ok !( MT::Website->count ),     "no website";
    ok !( MT::ContentType->count ), "no content type";
};

subtest 'Load ContentType before Website: MTC-27225' => sub {
    ## Clean up
    Class::Unload->unload($_) for qw/MT::ContentType MT::Website/;
    $test_env->reset_cluck_errors;

    ## Initialize some
    $MT::plugins_installed = 0;
    my $mt = bless {}, 'MT';
    $mt->bootstrap unless $MT::MT_DIR;
    $mt->{mt_dir}     = $MT::MT_DIR;
    $mt->{config_dir} = $MT::CFG_DIR;
    $mt->{app_dir}    = $MT::APP_DIR;

    $mt->init_callbacks;
    $mt->init_config;

    ok !$INC{"MT/ContentType.pm"}, "ContentType is not loaded yet";
    ok !$INC{"MT/Website.pm"},     "Website is not loaded yet";

    ## Properties are not installed at this moment
    ## and kept in @MT::Object::PRE_INIT_PROPS
    require MT::ContentType;
    require MT::Website;

    ## Install properties
    $mt->init_schema;

    my $website_child_classes = MT::Website->__properties->{child_classes};
    ok exists $website_child_classes->{'MT::ContentType'},
        "ContentType exists";

    $test_env->prepare_fixture('db');

    MT::Website->remove;
    MT::ContentType->remove;

    my $site = MT::Website->new( name => 'site' );
    ok $site->save, "site is created";
    my $ct = MT::ContentType->new( blog_id => $site->id, name => 'ct' );
    ok $ct->save, "ct is created";

    ok $site->remove, "site is removed";

    ok !( MT::Website->count ),     "no website";
    ok !( MT::ContentType->count ), "no content type";
};

subtest 'ContentData removal: MTC-27225' => sub {
    ## Clean up
    Class::Unload->unload($_) for qw/MT::ContentType MT::Website/;
    $test_env->reset_cluck_errors;

    $MT::plugins_installed = 0;
    my $mt = bless {}, 'MT';
    $mt->bootstrap unless $MT::MT_DIR;
    $mt->{mt_dir}     = $MT::MT_DIR;
    $mt->{config_dir} = $MT::CFG_DIR;
    $mt->{app_dir}    = $MT::APP_DIR;

    $mt->init_callbacks;
    $mt->init_config;

    require MT::Website;
    require MT::ContentType;
    require MT::ContentData;

    $mt->init_schema;

    $test_env->prepare_fixture('db');

    MT::Website->remove;
    MT::ContentType->remove;
    MT::ContentData->remove;

    my $site = MT::Website->new( name => 'site' );
    ok $site->save, "site is created";
    my $ct = MT::ContentType->new( blog_id => $site->id, name => 'ct' );
    ok $ct->save, "ct is created";
    my $cd = MT::ContentData->new(
        blog_id         => $site->id,
        content_type_id => $ct->id,
        label           => 'cd',
        author_id       => 1
    );
    ok $cd->save, "cd is created";

    ok $site->remove, "site is removed";

    ok !( MT::Website->count ),     "no website";
    ok !( MT::ContentType->count ), "no content type";
    ok !( MT::ContentData->count ), "no content data";
};

done_testing;
