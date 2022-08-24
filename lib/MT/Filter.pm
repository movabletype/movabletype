# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Filter;
use strict;
use warnings;
use MT::Serialize;

use base qw( MT::Object );

__PACKAGE__->install_properties(
    {   column_defs => {
            'id'        => 'integer not null auto_increment',
            'author_id' => 'integer not null',
            'blog_id'   => 'integer not null',
            'label'     => 'string(255)',
            'object_ds' => 'string(255)',
            'items'     => 'blob',
        },
        datasource  => 'filter',
        primary_key => 'id',
        audit       => 1,
        indexes     => {
            author_id   => 1,
            created_on  => 1,
            modified_on => 1,
            label       => 1,

            # Load by author with ds
            author_ds => { columns => [ 'author_id', 'object_ds' ], },
        },
    }
);

MT->add_callback( 'restore_filter_item_ids', 5, undef, \&_cb_restore_ids );

sub class_label {
    MT->translate("Filter");
}

sub class_label_plural {
    MT->translate("Filters");
}

{
    my $ser;

    sub items {
        my $self = shift;
        $ser
            ||= MT::Serialize->new('MT'); # force MT serialization for plugins
        if (@_) {
            my $filter = shift;
            if ( ref($filter) ) {
                $self->column( 'items', $ser->serialize( \$filter ) );
            }
            else {
                $self->column( 'items', $filter );
            }
            $filter;
        }
        else {
            my $filter = $self->column('items');
            return undef unless defined $filter;
            my $thawed = $ser->unserialize($filter);
            my $ret = defined $thawed ? $$thawed : undef;
            return $ret;
        }
    }
}

sub list_props {
    return {
        id => {
            base        => '__virtual.id',
            order       => 100,
            view_filter => 'none',
        },
        label => {
            auto    => 1,
            label   => 'Label',
            order   => 200,
            display => 'force',
            raw     => sub {
                my $prop = shift;
                my ( $obj, $app ) = @_;
                my $label = $obj->label;
                $label = '' if !defined $label;
                $label =~ s/^\s+|\s+$//g;
                $label = "(" . $app->translate("No Label") . ")"
                    if $label eq '';
                MT::Util::encode_html($label);
            },
            html_link => sub {
                my $prop = shift;
                my ( $obj, $app ) = @_;

                my $blog  = undef;
                my $scope = undef;
                if ( $obj->blog_id ) {
                    $blog = MT->model('blog')->load( $obj->blog_id );
                    return unless $blog;
                    $scope = $blog->is_blog ? 'blog' : 'website';
                }
                else {
                    $scope = 'system';
                }
                if ($scope ne 'system'
                    && ( my ($content_type_id)
                        = $obj->object_ds
                        =~ /^content_data\.content_data_[0-9]+$/ )
                    )
                {
                    return $app->uri(
                        mode => 'list',
                        args => {
                            _type      => 'content_data',
                            type       => 'content_data_' . $content_type_id,
                            blog_id    => $obj->blog_id,
                            filter_key => $obj->id,
                        },
                    );
                }

                my $list_screen
                    = MT->registry( listing_screens => $obj->object_ds );
                if ($list_screen) {
                    my $can_edit = 0;
                    if ( my $view = $list_screen->{view} ) {
                        $view = [$view] unless ref $view;
                        my %view = map { $_ => 1 } @$view;
                        if ( $scope && $view{$scope} ) {
                            $can_edit = 1;
                        }
                    }
                    else {
                        $can_edit = 1;
                    }
                    return unless $can_edit;
                    return $app->uri(
                        mode => 'list',
                        args => {
                            _type      => $obj->object_ds,
                            blog_id    => $obj->blog_id,
                            filter_key => $obj->id,
                        }
                    );
                }
                else {
                    return;
                }
            },
        },
        author_name => {
            base    => '__virtual.author_name',
            label   => 'Author',
            display => 'default',
            order   => 300,
        },
        author_status => {
            base                  => '__virtual.single_select',
            display               => 'none',
            label                 => 'Author Status',
            single_select_options => [
                { label => MT->translate('Enabled'),  value => 'enabled', },
                { label => MT->translate('Disabled'), value => 'disabled', },
            ],
            terms => sub {
                my $prop = shift;
                my ( $args, $db_terms, $db_args ) = @_;
                my $val = $args->{value};
                if ( $val eq 'deleted' ) {
                    my @all_authors = MT->model('author')
                        ->load( undef, { fetchonly => { id => 1 }, }, );
                    return { author_id =>
                            { not => [ map { $_->id } @all_authors ] }, };
                }
                else {
                    my $status
                        = $val eq 'enabled'
                        ? MT::Author::ACTIVE()
                        : MT::Author::INACTIVE();
                    $db_args->{joins} ||= [];
                    push @{ $db_args->{joins} },
                        MT->model('author')->join_on(
                        undef,
                        {   id     => \'= filter_author_id',
                            status => $status,
                        },
                        );
                }
            },
        },
        object_ds => {
            base        => '__virtual.single_select',
            label       => 'System Object',
            display     => 'force',
            order       => 400,
            screen_name => sub {
                my $prop = shift;
                my ($screen_id) = @_;
                my $reg = MT->registry( listing_screens => $screen_id );
                my $label = $reg->{label} || $reg->{object_label};
                if ( !$label ) {
                    my $class = $reg->{object_type} || $screen_id;
                    my $cls = MT->model($class);
                    $label
                        = $class
                        ? (
                        $cls ? $cls->class_label : MT->translate('Deleted') )
                        : $prop->class;
                }
                return ref $label ? $label->() : $label;
            },
            html => sub {
                my $prop = shift;
                my ( $obj, $app ) = @_;
                $prop->screen_name( $obj->object_ds );
            },
            bulk_sort => sub {
                my $prop = shift;
                my ($objs) = @_;
                return sort { $prop->html($a) cmp $prop->html($b) } @$objs;
            },
            single_select_options => sub {
                my $prop  = shift;
                my $app   = MT->app;
                my $lists = MT->registry('listing_screens');
                my @lists;
                for my $key ( keys %$lists ) {
                    my $list = MT->registry( 'listing_screens', $key );
                    my $cond = $list->{condition};
                    if ($cond) {
                        $cond = MT->handler_to_coderef($cond)
                            unless ref $cond;
                        $cond->($app) or next;
                    }
                    push @lists, $key;
                }
                $app->error(undef);
                return [
                    sort { $a->{label} cmp $b->{label} }
                        map {
                        {   label => $prop->screen_name($_),
                            value => $_,
                        }
                        } @lists
                ];
            },
        },
        created_on => {
            base    => '__virtual.created_on',
            display => 'default',
            order   => 500,
        },
        modified_on => {
            base  => '__virtual.modified_on',
            order => 600,
        },
        blog_name       => { view => 0 },
        current_context => { view => 0 },
    };
}

