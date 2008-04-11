# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package MT::App::Search;

use strict;
use base qw( MT::App );

use MT::Util qw( encode_html encode_url );

sub id { 'new_search' }

sub init {
    my $app = shift;
    $app->SUPER::init(@_) or return;
    $app->set_no_cache;
    $app->{default_mode} = 'default';

    $app->mode('tag') if $app->param('tag');
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
    $app->_register_core_callbacks({
        'search_post_execute' => \&log_search,
        'search_post_render'  => \&cache_out,
    });
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
    return {
        params => [ qw( searchTerms search count limit startIndex offset
            category author )],
        types  => {
            #author => {
            #    columns => [ qw( name nickname email url ) ],
            #    'sort' => 'created_on',
            #    terms   => { status => 1 }, #MT::Author::ACTIVE()
            #},
            entry => {
                columns => {
                    title     => 'like',
                    keywords  => 'like',
                    text      => 'like',
                    text_more => 'like'
                },
                'sort'  => 'authored_on',
                terms   => { status => 2, class => '*' }, #MT::Entry::RELEASE()
                filter_types => {
                    author   => \&_join_author,
                    category => \&_join_category,
                },
            },
        },
        cache_driver => {
            'package' => 'MT::Cache::Negotiate',
        },
    };
}

sub init_request{
    my $app = shift;
    $app->SUPER::init_request(@_);
    my $q = $app->param;

    my $params = $app->registry( $app->mode, 'params' );
    foreach ( @$params ) {
        delete $app->{$_} if exists $app->{$_}
    }

    my %no_override;
    foreach my $no ( split /\s*,\s*/, $app->config->SearchNoOverride ) {
        $no_override{ $no } = 1;
        $no_override{ "Search$no" } = 1
            if $no !~ /^Search.+/;
    }

    ## Set other search params--prefer per-query setting, default to
    ## config file.
    for my $key (qw( SearchResultDisplay SearchMaxResults SearchSortBy )) {
        $app->{searchparam}{$key} = $no_override{$key} ?
            $app->config->$key() : ($q->param($key) || $app->config->$key());
    }

    $app->{searchparam}{Type} = 'entry';
    if ( my $type = $q->param('type') ) {
        return $app->errtrans('Invalid type: [_1]', encode_html($type) )
            if $type !~ /[\w\.]+/;
        $app->{searchparam}{Type} = $type;
    }

    $app->generate_cache_keys();
    $app->init_cache_driver();

    my $processed = 0;
    my $list      = {};
    if ( MT->run_callbacks( 'search_blog_list', $app, $list, \$processed ) ) {
        if ( $processed ) {
            $app->{searchparam}{IncludeBlogs} = $list;
        }
        else {
            my $blog_list = $app->create_blog_list( %no_override );
            $app->{searchparam}{IncludeBlogs} = $blog_list->{IncludeBlogs}
                if $blog_list && %$blog_list
                && $blog_list->{IncludeBlogs}
                && %{ $blog_list->{IncludeBlogs} };
            if ( !exists($app->{searchparam}{IncludeBlogs})
              && ( my $blog_id = $q->param('blog_id') ) ) {
                $blog_id =~ s/\D//g;
                $app->{searchparam}{IncludeBlogs}{$blog_id} = 1
                    if $blog_id;
            }
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
    $key .= lc($_) . encode_url($q->param($_))
        foreach @p;
    $count_key .= lc($_) . encode_url($q->param($_))
        foreach grep { ('limit' ne lc($_)) && ('offset' ne lc($_)) } @p;
    $app->{cache_keys} = { result => $key, count => $count_key };
}

sub init_cache_driver {
    my $app = shift;

    my $registry = $app->registry( $app->mode, 'cache_driver' );
    my $cache_driver = $registry->{'package'} || 'MT::Cache::Negotiate';
    eval "require $cache_driver;";
    if ( my $e = $@ ) {
        require MT::Log;
        $app->log({
            message =>
                $app->translate("Search: failed storing results in cache.  [_1] is not available: [_2]",
                    $cache_driver, $e ),
            level => MT::Log::INFO(),
            class => 'search',
        });
        return;
    }
    $app->{cache_driver} = $cache_driver->new( ttl => $app->config->ThrottleSeconds );
}

sub create_blog_list {
    my $app = shift;
    my ( %no_override ) = @_;

    my $q = $app->param;
    my $cfg = $app->config;

    unless ( %no_override ) {
        my %no_override;
        foreach my $no ( split /\s*,\s*/, $app->config->SearchNoOverride ) {
            $no_override{ $no } = 1;
            $no_override{ "Search$no" } = 1
                if $no !~ /^Search.+/;
        }
    }

    my %blog_list;
    ## Combine user-selected included/excluded blogs
    ## with config file settings.
    for my $type (qw( IncludeBlogs ExcludeBlogs )) {
        $blog_list{$type} = {};
        if (my $list = $cfg->$type()) {
            $blog_list{$type} =
                { map { $_ => 1 } split /\s*,\s*/, $list };
        }
        next if exists($no_override{$type}) && $no_override{$type};
        for my $blog_id ($q->param($type)) {
            if ($blog_id =~ m/,/) {
                my @ids = split /,/, $blog_id;
                s/\D+//g for @ids; # only numeric values.
                foreach my $id (@ids) {
                    next unless $id;
                    $blog_list{$type}{$id} = 1;
                }
            } else {
                $blog_id =~ s/\D+//g; # only numeric values.
                $blog_list{$type}{$blog_id} = 1;
            }
        }
    }

    ## If IncludeBlogs has not been set, we need to build a list of
    ## the blogs to search. If ExcludeBlogs was set, exclude any blogs
    ## set in that list from our final list.
    unless ( exists $blog_list{IncludeBlogs} ) {
        my $exclude = $blog_list{ExcludeBlogs};
        my $iter = $app->model('blog')->load_iter;
        while (my $blog = $iter->()) {
            $blog_list{IncludeBlogs}{$blog->id} = 1
                unless $exclude && $exclude->{$blog->id};
        }
    }

    \%blog_list;
}

sub check_cache {
    my $app = shift;

    my $cache = $app->{cache_driver}->get_multi(
        values %{ $app->{cache_keys} } );

    my $count = $cache->{ $app->{cache_keys}{count} }
        if exists $cache->{ $app->{cache_keys}{count} };
    my $result = $cache->{ $app->{cache_keys}{result} }
        if exists $cache->{ $app->{cache_keys}{result} };

    ( $count, $result );
}

sub process {
    my $app = shift;

    my ( $count, $out ) = $app->check_cache();
    if ( defined $out ) {
        $app->run_callbacks( 'search_cache_hit', $count, $out );
        return $out;
    }

    my @arguments = $app->search_terms();
    return $app->error($app->errstr) if $app->errstr;

    $count = 0;
    my $iter;
    if ( @arguments ) {
        ( $count, $iter ) = $app->execute( @arguments );
        return $app->error($app->errstr) unless $iter;

        $app->run_callbacks( 'search_post_execute', $app, \$count, \$iter );
    }

    my $format = q();
    if ( $format = $app->param('format') ) {
        return $app->errtrans('Invalid format: [_1]', encode_html($format))
            if $format !~ /\w+/;
    }
    my $method = "render";
    $method .= $format if $format && $app->can($method . $format);
    $out = $app->$method( $count, $iter );

    my $result;
    if (ref($out) && ($out->isa('MT::Template'))) {
        defined( $result = $app->build_page($out) )
            or return $app->error($out->errstr);
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
    my $count = $app->{cache_driver}->get($app->{cache_keys}{count});
    return $count if defined $count;

    $count = $class->count( $terms, $args );
    return $app->error($class->errstr) unless defined $count;

    my $cache_driver = $app->{cache_driver};
    $cache_driver->set( $app->{cache_keys}{count}, $count, $app->config->ThrottleSeconds );

    $count;
}

sub execute {
    my $app = shift;
    my ( $terms, $args ) = @_;

    my $class = $app->model( $app->{searchparam}{Type} )
        or return $app->errtrans('Unsupported type: [_1]', encode_html($app->{searchparam}{Type}));

    my $count = $app->count( $class, $terms, $args );
    return $app->errtrans("Invalid query.  [_1]", $app->errstr) unless defined $count;

    my $iter = $class->load_iter( $terms, $args )
        or $app->error($class->errstr);
    ( $count, $iter );
}

sub search_terms {
    my $app = shift;
    my $q = $app->param;

    my $search_string = $q->param('searchTerms') || $q->param('search')
        or return ( undef, undef );
    $app->{search_string} = $search_string;
    my $offset = $q->param('startIndex') || $q->param('offset') || 0;
    return $app->errtrans('Invalid value: [_1]', encode_html($offset))
        if $offset && $offset !~ /^\d+$/;
    my $limit = $q->param('count') || $q->param('limit');
    return $app->errtrans('Invalid value: [_1]', encode_html($limit))
        if $limit && $limit !~ /^\d+$/;
    my $max = $app->{searchparam}{SearchMaxResults};
    $max =~ s/\D//g if defined $max;
    $limit = $max if !$limit || ( $limit - $offset > $max );

    my $params = $app->registry( $app->mode, 'types', $app->{searchparam}{Type} );
    my %def_terms = exists( $params->{terms} )
          ? %{ $params->{terms} }
          : ();
    delete $def_terms{'plugin'}; #FIXME: why is this in here?

    if ( exists $app->{searchparam}{IncludeBlogs} ) {
        $def_terms{blog_id} = [ keys %{ $app->{searchparam}{IncludeBlogs} } ];
    }

    my @terms;
    if (%def_terms) {
        # If we have a term for the model's class column, add it separately, so
        # array search() doesn't add the default class column term.
        my $type = $app->{searchparam}{Type};
        my $model_class = MT->model($type);
        if (my $class_col = $model_class->properties->{class_column}) {
            if ($def_terms{$class_col}) {
                push @terms, { $class_col => delete $def_terms{$class_col} };
            }
        }

        push @terms, \%def_terms;
    }

    my $columns = $params->{columns};
    delete $columns->{'plugin'}; #FIXME: why is this in here?
    return $app->errtrans('No column was specified to search for [_1].', $app->{searchparam}{Type})
        unless $columns && %$columns;

    my $parsed = $app->query_parse( %$columns );
    return $app->errtrans('Parse error: [1]', $app->errstr)
        unless $parsed && %$parsed;

    push @terms, $parsed->{terms} if exists $parsed->{terms};

    my $desc = 'descend' eq $app->{searchparam}{SearchResultDisplay} ? 'DESC' : 'ASC';
    my @sort;
    my $sort = $params->{'sort'};
    if ( $sort !~ /\w+\!$/ && $app->{searchparam}{SearchSortBy} ) {
        my $sort_by = $app->{searchparam}{SearchSortBy};
        $sort_by =~ s/[^\w\-\.\,]+//g;
        if ( $sort_by ) {
            my @sort_bys = split ',', $sort_by;
            foreach my $key ( @sort_bys ) {
                push @sort, {
                    desc   => $desc,
                    column => $key
                };
            }
        }
    }
    push @sort, {
        desc   => $desc,
        column => $sort
    };

    my %args = (
      exists( $parsed->{args} ) ? %{ $parsed->{args} } : (),
      $limit  ? ( 'limit' => $limit ) : (),
      $offset ? ( 'offset' => $offset ) : (),
      @sort   ? ( 'sort' => \@sort ) : (),
    );

    ( \@terms, \%args );
}

sub cache_out {
    my ( $cb, $app, $count, $out ) = @_;

    my $result;
    if (ref($out) && ($out->isa('MT::Template'))) {
        defined($result = $app->build_page($out))
            or die $out->errstr;
    }
    else {
        $result = $out;
    }

    my $cache_driver = $app->{cache_driver};
    $cache_driver->set( $app->{cache_keys}{result}, $out, $app->config->ThrottleSeconds );
}

sub log_search {
    my ( $cb, $app, $count_ref, $iter_ref ) = @_;

    #FIXME: template name may not be 'feed' for search feed
    unless ( $app->param('template') && ( 'feed' eq $app->param('template') ) ) {
        my $blog_id = $app->first_blog_id();
        require MT::Log;
        $app->log({
            message => $app->translate("Search: query for '[_1]'",
                  $app->{search_string}),
            level => MT::Log::INFO(),
            class => 'search',
            category => 'straight_search',
            $blog_id ? (blog_id => $blog_id) : ()
        });
    }
}

sub template_paths {
    my $app = shift;
    my @paths = $app->SUPER::template_paths;
    ( $app->config->SearchTemplatePath, @paths );
}

sub first_blog_id {
    my $app = shift;
    my $q = $app->param;

    my $blog_id;
    if ( $q->param('IncludeBlogs') ) {
        my @ids = split ',', $q->param('IncludeBlogs');
        $blog_id = $ids[0];
    }
    elsif ( exists($app->{searchparam}{IncludeBlogs})
      && keys(%{ $app->{searchparam}{IncludeBlogs} }) ) {
        my @blog_ids = keys %{ $app->{searchparam}{IncludeBlogs} };
        $blog_id = $blog_ids[0] if @blog_ids;
    }
    $blog_id;
}

sub prepare_context {
    my $app = shift;
    my $q = $app->param;
    my ( $count, $iter ) = @_;

    ## Initialize and set up the context object.
    require MT::Template::Context::Search;
    my $ctx = MT::Template::Context::Search->new;
    if ( my $str = $app->{search_string} ) {
        $ctx->stash('search_string', encode_html($str));
    }
    if ( $q->param('type') ) {
        $ctx->stash('type', $app->{searchparam}{Type});
    }
    if ( $app->{default_mode} ne $app->mode ) {
        $ctx->stash('mode', $app->mode);
    }
    if ( my $template = $q->param('Template') ) {
        $template =~ s/[\w\-\.]//g;
        $ctx->stash('template_id', $template);
    }
    $ctx->stash('stash_key'  , $app->{searchparam}{Type} );
    $ctx->stash('maxresults' , $app->{searchparam}{SearchMaxResults});
    $ctx->stash('include_blogs',
        join ',', keys %{ $app->{searchparam}{IncludeBlogs} });
    $ctx->stash('results'    , $iter);
    $ctx->stash('count'      , $count);
    $ctx->stash('offset'     , $q->param('startIndex') || $q->param('offset') || 0);
    $ctx->stash('limit'      , $q->param('count') || $q->param('limit'));
    $ctx->stash('format'     , $q->param('format')) if $q->param('format');

    my $blog_id = $app->first_blog_id();
    if ( $blog_id ) {
        $ctx->stash('blog_id', $blog_id);
        $ctx->stash('blog',    $app->model('blog')->load($blog_id));
    }
    $ctx;
}

sub load_search_tmpl {
    my $app = shift;
    my $q = $app->param;
    my ( $ctx ) = @_;

    my $tmpl;
    if ( $q->param('Template') && ( 'default' ne $q->param('Template') ) ) {
        # load specified template
        my $filename;
        if (my @tmpls = (
          $app->config->default('SearchAltTemplate'),
          $app->config->SearchAltTemplate) ) {
            for my $tmpl (@tmpls) {
                next unless defined $tmpl;
                my ( $nickname, $file ) = split /\s+/, $tmpl;
                if ( $nickname eq $q->param('Template') ) {
                    $filename = $file;
                    last;
                }
            }
        }
        return $app->errtrans( "No alternate template is specified for the Template '[_1]'",
          encode_html( $q->param('Template') ) )
            unless $filename;
        # template_paths method does the magic
        $tmpl = $app->load_tmpl( $filename )
            or return $app->errtrans( "Opening local file '[_1]' failed: [_2]", $filename, "$!" );
    }
    else {
        # load default template
        # first look for appropriate blog_id
        if ( my $blog_id = $ctx->stash('blog_id') ) {
            # look for 'search_results'
            my $tmpl_class = $app->model('template');
            $tmpl = $tmpl_class->load(
                { blog_id => $blog_id, type => 'search_results' }
            );
        }
        unless ( $tmpl ) {
            # load template from search_template path
            # template_paths method does the magic
            $tmpl = $app->load_tmpl( $app->config->SearchDefaultTemplate );
        }
    }
    return $app->error($app->errstr)
        unless $tmpl;

    $ctx->var('system_template', '1');
    $ctx->var('search_results', '1');

    $tmpl->context($ctx);
    $tmpl;
}

sub render {
    my $app = shift;
    my ( $count, $iter ) = @_;

    my @arguments = $app->prepare_context( $count, $iter )
        or return $app->error($app->errstr);
    my $tmpl = $app->load_search_tmpl( @arguments )
        or return $app->error($app->errstr);
    $tmpl;
}

sub renderjs {
    my $app = shift;
    my ( $count, $iter ) = @_;

    my ( $ctx ) = $app->prepare_context( $count, $iter )
        or return $app->json_error($app->errstr);
    my $search_tmpl = $app->load_search_tmpl( $ctx )
        or return $app->json_error($app->errstr);
    my $result_node = $search_tmpl->getElementById('search_results')
        or return $app->json_error('Search template does not have markup for search results.');
    my $t = $result_node->innerHTML();

    require MT::Template;
    my $tmpl = MT::Template->new( type => 'scalarref', source => \$t );
    $ctx->stash('format', q()); # don't propagate "js" format
    $tmpl->context( $ctx );
    my $content = $tmpl->output
        or return $app->json_error($tmpl->errstr);

    my $next_link = $ctx->_hdlr_next_link();
    return $app->json_result({ content => $content, next_url => $next_link });
}

sub query_parse {
    my $app = shift;
    my ( %columns ) = @_;

    my $search = $app->{search_string};

    my $reg = $app->registry( $app->mode, 'types', $app->{searchparam}{Type} );
    my $filter_types = $reg->{ 'filter_types' };
    foreach my $type ( keys %$filter_types ) {
        if ( my $filter = $app->param($type) ) {
            $search .= " $type:$filter";
        }
    }

    require Lucene::QueryParser;
    my $lucene_struct = Lucene::QueryParser::parse_query( $search );
    my ( $terms, $joins ) = $app->_query_parse_core( $lucene_struct, \%columns, $filter_types );
    my $return = {
        $terms && @$terms ? (terms => $terms) : ()
    };
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
    _create_join_arg($next, $joins);
    $args->{'join'} = $join;
}

sub _query_parse_core {
    my $app = shift;
    my ( $lucene_struct, $columns, $filter_types ) = @_;

    my $rvalue = sub {
        my %rvalues = (
            NORMALlike => { like => '%' . $_[1] . '%' },
            NORMAL1    => $_[1],
            PROHIBITEDlike => { not_like => '%' . $_[1] . '%' },
            PROHIBITED1    => { not => $_[1] }
        );
        $rvalues{$_[0]};
    };

    my ( @structure, @joins );
    for my $term ( @$lucene_struct ) {
        if ( exists $term->{field} ) {
            unless ( exists $columns->{ $term->{field} } ) {
                next if $filter_types && %$filter_types
                    && !exists( $filter_types->{ $term->{field} } );
            }
        }

        my @tmp;
        if ( ( 'TERM' eq $term->{query} ) || ( 'PHRASE' eq $term->{query} ) ){
            my $test;
            if ( exists( $term->{field} ) ) {
                if ( $filter_types && %$filter_types
                  && exists( $filter_types->{ $term->{field} } ) ) {
                    my $code = $app->handler_to_coderef($filter_types->{ $term->{field} });
                    if ( $code ) {
                        my $join_args = $code->( $app, $term );
                        push @joins, $join_args;
                        next;
                    }
                }
                elsif ( exists $columns->{ $term->{field} } ) {
                    my $test = $rvalue->(
                        ( $term->{type} || '' ) . $columns->{ $term->{field} },
                        $term->{term}
                    );
                    push @tmp, { $term->{field} => $test };
                }
            }
            else {
                my @cols = keys %$columns;
                my $number = scalar @cols;
                for ( my $i = 0; $i < $number; $i++ ) {
                    my $test = $rvalue->(
                        ( $term->{type} || '' ) . $columns->{ $cols[$i] },
                        $term->{term}
                    );
                    push @tmp, { $cols[$i] => $test };
                    unless ( $i == $number - 1 ) {
                        push @tmp, '-or';
                    }
                }
            }
        }
        elsif ( 'SUBQUERY' eq $term->{query} ) {
            my ( $test, $more_joins ) = $app->_query_parse_core(
                $term->{subquery}, $columns, $filter_types );
            next unless $test && @$test;
            if ( @structure ) {
                push @structure, 'PROHIBITED' eq $term->{type}
                  ? '-and_not'
                  : '-and';
            }
            push @structure, $test->[0];
            push @joins, @$more_joins;
            next;
        }

        if ( exists($term->{conj}) && ( 'OR' eq $term->{conj} ) ) {
            if ( my $prev = pop @structure ) {
                push @structure, [ $prev, -or => \@tmp ];
            }
        }
        else {
            if ( @structure ) {
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

    my $lucene_struct = Lucene::QueryParser::parse_query( $query );
    if ( 'PROHIBITED' eq $term->{type} ) {
        $_->{type} = 'PROHIBITED' foreach @$lucene_struct;
    }
    # search for exact match
    my ( $terms ) = $app->_query_parse_core( $lucene_struct, { label => 1 }, {} );
    return unless $terms && @$terms;
    push @$terms, '-and', {
        id => \'= placement_category_id',
        blog_id => \'= entry_blog_id',
    };

    require MT::Placement;
    require MT::Category;
    return MT::Placement->join_on( undef,
        { entry_id => \'= entry_id', blog_id => \'= entry_blog_id' },
        { join => MT::Category->join_on( undef, $terms, {} ),
          unique => 1 }
    );
}

# add author filter to entry search
sub _join_author {
    my ( $app, $term ) = @_;

    my $query = $term->{term};
    if ( 'PHRASE' eq $term->{query} ) {
        $query =~ s/'/"/g;
    }

    my $lucene_struct = Lucene::QueryParser::parse_query( $query );
    if ( 'PROHIBITED' eq $term->{type} ) {
        $_->{type} = 'PROHIBITED' foreach @$lucene_struct;
    }
    my ( $terms ) = $app->_query_parse_core( $lucene_struct, { nickname => 'like' }, {} );
    return unless $terms && @$terms;
    push @$terms, '-and', {
        id => \'= entry_author_id',
    };
    require MT::Author;
    return MT::Author->join_on( undef,
        $terms,
        { unique => 1 }
    );
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

=head1 AUTHOR & COPYRIGHT

Please see L<MT/AUTHOR & COPYRIGHT>.

=cut
