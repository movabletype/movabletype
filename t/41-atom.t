use strict;
use lib 't/lib', 'extlib', 'lib', '../lib', '../extlib';
use POSIX;

use MT;
use MT::Atom;
use XML::LibXML; # this test would not work without it
use XML::XPath;
use XML::Atom;
use XML::Atom::Feed;
use XML::Atom::Entry;
use POSIX qw( ceil );

use Test::More qw( no_plan );#tests => 97;

# To keep away from being under FastCGI
$ENV{HTTP_HOST} = 'localhost';

use vars qw( $DB_DIR $T_CFG );
my $mt = MT->new( Config => $T_CFG ) or die MT->errstr;
isa_ok($mt, 'MT');

use MT::Test qw(:db :data);

my %test_data;
$test_data{'/mt-atom.cgi/weblog'} = <<XML1;
<?xml version="1.0" encoding="utf-8"?>
    <entry xmlns="http://purl.org/atom/ns#" xmlns:dc="http://purl.org/dc/elements/1.1/">
    <title>Fight the Power</title>
    <content>Elvis was a hero to most but he never meant shit to me</content>
    <issued>2004-08-06T00:43:34+01:00</issued>
    </entry>
XML1
$test_data{'/mt-atom.cgi/1.0'} = <<XML2;
<?xml version="1.0" encoding="utf-8"?>
<entry xmlns="http://www.w3.org/2005/Atom">
<title>Fight the Power</title>
<content type="html">Elvis was a hero to most but he never meant shit to me</content>
<published>2004-08-06T00:43:34+01:00</published>
</entry>
XML2

my %feed_link = (
    '/mt-atom.cgi/weblog' => sub {
        my ($resp) = @_;
        my $feed = XML::Atom::Feed->new(\$resp->content());
        ok($feed, 'got feed');
        my ($sfeed) = grep {
            $_->rel eq 'service.feed'
        } $feed->links;
        $sfeed->href;
    },
    '/mt-atom.cgi/1.0' => sub {
        my ($resp) = @_;
        my $feed = XML::XPath->new(xml => $resp->content());
        ok($feed, 'got feed');
        my $col = $feed->getNodeText('/service/workspace[1]/collection/@href');
        $col;
    }
);

my $username = 'Chuck D';
my $chuck = MT::Author->load({name => $username})
    or die "Couldn't load $username";
my $chuck_token = $chuck->api_password;

# not a good nonce-maker
my @hexch = ('0' .. '9', 'a' .. 'f');
sub make_nonce {
    join '', map { $hexch[rand() * @hexch] } (0..7);
}
sub make_wsse {
    my ($password) = @_;
    my $timestamp = strftime("%Y-%m-%dT%H:%M:%SZ", gmtime(time));
    my $nonce = make_nonce();
    my $PasswordDigest = sha1_base64($nonce . $timestamp . $chuck_token);
    # print "# PasswordDigest is sha1('$nonce$timestamp$chuck_token')\n";
    $nonce = MIME::Base64::encode_base64($nonce, '');
    return "UserNameToken Username=\"$username\", "
		 . "PasswordDigest=\"$PasswordDigest\", Nonce=\"$nonce\", " 
		 . "Created=\"$timestamp\"";
}

require LWP::UserAgent::Local;
my $ua = new LWP::UserAgent::Local({ ScriptAlias => '/' });

