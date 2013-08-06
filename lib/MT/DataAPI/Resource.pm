# Movable Type (r) (C) 2001-2013 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Resource;

use strict;
use warnings;

our %resources = ();

sub core_resources {
    my $pkg = '$Core::MT::DataAPI::Resource::';
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
        'tbping' => 'trackback',
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
        'asset' => {
            fields           => "${pkg}Asset::fields",
            updatable_fields => "${pkg}Asset::updatable_fields",
        },
        'permission' => {
            fields           => "${pkg}Permission::fields",
            updatable_fields => "${pkg}Permission::updatable_fields",
        },
    };
}

sub resource {
    my $class = shift;
    my ($key) = @_;
    my $app   = MT->instance;

    if ( !%resources ) {
        my %aliases = ();
        my $regs = MT::Component->registry( 'applications', 'data_api',
            'resources' );
        for my $reg (@$regs) {
            for my $k ( keys %$reg ) {
                if ( ref $reg->{$k} ) {
                    $resources{$k} ||= { aliases => [], };

                    push @{ $resources{$k}{aliases} },
                        {
                        key    => $k,
                        plugin => $reg->{$k}{plugin},
                        };
                }
                else {
                    $aliases{$k} = $reg->{$k};
                }
            }
        }

        for my $k ( keys %aliases ) {
            if ( $resources{$k} ) {
                push @{ $resources{ $aliases{$k} }{aliases} },
                    @{ $resources{$k}{aliases} };
            }
            $resources{$k} = $aliases{$k};
        }
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
        next unless $k;
        $resource_key = $k;
        $res = $resources{$k} and last;
    }

    return unless $res;

    if ( !ref $res ) {
        $resources{$resource_key} = $res = $class->resource($res);
    }

    return unless $res;

    if ( !$res->{fields} ) {
        my %tmp_res = ();
        for my $k (qw(fields updatable_fields)) {
            $tmp_res{$k} = [
                map {
                    my $reg
                        = $_->{plugin}->registry( 'applications', 'data_api',
                        'resources', $_->{key}, $k );
                    $reg ? @$reg : ();
                } @{ $res->{aliases} }
            ];
        }

        $res->{fields} = [];
        {
            my %fields = ();

            for my $f ( @{ $tmp_res{fields} } ) {
                my $ref = ref $f;
                if ( !$ref ) {
                    ( my $alias = $f ) =~ s/([A-Z])/_\l$1/g;
                    $f = { name => $f, alias => $alias };
                }
                elsif ( $ref eq 'HASH' ) {
                    if ( my $type = $f->{type} ) {
                        $type = 'MT::DataAPI::Resource::DataType::' . $type
                            unless $type =~ m/:/;
                        eval "require $type;";
                        for my $mtype (qw(from_object to_object)) {
                            if ( my $method = $type->can($mtype) ) {
                                $f->{ 'type_' . $mtype } = $method;
                            }
                        }
                    }

                    for my $k (qw(bulk_from_object from_object to_object)) {
                        if ( my $handler = $f->{$k} ) {
                            $f->{$k} = MT->handler_to_coderef($handler);
                        }
                    }
                }

                if ( my $hash = $fields{ $f->{name} } ) {
                    for my $k ( keys %$f ) {
                        $hash->{$k} = $f->{$k};
                    }
                }
                else {
                    $fields{ $f->{name} } = $f;
                    push @{ $res->{fields} }, $f;
                }
            }
        }
        $res->{field_name_map}
            = +{ map { $_->{name} => $_->{alias} || $_->{name} }
                @{ $res->{fields} } };

        $res->{updatable_fields} = [];
        {
            my %fields = ();

            for my $f ( @{ $tmp_res{updatable_fields} } ) {
                if ( !ref $f ) {
                    $f = { name => $f };
                }

                if ( my $hash = $fields{ $f->{name} } ) {
                    for my $k ( keys %$f ) {
                        $hash->{$k} = $f->{$k};
                    }
                }
                else {
                    $fields{ $f->{name} } = $f;
                    push @{ $res->{updatable_fields} }, $f;
                }
            }
        }
    }

    $res;
}

