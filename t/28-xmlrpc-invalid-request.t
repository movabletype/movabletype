use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/lib"; # t/lib
use Test::More;
use MT::Test::Env;
BEGIN {
    eval { require LWP::UserAgent::Local }
        or plan skip_all => 'Some of the deps of LWP::UserAgent::Local are not available';
}

our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test;
use MT::Test::Permission;
use MT::Util qw(archive_file_for);
use File::Basename qw(dirname);
use MIME::Base64;
use Storable qw(dclone);

$test_env->prepare_fixture('db_data');

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

my $author = MT->model('author')->load(2) or die MT->model('author')->errstr;
$author->api_password($password);
$author->save or die $author->errstr;

use XMLRPC::Lite;
my $ser   = XMLRPC::Serializer->new();
my $deser = XMLRPC::Deserializer->new();

my $ua = new LWP::UserAgent::Local( { ScriptAlias => '/' } );

my $logo
    = q{R0lGODlhlgAZANUAAP////Ly8uTk5NfX18nJyb29vbu7u62trZ6eno+Pj1iZvVKQsoCAgE6IqHx8fEmAnnFxcUV4lGtra0BwimFhYTtnf1lZWTZfdVBQUDFWaitMXz8/PydDUyA5SC0tLRswPBYlLxkZGQ8bIggPEwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACH5BAAHAP8ALAAAAACWABkAAAb/QAjBQCoaMQSC0QiaKJ6LzGhJIhyoVQSWQcBgi8lwIkTdEDZfkjCchHzZbC3JfF0eCOQign3wLOFJRgWDFgUkBRYJAAAUVAaLVBxPk08PU0YHAH5GFABuVAIARF8ABAkIA6VUGABeX4oJsbGuVLKZB7GfJI+NRQwACX8CsQQAAZskpbKxS4YOBRIFDooBSkYeiwBLH08cSxEKD0udwUYGAXlGEACpyEvA5ppLrLS12mlf9FghAQJkHgEGUAlUZF25ZAexGILGUBECeXoAZPoWjgqIbksECLgmEcsAARsAyKECL6I7fa/u4VvV6ss6LcXQ/LFGAtvBkl8WHjqkCFsd/34GFBkZ8eQDlgoKKixR5OqXzCMAGJAYgA6LRAwYElRjWW9pK6xY0+Vr+QaYSCwEPTzSdRXs0zRCH5H5lVUltwlfiEZY4rOIRiznyKzTZSTbogBdUWJRZJhsGsVUAALwh7ZxnSKNVa0UyirYX6FFRChYcGmJpAUD0bGSyrdjkYBWD2ClkKoeZK9gw668veRXr4HDElBwl0y225UkQGvs5AZ0kQUKLlAZAV2BUXWeMoklkWlAmACOMR8MIWpeeK/IueLjXYWm1YTpQa8LUNU5iQxPQCzB/wTvkmquGcHPAMsocpl4AmpWBHvJqZQeCQxCeB4Y7pEEH3Kg8XNWg1Q8EP9OBiDyN4k3mCzS1S+EVQERZsbR5ol5DOSWDlO5vYVFhOwRRIpxYBFnjxEPbWJfERdQYiRGRYS0EShLLmHQO4YFAB8rjdHCmGEVqvfYhO3hkxlOX3hASwhPifmFCBpU0MCRT0ixoI0QwhnnPLl9EUJuuhUhJp5yCojBdkvcCegcfUKIJwY+PqioCBdUR8kCF1yn6KSUVmrppZheKoKHbIajQWmZhirqqKReOgKnnTagX6mstupqqRd1CgWor9Zq661fICVrUrj26qutsU4S6QcfdPAErb8mq6ylaz7RABVFSrrstNQi50RR0y0gbbXcdkuCBk/shQUHInhrLrei8XoZ7rrrFmkdu/B664S48dY7LQcPkGjvvksEAQA7};

my @apis = map {
    my @api;
    if ( !$_->{no_valid} ) {
        my $valid = +{
            api    => $_->{api},
            params => $_->{base_params},
            result => sub {
                my ($som) = @_;
                ok( $som->result );
                ok( !$som->fault );
                ok( !$som->faultcode );
            },
        };
        push @api, $valid;
    }
    push @api, $_->{generate_api}->($_);
    +@api;
} suite();

sub suite {
    return +(
        +(  map {
                +{  api => $_,
                    base_params =>
                        [ '', 1, $username, $password, 'foo bar', 0 ],
                    generate_api => \&_blogger_post,
                };
            } qw/ blogger.newPost blogger.editPost /,
        ),
        +(  map {
                +{  api         => $_,
                    base_params => [
                        1,
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
                            ( $_ eq 'wp.newPage' ) ? () : (
                                categories => [
                                    map {
                                        $mt->model('category')->load($_)
                                            ->label
                                    } qw(1 2)
                                ]
                            ),
                        },
                        0,
                    ],
                    generate_api => \&_meta_weblog_post,
                };
            } qw/ metaWeblog.newPost metaWeblog.editPost wp.newPage /,
        ),
        {   api         => 'wp.editPage',
            base_params => [
                1, 1,
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
                0,
            ],
            generate_api => \&_meta_weblog_post,
        },
        +(  map {
                +{  api         => $_,
                    base_params => [ ( blog_id => { op => 1, value => 1 } ) ],
                    generate_api => \&_hash_blog_id_post,
                    no_valid     => 1,
                };
            } qw/ blogger._new_entry blogger._edit_entry blogger._get_entries blogger._delete_entry blogger._get_entry /,
        ),
    );
}

