# Movable Type (r) Open Source (C) 2001-2010 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package MT::App::Search;

use strict;
use base qw( MT::App );

use MT::Util qw( encode_html encode_url );

sub id {'new_search'}

sub init {
    my $app = shift;
    $app->SUPER::init(@_) or return;
    $app->set_no_cache;
    $app->{default_mode} = 'default';

    ## process pathinfo
    #if ( my $pi = $app->path_info ) {
    #    $pi =~ s!^/!!;
    #    my ($mode, $tag, @args) = split /\//, $pi;
    #    $app->mode($mode);
    #    $app->param($mode, $tag);
    #    for my $arg (@args) {
    #        my ($k, $v) = split /=/, $arg, 2;
    #        $app->param($k, $v);
    #    }
    #}
    my $pkg = ref($app);
    $app->_register_core_callbacks(
        {   "${pkg}::search_post_execute" => \&_log_search,
            "${pkg}::search_post_render"  => \&_cache_out,
            "${pkg}::prepare_throttle"    => \&_default_throttle,
            "${pkg}::take_down"           => \&_default_takedown,
        }
    );
    $app;
}

sub core_methods {
    my $app = shift;
    return {
        'default' => \&process,
        'tag'     => '$Core::MT::App::Search::TagSearch::process',
    };
}

sub core_parameters {
    my $app = shift;
    my $core = {
        params => [
            qw( searchTerms search count limit startIndex offset
                category author )
        ],
        types => {
            entry => {
                columns => {
                    title     => 'like',
                    keywords  => 'like',
                    text      => 'like',
                    text_more => 'like'
                },
                'sort' => 'authored_on',
                terms  => { 
                    status => 2,  #MT::Entry::RELEASE()
                    class => $app->param('archive_type') ? 'entry' : '*', 
                },
                filter_types => {
                    author   => \&_join_author,
                    category => \&_join_category,
                },
            },
        },
        cache_driver => { 'package' => 'MT::Cache::Negotiate', },
    };
    
    my @filters = ($app->param('filter'), $app->param('filter_on'));
    if (@filters) {
        $core->{types}->{entry}->{columns} = { map { $_ => 'like' } @filters };
    }

    $core;
}

sub init_request {
    my $app = shift;
    $app->SUPER::init_request(@_);

    $app->mode('tag') if $app->param('tag');

    my $q = $app->param;

    my $cfg     = $app->config;
    my $blog_id = defined $q->param('blog_id') ? $q->param('blog_id') : $app->first_blog_id();
    my $blog    = $app->model('blog')->load($blog_id)
        or return $app->errtrans('Can\'t load blog #[_1].', $blog_id);
    my $page    = $q->param('page') ? $q->param('page') : 1;
    my $limit
        = $q->param('limit') ? $q->param('limit')
        : ( $blog->entries_on_index ? $blog->entries_on_index
        : $cfg->SearchMaxResults );
    my $offset = ( $page - 1 ) * $limit if ( $page && $limit );
    $q->param( 'limit',  $limit )  if $limit;
    $q->param( 'offset', $offset ) if $offset;

    # These parameters are strictly numeric; invalid request if they
    # are given and are not
    foreach my $param (qw( blog_id limit offset SearchMaxResults )) {
        my $val = $q->param($param);
        next unless defined $val && ( $val ne '' );
        return $app->errtrans( 'Invalid [_1] parameter.', $param )
            if $val !~ m/^\d+$/;
    }
    foreach my $param (qw( IncludeBlogs ExcludeBlogs )) {
        my $val = $q->param($param);
        next unless defined $val && ( $val ne '' );
        return $app->errtrans( 'Invalid [_1] parameter.', $param )
            if ( $val !~ m/^(\d+,?)+$/ && $val ne 'all' );
    }

    # invalid request if they are given Zero as blog_id
    return $app->errtrans( 'Invalid [_1] parameter.', 'blog_id' )
        unless ( $blog_id > 0 );

    my $params = $app->registry( $app->mode, 'params' );
    foreach (@$params) {
        delete $app->{$_} if exists $app->{$_};
    }
    delete $app->{__have_throttle} if exists $app->{__have_throttle};

    my %no_override;
    foreach my $no ( split /\s*,\s*/, $app->config->SearchNoOverride ) {
        $no_override{$no} = 1;
        $no_override{"Search$no"} = 1
            if $no !~ /^Search.+/;
    }

    ## Set other search params--prefer per-query setting, default to
    ## config file.
    for my $key (qw( SearchResultDisplay SearchMaxResults SearchSortBy )) {
        $app->{searchparam}{$key}
            = $no_override{$key}
            ? $app->config->$key()
            : ( $q->param($key) || $app->config->$key() );
    }
    $app->{searchparam}{SearchMaxResults} =~ s/\D//g
        if defined( $app->{searchparam}{SearchMaxResults} );

    $app->{searchparam}{Type} = 'entry';
    if ( my $type = $q->param('type') ) {
        return $app->errtrans( 'Invalid type: [_1]', encode_html($type) )
            if $type !~ /[\w\.]+/;
        $app->{searchparam}{Type} = $type;
    }

    $app->generate_cache_keys();
    $app->init_cache_driver();

    my $processed = 0;
    my $list      = {};
    $q->param( 'IncludeBlogs', $blog_id )
        unless $q->param( 'IncludeBlogs');
    if ( $app->run_callbacks( 'search_blog_list', $app, $list, \$processed ) )
    {
        if ($processed) {
            $app->{searchparam}{IncludeBlogs} = keys %$list
                if ( $list && %$list );
        }
        else {
            my $blog_list = $app->create_blog_list(%no_override);
            $app->{searchparam}{IncludeBlogs} = $blog_list->{IncludeBlogs}
                if $blog_list
                    && %$blog_list
                    && $blog_list->{IncludeBlogs}
                    && @{ $blog_list->{IncludeBlogs} };
            return $app->error( $app->translate('Invalid request.') )
                if !$processed
                    && (   !exists $app->{searchparam}{IncludeBlogs}
                        || !@{ $app->{searchparam}{IncludeBlogs} } );
        }
    }
    else {
        return $app->error( $app->translate('Invalid request.') );
    }
}

