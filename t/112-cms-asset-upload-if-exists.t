#!/usr/bin/perl

use strict;
use lib qw( t/lib extlib lib );

BEGIN {
    $ENV{MT_CONFIG} = 'mysql-test.cfg';
}

BEGIN {
    use Test::More;
    eval { require Test::MockModule }
        or plan skip_all => 'Test::MockModule is not installed';
    eval { require Test::MockObject }
        or plan skip_all => 'Test::MockObject is not installed';
}

use MT::Test qw( :app :db :data );
use Test::More;

my $admin = MT::Author->load(1);
my $blog  = MT::Blog->load(1);
my $fmgr  = $blog->file_mgr;

sub _run_app_with_upload_file {
    my ( $class, $params, $file_path, $file_info ) = @_;
    my $put_args = undef;

    my $mock_put = sub {
        my $self = shift;
        $put_args = [@_];
    };
    my $fmgr_module = Test::MockModule->new( ref $fmgr );
    $fmgr_module->mock( $_, $mock_put ) for qw(put put_data);

    my $app = Test::MockModule->new('MT::App');
    $app->mock(
        'upload_info',
        sub {
            open( my $fh, '<', $file_path );
            $fh, $file_info;
        }
    );

    my $app = _run_app( $class, $params );

    $app, $put_args;
}

my $fmgr_module = Test::MockModule->new( ref $fmgr );
$fmgr_module->mock(
    'exists',
    sub {
        $_[1] eq 't/site/archives/test.jpg';
    }
);

subtest 'Without "auto_rename_if_exists"' => sub {
    my $newest_asset = MT::Asset->load( { class => '*' },
        { sort => [ { column => 'id', desc => 'DESC' } ], } );

    my ( $app, $put_args ) = _run_app_with_upload_file(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'upload_file',
            blog_id          => $blog->id,
            file             => 'test.jpg',
        },
        File::Spec->catfile( $ENV{MT_HOME}, 't', 'images', 'test.jpg' ),
        { 'Content-Type' => 'image/jpeg' }
    );
    my $out = delete $app->{__test_output};

    ok( !$put_args, 'Not uploaded' );
    my $created_asset
        = MT::Asset->load( { id => { '>' => $newest_asset->id } },
        { sort => [ { column => 'id', desc => 'DESC' } ], } );
    ok( !$created_asset, 'Not created' );

    done_testing();
};

subtest 'With "auto_rename_if_exists"' => sub {
    my $newest_asset = MT::Asset->load( { class => '*' },
        { sort => [ { column => 'id', desc => 'DESC' } ], } );

    my ( $app, $put_args ) = _run_app_with_upload_file(
        'MT::App::CMS',
        {   __test_user           => $admin,
            __request_method      => 'POST',
            __mode                => 'upload_file',
            blog_id               => $blog->id,
            file                  => 'test.jpg',
            auto_rename_if_exists => 1,
        },
        File::Spec->catfile( $ENV{MT_HOME}, 't', 'images', 'test.jpg' ),
        { 'Content-Type' => 'image/jpeg' }
    );
    my $out = delete $app->{__test_output};

    like(
        $put_args->[1],
        qr!t/site/archives/[0-9a-z]{40}\.jpg!,
        'Uploaded file path'
    );
    my $created_asset = MT::Asset->load( { id => { '>' => $newest_asset->id } },
        { sort => [ { column => 'id', desc => 'DESC' } ], } );
    ok( $created_asset, 'Created' );
    my $replaced_basename = File::Basename::basename( $put_args->[1] );
    my $expected_values   = {
        'file_ext'   => 'jpg',
        'file_path'  => '%a/' . $replaced_basename,
        'file_name'  => $replaced_basename,
        'url'        => '%a/' . $replaced_basename,
        'class'      => 'image',
        'blog_id'    => '1',
        'created_by' => '1'
    };
    my $result_values = do {
        return +{} unless $created_asset;
        my $values = $created_asset->column_values();
        +{ map { $_ => $values->{$_} } keys %$expected_values };
    };
    is_deeply( $result_values, $expected_values,
        "Created asset's column values" );
};

done_testing();
