#!/usr/bin/perl
use strict;
use warnings;
use utf8;
use open ':std', ':encoding(utf8)';

use Test::More;

use File::Spec;
use JSON;

BEGIN {
    eval 'use Test::Spec; 1'
        or plan skip_all => 'Test::Spec is not installed';

    $ENV{MT_CONFIG} = 'mysql-test.cfg';
}

use lib qw( lib extlib t/lib );
use MT::Test qw( :app :db :data );
use MT;

my $admin   = MT->model('author')->load(1);
my $blog_id = 1;

describe 'Uploaded asset (test.jpg)' => sub {
    context 'first time' => sub {
        my $asset;
        before all => sub {
            $asset = upload_asset('test.jpg');
        };
        describe 'file_name' => sub {
            it 'should be "test.jpg"' => sub {
                is( $asset->file_name, 'test.jpg' );
            };
        };
        describe 'label' => sub {
            it 'should be "test.jpg"' => sub {
                is( $asset->label, 'test.jpg' );
            };
        };
    };
    context 'second time with rename option' => sub {
        my $asset;
        before all => sub {
            $asset = upload_asset('test.jpg');
        };
        describe 'file_name' => sub {
            it 'should not be "test.jpg"' => sub {
                isnt( $asset->file_name, 'test.jpg' );
            };
        };
        describe 'label' => sub {
            it 'should be "test.jpg"' => sub {
                is( $asset->label, 'test.jpg' );
            };
        };
    };
};

describe 'Uploaded asset (テスト.jpg)' => sub {
    my $asset;
    before all => sub {
        $asset = upload_asset('テスト.jpg');
    };
    describe 'file_name' => sub {
        it 'should not be "テスト.jpg"' => sub {
            isnt( $asset->file_name, 'テスト.jpg' );
        };
    };
    describe 'label' => sub {
        it 'should be "テスト.jpg"' => sub {
            is( $asset->label, 'テスト.jpg' );
        };
    };
};

sub upload_asset {
    my $file = shift;

    local $ENV{HTTP_X_REQUESTED_WITH} = 'XMLHttpRequest';
    my $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'js_upload_file',
            blog_id          => $blog_id,
            destination      => '%s',
            __test_upload    => [
                'file',
                File::Spec->catfile( $ENV{MT_HOME}, qw/ t images /, $file ),
            ],
            auto_rename_non_ascii =>
                1,    # Rename non-ascii filename automatically
            operation_if_exists => 1,    # Upload and rename
        }
    );
    my $out = delete $app->{__test_output};

    my ( $headers, $body ) = split /^\s*$/m, $out, 2;
    my $hash = JSON::from_json($body);
    my $asset
        = MT->model('asset.image')->load( $hash->{result}{asset}{id} );
}

runtests unless caller;

