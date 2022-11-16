# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Resource;

use strict;
use warnings;

our %resources = ();

sub core_resources {
    return {
        'entry' => [{
                version          => 1,
                fields           => '$Core::MT::DataAPI::Resource::v1::Entry::fields',
                updatable_fields => '$Core::MT::DataAPI::Resource::v1::Entry::updatable_fields',
            },
            {
                version          => 2,
                fields           => '$Core::MT::DataAPI::Resource::v2::Entry::fields',
                updatable_fields => '$Core::MT::DataAPI::Resource::v2::Entry::updatable_fields',
            },
            {
                version          => 5,
                fields           => '$Core::MT::DataAPI::Resource::v5::Entry::fields',
                updatable_fields => '$Core::MT::DataAPI::Resource::v5::Entry::updatable_fields',
            },
        ],
        'page' => [{
                version          => 2,
                fields           => '$Core::MT::DataAPI::Resource::v2::Page::fields',
                updatable_fields => '$Core::MT::DataAPI::Resource::v2::Page::updatable_fields',
            },
            {
                version          => 5,
                fields           => '$Core::MT::DataAPI::Resource::v5::Page::fields',
                updatable_fields => '$Core::MT::DataAPI::Resource::v5::Page::updatable_fields',
            },
        ],
        'category' => [{
                version          => 1,
                fields           => '$Core::MT::DataAPI::Resource::v1::Category::fields',
                updatable_fields => '$Core::MT::DataAPI::Resource::v1::Category::updatable_fields',
            },
            {
                version          => 2,
                fields           => '$Core::MT::DataAPI::Resource::v2::Category::fields',
                updatable_fields => '$Core::MT::DataAPI::Resource::v2::Category::updatable_fields',
            },
            {
                version          => 5,
                fields           => '$Core::MT::DataAPI::Resource::v5::Category::fields',
                updatable_fields => '$Core::MT::DataAPI::Resource::v5::Category::updatable_fields',
            },
        ],
        'folder' => [{
                version          => 2,
                fields           => '$Core::MT::DataAPI::Resource::v2::Folder::fields',
                updatable_fields => '$Core::MT::DataAPI::Resource::v2::Folder::updatable_fields',
            },
            {
                version          => 5,
                fields           => '$Core::MT::DataAPI::Resource::v5::Folder::fields',
                updatable_fields => '$Core::MT::DataAPI::Resource::v5::Folder::updatable_fields',
            },
        ],
        'user' => [{
                version          => 1,
                fields           => '$Core::MT::DataAPI::Resource::v1::User::fields',
                updatable_fields => '$Core::MT::DataAPI::Resource::v1::User::updatable_fields',
            },
            {
                version          => 2,
                fields           => '$Core::MT::DataAPI::Resource::v2::User::fields',
                updatable_fields => '$Core::MT::DataAPI::Resource::v2::User::updatable_fields',
            },
            {
                version          => 3,
                fields           => '$Core::MT::DataAPI::Resource::v3::User::fields',
                updatable_fields => '$Core::MT::DataAPI::Resource::v3::User::updatable_fields',
            },
            {
                version          => 5,
                fields           => '$Core::MT::DataAPI::Resource::v5::User::fields',
                updatable_fields => '$Core::MT::DataAPI::Resource::v5::User::updatable_fields',
            },
        ],
        'author' => 'user',
        'blog'   => [{
                version          => 1,
                fields           => '$Core::MT::DataAPI::Resource::v1::Blog::fields',
                updatable_fields => '$Core::MT::DataAPI::Resource::v1::Blog::updatable_fields',
            },
            {
                version          => 2,
                fields           => '$Core::MT::DataAPI::Resource::v2::Blog::fields',
                updatable_fields => '$Core::MT::DataAPI::Resource::v2::Blog::updatable_fields',
            },
            {
                version          => 3,
                fields           => '$Core::MT::DataAPI::Resource::v3::Blog::fields',
                updatable_fields => '$Core::MT::DataAPI::Resource::v3::Blog::updatable_fields',
            },
            {
                version          => 4,
                fields           => '$Core::MT::DataAPI::Resource::v4::Blog::fields',
                updatable_fields => '$Core::MT::DataAPI::Resource::v4::Blog::updatable_fields',
            },
            {
                version          => 5,
                fields           => '$Core::MT::DataAPI::Resource::v5::Blog::fields',
                updatable_fields => '$Core::MT::DataAPI::Resource::v5::Blog::updatable_fields',
            },
        ],
        'website' => [{
                version          => 1,
                fields           => '$Core::MT::DataAPI::Resource::v1::Website::fields',
                updatable_fields => '$Core::MT::DataAPI::Resource::v1::Website::updatable_fields',
            },
            {
                version          => 2,
                fields           => '$Core::MT::DataAPI::Resource::v2::Website::fields',
                updatable_fields => '$Core::MT::DataAPI::Resource::v2::Website::updatable_fields',
            },
            {
                version          => 3,
                fields           => '$Core::MT::DataAPI::Resource::v3::Website::fields',
                updatable_fields => '$Core::MT::DataAPI::Resource::v3::Website::updatable_fields',
            },
            {
                version          => 4,
                fields           => '$Core::MT::DataAPI::Resource::v4::Website::fields',
                updatable_fields => '$Core::MT::DataAPI::Resource::v4::Website::updatable_fields',
            },
            {
                version          => 5,
                fields           => '$Core::MT::DataAPI::Resource::v5::Website::fields',
                updatable_fields => '$Core::MT::DataAPI::Resource::v5::Website::updatable_fields',
            },
        ],
        'asset' => [{
                version          => 1,
                fields           => '$Core::MT::DataAPI::Resource::v1::Asset::fields',
                updatable_fields => '$Core::MT::DataAPI::Resource::v1::Asset::updatable_fields',
            },
            {
                version          => 2,
                fields           => '$Core::MT::DataAPI::Resource::v2::Asset::fields',
                updatable_fields => '$Core::MT::DataAPI::Resource::v2::Asset::updatable_fields',
            },
            {
                version          => 5,
                fields           => '$Core::MT::DataAPI::Resource::v5::Asset::fields',
                updatable_fields => '$Core::MT::DataAPI::Resource::v5::Asset::updatable_fields',
            },
        ],
        'permission' => [{
                version          => 1,
                fields           => '$Core::MT::DataAPI::Resource::v1::Permission::fields',
                updatable_fields => '$Core::MT::DataAPI::Resource::v1::Permission::updatable_fields',
            },
            {
                version          => 2,
                fields           => '$Core::MT::DataAPI::Resource::v2::Permission::fields',
                updatable_fields => '$Core::MT::DataAPI::Resource::v2::Permission::updatable_fields',
            },
            {
                version          => 5,
                fields           => '$Core::MT::DataAPI::Resource::v5::Permission::fields',
                updatable_fields => '$Core::MT::DataAPI::Resource::v5::Permission::updatable_fields',
            },
        ],
        'association' => [{
                version          => 2,
                fields           => '$Core::MT::DataAPI::Resource::v2::Association::fields',
                updatable_fields => '$Core::MT::DataAPI::Resource::v2::Association::updatable_fields',
            },
            {
                version          => 5,
                fields           => '$Core::MT::DataAPI::Resource::v5::Association::fields',
                updatable_fields => '$Core::MT::DataAPI::Resource::v5::Association::updatable_fields',
            },
        ],
        'role' => [{
                version          => 2,
                fields           => '$Core::MT::DataAPI::Resource::v2::Role::fields',
                updatable_fields => '$Core::MT::DataAPI::Resource::v2::Role::updatable_fields',
            },
        ],
        'log' => [{
                version          => 2,
                fields           => '$Core::MT::DataAPI::Resource::v2::Log::fields',
                updatable_fields => '$Core::MT::DataAPI::Resource::v2::Log::updatable_fields',
            },
            {
                version          => 5,
                fields           => '$Core::MT::DataAPI::Resource::v5::Log::fields',
                updatable_fields => '$Core::MT::DataAPI::Resource::v5::Log::updatable_fields',
            },
        ],
        'tag' => [{
                version          => 2,
                fields           => '$Core::MT::DataAPI::Resource::v2::Tag::fields',
                updatable_fields => '$Core::MT::DataAPI::Resource::v2::Tag::updatable_fields',
            },
            {
                version => 5,
                fields  => '$Core::MT::DataAPI::Resource::v5::Tag::fields',
            },
        ],
        'template' => [{
                version          => 2,
                fields           => '$Core::MT::DataAPI::Resource::v2::Template::fields',
                updatable_fields => '$Core::MT::DataAPI::Resource::v2::Template::updatable_fields',
            },
            {
                version          => 4,
                fields           => '$Core::MT::DataAPI::Resource::v4::Template::fields',
                updatable_fields => '$Core::MT::DataAPI::Resource::v4::Template::updatable_fields',
            },
            {
                version          => 5,
                fields           => '$Core::MT::DataAPI::Resource::v5::Template::fields',
                updatable_fields => '$Core::MT::DataAPI::Resource::v5::Template::updatable_fields',
            },
        ],
        'widget'      => 'template',
        'templatemap' => [{
                version          => 2,
                fields           => '$Core::MT::DataAPI::Resource::v2::TemplateMap::fields',
                updatable_fields => '$Core::MT::DataAPI::Resource::v2::TemplateMap::updatable_fields',
            },
            {
                version          => 5,
                fields           => '$Core::MT::DataAPI::Resource::v5::TemplateMap::fields',
                updatable_fields => '$Core::MT::DataAPI::Resource::v5::TemplateMap::updatable_fields',
            },
        ],
        'category_set' => [{
                version          => 4,
                fields           => '$Core::MT::DataAPI::Resource::v4::CategorySet::fields',
                updatable_fields => '$Core::MT::DataAPI::Resource::v4::CategorySet::updatable_fields',
            },
            {
                version          => 5,
                fields           => '$Core::MT::DataAPI::Resource::v5::CategorySet::fields',
                updatable_fields => '$Core::MT::DataAPI::Resource::v5::CategorySet::updatable_fields',
            },
        ],
        'content_type' => [{
                version          => 4,
                fields           => '$Core::MT::DataAPI::Resource::v4::ContentType::fields',
                updatable_fields => '$Core::MT::DataAPI::Resource::v4::ContentType::updatable_fields',
            },
            {
                version          => 5,
                fields           => '$Core::MT::DataAPI::Resource::v5::ContentType::fields',
                updatable_fields => '$Core::MT::DataAPI::Resource::v5::ContentType::updatable_fields',
            },
        ],
        'cf' => [{
                version          => 4,
                fields           => '$Core::MT::DataAPI::Resource::v4::ContentField::fields',
                updatable_fields => '$Core::MT::DataAPI::Resource::v4::ContentField::updatable_fields',
            },
            {
                version          => 5,
                fields           => '$Core::MT::DataAPI::Resource::v5::ContentField::fields',
                updatable_fields => '$Core::MT::DataAPI::Resource::v5::ContentField::updatable_fields',
            },

        ],
        'content_field' => 'cf',
        'cd'            => [{
                version          => 4,
                fields           => '$Core::MT::DataAPI::Resource::v4::ContentData::fields',
                updatable_fields => '$Core::MT::DataAPI::Resource::v4::ContentData::updatable_fields',
            },
            {
                version          => 5,
                fields           => '$Core::MT::DataAPI::Resource::v5::ContentData::fields',
                updatable_fields => '$Core::MT::DataAPI::Resource::v5::ContentData::updatable_fields',
            },
        ],
        'content_data' => 'cd',
        'group'        => [{
                version          => 2,
                fields           => '$Core::MT::DataAPI::Resource::v2::Group::fields',
                updatable_fields => '$Core::MT::DataAPI::Resource::v2::Group::updatable_fields',
            },
            {
                version          => 5,
                fields           => '$Core::MT::DataAPI::Resource::v5::Group::fields',
                updatable_fields => '$Core::MT::DataAPI::Resource::v5::Group::updatable_fields',
            },
        ],
        'endpoint' => [{
                version => 1,
                fields  => '$Core::MT::DataAPI::Resource::Endpoint::fields',
            },
        ],
        statisticsdate => [{
                version => 1,
                fields  => '$Core::MT::DataAPI::Resource::v1::StatisticsDate::fields',
            },
        ],
        statisticspath => [{
                version => 1,
                fields  => '$Core::MT::DataAPI::Resource::v1::StatisticsPath::fields',
            },
        ],
        theme => [{
                version => 2,
                fields  => '$Core::MT::DataAPI::Resource::v2::Theme::fields',
            },
        ],
        plugin => [{
                version => 2,
                fields  => '$Core::MT::DataAPI::Resource::v2::Plugin::fields',
            },
        ],
    };
}

