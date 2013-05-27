package MT::DataAPI::Endpoint::Common;

use warnings;
use strict;

use base 'Exporter';
our @EXPORT = qw(
    save_object remove_object
    context_objects resource_objects get_target_user
    run_permission_filter filtered_list obj_promise
);

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
        $app->user;
    }
    else {
        my ($user) = context_objects(@_);
        if ( $user && $user->status == MT::Author::ACTIVE() ) {
            $user;
        }
        else {
            undef;
        }
    }
}

sub run_permission_filter {
    my $app = shift;
    my ( $filter, $type ) = splice( @_, 0, 2 );

    return 1 if $app->user->is_superuser;

    $app->run_callbacks( "$filter.$type", $app, @_ ) || $app->error(403);
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

    my $setting = MT->registry( listing_screens => $ds )
        or return $app->error( $app->translate('Unknown list type'), 400 );

    if ( my $cond = $setting->{condition} ) {
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

    # Validate scope
    if ( my $view = $setting->{view} ) {
        $view = [$view] unless ref $view;
        my %view = map { $_ => 1 } @$view;
        if ( !$view{$scope} ) {
            return $app->return_to_dashboard( redirect => 1, );
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
        my $list_permission = $setting->{permission};
        my $inherit_blogs   = 1;
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
    if ( my $items = $q->param('items') ) {
        if ( $items =~ /^".*"$/ ) {
            $items =~ s/^"//;
            $items =~ s/"$//;
            $items = MT::Util::decode_js($items);
        }
        require JSON;
        my $json = JSON->new->utf8(0);
        $filteritems = $json->decode($items);
    }
    else {
        $allpass     = 1;
        $filteritems = [];
    }

    if ( my $search = $app->param('search') ) {
        push @$filteritems,
            {
            type => 'content',
            args => {
                string => $search,
                option => 'contains',
                fields => $app->param('search_fields') || '',
            },
            };
    }

    for my $key ( split ',', ( $app->param('filterKeys') || '' ) ) {
        if ( defined( $app->param($key) ) ) {
            push @$filteritems,
                {
                type => $key,
                args => { value => scalar( $app->param($key) ), },
                };
        }
    }

    if ( my $ids = $app->param('excludeIds') ) {
        push @$filteritems, {
            type => 'pack',
            args => {
                op    => 'and',
                items => [
                    map {
                        +{  type => 'id',
                            args => {
                                option => 'not_equal',
                                value  => $_,
                            },
                        };
                    } grep {$_} split( ',', $ids )
                ],
            },
        };
    }

    require MT::ListProperty;
    my $props = MT::ListProperty->list_properties($ds);

    my $filter = MT->model('filter')->new;
    $filter->set_values(
        {   object_ds => $ds,
            items     => $filteritems,
            author_id => $app->user->id,
            blog_id   => $blog_id || 0,
        }
    );
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
