# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::App::Search::ContentData;
use strict;
use warnings;
use base 'MT::App::Search';

use Lucene::QueryParser ();
use Storable            ();

use MT::ContentStatus ();
use MT::Util;

sub id                   {'cd_search'}
sub archive_listing_type {'ct_archive'}
sub default_type         {'content_data'}
sub search_template_type {'cd_search_results'}

sub search_params {
    qw( searchTerms search content_field archive_type author year month day );
}

sub context_params {
    qw( limit_by author content_field page year month day archive_type template_id );
}

sub ExcludeBlogs { $_[0]->config->ContentDataExcludeBlogs }
sub IncludeBlogs { $_[0]->config->ContentDataIncludeBlogs }

sub SearchAlwaysAllowTemplateID {
    $_[0]->config->ContentDataSearchAlwaysAllowTemplateID;
}

sub SearchAltTemplates {
    +(  $_[0]->config->default('ContentDataSearchAltTemplate'),
        $_[0]->config->ContentDataSearchAltTemplate
    );
}
sub SearchCacheTTL { $_[0]->config->ContentDataSearchCacheTTL }

sub SearchDefaultTemplate {
    $_[0]->config->ContentDataSearchDefaultTemplate;
}
sub SearchMaxResults    { $_[0]->config->ContentDataSearchMaxResults }
sub SearchNoOverride    { $_[0]->config->ContentDataSearchNoOverride }
sub SearchResultDisplay { $_[0]->config->ContentDataSearchResultDisplay }
sub SearchSortBy        { $_[0]->config->ContentDataSearchSortBy }
sub SearchTemplatePath  { $_[0]->config->ContentDataSearchTemplatePath }

sub SearchThrottleIPWhitelist {
    $_[0]->config->ContentDataSearchThrottleIPWhitelist;
}

sub SearchThrottleSeconds {
    $_[0]->config->ContentDataSearchThrottleSeconds;
}

sub core_methods {
    my $app = shift;
    +{ default => \&MT::App::Search::process };
}

sub core_parameters {
    my $app = shift;
    +{  params => [
            qw( searchTerms search count limit startIndex offset author content_field )
        ],
        types => {
            content_data => {
                sort         => 'authored_on',
                terms        => \&_filter_terms,
                filter_types => {
                    author        => \&MT::App::Search::_join_author,
                    content_field => \&_join_content_field,
                },
            },
        },
        cache_driver => { 'package' => 'MT::Cache::Negotiate' },
    };
}

sub init_request {
    my $app = shift;
    $app->SUPER::init_request(@_);
    $app->{searchparam}{Type} = $app->default_type;
    $app->_parse_search_content_types;
}

sub get_limit {
    my $app   = shift;
    my $limit = $app->param('limit')
        || $app->SearchMaxResults;
    $limit;
}

sub prepare_context {
    my $app = shift;
    my $ctx = $app->SUPER::prepare_context(@_);
    $ctx->stash( 'stash_key', 'content' );
    $ctx->stash( 'user', $app->user ) if $app->user;
    $ctx->stash( 'search_content_types',
        $app->{searchparam}{SearchContentTypes} );
    $ctx->stash( 'search_content_type_id',
        $app->{searchparam}{SearchContentTypeID} );
    $ctx;
}

sub query_parse {
    my $app = shift;
    my ($orig_terms) = @_;

    my $search = $app->{search_string};

    my $reg
        = $app->registry( $app->mode, 'types', $app->{searchparam}{Type} );
    my $filter_types = $reg->{'filter_types'};
    foreach my $type ( keys %$filter_types ) {
        my @filters = $app->multi_param($type);
        foreach my $filter (@filters) {
            if ( $filter =~ m/\s/ ) {
                $filter = '"' . $filter . '"';
            }
            $search .= " $type:$filter";
        }
    }

    my $lucene_struct = eval { Lucene::QueryParser::parse_query($search); };
    if ($@) {
        warn $@ if $MT::DebugMode;
        return;
    }

    my $terms = $app->_query_parse_terms( $lucene_struct, $filter_types,
        $orig_terms );
    my $joins = $app->_query_parse_filter( $lucene_struct, $filter_types );

    my $return = { $terms && @$terms ? ( terms => $terms ) : () };
    if ( $joins && @$joins ) {
        $return->{args} = { joins => $joins };
    }
    $return;
}