sub generate_cache_keys {
    my $app = shift;

    my $q = $app->param;
    my @p = sort { $a cmp $b } $q->param;
    my ( $key, $count_key );
    foreach my $p ( @p ) {
        foreach my $pp ( $q->param($p) ) {
            $key .= lc($p) . encode_url( $pp  );
            $count_key .= lc($p) . encode_url( $pp )
                if ( 'limit' ne lc($p) ) && ( 'offset' ne lc($p) );
        }
    }

    $app->{cache_keys} = { result => $key, count => $count_key, content_type => "HTTP_CONTENT_TYPE::$key" };
}

sub init_cache_driver {
    my $app = shift;

    unless ( $app->config->SearchCacheTTL ) {
        require MT::Cache::Null;
        $app->{cache_driver} = MT::Cache::Null->new;
        return;
    }

    my $registry = $app->registry( $app->mode, 'cache_driver' );
    my $cache_driver = $registry->{'package'} || 'MT::Cache::Negotiate';
    eval "require $cache_driver;";
    if ( my $e = $@ ) {
        require MT::Log;
        $app->log(
            {   message => $app->translate(
                    "Search: failed storing results in cache.  [_1] is not available: [_2]",
                    $cache_driver,
                    $e
                ),
                level => MT::Log::WARNING(),
                class => 'search',
                category => 'cache',
            }
        );
        return;
    }
    $app->{cache_driver} = $cache_driver->new(
        ttl  => $app->config->SearchCacheTTL,
        kind => 'CS',
    );
}

sub create_blog_list {
    my $app = shift;
    my (%no_override) = @_;

    my $q   = $app->param;
    my $cfg = $app->config;

    unless (%no_override) {
        my %no_override;
        foreach my $no ( split /\s*,\s*/, $app->config->SearchNoOverride ) {
            $no_override{$no} = 1;
            $no_override{"Search$no"} = 1
                if $no !~ /^Search.+/;
        }
    }

    my %blog_list;

    ## If IncludeBlogs is all, then set IncludeBlogs to ""
    ## this will get all the blogs by default later on
    if ($q->param('IncludeBlogs') eq 'all') {
        $q->param('IncludeBlogs', '');
    }

    ## Combine user-selected included/excluded blogs
    ## with config file settings.
    for my $type (qw( IncludeBlogs ExcludeBlogs )) {
        $blog_list{$type} = ();
        if ( my $list = $cfg->$type() ) {
            push @{$blog_list{$type}}, (split /\s*,\s*/, $list);
        }
        next if exists( $no_override{$type} ) && $no_override{$type};
        for my $blog_id ( $q->param($type) ) {
            if ( $blog_id =~ m/,/ ) {
                my @ids = split /,/, $blog_id;
                s/\D+//g for @ids;    # only numeric values.
                foreach my $id (@ids) {
                    next unless $id;
                    push @{$blog_list{$type}}, $id;
                }
            }
            else {
                $blog_id =~ s/\D+//g;    # only numeric values.
                push @{$blog_list{$type}}, $blog_id if $blog_id;
            }
        }
    }

    ## If IncludeBlogs has not been set, we need to build a list of
    ## the blogs to search. If ExcludeBlogs was set, exclude any blogs
    ## set in that list from our final list.
    unless ( $blog_list{IncludeBlogs} ) {
        my $exclude = $blog_list{ExcludeBlogs};
        my $iter    = $app->model('blog')->load_iter({ class => '*' });
        while ( my $blog = $iter->() ) {
            push @{$blog_list{IncludeBlogs}}, $blog->id
                unless $exclude && grep { $_ == $blog->id } @$exclude;
        }
    }

    \%blog_list;
}

