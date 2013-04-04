package MT::API::Endpoint::Common;

use warnings;
use strict;

use base 'Exporter';
our @EXPORT = qw(
    save_object remove_object
    context_objects resource_objects
    resource_error run_permission_filter filtered_list
);

sub save_object {
    my ( $app, $obj ) = @_;

    # TODO should run callbacks
    # TODO should return appropriate error
    $obj->save
        or return $app->error(
        $app->translate( 'Saving object failed: [_1]', $obj->errstr ), 500 );
}

sub remove_object {
    my ( $app, $obj ) = @_;

    # TODO should run callbacks
    # TODO should return appropriate error
    $obj->remove
        or return $app->error(
        $app->translate(
            'Removing [_1] failed: [_2]',
            $obj->class_label, $obj->errstr
        ),
        500
        );
}

sub _load_object_by_name {
    my ( $app, $name ) = @_;

    return $app->blog if $name eq 'site_id';

    my ($model_name) = ( $name =~ /([\w-]+)_id\z/ ) or return;
    my $model = $app->model($model_name)
        or return;

    my $id = $app->param($name);
    my $obj = $id ? $model->load($id) : undef;

    if ( !$obj && !$app->errstr ) {
        $app->error( ucfirst($model_name) . ' not found', 404 );
    }

    $obj;
}

sub context_objects {
    my ( $app, $endpoint ) = @_;

    my @objects
        = map { _load_object_by_name( $app, $_ ) } @{ $endpoint->{_vars} };

    return ( grep { !defined($_) } @objects ) ? () : @objects;
}

sub resource_objects {
    my ( $app, $endpoint ) = @_;

    my @objects
        = map { $app->resource_object($_) } @{ $endpoint->{resources} };

    return ( grep { !defined($_) } @objects ) ? () : @objects;
}

sub resource_error {
    qq{A resource "$_[0]" is required.}, 400;
}

sub run_permission_filter {
    my $app    = shift;
    my $filter = shift;

    return 1 if $app->user->is_superuser;

    $app->run_callbacks( $filter, $app, @_ ) || $app->json_error(403);
}

sub filtered_list {
    my ( $app, $endpoint, $ds, $terms, $args ) = @_;
    $terms ||= {};
    $args  ||= {};
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
        or return $app->json_error( $app->translate('Unknown list type') );

    if ( my $cond = $setting->{condition} ) {
        $cond = MT->handler_to_coderef($cond)
            if 'CODE' ne ref $cond;
        $app->error();
        unless ( $cond->($app) ) {
            if ( $app->errstr ) {
                return $app->json_error( $app->errstr );
            }
            return $app->json_error( $app->translate('Invalid request') );
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
    if ( defined $setting->{permission}
        && !$app->user->is_superuser() )
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
            $allowed = 1, last
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

    my $scope_mode = $setting->{scope_mode} || 'wide';
    my @blog_id_term = (
         !$blog_id ? ()
        : $scope_mode eq 'none' ? ()
        : $scope_mode eq 'this' ? ( blog_id => $blog_id )
        : ( blog_id => $blog_ids )
    );

    my %load_options = (
        terms => { %$terms, @blog_id_term },
        args  => {%$args},
        sort_by    => $q->param('sort_by')    || '',
        sort_order => $q->param('sort_order') || '',
        limit      => $limit,
        offset     => $offset,
        scope      => $scope,
        blog       => $blog,
        blog_id    => $blog_id,
        blog_ids   => $blog_ids,
    );

    my %count_options = (
        terms    => { %$terms, @blog_id_term },
        args     => {%$args},
        scope    => $scope,
        blog     => $blog,
        blog_id  => $blog_id,
        blog_ids => $blog_ids,
    );

    MT->run_callbacks( 'cms_pre_load_filtered_list.' . $ds,
        $app, $filter, \%count_options, \@cols );

    my $count_result = $filter->count_objects(%count_options);
    if ( !defined $count_result ) {
        return $app->error(
            MT->translate(
                "An error occured while counting objects: [_1]",
                $filter->errstr
            )
        );
    }
    my ( $count, $editable_count ) = @$count_result;

    $load_options{total} = $count;

    my ( $objs, @data );
    if ($count) {
        MT->run_callbacks( 'cms_pre_load_filtered_list.' . $ds,
            $app, $filter, \%load_options, \@cols );

        $objs = $filter->load_objects(%load_options);
        if ( !defined $objs ) {
            return $app->error(
                MT->translate(
                    "An error occured while loading objects: [_1]",
                    $filter->errstr
                )
            );
        }
    }

    +{  objects        => $objs || [],
        count          => $count,
        editable_count => $editable_count,
    };
}

1;