sub _query_parse_filter {
    my $app = shift;
    my ( $lucene_struct, $filter_types ) = @_;

    $lucene_struct = Storable::dclone($lucene_struct);
    my @joins;

    while ( my $term = shift @$lucene_struct ) {
        if ( 'TERM' eq $term->{query} || 'PHRASE' eq $term->{query} ) {
            if (   exists $term->{field}
                && $filter_types
                && %$filter_types
                && exists $filter_types->{ $term->{field} } )
            {
                my $code = $app->handler_to_coderef(
                    $filter_types->{ $term->{field} } );
                if ($code) {
                    my $join_args = $code->( $app, $term ) or next;
                    push @joins,
                        ( 'ARRAY' eq ref $join_args->[0] )
                        ? @$join_args
                        : $join_args;
                    next;
                }
            }
        }
        elsif ( 'SUBQUERY' eq $term->{query} ) {
            my $more_joins = $app->_query_parse_filter( $term->{subquery},
                $filter_types );
            push @joins, @$more_joins;
            next;
        }
    }

    \@joins;
}

sub _query_parse_terms {
    my $app = shift;
    my ( $lucene_struct, $filter_types, $orig_terms ) = @_;

    $lucene_struct = Storable::dclone($lucene_struct);
    my @structure;

    while ( my $term = shift @$lucene_struct ) {
        if (   exists $term->{field}
            && $filter_types
            && %$filter_types
            && !exists $filter_types->{ $term->{field} } )
        {
            # Colon in query but was not to specify a field.
            # Treat it as a phrase including the colon.
            my $field = delete $term->{field};
            $term->{term} = $field . ':' . $term->{term};
        }

        my @tmp;
        if ( 'TERM' eq $term->{query} || 'PHRASE' eq $term->{query} ) {
            unless ( exists $term->{field} ) {
                if ( 'PROHIBITED' eq $term->{type} ) {
                    push @tmp,
                        $app->_get_not_terms( $term->{term}, $orig_terms );
                }
                else {
                    push @tmp,
                        $app->_get_normal_terms( $term->{term}, $orig_terms );
                }
            }
        }
        elsif ( 'SUBQUERY' eq $term->{query} ) {
            my $test_ = $app->_query_parse_terms( $term->{subquery},
                $filter_types, $orig_terms );
            next unless $test_ && @$test_;
            if (@structure) {
                push @structure,
                    ( 'PROHIBITED' eq $term->{type} ) ? '-and_not' : '-and';
            }
            push @structure, @$test_;
            next;
        }

        if ( exists $term->{conj} && 'OR' eq $term->{conj} ) {
            if ( my $prev = pop @structure ) {
                push @structure, [ $prev, '-or', \@tmp ];
            }
        }
        elsif (@tmp) {
            if (@structure) {
                push @structure, '-and';
            }
            push @structure, \@tmp;
        }
    }

    \@structure;
}

sub _get_not_terms {
    my $app = shift;
    my ( $value, $orig_terms ) = @_;

    my $actual_ids
        = $app->_get_not_ids_common( $value, $orig_terms,
        '_get_normal_ids_for_actual_fields' );
    my $reference_ids
        = $app->_get_not_ids_common( $value, $orig_terms,
        '_get_normal_ids_for_reference_fields' );
    my $content_type_ids
        = $app->_get_not_ids_common( $value, $orig_terms,
        '_get_normal_ids_for_content_type_field' );

    my $id_set_count
        = ( $actual_ids       ? 1 : 0 )
        + ( $reference_ids    ? 1 : 0 )
        + ( $content_type_ids ? 1 : 0 );
    return +{ id => \'> 0' } unless $id_set_count;

    my %content_data_ids;
    $content_data_ids{$_}++
        for (
        $actual_ids       ? @$actual_ids       : (),
        $reference_ids    ? @$reference_ids    : (),
        $content_type_ids ? @$content_type_ids : (),
        );
    my @content_data_ids = grep { $content_data_ids{$_} == $id_set_count }
        keys %content_data_ids;
    +{ id => @content_data_ids ? \@content_data_ids : 0 };
}

