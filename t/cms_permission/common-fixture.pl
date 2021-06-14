#!/usr/bin/perl

$test_env->prepare_fixture(sub {
    MT::Test->init_db;

    # Website
    my $website = MT::Test::Permission->make_website();

    # Blog
    my $blog = MT::Test::Permission->make_blog(parent_id => $website->id, name => 'my blog');

    # Author
    my $aikawa = MT::Test::Permission->make_author(name => 'aikawa', nickname => 'Ichiro Aikawa');

    # Role
    require MT::Role;
    my $site_admin = MT::Role->load({ name => MT->translate('Site Administrator') });

    require MT::Association;
    MT::Association->link($aikawa => $site_admin => $blog);
});

1;
