package MT::Test::Fixture::Mt7::Multiblog::Common1;
use strict;
use warnings;
use base 'MT::Test::Fixture';

sub prepare_fixture {
    MT::Test->init_db;

    my $site = MT::Test::Permission->make_website(name => 'test website');
    my $blog = MT::Test::Permission->make_blog(parent_id => $site->id, name => 'test blog');
    my $ct   = MT::Test::Permission->make_content_type(blog_id => $blog->id, name => 'test content type');

    my $cf = MT::Test::Permission->make_content_field(
        blog_id         => $ct->blog_id,
        content_type_id => $ct->id,
        name            => 'single text',
        type            => 'single_line_text',
    );

    my $fields = [{
        id        => $cf->id,
        label     => 1,
        name      => $cf->name,
        order     => 1,
        type      => $cf->type,
        unique_id => $cf->unique_id,
    }];
    $ct->fields($fields);
    $ct->save or die $ct->errstr;

    MT::Test::Permission->make_content_data(
        blog_id         => $ct->blog_id,
        author_id       => 1,
        content_type_id => $ct->id,
        data            => { $cf->id => 'test text' },
    );
}

1;