sub check_cache {
    my $app = shift;

    my $cache
        = $app->{cache_driver}->get_multi( values %{ $app->{cache_keys} } );

    my $count = $cache->{ $app->{cache_keys}{count} }
        if exists $cache->{ $app->{cache_keys}{count} };
    my $result = $cache->{ $app->{cache_keys}{result} }
        if exists $cache->{ $app->{cache_keys}{result} };
    if ( exists $cache->{ $app->{cache_keys}{content_type} } ) {
        my $content_type = $cache->{ $app->{cache_keys}{content_type} };
        $app->{response_content_type} = $content_type;
    }
    if ( !Encode::is_utf8($result) ) {
        my $enc = MT->config->PublishCharset;
        $result = Encode::decode( $enc, $result );
    }
    ( $count, $result );
}

sub process {
    my $app = shift;

    my @messages;
    return $app->throttle_response( \@messages )
        unless $app->throttle_control( \@messages );

    my ( $count, $out ) = $app->check_cache();
    if ( defined $out ) {
        $app->run_callbacks( 'search_cache_hit', $count, $out );
        return $out;
    }
    my $iter;
    if ( $app->param('searchTerms') || $app->param('search') || $app->param('category') || $app->param('archive_type')
         || $app->param('author') || $app->param('year') || $app->param('month') || $app->param('day') ) {
        my @arguments = $app->search_terms();
        return $app->error( $app->errstr ) if $app->errstr;

        $count = 0;
        if (@arguments) {
            ( $count, $iter ) = $app->execute(@arguments);
            return $app->error( $app->errstr ) unless $iter;

            $app->run_callbacks( 'search_post_execute', $app, \$count, \$iter );
        }
    }

    my $format = q();
    if ( $format = $app->param('format') ) {
        return $app->errtrans( 'Invalid format: [_1]', encode_html($format) )
            if $format !~ /\w+/;
    }
    my $method = "render";
    if ( my $tmpl_name = $app->param('Template') ) {
        $method .= $tmpl_name if $app->can( $method . $tmpl_name );
    }
    elsif ( $format ) {
        $method .= $format if $app->can( $method . $format );
    }

    $out = $app->$method( $count, $iter );
    return $app->error( $app->errstr ) unless defined $out;

    my $result;
    if ( ref($out) && ( $out->isa('MT::Template') ) ) {
        defined( $result = $out->build() )
            or return $app->error( $out->errstr );
    }
    else {
        $result = $out;
    }

    $app->run_callbacks( 'search_post_render', $app, $count, $result );
    $result;
}

sub count {
    my $app = shift;
    my ( $class, $terms, $args ) = @_;
    my $count = $app->{cache_driver}->get( $app->{cache_keys}{count} );
    return $count if defined $count;

    $count = $class->count( $terms, $args );
    return $app->error( $class->errstr ) unless defined $count;

    my $cache_driver = $app->{cache_driver};
    $cache_driver->set( $app->{cache_keys}{count},
        $count, $app->config->SearchCacheTTL );

    $count;
}

sub execute {
    my $app = shift;
    my ( $terms, $args ) = @_;

    my $class = $app->model( $app->{searchparam}{Type} )
        or return $app->errtrans( 'Unsupported type: [_1]',
        encode_html( $app->{searchparam}{Type} ) );

    my $count = $app->count( $class, $terms, $args );
    return $app->errtrans( "Invalid query: [_1]", $app->errstr )
        unless defined $count;

    my $iter = $class->load_iter( $terms, $args )
        or $app->error( $class->errstr );
    ( $count, $iter );
}

