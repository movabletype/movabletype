use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/lib"; # t/lib
use Test::More;
use MT::Test::Env;
BEGIN {
    eval { require XML::Parser }
        or plan skip_all => 'XML::Parser is not installed';
}

our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use POSIX;

use MT;
use MT::Atom;
use MT::Util;
use XML::LibXML;    # this test would not work without it
use XML::XPath;
use XML::Atom;
use XML::Atom::Feed;
use XML::Atom::Entry;
use POSIX qw( ceil );

# To keep away from being under FastCGI
$ENV{HTTP_HOST} = 'localhost';

my $mt = MT->new or die MT->errstr;
isa_ok( $mt, 'MT' );

use MT::Test qw(:db :data);
use MT::Test::Permission;

my %test_data;
$test_data{'/mt-atom.cgi/weblog'} = <<XML1;
<?xml version="1.0" encoding="utf-8"?>
    <entry xmlns="http://purl.org/atom/ns#" xmlns:dc="http://purl.org/dc/elements/1.1/">
    <title>Fight the Power</title>
    <content>Elvis was a hero to most but he never meant shit to me</content>
    <issued>2004-08-06T00:43:34+01:00</issued>
    </entry>
XML1

#$test_data{'/mt-atom.cgi/1.0'} = <<XML2;
#<?xml version="1.0" encoding="utf-8"?>
#<entry xmlns="http://www.w3.org/2005/Atom">
#<title>Fight the Power</title>
#<content type="html">Elvis was a hero to most but he never meant shit to me</content>
#<published>2004-08-06T00:43:34+01:00</published>
#</entry>
#XML2

my %blog_data = (

    # blog
    1 => {
        title    => 'none',
        blog_url => 'http://narnia.na/nana/',
    },

    # website
    2 => {
        title    => 'Test site',
        blog_url => 'http://narnia.na/',
    },
);

my %feed_link = (
    '/mt-atom.cgi/weblog' => sub {
        my ($resp) = @_;
        my $feed = XML::Atom::Feed->new( \$resp->content() );
        ok( $feed, 'got feed' );
        my @sfeeds = grep { $_->rel eq 'service.feed' } $feed->links;
        [ map { $_->href } @sfeeds ];
    },

  #'/mt-atom.cgi/1.0' => sub {
  #    my ($resp) = @_;
  #    my $feed = XML::XPath->new(xml => $resp->content());
  #    ok($feed, 'got feed');
  #    my $col = $feed->getNodeText('/service/workspace[1]/collection/@href');
  #    $col;
  #}
);

my $username = 'Chuck D';
my $chuck = MT::Author->load( { name => $username } )
    or die "Couldn't load $username";
my $chuck_token = $chuck->api_password;

# create website records
foreach ( 0 .. 2 ) {
    MT::Test::Permission->make_entry( blog_id => 2 );
    MT::Test::Permission->make_category( blog_id => 2 );
}

# not a good nonce-maker
my @hexch = ( '0' .. '9', 'a' .. 'f' );

sub make_nonce {
    join '', map { $hexch[ rand() * @hexch ] } ( 0 .. 7 );
}

sub make_wsse {
    my ($password) = @_;
    my $timestamp      = strftime( "%Y-%m-%dT%H:%M:%SZ", gmtime(time) );
    my $nonce          = make_nonce();
    my $PasswordDigest = sha1_base64( $nonce . $timestamp . $chuck_token );

    # print "# PasswordDigest is sha1('$nonce$timestamp$chuck_token')\n";
    $nonce = MIME::Base64::encode_base64( $nonce, '' );
    return
          "UserNameToken Username=\"$username\", "
        . "PasswordDigest=\"$PasswordDigest\", Nonce=\"$nonce\", "
        . "Created=\"$timestamp\"";
}

require LWP::UserAgent::Local;
my $ua = new LWP::UserAgent::Local( { ScriptAlias => '/' } );

