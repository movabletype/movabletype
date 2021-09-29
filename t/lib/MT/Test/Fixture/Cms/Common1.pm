package MT::Test::Fixture::Cms::Common1;
use strict;
use warnings;
use base 'MT::Test::Fixture';

sub prepare_fixture {
    MT::Test->init_db;

    # Website
    my $website = MT::Test::Permission->make_website(name => 'my website');

    # Blog
    my $blog = MT::Test::Permission->make_blog(parent_id => $website->id, name => 'my blog');

    # Author
    my $admin = MT->model('author')->load(1);
}

1;
