# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::CMS::Filter;
use strict;
use warnings;
use MT::Util;

sub save {
    my $app         = shift;

    $app->validate_param({
        blog_id           => [qw/ID/],
        datasource        => [qw/MAYBE_STRING/],
        fid               => [qw/ID/],
        items             => [qw/MAYBE_STRING/],
        label             => [qw/MAYBE_STRING/],
        list              => [qw/MAYBE_STRING/],
        not_encode_result => [qw/MAYBE_STRING/],
    }) or return $app->json_error($app->errstr);

    my $fid         = $app->param('fid');
    my $author_id   = $app->user->id;
    my $blog_id     = $app->param('blog_id') || 0;
    my $label       = $app->param('label');
    my $ds          = $app->param('datasource');
    my $encode_html = $app->param('not_encode_result') ? 0 : 1;

    $app->validate_magic
        or return $app->json_error( $app->translate('Invalid request') );

    if ( !$label ) {
        return $app->json_error(
            $app->translate('Failed to save filter: Label is required.') );
    }
    my $items;
    if ( my $items_json = $app->param('items') ) {
        if ( $items_json =~ /^".*"$/ ) {
            $items_json =~ s/^"//;
            $items_json =~ s/"$//;
            $items_json = MT::Util::decode_js($items_json);
        }
        require JSON;
        my $json = JSON->new->utf8(0);
        $items = $json->decode($items_json);
    }
    else {
        $items = [];
    }

    require MT::ListProperty;
    for my $item (@$items) {
        my $prop = MT::ListProperty->instance( $ds, $item->{type} );
        if ( $prop->has('validate_item') ) {
            $prop->validate_item($item)
                or return $app->json_error(
                MT->translate( 'Invalid filter terms: [_1]', $prop->errstr )
                );
        }
    }

    my $filter;
    my $filter_class = MT->model('filter');

    # Search duplicate.
    if (my $dupe = $filter_class->load(
            {   author_id => $author_id,
                object_ds => $ds,
                label     => $label,
                ( $fid ? ( id => { not => $fid } ) : () ),
            },
            {   limit     => 1,
                fetchonly => { id => 1 },
            }
        )
        )
    {
        return $app->json_error(
            $app->translate(
                'Failed to save filter:  Label "[_1]" is duplicated.', $label
            )
        );
    }
    if ($fid) {
        $filter = $filter_class->load($fid)
            or return $app->json_error( $app->translate('No such filter') );
        return $app->json_error( $app->translate('Permission denied') )
            unless $filter->author_id == $author_id;
    }
    else {
        $filter = $filter_class->new;
    }

    $filter->set_values(
        {   author_id => $author_id,
            blog_id   => $blog_id,
            label     => $label,
            object_ds => $ds,
            items     => $items,
        }
    );
    $filter->modified_by( $app->user->id );
    $filter->save
        or return $app->json_error(
        $app->translate( 'Failed to save filter: [_1]', $filter->errstr ) );

    my $list = $app->param('list');
    if ( defined $list && !$list ) {
        my %res;
        my $filters = filters( $app, $ds, encode_html => $encode_html );
        $res{id}      = $filter->id;
        $res{filters} = $filters;
        return $app->json_result( \%res );
    }
    else {

        # Forward to MT::Common::filterd_list
        $app->forward(
            'filtered_list',
            saved       => 1,
            saved_fid   => $filter->id,
            saved_label => $filter->label,
            validated   => 1,
        );
    }
}

sub delete {
    my $app = shift;
    $app->validate_magic
        or return $app->json_error( $app->translate('Invalid request') );

    $app->validate_param({
        blog_id           => [qw/ID/],
        datasource        => [qw/MAYBE_STRING/],
        id                => [qw/ID/],
        list              => [qw/MAYBE_STRING/],
        not_encode_result => [qw/MAYBE_STRING/],
    }) or return $app->json_error($app->errstr);

    my $id           = $app->param('id');
    my $filter_class = MT->model('filter');
    my $filter       = $filter_class->load($id)
        or return $app->json_error( $app->translate('No such filter') );
    my $blog_id     = $app->param('blog_id') || 0;
    my $ds          = $app->param('datasource');
    my $encode_html = $app->param('not_encode_result') ? 0 : 1;
    my $user        = $app->user;

    if ( $filter->author_id != $user->id && !$user->is_superuser ) {
        return $app->json_error( $app->translate('Permission denied') );
    }
    $filter->remove
        or return $app->json_error(
        $app->translate(
            'Failed to delete filter(s): [_1]', $filter->errstr
        )
        );

    my %res;
    my $list = $app->param('list');
    if ( defined $list && !$list ) {
        my %res;
        my $filters = filters( $app, $ds, encode_html => $encode_html );
        $res{id}      = $filter->id;
        $res{filters} = $filters;
        return $app->json_result( \%res );
    }
    else {

        # Forward to MT::Common::filterd_list
        $app->forward('filtered_list');
    }
}

