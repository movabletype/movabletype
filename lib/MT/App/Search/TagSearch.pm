# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package MT::App::Search::TagSearch;

use strict;
use MT::Util qw( epoch2ts offset_time_list );
use HTTP::Date qw( str2time );

sub process {
    my $app = shift;
    return $app->errtrans('TagSearch works with MT::App::Search.')
        unless $app->isa('MT::App::Search');

    my ( $terms, $args ) = &search_terms( $app );
    return $app->error($app->errstr) if $app->errstr;

    my $count = 0;
    my $iter;
    if ( $terms && $args ) {
        ( $count, $iter ) = $app->execute( $terms, $args );
        return $app->error($app->errstr) unless $iter;

        $iter = $app->post_search( $count, $iter );
    }

    return $app->render( $count, $iter );
}

sub _process_lucene_query {
    my ($search_string) = @_;

    require Lucene::QueryParser;
    my $lucene_struct = Lucene::QueryParser::parse_query( $search_string );

    my @or_tags;
    for my $term ( @$lucene_struct ) {
        next if exists $term->{field};
        next if 'SUBQUERY' eq $term->{query};

        if ( ( 'TERM' eq $term->{query} ) || ( 'PHRASE' eq $term->{query} ) ){
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


sub search_terms {
    my $app = shift;
    my $q = $app->param;

    my $offset = $q->param('startIndex') || $q->param('offset') || 0;
    my $limit = $q->param('count') || $q->param('limit');
    my $max = $app->{searchparam}{MaxResults};
    $limit = $max if !$limit || ( $limit - $offset > $max );

    my $tag_class = $app->model('tag');
    my $search_string = $q->param('tag') || $q->param('search');
    $app->{search_string} = $search_string;

    my @or_tag_names;
    if ( ( $search_string =~ /\s+OR\s+/ )
      || ( $search_string =~ /\s+AND\s+/ )
      || ( $search_string =~ /\s*"\s*/ ) ) {
        @or_tag_names = &_process_lucene_query( $search_string );
    }
    else {
        my $counter = sub {
            my $tmp = $_[0];
            my $count = $tmp =~ s/,/,/g;
            $count;
        };

        # plus to split intersection, comma to split addition 
        @or_tag_names = split /\+\s*/, $search_string;
        # sort by the number of tags in each section (smallest first)
        @or_tag_names = sort { $counter->($a) cmp $counter->($b) } @or_tag_names;
    }

    my @or_tags;
    foreach my $or_tag_name ( @or_tag_names ) {
        my %tags = map { $_ => 1, $tag_class->normalize($_) => 1 } split(/,/, $or_tag_name);
        my @tags = $tag_class->load({ name => [ keys %tags ] });
        my @tmp;
        foreach my $tag (@tags) {
            push @tmp, $tag->id;
            my @more = $tag_class->load({ n8d_id => $tag->n8d_id ? $tag->n8d_id : $tag->id });
            push @tmp, $_->id foreach @more;
        }
        push @or_tags, \@tmp if @tmp;
    }

    my $ot_class = $app->model('objecttag');
    my $class = $app->model( $app->{searchparam}{Type} )
        or return $app->error($app->errstr);

    my $params = $app->registry( 'default', 'types', $app->{searchparam}{Type} );
    my %def_terms = exists( $params->{terms} )
          ? %{ $params->{terms} }
          : ();
    delete $def_terms{'plugin'}; #FIXME: why is this in here?

    my $sort = $params->{'sort'};
    if ( $sort !~ /\w+\!$/  && exists($app->{searchparam}{Sort}) ) {
        $sort = $app->{searchparam}{Sort};
    }

    if ( exists $app->{searchparam}{IncludeBlogs} ) {
        $def_terms{blog_id} = [ keys %{ $app->{searchparam}{IncludeBlogs} } ];
    }

    my $or_tag = shift @or_tags;
    my @object_ids = $class->load( \%def_terms, {
        'fetchonly' => [ qw( id ) ],
        'join' => $ot_class->join_on( 'object_id',
            { tag_id => $or_tag, object_datasource => $class->datasource }
        )}
    );
    my @ids = map { $_->id } @object_ids;
    while ( @ids && @or_tags ) {
        $or_tag = shift @or_tags;
        @object_ids = $class->load(
          {
            %def_terms,
            id => \@ids
          },
          {
            'fetchonly' => [ qw( id ) ],
            'join' => $ot_class->join_on( 'object_id',
                { tag_id => $or_tag, object_datasource => $class->datasource }
            )
          }
        );
        @ids = map { $_->id } @object_ids;
    }

    return ( undef, undef ) unless @ids;

    my %terms = (
        id => \@ids
    );

    my %args = (
      $limit  ? ( 'limit' => $limit ) : (),
      $offset ? ( 'offset' => $offset ) : (),
      $sort   ? ( 'sort' => [
            { desc   => 'descend' eq $app->{searchparam}{ResultDisplay} ? 'DESC' : 'ASC',
              column => $sort }
        ] ) : (),
    );

    if ( exists $app->{searchparam}{IncludeBlogs} ) {
        unshift @{ $args{'sort'} },
          { desc => 'ASC',
            column    => 'blog_id' };
    }

    my $blog_class = $app->model('blog');
    # Override SearchCutoff if If-Modified-Since header is present
    if ((my $mod_since = $app->get_header('If-Modified-Since')) && $app->param('Template') eq 'feed') {
        my $tz_offset = 15;  # Start with maximum possible offset to UTC
        my $blog_selected;
        my $iter;
        if ($app->{searchparam}{IncludeBlogs}) {
            $iter = $blog_class->load_iter({ id => [ keys %{ $app->{searchparam}{IncludeBlogs} }] });
        } else {
            $iter = $blog_class->load_iter;
        }
        while (my $blog = $iter->()) {
            my $blog_offset = $blog->server_offset ?
                $blog->server_offset : 0;
            if ($blog_offset < $tz_offset) {
                $tz_offset = $blog_offset;
                $blog_selected = $blog;
            }
        }
        $mod_since = epoch2ts($blog_selected, str2time($mod_since));
        if ( ( 'entry' eq $app->{searchparam}{Type} )
          || ( 'page'  eq $app->{searchparam}{Type} ) ) {
            $terms{authored_on} = [ $mod_since ];
            $args{range} = { authored_on => 1 };
        }
        else {
            $terms{created_on} = [ $mod_since ];
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