sub search_terms {
    my $app = shift;
    my $q   = $app->param;

    if (my $limit = $app->param('limit_by')) {
        if ($limit eq 'all') {
            # this is the default behavior
        } 
        else {
            my $search = $app->param('search');
            my @words = split(/ +/, $search);
            if ($limit eq 'any') {
                $search = join(' OR ', @words);
            } 
            elsif ($limit eq 'exclude') {
                $search = 'NOT ' . join(' NOT ', @words);
            }
            $app->param('search', $search);
        }
    }

    # check if archive type is legal
    if ($app->param('archive_type')) {
        my $at = $app->param('archive_type');
        my $archiver = MT->publisher->archiver($at);
        return return $app->errtrans( 'Invalid archive type' )
            unless ($archiver || $at eq 'Index');
    }

    my $search_string = $q->param('searchTerms') || $q->param('search');
    $app->{search_string} = $search_string;
    my $offset = $q->param('startIndex') || $q->param('offset') || 0;
    return $app->errtrans( 'Invalid value: [_1]', encode_html($offset) )
        if $offset && $offset !~ /^\d+$/;
    my $limit = $q->param('count') || $q->param('limit');
    return $app->errtrans( 'Invalid value: [_1]', encode_html($limit) )
        if $limit && $limit !~ /^\d+$/;
    my $max = $app->{searchparam}{SearchMaxResults};
    $max =~ s/\D//g if defined $max;
    $limit = $max if !$limit || ( $limit - $offset > $max );

    my $params
        = $app->registry( $app->mode, 'types', $app->{searchparam}{Type} );
    my %def_terms
        = exists( $params->{terms} )
        ? %{ $params->{terms} }
        : ();
    delete $def_terms{'plugin'};

    if ( my $incl_blogs = $app->{searchparam}{IncludeBlogs} ) {
        $def_terms{blog_id} = $incl_blogs if $incl_blogs;
    }

    my @terms;
    if (%def_terms) {
        my $type        = $app->{searchparam}{Type};
        my $model_class = MT->model($type);

        delete $def_terms{blog_id}
            unless $model_class->can('blog_id');

        # If we have a term for the model's class column, add it separately, so
        # array search() doesn't add the default class column term.
        if ( my $class_col = $model_class->properties->{class_column} ) {
            if ( $def_terms{$class_col} ) {
                push @terms, { $class_col => delete $def_terms{$class_col} };
            }
        }

        push @terms, \%def_terms;
    }

    my $columns = $params->{columns};
    delete $columns->{'plugin'};
    return $app->errtrans( 'No column was specified to search for [_1].',
        $app->{searchparam}{Type} )
        unless $columns && %$columns;

    my $parsed = $app->query_parse(%$columns);
    return $app->errtrans( 'Invalid query: [_1]',
        encode_html($search_string) )
        if ((!$parsed || !(%$parsed)) && !$app->param('archive_type'));

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

    my $terms = \@terms;
    my ($date_start, $date_end);
    if ($app->param('archive_type') && $app->param('year')) {
        my $year = $app->param('year');
        my $month = $app->param('month') ? $app->param('month') : '01';
        my $day = $app->param('day') ? $app->param('day') : '01';
        my $archive_type = $app->param('archive_type');
        require MT::Util;
        if ($archive_type =~ /Daily/i) {
            ($date_start, $date_end) = MT::Util::start_end_day($year . $month . $day);
        } elsif ($archive_type =~ /Weekly/i) {
            ($date_start, $date_end) = MT::Util::start_end_week($year . $month . $day);
        } elsif ($archive_type =~ /Monthly/i) {
            ($date_start, $date_end) = MT::Util::start_end_month($year . $month . $day);
        } elsif ($archive_type =~ /Yearly/i) {
            ($date_start, $date_end) = MT::Util::start_end_year($year . $month . $day);
        }
        $app->param('context_date_start', $date_start);
        $terms->[1]->{authored_on} = { between => [ $date_start, $date_end ] };
    }

    ( \@terms, \%args );
}

sub _cache_out {
    my ( $cb, $app, $count, $out ) = @_;

    my $result;
    if ( ref($out) && ( $out->isa('MT::Template') ) ) {
        defined( $result = $out->build() )
            or die $out->errstr;
    }
    else {
        $result = $out;
    }
    if ( Encode::is_utf8($result) ) {
        my $enc = MT->config->PublishCharset;
        $result = Encode::encode( $enc, $result );
    }
    my $cache_driver = $app->{cache_driver};
    $cache_driver->set( $app->{cache_keys}{result},
        $result, $app->config->SearchCacheTTL );
    if ( exists( $app->{response_content_type} )
      && ( 'text/html' ne $app->{response_content_type} ) )
    {
        $cache_driver->set( $app->{cache_keys}{content_type},
            $app->{response_content_type}, $app->config->SearchCacheTTL );
    }
}

sub _log_search {
    my ( $cb, $app, $count_ref, $iter_ref ) = @_;

    #FIXME: template name may not be 'feed' for search feed
    unless ( $app->param('Template')
        && ( 'feed' eq $app->param('Template') ) )
    {
        my $blog_id = $app->first_blog_id();
        require MT::Log;
        $app->log(
            {   message => $app->translate(
                    "Search: query for '[_1]'",
                    $app->{search_string}
                ),
                level    => MT::Log::INFO(),
                class    => 'search',
                category => 'straight_search',
                $blog_id ? ( blog_id => $blog_id ) : ()
            }
        );
    }
}

sub template_paths {
    my $app   = shift;
    my @paths = $app->SUPER::template_paths;
    ( $app->config->SearchTemplatePath, @paths );
}

sub first_blog_id {
    my $app = shift;
    my $q   = $app->param;

    my $blog_id;
    if ( $q->param('IncludeBlogs') ) {
        # if IncludeBlogs is empty or all, get the first blog id available
        if ( $q->param('IncludeBlogs') eq '' || $q->param('IncludeBlogs') eq 'all') {
            my @blogs = $app->model('blog')->load();
            $blog_id = $blogs[0];
        }
        # all other normal requests with a list of blog ids
        else {
            my @ids = split ',', $q->param('IncludeBlogs');
            $blog_id = $ids[0];
        }
    }
    elsif ( exists( $app->{searchparam}{IncludeBlogs} )
        && @{ $app->{searchparam}{IncludeBlogs} } )
    {
        my @blog_ids = $app->{searchparam}{IncludeBlogs};
        $blog_id = $blog_ids[0] if @blog_ids;
    }
    $blog_id;
}

