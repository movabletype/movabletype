package MT::Core::Config;

use strict;
use warnings;
use utf8;

our $common = { 'TempDir' => { default => '/tmp', }, };

our $database = {
    'Database'        => undef,
    'DBHost'          => undef,
    'DBSocket'        => undef,
    'DBPort'          => undef,
    'DBUser'          => undef,
    'DBPassword'      => undef,
    'DBMaxRetries'    => { default => 3 },
    'DBRetryInterval' => { default => 1 },
};

our $middleware = {
    'MemcachedServers'   => { type    => 'ARRAY', },
    'MemcachedNamespace' => undef,
    'MemcachedDriver'    => { default => 'Cache::Memcached' },
};

our $data_api = {
    'AccessTokenTTL'          => { default => 60 * 60, },
    'DataAPICORSAllowOrigin'  => { default => undef },
    'DataAPICORSAllowMethods' => { default => '*' },
    'DataAPICORSAllowHeaders' =>
        { default => 'X-MT-Authorization, X-Requested-With' },
    'DataAPICORSExposeHeaders' => { default => 'X-MT-Next-Phase-URL' },
    'DisableResourceField'     => {
        type    => 'HASH',
        default => {}
    },
    'DataAPIResponseCacheDriver'     => { default => 'MT::Cache::File' },
    'DataAPIResponseCacheBlogRegexp' => { default => '/blog/(\d+)(?:/|$)' },
};

1;

