package MT::Test::Fixture::Mt7::Tag::Site::Entry;
use strict;
use warnings;
use base 'MT::Test::Fixture';

sub prepare_fixture {
    MT::Test->init_db;
    MT::Test->init_data;

    MT::Test::Permission->make_entry( blog_id => 2 );
}

1;