sub prepare_context {
    my $app = shift;
    my $q   = $app->param;
    my ( $count, $iter ) = @_;

    ## Initialize and set up the context object.
    require MT::Template::Context::Search;
    my $ctx = MT::Template::Context::Search->new;
    if ( my $str = $app->{search_string} ) {
        $ctx->stash( 'search_string', encode_html($str) );
    }
    if ( $q->param('type') ) {
        $ctx->stash( 'type', $app->{searchparam}{Type} );
    }
    if ( $app->{default_mode} ne $app->mode ) {
        $ctx->stash( 'mode', $app->mode );
    }
    if ( my $template = $q->param('Template') ) {
        $template =~ s/[^\w\-\.]//g;
        $ctx->stash( 'template_id', $template );
    }
    $ctx->stash( 'stash_key',  $app->{searchparam}{Type} );
    $ctx->stash( 'maxresults', $app->{searchparam}{SearchMaxResults} );
    $ctx->stash( 'include_blogs', join ',',
        @{ $app->{searchparam}{IncludeBlogs} } );
    $ctx->stash( 'results', $iter );
    $ctx->stash( 'count',   $count );
    $ctx->stash( 'offset',
        $q->param('startIndex') || $q->param('offset') || 0 );
    $ctx->stash( 'limit', $q->param('count') || $q->param('limit') );
    $ctx->stash( 'format', $q->param('format') ) if $q->param('format');

    my $blog_id = defined $q->param('blog_id') ? $q->param('blog_id') : $app->first_blog_id();
    if ($blog_id) {
        my $blog = $app->model('blog')->load($blog_id);
        $app->blog($blog);
        $ctx->stash( 'blog_id', $blog_id );
        $ctx->stash( 'blog',    $blog );
    }
    
    # some basic search parameters
    for my $key (qw( limit_by author category page year month day archive_type template_id )) {
        if (my $val = $app->param($key)) {
            $ctx->stash('search_' . $key, $val);
        }
        my @filters = ($app->param('filter'), $app->param('filter_on'));
        if (@filters) {
            $ctx->stash('search_filters', \@filters);
        }
    }

    # now we need to figure out the archive types
    if ( my $at = $q->param('archive_type') ) {
        $ctx->stash('archive_count', $count);
        $ctx->{current_archive_type} = $at;
        my $archiver = MT->publisher->archiver($at);
        if ( $archiver ) {
            my $params = $archiver->template_params;
            map { $ctx->var( $_, $params->{ $_ } ) } keys %$params;
        }
    }
    $ctx->{current_timestamp} = $app->param('context_date_start') ? $app->param('context_date_start') : MT::Util::epoch2ts( $blog_id, time);
    if ($app->param('author')) {
        require MT::Author;
        my $author = MT::Author->load($app->param('author'));
        $ctx->stash('author', $author);
        $ctx->var('author_archive', 1);
    }
    if ($app->param('category')) {
        require MT::Category;
        my $category = MT::Category->load($app->param('category'));
        $ctx->stash('category', $category);
        $ctx->var('category_archive', 1);
    }

    $ctx;
}

