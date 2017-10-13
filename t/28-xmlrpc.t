use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/lib"; # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test qw(:db :data);
use MT::Test::Permission;
use MT::Util qw(archive_file_for);
use File::Basename qw(dirname);
use MIME::Base64;

use MT::FileMgr;
my $fmgr = MT::FileMgr->new('Local');

# To keep away from being under FastCGI
$ENV{HTTP_HOST} = 'localhost';

my $mt = MT->new() or die MT->errstr;

isa_ok( $mt, 'MT' );

# Adjust authored_on because result of load_iter is undetermined.
my $entry_iter = MT::Entry->load_iter();
while ( my $e = $entry_iter->() ) {
    $e->authored_on( $e->authored_on + $e->id );
    $e->save;
}

my $base_uri = '/mt-xmlrpc.cgi';
my $username = 'Chuck D';
my $password = 'seecret';

use XMLRPC::Lite;
my $ser   = XMLRPC::Serializer->new();
my $deser = XMLRPC::Deserializer->new();

require LWP::UserAgent::Local;
my $ua = new LWP::UserAgent::Local( { ScriptAlias => '/' } );

my $logo
    = q{R0lGODlhlgAZANUAAP////Ly8uTk5NfX18nJyb29vbu7u62trZ6eno+Pj1iZvVKQsoCAgE6IqHx8fEmAnnFxcUV4lGtra0BwimFhYTtnf1lZWTZfdVBQUDFWaitMXz8/PydDUyA5SC0tLRswPBYlLxkZGQ8bIggPEwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACH5BAAHAP8ALAAAAACWABkAAAb/QAjBQCoaMQSC0QiaKJ6LzGhJIhyoVQSWQcBgi8lwIkTdEDZfkjCchHzZbC3JfF0eCOQign3wLOFJRgWDFgUkBRYJAAAUVAaLVBxPk08PU0YHAH5GFABuVAIARF8ABAkIA6VUGABeX4oJsbGuVLKZB7GfJI+NRQwACX8CsQQAAZskpbKxS4YOBRIFDooBSkYeiwBLH08cSxEKD0udwUYGAXlGEACpyEvA5ppLrLS12mlf9FghAQJkHgEGUAlUZF25ZAexGILGUBECeXoAZPoWjgqIbksECLgmEcsAARsAyKECL6I7fa/u4VvV6ss6LcXQ/LFGAtvBkl8WHjqkCFsd/34GFBkZ8eQDlgoKKixR5OqXzCMAGJAYgA6LRAwYElRjWW9pK6xY0+Vr+QaYSCwEPTzSdRXs0zRCH5H5lVUltwlfiEZY4rOIRiznyKzTZSTbogBdUWJRZJhsGsVUAALwh7ZxnSKNVa0UyirYX6FFRChYcGmJpAUD0bGSyrdjkYBWD2ClkKoeZK9gw668veRXr4HDElBwl0y225UkQGvs5AZ0kQUKLlAZAV2BUXWeMoklkWlAmACOMR8MIWpeeK/IueLjXYWm1YTpQa8LUNU5iQxPQCzB/wTvkmquGcHPAMsocpl4AmpWBHvJqZQeCQxCeB4Y7pEEH3Kg8XNWg1Q8EP9OBiDyN4k3mCzS1S+EVQERZsbR5ol5DOSWDlO5vYVFhOwRRIpxYBFnjxEPbWJfERdQYiRGRYS0EShLLmHQO4YFAB8rjdHCmGEVqvfYhO3hkxlOX3hASwhPifmFCBpU0MCRT0ixoI0QwhnnPLl9EUJuuhUhJp5yCojBdkvcCegcfUKIJwY+PqioCBdUR8kCF1yn6KSUVmrppZheKoKHbIajQWmZhirqqKReOgKnnTagX6mstupqqRd1CgWor9Zq661fICVrUrj26qutsU4S6QcfdPAErb8mq6ylaz7RABVFSrrstNQi50RR0y0gbbXcdkuCBk/shQUHInhrLrei8XoZ7rrrFmkdu/B664S48dY7LQcPkGjvvksEAQA7};

my $new_entry_id;
my @apis = (
    {   api    => 'blogger.getUsersBlogs',
        params => [ '', $username, $password ],
        result => sub {
            my ($som) = @_;
            my $result = $som->result;

            # blog
            is( $result->[0]->{url},
                'http://narnia.na/nana/', 'url is correct' );
            is( $result->[0]->{blogid},   1,      'blogid is correct' );
            is( $result->[0]->{blogName}, 'none', 'blogName is correct' );

            # website
            is( $result->[1]->{url}, 'http://narnia.na/', 'url is correct' );
            is( $result->[1]->{blogid}, '2', 'blogid is correct' );
            is( $result->[1]->{blogName}, 'Test site',
                'blogName is correct' );
        }
    },
    {   api    => 'metaWeblog.getUsersBlogs',
        params => [ '', $username, $password ],
        result => sub {
            my ($som) = @_;
            my $result = $som->result;

            # blog
            is( $result->[0]->{url},
                'http://narnia.na/nana/', 'url is correct' );
            is( $result->[0]->{blogid},   1,      'blogid is correct' );
            is( $result->[0]->{blogName}, 'none', 'blogName is correct' );

            # website
            is( $result->[1]->{url}, 'http://narnia.na/', 'url is correct' );
            is( $result->[1]->{blogid}, '2', 'blogid is correct' );
            is( $result->[1]->{blogName}, 'Test site',
                'blogName is correct' );
        }
    },
    {   api    => 'blogger.getUserInfo',
        params => [ '', $username, $password ],
        result => sub {
            my ($som) = @_;
            my $result = $som->result;
            my $author = MT::Author->load( { name => 'Chuck D' } );
            is( $result->{userid}, $author->id );
            is( $result->{firstname}, ( split /\s+/, $author->name )[0] );
            is( $result->{lastname},  ( split /\s+/, $author->name )[1] );
            is( $result->{nickname}, $author->nickname || '' );
            is( $result->{email},    $author->email    || '' );
            is( $result->{url},      $author->url      || '' );
        }
    },
    {   api    => 'blogger.getUsersBlogs',
        params => [ '', 'Chuck D', 'wrong' ],
        result => sub {
            my ($som) = @_;
            ok( !$som->result );
            ok( $som->fault );
            is( $som->faultstring, 'Invalid login' );
            is( $som->faultcode,   1 );
        }
    },
    {   api    => 'metaWeblog.getUsersBlogs',
        params => [ '', 'Chuck D', 'wrong' ],
        result => sub {
            my ($som) = @_;
            ok( !$som->result );
            ok( $som->fault );
            is( $som->faultstring, 'Invalid login' );
            is( $som->faultcode,   1 );
        }
    },
    {   api    => 'blogger.getUserInfo',
        params => [ '', 'Chuck D', 'wrong' ],
        result => sub {
            my ($som) = @_;
            ok( !$som->result );
            ok( $som->fault );
            is( $som->faultstring, 'Invalid login' );
            is( $som->faultcode,   1 );
        }
    },
    {   api    => 'blogger.getRecentPosts',
        params => [ '', 1, $username, $password, 2 ],
        result => sub {
            my ($som) = @_;
            my $result = $som->result;
            is( scalar(@$result), 2 );
            my $entry = MT::Entry->load(3);
            my $author = MT::Author->load( { name => 'Chuck D' } );
            is( $result->[0]->{userid}, $author->id );
            is( $result->[0]->{postid}, $entry->id );
            my $ao = sprintf "%04d%02d%02dT%02d:%02d:%02d",
                unpack 'A4A2A2A2A2A2', $entry->authored_on;
            is( $result->[0]->{dateCreated}, $ao );
            is( $result->[0]->{content},     $entry->text );
            $entry = MT::Entry->load(2);
            $author = MT::Author->load( { name => 'Bob D' } );
            is( $result->[1]->{userid}, $author->id );
            is( $result->[1]->{postid}, $entry->id );
            $ao = sprintf "%04d%02d%02dT%02d:%02d:%02d",
                unpack 'A4A2A2A2A2A2', $entry->authored_on;
            is( $result->[1]->{dateCreated}, $ao );
            is( $result->[1]->{content},     $entry->text );
        },
    },
    {   api    => 'blogger.getRecentPosts',
        params => [ '', 2, $username, $password, 2 ],
        pre    => sub {
            my $e1 = MT::Test::Permission->make_entry( blog_id => 2, );
            my $e2 = MT::Test::Permission->make_entry( blog_id => 2, );
            return [ $e1, $e2 ];
        },
        result => sub {
            my ( $som, $entries ) = @_;
            my $result = $som->result;
            is( scalar(@$result), 2 );
            my $entry  = MT::Entry->load( $entries->[0]->id );
            my $author = MT::Author->load( $entries->[0]->author_id );
            is( $result->[0]->{userid}, $author->id );
            is( $result->[0]->{postid}, $entry->id );
            my $ao = sprintf "%04d%02d%02dT%02d:%02d:%02d",
                unpack 'A4A2A2A2A2A2', $entry->authored_on;
            is( $result->[0]->{dateCreated}, $ao );
            is( $result->[0]->{content},     $entry->text );
            $entry  = MT::Entry->load( $entries->[1]->id );
            $author = MT::Author->load( $entries->[1]->author_id );
            is( $result->[1]->{userid}, $author->id );
            is( $result->[1]->{postid}, $entry->id );
            $ao = sprintf "%04d%02d%02dT%02d:%02d:%02d",
                unpack 'A4A2A2A2A2A2', $entry->authored_on;
            is( $result->[1]->{dateCreated}, $ao );
            is( $result->[1]->{content},     $entry->text );
        },
    },
    {   api    => 'metaWeblog.getRecentPosts',
        params => [ 1, $username, $password, 2 ],
        result => sub {
            my ($som) = @_;
            my $result = $som->result;
            is( scalar(@$result), 2 );
            my $author = MT::Author->load( { name => 'Chuck D' } );
            my $entry = MT::Entry->load(3);
            is( $result->[0]->{userid}, $author->id );
            is( $result->[0]->{postid}, $entry->id );
            my $ao = sprintf "%04d%02d%02dT%02d:%02d:%02d",
                unpack 'A4A2A2A2A2A2', $entry->authored_on;
            is( $result->[0]->{dateCreated}, $ao );
            is( $result->[0]->{description}, $entry->text );
            is( $result->[0]->{title},       $entry->title );
            is( $result->[0]->{link},        $entry->permalink );
            is( $result->[0]->{permaLink},   $entry->permalink );
            is( $result->[0]->{mt_excerpt},
                defined $entry->excerpt ? $entry->excerpt : '' );
            is( $result->[0]->{mt_text_more},      $entry->text_more );
            is( $result->[0]->{mt_allow_comments}, $entry->allow_comments );
            is( $result->[0]->{mt_allow_pings},    0 );
            is( $result->[0]->{mt_convert_breaks},
                $entry->convert_breaks || ''
            );
            is( $result->[0]->{mt_keywords}, '' );
            $author = MT::Author->load( { name => 'Bob D' } );
            $entry = MT::Entry->load(2);
            is( $result->[1]->{userid}, $author->id );
            is( $result->[1]->{postid}, $entry->id );
            $ao = sprintf "%04d%02d%02dT%02d:%02d:%02d",
                unpack 'A4A2A2A2A2A2', $entry->authored_on;
            is( $result->[1]->{dateCreated}, $ao );
            is( $result->[1]->{description}, $entry->text );
            is( $result->[1]->{title},       $entry->title );
            is( $result->[1]->{link},        $entry->permalink );
            is( $result->[1]->{permaLink},   $entry->permalink );
            is( $result->[1]->{mt_excerpt},
                defined $entry->excerpt ? $entry->excerpt : '' );
            is( $result->[1]->{mt_text_more},      $entry->text_more );
            is( $result->[1]->{mt_allow_comments}, $entry->allow_comments );
            is( $result->[1]->{mt_allow_pings}, $entry->allow_pings || '0' );
            is( $result->[1]->{mt_convert_breaks},
                $entry->convert_breaks || ''
            );
            is( $result->[1]->{mt_keywords}, $entry->keywords || '' );
        },
    },
    {   api    => 'metaWeblog.getRecentPosts',
        params => [ 2, $username, $password, 2 ],
        pre    => sub {
            my @e = MT::Entry->load(
                { blog_id => 2 },
                { sort => 'authored_on', direction => 'descend', limit => 2 }
            );
            return \@e;
        },
        result => sub {
            my ( $som, $entries ) = @_;
            my $result = $som->result;
            is( scalar(@$result), 2 );
            my $author = MT::Author->load( $entries->[0]->author_id );
            my $entry  = MT::Entry->load( $entries->[0]->id );
            is( $result->[0]->{userid}, $author->id );
            is( $result->[0]->{postid}, $entry->id );
            my $ao = sprintf "%04d%02d%02dT%02d:%02d:%02d",
                unpack 'A4A2A2A2A2A2', $entry->authored_on;
            is( $result->[0]->{dateCreated}, $ao );
            is( $result->[0]->{description}, $entry->text );
            is( $result->[0]->{title},       $entry->title );
            is( $result->[0]->{link},        $entry->permalink );
            is( $result->[0]->{permaLink},   $entry->permalink );
            is( $result->[0]->{mt_excerpt},
                defined $entry->excerpt ? $entry->excerpt : '' );
            is( $result->[0]->{mt_text_more},      $entry->text_more );
            is( $result->[0]->{mt_allow_comments}, $entry->allow_comments );
            is( $result->[0]->{mt_allow_pings}, $entry->allow_pings || '0' );
            is( $result->[0]->{mt_convert_breaks},
                $entry->convert_breaks || ''
            );
            is( $result->[0]->{mt_keywords}, $entry->keywords || '' );
            $author = MT::Author->load( $entries->[1]->author_id );
            $entry  = MT::Entry->load( $entries->[1]->id );
            is( $result->[1]->{userid}, $author->id );
            is( $result->[1]->{postid}, $entry->id );
            $ao = sprintf "%04d%02d%02dT%02d:%02d:%02d",
                unpack 'A4A2A2A2A2A2', $entry->authored_on;
            is( $result->[1]->{dateCreated}, $ao );
            is( $result->[1]->{description}, $entry->text );
            is( $result->[1]->{title},       $entry->title );
            is( $result->[1]->{link},        $entry->permalink );
            is( $result->[1]->{permaLink},   $entry->permalink );
            is( $result->[1]->{mt_excerpt},
                defined $entry->excerpt ? $entry->excerpt : '' );
            is( $result->[1]->{mt_text_more},      $entry->text_more );
            is( $result->[1]->{mt_allow_comments}, $entry->allow_comments );
            is( $result->[1]->{mt_allow_pings}, $entry->allow_pings || '0' );
            is( $result->[1]->{mt_convert_breaks},
                $entry->convert_breaks || ''
            );
            is( $result->[1]->{mt_keywords}, $entry->keywords || '' );
        },
    },
    {   api    => 'mt.getRecentPostTitles',
        params => [ 1, $username, $password, 3 ],
        result => sub {
            my ($som) = @_;
            my $result = $som->result;
            is( scalar(@$result), 3 );
            my @entries = MT::Entry->load(
                { blog_id => 1, },
                {   'sort'      => 'authored_on',
                    'direction' => 'descend',
                    limit       => 3,
                }
            );
            for ( my $i = 0; $i < 3; ++$i ) {
                is( $entries[$i]->id,    $result->[$i]->{postid} );
                is( $entries[$i]->title, $result->[$i]->{title} );
            }
        },
    },
    {   api    => 'mt.getRecentPostTitles',
        params => [ 2, $username, $password, 2 ],
        result => sub {
            my ($som) = @_;
            my $result = $som->result;
            is( scalar(@$result), 2 );
            my @entries = MT::Entry->load(
                { blog_id => 2, },
                {   'sort'      => 'authored_on',
                    'direction' => 'descend',
                    limit       => 2,
                }
            );
            for ( my $i = 0; $i < 2; ++$i ) {
                is( $entries[$i]->id,    $result->[$i]->{postid} );
                is( $entries[$i]->title, $result->[$i]->{title} );
            }
        },
    },
    {   api    => 'blogger.editPost',
        params => [ '', 3, $username, $password, 'Foo Bar', 0 ],
        result => sub {
            my ($som)  = @_;
            my $result = $som->result;
            my $d      = MT::Entry->driver;
            MT::Entry->driver->Disabled(1)
                if MT::Entry->driver->isa(
                'Data::ObjectDriver::Driver::BaseCache');
            my $entry = MT::Entry->load(3);
            MT::Entry->driver->Disabled(0)
                if MT::Entry->driver->isa(
                'Data::ObjectDriver::Driver::BaseCache');
            is( $entry->text, 'Foo Bar' );
        },
    },
    {   api    => 'blogger.editPost',
        params => [
            '',
            sub {
                my $e = MT::Entry->load( undef,
                    { sort => 'id', direction => 'descend' } );
                $e->id;
            },
            $username,
            $password,
            'Foo Bar',
            0
        ],
        pre => sub {
            my $entry = MT::Test::Permission->make_entry(
                blog_id => 2,    # website
            );
            return $entry;
        },
        result => sub {
            my ( $som, $e ) = @_;
            my $result = $som->result;
            my $d      = MT::Entry->driver;
            MT::Entry->driver->Disabled(1)
                if MT::Entry->driver->isa(
                'Data::ObjectDriver::Driver::BaseCache');
            my $entry = MT::Entry->load( $e->id );
            MT::Entry->driver->Disabled(0)
                if MT::Entry->driver->isa(
                'Data::ObjectDriver::Driver::BaseCache');
            is( $entry->text, 'Foo Bar' );
        },
    },
    {   api    => 'metaWeblog.editPost',
        params => [
            3,
            $username,
            $password,
            {   title             => 'Title',
                description       => 'Description',
                mt_convert_breaks => 'wiki',
                mt_allow_comments => 1,
                mt_allow_pings    => 1,
                mt_excerpt        => 'Excerpt',
                mt_text_more      => 'Extended Entry',
                mt_keywords       => 'Keywords',
                mt_tb_ping_urls   => ['http://127.0.0.1/'],
                dateCreated       => '19770922T15:30:00',
            },
            0
        ],
        result => sub {
            my ($som) = @_;
            my $result = $som->result;
            MT::Entry->driver->Disabled(1)
                if MT::Entry->driver->isa(
                'Data::ObjectDriver::Driver::BaseCache');
            my $entry = MT::Entry->load(3);
            MT::Entry->driver->Disabled(0)
                if MT::Entry->driver->isa(
                'Data::ObjectDriver::Driver::BaseCache');
            is( $entry->title,                 'Title' );
            is( $entry->text,                  'Description' );
            is( $entry->convert_breaks,        'wiki' );
            is( $entry->allow_comments,        1 );
            is( $entry->allow_pings,           1 );
            is( $entry->excerpt,               'Excerpt' );
            is( $entry->text_more,             'Extended Entry' );
            is( $entry->keywords,              'Keywords' );
            is( $entry->to_ping_urls,          'http://127.0.0.1/' );
            is( $entry->to_ping_url_list->[0], 'http://127.0.0.1/' );
            is( $entry->authored_on,           '19770922153000' );
        },
    },
    {   api    => 'metaWeblog.editPost',
        params => [
            sub {
                my $e = MT::Entry->load( { blog_id => 2 },
                    { sort => 'id', direction => 'descend' } );
                $e->id;
            },
            $username,
            $password,
            {   title             => 'Title',
                description       => 'Description',
                mt_convert_breaks => 'wiki',
                mt_allow_comments => 1,
                mt_allow_pings    => 1,
                mt_excerpt        => 'Excerpt',
                mt_text_more      => 'Extended Entry',
                mt_keywords       => 'Keywords',
                mt_tb_ping_urls   => ['http://127.0.0.1/'],
                dateCreated       => '19770922T15:30:00',
            },
            0
        ],
        pre => sub {
            my $e = MT::Entry->load( { blog_id => 2 },
                { sort => 'id', direction => 'descend' } );
            return $e;
        },
        result => sub {
            my ( $som, $e ) = @_;
            my $result = $som->result;
            MT::Entry->driver->Disabled(1)
                if MT::Entry->driver->isa(
                'Data::ObjectDriver::Driver::BaseCache');
            my $entry = MT::Entry->load( $e->id );
            MT::Entry->driver->Disabled(0)
                if MT::Entry->driver->isa(
                'Data::ObjectDriver::Driver::BaseCache');
            is( $entry->title,                 'Title' );
            is( $entry->text,                  'Description' );
            is( $entry->convert_breaks,        'wiki' );
            is( $entry->allow_comments,        1 );
            is( $entry->allow_pings,           1 );
            is( $entry->excerpt,               'Excerpt' );
            is( $entry->text_more,             'Extended Entry' );
            is( $entry->keywords,              'Keywords' );
            is( $entry->to_ping_urls,          'http://127.0.0.1/' );
            is( $entry->to_ping_url_list->[0], 'http://127.0.0.1/' );
            is( $entry->authored_on,           '19770922153000' );
        },
    },
    {   api    => 'metaWeblog.editPost',
        params => [
            3,
            $username,
            $password,
            {   mt_convert_breaks => '',
                mt_allow_comments => 2,
                mt_excerpt        => '',
                mt_text_more      => '',
            },
            0
        ],
        result => sub {
            my ($som) = @_;
            my $result = $som->result;
        },
    },
    {   api    => 'metaWeblog.editPost',
        params => [
            1,
            $username,
            $password,
            {   categories => [
                    map { $mt->model('category')->load($_)->label } qw(1 2)
                ],
            },
            1
        ],
        pre => sub {
            my $blog     = $mt->model('blog')->load(1);
            my $file_mgr = $blog->file_mgr;

            my @cats = $mt->model('category')->load( { id => [qw(1 2)] } );
            my $files_to_publish = [
                map {
                    File::Spec->catfile( $blog->archive_path,
                        archive_file_for( undef, $blog, 'Category', $_ ) );
                } @cats
            ];
            foreach my $f (@$files_to_publish) {
                $file_mgr->delete($f);
            }
            return $files_to_publish;
        },
        result => sub {
            my ( $som, $files_to_publish ) = @_;
            my $file_mgr = $mt->model('blog')->load(1)->file_mgr;

            foreach my $f (@$files_to_publish) {
                ok( $file_mgr->exists($f), 'Published:' . $f );
            }
        },
    },
    {   api    => 'metaWeblog.editPost',
        params => [
            1,
            $username,
            $password,
            {   categories =>
                    [ map { $mt->model('category')->load($_)->label } qw(1) ],
            },
            1
        ],
        pre => sub {
            my $blog     = $mt->model('blog')->load(1);
            my $file_mgr = $blog->file_mgr;
            my $entry    = $mt->model('entry')->load(1);
            $entry->clear_cache('categories');

            my @cats = grep {
                MT::Object::clear_cache( $_, 'entry_count' );
                $_->entry_count == 1;
            } @{ $entry->categories };

            my $files_to_delete = [
                map {
                    File::Spec->catfile( $blog->archive_path,
                        archive_file_for( undef, $blog, 'Category', $_ ) );
                } @cats
            ];
            foreach my $f (@$files_to_delete) {
                $file_mgr->mkpath( dirname($f) );
                $file_mgr->put_data( 1, $f );
            }
            CORE::sleep(1);
            return $files_to_delete;
        },
        result => sub {
            my ( $som, $files_to_delete ) = @_;
            my $file_mgr = $mt->model('blog')->load(1)->file_mgr;

            foreach my $f (@$files_to_delete) {
                ok( !$file_mgr->exists($f), 'Deleted:' . $f );
            }
        },
    },
    {   api    => 'mt.getCategoryList',
        params => [ 1, $username, $password ],
        result => sub {
            my ($som)  = @_;
            my $result = $som->result;
            my $cat1   = MT::Category->load(1);
            my $cat2   = MT::Category->load(2);
            is( $result->[0]->{categoryId},   $cat1->id );
            is( $result->[0]->{categoryName}, $cat1->label );
            is( $result->[1]->{categoryId},   $cat2->id );
            is( $result->[1]->{categoryName}, $cat2->label );
        },
    },
    {   api    => 'mt.getCategoryList',
        params => [ 2, $username, $password ],
        pre    => sub {
            while ( MT::Category->count( { blog_id => 2 } ) < 2 ) {
                MT::Test::Permission->make_category( blog_id => 2 );
            }
        },
        result => sub {
            my ($som) = @_;
            my $result = $som->result;
            my @cats = MT::Category->load( { blog_id => 2 } );
            ok( scalar(@cats) );
            ok( scalar(@$result) );
            is( scalar(@cats), scalar(@$result) );

            my $cnt = 0;
            foreach my $cat (@cats) {
                is( $result->[$cnt]->{categoryId},   $cat->id );
                is( $result->[$cnt]->{categoryName}, $cat->label );
                $cnt++;
            }
        },
    },
    {   api    => 'mt.getPostCategories',
        params => [ 3, $username, $password ],
        result => sub {
            my ($som) = @_;
            my $result = $som->result;
            is( scalar @{ $som->result }, 0 );
        },
    },
    {   api    => 'mt.getPostCategories',
        params => [
            sub {
                my $e = MT::Entry->load( { blog_id => 2 },
                    { sort => 'id', direction => 'descend' } );
                $e->id;
            },
            $username,
            $password
        ],
        result => sub {
            my ($som) = @_;
            my $result = $som->result;
            is( scalar @{ $som->result }, 0 );
        },
    },
    {   api    => 'mt.setPostCategories',
        params => [ 3, $username, $password, [ { categoryId => 1 } ] ],
        result => sub {
            my ($som) = @_;
            my $result = $som->result;
            MT::Entry->driver->Disabled(1)
                if MT::Entry->driver->isa(
                'Data::ObjectDriver::Driver::BaseCache');
            my $entry = MT::Entry->load(3);
            MT::Entry->driver->Disabled(0)
                if MT::Entry->driver->isa(
                'Data::ObjectDriver::Driver::BaseCache');
            my $cat1 = MT::Category->load(1);
            my $cats = $entry->categories;
            is( scalar @$cats,           1 );
            is( $cats->[0]->label,       $cat1->label );
            is( $entry->category->label, $cat1->label );
        },
    },
    {   api    => 'mt.setPostCategories',
        params => [
            sub {
                my $e = MT::Entry->load( { blog_id => 2 },
                    { sort => 'id', direction => 'descend' } );
                $e->id;
            },
            $username,
            $password,
            sub {
                my $c = MT::Category->load( { blog_id => 2 },
                    { sort => 'id', direction => 'descend' } );
                [ { categoryId => $c->id } ];
            },
        ],
        result => sub {
            my ($som) = @_;
            my $result = $som->result;
            MT::Entry->driver->Disabled(1)
                if MT::Entry->driver->isa(
                'Data::ObjectDriver::Driver::BaseCache');
            my $entry = MT::Entry->load( { blog_id => 2 },
                { sort => 'id', direction => 'descend' } );
            MT::Entry->driver->Disabled(0)
                if MT::Entry->driver->isa(
                'Data::ObjectDriver::Driver::BaseCache');
            my $cat1 = MT::Category->load( { blog_id => 2 },
                { sort => 'id', direction => 'descend' } );
            my $cats = $entry->categories;
            is( scalar @$cats,           1 );
            is( $cats->[0]->label,       $cat1->label );
            is( $entry->category->label, $cat1->label );
        },
    },
    {   api    => 'mt.setPostCategories',
        params => [
            3,
            $username,
            $password,
            [   { categoryId => 1, isPrimary => 1 },
                { categoryId => 2, isPrimary => 0 },
            ]
        ],
        pre => sub {
            my $r = MT->request;
            my $oc = $r->cache( 'object_cache', {} );
        },
        result => sub {
            my ($som) = @_;
            my $result = $som->result;
            MT::Entry->driver->Disabled(1)
                if MT::Entry->driver->isa(
                'Data::ObjectDriver::Driver::BaseCache');
            my $entry = MT::Entry->load(3);
            MT::Entry->driver->Disabled(0)
                if MT::Entry->driver->isa(
                'Data::ObjectDriver::Driver::BaseCache');
            my $cat1 = MT::Category->load(1);
            my $cats = $entry->categories;
            is( scalar @$cats,           2 );
            is( $entry->category->label, $cat1->label );
        },
    },
    {   api    => 'mt.setPostCategories',
        params => [
            sub {
                my $e = MT::Entry->load( { blog_id => 2 },
                    { sort => 'id', direction => 'descend' } );
                $e->id;
            },
            $username,
            $password,
            sub {
                my @c = MT::Category->load( { blog_id => 2 },
                    { sort => 'id', direction => 'descend', limit => 2 } );
                [   { categoryId => $c[0]->id, isPrimary => 1 },
                    { categoryId => $c[1]->id, isPrimary => 0 }
                ];
            },
        ],
        pre => sub {
            my $r = MT->request;
            my $oc = $r->cache( 'object_cache', {} );
        },
        result => sub {
            my ($som) = @_;
            my $result = $som->result;
            MT::Entry->driver->Disabled(1)
                if MT::Entry->driver->isa(
                'Data::ObjectDriver::Driver::BaseCache');
            my $entry = MT::Entry->load( { blog_id => 2 },
                { sort => 'id', direction => 'descend' } );
            MT::Entry->driver->Disabled(0)
                if MT::Entry->driver->isa(
                'Data::ObjectDriver::Driver::BaseCache');
            my $cat1 = MT::Category->load( { blog_id => 2 },
                { sort => 'id', direction => 'descend' } );
            my $cats = $entry->categories;
            is( scalar @$cats,           2 );
            is( $entry->category->label, $cat1->label );
        },
    },
    {   api    => 'mt.setPostCategories',
        params => [
            3,
            $username,
            $password,
            [   { categoryId => 1, isPrimary => 0 },
                { categoryId => 2, isPrimary => 1 },
            ]
        ],
        pre => sub {
            my $r = MT->request;
            my $oc = $r->cache( 'object_cache', {} );
        },
        result => sub {
            my ($som) = @_;
            my $result = $som->result;
            MT::Entry->driver->Disabled(1)
                if MT::Entry->driver->isa(
                'Data::ObjectDriver::Driver::BaseCache');
            my $entry = MT::Entry->load(3);
            MT::Entry->driver->Disabled(0)
                if MT::Entry->driver->isa(
                'Data::ObjectDriver::Driver::BaseCache');
            my $cat2 = MT::Category->load(2);
            my $cats = $entry->categories;
            is( scalar @$cats,           2 );
            is( $entry->category->label, $cat2->label );
        },
    },
    {   api    => 'mt.setPostCategories',
        params => [
            sub {
                my $e = MT::Entry->load( { blog_id => 2 },
                    { sort => 'id', direction => 'descend' } );
                $e->id;
            },
            $username,
            $password,
            sub {
                my @c = MT::Category->load( { blog_id => 2 },
                    { sort => 'id', direction => 'descend', limit => 2 } );
                [   { categoryId => $c[0]->id, isPrimary => 0 },
                    { categoryId => $c[1]->id, isPrimary => 1 }
                ];
            },
        ],
        pre => sub {
            my $r = MT->request;
            my $oc = $r->cache( 'object_cache', {} );
        },
        result => sub {
            my ($som) = @_;
            my $result = $som->result;
            MT::Entry->driver->Disabled(1)
                if MT::Entry->driver->isa(
                'Data::ObjectDriver::Driver::BaseCache');
            my $entry = MT::Entry->load( { blog_id => 2 },
                { sort => 'id', direction => 'descend' } );
            MT::Entry->driver->Disabled(0)
                if MT::Entry->driver->isa(
                'Data::ObjectDriver::Driver::BaseCache');
            my @cat = MT::Category->load( { blog_id => 2 },
                { sort => 'id', direction => 'descend', limit => 2 } );
            my $cats = $entry->categories;
            is( scalar @$cats,           2 );
            is( $entry->category->label, $cat[1]->label );
        },
    },
    {   api    => 'mt.setPostCategories',
        params => [ 3, $username, $password, [] ],
        pre    => sub {
            my $r = MT->request;
            my $oc = $r->cache( 'object_cache', {} );
        },
        result => sub {
            my ($som) = @_;
            my $result = $som->result;
            MT::Entry->driver->Disabled(1)
                if MT::Entry->driver->isa(
                'Data::ObjectDriver::Driver::BaseCache');
            my $entry = MT::Entry->load(3);
            MT::Entry->driver->Disabled(0)
                if MT::Entry->driver->isa(
                'Data::ObjectDriver::Driver::BaseCache');
            my $cats = $entry->categories;
            is( scalar @$cats, 0 );
            ok( !$entry->category );
        },
    },
    {   api    => 'mt.setPostCategories',
        params => [
            sub {
                my $e = MT::Entry->load( { blog_id => 2 },
                    { sort => 'id', direction => 'descend' } );
                $e->id;
            },
            $username,
            $password,
            []
        ],
        pre => sub {
            my $r = MT->request;
            my $oc = $r->cache( 'object_cache', {} );
        },
        result => sub {
            my ($som) = @_;
            my $result = $som->result;
            MT::Entry->driver->Disabled(1)
                if MT::Entry->driver->isa(
                'Data::ObjectDriver::Driver::BaseCache');
            my $entry = MT::Entry->load( { blog_id => 2 },
                { sort => 'id', direction => 'descend' } );
            MT::Entry->driver->Disabled(0)
                if MT::Entry->driver->isa(
                'Data::ObjectDriver::Driver::BaseCache');
            my $cats = $entry->categories;
            is( scalar @$cats, 0 );
            ok( !$entry->category );
        },
    },
    {   api    => 'mt.setPostCategories',
        params => [
            1,
            $username,
            $password,
            [   { categoryId => 1, isPrimary => 0 },
                { categoryId => 2, isPrimary => 1 },
            ]
        ],
        pre => sub {
            my $blog     = $mt->model('blog')->load(1);
            my $file_mgr = $blog->file_mgr;

            my @cats = $mt->model('category')->load( { id => [qw(1 2)] } );
            my $files_to_publish = [
                map {
                    File::Spec->catfile( $blog->archive_path,
                        archive_file_for( undef, $blog, 'Category', $_ ) );
                } @cats
            ];
            foreach my $f (@$files_to_publish) {
                $file_mgr->delete($f);
            }
            return $files_to_publish;
        },
        result => sub {
            my ( $som, $files_to_publish ) = @_;
            my $file_mgr = $mt->model('blog')->load(1)->file_mgr;

            foreach my $f (@$files_to_publish) {
                ok( $file_mgr->exists($f), 'Published:' . $f );
            }
        },
    },
    {   api    => 'mt.setPostCategories',
        params => [ 1, $username, $password, [] ],
        pre    => sub {
            my $blog     = $mt->model('blog')->load(1);
            my $file_mgr = $blog->file_mgr;
            my $entry    = $mt->model('entry')->load(1);
            $entry->clear_cache('categories');

            my @cats = grep {
                MT::Object::clear_cache( $_, 'entry_count' );
                $_->entry_count == 1;
            } @{ $entry->categories };

            my $files_to_delete = [
                map {
                    File::Spec->catfile( $blog->archive_path,
                        archive_file_for( undef, $blog, 'Category', $_ ) );
                } @cats
            ];
            foreach my $f (@$files_to_delete) {
                $file_mgr->mkpath( dirname($f) );
                $file_mgr->put_data( 1, $f );
            }
            CORE::sleep(1);
            return $files_to_delete;
        },
        result => sub {
            my ( $som, $files_to_delete ) = @_;
            my $file_mgr = $mt->model('blog')->load(1)->file_mgr;

            foreach my $f (@$files_to_delete) {
                ok( !$file_mgr->exists($f), 'Deleted:' . $f );
            }
        },
    },
    {   api    => 'blogger.newPost',
        params => [ '', 1, $username, $password, 'This is a new post.', 0 ],
        result => sub {
            my ($som)  = @_;
            my $result = $som->result;
            my $entry  = MT::Entry->load($result);
            ok($entry);
            is( $entry->blog_id, 1 );
            is( $entry->text,    'This is a new post.' );

            # RELEASE unless NoPublishMeansDraft
            is( $entry->status, MT::Entry::RELEASE() );
        },
    },
    {   api    => 'blogger.newPost',
        params => [ '', 2, $username, $password, 'This is a new post.', 0 ]
        ,    # website
        result => sub {
            my ($som)  = @_;
            my $result = $som->result;
            my $entry  = MT::Entry->load($result);
            ok($entry);
            is( $entry->blog_id, 2 );
            is( $entry->text,    'This is a new post.' );

            # RELEASE unless NoPublishMeansDraft
            is( $entry->status, MT::Entry::RELEASE() );
        },
    },
    {   api    => 'metaWeblog.newPost',
        params => [
            1,
            $username,
            $password,
            {   title       => 'MetaWeblog Post',
                description => 'This is a new post via metaWeblog API.'
            },
            1
        ],
        result => sub {
            my ($som)  = @_;
            my $result = $som->result;
            my $entry  = MT::Entry->load($result);
            $new_entry_id = $entry->id;
            ok($entry);
            is( $entry->blog_id, 1 );
            is( $entry->title,   'MetaWeblog Post' );
            is( $entry->text,    'This is a new post via metaWeblog API.' );

            # RELEASE unless NoPublishMeansDraft
            is( $entry->status, MT::Entry::RELEASE() );
        },
    },
    {   api    => 'metaWeblog.newPost',
        params => [
            2,
            $username,
            $password,
            {   title       => 'MetaWeblog Post',
                description => 'This is a new post via metaWeblog API.'
            },
            1
        ],
        result => sub {
            my ($som)  = @_;
            my $result = $som->result;
            my $entry  = MT::Entry->load($result);
            $new_entry_id = $entry->id;
            ok($entry);
            is( $entry->blog_id, 2 );
            is( $entry->title,   'MetaWeblog Post' );
            is( $entry->text,    'This is a new post via metaWeblog API.' );

            # RELEASE unless NoPublishMeansDraft
            is( $entry->status, MT::Entry::RELEASE() );
        },
    },
    {   api    => 'blogger.deletePost',
        params => [
            '',
            sub {
                my $e = MT::Entry->load( undef,
                    { sort => 'id', direction => 'descend', limit => 1 } );
                $e->id;
            },
            $username,
            $password,
            0
        ],
        pre => sub {
            my ($e1)
                = MT::Entry->load( undef,
                { sort => 'id', direction => 'descend', limit => 1 } );
            return $e1;
        },
        result => sub {
            my ( $som, $data ) = @_;
            my $result = $som->result;
            MT::Entry->driver->Disabled(1)
                if MT::Entry->driver->isa(
                'Data::ObjectDriver::Driver::BaseCache');
            my $entry = MT::Entry->load( $data->id );
            is( $entry, undef );
            MT::Entry->driver->Disabled(0)
                if MT::Entry->driver->isa(
                'Data::ObjectDriver::Driver::BaseCache');
        },
    },
    {   api    => 'blogger.deletePost',
        params => [
            '',
            sub {
                my $e = MT::Entry->load( { blog_id => 2 },
                    { sort => 'id', direction => 'descend', limit => 1 } );
                $e->id;
            },
            $username,
            $password,
            0
        ],
        pre => sub {
            my ($e1) = MT::Entry->load( { blog_id => 2 },
                { sort => 'id', direction => 'descend', limit => 1 } );
            if ( !$e1 ) {
                $e1 = MT::Test::Permission->make_entry( blog_id => 2, );
            }
            return $e1;
        },
        result => sub {
            my ( $som, $data ) = @_;
            my $result = $som->result;
            MT::Entry->driver->Disabled(1)
                if MT::Entry->driver->isa(
                'Data::ObjectDriver::Driver::BaseCache');
            my $entry = MT::Entry->load( $data->id );
            is( $entry, undef );
            MT::Entry->driver->Disabled(0)
                if MT::Entry->driver->isa(
                'Data::ObjectDriver::Driver::BaseCache');
        },
    },
    {   api    => 'metaWeblog.getPost',
        params => [
            sub {
                my $e = MT::Entry->load( { blog_id => 1 },
                    { sort => 'id', direction => 'descend', limit => 1 } );
                $e->id;
            },
            $username,
            $password
        ],
        pre => sub {
            my ($e2) = MT::Entry->load( { blog_id => 1 },
                { sort => 'id', direction => 'descend', limit => 1 } );
            return $e2;
        },
        result => sub {
            my ( $som, $e ) = @_;
            my $result = $som->result;
            my $entry  = MT::Entry->load( $e->id );
            ok($entry);
            is( $entry->permalink, $result->{permaLink} );
            is( $entry->basename,  $result->{mt_basename} );
            is( $entry->text,      $result->{description} );
        },
    },
    {   api    => 'metaWeblog.getPost',
        params => [
            sub {
                my $e = MT::Entry->load( { blog_id => 2 },
                    { sort => 'id', direction => 'descend', limit => 1 } );
                $e->id;
            },
            $username,
            $password
        ],
        pre => sub {
            my ($e2) = MT::Test::Permission->make_entry( blog_id => 2, );
            return $e2;
        },
        result => sub {
            my ( $som, $e ) = @_;
            my $result = $som->result;
            my $entry  = MT::Entry->load( $e->id );
            MT::Request->instance->cache( 'file', {} );
            ok($entry);
            is( $entry->permalink, $result->{permaLink} );
            is( $entry->basename,  $result->{mt_basename} );
            is( $entry->text,      $result->{description} );
        },
    },
    {   api    => 'metaWeblog.deletePost',
        params => [
            '',
            sub {
                my $e = MT::Entry->load( { blog_id => 1 },
                    { sort => 'id', direction => 'descend', limit => 1 } );
                $e->id;
            },
            $username,
            $password,
            0
        ],
        pre => sub {
            my ($e2) = MT::Entry->load( { blog_id => 1 },
                { sort => 'id', direction => 'descend', limit => 1 } );
            return $e2;
        },
        result => sub {
            my ( $som, $data ) = @_;
            my $result = $som->result;
            MT::Entry->driver->Disabled(1)
                if MT::Entry->driver->isa(
                'Data::ObjectDriver::Driver::BaseCache');
            my $entry = MT::Entry->load( $data->id );
            is( $entry, undef );
            MT::Entry->driver->Disabled(0)
                if MT::Entry->driver->isa(
                'Data::ObjectDriver::Driver::BaseCache');
        },
    },
    {   api    => 'metaWeblog.deletePost',
        params => [
            '',
            sub {
                my $e = MT::Entry->load( { blog_id => 2 },
                    { sort => 'id', direction => 'descend', limit => 1 } );
                $e->id;
            },
            $username,
            $password,
            0
        ],
        pre => sub {
            my ($e2) = MT::Entry->load( { blog_id => 2 },
                { sort => 'id', direction => 'descend', limit => 1 } );
            return $e2;
        },
        result => sub {
            my ( $som, $data ) = @_;
            my $result = $som->result;
            MT::Entry->driver->Disabled(1)
                if MT::Entry->driver->isa(
                'Data::ObjectDriver::Driver::BaseCache');
            my $entry = MT::Entry->load( $data->id );
            is( $entry, undef );
            MT::Entry->driver->Disabled(0)
                if MT::Entry->driver->isa(
                'Data::ObjectDriver::Driver::BaseCache');
        },
    },
    {   api    => 'metaWeblog.newMediaObject',
        params => [
            1,
            $username,
            $password,
            {   name => 'movable-type-logo.gif',
                type => 'image/gif',
                bits => sub {
                    return MIME::Base64::decode_base64($logo);
                },
            }
        ],
        result => sub {
            my ($som)  = @_;
            my $result = $som->result;
            my $url    = $result->{url};
            is( $url, 'http://narnia.na/nana/movable-type-logo.gif' );
            my $asset = MT::Asset::Image->load( { blog_id => 1 },
                { sort => 'id', direction => 'descend', limit => 1 } );
            ok( $asset, 'asset loaded' );
            is( $asset->mime_type, 'image/gif' );
            is( $asset->file_name, 'movable-type-logo.gif' );
            local $/;
            open my $fh, '<', $asset->file_path;
            my $image = <$fh>;
            close $fh;
            require MIME::Base64;
            is( $logo, MIME::Base64::encode_base64( $image, '' ) );
        },
        post => sub {
            my $asset = MT::Asset->load( { blog_id => 1 },
                { sort => 'id', direction => 'descend', limit => 1 } );
            $asset->remove();
        }
    },
    {   api    => 'metaWeblog.newMediaObject',
        params => [
            2,
            $username,
            $password,
            {   name => 'movable-type-logo.gif',
                type => 'image/gif',
                bits => sub {
                    return MIME::Base64::decode_base64($logo);
                },
            }
        ],
        result => sub {
            my ($som)  = @_;
            my $result = $som->result;
            my $url    = $result->{url};
            is( $url, 'http://narnia.na/movable-type-logo.gif' );
            my $asset = MT::Asset::Image->load( { blog_id => 2 },
                { sort => 'id', direction => 'descend', limit => 1 } );
            ok( $asset, 'asset loaded' );
            is( $asset->mime_type, 'image/gif' );
            is( $asset->file_name, 'movable-type-logo.gif' );
            local $/;
            open my $fh, '<', $asset->file_path;
            my $image = <$fh>;
            close $fh;
            require MIME::Base64;
            is( $logo, MIME::Base64::encode_base64( $image, '' ) );
        },
        post => sub {
            my $asset = MT::Asset::Image->load( { blog_id => 2 },
                { sort => 'id', direction => 'descend', limit => 1 } );
            $asset->remove();
        }
    },
    {   api    => 'metaWeblog.getCategories',
        params => [ 1, $username, $password ],
        result => sub {
            my ($som) = @_;
            my $result = $som->result;
            my @cats = MT::Category->load( { blog_id => 1 } );
            for ( my $i = 0; $i <= $#cats; ++$i ) {
                is( $cats[$i]->id,          $result->[$i]->{categoryId} );
                is( $cats[$i]->label,       $result->[$i]->{categoryName} );
                is( $cats[$i]->description, $result->[$i]->{description} );
                if ( my $parent = $cats[$i]->parent_category ) {
                    is( $parent->id, $result->[$i]->{parentId} );
                }
                else {
                    ok( !( $result->[$i]->{parentId} ) );
                }
            }
            is( scalar(@$result), scalar(@cats) );
            is( scalar(@$result), 3 );
            is( scalar(@cats),    3 );
        },
    },
    {   api    => 'metaWeblog.getCategories',
        params => [ 2, $username, $password ],
        pre    => sub {
            while ( MT::Category->count( { blog_id => 2 } ) < 2 ) {
                MT::Test::Permission->make_category( blog_id => 2, );
            }
        },
        result => sub {
            my ($som) = @_;
            my $result = $som->result;
            my @cats = MT::Category->load( { blog_id => 2 } );
            for ( my $i = 0; $i <= $#cats; ++$i ) {
                is( $cats[$i]->id,          $result->[$i]->{categoryId} );
                is( $cats[$i]->label,       $result->[$i]->{categoryName} );
                is( $cats[$i]->description, $result->[$i]->{description} );
                if ( my $parent = $cats[$i]->parent_category ) {
                    is( $parent->id, $result->[$i]->{parentId} );
                }
                else {
                    ok( !( $result->[$i]->{parentId} ) );
                }
            }
            is( scalar(@$result), scalar(@cats) );
            ok( scalar(@$result) );
            ok( scalar(@cats) );
        },
    },
    {   api    => 'mt.getTrackbackPings',
        params => [ 1, $username, $password ],
        result => sub {
            my ($som)  = @_;
            my $result = $som->result;
            my @pings  = MT::TBPing->load(
                undef,
                {   'join' => MT::Trackback->join_on(
                        undef,
                        { id => \'= tbping_tb_id', },
                        {   'join' => MT::Entry->join_on(
                                undef,
                                {   id    => \'= trackback_entry_id',
                                    class => 'entry',
                                }
                            )
                        }
                    )
                }
            );
            for ( my $i = 0; $i <= $#pings; ++$i ) {
                is( $pings[$i]->ip,         $result->[$i]->{pingIP} );
                is( $pings[$i]->source_url, $result->[$i]->{pingURL} );
                is( $pings[$i]->title,      $result->[$i]->{pingTitle} );
            }
            is( scalar(@$result), scalar(@pings) );
        },
    },
    {   api => 'mt.getTrackbackPings',
        pre => sub {
            my $e = MT::Entry->load( { blog_id => 2 },
                { sort => 'id', direction => 'descend' } );
            my $tb = MT::Trackback->load(
                { blog_id => 2,    entry_id  => $e->id },
                { sort    => 'id', direction => 'descend' }
            );
            MT::Test::Permission->make_ping( blog_id => 2, tb_id => $tb->id );
        },
        params => [
            sub {
                my $e = MT::Entry->load( { blog_id => 2 },
                    { sort => 'id', direction => 'descend' } );
                $e->id;
            },
            $username,
            $password
        ],
        result => sub {
            my ($som)  = @_;
            my $result = $som->result;
            my @pings  = MT::TBPing->load(
                { blog_id => 2 },
                {   'join' => MT::Trackback->join_on(
                        undef,
                        { id => \'= tbping_tb_id', },
                        {   'join' => MT::Entry->join_on(
                                undef,
                                {   id    => \'= trackback_entry_id',
                                    class => 'entry',
                                }
                            )
                        }
                    )
                }
            );
            for ( my $i = 0; $i <= $#pings; ++$i ) {
                is( $pings[$i]->ip,         $result->[$i]->{pingIP} );
                is( $pings[$i]->source_url, $result->[$i]->{pingURL} );
                is( $pings[$i]->title,      $result->[$i]->{pingTitle} );
            }
            is( scalar(@$result), scalar(@pings) );
            ok( scalar(@pings) );
        },
    },
    {   api    => 'mt.supportedTextFilters',
        params => [ $username, $password ],
        result => sub {
            my ($som)  = @_;
            my $result = $som->result;
            my %tf     = (
                '__default__'               => 1,
                'richtext'                  => 1,
                'markdown'                  => 1,
                'markdown_with_smartypants' => 1,
                'textile_2'                 => 1,
                'blockeditor'               => 1,
            );

            # __sanitize__ may come from the community pack
            @$result = grep { $_->{key} ne '__sanitize__' } @$result;
            foreach my $res ( sort @$result ) {
                is( 1, delete( $tf{ $res->{key} } ), $res->{key} );
            }
            ok( !%tf );
        },
    },
    {   api    => 'mt.getTagList',
        params => [ 1, $username, $password ],
        result => sub {
            my ($som)  = @_;
            my $result = $som->result;
            my @tags   = MT::Tag->load(
                undef,
                {   'join' => MT::ObjectTag->join_on(
                        undef,
                        {   tag_id  => \'= tag_id',    # baka editors ',
                            blog_id => 1
                        },
                        { unique => 1 }
                    )
                }
            );
            for ( my $i = 0; $i <= $#tags; ++$i ) {
                is( $tags[$i]->id,   $result->[$i]->{tagId} );
                is( $tags[$i]->name, $result->[$i]->{tagName} );
            }
            is( scalar(@$result), scalar(@tags) );
        },
    },
    {   api => 'mt.getTagList',
        pre => sub {
            my $tag = MT::Test::Permission->make_tag();
            MT::Test::Permission->make_objecttag(
                blog_id => 2,
                tag_id  => $tag->id,
            );
        },
        params => [ 2, $username, $password ],
        result => sub {
            my ($som)  = @_;
            my $result = $som->result;
            my @tags   = MT::Tag->load(
                undef,
                {   'join' => MT::ObjectTag->join_on(
                        undef,
                        {   tag_id  => \'= tag_id',    # baka editors ',
                            blog_id => 2
                        },
                        { unique => 1 }
                    )
                }
            );
            for ( my $i = 0; $i <= $#tags; ++$i ) {
                is( $tags[$i]->id,   $result->[$i]->{tagId} );
                is( $tags[$i]->name, $result->[$i]->{tagName} );
            }
            is( scalar(@$result), scalar(@tags) );
            ok( scalar(@tags) );
        },
    },
    {   api    => 'wp.newPage',
        params => [
            1,
            $username,
            $password,
            {   title       => 'Page title in blog',
                description => 'This is a new page in blog.',
            },
            1
        ],
        result => sub {
            my ($som) = @_;
            my $result = $som->result;
            ok($result);
            my $page = MT::Page->load($result);
            ok($page);
            is( $page->class,   'page' );
            is( $page->blog_id, 1 );
            is( $page->title,   'Page title in blog' );
            is( $page->text,    'This is a new page in blog.' );
            is( $page->status,  MT::Entry::RELEASE() );
        },
    },
    {   api    => 'wp.newPage',
        params => [
            2,
            $username,
            $password,
            {   title       => 'Page title in website',
                description => 'This is a new page in website.',
            },
            1
        ],
        result => sub {
            my ($som) = @_;
            my $result = $som->result;
            ok($result);
            my $page = MT::Page->load($result);
            ok($page);
            is( $page->class,   'page' );
            is( $page->blog_id, 2 );
            is( $page->title,   'Page title in website' );
            is( $page->text,    'This is a new page in website.' );
            is( $page->status,  MT::Entry::RELEASE() );
        },
    },
    {   api    => 'wp.getPages',
        params => [ 1, $username, $password ],
        result => sub {
            my ($som) = @_;
            my $result = $som->result;
            ok($result);

            my @pages = MT::Page->load( { blog_id => 1 },
                { sort => 'authored_on', direction => 'descend' } );
            ok( scalar(@$result) );
            ok( scalar(@pages) );
            is( scalar(@$result), scalar(@pages) );

            my $cnt = 0;
            foreach my $r (@$result) {
                is( $r->{userid},  $pages[$cnt]->author_id );
                is( $r->{page_id}, $pages[$cnt]->id );
                my $ao = sprintf "%04d%02d%02dT%02d:%02d:%02d",
                    unpack 'A4A2A2A2A2A2', $pages[$cnt]->authored_on;
                is( $r->{dateCreated}, $ao );
                is( $r->{description}, $pages[$cnt]->text );

                $cnt++;
            }
        },
    },
    {   api    => 'wp.getPages',
        params => [ 2, $username, $password ],
        result => sub {
            my ($som) = @_;
            my $result = $som->result;
            ok($result);

            my @pages = MT::Page->load( { blog_id => 2 },
                { sort => 'authored_on', direction => 'descend' } );
            ok( scalar(@$result) );
            ok( scalar(@pages) );
            is( scalar(@$result), scalar(@pages) );

            my $cnt = 0;
            foreach my $r (@$result) {
                is( $r->{userid},  $pages[$cnt]->author_id );
                is( $r->{page_id}, $pages[$cnt]->id );
                my $ao = sprintf "%04d%02d%02dT%02d:%02d:%02d",
                    unpack 'A4A2A2A2A2A2', $pages[$cnt]->authored_on;
                is( $r->{dateCreated}, $ao );
                is( $r->{description}, $pages[$cnt]->text );

                $cnt++;
            }
        },
    },
    {   api    => 'wp.getPage',
        params => [
            1,
            sub {
                my $p = MT::Page->load( { blog_id => 1 },
                    { sort => 'id', direction => 'descend' } );
                $p->id;
            },
            $username,
            $password
        ],
        result => sub {
            my ($som) = @_;
            my $result = $som->result;
            ok($result);

            my $page = MT::Page->load( { blog_id => 1 },
                { sort => 'id', direction => 'descend' } );
            ok($page);
            is( $result->{userid},  $page->author_id );
            is( $result->{page_id}, $page->id );
            my $ao = sprintf "%04d%02d%02dT%02d:%02d:%02d",
                unpack 'A4A2A2A2A2A2', $page->authored_on;
            is( $result->{dateCreated}, $ao );
            is( $result->{description}, $page->text );
        },
    },
    {   api    => 'wp.getPage',
        params => [
            2,
            sub {
                my $p = MT::Page->load( { blog_id => 2 },
                    { sort => 'id', direction => 'descend' } );
                $p->id;
            },
            $username,
            $password
        ],
        result => sub {
            my ($som) = @_;
            my $result = $som->result;
            ok($result);

            my $page = MT::Page->load( { blog_id => 2 },
                { sort => 'id', direction => 'descend' } );
            ok($page);
            is( $result->{userid},  $page->author_id );
            is( $result->{page_id}, $page->id );
            my $ao = sprintf "%04d%02d%02dT%02d:%02d:%02d",
                unpack 'A4A2A2A2A2A2', $page->authored_on;
            is( $result->{dateCreated}, $ao );
            is( $result->{description}, $page->text );
        },
    },
    {   api    => 'wp.editPage',
        params => [
            1,
            sub {
                my $p = MT::Page->load( { blog_id => 1 },
                    { sort => 'id', direction => 'descend' } );
                $p->id;
            },
            $username,
            $password,
            {   title             => 'Title',
                description       => 'Description',
                mt_convert_breaks => 'wiki',
                mt_allow_comments => 1,
                mt_allow_pings    => 1,
                mt_excerpt        => 'Excerpt',
                mt_text_more      => 'Extended Entry',
                mt_keywords       => 'Keywords',
                mt_tb_ping_urls   => ['http://127.0.0.1/'],
                dateCreated       => '19770922T15:30:00',
            },
        ],
        result => sub {
            my ($som) = @_;
            my $result = $som->result;
            ok($result);

            MT::Page->driver->Disabled(1)
                if MT::Page->driver->isa(
                'Data::ObjectDriver::Driver::BaseCache');
            my $page = MT::Page->load( { blog_id => 1 },
                { sort => 'id', direction => 'descend' } );
            ok($page);
            MT::Page->driver->Disabled(0)
                if MT::Page->driver->isa(
                'Data::ObjectDriver::Driver::BaseCache');

            is( $page->title,                 'Title' );
            is( $page->text,                  'Description' );
            is( $page->convert_breaks,        'wiki' );
            is( $page->allow_comments,        1 );
            is( $page->allow_pings,           1 );
            is( $page->excerpt,               'Excerpt' );
            is( $page->text_more,             'Extended Entry' );
            is( $page->keywords,              'Keywords' );
            is( $page->to_ping_urls,          'http://127.0.0.1/' );
            is( $page->to_ping_url_list->[0], 'http://127.0.0.1/' );
            is( $page->authored_on,           '19770922153000' );
        },
    },
    {   api    => 'wp.editPage',
        params => [
            2,
            sub {
                my $p = MT::Page->load( { blog_id => 2 },
                    { sort => 'id', direction => 'descend' } );
                $p->id;
            },
            $username,
            $password,
            {   title             => 'Title',
                description       => 'Description',
                mt_convert_breaks => 'wiki',
                mt_allow_comments => 1,
                mt_allow_pings    => 1,
                mt_excerpt        => 'Excerpt',
                mt_text_more      => 'Extended Entry',
                mt_keywords       => 'Keywords',
                mt_tb_ping_urls   => ['http://127.0.0.1/'],
                dateCreated       => '19770922T15:30:00',
            },
        ],
        result => sub {
            my ($som) = @_;
            my $result = $som->result;
            ok($result);

            MT::Page->driver->Disabled(1)
                if MT::Page->driver->isa(
                'Data::ObjectDriver::Driver::BaseCache');
            my $page = MT::Page->load( { blog_id => 2 },
                { sort => 'id', direction => 'descend' } );
            ok($page);
            MT::Page->driver->Disabled(0)
                if MT::Page->driver->isa(
                'Data::ObjectDriver::Driver::BaseCache');

            is( $page->title,                 'Title' );
            is( $page->text,                  'Description' );
            is( $page->convert_breaks,        'wiki' );
            is( $page->allow_comments,        1 );
            is( $page->allow_pings,           1 );
            is( $page->excerpt,               'Excerpt' );
            is( $page->text_more,             'Extended Entry' );
            is( $page->keywords,              'Keywords' );
            is( $page->to_ping_urls,          'http://127.0.0.1/' );
            is( $page->to_ping_url_list->[0], 'http://127.0.0.1/' );
            is( $page->authored_on,           '19770922153000' );
        },
    },
    {   api => 'wp.deletePage',
        pre => sub {
            my $page = MT::Test::Permission->make_page( blog_id => 1, );
            return $page;
        },
        params => [
            1,
            $username,
            $password,
            sub {
                my $p = MT::Page->load( { blog_id => 1 },
                    { sort => 'id', direction => 'descend' } );
                $p->id;
            }
        ],
        result => sub {
            my ( $som, $data ) = @_;
            MT::Page->driver->Disabled(1)
                if MT::Page->driver->isa(
                'Data::ObjectDriver::Driver::BaseCache');
            my $page = MT::Page->load( $data->id );
            MT::Page->driver->Disabled(0)
                if MT::Page->driver->isa(
                'Data::ObjectDriver::Driver::BaseCache');
            is( $page, undef );
        },
    },
    {   api => 'wp.deletePage',
        pre => sub {
            my $page = MT::Test::Permission->make_page( blog_id => 2, );
            return $page;
        },
        params => [
            2,
            $username,
            $password,
            sub {
                my $p = MT::Page->load( { blog_id => 2 },
                    { sort => 'id', direction => 'descend' } );
                $p->id;
            }
        ],
        result => sub {
            my ( $som, $data ) = @_;
            MT::Page->driver->Disabled(1)
                if MT::Page->driver->isa(
                'Data::ObjectDriver::Driver::BaseCache');
            my $page = MT::Page->load( $data->id );
            MT::Page->driver->Disabled(0)
                if MT::Page->driver->isa(
                'Data::ObjectDriver::Driver::BaseCache');
            is( $page, undef );
        },
    },
    {   api => 'mt.publishPost',
        pre => sub {
            my $entry = MT::Entry->load( { blog_id => 1 },
                { sort => 'id', direction => 'descend' } );
            my $blog = $entry->blog;
            my $path = File::Spec->catfile( $blog->archive_path,
                archive_file_for( $entry, $blog, 'Individual' ) );
            my $file_mgr = $blog->file_mgr;
            $file_mgr->delete($path);
            ok( !$file_mgr->exists($path) );
            return [ $file_mgr, $path ];
        },
        params => [
            sub {
                my $e = MT::Entry->load( { blog_id => 1 },
                    { sort => 'id', direction => 'descend' } );
                $e->id;
            },
            $username,
            $password
        ],
        result => sub {
            my ( $som,      $data ) = @_;
            my ( $file_mgr, $path ) = @$data;
            ok( $file_mgr->exists($path) );
        },
    },
    {   api => 'mt.publishPost',
        pre => sub {
            my $entry = MT::Entry->load( { blog_id => 2 },
                { sort => 'id', direction => 'descend' } );
            my $blog = $entry->blog;
            my $path = File::Spec->catfile( $blog->archive_path,
                archive_file_for( $entry, $blog, 'Individual' ) );
            my $file_mgr = $blog->file_mgr;
            $file_mgr->delete($path);
            ok( !$file_mgr->exists($path) );
            return [ $file_mgr, $path ];
        },
        params => [
            sub {
                my $e = MT::Entry->load( { blog_id => 2 },
                    { sort => 'id', direction => 'descend' } );
                $e->id;
            },
            $username,
            $password
        ],
        result => sub {
            my ( $som,      $data ) = @_;
            my ( $file_mgr, $path ) = @$data;
            ok( $file_mgr->exists($path) );
        },
    },
    {   api    => 'blogger.deletePost',
        params => [
            '',
            sub {
                my $page
                    = $mt->model('page')
                    ->load( undef,
                    { sort => 'id', direction => 'descend', limit => 1 } );
                $page->id;
            },
            $username,
            $password,
            0
        ],
        pre => sub {
            my ($page)
                = $mt->model('page')
                ->load( undef,
                { sort => 'id', direction => 'descend', limit => 1 } );
            return $page;
        },
        result => sub {
            my ( $som, $data ) = @_;
            my $result = $som->result;
            MT::Entry->driver->Disabled(1)
                if MT::Entry->driver->isa(
                'Data::ObjectDriver::Driver::BaseCache');
            my $entry = MT::Entry->load( $data->id );
            is( $entry, undef );
            MT::Entry->driver->Disabled(0)
                if MT::Entry->driver->isa(
                'Data::ObjectDriver::Driver::BaseCache');
            my $blog      = $mt->model('blog')->load( $data->blog_id );
            my $file_path = File::Spec->catfile( $blog->archive_path,
                $data->archive_file );
            ok( !$fmgr->exists($file_path), "Remove $file_path" );
        },
    },

    #TODO Add these tests
    # newPost with mt_tags
);

my $uri = new URI();
$uri->path($base_uri);
my $req = new HTTP::Request( POST => $uri );

foreach my $api (@apis) {
    note("test for $api->{api}");
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
    $req->content( $ser->method( $api->{api}, @params ) );

    my $resp = $ua->request($req);

    #    print STDERR $resp->content;
    my $som = $deser->deserialize( $resp->content() );
    $api->{result}->( $som, $data );
    $api->{post}->() if exists $api->{post};
}

done_testing();
1;
__END__
