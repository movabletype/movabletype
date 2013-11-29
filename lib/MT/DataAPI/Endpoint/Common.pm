# Movable Type (r) (C) 2001-2013 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Endpoint::Common;

use warnings;
use strict;

use MT::DataAPI::Resource;

use base 'Exporter';
our @EXPORT = qw(
    save_object remove_object
    context_objects resource_objects get_target_user
    run_permission_filter filtered_list obj_promise
);

our $query_builder;

sub save_object {
    my ( $app, $type, $obj, $original, $around_filter ) = @_;
    $original ||= $app->model($type)->new;
    $around_filter ||= sub { $_[0]->() };

    run_permission_filter( $app, 'data_api_save_permission_filter',
        $type, $obj->id, $obj, $original )
        or return;

    $app->run_callbacks( 'data_api_save_filter.' . $type,
        $app, $obj, $original )
        or return $app->error( $app->errstr, 409 );

    $app->run_callbacks( 'data_api_pre_save.' . $type, $app, $obj, $original )
        or return $app->error(
        $app->translate( "Save failed: [_1]", $app->errstr ), 409 );

    $around_filter->(
        sub {
            $obj->save;
        }
        )
        or return $app->error(
        $app->translate( 'Saving object failed: [_1]', $obj->errstr ),
        500
        );

    $app->run_callbacks( 'data_api_post_save.' . $type,
        $app, $obj, $original );

    1;
}

sub obj_promise {
    my ($obj) = @_;

    require MT::Promise;
    MT::Promise::delay( sub {$obj} );
}

sub remove_object {
    my ( $app, $type, $obj ) = @_;

    run_permission_filter( $app, 'data_api_delete_permission_filter',
        $type, $obj )
        or return;

    $obj->remove
        or return $app->error(
        $app->translate(
            'Removing [_1] failed: [_2]',
            $obj->class_label, $obj->errstr
        ),
        500
        );

    $app->run_callbacks( 'data_api_post_delete.' . $type, $app, $obj );

    1;
}

sub _load_object_by_name {
    my ( $app, $name, $parent ) = @_;

    return $app->blog if $name eq 'site_id';

    my ($model_name) = ( $name =~ /([\w-]+)_id\z/ ) or return;
    my $model = $app->model($model_name)
        or return;

    my $id  = $app->param($name);
    my $obj = $model->load(
        {   id => $id,
            ( $parent ? ( $parent->datasource . '_id' => $parent->id ) : () ),
        }
    ) if $id;

    if ( !$obj && !$app->errstr ) {
        $app->error( ucfirst($model_name) . ' not found', 404 );
    }

    $obj;
}

sub context_objects {
    my ( $app, $endpoint ) = @_;

    my @objects;
    for my $name ( @{ $endpoint->{_vars} } ) {
        my $obj
            = _load_object_by_name( $app, $name,
            @objects ? $objects[-1] : undef )
            or return ();
        push @objects, $obj;
    }

    @objects;
}

sub resource_objects {
    my ( $app, $endpoint ) = @_;

    my @objects
        = map { $app->resource_object($_) } @{ $endpoint->{resources} };

    return ( grep { !defined($_) } @objects ) ? () : @objects;
}

sub get_target_user {
    my ($app) = @_;

    if ( $app->param('user_id') eq 'me' ) {
        my $user = $app->user;
        $user->is_anonymous ? $app->error(401) : $user;
    }
    else {
        my ($user) = context_objects(@_);
        ( $user && $user->status == MT::Author::ACTIVE() ) ? $user : undef;
    }
}

sub run_permission_filter {
    my $app = shift;
    my ( $filter, $type ) = splice( @_, 0, 2 );

    return 1 if $app->user->is_superuser;

    $app->run_callbacks( "$filter.$type", $app, @_ ) || $app->error(403);
}

sub query_parser {
    [ grep $_, ( $_[0] =~ /\s*"([^"]+)"|\s*([^"\s]+)|\s*"([^"]+)/sg ) ];
}

sub query_builder {
    my ( $app, $search, $fields, $filter ) = @_;
    $fields = join ',', @$fields;

    $filter->append_item(
        {   type => 'pack',
            args => {
                op    => 'and',
                items => [
                    map {
                        +{  type => 'content',
                            args => {
                                string => $_,
                                option => 'contains',
                                fields => $fields,
                            },
                        };
                    } grep {$_} @{ query_parser($search) }
                ],
            },
        }
    );
}

