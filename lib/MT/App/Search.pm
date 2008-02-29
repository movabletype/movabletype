# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package MT::App::Search;

use strict;
use base qw( MT::App );

use MT::Util qw( encode_html );

sub id { 'new_search' }

sub init {
    my $app = shift;
    $app->SUPER::init(@_) or return;
    $app->set_no_cache;
    $app->{default_mode} = 'search';
    $app;
}

sub core_methods {
    my $app = shift;
    return {
        'search' => \&process,
    };
}

sub core_query_params {
    my $app = shift;
    return [
        'searchTerms',
        'search',
        'count',
        'limit',
        'startIndex',
        'offset',
    ];
}

sub init_request{
    my $app = shift;
    $app->SUPER::init_request(@_);
    my $q = $app->param;

    my $params = $app->registry('params');
    foreach ( @$params ) {
        delete $app->{$_} if exists $app->{$_}
    }

    my %no_override = map { $_ => 1 } split /\s*,\s*/, $app->config->NoOverride;
    my $blog_list = $app->create_blog_list( %no_override );
    $app->{searchparam}{IncludeBlogs} = $blog_list->{IncludeBlogs}
        if $blog_list && %$blog_list
        && $blog_list->{IncludeBlogs}
        && %{ $blog_list->{IncludeBlogs} };

    ## Set other search params--prefer per-query setting, default to
    ## config file.
    for my $key (qw( ResultDisplay MaxResults SearchSortBy )) {
        $app->{searchparam}{$key} = $no_override{$key} ?
            $app->config->$key() : ($q->param($key) || $app->config->$key());
    }

    $app->{searchparam}{Type} = $q->param('type') || 'entry';
}