sub load_search_tmpl {
    my $app   = shift;
    my $q     = $app->param;
    my ($ctx) = @_;

    my $tmpl;
    if ( $q->param('Template') && ( 'default' ne $q->param('Template') ) ) {

        # load specified template
        my $filename;
        if (my @tmpls = (
                $app->config->default('SearchAltTemplate'),
                $app->config->SearchAltTemplate
            )
            )
        {
            for my $tmpl_ (@tmpls) {
                next unless defined $tmpl_;
                my ( $nickname, $file ) = split /\s+/, $tmpl_;
                if ( $nickname eq $q->param('Template') ) {
                    $filename = $file;
                    last;
                }
            }
        }
        return $app->errtrans(
            "No alternate template is specified for the Template '[_1]'",
            encode_html( $q->param('Template') ) )
            unless $filename;

        # template_paths method does the magic
        $tmpl = $app->load_tmpl($filename)
            or
            return $app->errtrans( "Opening local file '[_1]' failed: [_2]",
            $filename, "$!" );
        $tmpl->text( $app->translate_templatized( $tmpl->text ) );
    }
    else {
        my $tmpl_id = $q->param ('template_id');
        if ($tmpl_id && $tmpl_id =~ /^\d+$/) {
            $tmpl = $app->model('template')->lookup ($tmpl_id);
            return $app->errtrans( 'No such template' )
                unless ($tmpl);
            return $app->errtrans( 'template_id cannot be a global template' )
                if ($tmpl->blog_id == 0);
            return $app->errtrans( 'Output file cannot be asp or php' )
                if ($tmpl->outfile && !$app->config->SearchAlwaysAllowTemplateID 
                    && ($tmpl->outfile =~ /\.asp/i || $tmpl->outfile =~ /\.php/i));

            if ($q->param('archive_type')) {
                my $at = $q->param('archive_type');
                my $archiver = MT->publisher->archiver($at);
                return return $app->errtrans( 'You must pass a valid archive_type with the template_id' )
                    unless ($archiver || $at eq 'Index');

                if ($at ne 'Index') {
                    return $app->errtrans( 'Template must have identifier entry_listing for non-Index archive types' )
                        unless ($app->config->SearchAlwaysAllowTemplateID || $tmpl->identifier =~ /entry_listing$/ );
                    my $blog = $app->model('blog')->load($tmpl->blog_id);
                    return $app->errtrans( 'Blog file extension cannot be asp or php for these archives' )
                        if (!$app->config->SearchAlwaysAllowTemplateID
                            && ($blog->file_extension =~ /^php$/i || $blog->file_extension =~ /^asp$/i));
                } else {
                    return $app->errtrans( 'Template must have identifier main_index for Index archive type' )
                        unless ($app->config->SearchAlwaysAllowTemplateID || $tmpl->identifier eq 'main_index');
                }
            }
            else {
                return $app->errtrans( 'You must pass a valid archive_type with the template_id' );
            }
        }

        # load default template
        # first look for appropriate blog_id
        elsif ( my $blog_id = $ctx->stash('blog_id') ) {
            my $tmpl_class = $app->model('template');
            $tmpl = $tmpl_class->load({ blog_id => $blog_id, type => 'search_results' });
        }
        unless ($tmpl) {
            # load template from search_template path
            # template_paths method does the magic
            $tmpl = $app->load_tmpl( $app->config->SearchDefaultTemplate );
            $tmpl->text( $app->translate_templatized( $tmpl->text ) );
        }
    }
    return $app->error( $app->errstr )
        unless $tmpl;

    $ctx->var( 'system_template', '1' );
    $ctx->var( 'search_results',  '1' );

    $tmpl->context($ctx);
    $tmpl;
}

sub render {
    my $app = shift;
    my ( $count, $iter ) = @_;

    my @arguments = $app->prepare_context( $count, $iter )
        or return $app->error( $app->errstr );
    my $tmpl = $app->load_search_tmpl(@arguments)
        or return $app->error( $app->errstr );
    return $tmpl;
}

sub renderjs {
    my $app = shift;
    my ( $count, $iter ) = @_;

    my ($ctx) = $app->prepare_context( $count, $iter )
        or return $app->json_error( $app->errstr );
    my $search_tmpl = $app->load_search_tmpl($ctx)
        or return $app->json_error( $app->errstr );
    my $result_node = $search_tmpl->getElementById('search_results')
        or return $app->json_error(
        'Search template does not have markup for search results.');
    my $t = $result_node->innerHTML();

    require MT::Template;
    my $tmpl = MT::Template->new( type => 'scalarref', source => \$t );
    $ctx->stash( 'format', q() );    # don't propagate "js" format
    $tmpl->context($ctx);
    my $content = $tmpl->output
        or return $app->json_error( $tmpl->errstr );

    my $next_link = $ctx->invoke_handler('nextlink');
    return $app->json_result(
        { content => $content, next_url => $next_link } );
}

#FIXME: template name may not be 'feed' for search feed
sub renderfeed {
    my $app = shift;
    my $tmpl = $app->render(@_);
    my $out = $app->build_page($tmpl);
    my $ctx = $tmpl->context;
    if ( my $content_type = $ctx->stash('content_type') ) {
        $app->{response_content_type} = $content_type;
    }
    return $out;
}

sub query_parse {
    my $app = shift;
    my (%columns) = @_;

    my $search = $app->{search_string};

    my $reg
        = $app->registry( $app->mode, 'types', $app->{searchparam}{Type} );
    my $filter_types = $reg->{'filter_types'};
    foreach my $type ( keys %$filter_types ) {
        if ( my $filter = $app->param($type) ) {
             if ( $filter =~ m/\s/ ) {
                 $filter = '"' . $filter . '"';
            }
            $search .= " $type:$filter";
        }
    }

    require Lucene::QueryParser;
    my $lucene_struct = eval { Lucene::QueryParser::parse_query($search); };
    return if $@;
    my ( $terms, $joins )
        = $app->_query_parse_core( $lucene_struct, \%columns, $filter_types );
    my $return = { $terms && @$terms ? ( terms => $terms ) : () };
    if ( $joins && @$joins ) {
        my $args = {};
        _create_join_arg( $args, $joins );
        if ( $args && %$args ) {
            $return->{args} = $args;
        }
    }
    $return;
}

sub _create_join_arg {
    my ( $args, $joins ) = @_;
    my $join = shift @$joins;
    return unless $join && @$join;
    my $next = $join->[3];
    if ( defined $next ) {
        if ( exists $next->{'join'} ) {
            $next = $next->{'join'}->[3];
        }
    }
    else {
        $next = {};
        $join->[3] = $next;
    }
    _create_join_arg( $next, $joins );
    $args->{'join'} = $join;
}