sub delete_filters {
    my $app = shift;

    $app->validate_param({
        all_selected => [qw/MAYBE_STRING/],
        id           => [qw/IDS MULTI/],
        xhr          => [qw/MAYBE_STRING/],
    }) or return;

    return $app->permission_denied
        unless $app->can_do('delete_any_filters');
    return $app->errtrans('Invalid request')
        unless $app->validate_magic;

    $app->setup_filtered_ids
        if $app->param('all_selected');
    my @ids = $app->multi_param('id');

    # handling either AJAX request and normal request
    @ids = split ',', join ',', @ids;

    my $res = MT->model('filter')->remove( { id => \@ids } )
        or return $app->errtrans(
        'Failed to delete filter(s): [_1]',
        MT->model('filter')->errstr,
        );
    unless ( $res > 0 ) {
        ## if $res is 0E0 ( zero but true )
        return $app->errtrans('No such filter');
    }

    if ( $app->param('xhr') ) {
        $app->forward(
            'filtered_list',
            messages => [
                {   cls => 'success',
                    msg => MT->translate(
                        'Removed [_1] filters successfully.', $res,
                    ),
                }
            ]
        );
    }
    else {
        my %return_arg;
        $return_arg{deleted} = $res;
        $app->add_return_arg(%return_arg);
        return $app->call_return;
    }
}

## Note that these filter loading methods below NOT return instances of MT::Filter class.
## they returns a simple hash structure good to encode to JSON.

sub filter {
    my ( $app, $type, $id ) = @_;
    if ( $id && $id !~ /\D/ ) {
        my $filter = MT->model('filter')->load($id) or return;
        my $hash = $filter->to_hash;
        if ( $app->user->id != $filter->author_id ) {
            return if !$app->user->is_superuser;
            my $owner = MT->model('author')->load( $filter->author_id );
            $hash->{label} = MT->translate( '[_1] ( created by [_2] )',
                $hash->{label}, $owner->name, );
        }
        return $hash;
    }
    return system_filter( $app, $type, $id )
        || legacy_filter( $app, $type, $id );
}

sub system_filter {
    my ( $app, $type, $sys_id ) = @_;
    my $sys_filter = MT->registry( system_filters => $type => $sys_id )
        or return;

    if ( my $cond = $sys_filter->{condition} ) {
        $cond = MT->handler_to_coderef($cond);
        return unless $cond->();
    }
    if ( my $view = $sys_filter->{view} ) {
        $view = [$view] unless ref $view;
        my %view = map { $_ => 1 } @$view;
        my $blog = $app->blog;
        return if !$blog && !$view{system};
        return if $blog  && $blog->is_blog && !$view{blog};
        return if $blog  && !$blog->is_blog && !$view{website};
    }

    my $hash = {
        id         => $sys_id,
        label      => $sys_filter->{label},
        items      => $sys_filter->{items},
        order      => $sys_filter->{order},
        can_edit   => 0,
        can_save   => 0,
        can_delete => 0,
    };
    for my $val ( values %$hash ) {
        $val = $val->() if 'CODE' eq ref $val;
    }
    $hash;
}

sub legacy_filter {
    my ( $app, $type, $legacy_id ) = @_;
    my $legacy_filter
        = MT->registry(
        applications => cms => list_filters => $type => $legacy_id )
        or return;
    if ( my $cond = $legacy_filter->{condition} ) {
        $cond = MT->handler_to_coderef($cond);
        return unless $cond->();
    }
    my $label = $legacy_filter->{label};
    $label = $label->() if 'CODE' eq ref $label;
    my $args = {
        filter_key => $legacy_id,
        ds         => $type,
        filter_val => ( $app->param('filter_val') || '' ),
    };
    $args->{label} = "($label)";

    my $hash = {
        id     => $legacy_id,
        label  => '(Legacy) ' . $label,
        legacy => 1,
        items  => [
            {   type => '__legacy',
                args => $args
            }
        ],
        can_edit   => 0,
        can_save   => 0,
        can_delete => 0,
    };
    for my $val ( values %$hash ) {
        $val = $val->() if 'CODE' eq ref $val;
    }
    $hash;
}

sub filters {
    my ( $app, $type, %opts ) = @_;
    my $obj_class    = MT->model($type);
    my @user_filters = MT->model('filter')
        ->load( { author_id => $app->user->id, object_ds => $type } );
    @user_filters = map { $_->to_hash } @user_filters;

    my @sys_filters;
    my $sys_filters = MT->registry( system_filters => $type );
    for my $sys_id ( keys %$sys_filters ) {
        next if $sys_id =~ /^_/;
        my $sys_filter = system_filter( $app, $type, $sys_id )
            or next;
        push @sys_filters, $sys_filter;
    }
    @sys_filters = sort { $a->{order} <=> $b->{order} } @sys_filters;

    #FIXME: Is this always right path to get it?
    my @legacy_filters;
    my $legacy_filters
        = MT->registry( applications => cms => list_filters => $type );
    for my $legacy_id ( keys %$legacy_filters ) {
        next if $legacy_id =~ /^_/;
        my $legacy_filter = legacy_filter( $app, $type, $legacy_id )
            or next;
        push @legacy_filters, $legacy_filter;
    }

    my @filters = ( @user_filters, @sys_filters, @legacy_filters );
    for my $filter (@filters) {
        my $label = $filter->{label};
        if ( 'CODE' eq ref $label ) {
            $filter->{label} = $label->();
        }
        if ( $opts{encode_html} ) {
            MT::Util::deep_do(
                $filter,
                sub {
                    my $ref = shift;
                    $$ref = MT::Util::encode_html($$ref);
                }
            );
        }
    }
    return \@filters;
}

1;
