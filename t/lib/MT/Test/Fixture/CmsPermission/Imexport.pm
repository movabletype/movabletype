package MT::Test::Fixture::CmsPermission::Imexport;
use strict;
use warnings;
use base 'MT::Test::Fixture';

sub prepare_fixture {
    MT::Test->init_db;

    # Website
    my $website = MT::Test::Permission->make_website();

    # Blog
    my $blog = MT::Test::Permission->make_blog(
        parent_id => $website->id,
        name      => 'my blog',
    );
    my $second_blog = MT::Test::Permission->make_blog(
        parent_id => $website->id,
        name      => 'second blog',
    );

    # Author
    my $aikawa = MT::Test::Permission->make_author(
        name     => 'aikawa',
        nickname => 'Ichiro Aikawa',
    );

    my $ichikawa = MT::Test::Permission->make_author(
        name     => 'ichikawa',
        nickname => 'Jiro Ichikawa',
    );

    my $ukawa = MT::Test::Permission->make_author(
        name     => 'ukawa',
        nickname => 'Saburo Ukawa',
    );

    # Role
    require MT::Role;
    my $blog_admin = MT::Role->load({ name => MT->translate('Site Administrator') });
    my $designer   = MT::Role->load({ name => MT->translate('Designer') });

    require MT::Association;
    MT::Association->link($aikawa   => $blog_admin => $blog);
    MT::Association->link($ichikawa => $blog_admin => $second_blog);
    MT::Association->link($ukawa    => $designer   => $blog);
}

1;
