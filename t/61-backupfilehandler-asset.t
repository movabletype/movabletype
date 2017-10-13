#!/usr/bin/perl

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


use lib qw(lib extlib t/lib);

BEGIN {
    $ENV{MT_CONFIG} = 'mysql-test.cfg';
}

use MT;
use MT::Test qw(:db);
use JSON;
use File::Spec;
use Test::More;

use MT::BackupRestore;

my $schema_version = 5.0034;

sub make_xml {
    my ($params) = @_;

    <<__XML__
<?xml version='1.0'?>
<movabletype xmlns='http://www.sixapart.com/ns/movabletype'
backup_what='' backup_by='Melody(ID: 1)' schema_version='@{[ $params->{schema_version} ]}' backup_on='2012-10-02T00:50:29'>
<image id='1' blog_id='0' class='image' created_by='1' created_on='@{[ $params->{created_on} ]}' file_ext='jpg' file_name='test.jpg' file_path='@{[ $params->{file_path} ]}' label='@{[ $params->{label} ]}' mime_type='image/jpeg' modified_by='1' modified_on='20121002095007' url='@{[ $params->{url} ]}' image_height='768' image_width='1024'><description>@{[ $params->{description} ]}</description></image>
</movabletype>
__XML__
}

sub parse {
    my ($params) = @_;

    note( 'Parse XML: params: ' . JSON::to_json($params, {canonical => 1}) );

    my $objects = {};
    my $callback = sub { };

    require MT::BackupRestore::BackupFileHandler;
    my $handler = MT::BackupRestore::BackupFileHandler->new(
        callback           => $callback,
        objects            => $objects,
        deferred           => {},
        errors             => {},
        schema_version     => $schema_version,
        overwrite_template => {},
    );

    my $parser = MT::Util::sax_parser();
    $handler->{is_pp} = ref($parser) eq 'XML::SAX::PurePerl' ? 1 : 0;
    $parser->{Handler} = $handler;

    $parser->parse_string( make_xml($params) );

    return $objects;
}

# Clean up
MT->model('asset')->remove_all;

my $last_restored_asset;
{
    note('Restore an asset for first time.');

    my $params = {
        file_path   => '%s/uploads/test.jpg',
        url         => '%s/uploads/test.jpg',
        label       => 'Test Label',
        description => 'Test Description',
        created_on  => '20121001175056',
    };

    my $objects = parse(
        {   schema_version => $schema_version,
            %$params,
        }
    );

    my $asset = $objects->{'MT::Asset#1'};
    ok( $asset, 'MT::Asset#1 is restored.' );

    my $values = $asset->column_values;
    is_deeply(
        $params,
        { map { $_ => $values->{$_} } keys(%$params) },
        'All parameters were restored.'
    );

    $last_restored_asset = $asset;
}

{
    note(
        'Restore same asset again. but the label and description is updated.'
    );

    my $params = {
        file_path   => '%s/uploads/test.jpg',
        url         => '%s/uploads/test.jpg',
        label       => 'Updated Test Label',
        description => 'Updated Test Description',
        created_on  => '20121001175056',
    };

    my $objects = parse(
        {   schema_version => $schema_version,
            %$params,
        }
    );

    my $asset = $objects->{'MT::Asset#1'};
    ok( $asset, 'MT::Asset#1 is restored.' );
    is( $asset->id, $last_restored_asset->id, 'An object is not created.' );

    my $values = $asset->column_values;
    is_deeply(
        $params,
        { map { $_ => $values->{$_} } keys(%$params) },
        'All parameters were restored.'
    );

    $last_restored_asset = $asset;
}

{
    note(
        'Restore different asset. (an asset has different "created_on" attribute.'
    );

    my $path       = '%s/uploads';
    my $file_name  = 'test.jpg';
    my $created_on = '20131001175056';

    my $params = {
        file_path   => File::Spec->catfile( $path, $file_name ),
        url         => File::Spec->catfile( $path, $file_name ),
        label       => 'Test Label',
        description => 'Test Description',
        created_on  => $created_on,
    };

    my $objects = parse(
        {   schema_version => $schema_version,
            %$params,
        }
    );

    my $asset = $objects->{'MT::Asset#1'};
    ok( $asset, 'MT::Asset#1 is restored.' );
    isnt( $asset->id, $last_restored_asset->id, 'An object is created.' );

    my $values = $asset->column_values;

    delete $params->{file_path};
    is( $values->{file_path},
        File::Spec->catfile( $path, $created_on, $file_name ),
        'file_path is updated. (%s/uploads/$created_on/$file_name)'
    );
    delete $params->{url};
    is( $values->{url},
        File::Spec->catfile( $path, $created_on, $file_name ),
        'url is updated. (%s/uploads/$created_on/$file_name)'
    );

    is_deeply(
        $params,
        { map { $_ => $values->{$_} } keys(%$params) },
        'All other parameters were restored.'
    );

    $last_restored_asset = $asset;
}

done_testing();