sub _get_normal_terms {
    my $app = shift;
    my ( $value, $orig_terms ) = @_;
    my %content_data_ids = map { $_ => 1 } (
        @{  $app->_get_normal_ids_for_actual_fields( $value, $orig_terms )
        },
        @{  $app->_get_normal_ids_for_reference_fields( $value, $orig_terms )
        },
        @{  $app->_get_normal_ids_for_content_type_field( $value,
                $orig_terms )
        },
    );
    +{ id => %content_data_ids ? [ keys %content_data_ids ] : 0 };
}

sub search_terms {
    my $app = shift;

    if ( my $limit = $app->param('limit_by') ) {
        if ( $limit eq 'all' ) {

            # this is the default behavior
        }
        else {
            my $search = $app->param('search');
            my @words  = split( / +/, $search );
            if ( $limit eq 'any' ) {
                $search = join( ' OR ', @words );
            }
            elsif ( $limit eq 'exclude' ) {
                $search = 'NOT ' . join( ' NOT ', @words );
            }
            $app->param( 'search', $search );
        }
    }

    # check if archive type is legal
    if ( $app->param('archive_type') ) {
        my $at       = $app->param('archive_type');
        my $archiver = MT->publisher->archiver($at);
        return $app->errtrans('Invalid archive type')
            unless ( $archiver || $at eq 'Index' );
    }

    my $search_string = $app->param('searchTerms') || $app->param('search');
    $app->{search_string} = $search_string;
    my $offset = $app->param('startIndex') || $app->param('offset') || 0;
    return $app->errtrans( 'Invalid value: [_1]',
        MT::Util::encode_html($offset) )
        if $offset && $offset !~ /^\d+$/;
    my $limit = $app->param('count') || $app->param('limit');
    return $app->errtrans( 'Invalid value: [_1]',
        MT::Util::encode_html($limit) )
        if $limit && $limit !~ /^\d+$/;
    my $max = $app->{searchparam}{SearchMaxResults};
    $max =~ s/\D//g if defined $max;
    $limit = $max if !$limit || ( $limit - $offset > $max );

    my $params
        = $app->registry( $app->mode, 'types', $app->{searchparam}{Type} );
    my %def_terms = ();
    if ( exists( $params->{terms} ) ) {
        if ( 'HASH' ne ref $params->{terms} ) {
            my $code = $params->{terms};
            $code = MT->handler_to_coderef($code);
            eval { %def_terms = %{ $code->($app) }; };
        }
        else {
            %def_terms = %{ $params->{terms} };
        }
    }
    delete $def_terms{'plugin'};

    if ( my $incl_blogs = $app->{searchparam}{IncludeBlogs} ) {
        $def_terms{blog_id} = $incl_blogs;
    }
    if ( my $search_content_type_id
        = $app->{searchparam}{SearchContentTypeID} )
    {
        $def_terms{content_type_id} = $search_content_type_id;
    }

    my @terms;
    if (%def_terms) {
        my $type        = $app->{searchparam}{Type};
        my $model_class = MT->model($type);

        delete $def_terms{blog_id}
            unless $model_class->can('blog_id');

        delete $def_terms{content_type_id}
            unless $model_class->can('content_type_id');

       # If we have a term for the model's class column, add it separately, so
       # array search() doesn't add the default class column term.
        if ( my $class_col = $model_class->properties->{class_column} ) {
            if ( $def_terms{$class_col} ) {
                push @terms, { $class_col => delete $def_terms{$class_col} };
            }
        }

        push @terms, \%def_terms;
    }

    my ( $date_start, $date_end );
    if ( $app->param('archive_type') && $app->param('year') ) {
        my $year         = $app->param('year');
        my $month        = $app->param('month') ? $app->param('month') : '01';
        my $day          = $app->param('day') ? $app->param('day') : '01';
        my $archive_type = $app->param('archive_type');
        require MT::Util;
        if ( $archive_type =~ /Daily/i ) {
            ( $date_start, $date_end )
                = MT::Util::start_end_day( $year . $month . $day );
        }
        elsif ( $archive_type =~ /Weekly/i ) {
            ( $date_start, $date_end )
                = MT::Util::start_end_week( $year . $month . $day );
        }
        elsif ( $archive_type =~ /Monthly/i ) {
            ( $date_start, $date_end )
                = MT::Util::start_end_month( $year . $month . $day );
        }
        elsif ( $archive_type =~ /Yearly/i ) {
            ( $date_start, $date_end )
                = MT::Util::start_end_year( $year . $month . $day );
        }
        $app->param( 'context_date_start', $date_start );

        if ( my $date_field = $app->param('date_field') ) {
            my $iter = $app->model('content_data')->load_iter(
                \@terms,
                {   fetchonly => { id => 1 },
                    join      => $app->model('content_field')->join_on(
                        undef,
                        [   {   content_type_id => \'= cd_content_type_id',
                                type => [ 'date_and_time', 'date_only' ],
                            },
                            [   { name => $date_field },
                                '-or',
                                { unique_id => $date_field },
                            ],
                        ],
                        {   join =>
                                $app->model('content_field_index')->join_on(
                                undef,
                                {   content_data_id  => \'= cd_id',
                                    content_field_id => \'= cf_id',
                                    value_datetime   => {
                                        between => [ $date_start, $date_end ]
                                    },
                                },
                                { unique => 1 },
                                ),
                        },
                    ),
                },
            );
            my %content_data_ids;
            while ( my $content_data = $iter->() ) {
                $content_data_ids{ $content_data->id } = 1;
            }
            $terms[0]->{id}
                = %content_data_ids ? [ keys %content_data_ids ] : 0;
        }
        else {
            $terms[0]->{authored_on}
                = { between => [ $date_start, $date_end ] };
        }
    }

    my $parsed = $app->query_parse( \@terms );
    return $app->errtrans( 'Invalid query: [_1]',
        MT::Util::encode_html($search_string) )
        if ( ( !$parsed || !(%$parsed) )
        && !$app->param('archive_type') );

    push @terms, $parsed->{terms} if exists $parsed->{terms};

    my $desc
        = 'descend' eq $app->{searchparam}{SearchResultDisplay}
        ? 'DESC'
        : 'ASC';
    my @sort;
    my $sort = $params->{'sort'};
    if ( $sort !~ /\w+\!$/ && $app->{searchparam}{SearchSortBy} ) {
        my $sort_by = $app->{searchparam}{SearchSortBy};
        $sort_by =~ s/[^\w\-\.\,:]+//g;
        if ($sort_by) {
            my @sort_bys = split ',', $sort_by;
            foreach my $key (@sort_bys) {
                push @sort,
                    {
                    desc   => $desc,
                    column => $key
                    };
            }
        }
    }
    push @sort,
        {
        desc   => $desc,
        column => $sort
        };
    my %args = (
        exists( $parsed->{args} ) ? %{ $parsed->{args} } : (),
        $limit  ? ( 'limit'  => $limit )  : (),
        $offset ? ( 'offset' => $offset ) : (),
        @sort   ? ( 'sort'   => \@sort )  : (),
    );

    ( \@terms, \%args );
}

