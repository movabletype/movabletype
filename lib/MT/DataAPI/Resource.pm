# Movable Type (r) (C) 2001-2013 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Resource;

use strict;
use warnings;

use MT::Cache::Negotiate;

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
                    next unless $reg->{$k}{plugin};

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
        my @disabled_fields = do {
            my $all_fields = MT->config->DisableResourceField;
            map { split ',', ( $all_fields->{ $_->{key} } || '' ) }
                @{ $res->{aliases} };
        };

        my %tmp_res = ();
        for my $k (qw(fields updatable_fields)) {
            $tmp_res{$k} = [
                map {
                    my $reg
                        = $_->{plugin}
                        ->registry( 'applications', 'data_api', 'resources',
                        $_->{key}, $k );
                    $reg ? @$reg : ();
                } @{ $res->{aliases} }
            ];
        }

        for my $k (qw(disable_cache)) {
            $res->{$k} = undef;
            $res->{$k}
                ||= $_->{plugin}->registry( 'applications', 'data_api',
                'resources', $_->{key}, $k )
                for @{ $res->{aliases} };
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

                    for my $k (
                        qw(bulk_from_object from_object to_object bulk_filter_cache filter_cache)
                        )
                    {
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
    $f->{condition}->();
}

sub _from_object_fields {
    my $class = shift;
    my ( $obj, $fields_specified ) = @_;

    my $resource_data = $class->resource($obj)
        or return;

    [   grep { _is_condition_ok($_) } do {
            if ($fields_specified) {
                my %keys = map { $_ => 1 } @$fields_specified;
                grep { $keys{ $_->{name} } } @{ $resource_data->{fields} };
            }
            else {
                @{ $resource_data->{fields} };
            }
            }
    ];
}

sub from_object {
    my $class = shift;
    my ( $objs, $fields_specified, $opts ) = @_;
    my $is_list = 1;
    $opts ||= {};

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

    my $fields = $class->_from_object_fields( $objs->[0], $fields_specified );

    my $objs_count = scalar(@$objs);
    my @hashs      = map { +{} } 0 .. $#$objs;
    my $stash      = {};

    for my $f (@$fields) {
        if ( $f->{bulk_from_object} ) {
            $f->{bulk_from_object}->( $objs, \@hashs, $f, $stash, $opts );
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
                        $f->{from_object}
                            ->( $_[0], $hashs[$i], $f, $stash, $opts );
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

    for my $f (@$fields) {
        if ( ref $f && $f->{type_from_object} ) {
            $f->{type_from_object}->( $objs, \@hashs, $f, $stash, $opts );
        }
    }

    $is_list ? \@hashs : $hashs[0];
}

sub from_object_with_cache {
    my $class = shift;
    my ( $objs, $fields_specified ) = @_;
    my $app     = MT->instance;
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

    my $datasource   = $objs->[0]->datasource;
    my $latest_touch = $app->model('touch')->load(
        { $app->blog ? ( blog_id => [ 0, $app->blog->id ] ) : (), },
        { sort => 'modified_on', direction => 'descend' }
    );
    my $driver = MT::Cache::Negotiate->new(
        ttl => (
            $latest_touch
            ? time()
                - MT::Util::ts2epoch( undef, $latest_touch->modified_on, 1 )
            : 0
        ),
        expirable => 1,
    );
    my @load_ids = ();
    my @results  = ();
    my @keys     = map { $class->cache_key($_) } @$objs;
    my $cached   = $driver->get_multi(@keys);
    my $serializer
        = MT::Serialize->new( MT->config->DataAPIResourceCacheSerializer );

    # Rebuild cache always, in DebugMode
    $cached = {} if $MT::DebugMode;

    for ( my $i = 0; $i < scalar @$objs; $i++ ) {
        my $r  = $objs->[$i];
        my $ck = $keys[$i];
        if ( my $c = $cached->{$ck} ) {
            push @results, ${ $serializer->unserialize($c) };
        }
        else {
            push @load_ids, [ $i, $ck, $r->id, $r ];
        }
    }

    if (@load_ids) {
        my @tmp = $app->model($datasource)
            ->load( { id => [ map { $_->[2] } @load_ids ] } );
        my @load_objs = map {
            my $id_set = $_;
            ( grep { $id_set->[2] == $_->id } @tmp )[0] || $id_set->[3];
        } @load_ids;

        my $converteds
            = $class->from_object( \@load_objs, undef, { cache => 1, } );
        for ( my $i = 0; $i < scalar @load_ids; $i++ ) {
            splice @results, $load_ids[$i]->[0], 0, $converteds->[$i];

            $driver->set( $load_ids[$i]->[1],
                $serializer->serialize( \$converteds->[$i] ) );
        }
    }

    my $hashs
        = $class->filter_cache( \@results, $objs->[0], $fields_specified );

    $is_list ? $hashs : $hashs->[0];
}

sub filter_cache {
    my $class = shift;
    my ( $resources, $obj, $fields_specified ) = @_;

    return [] unless @$resources;

    my $fields = $class->_from_object_fields( $obj, $fields_specified );

    my $resources_count = scalar(@$resources);
    my @hashs           = map { +{} } 0 .. $#$resources;
    my $stash           = {};

    for my $f (@$fields) {
        if ( $f->{bulk_filter_cache} ) {
            $f->{bulk_filter_cache}->( $resources, \@hashs, $f, $stash );
        }
        elsif ( $f->{filter_cache} ) {
            for ( my $i = 0; $i < $resources_count; $i++ ) {
                my @vals = $f->{filter_cache}
                    ->( $resources->[$i], $hashs[$i], $f, $stash );
                if (@vals) {
                    $hashs[$i]{ $f->{name} } = $vals[0];
                }
            }
        }
        else {
            for ( my $i = 0; $i < $resources_count; $i++ ) {
                $hashs[$i]{ $f->{name} } = $resources->[$i]{ $f->{name} };
            }
        }
    }

    \@hashs;
}

sub cache_key {
    my $self = shift;
    my ($datasource, $id);
    if (ref $_[0]) {
        ($datasource, $id) = $_[0]->datasource, $_[0]->id
    }
    else {
        ($datasource, $id) = @_;
    }
    'data_api_resource_' . $datasource . '_' . $id;
}

sub expire_cache {
    my $self   = shift;
    my $driver = MT::Cache::Negotiate->new;
    $driver->delete( $self->cache_key(@_) );
}

sub to_object {
    my $class = shift;
    my ( $name, $hashs, $originals, $opts ) = @_;
    my $is_list = 1;
    $opts ||= {};

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
                @vals = $f->{to_object}->( $hash, $obj, $f, $stash, $opts );
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
            $f->{type_to_object}->( $hashs, \@objs, $f, $stash, $opts );
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

sub datasource {
    my $self    = shift;
    my $content = $self->content;
    @$content ? $content->[0]->datasource : '';
}

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
                    'Cannot parse "[_1]" as an ISO 8601 datetime',
                    $o->$name
                )
            );
        }
    }
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

=item MT::DataAPI::Resource::DataType::Boolean

If this package is specified to the type, the value will be converted to an boolean.

=item MT::DataAPI::Resource::DataType::ISO8601

If this package is specified to the type, the value will be converted to an ISO8601 datetime format.

=back

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