sub append_item {
    my $self  = shift;
    my $item  = shift;
    my $items = $self->items || [];
    push @$items, $item;
    $self->items($items);
}

sub to_hash {
    my $self = shift;
    return {
        id         => $self->id,
        label      => $self->label,
        items      => $self->items,
        can_edit   => 1,
        can_save   => 1,
        can_delete => 1,
    };
}

sub load_objects {
    my $self = shift;
    my (%options) = @_;
    my ( $terms, $args, $sort, $dir, $limit, $offset )
        = @options{ 'terms', 'args', 'sort_by', 'sort_order', 'limit',
        'offset' };
    my $ds       = $self->object_ds;
    my $setting  = MT->registry( listing_screens => $ds ) || {};
    my $obj_type = $setting->{object_type} || $ds;
    my $class    = MT->model($obj_type);
    my $items    = $self->items;
    my $total    = $options{total};
    if ( !defined($total) ) {
        my $count_result = $self->count_objects(@_)
            or return;
        ($total) = @$count_result;
    }
    my @items;
    require MT::ListProperty;

    ## Prepare properties
    for my $item (@$items) {
        my $id = $item->{type};
        my $prop = MT::ListProperty->instance( $ds, $id )
            or return $self->error(
            MT->translate( 'Invalid filter type [_1]:[_2]', $ds, $id ) );
        $item->{prop} = $prop;
        push @items, $item;
    }
    @items = sort {
        ( $a->{prop}->priority || 5 ) <=> ( $b->{prop}->priority || 5 )
    } @items;
    my @grep_items = grep {
              $_->{prop}->has('requires_grep')
            ? $_->{prop}->requires_grep( $_->{args} )
            : $_->{prop}->has('grep');
    } @items;

    ## Prepare terms
    my @additional_terms;
    for my $item (@items) {
        my $prop = $item->{prop};
        $prop->has('terms') or next;
        my $filter_terms
            = $prop->terms( $item->{args}, $terms, $args, \%options )
            or next;
        if ( ( $item->{args}{option} || q{} ) eq 'not_contains'
            && $class->has_column( $item->{type} ) )
        {
            $filter_terms
                = [ $filter_terms, '-or', { $item->{type} => \'IS NULL' } ];
        }
        if (   ( 'HASH' eq ref $filter_terms && scalar %$filter_terms )
            || ( 'ARRAY' eq ref $filter_terms && scalar @$filter_terms ) )
        {
            push @additional_terms, ( '-and', $filter_terms );
        }
    }
    if ( scalar @additional_terms ) {
        if (   !$terms
            || ( 'HASH' eq ref $terms  && !scalar %$terms )
            || ( 'ARRAY' eq ref $terms && !scalar @$terms ) )
        {
            shift @additional_terms;
            $terms = [@additional_terms];
        }
        else {
            $terms = [ $terms, @additional_terms ];
        }
    }

    my $sort_prop;
    if ($sort) {
        $sort_prop = MT::ListProperty->instance( $ds, $sort );
        if ( !$sort_prop || !$sort_prop->can_sort( $options{scope} ) ) {
            return $self->error(
                MT->translate( 'Invalid sort key [_1]:[_2]', $ds, $sort ) );
        }
    }
    my $has_post_process = scalar @grep_items
        || (
        $sort_prop
        && (   $sort_prop->has('sort_method')
            || $sort_prop->has('bulk_sort') )
        );
    if ( !$has_post_process ) {
        $args->{limit}  = $limit  if $limit;
        $args->{offset} = $offset if $offset;
    }

    ## It's time to load now.
    my @objs;
    if ( $sort_prop && $sort_prop->has('sort') ) {
        $args->{direction}
            = ( $dir && $dir eq 'descend' ) ? 'descend' : 'ascend';
        my $sort_result = $sort_prop->sort( $terms, $args, \%options );
        if ( $sort_result && 'ARRAY' eq ref $sort_result ) {
            return if !scalar @$sort_result;
            if ( !ref $sort_result->[0] ) {
                @objs = $class->load( { id => $sort_result } )
                    or return $self->error( $class->errstr );
            }
            else {
                @objs = @$sort_result;
            }
        }
        else {
            @objs = $class->load( $terms, $args )
                or return $self->error( $class->errstr );
        }
    }
    else {
        @objs = $class->load( $terms, $args )
            or return $self->error( $class->errstr );
    }

    for my $item (@grep_items) {
        @objs = $item->{prop}->grep( $item->{args}, \@objs, \%options );
    }

    if ( $sort_prop && $sort_prop->has('bulk_sort') ) {
        @objs = $sort_prop->bulk_sort( \@objs, \%options );
        @objs = reverse @objs
            if ( $dir && $dir eq 'descend' );
    }
    elsif ( $sort_prop && $sort_prop->has('sort_method') ) {
        @objs = sort { $sort_prop->sort_method( $a, $b ) } @objs;
        @objs = reverse @objs
            if ( $dir && $dir eq 'descend' );
    }

    if (   $has_post_process
        && $limit
        && $limit < scalar @objs )
    {
        my $max
            = scalar @objs < $limit + $offset
            ? scalar @objs - 1
            : $limit + $offset - 1;
        @objs = @objs[ $offset .. $max ];
    }

    @objs = grep defined $_, @objs;

    return \@objs;
}