sub filtered_list {
    my ( $app, $endpoint, $ds, $terms, $args, $options ) = @_;

    run_permission_filter( $app, 'data_api_list_permission_filter',
        $ds, $terms, $args, $options )
        or return;

    $terms   ||= {};
    $args    ||= {};
    $options ||= {};
    my $q         = $app->param;
    my $blog_id   = $q->param('blog_id') || 0;
    my $filter_id = $q->param('fid') || 0;
    my $blog      = $blog_id ? $app->blog : undef;
    my $scope
        = !$blog         ? 'system'
        : $blog->is_blog ? 'blog'
        :                  'website';
    my $blog_ids
        = !$blog         ? undef
        : $blog->is_blog ? [$blog_id]
        :                  [ $blog->id, map { $_->id } @{ $blog->blogs } ];
    my $resource_data = MT::DataAPI::Resource->resource($ds);

    my $setting = MT->registry( listing_screens => $ds ) || {};

    if (exists $setting->{data_api_condition}
        ? defined $setting->{data_api_condition}
        : defined $setting->{condition}
        )
    {
        my $cond = $setting->{data_api_condition} || $setting->{condition};
        $cond = MT->handler_to_coderef($cond)
            if 'CODE' ne ref $cond;
        $app->error();
        unless ( $cond->($app) ) {
            if ( $app->errstr ) {
                return $app->error( $app->errstr, 500 );
            }
            return $app->error( $app->translate('Invalid request'), 400 );
        }
    }

    # Permission check
    if ((   exists $setting->{data_api_permission}
            ? defined $setting->{data_api_permission}
            : defined $setting->{permission}
        )
        && !$app->user->is_superuser()
        )
    {
        my $list_permission
            = $setting->{data_api_permission} || $setting->{permission};
        my $inherit_blogs = 1;
        if ( 'HASH' eq ref $list_permission ) {
            $inherit_blogs = $list_permission->{inherit}
                if defined $list_permission->{inherit};
            $list_permission = $list_permission->{permit_action};
        }
        my $allowed  = 0;
        my @act      = split /\s*,\s*/, $list_permission;
        my $blog_ids = undef;
        if ($blog_id) {
            push @$blog_ids, $blog_id;
            if ( $scope eq 'website' && $inherit_blogs ) {
                push @$blog_ids, $_->id foreach @{ $app->blog->blogs() };
            }
        }
        foreach my $p (@act) {
            $allowed = 1,
                last
                if $app->user->can_do(
                $p,
                at_least_one => 1,
                ( $blog_ids ? ( blog_id => $blog_ids ) : () )
                );
        }
        return $app->permission_denied()
            unless $allowed;
    }

    my $class = $setting->{datasource} || MT->model($ds);
    my $filteritems;
    my $allpass = 0;
    if ( my $items = $q->param('searchConditions') ) {
        require JSON;
        my $json = JSON->new->utf8(0);
        $filteritems = $json->decode($items);
    }
    else {
        $allpass     = 1;
        $filteritems = [];
    }

    my $filter = MT->model('filter')->new;
    $filter->set_values(
        {   object_ds => $ds,
            items     => $filteritems,
            author_id => $app->user->id,
            blog_id   => $blog_id || 0,
        }
    );

    if ( my $search = $app->param('search') ) {
        my @fields = ();
        if ( my $specified = $app->param('searchFields') ) {
            @fields = map {
                exists $resource_data->{field_name_map}{$_}
                    ? $resource_data->{field_name_map}{$_}
                    : ()
            } split ',', $specified;
        }

        my $handler
            = $app->registry( 'applications', 'data_api' )->{query_builder};
        if ( ref $handler eq 'ARRAY' ) {
            $handler = $handler->[$#$handler];
        }
        $query_builder ||= MT->handler_to_coderef($handler);
        $query_builder->( $app, $search, \@fields, $filter );
    }

    require MT::ListProperty;
    my $props = MT::ListProperty->list_properties($ds) || {};

    for my $key ( split ',', ( $app->param('filterKeys') || '' ) ) {
        if ( defined( $app->param($key) ) ) {
            ( my $obj_key = $key ) =~ s/([A-Z])/_\l$1/g;
            $obj_key =~ s/s\z// unless exists $props->{$obj_key};

            $filter->append_item(
                {   type => 'pack',
                    args => {
                        op    => 'or',
                        items => [
                            map {
                                +{  type => $obj_key,
                                    args => {
                                        option => 'equal',
                                        value  => $_,
                                    },
                                };
                                } grep {$_}
                                split( ',', scalar( $app->param($key) ) )
                        ],
                    },
                }
            );
        }
    }

    for my $d ( [qw(includeIds or equal)], [qw(excludeIds and not_equal)], ) {
        my ( $key, $op, $option ) = @$d;

        if ( my $ids = $app->param($key) ) {
            $filter->append_item(
                {   type => 'pack',
                    args => {
                        op    => $op,
                        items => [
                            map {
                                +{  type => 'id',
                                    args => {
                                        option => $option,
                                        value  => $_,
                                    },
                                };
                            } grep {$_} split( ',', $ids )
                        ],
                    },
                }
            );
        }
    }

    my $limit  = $q->param('limit')  || 50;
    my $offset = $q->param('offset') || 0;

    ## FIXME: take identifical column from column defs.
    my $cols = defined( $q->param('columns') ) ? $q->param('columns') : '';
    my @cols = ( '__id', grep {/^[^\.]+$/} split( ',', $cols ) );
    my @subcols = ( '__id', grep {/\./} split( ',', $cols ) );

    my $scope_mode
        = $setting->{data_api_scope_mode} || $setting->{scope_mode} || 'wide';
    my @blog_id_term = (
         !$blog_id              ? ()
        : $scope_mode eq 'none' ? ()
        : $scope_mode eq 'this' ? ( blog_id => $blog_id )
        :                         ( blog_id => $blog_ids )
    );

    my %load_options = (
        terms => { %$terms, @blog_id_term },
        args  => {%$args},
        sort_by    => $q->param('sortBy')    || '',
        sort_order => $q->param('sortOrder') || '',
        limit      => $limit,
        offset     => $offset,
        scope      => $scope,
        blog       => $blog,
        blog_id    => $blog_id,
        blog_ids   => $blog_ids,
        %$options,
    );

    my %count_options = (
        terms    => { %$terms, @blog_id_term },
        args     => {%$args},
        scope    => $scope,
        blog     => $blog,
        blog_id  => $blog_id,
        blog_ids => $blog_ids,
        %$options,
    );

    MT->run_callbacks( 'data_api_pre_load_filtered_list.' . $ds,
        $app, $filter, \%count_options, \@cols );

    my $count_result = $filter->count_objects(%count_options);
    if ( !defined $count_result ) {
        return $app->error(
            MT->translate(
                "An error occured while counting objects: [_1]",
                $filter->errstr
            ),
            500
        );
    }
    my ( $count, $editable_count ) = @$count_result;

    $load_options{total} = $count;

    my ( $objs, @data );
    if ($count) {
        MT->run_callbacks( 'data_api_pre_load_filtered_list.' . $ds,
            $app, $filter, \%load_options, \@cols );

        $objs = $filter->load_objects(%load_options);
        if ( !defined $objs ) {
            return $app->error(
                MT->translate(
                    "An error occured while loading objects: [_1]",
                    $filter->errstr
                ),
                500
            );
        }
    }

    +{  objects => $objs || [],
        count => $count,
        editable_count => $editable_count,
    };
}

1;

__END__

=head1 NAME

MT::DataAPI::Endpoint::Common - Movable Type utilities for endpoint definitions.

=head1 METHODS

=head2 MT::DataAPI::Endpoint::Common::obj_promise($obj)

Just call L<MT::Promise::delay> internally.

=head2 MT::DataAPI::Endpoint::Common::save_object($app, $type, $obj[, $original[, $around_filter]]);

Save C<$obj> with permission checking and callbacks.

C<$around_filter> is optional. C<$around_filter> has the following signature:

    sub {
        my $save = shift;
        # Do stuff before save
        $save->();
        # Do stuff after save
    }

This method will call these callbacks.

=over 4

=item data_api_save_permission_filter.$type

    A permission-filter callback.
    Returns 1 if current user can save this object.

=item data_api_save_filter.$type

    A filter callback.
    Returns 1 if the MT can save this object.

=item data_api_pre_save.$type

    A filter callback.
    Returns 1 if the MT can save this object.
    
=item data_api_post_save.$type

    A post-save callback.

=back

=head2 MT::DataAPI::Endpoint::Common::remove_object($app, $type, $obj)

Remove C<$obj> with permission checking and callbacks.
This method will call these callbacks.

=over 4

=item data_api_delete_permission_filter.$type

    A permission-filter callback.
    Returns 1 if current user can remove this object.
    
=item data_api_post_delete.$type

    A post-remove callback.

=back

=head2 MT::DataAPI::Endpoint::Common::context_objects($app, $endpoint)

Returns all the objects referred from URL, only if all the objects can be loaded.
Returns empty list, if some object cannot be loaded.

    # If current endpoint is "/sites/:site_id/entries/:entry_id/action",
    # and current URL is "/sites/1/entries/1/action".
    my ($site, $entry) = context_objects($app, $endpoint);
    $site->id;  # 1
    $entry->id; # 1

    # Parent object ID is checked in loading.
    # Therefore this value is 1 or cannot load entry.
    $entry->blog_id;

=head2 MT::DataAPI::Endpoint::Common::resource_objects($app, $endpoint)

Returns all the objects extracted from request data, only if all the objects can be obtained. 
All the key of objects should be specified by endpoint definitions, before request.

    # $endpoint->{resources} is ['entry']
    my ($entry) = resource_objects($app, $endpoint)
        or $app->error(400);

=head2 MT::DataAPI::Endpoint::Common::get_target_user

Returns the current target user.

=head2 MT::DataAPI::Endpoint::Common::run_permission_filter($filter, $type)

Call "$Filter.$type" as a permission filter.

If the current user is superuser, pass to calling filter.

If a permission filter returns 0, this method returns empty list with setting permission error to $app.

=head2 MT::DataAPI::Endpoint::Common::filtered_list($app, $endpoint, $ds[, $terms[, $args[, $options]]])

Returns a filtered list by using filter of listing framework.
This method will call these callbacks.

=over 4

=item data_api_list_permission_filter.$type

    A permission-filter callback.
    Returns 1 if current user can retrieve a list of this C<$ds>.
    
=back

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