sub _is_condition_ok {
    my ($f) = @_;
    return 1 unless exists $f->{condition};    # not specified
    return 0 unless $f->{condition};           # "0" had been specified
    if ( !ref( $f->{condition} ) ) {
        $f->{condition}
            = MT->handler_to_coderef( $f->{condition} );
    }
    $f->{condition}->();
}

sub from_object {
    my $class = shift;
    my ( $objs, $fields_specified ) = @_;
    my $is_list = 1;

    if ( UNIVERSAL::isa( $objs, 'MT::Object' ) ) {
        $is_list = 0;
        $objs    = [$objs];
    }
    elsif (
        UNIVERSAL::isa( $objs, 'MT::DataAPI::Resource::Type::ObjectList' ) )
    {
        $objs = $objs->content;
    }

    return [] unless @$objs;

    my $resource_data = $class->resource( $objs->[0] )
        or return;

    my @fields = grep { _is_condition_ok($_) } do {
        if ($fields_specified) {
            my %keys = map { $_ => 1 } @$fields_specified;
            grep { $keys{ $_->{name} } } @{ $resource_data->{fields} };
        }
        else {
            @{ $resource_data->{fields} };
        }
    };

    my $objs_count = scalar(@$objs);
    my @hashs      = map { +{} } 0 .. $#$objs;
    my $stash      = {};

    for my $f (@fields) {
        if ( $f->{bulk_from_object} ) {
            $f->{bulk_from_object}->( $objs, \@hashs, $f, $stash );
        }
        else {
            my $i;
            my $name        = $f->{name};
            my $has_default = exists $f->{from_object_default};
            my $default     = $f->{from_object_default};

            # Prepare method to fetching value, outside of the loop
            my $method = do {
                if ( exists $f->{from_object} ) {
                    sub {
                        $f->{from_object}->( $_[0], $hashs[$i], $f, $stash );
                    };
                }
                else {
                    $objs->[0]->can( $f->{alias} || $name );
                }
                }
                || sub { };

            for ( $i = 0; $i < $objs_count; $i++ ) {
                my @vals = $method->( $objs->[$i] );
                if ( @vals || $has_default ) {
                    $hashs[$i]{$name}
                        = defined( $vals[0] ) ? $vals[0] : $default;
                }
            }
        }
    }

    for my $f (@fields) {
        if ( ref $f && $f->{type_from_object} ) {
            $f->{type_from_object}->( $objs, \@hashs, $f, $stash );
        }
    }

    $is_list ? \@hashs : $hashs[0];
}

sub to_object {
    my $class = shift;
    my ( $name, $hashs, $originals ) = @_;
    my $is_list = 1;

    if ( ref $hashs eq 'HASH' ) {
        $is_list = 0;
        $hashs   = [$hashs];
    }

    return [] unless @$hashs;

    my $resource_data = $class->resource($name)
        or return;

    my @fields = do {
        my %keys = map { _is_condition_ok($_) ? ( $_->{name} => 1 ) : () }
            @{ $resource_data->{updatable_fields} };

        grep { $keys{ $_->{name} } && _is_condition_ok($_) }
            @{ $resource_data->{fields} };
    };

    my $model_class = MT->model($name);
    my @objs        = map {
        my $obj
            = $originals
            ? ref $originals eq 'ARRAY'
                ? $originals->[$_]->clone
                : $originals->clone
            : $model_class->new;

    } 0 .. $#$hashs;
    my $objs_count = scalar(@$hashs);
    my $stash      = {};

    for my $f (@fields) {
        my $name        = $f->{name};
        my $has_default = exists $f->{to_object_default};
        my $default     = $f->{to_object_default};

        for ( my $i = 0; $i < $objs_count; $i++ ) {
            my $hash = $hashs->[$i];
            my $obj  = $objs[$i];

            my @vals = ();
            if ( !exists( $hash->{$name} ) ) {

                # Do nothing
            }
            elsif ( exists $f->{to_object} ) {
                @vals = $f->{to_object}->( $hash, $obj, $f, $stash );
            }
            else {
                @vals = ( $hash->{$name} );
            }

            if ( @vals || $has_default ) {
                my $k = $f->{alias} || $name;
                $obj->$k( defined( $vals[0] ) ? $vals[0] : $default );
            }
        }
    }

    for my $f (@fields) {
        if ( ref $f && $f->{type_to_object} ) {
            $f->{type_to_object}->( $hashs, \@objs, $f, $stash );
        }
    }

    $is_list ? \@objs : $objs[0];
}

