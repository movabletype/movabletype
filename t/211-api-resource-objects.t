#!/usr/bin/perl

use strict;
use warnings;

BEGIN {
    $ENV{MT_CONFIG} = 'mysql-test.cfg';
}

BEGIN {
    use Test::More;
    eval { require YAML::Syck }
        or plan skip_all => 'YAML::Syck is not installed';
}

use lib qw(lib extlib t/lib);

eval(
    $ENV{SKIP_REINITIALIZE_DATABASE}
    ? "use MT::Test;"
    : "use MT::Test qw(:db :data);"
);

use File::Spec;
use File::Basename;

use MT::App::DataAPI;
use MT::DataAPI::Resource;

my $app = MT::App::DataAPI->new;
MT->set_instance($app);
$app->user($app->model('author')->load(1));

if ( !$app->model('placement')->load( { entry_id => 6, category_id => 2 } ) )
{
    my $place = $app->model('placement')->new;
    $place->entry_id(6);
    $place->blog_id(1);
    $place->category_id(2);
    $place->is_primary(0);
    $place->save
        or die "Couldn't save placement record: " . $place->errstr;
}

( my $spec_dir = __FILE__ ) =~ s/t$/d/;
for my $d ( glob( File::Spec->catfile( $spec_dir, '*' ) ) ) {
    my $model = basename($d);
    next if $model eq 'plugins';

    subtest $model => sub {
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

sub from_object {
    my ( $model, $suite ) = @_;

    my $model_class = $app->model($model);

    for my $d (@$suite) {
        note( $d->{note} ) if $d->{note};
        if (my $params = $d->{params}) {
            $app->param($_ => $params->{$_}) for keys %$params;
        }

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
        if (my $params = $d->{params}) {
            $app->param($_ => $params->{$_}) for keys %$params;
        }

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
        my $values = {
            %{ $obj->column_values },
            %{ $obj->meta },
        };

        if ( $d->{not_to} ) {
            foreach my $k ( keys %{ $d->{not_to} } ) {
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