sub _parse_search_content_types {
    my $app = shift;

    if ( ( $app->param('SearchContentTypes') || '' ) eq 'all' ) {
        $app->param( 'SearchContentTypes', undef );
    }

    my $search_content_types;
    unless ( $app->_get_no_override('SearchContentTypes') ) {
        $search_content_types = $app->param('SearchContentTypes');
    }
    unless ( defined $search_content_types && $search_content_types ne '' ) {
        $search_content_types = $app->config->SearchContentTypes;
    }

    return
        unless defined $search_content_types && $search_content_types ne '';

    my $can_search_by_id = $search_content_types =~ /^(?:[0-9]+|AND|OR|NOT|[ \(\)])+$/i ? 1 : 0;

    my $lucene_struct
        = eval { Lucene::QueryParser::parse_query($search_content_types) };
    return $app->error(
        $app->translate(
            'Invalid SearchContentTypes "[_1]": [_2]',
            MT::Util::encode_html($search_content_types),
            $@
        )
    ) if $@;

    my %columns = (
        name      => 1,
        unique_id => 1,
        $can_search_by_id ? ( id => 1 ) : (),
    );
    my %filter_types = ();
    my ($terms)
        = $app->_query_parse_core( $lucene_struct, \%columns,
        \%filter_types );
    return $app->error(
        $app->translate(
            'Invalid SearchContentTypes: [_1]',
            MT::Util::encode_html($search_content_types)
        )
    ) unless $terms && @$terms;

    my @content_type_ids;
    my $iter = $app->model('content_type')
        ->load_iter( $terms, { fetchonly => { id => 1 } } );
    while ( my $content_type = $iter->() ) {
        push @content_type_ids, $content_type->id;
    }

    $app->{searchparam}{SearchContentTypes}  = $search_content_types;
    $app->{searchparam}{SearchContentTypeID} = \@content_type_ids;
}

