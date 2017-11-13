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
use MT::Test::Permission;

MT::Test->init_app;

use MT::Author;

my $blog_id = 1;
my $admin   = MT::Author->load(1);

$test_env->prepare_fixture(sub {
    MT::Test->init_db;

    my $ct = MT::Test::Permission->make_content_type(
        blog_id => $blog_id,
        name    => 'test content type',
    );

    my $cf = MT::Test::Permission->make_content_field(
        blog_id         => $ct->blog_id,
        content_type_id => $ct->id,
        name            => 'single line text',
        type            => 'single_line_text',
    );

    my $field_data = [
        {   id        => $cf->id,
            order     => 1,
            type      => $cf->type,
            options   => { label => $cf->name, },
            unique_id => $cf->unique_id,
        },
    ];
    $ct->fields($field_data);
    $ct->save or die $ct->errstr;
});

my $ct = MT::ContentType->load( { name => 'test content type' } );

my $app = _run_app(
    'MT::App::CMS',
    {   __test_user      => $admin,
        __request_method => 'POST',
        __mode           => 'view',
        blog_id          => $ct->blog_id,
        id               => $ct->id,
        _type            => 'content_type',
    },
);
my $out = delete $app->{__test_output};
ok( $out !~ /An error occurred/,
    'No error occurs on edit_content_type screen' );

done_testing;