foreach my $base_uri ( qw{/mt-atom.cgi/weblog /mt-atom.cgi/1.0 } ) {
{
# # # # First try a req with baloney auth, make sure it fails
    # TBD: Try more bogus auth varieties
    my $nonce = make_nonce();
    $nonce = MIME::Base64::encode_base64($nonce, '');

    my $uri = new URI();
    $uri->path($base_uri . '/blog_id=1');
    my $req = new HTTP::Request(GET => $uri);
    $req->header(Authentication => 'Atom');
    $req->header('X-WSSE' => "UserNameToken Username=\"Melody\", PasswordDigest=\"Oj12fART+XZvBZBe39vVvkirg4w\", Nonce=\"" . $nonce . "\", Created=\"2004-05-19T20:08:57Z\"");
    print "# requesting: " . $req->uri . "\n";
    my $resp = $ua->request($req);

    print "# response code was: " . $resp->code . "\n";
    print "# content was: " . $resp->content . "\n";# if !$resp->code();
    ok($resp->is_error());
}

# test blog lists
{
    my $wsse_header = make_wsse($chuck_token);
    my $uri = new URI;
    $uri->path($base_uri);
    my $req = new HTTP::Request(GET => $uri);
    $req->header('Authorization' => 'Atom');
    $req->header('X-WSSE' => $wsse_header);

    print "# X-WSSE: $wsse_header\n";

    my $resp = $ua->request($req);
    if (ok($resp->is_success)) {
        my $blog_feed_url = $feed_link{$base_uri}->($resp);
        my $blog_feed_uri = new URI($blog_feed_url);
        is($blog_feed_uri->path, $base_uri . '/blog_id=1', 'blog feed url is correct');
    }
    else {
        die 'failed to retrieve blog feed';
    }
}

# test blog feed
{
    my $wsse_header = make_wsse($chuck_token);
    my $uri = new URI;
    $uri->path($base_uri . "/blog_id=1");
    my $req = new HTTP::Request(GET => $uri);
    $req->header('Authorization' => 'Atom');
    $req->header('X-WSSE' => $wsse_header);

    print "# X-WSSE: $wsse_header\n";

    my $resp = $ua->request($req);
    if (ok($resp->is_success)) {
        my $feed = XML::Atom::Feed->new(\$resp->content());
        ok($feed, 'got feed');
        is($feed->title, 'none');
        my ($alternate) = grep {
            $_->rel eq 'alternate' && $_->type eq 'text/html'
        } $feed->links;
        is($alternate->href, 'http://narnia.na/nana/', 'blog url is correct');
        my $entry_count = MT::Entry->count(
            { blog_id => 1 },
            { limit => 21 },
        );
        my @entries = $feed->entries;
        is($entry_count, scalar(@entries), 'number of entries is correct');

        # check if entries have replies link relation
        my $failed = 0;
        foreach my $entry (@entries) {
            next if !$entry->id && $entry->title =~ /^I just finished installing Movable Type/;
            my $mt_entry = MT::Entry->load({
                atom_id => $entry->id,
                blog_id => 1,
            });
            $failed = 1, last unless $mt_entry;
            my ($replies) = grep {
                $_->rel eq 'replies'
            } $entry->links;
            $failed = 1, last unless $replies;
            my $replies_uri = new URI($replies->href);
            $failed = 1, last unless $replies_uri->path eq '/mt-atom.cgi/comments/blog_id=1/entry_id='.$mt_entry->id;
        }
        is($failed, 0, 'all the entries have replies link rel');
    }
    else {
        die 'failed to retrieve blog feed';
    }
}

my $entry_id;

use constant USE_DIGEST => 0;

if (USE_DIGEST)
{
# # # # # # # use this to do a Digest auth with MD5 as the algorithm.
    my $realm = 'movabletype';
#     $username = shift;
#     $hashed_pwd = shift;
    require Digest::MD5;
    my $hashed_pwd = Digest::MD5::md5(join ':', $username, $realm, $chuck_token);
    my $method = 'POST';

    my $uri = new URI;
    $uri->path($base_uri . '/blog_id=1');
    my $req = new HTTP::Request(POST => $uri);

    my $resp = $ua->simple_request($req);
    ok($resp->is_error());
    my $auth_header = $resp->header('WWW-Authenticate');
    my ($nonce) = $auth_header =~ /nonce=(\S*)/;

    my $A1 = pack('H*', $hashed_pwd);
    my $A2 = $method . ':' . $uri;
    
    require Digest::MD5;
    my $hash = \&Digest::MD5::md5;
    my $kd = sub { $hash->($_[0].':'.$_[1]) };

    print STDERR "Signing ", join(':',
                                  $nonce,
                                  '',
                                  '',
                                  'auth',
                                  $hash->($A2)), "\n";
    print STDERR "with key ", $hash->($A1), "\n";

    my $response = $kd->($hash->($A1), join(':',
                                            $nonce,
                                            '',
                                            '',
                                            'auth',
                                            $hash->($A2)));
    print "# ", ($response = unpack('H*', $response)), "\n";

    $uri = new URI;
    $uri->path($base_uri . '/blog_id=1');
    $req = new HTTP::Request(POST => $uri);

    $req->header('X-Atom-Authorization', "Digest nonce=$nonce, username=$username, realm=movabletype, uri=$uri, qop=auth, response=$response");
    print "# sending: ", $req->header('X-Atom-Authorization');

    $req->content($test_data{$base_uri});

    $resp = $ua->simple_request($req);

    print "# " . $resp->code . " " . $resp->message . "\n";
    print "# " . $resp->content . "\n";
    ok($resp->is_success());

    print "##\n". $resp->header('Location')  . "\n##\n";
    my $location = $resp->header('Location') 
	|| die "No Location: header. Did get\n"
                . $resp->code() . $resp->message() . "\n"
	        . $resp->headers_as_string() . "\n"
		. $resp->content();
    ($entry_id) = ($location =~ /entry_id=(\d+)/);

    $entry_id || die "Couldn't get entry ID from header Location: " 
        . $location;

    print "# entry ID is $entry_id\n";

    ok($entry_id);
}

unless (USE_DIGEST)
{
    print "# Doing Digest auth\n";
# # # # Now try posting an entry with authentication
    my $nonce = make_nonce();
    my $timestamp = strftime("%Y-%m-%dT%H:%M:%SZ", gmtime(time));
    use Digest::SHA1 qw(sha1_base64);
    my $PasswordDigest = sha1_base64($nonce . $timestamp . $chuck_token);

#     print STDERR ("Client hashing (",
# 		  unpack('H*', $nonce . $timestamp . $chuck_token), ")\n");
#     print STDERR "      produces: $PasswordDigest\n";

    $nonce = MIME::Base64::encode_base64($nonce, '');

    print "# nonce: $nonce\n";

    my $dir = `pwd`; chomp $dir;
    while (! -x ($dir . "/mt-atom.cgi")) {
	$dir =~ s!(/[^/]*)$!!;
	last if $dir =~ m!^/?$!;
    }	

    my $uri = new URI;
    $uri->path($base_uri . '/blog_id=1');
    my $req = new HTTP::Request(POST => $uri);
    $req->header('Authorization' => 'Atom');
    $req->header('X-WSSE' => "UserNameToken Username=\"$username\", "
		 . "PasswordDigest=\"$PasswordDigest\", Nonce=\"$nonce\", " 
		 . "Created=\"$timestamp\"");

    $req->content($test_data{$base_uri});

    my $resp = $ua->simple_request($req);

    print "######### RESPONSE #########\n";
    print "# " . $resp->code . " " . $resp->message . "\n";
    my $content =  $resp->content;
    $content =~ s/^/# /gm;
    print $content;
    print "#########~RESPONSE #########\n";
    ok($resp->is_success());

    #print "##\n". $resp->header('Location')  . "\n##\n";
    my $location = $resp->header('Location') 
	|| die "No Location: header. Did get\n"
	        . $resp->headers_as_string() . "\n"
		. $resp->content();
    ($entry_id) = ($location =~ /entry_id=(\d+)/);

    $entry_id || die "Couldn't get entry ID from header Location: " 
        . $location;

    print "# entry ID is $entry_id\n";

    ok($entry_id);
    my $atom_obj = XML::Atom::Entry->new(\$resp->content());
    require Date::Parse;
    print "# ", $atom_obj->issued(), "\n";
    is(Date::Parse::str2time($atom_obj->issued()),
       Date::Parse::str2time('2004-08-06T00:43:34+01:00'), $atom_obj->issued());
}

{
    my $wsse_header = make_wsse($chuck_token);
    my $uri = new URI;
    $uri->path($base_uri . "/blog_id=1/entry_id=$entry_id");
    my $req = new HTTP::Request(GET => $uri);
    $req->header('Authorization' => 'Atom');
    $req->header('X-WSSE' => $wsse_header);

    print "# X-WSSE: $wsse_header\n";

    my $resp = $ua->request($req);

    my $atom_entry = XML::Atom::Entry->new(Stream => \$resp->content());

    is($atom_entry->title(), "Fight the Power");
    is($atom_entry->author()->name(), $chuck->nickname);
    is($atom_entry->content()->body(),
       "Elvis was a hero to most but he never meant shit to me");

    $wsse_header = make_wsse($chuck_token);
    $uri = new URI;
    $uri->path($base_uri . "/blog_id=1/entry_id=$entry_id");
    $req = new HTTP::Request(PUT => $uri);
    $req->header('Authorization' => 'Atom');
    $req->header('X-WSSE' => $wsse_header);
    my $body = $atom_entry->as_xml();
    $req->content($body);
    
    $resp = $ua->request($req);

    if (ok($resp->is_success)) {
        $atom_entry = XML::Atom::Entry->new(Stream => \$resp->content());
        is($atom_entry->title, "Fight the Power");
        is(Date::Parse::str2time($atom_entry->issued), 
           Date::Parse::str2time("2004-08-05T21:13:34-0230"));
    } else {
        print STDERR "# PUT request returned ", $resp->status_line(), "\n";
        skip(1);
        skip(1);
    }
}

} #end foreach