sub _get_not_ids_common {
    my $app = shift;
    my ( $value, $orig_terms, $method ) = @_;
    my @normal_ids = @{ $app->$method( $value, $orig_terms ) };
    return unless @normal_ids;
    my $terms = [ $orig_terms, { id => { not => \@normal_ids } }, ];
    my $args  = {
        fetchonly => { id => 1 },
        unique    => 1,
    };
    my %content_data_ids;
    my $iter = MT->model('content_data')->load_iter( $terms, $args );

    while ( my $content_data = $iter->() ) {
        $content_data_ids{ $content_data->id } = 1;
    }
    [ keys %content_data_ids ];
}

sub _get_normal_ids_for_actual_fields {
    my $app = shift;
    my ( $value, $orig_terms ) = @_;
    my $args = {
        fetchonly => { id => 1 },
        joins     => [
            MT->model('content_field_index')->join_on(
                undef,
                [   { content_data_id => \'= cd_id' },
                    [   { value_varchar => { like => "%$value%" } },
                        '-or',
                        { value_text => { like => "%$value%" } },
                        '-or',
                        { value_float => { like => "%$value%" } },
                        '-or',
                        { value_double => { like => "%$value%" } },
                    ],
                ],
                {   join => MT->model('content_field')->join_on(
                        undef,
                        {   id   => \'= cf_idx_content_field_id',
                            type => $app->model('content_type')
                                ->searchable_field_types_for_search,
                        },
                    ),
                    unique => 1,
                },
            ),
        ],
    };
    my $iter = MT->model('content_data')->load_iter( $orig_terms, $args );
    my %content_data_ids;
    while ( my $content_data = $iter->() ) {
        $content_data_ids{ $content_data->id } = 1;
    }
    [ keys %content_data_ids ];
}

sub _get_normal_ids_for_reference_fields {
    my $app = shift;
    my ( $value, $orig_terms ) = @_;

    my %content_data_ids;
    my $registry = $app->registry('content_field_types');
    for my $type ( keys %$registry ) {
        my $type_registry = $registry->{$type};
        next
            unless $type_registry->{data_type} eq 'integer'
            && $type_registry->{search_class}
            && $type_registry->{search_columns};
        my @terms = map { +( '-or', +{ $_ => +{ like => "%$value%" } } ) }
            @{ $type_registry->{search_columns} };
        shift @terms;
        my $args = {
            fetchonly => { id => 1 },
            joins     => [
                MT->model('content_field_index')->join_on(
                    undef,
                    { content_data_id => \'= cd_id' },
                    {   joins => [
                            MT->model( $type_registry->{search_class} )
                            ->join_on(
                            undef,
                            [ { id => \'= cf_idx_value_integer' }, \@terms, ],
                            ),
                            MT->model('content_field')->join_on(
                                undef,
                                { id => \'= cf_idx_content_field_id', type => $type },
                            ),
                        ],
                    },
                ),
            ],
            unique => 1,
        };
        my $iter = MT->model('content_data')->load_iter( $orig_terms, $args );
        while ( my $content_data = $iter->() ) {
            $content_data_ids{ $content_data->id } = 1;
        }
    }

    [ keys %content_data_ids ];
}