sub _query_parse_core {
    my $app = shift;
    my ( $lucene_struct, $columns, $filter_types ) = @_;

    my $rvalue = sub {
        my $val = $_[1];
        $val =~ s/\\([^\\])/$1/g;
        my %rvalues = (
            REQUIREDlike   => { like     => '%' . $val . '%' },
            REQUIRED1      => $val,
            NORMALlike     => { like     => '%' . $val . '%' },
            NORMAL1        => $val,
            PROHIBITEDlike => { not_like => '%' . $val . '%' },
            PROHIBITED1    => { not      => $val }
        );
        $rvalues{ $_[0] };
    };

    my ( @structure, @joins );
    while ( my $term = shift @$lucene_struct ) {
        if ( exists $term->{field} ) {
            unless ( exists $columns->{ $term->{field} } ) {
                if (   $filter_types
                    && %$filter_types
                    && !exists( $filter_types->{ $term->{field} } ) )
                {

                    # Colon in query but was not to specify a field.
                    # Treat it as a phrase including the colon.
                    my $field = delete $term->{field};
                    $term->{term} = $field . ':' . $term->{term};
                    unshift @$lucene_struct, $term;
                }
            }
        }

        my @tmp;
        if ( ( 'TERM' eq $term->{query} ) || ( 'PHRASE' eq $term->{query} ) )
        {
            my $test;
            if ( exists( $term->{field} ) ) {
                if (   $filter_types
                    && %$filter_types
                    && exists( $filter_types->{ $term->{field} } ) )
                {
                    my $code = $app->handler_to_coderef(
                        $filter_types->{ $term->{field} } );
                    if ($code) {
                        my $join_args = $code->( $app, $term );
                        push @joins, $join_args;
                        next;
                    }
                }
                elsif ( exists $columns->{ $term->{field} } ) {
                    my $test_ = $rvalue->(
                        ( $term->{type} || '' )
                        . $columns->{ $term->{field} },
                        $term->{term}
                    );
                    push @tmp, { $term->{field} => $test_ };
                }
            }
            else {
                my @cols   = keys %$columns;
                my $number = scalar @cols;
                for ( my $i = 0; $i < $number; $i++ ) {
                    my $test_ = $rvalue->(
                        ( $term->{type} || '' ) . $columns->{ $cols[$i] },
                        $term->{term}
                    );
                    if ( 'PROHIBITED' eq $term->{type} ) {
                        my @this_term;
                        push @this_term, { $cols[$i] => $test_ };
                        push @this_term, '-or';
                        push @this_term, { $cols[$i] => \' IS NULL' };
                        push @tmp, \@this_term;
                        unless ( $i == $number - 1 ) {
                            push @tmp, '-and';
                        }
                    }
                    else {
                        push @tmp, { $cols[$i] => $test_ };
                        unless ( $i == $number - 1 ) {
                            push @tmp, '-or';
                        }
                    }
                }
            }
        }
        elsif ( 'SUBQUERY' eq $term->{query} ) {
            my ( $test_, $more_joins )
                = $app->_query_parse_core( $term->{subquery}, $columns,
                $filter_types );
            next unless $test_ && @$test_;
            if (@structure) {
                push @structure, 'PROHIBITED' eq $term->{type}
                    ? '-and_not'
                    : '-and';
            }
            push @structure, @$test_;
            push @joins,     @$more_joins;
            next;
        }

        if ( exists( $term->{conj} ) && ( 'OR' eq $term->{conj} ) ) {
            if ( my $prev = pop @structure ) {
                push @structure, [ $prev, -or => \@tmp ];
            }
        }
        else {
            if (@structure) {
                push @structure, '-and';
            }
            push @structure, \@tmp;
        }
    }
    ( \@structure, \@joins );
}

# add category filter to entry search
sub _join_category {
    my ( $app, $term ) = @_;
    my $query = $term->{term};
    if ( 'PHRASE' eq $term->{query} ) {
        $query =~ s/'/"/g;
    }
    my $lucene_struct = Lucene::QueryParser::parse_query($query);
    if ( 'PROHIBITED' eq $term->{type} ) {
        $_->{type} = 'PROHIBITED' foreach @$lucene_struct;
    }

    # search for exact match
    my ($terms)
        = $app->_query_parse_core( $lucene_struct, { id => 1, label => 1 }, {} );
    return unless $terms && @$terms;
    push @$terms, '-and',
        {
        id      => \'= placement_category_id',
        blog_id => \'= entry_blog_id',
        };

    require MT::Placement;
    require MT::Category;
    return MT::Placement->join_on(
        undef,
        { entry_id => \'= entry_id', blog_id => \'= entry_blog_id' },
        {   join   => MT::Category->join_on( undef, $terms, {} ),
            unique => 1
        }
    );
}