COMMENT:
# comments retrieval
{
    my $wsse_header = make_wsse($chuck_token);
    my $uri = new URI;
    $uri->path('/mt-atom.cgi/comments/blog_id=1');
    my $req = new HTTP::Request(GET => $uri);
    $req->header('Authorization' => 'Atom');
    $req->header('X-WSSE' => $wsse_header);

    my $resp = $ua->request($req);
    if (ok($resp->is_success)) {
        my $thr_ns = XML::Atom::Namespace->new(prefix => undef, uri => 'http://purl.org/syndication/thread/1.0');
        my $comments = XML::Atom::Feed->new(\$resp->content());
        my $count = MT::Comment->count({
            blog_id => 1, visible => 1
        });
        is( $count, scalar($comments->entries), 'comment count' );
        foreach my $c ( $comments->entries ) {
            my $id = $c->id;
            my ( $cmt_id ) = $id =~ m{/([0-9]+)$};
            die unless $cmt_id;
            my $mt_comment = MT::Comment->load($cmt_id);
            die unless $mt_comment;
            my $mt_entry = $mt_comment->entry;
            is($c->title, $mt_entry->title, 'comment title == entry title');
            is( $c->author->name, $mt_comment->author, 'comment author' );
            is( $c->author->email || '', $mt_comment->email || '', 'commenter email' );
            is( $c->author->uri || '', $mt_comment->url || '', 'commenter url'  );
            if ( $XML::Atom::LIBXML ) {
                my $nodelist = $c->elem->getElementsByTagNameNS('http://purl.org/syndication/thread/1.0', 'in-reply-to');    
                my $irt = $nodelist->shift;
                ok($irt, 'in-reply-to');
                is( $irt->ref, $mt_entry->atom_id, 'in-reply-to/ref' );
                is( $irt->href, $mt_entry->permalink, 'in-reply-to/href' );
            }
        }
    }
    else {
        die $resp->content();
    }
}

