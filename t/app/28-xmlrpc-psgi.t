use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
BEGIN {
    eval qq{ use Plack::Test; 1 }
        or plan skip_all => 'Plack::Test is not installed';
}

our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use HTTP::Request::Common;

use MT::Test;
use MT::Test::Permission;
use MT;
use MT::Util qw(ts2iso);
use MT::PSGI;
use XMLRPC::Lite;

my $uri       = MT->config->CGIPath . MT->config->XMLRPCScript;
my $apps      = MT::PSGI->new->to_app;
my $test_apps = Plack::Test->create($apps);

my $serializer   = XMLRPC::Serializer->new();
my $deserializer = XMLRPC::Deserializer->new();

$test_env->prepare_fixture('db');
my $admin = MT::Author->load(1);
my $blog  = MT::Blog->load(1);
my $page  = MT::Test::Permission->make_page(
    blog_id        => $blog->id,
    allow_comments => 0,
    allow_pings    => 0,
);
my $cat = MT::Test::Permission->make_category(blog_id => $blog->id);

# Make sure that all packages (blogger, metaWeblog, wp and mt) are available
my @apis = ({
        api    => 'blogger.getUserInfo',
        params => ['', $admin->name, $admin->api_password],
        result => {
            'lastname'  => '',
            'firstname' => $admin->name,
            'nickname'  => $admin->nickname,
            'userid'    => $admin->id,
            'email'     => $admin->email || '',
            'url'       => $admin->url || '',
        },
    },
    {
        api    => 'metaWeblog.getUsersBlogs',
        params => ['', $admin->name, $admin->api_password],
        result => [{
            'url'      => $blog->site_url,
            'blogid'   => $blog->id,
            'blogName' => $blog->name,
        }],
    },
    {
        api    => 'wp.getPages',
        params => [$blog->id, $admin->name, $admin->api_password],
        result => [{
            'userid'            => $page->author_id,
            'mt_convert_breaks' => $page->convert_breaks || '',
            'dateCreated'       => do {
                my $date_created = ts2iso($blog, $page->authored_on);
                $date_created =~ s/[Z-]//g;
                $date_created;
            },
            'mt_excerpt'   => $page->excerpt   || '',
            'title'        => $page->title     || '',
            'mt_text_more' => $page->text_more || '',
            'mt_tags'      => '',
            'link'         => $page->permalink || '',
            'permaLink'    => $page->permalink || '',
            'mt_keywords'  => $page->keywords,
            'page_id'      => $page->id,
            'mt_basename'  => $page->basename,
            'mt_allow_pings'    => $page->allow_pings ? 1 : 0,
            'description'       => $page->text,
            'mt_allow_comments' => $page->allow_comments ? 1 : 0,
        }],
    },
    {
        api    => 'mt.getCategoryList',
        params => [$blog->id, $admin->name, $admin->api_password],
        result => [{
            'categoryId'   => $cat->id,
            'categoryName' => $cat->label,
        }],
    },
);

for my $api (@apis) {
    my $request_body = $serializer->method(
        $api->{api},
        @{ $api->{params} || [] });

    my $resp = $test_apps->request(
        POST $uri,
        'Content-Type' => 'text/xml',
        Content        => $request_body,
    );
    ok $resp;

    my $result = $deserializer->deserialize($resp->content())->result;
    is_deeply($result, $api->{result}, $api->{api} . ' works with PSGI app.');
}

done_testing;