sub resource {
    my $class       = shift;
    my ($key)       = @_;
    my $app         = MT->instance;
    my $api_version = $app->current_api_version;

    if ( !$resources{$api_version} ) {
        my %aliases = ();
        for my $c ( MT::Component->select ) {
            my $reg = $c->registry( 'applications', 'data_api', 'resources' );
            next unless $reg && ref $reg eq 'HASH';

            for my $k ( keys %$reg ) {
                if ( ref $reg->{$k} ) {
                    $resources{$api_version}{$k} ||= { aliases => [], };

                    push @{ $resources{$api_version}{$k}{aliases} },
                        {
                        key    => $k,
                        plugin => $c,
                        };
                }
                else {
                    $aliases{$k} = $reg->{$k};
                }
            }
        }

        for my $k ( keys %aliases ) {
            if ( $resources{$api_version}{$k} ) {
                push @{ $resources{$api_version}{ $aliases{$k} }{aliases} },
                    @{ $resources{$api_version}{$k}{aliases} };
            }
            $resources{$api_version}{$k} = $aliases{$k};
        }
    }

    my $res;
    my $resource_key;
    for my $k (
        ref $key
        ? ( (   UNIVERSAL::isa( $key, 'MT::Log' )
                ? ()
                : ( $key->class_type || '' )
            ),
            $key->datasource . '.' . ( $key->class_type || '' ),
            $key->datasource
        )
        : ($key)
        )
    {
        next unless $k;
        $resource_key = $k;
        $res = $resources{$api_version}{$k} and last;
    }

    return unless $res;

    if ( !ref $res ) {
        $resources{$api_version}{$resource_key} = $res
            = $class->resource($res);
    }

    return unless $res;

    if ( !$res->{fields} ) {
        my @disabled_fields = do {
            my $all_fields = MT->config->DisableResourceField;
            map { split ',', ( $all_fields->{ $_->{key} } || '' ) }
                @{ $res->{aliases} };
        };

        my @regs;
        for ( @{ $res->{aliases} } ) {
            my $p = $_->{plugin};
            my $reg
                = $p->registry( 'applications', 'data_api', 'resources',
                $_->{key} );
            next unless $reg;

            if ( ref $reg eq 'ARRAY' ) {
                push @regs, ( map { +{ reg => $_, plugin => $p } } @$reg );
            }
            else {
                push @regs, { reg => $reg, plugin => $p };
            }
        }

        # Get the resource registries of the version below api version,
        # and sort these in ascending order of version.
        @regs = map { $_->[1] }
            sort { $a->[0] <=> $b->[0] }
            grep { $_->[0] <= $api_version }
            map { [$_->{reg}{version} || 1, $_] } @regs;

        my %tmp_res = ();
        for (@regs) {
            my $p = $_->{plugin};
            for my $k (qw(fields updatable_fields)) {
                my $r = $_->{reg}{$k};
                next unless $r;
                unless ( ref $r ) {
                    my $code = MT->handler_to_coderef($r);
                    if ( ref $code eq 'CODE' ) {
                        my $res = $code->($p);
                        require MT::Component;
                        MT::Component::__deep_localize_labels( $p, $res )
                            if $res && ref $res eq 'HASH';
                        $r = $res;
                    }
                }
                $tmp_res{$k} ||= [];
                push @{ $tmp_res{$k} }, ( $r ? @$r : () );
            }
        }

        $res->{fields} = [];
        {
            my %fields = ();
            my %alias;

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

                    if ( $f->{condition} ) {
                        $f->{condition}
                            = MT->handler_to_coderef( $f->{condition} );
                    }
                }

                if ( grep { $_ eq $f->{name} } @disabled_fields ) {
                    if ( my $cond = $f->{condition} ) {
                        $f->{condition} = sub {
                            $cond->()
                                && $app->user
                                && !$app->user->is_anonymous;
                        };
                    }
                    else {
                        $f->{condition}
                            = sub { $app->user && !$app->user->is_anonymous };
                    }
                }

                if ($f->{alias} && $f->{alias} ne $f->{name}) {
                    $alias{$f->{alias}} = $f->{name};
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
            @{$res->{fields}} = grep {!$alias{$_->{name}}} @{$res->{fields}};
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

                if ( $f->{condition} ) {
                    $f->{condition}
                        = MT->handler_to_coderef( $f->{condition} );
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
    elsif ( UNIVERSAL::isa( $objs, 'MT::DataAPI::Resource::Type::Raw' ) ) {
        return $objs->content;
    }

    return [] unless @$objs;

    my $resource_data = $class->resource( $objs->[0] )
        or return;

    my @fields = grep { _is_condition_ok($_) } do {
        if ($fields_specified) {
            my %keys = map { $_ => 1 } @$fields_specified;
            grep { $keys{ $_->{name} } or $keys{ $_->{alias} || '' } } @{ $resource_data->{fields} };
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
package MT::DataAPI::Resource::Type;

sub new {
    my $self = [ $_[1] ];
    bless $self, $_[0];
    $self;
}

sub content {
    $_[0]->[0];
}

package MT::DataAPI::Resource::Type::Raw;

use base qw(MT::DataAPI::Resource::Type);

package MT::DataAPI::Resource::Type::ObjectList;

use base qw(MT::DataAPI::Resource::Type);

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

sub schema {
    return +{
        type => 'integer',
    };
}

package MT::DataAPI::Resource::DataType::Float;

sub from_object {
    my ( $objs, $hashs, $f ) = @_;
    my $name = $f->{name};
    foreach my $h (@$hashs) {
        $h->{$name} = $h->{$name} if defined $h->{$name};
    }
}

sub to_object {
    my ( $hashs, $objs, $f ) = @_;
    my $name = $f->{alias} || $f->{name};
    foreach my $o (@$objs) {
        $o->$name( $o->$name ) if defined $o->$name;
    }
}

sub schema {
    return +{
        type   => 'number',
        format => 'float',
    };
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

sub schema {
    return +{
        type => 'boolean',
    };
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
    elsif ( $objs->[0]->has_column('blog_id') ) {
        @blog_ids = map { $_->blog_id } @$objs;
        my @blogs = MT->model('blog')->load( { id => \@blog_ids, } );
        $blogs{ $_->id } = $_ for @blogs;
    }

    my $size = scalar(@$objs);
    my $name = $f->{name};
    for ( my $i = 0; $i < $size; $i++ ) {
        my $h = $hashs->[$i];
        $h->{$name}
            &&= MT::Util::ts2iso( @blog_ids ? $blogs{ $blog_ids[$i] } : undef,
            $h->{$name}, 1 );
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
                    'Cannot parse "[_1]" as an ISO 8601 datetime',
                    $o->$name
                )
            );
        }
    }
}

sub schema {
    return +{
        type   => 'string',
        format => 'date-time',
    };
}

1;

__END__

=head1 NAME

MT::DataAPI::Resource - Movable Type class for managing Data API's resources.

=head1 SYNOPSIS

    use MT::DataAPI::Resource;

    my $obj      = MT->model('entry')->load(1);
    my $resource = MT::DataAPI::Resource->from_object($obj);

=head1 METHODS

=head2 MT::DataAPI::Resource->resource($key)

Returns a specification of the resource if found for C<$key>.
If C<$key> is object, C<$key-E<gt>datasource> is used as a key.

=head2 MT::DataAPI::Resource->from_object($objs[, $fields_specified])

Returns a resource data which converted C<$objs>.

If C<$fields_specified> is given, returned data only contains specified keys.

C<$objs> can take an instance of these class.

=over 4

=item MT::Object

    Return value is a hash.

=item MT::DataAPI::Resource::Type::Raw

    Returns C<$objs-E<gt>content> immediately.

=item MT::DataAPI::Resource::Type::ObjectList

    Return value is a reference of the array.

=back

=head2 MT::DataAPI::Resource->to_object($name, $hashs[, $originals])

Returns an instance (or instances) which converted C<$hashs>.

C<$name> should be a key that can pass to L<MT::DataAPI::Resource-E<gt>resource>.

C<$hashs> can take a reference of the array or a hash.
If a reference of the array is given to C<$hashs>, return value is a reference of the array.
If a hash is given to C<$hashs>, return value is an instance.

If C<$originals> is given, The result object is cloned from C<$original>, then be overwritten by C<$hashs>.

=head1 MT::DataAPI::Resource::Type INTERNAL PACKAGES

These classes can wrap data that is passed to L<MT::DataAPI::Resource-E<gt>from_object>.

=over 4

=item MT::DataAPI::Resource::Type::Raw

If a converted data has been wrapped by this class, L<MT::DataAPI::Resource-E<gt>from_object> returns raw data immediately. You can use this class in order to return simple data that is not an instance of MT::Object.

    use MT::DataAPI::Resource;

    my $obj = MT::DataAPI::Resource::Type::Raw->new( $converted_data )
    my $resource = MT::DataAPI::Resource->from_object($obj);

    $converted_data == $obj # true

=item MT::DataAPI::Resource::Type::ObjectList

If an object list has been wrapped by this class, L<MT::DataAPI::Resource-E<gt>from_object> returns a reference of array. The MT expects all the objects contained in array are the instances of the same class. You can use this class in order to convert object list.

    use MT::DataAPI::Resource;

    my $objs = MT::DataAPI::Resource::Type::ObjectList
        ->new([ $app->model('entry')->load ]);
    my $resources = MT::DataAPI::Resource->from_object($objs);

=back

=head1 MT::DataAPI::Resource::DataType INTERNAL PACKAGES

These classes can specify to the type of the resource.

=over 4

=item MT::DataAPI::Resource::DataType::Object

If this package is specified to the type, the value will be converted by L<MT::DataAPI::Resource-E<gt>from_object>.

    {   name   => 'author',
        fields => [qw(id displayName userpicUrl)],
        type   => 'MT::DataAPI::Resource::DataType::Object',
    }

=item MT::DataAPI::Resource::DataType::Integer

If this package is specified to the type, the value will be converted to an integer.
If C<field> was given, this value passed to L<MT::DataAPI::Resource-E<gt>from_object> as a second argument.

=item MT::DataAPI::Resource::DataType::Float

If this package is specified to the type, the value will be converted to a float.
If C<field> was given, this value passed to L<MT::DataAPI::Resource-E<gt>from_object> as a second argument.

=item MT::DataAPI::Resource::DataType::Boolean

If this package is specified to the type, the value will be converted to an boolean.

=item MT::DataAPI::Resource::DataType::ISO8601

If this package is specified to the type, the value will be converted to an ISO8601 datetime format.

=back

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