{
    my $iter = MT::Comment->count_group_by(
        { blog_id => 1, visible => 1 },
        { group => ['entry_id'], sort => [ { desc => 'DESC', column => '1' } ]
        }
    );
    #$Data::ObjectDriver::PROFILE = 1;
    #my $p = Data::ObjectDriver->profiler;
    #$p->reset;
    #print "$_\n" foreach @{$p->query_log};
    my ( $count, $eid ) = $iter->();
    $iter->('finish');
    my $entry = MT::Entry->load($eid);

    my $wsse_header = make_wsse($chuck_token);
    my $uri = new URI;
    $uri->path('/mt-atom.cgi/1.0/blog_id=1/entry_id=' . $entry->id);
    my $req = new HTTP::Request(GET => $uri);
    $req->header('Authorization' => 'Atom');
    $req->header('X-WSSE' => $wsse_header);

    my $resp = $ua->request($req);
    if (ok($resp->is_success)) {
        my $feed = XML::Atom::Entry->new(\$resp->content());
        my ($replies) = grep {
            $_->rel eq 'replies'
        } $feed->links;

        # retrieve comments from replies url
        my $replies_uri = new URI($replies->href);
        my $wsse_header = make_wsse($chuck_token);
        my $uri = new URI;
        $uri->path($replies_uri->path);
        my $req = new HTTP::Request(GET => $uri);
        $req->header('Authorization' => 'Atom');
        $req->header('X-WSSE' => $wsse_header);

        my $resp = $ua->request($req);
        my $thr_ns = XML::Atom::Namespace->new(prefix => undef, uri => 'http://purl.org/syndication/thread/1.0');
        if (ok($resp->is_success)) {
            my $comments = XML::Atom::Feed->new(\$resp->content());
            is( $count, scalar($comments->entries), 'comment count' );
            foreach my $e ( $comments->entries ) {
                is($e->title, $entry->title, 'comment title == entry title');
                my $id = $e->id;
                my ( $cmt_id ) = $id =~ m{/([0-9]+)$};
                die unless $cmt_id;
                my $mt_comment = MT::Comment->load($cmt_id);
                die unless $mt_comment;
                is( $e->author->name, $mt_comment->author, 'comment author' );
                is( $e->author->email || '', $mt_comment->email || '', 'commenter email' );
                is( $e->author->uri || '', $mt_comment->url || '', 'commenter url'  );
                if ( $XML::Atom::LIBXML ) {
                    my $nodelist = $e->elem->getElementsByTagNameNS('http://purl.org/syndication/thread/1.0', 'in-reply-to');    
                    my $irt = $nodelist->shift;
                    ok($irt, 'in-reply-to');
                    is( $irt->ref, $entry->atom_id, 'in-reply-to/ref' );
                    is( $irt->href, $entry->permalink, 'in-reply-to/href' );
                }
            }
        }
        else {
            die $resp->content();
        }
    }
}

