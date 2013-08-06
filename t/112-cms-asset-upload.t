#!/usr/bin/perl

#use strict;
use lib qw( t/lib extlib lib ../lib ../extlib );

BEGIN {
    $ENV{MT_CONFIG} = 'mysql-test.cfg';
}

BEGIN {
    use Test::More;
    eval { require Test::MockModule }
        or plan skip_all => 'Test::MockModule is not installed';
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

subtest 'Regular JPEG image' => sub {
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

    is( $put_args->[1], 't/site/archives/test.jpg', 'Uploaded file path' );
    my $created_asset
        = MT::Asset->load( { id => { '>' => $newest_asset->id } },
        { sort => [ { column => 'id', desc => 'DESC' } ], } );
    ok( $created_asset, 'An asset is created' );
    my $expected_values = {
        'file_ext'   => 'jpg',
        'file_path'  => '%a/test.jpg',
        'file_name'  => 'test.jpg',
        'url'        => '%a/test.jpg',
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

    done_testing();
};

subtest 'Regular JPEG image with wrong extension' => sub {
    my $newest_asset = MT::Asset->load( { class => '*' },
        { sort => [ { column => 'id', desc => 'DESC' } ], } );

    my ( $app, $put_args ) = _run_app_with_upload_file(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'upload_file',
            blog_id          => $blog->id,
            file             => 'wrong-extension-test.gif',
        },
        File::Spec->catfile( $ENV{MT_HOME}, 't', 'images', 'test.jpg' ),
        { 'Content-Type' => 'image/jpeg' }
    );
    my $out = delete $app->{__test_output};

    like(
        $out,
        qr/ext_to=jpg.*ext_from=gif|ext_from=gif.*ext_to=jpg/,
        'Reported that the extension was changed'
    );

    is( $put_args->[1], 't/site/archives/wrong-extension-test.jpg', 'Uploaded file path' );
    my $created_asset
        = MT::Asset->load( { id => { '>' => $newest_asset->id } },
        { sort => [ { column => 'id', desc => 'DESC' } ], } );
    ok( $created_asset, 'An asset is created' );
    my $expected_values = {
        'file_ext'   => 'jpg',
        'file_path'  => '%a/wrong-extension-test.jpg',
        'file_name'  => 'wrong-extension-test.jpg',
        'url'        => '%a/wrong-extension-test.jpg',
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

    done_testing();
};

subtest 'Regular PDF file' => sub {
    my $newest_asset = MT::Asset->load( { class => '*' },
        { sort => [ { column => 'id', desc => 'DESC' } ], } );

    my ( $app, $put_args ) = _run_app_with_upload_file(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'upload_file',
            blog_id          => $blog->id,
            file             => 'test.pdf',
        },
        File::Spec->catfile( $ENV{MT_HOME}, 't', 'files', 'test.pdf' ),
        { 'Content-Type' => 'application/pdf' }
    );
    my $out = delete $app->{__test_output};

    is( $put_args->[1], 't/site/archives/test.pdf', 'Uploaded file path' );
    my $expected_values = {
        'file_ext'   => 'pdf',
        'file_path'  => '%a/test.pdf',
        'file_name'  => 'test.pdf',
        'url'        => '%a/test.pdf',
        'class'      => 'file',
        'blog_id'    => '1',
        'created_by' => '1'
    };
    my $created_asset
        = MT::Asset->load( { id => { '>' => $newest_asset->id } },
        { sort => [ { column => 'id', desc => 'DESC' } ], } );
    ok( $created_asset, 'An asset is created' );
    my $result_values = do {
        return +{} unless $created_asset;
        my $values = $created_asset->column_values();
        +{ map { $_ => $values->{$_} } keys %$expected_values };
    };
    is_deeply( $result_values, $expected_values,
        "Created asset's column values" );

    done_testing();
};

done_testing();