sub count_objects {
    my $self = shift;
    my (%options) = @_;
    my ( $terms, $args ) = @options{qw( terms args )};
    my ( $editable_terms, $editable_args, $editable_filters )
        = @options{qw( editable_terms editable_args editable_filters )};
    if ( $editable_terms || $editable_args ) {
        $editable_terms ||= $terms;
        $editable_args  ||= $args;
    }
    my ( $count, $editable_count );

    return $self->error(
        MT->translate(
            '"editable_terms" and "editable_filters" cannot be specified at the same time.'
        )
    ) if $editable_terms && $editable_filters;

    # my $blog_id   = $options{terms}{blog_id};
    my $ds       = $self->object_ds;
    my $setting  = MT->registry( listing_screens => $ds ) || {};
    my $obj_type = $setting->{object_type} || $ds;
    my $class    = MT->model($obj_type);
    my $items    = $self->items;
    require MT::ListProperty;
    my @items;

    ## Prepare properties
    for my $item (@$items) {
        my $id = $item->{type};
        my $prop = MT::ListProperty->instance( $ds, $id )
            or return $self->error(
            MT->translate( 'Invalid filter type [_1]:[_2]', $ds, $id ) );
        $item->{prop} = $prop;
        push @items, $item;
    }
    @items = sort {
        ( $a->{prop}->priority || 5 ) <=> ( $b->{prop}->priority || 5 )
    } @items;
    my @grep_items = grep {
              $_->{prop}->has('requires_grep')
            ? $_->{prop}->requires_grep( $_->{args} )
            : $_->{prop}->has('grep');
    } @items;

    ## Prepare terms
    my $update_terms = sub {
        my ( $terms, $args ) = @_;
        my @additional_terms;
        for my $item (@items) {
            my $prop = $item->{prop};
            my $code = $prop->has('terms') or next;
            my $filter_terms
                = $prop->terms( $item->{args}, $terms, $args, \%options );
            if ( ( $item->{args}{option} || q{} ) eq 'not_contains'
                && $class->has_column( $item->{type} ) )
            {
                $filter_terms
                    = [ $filter_terms, '-or',
                    { $item->{type} => \'IS NULL' } ];
            }
            if ( $filter_terms
                && ( 'HASH' eq ref $filter_terms  && scalar %$filter_terms )
                || ( 'ARRAY' eq ref $filter_terms && scalar @$filter_terms ) )
            {
                push @additional_terms, ( '-and', $filter_terms );
            }
        }
        if ( scalar @additional_terms ) {
            if (   !$terms
                || ( 'HASH' eq ref $terms  && !scalar %$terms )
                || ( 'ARRAY' eq ref $terms && !scalar @$terms ) )
            {
                shift @additional_terms;
                \@additional_terms;
            }
            else {
                [ $terms, @additional_terms ];
            }
        }
        else {
            $terms;
        }
    };
    $terms = $update_terms->( $terms, $args );
    if ($editable_terms) {
        $editable_terms = $update_terms->( $editable_terms, $editable_args );
    }

    if ( !( scalar @grep_items ) && !$editable_filters ) {
        $editable_count = $count = $class->count( $terms, $args );
        if ($editable_terms) {
            $editable_count
                = $class->count( $editable_terms, $editable_args );
        }

        return $self->error( $class->errstr ) unless defined $count;
        return [ $count, $editable_count ];
    }
    my @objs = $class->load( $terms, $args );

    for my $item (@grep_items) {
        @objs = $item->{prop}->grep( $item->{args}, \@objs, \%options );
    }

    $editable_count = $count = scalar @objs;
    if ($editable_filters) {
        for my $filter (@$editable_filters) {
            @objs = $filter->( \@objs, \%options );
        }
        $editable_count = scalar @objs;
    }

    [ $count, $editable_count ];
}