{
    my $thr_ns = XML::Atom::Namespace->new(prefix => undef, uri => 'http://purl.org/syndication/thread/1.0');
    my $wsse_header = make_wsse($chuck_token);
    my $uri = new URI;
    $uri->path('/mt-atom.cgi/comments/blog_id=1/comment_id=1');
    my $req = new HTTP::Request(GET => $uri);
    $req->header('Authorization' => 'Atom');
    $req->header('X-WSSE' => $wsse_header);

    my $resp = $ua->request($req);
    if (ok($resp->is_success)) {
        my $c = XML::Atom::Entry->new(\$resp->content());
        my $mt_comment = MT::Comment->load(1);
        die unless $mt_comment;
        my $entry = $mt_comment->entry;
        is( $c->title, $entry->title, 'comment title == entry title' );
        is( $c->author->name, $mt_comment->author, 'comment author' );
        is( $c->author->email || '', $mt_comment->email || '', 'commenter email' );
        is( $c->author->uri || '', $mt_comment->url || '', 'commenter url'  );
        if ( $XML::Atom::LIBXML ) {
            my $nodelist = $c->elem->getElementsByTagNameNS('http://purl.org/syndication/thread/1.0', 'in-reply-to');    
            my $irt = $nodelist->shift;
            ok($irt, 'in-reply-to');
            is( $irt->ref, $entry->atom_id, 'in-reply-to/ref' );
            is( $irt->href, $entry->permalink, 'in-reply-to/href' );
        }
    }
    else {
        die $resp->content();
    }
}

sub _test_limit_offset {
    my ( $uri, $url, $limit, $total, $desc ) = @_;
    my %items;
    for ( my $i = 0; $i < ceil($total/$limit); $i++ ) {
        my $wsse_header = make_wsse($chuck_token);
        my $req = new HTTP::Request(GET => $uri);
        $req->header('Authorization' => 'Atom');
        $req->header('X-WSSE' => $wsse_header);

        my $resp = $ua->request($req);
        if (ok($resp->is_success)) {
            my $thr_ns = XML::Atom::Namespace->new(prefix => undef, uri => 'http://purl.org/syndication/thread/1.0');
            my $items = XML::Atom::Feed->new(\$resp->content());
            ok ($items, 'items retrieved');
            if ( $total >= $limit * ($i+1) ) {
                is( scalar($items->entries), $limit, 'limit applied ' . $desc );
            }
            else {
                ok( scalar($items->entries) < $limit, 'limit applied ' . $desc );
            }
            foreach my $c ( $items->entries ) {
                my $id = $c->id;
                die unless $id;
                ok( !exists($items{$id}), 'no dupe items - offset applied ' . $desc );
                $items{$id} = 1;
            }
        }
        else {
            die $resp->content();
        }
        $uri->path($url . '/offset=' . ($limit*($i+1)));
    }
}

#offset and limit
{
    my $uri = new URI;
    my $limit = 3;
    my $url = "/mt-atom.cgi/1.0/blog_id=1/limit=$limit";
    $uri->path($url);

    my $count = MT::Entry->count({
        blog_id => 1
    });

    &_test_limit_offset( $uri, $url, $limit, $count, 'blog entries');

    $url = "/mt-atom.cgi/comments/blog_id=1/limit=$limit";
    $uri->path($url);

    my $count = MT::Comment->count({
        blog_id => 1, visible => 1
    });

    &_test_limit_offset( $uri, $url, $limit, $count, 'blog comments');

    my $iter = MT::Comment->count_group_by(
        { blog_id => 1, visible => 1 },
        { group => ['entry_id'], sort => [ { desc => 'DESC', column => '1' } ]
        }
    );

    $limit = 2;
    my $eid;
    while ( ( $count, $eid ) = $iter->() ) {
        if ( $count > 2 ) {
            $iter->('finish');
            last;
        }
    }
    die unless $eid;

    $url = "/mt-atom.cgi/comments/blog_id=1/entry_id=$eid/limit=$limit";
    $uri->path($url);

    &_test_limit_offset($uri, $url, $limit, $count, 'entry comments');
}

END {
    #my $melody = MT::Author->load({ name => $username });
    #$melody->delete() if $melody;
}
