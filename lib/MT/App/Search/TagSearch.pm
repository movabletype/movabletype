# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::App::Search::TagSearch;

use strict;
use warnings;
use MT::Util qw( epoch2ts offset_time_list );
use HTTP::Date qw( str2time );

sub process {
    my $app = shift;
    return $app->errtrans('TagSearch works with MT::App::Search.')
        unless $app->isa('MT::App::Search') || $app->isa('MT::App::DataAPI');

    my ( $count, $out ) = $app->check_cache();
    if ( defined $out ) {
        $app->run_callbacks( 'search_cache_hit', $count, $out );
        return $out;
    }

    my ( $terms, $args ) = &search_terms($app);
    return $app->error( $app->errstr ) if $app->errstr;

    $count = 0;
    my $iter;
    if ( $terms && $args ) {
        ( $count, $iter ) = $app->execute( $terms, $args );
        return $app->error( $app->errstr ) unless $iter;

        $app->run_callbacks( 'search_post_execute', $app, \$count, \$iter );
    }

    my $format = $app->param('format') || q();
    my $method = "render";
    if ($format) {
        $method .= $format if $app->can( $method . $format );
    }
    elsif ( my $tmpl_name = $app->param('Template') ) {
        $method .= $tmpl_name if $app->can( $method . $tmpl_name );
    }

    $out = $app->$method( $count, $iter );

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

sub _process_lucene_query {
    my ($search_string) = @_;

    require Lucene::QueryParser;
    my $lucene_struct = Lucene::QueryParser::parse_query($search_string);

    my @or_tags;
    for my $term (@$lucene_struct) {
        next if exists $term->{field};
        next if 'SUBQUERY' eq $term->{query};

        if ( ( 'TERM' eq $term->{query} ) || ( 'PHRASE' eq $term->{query} ) )
        {
            if ( 'OR' eq $term->{conj} ) {
                if ( my $prev = pop @or_tags ) {
                    push @or_tags, $prev . ',' . $term->{term};
                    next;
                }
            }
            push @or_tags, $term->{term};
        }
    }
    @or_tags;
}

sub add_join {
    my ( $class, $terms, $def_args, $depth, $tag_ids ) = @_;

    my $alias  = $class->datasource . '_' . $depth;
    my $j_term = "= $alias.objecttag_object_id";
    $depth++;
    my $this_alias = $class->datasource . '_' . $depth;
    my %args;
    my $tag_id = shift @$tag_ids;
    if ($tag_id) {
        my $j_arg = &add_join( $class, $terms, $def_args, $depth, $tag_ids );
        $args{'join'} = $j_arg if $j_arg && @$j_arg;
    }
    if ($tag_id) {
        return $class->join_on(
            undef,
            {   object_id => \$j_term,
                tag_id    => $tag_id,
                %$terms
            },
            { %args, %$def_args, 'alias' => $this_alias }
        );
    }
    undef;
}

sub search_terms {
    my $app = shift;

    my $offset = $app->param('startIndex') || $app->param('offset') || 0;
    my $limit = $app->param('count') || $app->param('limit');
    my $max = $app->{searchparam}{SearchMaxResults};
    $limit = $max if !$limit || ( $limit - $offset > $max );

    my $tag_class = $app->model('tag');
    my $search_string = $app->param('tag') || $app->param('search');
    $app->{search_string} = $search_string;

    my @or_tag_names;
    if (   ( $search_string =~ /\s+OR\s+/ )
        || ( $search_string =~ /\s+AND\s+/ )
        || ( $search_string =~ /\s*"\s*/ ) )
    {
        @or_tag_names = &_process_lucene_query($search_string);
    }
    else {
        my $counter = sub {
            my $tmp   = $_[0];
            my $count = $tmp =~ s/,/,/g;
            $count;
        };

        # plus to split intersection, comma to split addition
        @or_tag_names = split /\+\s*/, $search_string;

        # sort by the number of tags in each section (smallest first)
        @or_tag_names
            = sort { $counter->($a) cmp $counter->($b) } @or_tag_names;
    }

    my @or_tags;
    my $terms
        = { $app->config->SearchPrivateTags ? () : ( is_private => '0' ) };
    foreach my $or_tag_name (@or_tag_names) {
        my %tags = map { $_ => 1, $tag_class->normalize($_) => 1 }
            ( split( /,/, $or_tag_name ), $or_tag_name );
        $terms->{name} = [ keys %tags ];
        my @tags = $tag_class->load($terms);
        my @tmp;
        foreach my $tag (@tags) {
            push @tmp, $tag->id;
            my @more = $tag_class->load(
                { n8d_id => $tag->n8d_id ? $tag->n8d_id : $tag->id } );
            push @tmp, $_->id foreach @more;
        }
        push @or_tags, \@tmp if @tmp;
    }
    return ( undef, undef ) unless @or_tags;

    my $ot_class = $app->model('objecttag');
    my $class    = $app->model( $app->{searchparam}{Type} )
        or return $app->error( $app->errstr );

    my $params
        = $app->registry( 'default', 'types', $app->{searchparam}{Type} );
    my %terms = ();
    if ( exists( $params->{terms} ) ) {
        if ( 'HASH' ne ref $params->{terms} ) {
            my $code = $params->{terms};
            $code = MT->handler_to_coderef($code);
            eval { %terms = %{ $code->($app) }; };
        }
        else {
            %terms = %{ $params->{terms} };
        }
    }
    delete $terms{'plugin'};    #FIXME: why is this in here?

    if ( exists $app->{searchparam}{IncludeBlogs} ) {
        $terms{blog_id} = $app->{searchparam}{IncludeBlogs};
    }

    my $depth = 1;
    my $alias = $ot_class->datasource . '_' . $depth;

    my $or_tag = shift @or_tags;
    my $join_on_arg;
    if (@or_tags) {
        $join_on_arg
            = &add_join( $ot_class,
            { object_datasource => $class->datasource },
            {}, $depth, \@or_tags );
    }

    #TODO: what if pk is from multiple cols?
    my $pk = $class->datasource . '_' . $class->properties->{primary_key};
    my $join_on = $ot_class->join_on(
        undef,
        {   tag_id            => $or_tag,
            object_datasource => $class->datasource,
            object_id         => \"= $pk"
        },
        {   alias => $alias,
            $join_on_arg && @$join_on_arg ? ( 'join' => $join_on_arg ) : ()
        }
    );

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
        'join' => $join_on,
        $limit  ? ( 'limit'  => $limit )  : (),
        $offset ? ( 'offset' => $offset ) : (),
        @sort   ? ( 'sort'   => \@sort )  : (),
    );

    my $blog_class = $app->model('blog');

    # Override SearchCutoff if If-Modified-Since header is present
    if ( ( my $mod_since = $app->get_header('If-Modified-Since') )
        && $app->param('Template') eq 'feed' )
    {
        my $tz_offset = 15;    # Start with maximum possible offset to UTC
        my $blog_selected;
        my $iter;
        if ( $app->{searchparam}{IncludeBlogs} ) {
            $iter = $blog_class->load_iter(
                { id => $app->{searchparam}{IncludeBlogs} } );
        }
        else {
            $iter = $blog_class->load_iter;
        }
        while ( my $blog = $iter->() ) {
            my $blog_offset = $blog->server_offset ? $blog->server_offset : 0;
            if ( $blog_offset < $tz_offset ) {
                $tz_offset     = $blog_offset;
                $blog_selected = $blog;
            }
        }
        $mod_since = epoch2ts( $blog_selected, str2time($mod_since) );
        if (   ( 'entry' eq $app->{searchparam}{Type} )
            || ( 'page' eq $app->{searchparam}{Type} ) )
        {
            $terms{authored_on} = [$mod_since];
            $args{range} = { authored_on => 1 };
        }
        else {
            $terms{created_on} = [$mod_since];
            $args{range} = { created_on => 1 };
        }
    }

    ( \%terms, \%args );
}

1;
__END__

=head1 NAME

MT::App::Search::TagSearch

=head1 SYNTAX

TagSearch allows the following syntax in url-encoded "tag" parameter.

"MovableType,TypePad,Vox" matches objects which has either MovableType,
TypePad, or Vox tag.

"MovableType+TypePad+Vox" matches objects which has all three tags.

"TypePad OR Vox AND "Movable Type"" matches objects which has
either TypePad or Vox tag *and* "Movable Type" tag.

=head1 AUTHOR & COPYRIGHT

Please see L<MT/AUTHOR & COPYRIGHT>.

=cut
