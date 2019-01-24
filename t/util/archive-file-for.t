use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;

our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

$test_env->prepare_fixture('db');

use MT;
use MT::Test;
use MT::Test::Permission;

my $website = MT->model('website')->load or die;

my $ct = MT::Test::Permission->make_content_type( blog_id => $website->id );
my $cf = MT::Test::Permission->make_content_field(
    blog_id         => $website->id,
    content_type_id => $ct->id,
    name            => 'title',
    type            => 'single_line_text',
);
$ct->fields(
    [   {   id      => $cf->id,
            order   => 1,
            type    => $cf->type,
            options => { label => $cf->name, },
        }
    ]
);
$ct->save or die;

my $cd = MT::Test::Permission->make_content_data(
    blog_id         => $website->id,
    content_type_id => $ct->id,
    label           => 'title001',
);
$cd->data( { $cf->id => $cd->label } );
$cd->save or die;

my $tmpl = MT::Test::Permission->make_template(
    blog_id         => $website->id,
    content_type_id => $ct->id,
);
my $map = MT::Test::Permission->make_templatemap(
    archive_type => 'ContentType',
    blog_id      => $website->id,
    file_template =>
        '<mtcontentfield content_field="title"><mtcontentfieldvalue></mtcontentfield>/%-f',
    template_id => $tmpl->id,
);

$website->archive_type( $map->archive_type );
$website->save or die;

my $publisher = MT->publisher;

my $cat;
my $file
    = $publisher->archive_file_for( $cd, $website, $map->archive_type, $cat,
    $map );
is( $file,
    $cd->label . '/' . $cd->identifier . '.html',
    'Use template tags related content_type in MT::TemplaeMap#file_template'
);

done_testing;

