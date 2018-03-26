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

    my ( $ids, $joins )
        = $app->_get_content_data_ids_searched_by_actual_fields( $orig_terms,
        $lucene_struct, $filter_types );
    my @content_data_ids = (
        @$ids,
        @{  $app->_get_content_data_ids_searched_by_reference_fields(
                $orig_terms, $lucene_struct, $filter_types )
        },
        @{  $app->_get_content_data_ids_searched_by_content_type_field(
                $orig_terms, $lucene_struct, $filter_types )
        },
    );

    +{  terms => [ { id => @content_data_ids ? \@content_data_ids : 0 } ],
        args  => { joins => $joins },
    };
}

sub search_terms {
    my $app = shift;

    if ( my $limit = $app->param('limit_by') ) {
        if ( $limit eq 'all' ) {

            # this is the default behavior
        }
        else {
            my $search = $app->param('search');
            my @words = split( / +/, $search );
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
        return return $app->errtrans('Invalid archive type')
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
        $sort_by =~ s/[^\w\-\.\,]+//g;
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

    my $can_search_by_id = $search_content_types =~ /^[0-9]+$/ ? 1 : 0;

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

# sub _get_content_data_ids_searched_by_label_column {
#     my $app = shift;
#     my ( $orig_terms, $lucene_struct, $filter_types ) = @_;
#     my %columns = ( label => 'like' );
#     my ( $terms, $joins )
#         = $app->_query_parse_core( $lucene_struct, \%columns, $filter_types );
#     $terms = [ $terms && @$terms ? @$terms : (), @$orig_terms ];
#     my $args = {
#         fetchonly => { id => 1 },
#         joins     => [
#             $joins && @$joins ? @$joins : (),
#             MT->model('content_type')->join_on(
#                 undef,
#                 {   id => \'= cd_content_type_id',
#                     data_label => [ \'IS NULL', '' ],
#                 },
#             ),
#         ],
#     };
#     my $iter = MT->model('content_data')->load_iter( $terms, $args );
#     my @content_data_ids;
#
#     while ( my $content_data = $iter->() ) {
#         push @content_data_ids, $content_data->id;
#     }
#     wantarray ? ( \@content_data_ids, $joins ) : \@content_data_ids;
# }

# sub _get_content_data_ids_searched_by_label_datetime_column {
#     my $app = shift;
#     my ( $orig_terms, $lucene_struct, $filter_types ) = @_;
#     my %columns = ( value_datetime => 'like_sql' );
#     my ( $terms, $joins )
#         = $app->_query_parse_core( $lucene_struct, \%columns, $filter_types );
#     my $args = {
#         fetchonly => { id => 1 },
#         joins     => [
#             $joins && @$joins ? @$joins : (),
#             MT->model('content_field_index')->join_on( undef, $terms ),
#             MT->model('content_field')->join_on(
#                 'content_type_id',
#                 { type => [ 'date_and_time', 'date_only', 'time_only' ], },
#                 {   join => MT->model('content_type')->join_on(
#                         undef, { data_label => \'= cf_unique_id' },
#                     )
#                 },
#             ),
#         ],
#     };
#     my $iter = MT->model('content_data')->load_iter( $orig_terms, $args );
#     my @content_data_ids;
#
#     while ( my $content_data = $iter->() ) {
#         push @content_data_ids, $content_data->id;
#     }
#     wantarray ? ( \@content_data_ids, $joins ) : \@content_data_ids;
# }

sub _get_content_data_ids_searched_by_actual_fields {
    my $app = shift;
    my ( $orig_terms, $lucene_struct, $filter_types ) = @_;
    my %columns = (
        value_varchar => 'like',
        value_text    => 'like',
        value_float   => 'like',
        value_double  => 'like',
    );
    my $searchable_field_types
        = $app->model('content_type')->searchable_field_types_for_search;
    my ( $terms, $joins )
        = $app->_query_parse_core( $lucene_struct, \%columns, $filter_types );
    my $args = {
        fetchonly => { id => 1 },
        joins     => [
            $joins && @$joins ? @$joins : (),
            MT->model('content_field_index')->join_on(
                undef,
                [   { content_data_id => \'= cd_id' },
                    $terms && @$terms ? @$terms : (),
                ],
                {   join => MT->model('content_field')->join_on(
                        undef,
                        {   id   => \'= cf_idx_content_field_id',
                            type => $searchable_field_types,
                        },
                    ),
                    unique => 1,
                },
            ),
        ],
    };
    my $iter = MT->model('content_data')->load_iter( $orig_terms, $args );
    my @content_data_ids;

    while ( my $content_data = $iter->() ) {
        push @content_data_ids, $content_data->id;
    }
    wantarray ? ( \@content_data_ids, $joins ) : \@content_data_ids;
}

sub _get_content_data_ids_searched_by_reference_fields {
    my $app = shift;
    my ( $orig_terms, $lucene_struct, $filter_types ) = @_;

    my %content_data_ids;
    my $registry = $app->registry('content_field_types');
    for my $type ( keys %$registry ) {
        my $type_registry = $registry->{$type};
        next
            unless $type_registry->{data_type} eq 'integer'
            && $type_registry->{search_class}
            && $type_registry->{search_columns};
        my %columns
            = map { $_ => 'like' } @{ $type_registry->{search_columns} };
        my ( $terms, $joins )
            = $app->_query_parse_core( $lucene_struct, \%columns,
            $filter_types );
        my $args = {
            fetchonly => { id => 1 },
            joins     => [
                $joins && @$joins ? @$joins : (),
                MT->model('content_field_index')->join_on(
                    undef,
                    { content_data_id => \'= cd_id' },
                    {   join =>
                            MT->model( $type_registry->{search_class} )
                            ->join_on(
                            undef,
                            [   { id => \'= cf_idx_value_integer' },
                                $terms && @$terms ? @$terms : (),
                            ],
                            ),
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

sub _get_content_data_ids_searched_by_content_type_field {
    my $app = shift;
    my ( $orig_terms, $lucene_struct, $filter_types ) = @_;

    my %columns = ();
    my ( $terms, $joins )
        = $app->_query_parse_core( $lucene_struct, \%columns, $filter_types );

    my $iter = $app->model('content_field_index')->load_iter(
        undef,
        {   joins => [
                $app->model('content_data')->join_on(
                    undef,
                    [ @$orig_terms, { id => \'= cf_idx_content_data_id', }, ],
                    { joins => [ $joins && @$joins ? @$joins : (), ], },
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

    my $terms_for_children
        = [ @$orig_terms, { id => [ keys %parent_content_data_ids ] } ];
    my %filter_types_for_children;
    my %content_data_ids = map { $_ => 1 } (
        @{  $app->_get_content_data_ids_searched_by_actual_fields(
                $terms_for_children, $lucene_struct,
                \%filter_types_for_children
            )
        },
        @{  $app->_get_content_data_ids_searched_by_reference_fields(
                $terms_for_children, $lucene_struct,
                \%filter_types_for_children
            )
        }
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