foreach my $base_uri (qw{/mt-atom.cgi/weblog }) {    #/mt-atom.cgi/1.0 } ) {

    # test blog lists
    {
        my $wsse_header = make_wsse($chuck_token);
        my $uri         = new URI;
        $uri->path($base_uri);
        my $req = new HTTP::Request( GET => $uri );
        $req->header( 'Authorization' => 'Atom' );
        $req->header( 'X-WSSE'        => $wsse_header );

        print "# X-WSSE: $wsse_header\n";

        my $resp = $ua->request($req);
        if ( ok( $resp->is_success ) ) {
            my $blog_feed_urls = $feed_link{$base_uri}->($resp);
            is( scalar @$blog_feed_urls, 2 );
            my $blog_feed_uri = new URI( $blog_feed_urls->[0] );
            is( $blog_feed_uri->path,
                '/cgi-bin' . $base_uri . '/blog_id=1',
                'blog feed url is correct'
            );
            my $website_feed_uri = new URI( $blog_feed_urls->[1] );
            is( $website_feed_uri->path,
                '/cgi-bin' . $base_uri . '/blog_id=2',
                'website feed url is correct'
            );
        }
        else {
            die 'failed to retrieve blog feed';
        }
    }

    foreach my $blog_id ( 1, 2 ) {
        {
            # # # # First try a req with baloney auth, make sure it fails
            # TBD: Try more bogus auth varieties
            my $nonce = make_nonce();
            $nonce = MIME::Base64::encode_base64( $nonce, '' );

            my $uri = new URI();
            $uri->path( $base_uri . '/blog_id=' . $blog_id );
            my $req = new HTTP::Request( GET => $uri );
            $req->header( Authentication => 'Atom' );
            $req->header( 'X-WSSE' =>
                    "UserNameToken Username=\"Melody\", PasswordDigest=\"Oj12fART+XZvBZBe39vVvkirg4w\", Nonce=\""
                    . $nonce
                    . "\", Created=\"2004-05-19T20:08:57Z\"" );
            print "# requesting: " . $req->uri . "\n";
            my $resp = $ua->request($req);

            print "# response code was: " . $resp->code . "\n";
            print "# content was: "
                . $resp->content
                . "\n";    # if !$resp->code();
            ok( $resp->is_error() );
        }

        # test blog feed
        {
            my $wsse_header = make_wsse($chuck_token);
            my $uri         = new URI;
            $uri->path( $base_uri . "/blog_id=$blog_id" );
            my $req = new HTTP::Request( GET => $uri );
            $req->header( 'Authorization' => 'Atom' );
            $req->header( 'X-WSSE'        => $wsse_header );

            print "# X-WSSE: $wsse_header\n";

            my $resp = $ua->request($req);
            if ( ok( $resp->is_success ) ) {
                my $feed = XML::Atom::Feed->new( \$resp->content() );
                ok( $feed, 'got feed' );
                is( $feed->title, $blog_data{$blog_id}{title} );
                my ($alternate)
                    = grep { $_->rel eq 'alternate' && $_->type eq 'text/html' }
                    $feed->links;
                is( $alternate->href,
                    $blog_data{$blog_id}{blog_url},
                    'blog url is correct'
                );
                my $entry_count = MT::Entry->count(
                    { blog_id => $blog_id },
                    { limit   => 21 },
                );
                my @entries = $feed->entries;
                ok($entry_count);
                is( $entry_count, scalar(@entries),
                    'number of entries is correct' );

                # check if entries have replies link relation
                my $failed = 0;
                foreach my $entry (@entries) {
                    next
                        if !$entry->id
                        && $entry->title
                        =~ /^I just finished installing Movable Type/;
                    my $mt_entry = MT::Entry->load(
                        {   atom_id => $entry->id,
                            blog_id => $blog_id,
                        }
                    );
                    $failed = 1, last unless $mt_entry;
                    my ($replies)
                        = grep { $_->rel eq 'replies' } $entry->links;
                    $failed = 2, last unless $replies;
                    my $replies_uri = new URI( $replies->href );
                    my $cmt_url
                        = '/mt-atom.cgi/comments/blog_id='
                        . $blog_id
                        . '/entry_id='
                        . $mt_entry->id;
                    $failed = 3, last
                        unless $replies_uri->path =~ m|${cmt_url}$|;
                }
                is( $failed, 0, 'all the entries have replies link rel' );
            }
            else {
                die 'failed to retrieve blog feed';
            }
        }

        # test blog categories feed
        {
            my $wsse_header = make_wsse($chuck_token);
            my $uri         = new URI;
            $uri->path( $base_uri . "/blog_id=$blog_id/svc=categories" );
            my $req = new HTTP::Request( GET => $uri );
            $req->header( 'Authorization' => 'Atom' );
            $req->header( 'X-WSSE'        => $wsse_header );

            print "# X-WSSE: $wsse_header\n";

            my $resp = $ua->request($req);
            if ( ok( $resp->is_success ) ) {

                my $parser = MT::Util::libxml_parser();
                my $doc    = $parser->parse_string( $resp->content );

                my $cats = $doc->getElementsByTagName('categories');
                ok( $cats && @$cats );

                my @subjects = $cats->[0]->getElementsByTagName('subject');
                my @categories
                    = MT::Category->load( { blog_id => $blog_id } );
                ok( scalar @subjects );
                is( scalar @subjects, scalar @categories );

                for ( my $cnt = 0; $cnt < scalar(@subjects); $cnt++ ) {
                    ok( $subjects[$cnt]->textContent );
                    is( $subjects[$cnt]->textContent,
                        $categories[$cnt]->label
                    );
                }

            }
            else {
                die 'failed to retrieve categories';
            }
        }

        my $entry_id;

        use constant USE_DIGEST => 0;

        if (USE_DIGEST) {

         # # # # # # # use this to do a Digest auth with MD5 as the algorithm.
            my $realm = 'movabletype';

            #     $username = shift;
            #     $hashed_pwd = shift;
            require Digest::MD5;
            my $hashed_pwd = Digest::MD5::md5( join ':', $username, $realm,
                $chuck_token );
            my $method = 'POST';

            my $uri = new URI;
            $uri->path( $base_uri . '/blog_id=' . $blog_id );
            my $req = new HTTP::Request( POST => $uri );

            my $resp = $ua->simple_request($req);
            ok( $resp->is_error() );
            my $auth_header = $resp->header('WWW-Authenticate');
            my ($nonce) = $auth_header =~ /nonce=(\S*)/;

            my $A1 = pack( 'H*', $hashed_pwd );
            my $A2 = $method . ':' . $uri;

            require Digest::MD5;
            my $hash = \&Digest::MD5::md5;
            my $kd = sub { $hash->( $_[0] . ':' . $_[1] ) };

            print STDERR "Signing ",
                join( ':', $nonce, '', '', 'auth', $hash->($A2) ), "\n";
            print STDERR "with key ", $hash->($A1), "\n";

            my $response = $kd->(
                $hash->($A1),
                join( ':', $nonce, '', '', 'auth', $hash->($A2) )
            );
            print "# ", ( $response = unpack( 'H*', $response ) ), "\n";

            $uri = new URI;
            $uri->path( $base_uri . '/blog_id=' . $blog_id );
            $req = new HTTP::Request( POST => $uri );

            $req->header( 'X-Atom-Authorization',
                "Digest nonce=$nonce, username=$username, realm=movabletype, uri=$uri, qop=auth, response=$response"
            );
            print "# sending: ", $req->header('X-Atom-Authorization');

            $req->content( $test_data{$base_uri} );

            $resp = $ua->simple_request($req);

            print "# " . $resp->code . " " . $resp->message . "\n";
            print "# " . $resp->content . "\n";
            ok( $resp->is_success() );

            print "##\n" . $resp->header('Location') . "\n##\n";
            my $location = $resp->header('Location')
                || die "No Location: header. Did get\n"
                . $resp->code()
                . $resp->message() . "\n"
                . $resp->headers_as_string() . "\n"
                . $resp->content();
            ($entry_id) = ( $location =~ /entry_id=(\d+)/ );

            $entry_id
                || die "Couldn't get entry ID from header Location: "
                . $location;

            print "# entry ID is $entry_id\n";

            ok($entry_id);
        }

        unless (USE_DIGEST) {
            print "# Doing Digest auth\n";

            # # # # Now try posting an entry with authentication
            my $nonce = make_nonce();
            my $timestamp = strftime( "%Y-%m-%dT%H:%M:%SZ", gmtime(time) );
            use Digest::SHA1 qw(sha1_base64);
            my $PasswordDigest
                = sha1_base64( $nonce . $timestamp . $chuck_token );

            #     print STDERR ("Client hashing (",
            # 		  unpack('H*', $nonce . $timestamp . $chuck_token), ")\n");
            #     print STDERR "      produces: $PasswordDigest\n";

            $nonce = MIME::Base64::encode_base64( $nonce, '' );

            print "# nonce: $nonce\n";

            my $dir = `pwd`;
            chomp $dir;
            while ( !-x ( $dir . "/mt-atom.cgi" ) ) {
                $dir =~ s!(/[^/]*)$!!;
                last if $dir =~ m!^/?$!;
            }

            my $uri = new URI;
            $uri->path( $base_uri . '/blog_id=' . $blog_id );
            my $req = new HTTP::Request( POST => $uri );
            $req->header( 'Authorization' => 'Atom' );
            $req->header( 'X-WSSE' => "UserNameToken Username=\"$username\", "
                    . "PasswordDigest=\"$PasswordDigest\", Nonce=\"$nonce\", "
                    . "Created=\"$timestamp\"" );

            $req->content( $test_data{$base_uri} );

            my $resp = $ua->simple_request($req);

            print "######### RESPONSE #########\n";
            print "# " . $resp->code . " " . $resp->message . "\n";
            my $content = $resp->content || '';
            $content =~ s/^/# /gm;
            print $content;
            print "#########~RESPONSE #########\n";
            ok( $resp->is_success() );

            #print "##\n". $resp->header('Location')  . "\n##\n";
            my $location = $resp->header('Location')
                || die "No Location: header. Did get\n"
                . $resp->headers_as_string() . "\n"
                . $resp->content();
            ($entry_id) = ( $location =~ /entry_id=(\d+)/ );

            $entry_id
                || die "Couldn't get entry ID from header Location: "
                . $location;

            print "# entry ID is $entry_id\n";

            ok($entry_id);
            my $atom_obj = XML::Atom::Entry->new( \$resp->content() );
            require Date::Parse;
            print "# ", $atom_obj->issued(), "\n";
            is( Date::Parse::str2time( $atom_obj->issued() ),
                Date::Parse::str2time('2004-08-06T00:43:34+01:00'),
                $atom_obj->issued()
            );
        }

        {
            my $wsse_header = make_wsse($chuck_token);
            my $uri         = new URI;
            $uri->path( $base_uri . "/blog_id=$blog_id/entry_id=$entry_id" );
            my $req = new HTTP::Request( GET => $uri );
            $req->header( 'Authorization' => 'Atom' );
            $req->header( 'X-WSSE'        => $wsse_header );

            print "# X-WSSE: $wsse_header\n";

            my $resp = $ua->request($req);

            my $atom_entry
                = XML::Atom::Entry->new( Stream => \$resp->content() );

            is( $atom_entry->title(),          "Fight the Power" );
            is( $atom_entry->author()->name(), $chuck->nickname );
            is( $atom_entry->content()->body(),
                "Elvis was a hero to most but he never meant shit to me" );

            $wsse_header = make_wsse($chuck_token);
            $uri         = new URI;
            $uri->path( $base_uri . "/blog_id=$blog_id/entry_id=$entry_id" );
            $req = new HTTP::Request( PUT => $uri );
            $req->header( 'Authorization' => 'Atom' );
            $req->header( 'X-WSSE'        => $wsse_header );
            my $body = $atom_entry->as_xml();
            $req->content($body);

            $resp = $ua->request($req);

            if ( ok( $resp->is_success ) ) {
                $atom_entry
                    = XML::Atom::Entry->new( Stream => \$resp->content() );
                is( $atom_entry->title, "Fight the Power" );
                is( Date::Parse::str2time( $atom_entry->issued ),
                    Date::Parse::str2time("2004-08-05T21:13:34-0230")
                );
            }
            else {
                print STDERR "# PUT request returned ", $resp->status_line(),
                    "\n";
                skip(1);
                skip(1);
            }
        }

        unless (USE_DIGEST) {
            print "# Doing Digest auth\n";

            # # # # Now try posting an entry with authentication
            my $nonce = make_nonce();
            my $timestamp = strftime( "%Y-%m-%dT%H:%M:%SZ", gmtime(time) );
            use Digest::SHA1 qw(sha1_base64);
            my $PasswordDigest
                = sha1_base64( $nonce . $timestamp . $chuck_token );

       #     print STDERR ("Client hashing (",
       #             unpack('H*', $nonce . $timestamp . $chuck_token), ")\n");
       #     print STDERR "      produces: $PasswordDigest\n";

            $nonce = MIME::Base64::encode_base64( $nonce, '' );

            print "# nonce: $nonce\n";

            my $dir = `pwd`;
            chomp $dir;
            while ( !-x ( $dir . "/mt-atom.cgi" ) ) {
                $dir =~ s!(/[^/]*)$!!;
                last if $dir =~ m!^/?$!;
            }

            my $uri = new URI;
            $uri->path( $base_uri . '/blog_id=' . $blog_id . '/svc=upload/' );
            my $req = new HTTP::Request( POST => $uri );
            $req->header( 'Authorization' => 'Atom' );
            $req->header( 'X-WSSE' => "UserNameToken Username=\"$username\", "
                    . "PasswordDigest=\"$PasswordDigest\", Nonce=\"$nonce\", "
                    . "Created=\"$timestamp\"" );

            my $fmgr = MT::FileMgr->new('Local');
            if ( $fmgr->exists('t/test.gif') ) {
                $fmgr->delete('t/test.gif');
            }

            my $name = 't/images/test.gif';
            open my $fh, $name or die $!;
            binmode $fh;
            my $data = do { local $/; <$fh> };
            close $fh;

            use XML::Atom::Entry;
            my $entry = XML::Atom::Entry->new;
            $entry->title($name);
            $entry->content($data);
            $entry->content->type('image/gif');
            $entry->summary('A picture.');

            $req->content( $entry->as_xml );

            my $resp = $ua->simple_request($req);

            print "######### RESPONSE #########\n";
            print "# " . $resp->code . " " . $resp->message . "\n";
            my $content = $resp->content || '';
            $content =~ s/^/# /gm;
            print $content;
            print "#########~RESPONSE #########\n";
            ok( $resp->is_success() );

            my $asset = MT::Asset::Image->load( { blog_id => $blog_id },
                { sort => 'id', direction => 'descend' } );
            ok($asset);
            is( $asset->file_name, 'test.gif' );
            my $asset_url = $asset->url;

        }

        unless (USE_DIGEST) {
            print "# Doing Digest auth\n";

            # # # # Now try posting an entry with authentication
            my $nonce = make_nonce();
            my $timestamp = strftime( "%Y-%m-%dT%H:%M:%SZ", gmtime(time) );
            use Digest::SHA1 qw(sha1_base64);
            my $PasswordDigest
                = sha1_base64( $nonce . $timestamp . $chuck_token );

       #     print STDERR ("Client hashing (",
       #             unpack('H*', $nonce . $timestamp . $chuck_token), ")\n");
       #     print STDERR "      produces: $PasswordDigest\n";

            $nonce = MIME::Base64::encode_base64( $nonce, '' );

            print "# nonce: $nonce\n";

            my $dir = `pwd`;
            chomp $dir;
            while ( !-x ( $dir . "/mt-atom.cgi" ) ) {
                $dir =~ s!(/[^/]*)$!!;
                last if $dir =~ m!^/?$!;
            }

            my $uri = new URI;
            $uri->path( $base_uri
                    . '/blog_id='
                    . $blog_id
                    . '/entry_id='
                    . $entry_id );
            my $req = new HTTP::Request( DELETE => $uri );
            $req->header( 'Authorization' => 'Atom' );
            $req->header( 'X-WSSE' => "UserNameToken Username=\"$username\", "
                    . "PasswordDigest=\"$PasswordDigest\", Nonce=\"$nonce\", "
                    . "Created=\"$timestamp\"" );

            $req->content( $test_data{$base_uri} );

            my $resp = $ua->simple_request($req);

            print "######### RESPONSE #########\n";
            print "# " . $resp->code . " " . $resp->message . "\n";
            my $content = $resp->content || '';
            $content =~ s/^/# /gm;
            print $content;
            print "#########~RESPONSE #########\n";
            ok( $resp->is_success() );

            print "# entry ID is $entry_id\n";
            my $entry = MT::Entry->load($entry_id);
            is( $entry, undef );
        }

    }    #end foreach of blog_id
}    #end foreach of base_uri

done_testing;
