use strict;
use lib 't/lib', 'extlib', 'lib', '../lib', '../extlib';

BEGIN {
    $ENV{MT_HOME} = './';
};

use MT;

use Test::More qw( no_plan );
use MIME::Base64;

# To keep away from being under FastCGI
$ENV{HTTP_HOST} = 'localhost';

use MT::Test qw(:db :data);
my $mt = MT->new() or die MT->errstr;
isa_ok($mt, 'MT');

my $base_uri = '/mt-xmlrpc.cgi';
my $username = 'Chuck D';
my $password = 'seecret';

use XMLRPC::Lite;
my $ser   = XMLRPC::Serializer->new();
my $deser = XMLRPC::Deserializer->new();

require LWP::UserAgent::Local;
my $ua = new LWP::UserAgent::Local({ ScriptAlias => '/' });

my $logo = q{R0lGODlhlgAZANUAAP////Ly8uTk5NfX18nJyb29vbu7u62trZ6eno+Pj1iZvVKQsoCAgE6IqHx8fEmAnnFxcUV4lGtra0BwimFhYTtnf1lZWTZfdVBQUDFWaitMXz8/PydDUyA5SC0tLRswPBYlLxkZGQ8bIggPEwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACH5BAAHAP8ALAAAAACWABkAAAb/QAjBQCoaMQSC0QiaKJ6LzGhJIhyoVQSWQcBgi8lwIkTdEDZfkjCchHzZbC3JfF0eCOQign3wLOFJRgWDFgUkBRYJAAAUVAaLVBxPk08PU0YHAH5GFABuVAIARF8ABAkIA6VUGABeX4oJsbGuVLKZB7GfJI+NRQwACX8CsQQAAZskpbKxS4YOBRIFDooBSkYeiwBLH08cSxEKD0udwUYGAXlGEACpyEvA5ppLrLS12mlf9FghAQJkHgEGUAlUZF25ZAexGILGUBECeXoAZPoWjgqIbksECLgmEcsAARsAyKECL6I7fa/u4VvV6ss6LcXQ/LFGAtvBkl8WHjqkCFsd/34GFBkZ8eQDlgoKKixR5OqXzCMAGJAYgA6LRAwYElRjWW9pK6xY0+Vr+QaYSCwEPTzSdRXs0zRCH5H5lVUltwlfiEZY4rOIRiznyKzTZSTbogBdUWJRZJhsGsVUAALwh7ZxnSKNVa0UyirYX6FFRChYcGmJpAUD0bGSyrdjkYBWD2ClkKoeZK9gw668veRXr4HDElBwl0y225UkQGvs5AZ0kQUKLlAZAV2BUXWeMoklkWlAmACOMR8MIWpeeK/IueLjXYWm1YTpQa8LUNU5iQxPQCzB/wTvkmquGcHPAMsocpl4AmpWBHvJqZQeCQxCeB4Y7pEEH3Kg8XNWg1Q8EP9OBiDyN4k3mCzS1S+EVQERZsbR5ol5DOSWDlO5vYVFhOwRRIpxYBFnjxEPbWJfERdQYiRGRYS0EShLLmHQO4YFAB8rjdHCmGEVqvfYhO3hkxlOX3hASwhPifmFCBpU0MCRT0ixoI0QwhnnPLl9EUJuuhUhJp5yCojBdkvcCegcfUKIJwY+PqioCBdUR8kCF1yn6KSUVmrppZheKoKHbIajQWmZhirqqKReOgKnnTagX6mstupqqRd1CgWor9Zq661fICVrUrj26qutsU4S6QcfdPAErb8mq6ylaz7RABVFSrrstNQi50RR0y0gbbXcdkuCBk/shQUHInhrLrei8XoZ7rrrFmkdu/B664S48dY7LQcPkGjvvksEAQA7};

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
        api    => 'mt.getRecentPostTitles',
        params => [ 1, $username, $password, 3 ],
        result => sub {
            my ( $som ) = @_;
            my $result = $som->result;
            is(scalar(@$result), 3);
            my @entries = MT::Entry->load({
                blog_id => 1,
            }, {
                'sort' => 'authored_on',
                'direction' => 'descend',
                limit => 3,
            });
            for ( my $i = 0; $i < 3; ++$i ) {
                is( $entries[$i]->id, $result->[$i]->{postid} );
                is( $entries[$i]->title, $result->[$i]->{title} );
            }
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
    {
        api    => 'blogger.newPost',
        params => [ '', 1, $username, $password, 'This is a new post.', 0 ],
        result => sub {
            my ( $som ) = @_;
            my $result = $som->result;
            my $entry = MT::Entry->load($result);
            ok($entry);
            is($entry->text, 'This is a new post.');
            # RELEASE unless NoPublishMeansDraft
            is($entry->status, MT::Entry::RELEASE());
        },
    },
    {
        api    => 'metaWeblog.newPost',
        params => [ 1, $username, $password, {
            title => 'MetaWeblog Post',
            description => 'This is a new post via metaWeblog API.'
        }, 1 ],
        result => sub {
            my ( $som ) = @_;
            my $result = $som->result;
            my $entry = MT::Entry->load($result);
            ok($entry);
            is($entry->title, 'MetaWeblog Post');
            is($entry->text, 'This is a new post via metaWeblog API.');
            # RELEASE unless NoPublishMeansDraft
            is($entry->status, MT::Entry::RELEASE());
        },
    },
    {
        api    => 'blogger.deletePost',
        params => [ '', 25, $username, $password, 0 ],
        pre    => sub {
            my ( $e1 ) = MT::Entry->load(undef,
                { sort => 'created_on', direction => 'descend', limit => 1 }
            );
            is( $e1->id, 25 );
            return $e1;
        },
        result => sub {
            my ( $som, $data ) = @_;
            my $result = $som->result;
            MT::Entry->driver->Disabled(1);
            my $entry = MT::Entry->load($data->id);
            is( $entry, undef );
            MT::Entry->driver->Disabled(0);
        },
    },
    {
        api    => 'metaWeblog.getPost',
        params => [ 24, $username, $password ],
        pre    => sub {
            my ( $e2 ) = MT::Entry->load(undef,
                { sort => 'created_on', direction => 'descend', limit => 1 }
            );
            is( $e2->id, 24 );
            return $e2;
        },
        result => sub {
            my ( $som ) = @_;
            my $result = $som->result;
            my $entry = MT::Entry->load(24);
            ok($entry);
            is($entry->permalink, $result->{permaLink});
            is($entry->basename, $result->{mt_basename});
            is($entry->text, $result->{description});
        },
    },
    {
        api    => 'metaWeblog.deletePost',
        params => [ '', 24, $username, $password, 0 ],
        pre    => sub {
            my ( $e2 ) = MT::Entry->load(undef,
                { sort => 'created_on', direction => 'descend', limit => 1 }
            );
            is( $e2->id, 24 );
            return $e2;
        },
        result => sub {
            my ( $som, $data ) = @_;
            my $result = $som->result;
            MT::Entry->driver->Disabled(1);
            my $entry = MT::Entry->load($data->id);
            is( $entry, undef );
            MT::Entry->driver->Disabled(0);
        },
    },
    {
        api    => 'metaWeblog.newMediaObject',
        params => [ 1, $username, $password, {
            name => 'movable-type-logo.gif',
            type => 'image/gif',
            bits  => sub {
                return MIME::Base64::decode_base64($logo);
            },
        } ],
        result => sub {
            my ( $som ) = @_;
            my $result = $som->result;
            my $url = $result->{url};
            is( $url, 'http://narnia.na/nana/movable-type-logo.gif' );
            my $asset = MT::Asset::Image->load(undef, { sort => 'created_on', direction => 'descend', limit => 1 });
            ok($asset, 'asset loaded');
            is( $asset->mime_type, 'image/gif' );
            is( $asset->file_name, 'movable-type-logo.gif' );
            local $/;
            open my $fh, '<', $asset->file_path;
            my $image = <$fh>;
            close $fh;
            require MIME::Base64;
            is( $logo, MIME::Base64::encode_base64($image, '') );
        },
        post   => sub {
            my $asset = MT::Asset->load(undef, { sort => 'created_on', direction => 'descend', limit => 1 });
            $asset->remove();
        }
    },
    {
        api    => 'metaWeblog.getCategories',
        params => [ 1, $username, $password ],
        result => sub {
            my ( $som ) = @_;
            my $result = $som->result;
            my @cats = MT::Category->load({blog_id=>1});
            for ( my $i = 0; $i <= $#cats; ++$i ) {
                is($cats[$i]->id, $result->[$i]->{categoryId});
                is($cats[$i]->label, $result->[$i]->{categoryName});
                is($cats[$i]->description, $result->[$i]->{description});
                if ( my $parent = $cats[$i]->parent_category ) {
                    is($parent->id, $result->[$i]->{parentId});
                }
                else { 
                    ok(!($result->[$i]->{parentId}));
                }
            }
            is(scalar(@$result), scalar(@cats));
        },
    },
    {
        api    => 'mt.getTrackbackPings',
        params => [ 1, $username, $password ],
        result => sub {
            my ( $som ) = @_;
            my $result = $som->result;
            my @pings = MT::TBPing->load( undef, {
                'join' => MT::Trackback->join_on( undef, {
                    id => \'= tbping_tb_id',
                }, {
                    'join' => MT::Entry->join_on( undef, {
                        id => \'= trackback_entry_id',
                        class => 'entry',
                    }
                ) }
            ) } );
            for ( my $i = 0; $i <= $#pings; ++$i ) {
                is($pings[$i]->ip, $result->[$i]->{pingIP});
                is($pings[$i]->source_url, $result->[$i]->{pingURL});
                is($pings[$i]->title, $result->[$i]->{pingTitle});
            }
            is(scalar(@$result), scalar(@pings));
        },
    },
    {
        api    => 'mt.supportedTextFilters',
        params => [ $username, $password ],
        result => sub {
            my ( $som ) = @_;
            my $result = $som->result;
            my %tf = (
                '__default__' => 1,
                'richtext' => 1,
                'markdown' => 1,
                'markdown_with_smartypants' => 1,
                'textile_2' => 1,
            );
            foreach my $res ( @$result ) {
                is(1, delete( $tf{$res->{key}} ), $res->{key});
            }
            ok(!%tf);
        },
    },
    {
        api    => 'mt.getTagList',
        params => [ 1, $username, $password ],
        result => sub {
            my ( $som ) = @_;
            my $result = $som->result;
            my @tags = MT::Tag->load(undef, {
                'join' => MT::ObjectTag->join_on(undef, {
                    tag_id => \'= tag_id',
                    blog_id => 1
                }, { unique => 1 })
            });
            for ( my $i = 0; $i <= $#tags; ++$i ) {
                is($tags[$i]->id, $result->[$i]->{tagId});
                is($tags[$i]->name, $result->[$i]->{tagName});
            }
            is(scalar(@$result), scalar(@tags));
        },
    },
    #TODO Add these tests
    #'wp.newPage', 'wp.getPages', 'wp.getPage', 'wp.editPage', 'wp.deletePage',
    # 'mt.publishPost',
    # newPost with mt_tags
);

my $uri = new URI();
$uri->path($base_uri);
my $req = new HTTP::Request(POST => $uri);

foreach my $api ( @apis ) {

    my $data = {};
    $data = $api->{pre}->() if exists $api->{pre};
    my @params;
    foreach my $param ( @{ $api->{params} } ) {
        if ( 'CODE' eq ref($param) ) {
            push @params, $param->();
        }
        elsif ( 'HASH' eq ref($param) ) {
            my $hash = {};
            while ( my ( $key, $val ) = each %$param ) {
                if ( 'CODE' eq ref($val) ) {
                    $hash->{$key} = $val->();
                }
                else {
                    $hash->{$key} = $val;
                }
            }
            push @params, $hash;
        }
        else {
            push @params, $param;
        }
    }
    $req->content($ser->method($api->{api}, @params));

    my $resp = $ua->request($req);
#    print STDERR $resp->content;
    my $som = $deser->deserialize($resp->content());
    $api->{result}->($som, $data);
    $api->{post}->() if exists $api->{post};
}

1;
__END__
