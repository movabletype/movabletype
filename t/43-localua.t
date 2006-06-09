use Test;

BEGIN { plan tests => 1 };

use lib 't/lib';

use LWP::UserAgent::Local;

$ENV{CONFIG} = 't/mt.cfg';
my $ua = new LWP::UserAgent::Local ({ScriptAlias => '/'});
my $req = new HTTP::Request(GET => "http://localhost/mt-atom.cgi/weblog/blog_id=1");
$resp = $ua->request($req);
print $resp->headers_as_string();
print $resp->content();
ok($resp->content());