sub pack_terms {
    my $prop = shift;
    my ( $args, $load_terms, $load_args, $options ) = @_;
    my $op = $args->{op} || 'and';
    $op = '-' . $op;
    my $items = $args->{items};
    my $ds    = $prop->{class};
    my @items;
    require MT::ListProperty;

    for my $item (@$items) {
        my $id = $item->{type};
        my $list_prop = MT::ListProperty->instance( $ds, $id )
            or die "Invalid Filter $id";
        $item->{prop} = $list_prop;
        push @items, $item;
    }

    @items = sort {
        ( $a->{prop}->priority || 5 ) <=> ( $b->{prop}->priority || 5 )
    } @items;
    my @terms;
    for my $item (@items) {
        my $prop = $item->{prop};
        $prop->has('terms') or next;
        my $filter_terms
            = $prop->terms( $item->{args}, $load_terms, $load_args,
            $options );
        if ( $filter_terms
            && ( 'HASH' eq ref $filter_terms  && scalar %$filter_terms )
            || ( 'ARRAY' eq ref $filter_terms && scalar @$filter_terms ) )
        {
            push @terms, $op if scalar @terms > 0;
            push @terms, $filter_terms;
        }
    }

    return scalar @terms ? \@terms : undef;
}

sub pack_grep {
    my $prop = shift;
    my ( $args, $objs, $opts ) = @_;
    my @objs  = @$objs;
    my $op    = $args->{op} || 'and';
    my $items = $args->{items};
    my $ds    = $prop->{class};
    my @items;
    require MT::ListProperty;

    for my $item (@$items) {
        my $id = $item->{type};
        my $list_prop = MT::ListProperty->instance( $ds, $id )
            or die "Invalid Filter $id";
        $item->{prop} = $list_prop;
        push @items, $item;
    }

    @items = sort {
        ( $a->{prop}->priority || 5 ) <=> ( $b->{prop}->priority || 5 )
    } @items;
    for my $item (@items) {
        my $prop = $item->{prop};
        $prop->has('grep') or next;
        @objs = $prop->grep( $item->{args}, \@objs, $opts );
    }
    return @objs;
}

