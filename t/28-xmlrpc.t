use strict;
use lib 't/lib', 'extlib', 'lib', '../lib', '../extlib';

BEGIN {
    $ENV{MT_HOME} = './';
};

use MT;

use Test::More qw( no_plan );

# To keep away from being under FastCGI
$ENV{HTTP_HOST} = 'localhost';

use vars qw( $DB_DIR $T_CFG );
my $mt = MT->new( Config => $T_CFG ) or die MT->errstr;
isa_ok($mt, 'MT');

use MT::Test qw(:db :data);

my $base_uri = '/mt-xmlrpc.cgi';
my $username = 'Chuck D';
my $password = 'seecret';

use XMLRPC::Lite;
my $ser   = XMLRPC::Serializer->new();
my $deser = XMLRPC::Deserializer->new();

require LWP::UserAgent::Local;
my $ua = new LWP::UserAgent::Local({ ScriptAlias => '/' });

my @apis = (
    {
        api    =>'blogger.getUsersBlogs',
        params => [ '', $username, $password ],
        result => sub {
            my ( $som ) = @_;
            my $result = $som->result;
            is( $result->[0]->{url}, 'http://narnia.na/nana/', 'url is correct' );
            is( $result->[0]->{blogid}, 1, 'blogid is correct' );
            is( $result->[0]->{blogName}, 'none', 'blogName is correct' );
        }
    },
    {
        api    => 'blogger.getUserInfo',
        params => [ '', $username, $password ],
        result => sub {
            my ( $som ) = @_;
            my $result = $som->result;
            my $author = MT::Author->load({ name => 'Chuck D' });
            is( $result->{userid}, $author->id);
            is( $result->{firstname}, (split /\s+/, $author->name)[0]);
            is( $result->{lastname}, (split /\s+/, $author->name)[1]);
            is( $result->{nickname}, $author->nickname || '');
            is( $result->{email}, $author->email || '');
            is( $result->{url}, $author->url || '');
        }
    },
    {
        api    => 'blogger.getUsersBlogs',
        params => [ '', 'Chuck D', 'wrong' ],
        result => sub {
            my ( $som ) = @_;
            ok(!$som->result);
            ok($som->fault);
            is($som->faultstring, 'Invalid login');
            is($som->faultcode, 1);
        }
    },
    {
        api    => 'blogger.getUserInfo',
        params => [ '', 'Chuck D', 'wrong' ],
        result => sub {
            my ( $som ) = @_;
            ok(!$som->result);
            ok($som->fault);
            is($som->faultstring, 'Invalid login');
            is($som->faultcode, 1);
        }
    },
    {
        api    => 'blogger.getRecentPosts',
        params => [ '', 1, $username, $password, 2 ],
        result => sub {
            my ( $som ) = @_;
            my $result = $som->result;
            is(scalar(@$result), 2);
            my $entry  = MT::Entry->load(3);
            my $author = MT::Author->load({ name => 'Chuck D' });
            is($result->[0]->{userid}, $author->id);
            is($result->[0]->{postid}, $entry->id);
            my $ao = sprintf "%04d%02d%02dT%02d:%02d:%02d",
                unpack 'A4A2A2A2A2A2', $entry->authored_on;
            is($result->[0]->{dateCreated}, $ao);
            is($result->[0]->{content}, $entry->text);
            $entry  = MT::Entry->load(2);
            $author = MT::Author->load({ name => 'Bob D' });
            is($result->[1]->{userid}, $author->id);
            is($result->[1]->{postid}, $entry->id);
            my $ao = sprintf "%04d%02d%02dT%02d:%02d:%02d",
                unpack 'A4A2A2A2A2A2', $entry->authored_on;
            is($result->[1]->{dateCreated}, $ao);
            is($result->[1]->{content}, $entry->text);
        },
    },
    {
        api    => 'metaWeblog.getRecentPosts',
        params => [ 1, $username, $password, 2 ],
        result => sub {
            my ( $som ) = @_;
            my $result = $som->result;
            is(scalar(@$result), 2);
            my $author = MT::Author->load({ name => 'Chuck D' });
            my $entry  = MT::Entry->load(3);
            is($result->[0]->{userid}, $author->id);
            is($result->[0]->{postid}, $entry->id);
            my $ao = sprintf "%04d%02d%02dT%02d:%02d:%02d",
                unpack 'A4A2A2A2A2A2', $entry->authored_on;
            is($result->[0]->{dateCreated}, $ao);
            is($result->[0]->{description}, $entry->text);
            is($result->[0]->{title}, $entry->title);
            is($result->[0]->{link}, $entry->permalink);
            is($result->[0]->{permaLink}, $entry->permalink);
            is($result->[0]->{mt_excerpt},
                defined $entry->excerpt ? $entry->excerpt : '' );
            is($result->[0]->{mt_text_more}, $entry->text_more);
            is($result->[0]->{mt_allow_comments}, $entry->allow_comments);
            is($result->[0]->{mt_allow_pings}, 0);
            is($result->[0]->{mt_convert_breaks}, $entry->convert_breaks || '');
            is($result->[0]->{mt_keywords}, '');
            $author = MT::Author->load({ name => 'Bob D' });
            $entry  = MT::Entry->load(2);
            is($result->[1]->{userid}, $author->id);
            is($result->[1]->{postid}, $entry->id);
            $ao = sprintf "%04d%02d%02dT%02d:%02d:%02d",
                unpack 'A4A2A2A2A2A2', $entry->authored_on;
            is($result->[1]->{dateCreated}, $ao);
            is($result->[1]->{description}, $entry->text);
            is($result->[1]->{title}, $entry->title);
            is($result->[1]->{link}, $entry->permalink);
            is($result->[1]->{permaLink}, $entry->permalink);
            is($result->[1]->{mt_excerpt},
                defined $entry->excerpt ? $entry->excerpt : '' );
            is($result->[1]->{mt_text_more}, $entry->text_more);
            is($result->[1]->{mt_allow_comments}, $entry->allow_comments);
            is($result->[1]->{mt_allow_pings}, $entry->allow_pings || '');
            is($result->[1]->{mt_convert_breaks}, $entry->convert_breaks || '');
            is($result->[1]->{mt_keywords}, $entry->keywords || '');
        },
    },
    {
        api    => 'blogger.editPost',
        params => [ '', 3, $username, $password, 'Foo Bar', 0 ],
        result => sub {
            my ( $som ) = @_;
            my $result = $som->result;
            MT::Entry->driver->Disabled(1);
            my $entry = MT::Entry->load(3);
            MT::Entry->driver->Disabled(0);
            is($entry->text, 'Foo Bar');
        },
    },
    {
        api    => 'metaWeblog.editPost',
        params => [ 3, $username, $password, {
            title => 'Title',
            description => 'Description',
            mt_convert_breaks => 'wiki',
            mt_allow_comments => 1,
            mt_allow_pings => 1,
            mt_excerpt => 'Excerpt',
            mt_text_more => 'Extended Entry',
            mt_keywords => 'Keywords',
            mt_tb_ping_urls => [ 'http://127.0.0.1/' ],
            dateCreated => '19770922T15:30:00',
        }, 0 ],
        result => sub {
            my ( $som ) = @_;
            my $result = $som->result;
            MT::Entry->driver->Disabled(1);
            my $entry = MT::Entry->load(3);
            MT::Entry->driver->Disabled(0);
            is($entry->title, 'Title');
            is($entry->text, 'Description');
            is($entry->convert_breaks, 'wiki');
            is($entry->allow_comments, 1);
            is($entry->allow_pings, 1);
            is($entry->excerpt, 'Excerpt');
            is($entry->text_more, 'Extended Entry');
            is($entry->keywords, 'Keywords');
            is($entry->to_ping_urls, 'http://127.0.0.1/');
            is($entry->to_ping_url_list->[0], 'http://127.0.0.1/');
            is($entry->authored_on, '19770922153000');
        },
    },
    {
        api    => 'metaWeblog.editPost',
        params => [ 3, $username, $password, {
            mt_convert_breaks => '',
            mt_allow_comments => 2,
            mt_excerpt => '',
            mt_text_more => '',
        }, 0 ],
        result => sub {
            my ( $som ) = @_;
            my $result = $som->result;
        },
    },
    {
        api    => 'mt.getCategoryList',
        params => [ 1, $username, $password ],
        result => sub {
            my ( $som ) = @_;
            my $result = $som->result;
            my $cat1 = MT::Category->load(1);
            my $cat2 = MT::Category->load(2);
            is($result->[0]->{categoryId}, $cat1->id);
            is($result->[0]->{categoryName}, $cat1->label);
            is($result->[1]->{categoryId}, $cat2->id);
            is($result->[1]->{categoryName}, $cat2->label);
        },
    },
    {
        api    => 'mt.getPostCategories',
        params => [ 3, $username, $password ],
        result => sub {
            my ( $som ) = @_;
            my $result = $som->result;
            is(scalar @{ $som->result }, 0);
        },
    },
    {
        api    => 'mt.setPostCategories',
        params => [ 3, $username, $password, [
            { categoryId => 1 } ]
        ],
        result => sub {
            my ( $som ) = @_;
            my $result = $som->result;
            MT::Entry->driver->Disabled(1);
            my $entry = MT::Entry->load(3);
            MT::Entry->driver->Disabled(0);
            my $cat1 = MT::Category->load(1);
            my $cats = $entry->categories;
            is(scalar @$cats, 1);
            is($cats->[0]->label, $cat1->label);
            is($entry->category->label, $cat1->label);
        },
    },
    {
        api    => 'mt.setPostCategories',
        params => [ 3, $username, $password, [
            { categoryId => 1, isPrimary => 1 },
            { categoryId => 2, isPrimary => 0 },
        ] ],
        pre    => sub {
            my $r = MT->request;
            my $oc = $r->cache('object_cache', {});
        },
        result => sub {
            my ( $som ) = @_;
            my $result = $som->result;
            MT::Entry->driver->Disabled(1);
            my $entry = MT::Entry->load(3);
            MT::Entry->driver->Disabled(0);
            my $cat1 = MT::Category->load(1);
            my $cats = $entry->categories;
            is(scalar @$cats, 2);
            is($entry->category->label, $cat1->label);
        },
    },
    {
        api    => 'mt.setPostCategories',
        params => [ 3, $username, $password, [
            { categoryId => 1, isPrimary => 0 },
            { categoryId => 2, isPrimary => 1 },
        ] ],
        pre    => sub {
            my $r = MT->request;
            my $oc = $r->cache('object_cache', {});
        },
        result => sub {
            my ( $som ) = @_;
            my $result = $som->result;
            MT::Entry->driver->Disabled(1);
            my $entry = MT::Entry->load(3);
            MT::Entry->driver->Disabled(0);
            my $cat2 = MT::Category->load(2);
            my $cats = $entry->categories;
            is(scalar @$cats, 2);
            is($entry->category->label, $cat2->label);
        },
    },
    {
        api    => 'mt.setPostCategories',
        params => [ 3, $username, $password, [
        ] ],
        pre    => sub {
            my $r = MT->request;
            my $oc = $r->cache('object_cache', {});
        },
        result => sub {
            my ( $som ) = @_;
            my $result = $som->result;
            MT::Entry->driver->Disabled(1);
            my $entry = MT::Entry->load(3);
            MT::Entry->driver->Disabled(0);
            my $cats = $entry->categories;
            is(scalar @$cats, 0);
            ok(!$entry->category);
        },
    },
    #TODO Add more XML-RPC API
);

my $uri = new URI();
$uri->path($base_uri);
my $req = new HTTP::Request(POST => $uri);

foreach my $api ( @apis ) {

    my $data = {};
    $data = $api->{pre}->() if exists $api->{pre};

    $req->content($ser->method($api->{api}, @{ $api->{params} }));

    my $resp = $ua->request($req);
#    print STDERR $resp->content;
    my $som = $deser->deserialize($resp->content());
    $api->{result}->($som, $data);
}

1;

__END__
