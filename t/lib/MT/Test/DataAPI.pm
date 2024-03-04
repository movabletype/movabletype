# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#

package MT::Test::DataAPI;

use strict;
use warnings;

use base qw( Exporter );

BEGIN {
    use Test::More;
    eval { require Test::MockModule }
        or plan skip_all => 'Test::MockModule is not installed';

    $ENV{MT_CONFIG} ||= 'mysql-test.cfg';
}

use MT::Test;
use MT::Test::App;

unless ( $ENV{MT_TEST_ROOT} ) {
    MT::Test->init_db;
    MT::Test->init_data;
}

our @EXPORT = qw/ test_data_api /;

use MT::Util;
use MT::App::DataAPI;
use MT::DataAPI::Resource;
use MT::DataAPI::Format;
use Test::Deep qw/cmp_deeply/;
use Data::Visitor::Tiny;

sub test_data_api {
    my ( $suite, $args ) = @_;

    my $app = MT::App::DataAPI->new;

    $app->config->DataAPIDisableSite( '', 1 );
    $app->config->save_config;

    my $is_superuser;
    my $mock_author = Test::MockModule->new('MT::Author');
    $mock_author->mock( 'is_superuser', sub {$is_superuser} );

    my $version;
    my $mock_app_api = Test::MockModule->new('MT::App::DataAPI');
    $mock_app_api->mock( 'current_api_version',
        sub { $version = $_[1] if $_[1]; $version } );

    my %callbacks = ();
    my $mock_mt   = Test::MockModule->new('MT');
    $mock_mt->mock(
        'run_callbacks',
        sub {
            my ( $app, $meth, @param ) = @_;
            $callbacks{$meth} ||= [];
            push @{ $callbacks{$meth} }, \@param;
            $mock_mt->original('run_callbacks')->(@_);
        }
    );

    my $mock_permission = Test::MockModule->new('MT::Permission');

    my $format = MT::DataAPI::Format->find_format('json');

    $suite = [$suite] unless ref $suite eq 'ARRAY';
    if ( my @only = grep { $_->{only} } @$suite ) {
        $suite = \@only;
    }

    my $test_number = 0;

    for my $data (@$suite) {
        my $author;
        if ( $data->{author_id} ) {
            $author = $app->model('author')->load( $data->{author_id} );
        }
        elsif ( !exists( $data->{author_id} ) ) {
            $author = $app->model('author')
                ->load( exists $args->{author_id} ? $args->{author_id} : 1 );
        }

        $is_superuser
            = $author
            ? (
            exists $data->{is_superuser} ? $data->{is_superuser}
            : exists $args->{is_superuser} ? $args->{is_superuser}
            : 0
            )
            : 0;

        $data->{setup}->($data) if $data->{setup};

        my @special_perms = qw/ edit_templates administer_site rebuild /;

        $mock_permission->unmock('can_do')
            if $mock_permission->is_mocked('can_do');
        for (@special_perms) {
            $mock_permission->unmock("can_$_")
                if $mock_permission->is_mocked("can_$_");
        }
        if ( exists $data->{restrictions} ) {
            $mock_permission->mock(
                'can_do',
                sub {
                    my ( $perm, $action ) = @_;
                    my $restrictions
                        = $data->{restrictions}{ $perm->blog_id || 0 };
                    if ( ref $restrictions eq 'ARRAY'
                        && ( grep { $_ eq $action } @$restrictions ) )
                    {
                        return 0;
                    }
                    else {
                        return $mock_permission->original('can_do')->(@_);
                    }
                }
            );

            for my $sp_perm (@special_perms) {
                $mock_permission->mock(
                    "can_$sp_perm",
                    sub {
                        my ($perm) = @_;
                        if ( grep { $_ eq $sp_perm }
                            @{ $data->{restrictions}{ $perm->blog_id || 0 } }
                            )
                        {
                            return;
                        }
                        else {
                            return $mock_permission->original("can_$sp_perm")
                                ->(@_);
                        }
                    },
                );
            }
        }

        my $path = $data->{path};
        $path
            =~ s/:(?:(\w+)_id)|:(\w+)/ref $data->{$1} ? $data->{$1}->id : $data->{$2}/ge;
        if (my $api_version = $ENV{MT_TEST_FORCE_DATAAPI_VERSION}) {
            if (!$data->{up_to} or $api_version <= $data->{up_to}) {
                my ($current) = $path =~ m!^/v(\d)/!;
                $path =~ s!^/v$current/!/v$api_version/! if $current and $current < $api_version;
            }
        }

        my $params
            = ref $data->{params} eq 'CODE'
            ? $data->{params}->($data)
            : $data->{params};

        my $note = $test_number++ . ': ' . $path;
        if ( lc $data->{method} eq 'get' && $data->{params} ) {
            $note .= '?'
                . join( '&',
                map { $_ . '=' . $data->{params}{$_} }
                sort keys %{ $data->{params} } );
        }
        $note .= ' ' . $data->{method};
        $note .= ' ' . $data->{note} if $data->{note};

        if ( $data->{skip} ) {
            note "SKIP: ". $note;
            next;
        }

        subtest $note => sub {

            if ( $data->{config} ) {
                for my $k ( keys %{ $data->{config} } ) {
                    $app->config->$k( $data->{config}{$k} );
                }
            }
            if ( $data->{request_headers} ) {
                for my $k ( keys %{ $data->{request_headers} } ) {
                    $ENV{ 'HTTP_' . uc $k } = $data->{request_headers}{$k};
                }
            }

            local $SIG{__DIE__} = sub { my $error = shift; fail Carp::longmess("$0 died: $error") unless $error =~ /Can't locate/ };
            local $ENV{MT_TEST_RUN_APP_AS_CGI};    ## MT::Test::DataAPI mocks too much

            %callbacks = ();
            my $app = MT::Test::App->new('DataAPI');
            $app->login($author) if $author;
            my $res = $app->request({
                __path_info      => $path,
                __request_method => $data->{method},
                (   $data->{upload}
                    ? ( __test_upload => $data->{upload} )
                    : ()
                ),
                (   $params
                    ? map {
                        $_ => ref $params->{$_}
                            ? MT::Util::to_json( $params->{$_},
                            { canonical => 1 } )
                            : $params->{$_};
                        }
                        keys %{$params}
                    : ()
                ),
            });
            my %headers = $res->headers->flatten;
            $headers{lc $_} = delete $headers{$_} for keys %headers;
            my $body    = $res->decoded_content;
            my $expected_status = $data->{code} || 200;
            is( $res->code, $expected_status, 'Status ' . $expected_status );
            if ( $data->{next_phase_url} ) {
                like(
                    $headers{'x-mt-next-phase-url'},
                    $data->{next_phase_url},
                    'X-MT-Next-Phase-URL'
                );
            }

            foreach my $cb ( @{ $data->{callbacks} } ) {
                my $params_list = $callbacks{ $cb->{name} } || [];
                if ( my $params = $cb->{params} ) {
                    for ( my $i = 0; $i < scalar(@$params); $i++ ) {
                        cmp_deeply( $params_list->[$i], $cb->{params}[$i] );
                    }
                }

                if ( defined( my $c = $cb->{count} ) ) {
                    is( @$params_list, $c,
                        $cb->{name} . ' was called ' . $c . ' time(s)' );
                }
            }

            my $result;
            if ( my $expected_result = $data->{result} ) {
                MT->instance->user($author);
                no warnings 'redefine';
                local *boolean::true  = sub {$JSON::true};
                local *boolean::false = sub {$JSON::false};

                $expected_result = $expected_result->( $data, $body )
                    if ref $expected_result eq 'CODE';
                if ( UNIVERSAL::isa( $expected_result, 'MT::Object' ) ) {
                    $expected_result = $format->{unserialize}->(
                        $format->{serialize}->(
                            MT::DataAPI::Resource->from_object($expected_result)
                        )
                    );
                }

                $result = $format->{unserialize}->($body);

                if (lc($ENV{MT_TEST_BACKEND} // '') eq 'oracle') {
                    visit(
                        [$result, $expected_result],
                        sub {
                            my ($key, $valueref) = @_;
                            $$valueref = '' unless defined $$valueref;
                        });
                }

                cmp_deeply( $result, $expected_result, 'result' ) || note explain $result;
            }

            if ( exists $data->{error} ) {
                $result = $format->{unserialize}->($body) if !defined $result;
                if ( ref $data->{error} eq ref qr// ) {
                    like( $result->{error}{message},
                        $data->{error}, 'error: ' . $data->{error} );
                }
                else {
                    is( $result->{error}{message},
                        $data->{error}, 'error: ' . $data->{error} );
                }
            }

            if ( my $complete = $data->{complete} ) {
                $complete->( $data, $body, \%headers );
            }
        };
    }
}

1;