sub pack_requires_grep {
    my $prop   = shift;
    my ($args) = @_;
    my $items  = $args->{items};
    my $ds     = $prop->{class};

    my @items;
    require MT::ListProperty;

    for my $item (@$items) {
        my $id = $item->{type};
        my $list_prop = MT::ListProperty->instance( $ds, $id )
            or die "Invalid Filter $id";
        return 1 if $list_prop->has('grep');
    }

    return 0;
}

sub _cb_restore_ids {
    my $cb = shift;
    my ( $obj, $data, $objects ) = @_;
    my $items = $obj->items;

    foreach my $item (@$items) {
        if ( 'category_id' eq $item->{type} ) {
            my $old_id = $item->{args}->{value};
            if ( exists $objects->{ 'MT::Category#' . $old_id } ) {
                $item->{args}->{value}
                    = $objects->{ 'MT::Category#' . $old_id }->id;
            }
        }
        elsif ( 'folder_id' eq $item->{type} ) {
            my $old_id = $item->{args}->{value};
            if ( exists $objects->{ 'MT::Folder#' . $old_id } ) {
                $item->{args}->{value}
                    = $objects->{ 'MT::Folder#' . $old_id }->id;
            }
        }
        elsif ( 'role' eq $item->{type} ) {
            my $old_id = $item->{args}->{value};
            if ( exists $objects->{ 'MT::Role#' . $old_id } ) {
                $item->{args}->{value}
                    = $objects->{ 'MT::Role#' . $old_id }->id;
            }
        }
    }
    $obj->items($items);
}

1;
__END__

=head1 NAME

MT::Filter - Movable Type filter record

=head1 SYNOPSIS

    use MT::Filter;
    my $filter = MT::Filter->new;
    $filter->object_ds('entry');
    $filter->items([
        {
            type => 'title',
            args => {
                option => 'equal',
                string => 'foo',
            },
        }
        {
            type => 'created_on',
            args => {
                option => 'after',
                origin => '2010-10-21',
            },
        }
    ]);
    my @objs = $filter->load_objects;
    $filter->save
        or die $filter->errstr;

=head1 DESCRIPTION

An I<MT::Filter> object represents a filter that user creates in each listing screen.
It contains the detail of filtering, and also can execute the filter and fetch the
objects that can pass the filter.

=head1 USAGE

As a subclass of I<MT::Object>, I<MT::Filter> inherits all of the
data-management and -storage methods from that class; thus you should look
at the I<MT::Object> documentation for details about creating a new object,
loading an existing object, saving an object, etc.

The following methods are unique to the I<MT::Filter> interface:

=head2 $filter->count_objects( %options )

Returns a number of objects which specified by the filter.

=over 4

=item *  terms

Basic temrs which passed to I<Data::ObjectDriver> load method.

=item *  args

Basic args which passed to I<Data::ObjectDriver> load method.

=back

=head2 $filter->load_objects( %options )

Execute the filter and returns loaded objects.

=over 4

=item *  terms => $terms

Basic temrs which passed to I<Data::ObjectDriver> load method.

=item *  args => $args

Basic args which passed to I<Data::ObjectDriver> load method.

=item *  sort_by => "property"

Specify the property id to sort to. The id MUST be combined to
I<MT::ListProperty> object that can execute sorting.

=item *  sort_order => "ascend|descend"

To be used together with a scalar I<sort> value; specifies the sort
order (ascending or descending). The default is C<ascend>.

=item *  limit => "N"

Rather than loading all of the matching objects (the default), load only
C<N> objects.

=item *  offset => "M"

To be used together with I<limit>; rather than returning the first C<N>
matches (the default), return matches C<M> through C<N + M>.

=back

=head2 $filter->append_item( $item )

Add filter item to filter object.

=head1 DATA ACCESS METHODS

The I<MT::Filter> object holds the following pieces of data. These fields can
be accessed and set using the standard data access methods described in the
I<MT::Object> documentation.

=over 4

=item * id

The numeric ID of the filter.

=item * blog_id

The numeric ID of the blog in which this filter has been created.

=item * author_id

The numeric ID of the author who created this filter.

=item * label

The label of the filter.

=item * items

The filter items that contains the detail of filtering logic based on I<MT::ListProperty>
data tree.

=back

=head1 FILTER ITEMS

Items is an arrey ref of the hash ref contains keys I<type> and I<args>. Each hash ref,
called I<Item>, is combined to proper ListProperty which specified by filter object's
object_ds and I<type> value, and give I<args> to ListProperty for executing the filter.

=head1 AUTHOR & COPYRIGHTS

Please see the I<MT> manpage for author, copyright, and license information.

=cut