sub _get_normal_ids_for_content_type_field {
    my $app = shift;
    my ( $value, $orig_terms ) = @_;

    my $iter = $app->model('content_field_index')->load_iter(
        undef,
        {   joins => [
                $app->model('content_data')->join_on(
                    undef,
                    [ @$orig_terms, { id => \'= cf_idx_content_data_id', }, ],
                ),
                $app->model('content_field')->join_on(
                    undef,
                    {   id   => \'= cf_idx_content_field_id',
                        type => 'content_type',
                    },
                ),
            ],
            unique => 1,
        },
    );

    my %parent_content_data_ids;
    while ( my $content_field_index = $iter->() ) {
        $parent_content_data_ids{ $content_field_index->value_integer } = 1;
    }

    return [] unless %parent_content_data_ids;

    my $terms_for_children
        = [ @$orig_terms, +{ id => [ keys %parent_content_data_ids ] } ];
    my %content_data_ids = map { $_ => 1 } (
        @{  $app->_get_normal_ids_for_actual_fields( $value,
                $terms_for_children )
        },
        @{  $app->_get_normal_ids_for_reference_fields( $value,
                $terms_for_children )
        },
    );
    [ keys %content_data_ids ];
}

sub _filter_terms {
    my $app = shift;
    +{ status => MT::ContentStatus::RELEASE() };
}

sub _get_rvalue {
    my $app = shift;

    my $val = $_[1];
    $val =~ s/\\([^\\])/$1/g;
    $val =~ s/%/\\%/;

    my %rvalues = (
        REQUIREDlike_sql   => \"LIKE '%$val%'",
        NORMALlike_sql     => \"LIKE '%$val%'",
        PROHIBITEDlike_sql => \"NOT LIKE '%$val%'",
    );

    $rvalues{ $_[0] } || $app->SUPER::_get_rvalue(@_);
}

sub _join_content_field {
    my ( $app, $term ) = @_;

    my $query = $term->{term};
    if ( 'PHRASE' eq $term->{query} ) {
        $query =~ s/'/"/g;
    }

    my ( $content_field_arg, $val ) = split ':', $query, 2;
    return unless defined $content_field_arg && $content_field_arg ne '';
    return unless defined $val && $val ne '';

    my $lucene_struct = eval { Lucene::QueryParser::parse_query($val) };
    if ($@) {
        warn $@ if $MT::DebugMode;
        return;
    }
    if ( 'PROHIBITED' eq $term->{type} ) {
        $_->{type} = 'PROHIBITED' foreach @$lucene_struct;
    }

    my $cf_iter = $app->model('content_field')->load_iter(
        [   { name => $content_field_arg },
            '-or',
            { unique_id => $content_field_arg },
        ]
    );

    my @terms_for_field_index;
    while ( my $content_field = $cf_iter->() ) {
        my $type_registry
            = $app->registry( 'content_field_types', $content_field->type )
            or next;
        my $data_type = $type_registry->{data_type} or next;
        next
            if $data_type eq 'datetime'
            || $data_type eq 'blob';
        my $search_column = "value_$data_type";
        my %columns       = (
            $search_column => ( $search_column eq 'integer' ) ? 1 : 'like', );
        my %filter_types = ();
        my ($terms)
            = $app->_query_parse_core( $lucene_struct, \%columns,
            \%filter_types );
        next unless $terms && @$terms;
        push @terms_for_field_index, '-or' if @terms_for_field_index;
        push @terms_for_field_index,
            [ @$terms, { content_field_id => $content_field->id } ];
    }

    my $cf_idx_iter
        = $app->model('content_field_index')
        ->load_iter( \@terms_for_field_index, { fetchonly => { id => 1 } } );
    my %content_field_index_ids;
    while ( my $content_field_index = $cf_idx_iter->() ) {
        $content_field_index_ids{ $content_field_index->id } = 1;
    }

    $app->model('content_field_index')->join_on(
        undef,
        {   content_data_id => \'= cd_id',
            id              => %content_field_index_ids
            ? [ keys %content_field_index_ids ]
            : 0,
        },
    );
}

sub _query_parse_core {
    my $app           = shift;
    my $lucene_struct = shift;
    $app->SUPER::_query_parse_core( Storable::dclone($lucene_struct), @_ );
}

1;

