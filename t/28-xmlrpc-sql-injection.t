use strict;
use warnings;

BEGIN {
    use Test::More;
    eval { require Test::MockModule }
        or plan skip_all => 'Test::MockModule is not installed';

    $ENV{MT_CONFIG} ||= 'mysql-test.cfg';
}

use lib 't/lib', 'extlib', 'lib', '../lib', '../extlib';
use MT::Test qw(:db :data);
use Test::More;

# To keep away from being under FastCGI
$ENV{HTTP_HOST} = 'localhost';

my $mt = MT->new() or die MT->errstr;

isa_ok( $mt, 'MT' );

my $base_uri = '/mt-xmlrpc.cgi';
my $username = 'Chuck D';
my $password = 'seecret';

use XMLRPC::Lite;
my $ser   = XMLRPC::Serializer->new();
my $deser = XMLRPC::Deserializer->new();

require LWP::UserAgent::Local;
my $ua = new LWP::UserAgent::Local( { ScriptAlias => '/' } );

my $templ_header = <<XML;
<?xml version="1.0"?>
<methodCall>
  <methodName>:api</methodName>
  <params>
XML
my $templ_label = <<XML;
    <param>
      <value><string>:param</string></value>
    </param>
XML
my $templ_value = <<XML;
    <param>
      <value>
        <struct>
          <member>
           <name>op</name>
           <value><string>&gt; 0 and 9999 and 1=</string></value>
         </member>
          <member>
           <name>value</name>
           <value><string>1</string></value>
         </member>
        </struct>
      </value>
    </param>
XML
my $templ_footer = <<XML;
  </params>
</methodCall>
XML

my @methods = (
    {   name   => '_new_entry',
        params => [ 'blog_id', 'user', 'pass', 'publish' ],
    },
    { name => 'newPost' },
    { name => 'newPage' },
    {   name   => '_edit_entry',
        params => [ 'blog_id', 'entry_id', 'user', 'pass', 'publish' ],
    },
    { name => 'editPost' },
    { name => 'editPage' },
    { name => 'getUsersBlogs' },
    { name => 'getUserInfo' },
    {   name   => '_get_entries',
        params => [ 'blog_id', 'user', 'pass', 'num', 'titles_only' ],
    },
    { name => 'getRecentPosts' },
    { name => 'getRecentPostTitles' },
    { name => 'getPages' },
    {   name   => '_delete_entry',
        params => [ 'blog_id', 'entry_id', 'user', 'pass', 'publish' ],
    },
    { name => 'deletePost' },
    { name => 'deletePage' },
    {   name   => '_get_entry',
        params => [ 'blog_id', 'entry_id', 'user', 'pass' ],
    },
    { name => 'getPost' },
    { name => 'getPage' },
    { name => 'getCategoryList' },
    { name => 'getCategories' },
    { name => 'getTagList' },
    { name => 'getPostCategories' },
    { name => 'setPostCategories' },
    { name => 'getTrackbackPings' },
    { name => 'publishPost' },
    { name => 'runPeriodicTasks' },
    { name => 'publishScheduledFuturePosts' },
    { name => 'getNextScheduled' },
    { name => 'setRemoteAuthToken' },
    { name => 'newMediaObject' },
);

my @apis;
foreach my $class (qw( blogger metaWeblog mt wp )) {
    foreach my $method (@methods) {
        foreach my $param ( @{ $method->{params} } ) {
            my $api = {
                class  => $class,
                method => $method->{name},
                param  => $param,
                count  => $method->{count},
                result => sub {
                    my ($som) = @_;
                    my $msg
                        = exists $method->{msg}
                        ? $method->{msg}
                        : 'Invalid parameter';
                    is( $som->faultstring, $msg,
                        "test for $class.$method->{name}" );
                },
            };
            push @apis, $api;
        }
    }
}

my $uri = new URI();
$uri->path($base_uri);
my $req = new HTTP::Request( POST => $uri );

foreach my $api (@apis) {
    my $api_name   = $api->{class} . '.' . $api->{method};
    my $param_name = $api->{param};
    note("test for $api_name");

    my $content = $templ_header;
    $content .= $templ_label if $api->{method} =~ /^_.*/;
    if ( $api->{method} =~ /^_.*/ ) {
        $content .= $templ_value;
    }
    else {
        for ( my $i = 0; $i < 6; $i++ ) {
            $content .= $templ_value;
        }
    }
    $content .= $templ_footer;
    $content =~ s/:api/$api_name/;
    $content =~ s/:param/$param_name/ if $api->{method} =~ /^_.*/;
    $req->content($content);

    my $resp = $ua->request($req);

    #    print STDERR $resp->content;
    my $som = $deser->deserialize( $resp->content() );
    $api->{result}->($som);
}

done_testing();
1;
__END__