sub create_blog_list {
    my $app = shift;
    my ( %no_override ) = @_;

    my $q = $app->param;
    my $cfg = $app->config;

    %no_override = map { $_ => 1 } split /\s*,\s*/, $cfg->NoOverride
        unless %no_override;

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

sub process {
    my $app = shift;

    my @arguments = $app->search_terms();
    return $app->error($app->errstr) if $app->errstr;

    my $count = 0;
    my $iter;
    if ( @arguments ) {
        ( $count, $iter ) = $app->execute( @arguments );
        return $app->error($app->errstr) unless $iter;

        $iter = $app->post_search( $count, $iter );
    }

    return $app->render( $count, $iter );
}

sub count {
    my $app = shift;
    my ( $class, $terms, $args ) = @_;
    #TODO: cache!
    $class->count( $terms, $args );
}

sub execute {
    my $app = shift;
    my ( $terms, $args ) = @_;

    my $class = $app->model( $app->{searchparam}{Type} )
        or return $app->errtrans('Unsupported type: [_1]', $app->{searchparam}{Type});
    my $count = $app->count( $class, $terms, $args );
    #TODO: cache!
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
    my $limit = $q->param('count') || $q->param('limit');
    my $max = $app->{searchparam}{MaxResults};
    $limit = $max if !$limit || ( $limit - $offset > $max );

    my $params = $app->registry( $app->{searchparam}{Type} );
    my %def_terms = exists( $params->{terms} )
          ? %{ $params->{terms} }
          : ();
    delete $def_terms{'plugin'}; #FIXME: why is this in here?

    if ( exists $app->{searchparam}{IncludeBlogs} ) {
        $def_terms{blog_id} = [ keys %{ $app->{searchparam}{IncludeBlogs} } ];
    }

    my @terms;
    push @terms, \%def_terms if %def_terms;

    my $columns = $params->{columns};
    my $sort = $params->{'sort'};
    if ( $sort !~ /\w+\!$/  && exists($app->{searchparam}{Sort}) ) {
        $sort = $app->{searchparam}{Sort};
    }

    return $app->errtrans('No column was specified to search for [_1].', $app->{searchparam}{Type})
        unless $columns && @$columns;

    my $number = scalar @$columns;
    my @and;
    for ( my $i = 0; $i < $number; $i++) {
        push @and, { $columns->[$i] => { like => '%'.$search_string.'%' } };
        unless ( $i == $number - 1 ) {
            push @and, '-or';
        }
    }
    push @terms, '-and' if @terms;
    push @terms, \@and;

    my %args = (
      $limit ? ( 'limit' => $limit ) : (),
      $offset ? ( 'offset' => $offset ) : (),
      'sort' => [
        { desc   => 'descend' eq $app->{searchparam}{ResultDisplay} ? 'DESC' : 'ASC',
          column => $sort }
      ]
    );

    if ( exists $app->{searchparam}{IncludeBlogs} ) {
        unshift @{ $args{'sort'} },
          { desc => 'ASC',
            column    => 'blog_id' };
    }

    ( \@terms, \%args );
}

sub post_search {
    my $app = shift;
    my ( $count, $iter ) = @_;
    # TODO: cache here?
    $iter;
}

sub template_paths {
    my $app = shift;
    my @paths = $app->SUPER::template_paths;
    ( $app->config->SearchTemplatePath, @paths );
}

sub load_search_tmpl {
    my $app = shift;
    my $q = $app->param;
    my ( $count, $iter ) = @_;

    my $blog_id;
    if ( $q->param('IncludeBlogs') ) {
        my @ids = split ',', $q->param('IncludeBlogs');
        $blog_id = $ids[0];
    }
    elsif ( exists $app->{searchparam}{IncludeBlogs} ) {
        $blog_id = @{ keys %{ $app->{searchparam}{IncludeBlogs} } }[0];
    }

    my $tmpl;
    if ( $q->param('Template') && ( 'default' ne $q->param('Template') ) ) {
        # load specified template
        my $filename;
        if (my @tmpls = ($app->config->default('AltTemplate'), $app->config->AltTemplate)) {
            for my $tmpl (@tmpls) {
                next unless defined $tmpl;
                my ( $nickname, $file ) = split /\s+/, $tmpl;
                if ( $nickname eq $q->param('Template') ) {
                    $filename = $file;
                    last;
                }
            }
        }
        return $app->errtrans("No alternate template is specified for the Template '[_1]'", $q->param('Template'))
            unless $filename;
        # template_paths method does the magic
        $tmpl = $app->load_tmpl( $filename )
            or return $app->errtrans( "Opening local file '[_1]' failed: [_2]", $filename, "$!" );
    }
    else {
        # load default template
        # first look for appropriate blog_id
        if ( $blog_id ) {
            # look for 'search_results'
            my $tmpl_class = $app->model('template');
            $tmpl = $tmpl_class->load(
                { blog_id => $blog_id, type => 'search_results' }
            );
        }
        unless ( $tmpl ) {
            # load template from search_template path
            # template_paths method does the magic
            $tmpl = $app->load_tmpl( $app->config->DefaultTemplate );
        }
    }
    return $app->error($app->errstr)
        unless $tmpl;

    ## Initialize and set up the context object.
    require MT::Template::Context::Search;
    my $ctx = MT::Template::Context::Search->new;
    if ( $blog_id ) {
        $ctx->stash('blog_id', $blog_id);
        $ctx->stash('blog',    $app->model('blog')->load($blog_id));
    }
    $ctx->stash('results', $iter);
    $ctx->stash('count',   $count);
    $ctx->stash('stash_key', $app->{searchparam}{Type} );
    $ctx->stash('include_blogs',
        join ',', keys %{ $app->{searchparam}{IncludeBlogs} });
    if ( my $str = $app->{search_string} ) {
        $ctx->stash('search_string', encode_html($str));
    }
    $ctx->stash('template_id', $q->param('Template'));
    $ctx->stash('maxresults' , $app->{searchparam}{MaxResults});

    $tmpl->context($ctx);
    $tmpl;
}

sub pre_render {
    my $app = shift;
    my ( $tmpl ) = @_;
    $tmpl;
}

sub render {
    my $app = shift;
    my ( $count, $iter ) = @_;

    my $tmpl = $app->load_search_tmpl( $count, $iter );
    $tmpl = $app->pre_render( $tmpl );
    $tmpl;
}

sub query_parse {
    my $app = shift;
    return unless $app->{search_string};
    use utf8;
    #local $_ = MT::I18N::decode_utf8($app->{search_string});
    local $_ = $app->{search_string_decoded};

    s/^\s//;            # Remove leading whitespace
    s/\s$//;            # Remove trailing whitespace
    s/\s+AND\s+/ /g;    # Remove AND because it's implied
    s/\s{2,}/ /g;       # Remove contiguous spaces

    my @search_keys;
    my @tokens = split;
    while (my $atom = shift @tokens) {
        my($type);
        if ($atom eq 'NOT' || $atom eq 'AND') {
            $type = $atom;
            $atom = shift @tokens;
            $atom = find_phrase($atom, \@tokens) if $atom =~ /^\"/;
        } elsif ($atom eq 'OR') {
            $atom = shift @tokens;
            $atom = find_phrase($atom, \@tokens) if $atom =~ /^\"/;
            ## OR new atom with last atom
            $search_keys[-1]{atom} =
                '(?:' . $search_keys[-1]{atom} .'|' . quotemeta($atom) . ')';
            next;
        } elsif ($atom =~ /^-(.*)/) {
            $type = 'NOT';
            $atom = $1;
            $atom = find_phrase($atom, \@tokens) if $atom =~ /^\"/;
        } else {
            $type = 'AND';
            $atom = find_phrase($atom, \@tokens) if $atom =~ /^\"/;
        }
        push @search_keys, { atom => quotemeta($atom),
                             type => $type };
    }

    $app->{searchparam}{search_keys} = \@search_keys;
    $app->query_optimize;
}

sub find_phrase {
    my($atom, $tokenref) = @_;
    while (my $next = shift @$tokenref) {
        $atom = $atom . ' ' . $next;
        last if $atom =~ /\"$/;
    }
    $atom =~ s/^"(.*)"$/$1/;
    $atom;
}

sub query_optimize {
    my $app = shift;

    ## Sort keys longest to shortest for search efficiency.
    $app->{searchparam}{search_keys} = [
        reverse sort { length($a->{atom}) <=> length($b->{atom}) }
        @{ $app->{searchparam}{search_keys} }
    ];
    
    ## Sort keys by contents. Any ORs immediately get a lower priority.
    my %terms;
    for my $key (@{ $app->{searchparam}{search_keys} }) {
        if ($key->{atom} =~ /\(.*\|.*\)/) {
            push(@{ $terms{$key->{type}}{low} }, $key);
        } else {
            push(@{ $terms{$key->{type}}{high} }, $key);
        }
    }

    ## Final priority: AND long, AND short, AND with OR (long/short),
    ## NOT long/short
    ##  This should give us the most efficient search in that it is
    ##  searching for the harder-to-match keys first.
    my %regex;
    for my $type (qw( AND NOT )) {
        for my $pri (qw( high low )) {
            for my $obj (@{ $terms{$type}{$pri} }) {
                push(@{ $regex{$type} }, $obj->{atom});
            }
        }
    }

    $app->{searchparam}{search_keys} = \%regex;
}

1;
__END__

=head1 NAME

MT::App::Search

=head1 AUTHOR & COPYRIGHT

Please see L<MT/AUTHOR & COPYRIGHT>.

=cut
