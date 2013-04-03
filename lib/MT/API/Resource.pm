package MT::API::Resource;

use strict;
use warnings;

sub from_object {
    my ( $class, $app, $obj, $fields_specified ) = @_;

    # TODO if not found
    my $resource_data = $app->resource($obj)
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
                @vals = $f->{from_object}->( $app, $obj, \%hash, $f );
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
    my ( $class, $app, $name, $hash, $original ) = @_;

    # TODO if not found
    my $resource_data = $app->resource($name)
        or return;

    my @fields = do {
        my @fs = @{ $resource_data->{updatable_fields} };
        grep {
            my $name = ref($_) ? $_->{name} : $_;
            grep { $_ eq $name } @fs
        } @{ $resource_data->{fields} };
    };

    my $obj = $original ? $original->clone : $app->model($name)->new;
    my %values = ();
    for my $f (@fields) {
        my $ref = ref $f;
        if ( !$ref ) {
            if ( exists( $hash->{$f} ) ) {
                $values{$f} = $hash->{$f};
            }
        }
        elsif ( $ref eq 'HASH' ) {
            if (! exists($hash->{ $f->{name} })) {
                # Do nothing
            }
            elsif ( exists $f->{to_object} ) {
                my @vals = $f->{to_object}->( $app, $hash, $obj, $f );
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
