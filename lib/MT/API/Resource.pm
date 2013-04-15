package MT::API::Resource;

use strict;
use warnings;

our (%resources) = ();

sub core_resources {
    my $pkg = '$Core::MT::API::Resource::';
    return {
        'entry' => {
            fields           => "${pkg}Entry::fields",
            updatable_fields => "${pkg}Entry::updatable_fields",
        },
        'category' => {
            fields           => "${pkg}Category::fields",
            updatable_fields => "${pkg}Category::updatable_fields",
        },
        'comment' => {
            fields           => "${pkg}Comment::fields",
            updatable_fields => "${pkg}Comment::updatable_fields",
        },
        'trackback' => {
            fields           => "${pkg}Trackback::fields",
            updatable_fields => "${pkg}Trackback::updatable_fields",
        },
        'tbping' => 'tbping',
        'user'   => {
            fields           => "${pkg}User::fields",
            updatable_fields => "${pkg}User::updatable_fields",
        },
        'author' => 'user',
        'blog'   => {
            fields           => "${pkg}Blog::fields",
            updatable_fields => "${pkg}Blog::updatable_fields",
        },
        'website' => {
            fields           => "${pkg}Website::fields",
            updatable_fields => "${pkg}Website::updatable_fields",
        },
    };
}

sub resource {
    my $class = shift;
    my ($key) = @_;
    my $app   = MT->instance;

    if ( !%resources ) {
        my $reg = $app->registry( 'applications', 'api', 'resources' );
        %resources
            = map { $_ => ref( $reg->{$_} ) ? +{} : $reg->{$_} } keys %$reg;
    }

    my $res;
    my $resource_key;
    for my $k (
        ref $key
        ? ( $key->class_type || '',
            $key->datasource . '.' . ( $key->class_type || '' ),
            $key->datasource
        )
        : ($key)
        )
    {

        $resource_key = $k;
        $res = $resources{$k} and last;
    }

    return unless $res;

    if ( !ref $res ) {
        $resources{$resource_key} = $res = $class->resource($res);
    }

    return unless $res;

    if ( !$res->{fields} ) {
        for my $k (qw(fields updatable_fields)) {
            $res->{$k} = [
                map {@$_} @{
                    $app->registry(
                        'applications', 'api',
                        'resources',    $resource_key,
                        $k
                    )
                }
            ];
        }
    }

    $res;
}

sub from_object {
    my $class = shift;
    my ( $obj, $fields_specified ) = @_;

    my $resource_data = $class->resource($obj)
        or return;

    my @fields = do {
        if ($fields_specified) {
            my @fs = split /,/, $fields_specified;
            grep {
                my $name = ref($_) ? $_->{name} : $_;
                grep { $_ eq $name } @fs
            } @{ $resource_data->{fields} };
        }
        else {
            @{ $resource_data->{fields} };
        }
    };

    my %hash = ();
    for my $f (@fields) {
        my $ref  = ref $f;
        my @vals = ();
        my $name = $f;

        if ( !$ref ) {
            @vals = $obj->$f;
        }
        elsif ( $ref eq 'HASH' ) {
            $name = $f->{name};
            if ( exists $f->{from_object} ) {
                @vals = $f->{from_object}->( $obj, \%hash, $f );
            }
            elsif ( my $alias = $f->{alias} ) {
                @vals = $obj->$alias;
            }
        }

        if (@vals) {
            $hash{$name} = $vals[0];
        }
    }
    \%hash;
}

sub to_object {
    my $class = shift;
    my ( $name, $hash, $original ) = @_;

    my $resource_data = $class->resource($name)
        or return;

    my @fields = do {
        my @fs = @{ $resource_data->{updatable_fields} };
        grep {
            my $name = ref($_) ? $_->{name} : $_;
            grep { $_ eq $name } @fs
        } @{ $resource_data->{fields} };
    };

    my $obj = $original ? $original->clone : MT->model($name)->new;
    my %values = ();
    for my $f (@fields) {
        my $ref = ref $f;
        if ( !$ref ) {
            if ( exists( $hash->{$f} ) ) {
                $values{$f} = $hash->{$f};
            }
        }
        elsif ( $ref eq 'HASH' ) {
            if ( !exists( $hash->{ $f->{name} } ) ) {

                # Do nothing
            }
            elsif ( exists $f->{to_object} ) {
                my @vals = $f->{to_object}->( $hash, $obj, $f );
                if (@vals) {
                    $values{ $f->{alias} || $f->{name} } = $vals[0];
                }
            }
            elsif ( my $alias = $f->{alias} ) {
                $values{$alias} = $hash->{ $f->{name} };
            }
        }
    }
    $obj->set_values( \%values );

    $obj;
}

1;
