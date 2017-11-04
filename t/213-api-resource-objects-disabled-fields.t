#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/lib"; # t/lib
use Test::More;
use MT::Test::Env;
BEGIN {
    eval { require YAML::Syck }
        or plan skip_all => 'YAML::Syck is not installed';
    eval { require Test::MockModule }
        or plan skip_all => 'Test::MockModule is not installed';
}

our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use File::Spec;
use File::Copy;

# Disable Commercial.pack temporarily.
BEGIN {
    my $commercialpack_config
        = File::Spec->catfile(qw/ addons Commercial.pack config.yaml /);
    my $commercialpack_config_rename
        = File::Spec->catfile(
        qw/ addons Commercial.pack config.yaml.disabled /);

    if ( -f $commercialpack_config ) {
        move( $commercialpack_config, $commercialpack_config_rename )
            or plan skip_all => "$commercialpack_config cannot be moved.";
    }
}

# Recover Commercial.pack.
END {
    my $commercialpack_config
        = File::Spec->catfile(qw/ addons Commercial.pack config.yaml /);
    my $commercialpack_config_rename
        = File::Spec->catfile(
        qw/ addons Commercial.pack config.yaml.disabled /);

    if ( -f $commercialpack_config_rename ) {
        move( $commercialpack_config_rename, $commercialpack_config );
    }
}

use File::Spec;
use File::Basename;

use MT::Test;
use MT::App::DataAPI;
use MT::DataAPI::Resource;

$test_env->prepare_fixture('db_data');

my $app = MT::App::DataAPI->new;
MT->set_instance($app);
my $author = $app->model('author')->load(1);
$app->user($author);
{
    ( my $base = __FILE__ ) =~ s/\.t$/.d/;
    $app->_init_plugins_core( {}, 1,
        [ File::Spec->join( $base, 'plugins' ) ] );
}
$app->current_api_version(1);

$app->param( 'maxComments',   9999 );
$app->param( 'maxTrackbacks', 9999 );

my $disabled_fields = $app->config->DisableResourceField;
$disabled_fields->{entry} = 'title,excerpt';
$disabled_fields->{asset} = 'description';

( my $spec_dir = __FILE__ ) =~ s/t$/d/;
my @specs = (
    {   label        => 'authenticated',
        is_anonymous => 0,
    },
    {   label        => 'non-authenticated',
        is_anonymous => 1,
    },
);

for my $s (@specs) {
    for my $d ( glob( File::Spec->catfile( $spec_dir, $s->{label}, '*' ) ) ) {
        my $model = basename($d);
        next if $model eq 'plugins';

        subtest $model . ': ' . $s->{label} => sub {
            my $mock_author = Test::MockModule->new('MT::Author');
            $mock_author->mock( 'is_anonymous', sub { $s->{is_anonymous} } );

            for my $k (qw(from_object to_object)) {
                my $yaml = File::Spec->catfile( $d, $k . '.yaml' );
                if ( -e $yaml ) {
                    my $suite = YAML::Syck::LoadFile($yaml);
                    subtest $k => sub {
                        no strict 'refs';
                        $k->( $model, $suite );
                        done_testing();
                    };
                }
            }

            done_testing();
        };
    }
}

sub from_object {
    my ( $model, $suite ) = @_;

    my $model_class = $app->model($model);

    for my $d (@$suite) {
        note( $d->{note} ) if $d->{note};
        my $obj = do {
            if ( ref $d->{from} ) {
                my $obj = $model_class->new;
                $obj->set_values( $d->{from} );
                $obj;
            }
            else {
                $model_class->load( $d->{from} );
            }
        };
        my $hash = MT::DataAPI::Resource->from_object($obj);
        delete $hash->{customFields};
        is_deeply( $hash, $d->{to}, 'converted data' );
    }
}

sub to_object {
    my ( $model, $suite ) = @_;

    my $model_class = $app->model($model);

    for my $d (@$suite) {
        note( $d->{note} ) if $d->{note};

        my ( $original, $expected_values );
        if ( $d->{original} ) {
            $original = $model_class->new;
            $original->set_values( $d->{original} );
            $expected_values = $original->column_values;
        }
        else {
            $expected_values = $model_class->new->column_values;
        }

        my $obj
            = MT::DataAPI::Resource->to_object( $model, $d->{from},
            $original );
        my $values = { %{ $obj->column_values }, %{ $obj->meta }, };

        if ( $d->{not_to} ) {
            foreach my $k ( sort keys %{ $d->{not_to} } ) {
                delete $expected_values->{$k};
                my $value = delete $values->{$k};
                isnt( $value, $d->{not_to}{$k}, 'converted data:' . $k );
            }
        }

        if ( my $tags = delete $d->{to}{tags} ) {
            is_deeply( [ $obj->tags ], $tags, 'converted data: tags' );
        }

        foreach my $k ( keys %{ $d->{to} } ) {
            $expected_values->{$k} = $d->{to}{$k};
        }
        is_deeply( $values, $expected_values, 'converted data' );
    }
}

done_testing();
