use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new( AltTemplatePath => "TEST_ROOT/alt-tmpl", );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

my $admin_id  = MT->config->AdminThemeId;
my $tmpl_path = ($admin_id ? "$admin_id/" : "") . "cms/layout/common/header.tmpl";
my $tmpl      = $test_env->slurp("$ENV{MT_HOME}/tmpl/$tmpl_path");
my $bom       = "\xef\xbb\xbf";
$test_env->save_file( "alt-tmpl/$tmpl_path", "$bom$tmpl" );
$test_env->save_file( "alt-tmpl/my_header.tmpl",
    "$bom\n<!DOCTYPE html>\n<html><head><title><mt:Var name='title' _default='My HEADER' /></title></head><body>" );
$test_env->save_file( "alt-tmpl/my_nested_header.tmpl",
    "$bom\n<mt:Ignore>define special variable</mt:Ignore>\n<mt:Include name='my_header.tmpl' title='NESTED HEADER'>" );

use MT;
use MT::Test;
use MT::Test::App;
use MT::Test::Fixture;

$test_env->prepare_fixture('db');

my $objs = MT::Test::Fixture->prepare(
    {   author  => [qw/author/],
        website => [ { name => 'My Site' } ],
        entry   => [
            {   author      => 'author',
                title       => 'entry1',
                authored_on => '20200825000000',
            },
        ],
        content_type => { ct => [ cf_text => 'single_line_text' ] },
        content_data => {
            first_cd => {
                content_type => 'ct',
                author       => 'author',
                authored_on  => '20200826000000',
                label        => 'first_cd',
                data         => { cf_text => 'test', },
            },
        },
        template => [
            {   type => 'index',
                name => 'tmpl_index',
                text => <<'TMPL',
<mt:Include name="my_header.tmpl">
Index
</body>
</html>
TMPL
                outfile => 'index.html',
            },
            {   type => 'index',
                name => 'tmpl_index_nested',
                text => <<'TMPL',
<mt:Include name="my_nested_header.tmpl">
Index
</body>
</html>
TMPL
                outfile => 'index_nested.html',
            },
            {   archive_type => 'Individual',
                name         => 'tmpl_individual',
                text         => <<'TMPL',
<mt:Include name="my_header.tmpl">
Entry <mt:EntryId>: <mt:EntryTitle>
</body>
</html>
TMPL
                mapping => [ { file_template => "entry/%f", }, ],
            },
            {   archive_type => 'Yearly',
                name         => "tmpl_yearly",
                text         => <<'TMPL',
<mt:Include name="my_header.tmpl">
<mt:Entries>Entry <mt:EntryId>: <mt:EntryTitle>
</mt:Entries>
</body>
</html>
TMPL
                mapping => [ { file_template => "entry/%y/index.html", }, ],
            },
            {   archive_type => 'ContentType',
                name         => 'tmpl_ct',
                content_type => 'ct',
                text         => <<'TMPL',
<mt:Include name="my_header.tmpl">
Content <mt:ContentId>: <mt:ContentLabel>
</body>
</html>
TMPL
                mapping => [ { file_template => 'ct/%f', }, ],
            },
        ],
    }
);

my $app   = MT::Test::App->new('MT::App::CMS');
my $admin = MT::Author->load(1);
$app->login($admin);

my $res = $app->get( { __mode => 'view', blog_id => 1, _type => 'entry' } );

my $content = $res->content;
test_bom( $content, "edit entry" );

MT->publisher->rebuild( BlogID => $objs->{blog_id} );

$test_env->ls;

my $index = $test_env->slurp( $test_env->path("index.html") );
test_bom( $index, "index", 1 );

my $index_nested = $test_env->slurp( $test_env->path("index_nested.html") );
test_bom( $index_nested, "index_nested" );

my $entry = $test_env->slurp( $test_env->path("entry/entry1.html") );
test_bom( $entry, "entry", 1 );

my $cd_id = $objs->{content_data}{first_cd}->unique_id;

my $cd = $test_env->slurp( $test_env->path("ct/$cd_id.html") );
test_bom( $cd, "content_data", 1 );

done_testing;

sub test_bom {
    my ( $body, $where, $has_my_header ) = @_;
    ok $body =~ /<!DOCTYPE/is, "$where has doctype";
    if ($has_my_header) {
        ok $body =~ /My HEADER/, "$where has My HEADER" or note $body;
    }
    my ($leading_whitespaces) = $body =~ /\A(.*)<!DOCTYPE/is;

    ok !$leading_whitespaces or note join ",", map { ord($_) } split //, $leading_whitespaces;
    ok $leading_whitespaces !~ /$bom/s, "no bom in $where";
}