# MT::DataAPI::Resource::Type
package MT::DataAPI::Resource::Type::Raw;

sub new {
    my $self = [ $_[1] ];
    bless $self, $_[0];
    $self;
}

sub content {
    $_[0]->[0];
}

package MT::DataAPI::Resource::Type::ObjectList;

use base qw(MT::DataAPI::Resource::Type::Raw);

# MT::DataAPI::Resource::DataType
package MT::DataAPI::Resource::DataType::Object;

sub from_object {
    my ( $objs, $hashs, $f ) = @_;
    my $name = $f->{name};
    foreach my $h (@$hashs) {
        $h->{$name}
            = MT::DataAPI::Resource->from_object( $h->{$name}, $f->{fields} )
            if defined $h->{$name};
    }
}

sub to_object {
    my ( $hashs, $objs, $f ) = @_;
    my $name = $f->{alias} || $f->{name};
    foreach my $o (@$objs) {
        $o->$name( MT::DataAPI::Resource->to_object( $name, $o->$name ) )
            if defined $o->$name;
    }
}

package MT::DataAPI::Resource::DataType::Integer;

sub from_object {
    my ( $objs, $hashs, $f ) = @_;
    my $name = $f->{name};
    foreach my $h (@$hashs) {
        $h->{$name} = int $h->{$name} if defined $h->{$name};
    }
}

sub to_object {
    my ( $hashs, $objs, $f ) = @_;
    my $name = $f->{alias} || $f->{name};
    foreach my $o (@$objs) {
        $o->$name( int $o->$name ) if defined $o->$name;
    }
}

package MT::DataAPI::Resource::DataType::Boolean;

use boolean ();

sub from_object {
    my ( $objs, $hashs, $f ) = @_;
    my $name = $f->{name};
    foreach my $h (@$hashs) {
        $h->{$name} = $h->{$name} ? boolean::true() : boolean::false();
    }
}

sub to_object {
    my ( $hashs, $objs, $f ) = @_;
    my $name = $f->{alias} || $f->{name};
    foreach my $o (@$objs) {
        $o->$name( $o->$name ? 1 : 0 ) if defined $o->$name;
    }
}

package MT::DataAPI::Resource::DataType::ISO8601;

sub from_object {
    my ( $objs, $hashs, $f ) = @_;
    my %blogs    = ();
    my @blog_ids = ();
    if ( $objs->[0]->isa('MT::Blog') ) {
        $blogs{ $_->id } = $_ for @$objs;
        @blog_ids = map { $_->id } @$objs;
    }
    else {
        @blog_ids = map { $_->blog_id } @$objs;
        my @blogs = MT->model('blog')->load( { id => \@blog_ids, } );
        $blogs{ $_->id } = $_ for @blogs;
    }

    my $size = scalar(@$objs);
    my $name = $f->{name};
    for ( my $i = 0; $i < $size; $i++ ) {
        my $h = $hashs->[$i];
        $h->{$name}
            = MT::Util::ts2iso( $blogs{ $blog_ids[$i] }, $h->{$name}, 1 );
    }
}

sub to_object {
    my ( $hashs, $objs, $f ) = @_;
    my %blogs    = ();
    my @blog_ids = ();
    if ( $objs->[0]->isa('MT::Blog') ) {
        $blogs{ $_->id } = $_ for @$objs;
        @blog_ids = map { $_->id } @$objs;
    }
    else {
        @blog_ids = map { $_->blog_id || () } @$objs
            or return;
        my @blogs = MT->model('blog')->load( { id => \@blog_ids, } );
        $blogs{ $_->id } = $_ for @blogs;
    }

    my $size = scalar(@$objs);
    my $name = $f->{alias} || $f->{name};
    for ( my $i = 0; $i < $size; $i++ ) {
        my $o = $objs->[$i];
        next unless $o->{changed_cols}->{$name} && $o->$name;
        my $ts = MT::Util::iso2ts( $blogs{ $blog_ids[$i] }, $o->$name );
        if ($ts) {
            $o->$name($ts);
        }
        else {
            $o->error(
                MT->translate(
                    'Cannot parse "[_1]" as ISO 8601 date-time',
                    $o->$name
                )
            );
        }
    }
}

1;