sub _blogger_post {
    my ($suite) = @_;
    my $base_params = $suite->{base_params};

    my @invalid_api;

    for my $type (qw/ array hash /) {
        for my $i ( 1 .. ( scalar(@$base_params) - 1 ) ) {
            my $params = dclone($base_params);

            my $value = $params->[$i];
            $params->[$i]
                = ( $type eq 'array' )
                ? +[ $value, $value ]
                : +{ $value => $value };

            my $api = +{
                api    => $suite->{api},
                params => $params,
                result => sub {
                    my ($som) = @_;
                    ok( !$som->result );
                    ok( $som->fault );
                    is( $som->faultstring, 'Invalid parameter' );
                    is( $som->faultcode,   1 );
                },
            };

            push @invalid_api, $api;
        }
    }

    return @invalid_api;
}

sub _meta_weblog_post {
    my ($suite)     = @_;
    my $api_name    = $suite->{api};
    my $base_params = $suite->{base_params};

    my $items_col = ( $api_name eq 'wp.editPage' ) ? 4 : 3;

    my @invalid_api;

    for my $type (qw/ array hash /) {

        for my $i ( 0 .. scalar( @$base_params - 1 ) ) {
            if ( $i == $items_col ) {

                my $base_items = $base_params->[$items_col];
                for my $key ( sort keys %$base_items ) {
                    next if $key eq 'categories' || $key eq 'mt_tb_ping_urls';

                    my $params = dclone($base_params);
                    my $items  = $params->[$items_col];
                    my $value  = $items->{$key};
                    $items->{$key}
                        = ( $type eq 'array' )
                        ? +[ $value, $value ]
                        : +{ $value => $value };

                    my $api = +{
                        api    => $api_name,
                        params => $params,
                        result => sub {
                            my ($som) = @_;
                            ok( !$som->result );
                            ok( $som->fault );
                            is( $som->faultstring, 'Invalid parameter' );
                            is( $som->faultcode,   1 );
                        },
                    };

                    push @invalid_api, $api;
                }

            }
            else {
                my $params = dclone($base_params);

                $params->[$i]
                    = ( $type eq 'array' )
                    ? [ $params->[$i], $params->[$i] ]
                    : +{ $params->[$i] => $params->[$i] };

                my $api = +{
                    api    => $api_name,
                    params => $params,
                    result => sub {
                        my ($som) = @_;
                        ok( !$som->result );
                        ok( $som->fault );
                        is( $som->faultstring, 'Invalid parameter' );
                        is( $som->faultcode,   1 );
                    },
                };

                push @invalid_api, $api;
            }
        }
    }

    return @invalid_api;
}

sub _hash_blog_id_post {
    my ($suite) = @_;
    my $params = $suite->{base_params};

    my $api = +{
        api    => $suite->{api},
        params => $params,
        result => sub {
            my ($som) = @_;
            ok( !$som->result );
            ok( $som->fault );
            is( $som->faultstring, 'Invalid parameter' );
            is( $som->faultcode,   1 );
        },
    };

    return $api;
}

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