# add author filter to entry search
sub _join_author {
    my ( $app, $term ) = @_;

    my $query = $term->{term};
    if ( 'PHRASE' eq $term->{query} ) {
        $query =~ s/'/"/g;
    }

    my $lucene_struct = Lucene::QueryParser::parse_query($query);
    if ( 'PROHIBITED' eq $term->{type} ) {
        $_->{type} = 'PROHIBITED' foreach @$lucene_struct;
    }
    my ($terms)
        = $app->_query_parse_core( $lucene_struct, { id => 1, nickname => 'like' },
        {} );
    return unless $terms && @$terms;
    push @$terms, '-and', { id => \'= entry_author_id', };
    require MT::Author;
    return MT::Author->join_on( undef, $terms, { unique => 1 } );
}

# throttling related methods
sub throttle_control {
    my $app = shift;
    my ($messages) = @_;
    my $result;
    $app->run_callbacks( 'prepare_throttle', $app, \$result, $messages );
    $result;
}

sub throttle_response {
    my $app        = shift;
    my ($messages) = @_;
    my $tmpl       = $app->param('Template') || '';
    if ( $tmpl eq 'feed' ) {
        $app->response_code(503);
        $app->set_header(
            'Retry-After' => $app->config->SearchThrottleSeconds );
        $app->send_http_header("text/plain");
        $app->{no_print_body} = 1;
    }
    my $msg
        = $messages && @$messages
        ? join '; ', @$messages
        : $app->translate(
        'The search you conducted has timed out.  Please simplify your query and try again.'
        );
    return $app->error($msg);
}

sub _default_throttle {
    my ( $cb, $app, $result, $messages ) = @_;

    # Don't bother if a callback proiritized higher
    # set up its throttle already
    return $$result if defined $$result;

    ## Get login information if user is logged in (via cookie).
    ## If no login cookie, this fails silently, and that's fine.
    ( $app->{user} ) = $app->login;

    ## Don't throttle MT registered users
    if ( $app->{user} && $app->{user}->type == MT::Author::AUTHOR() ) {
        $$result = 1;
        return 1;
    }

    my $ip        = $app->remote_ip;
    my $whitelist = $app->config->SearchThrottleIPWhitelist;
    if ($whitelist) {

        # check for $ip in $whitelist
        my @list = split /(\s*[,;]\s*|\s+)/, $whitelist;
        foreach (@list) {
            next unless $_ =~ m/^\d{1,3}(\.\d{0,3}){0,3}$/;
            if ( ( $ip eq $_ ) || ( $ip =~ m/^\Q$_\E/ ) ) {
                $$result = 1;
                return 1;
            }
        }
    }

    if ( $^O eq 'MSWin32' ) {
        $$result = 1;         #FIXME
    }
    else {
        # Use SIGALRM to stop processing in 5 seconds for each request
        $SIG{ALRM} = sub {
            my $msg
                = $app->translate(
                'The search you conducted has timed out.  Please simplify your query and try again.'
                );
            $app->error($msg);
            die $msg;
        };
        $app->{__have_throttle} = 1;
        alarm( $app->config->SearchThrottleSeconds );
        $$result = 1;
    }
    1;
}

sub _default_takedown {
    my ( $cb, $app ) = @_;
    alarm(0) if $app->{__have_throttle};
    if ( my $cache_driver = $app->{cache_driver} ) {
        $cache_driver->purge_stale( 2 * $app->config->SearchCacheTTL );
    }
    delete $app->{searchparam};
    1;
}

1;
__END__

=head1 NAME

MT::App::Search

=head1 Callbacks

Callbacks called by the package are as follows:

=over 4

=item search_post_execute

    callback($cb, $app, \$count, \$iter)

Called immediately after the search from the database (or however
search executed depending on the algorithm).

=item search_post_render

    callback($cb, $app, $count, $out_html)

Called immediately after the search template was loaded and its
context populated.

=item search_cache_hit

    callback($cb, $app, $count, $out_html)

Called immediately after cached results was retrieved.

=item search_blog_list

    callback($cb, $app, \%list, \$processed)

Called during init_request in which a plugin can fill %list.
The list must has the following data structure.

    %list = ( 1 => 1, 2 => 1, 3 => 1 );

where the hash keys (1, 2, and 3) are the IDs of the blogs to search for.

Plugins must also set $processed = 1 in order to specify the app that
the app must not overwrite the blog list created by the plugin.

=item prepare_throttle

    callback($cb, $app, \$result, \@messages);

Called right before the beginning of the search processing.
Each callback should see if certain condition is met, and
set 0 to $$result if the request should be throttled.

There can be more than one throttling method set up.
Callbacks are called in order of priority set up when add_callback
was called.  Each callback should start its own code by something like
below, to prevent itself overwriting throttle set up in the callback
whose priority is higher than itself.

    return $$result if defined $$result;

=back

=head1 AUTHOR & COPYRIGHT

Please see L<MT/AUTHOR & COPYRIGHT>.

=cut
