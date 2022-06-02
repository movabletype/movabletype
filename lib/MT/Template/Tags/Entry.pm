# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::Template::Tags::Entry;

use strict;
use warnings;

use MT;
use MT::Util
    qw( offset_time_list spam_protect asset_cleanup encode_html remove_html );
use MT::Entry;
use MT::I18N qw( first_n_text const );
use MT::Template::Tags::Common;

# returns an iterator that supplies entries, in the order of last comment
# date (descending)
sub _rco_entries_iter {
    my ( $entry_terms, $entry_args, $blog_terms, $blog_args ) = @_;

    my $offset = 0;
    my $limit = $entry_args->{limit} || 20;
    my @entries;
    delete $entry_args->{direction}
        if exists $entry_args->{direction};
    delete $entry_args->{sort}
        if exists $entry_args->{sort};

    my $rco_iter = sub {
        if ( !@entries ) {
            require MT::Comment;
            my $iter = MT::Comment->max_group_by(
                {   visible => 1,
                    %$blog_terms,
                },
                {   join => MT::Entry->join_on(
                        undef,
                        {   'id' => \'=comment_entry_id',
                            %$entry_terms,
                        },
                        {%$entry_args}
                    ),
                    %$blog_args,
                    group  => ['entry_id'],
                    max    => 'created_on',
                    offset => $offset,
                    limit  => $limit,
                }
            );
            my @ids;
            my %order;
            my $num = 0;
            while ( my ( $max, $id ) = $iter->() ) {
                push @ids, $id;
                $order{$id} = $num++;
            }
            if (@ids) {
                @entries = MT::Entry->load( { id => \@ids } );
                @entries
                    = sort { $order{ $a->id } <=> $order{ $b->id } } @entries;
            }
        }
        if (@entries) {
            $offset++;
            return shift @entries;
        }
        else {
            return undef;
        }
    };
    return Data::ObjectDriver::Iterator->new($rco_iter);
}

###########################################################################

=head2 Entries

The Entries tag is a workhorse of MT publishing. It is used for
publishing a selection of entries in a variety of situations. Typically,
the basic use (specified without any attributes) outputs the selection
of entries that are appropriate for the page being published. But you
can use this tag for publishing custom modules, index templates and
widgets to select content in many different ways.

B<Attributes:>

=over 4

=item * lastn (optional)

Allows you to limit the number of entries output. This attribute
always implies selection of entries based on their 'authored' date, in
reverse chronological order.

    <mt:Entries lastn="5" sort_by="title" sort_order="ascend">

This would publish the 5 most recent entries, ordered by their titles.

=item * limit (optional)

Similar to the C<lastn> attribute, but limits output based on whichever
sort order is in use.

=item * sort_by (optional; default "authored_on")

Accepted values are: C<authored_on>, C<title>, C<ping_count>,
C<comment_count>, C<author_id>, C<excerpt>, C<status>, C<created_on>,
C<modified_on>, C<rate>, C<score> (both C<rate> and C<score> require a C<namespace> attribute to be present).

If you have the Professional Pack installed, with custom fields, you
may specify a custom field basename to sort the listing, by giving
a C<sort_by> value of C<field:I<basename>> (where 'basename' is the custom
field basename you wish to sort on).

=item * sort_order (optional)

Accepted values are 'ascend' and 'descend'. The default is the order
specified for publishing entries, set on the blog entry preferences
screen.

=item * field:I<basename>

Permits filtering entries based on a custom field defined (available
when the Commercial Pack is installed).

B<Example:>

    <mt:Entries field:special="1" sort_by="authored_on"
        sort_order="descend" limit="5">

This selects the last 5 entries that have a "special" custom field
(checkbox field) checked.

=item * namespace (optional)

The namespace attribute is used to specify which scoring namespace
to use when applying the C<sort_by="score"> attribute, or filtering
based on scoring (any of the C<min_*>, C<max_*> attributes require this).

The MT Community Pack provides a 'community_pack_recommend' namespace,
for instance, which can be used to select entries, sorting by number
of recommend/favorite votes that have been made.

=item * class_type (optional; default 'entry')

Accepted values are 'entry' and 'page'.

=item * offset (optional)

Accepted values are any non-zero positive integers, or the keyword
"auto" which is used under dynamic publishing to automatically
determine the offset based on the C<offset> query parameter for
the request.

=item * category or categories (optional)

This attribute allows you to filter the entries based on category
assignment. The simple case is to filter for a single category,
where the full category name is specified:

    <mt:Entries category="Featured">

If you have multiple categories with the same name, you can give
their parent category names to be more explicit:

    <mt:Entries category="News/Featured">

or

    <mt:Entries category="Projects/Featured">

You can also use 'AND', 'OR' and 'NOT' operators to include or
exclude categories:

    <mt:Entries categories="(Family OR Pets) AND Featured">

or

    <mt:Entries categories="NOT Family">

=item * include_subcategories (optional)

If this attribute is specified in conjunction with the category (or
categories) attribute, it will cause any entries assigned to subcategories
of the identified category/categories to be included as well.

=item * tag or tags (optional)

This attribute functions similarly to the C<category> attribute, but
filters based on tag assignments. It also supports the logical operators
described for category selection.

=item * author (optional)

Accepts an author's username to filter entry selection.

B<Example:>

    <mt:Entries author="Melody">

=item * id (optional)

If specified, selects a single entry matching the given entry ID.

    <mt:Entries id="10">

=item * min_score (optional)

=item * max_score (optional)

=item * min_rate (optional)

=item * max_rate (optional)

=item * min_count (optional)

=item * max_count (optional)

Allows filtering of entries based on score, rating or count. Each of
the attributes require the C<namespace> attribute.

=item * scored_by (optional)

Allows filtering of entries that were scored by a particular user,
specified by username. Requires the C<namespace> attribute.

=item * days (optional)

Limits the selection of entries to a specified number of days,
based on the current date. For instance, if you specify:

    <mt:Entries days="10">

only entries that were authored within the last 10 days will be
published.

=item * recently_commented_on (optional)

Selects the list of entries that have received published comments
recently. The value of this attribute is the number of days to use
to limit the selection. For instance:

    <mt:Entries recently_commented_on="10">

will select entries that received published comments within the last
10 days. The order of the entries is the date of the most recently
received comment.

=item * unique

If specified, this flag will cause MT to keep track of which entries
are being published for a given page. It will also prevent the publishing
of entries already published.

For example, if you wish to publish the last 3 entries that are
tagged "@featured", but wish to exclude these entries from the set
of entries that follow, you can do this:


    <mt:Entries tag="@featured" lastn="3">
        ...
    </mt:Entries>
    
    <mt:Entries lastn="7" unique="1">
        ...
    </mt:Entries>

The second Entries tag will exclude any entries that were output
from the first Entries tag.

=item * glue (optional)

Specifies a string that is output inbetween published entries.

B<Example:>

    <mt:Entries glue=","><$mt:EntryID$></mt:Entries>

outputs something like this:

    10,9,8,7,6,5,4,3,2,1

=back

=for tags multiblog, loop, scoring

=cut

sub _hdlr_entries {
    my ( $ctx, $args, $cond ) = @_;
    return $ctx->error(
        MT->translate(
            'sort_by="score" must be used in combination with namespace.')
        )
        if ( ( exists $args->{sort_by} )
        && ( 'score' eq $args->{sort_by} )
        && ( !exists $args->{namespace} ) );

    my $cfg      = $ctx->{config};
    my $at       = $ctx->{current_archive_type} || $ctx->{archive_type};
    my $archiver = MT->publisher->archiver($at);
    my $blog_id  = $ctx->stash('blog_id');
    my $blog     = $ctx->stash('blog');
    my ( @filters, %blog_terms, %blog_args, %terms, %args );

    # for the case that we want to use mt:Entries with mt-search
    # send to MT::Template::Search if searh results are found
    if ( $ctx->stash('results')
        && ( ( $args->{search_results} || 0 ) == 1 ) )
    {
        require MT::Template::Context::Search;
        return MT::Template::Context::Search::_hdlr_results( $ctx, $args,
            $cond );
    }

    $ctx->set_blog_load_context( $args, \%blog_terms, \%blog_args )
        or return $ctx->error( $ctx->errstr );
    %terms = %blog_terms;
    %args  = %blog_args;

    $args{joins} = [];

    my $class_type     = $args->{class_type} || 'entry';
    my $class          = MT->model($class_type);
    my $cat_class_type = $class->container_type();
    my $cat_class      = MT->model($cat_class_type);

    my %fields;
    foreach my $arg ( keys %$args ) {
        if ( $arg =~ m/^field:(.+)$/ ) {
            $fields{$1} = $args->{$arg};
        }
    }

    my $use_stash = 1;

    # For the stock Entries/Pages tags, clear any prepopulated
    # entries list (placed by archive publishing) if we're invoked
    # with any of the following attributes. A plugin tag may
    # prepopulate the entries stash and then invoke this handler
    # to permit further filtering of the entries.
    my $tag = lc $ctx->stash('tag');
    if ( ( $tag eq 'entries' ) || ( $tag eq 'pages' ) ) {
        foreach
            my $args_key ( 'category', 'categories', 'tag', 'tags', 'author' )
        {
            if ( exists( $args->{$args_key} ) ) {
                $use_stash = 0;
                last;
            }
        }
    }
    if ($use_stash) {
        foreach my $args_key (
            'id',                    'days',
            'recently_commented_on', 'include_subcategories',
            'include_blogs',         'exclude_blogs',
            'blog_ids',              'include_websites',
            'exclude_websites',      'site_ids',
            'include_sites',         'exclude_sites'
            )
        {
            if ( exists( $args->{$args_key} ) ) {
                $use_stash = 0;
                last;
            }
        }
    }
    if ( $use_stash && %fields ) {
        $use_stash = 0;
    }

    my $entries;
    if ($use_stash) {
        $entries = $ctx->stash('entries');
        if (  !$entries
            && $archiver
            && $archiver->group_based
            && !$archiver->contenttype_group_based )
        {
            $entries = $archiver->archive_group_entries( $ctx, %$args );
        }
    }
    if ( $entries && scalar @$entries ) {
        my $entry = @$entries[0];
        if ( !$entry->isa($class) ) {

            # class types do not match; we can't use stashed entries
            undef $entries;
        }
        elsif ( ( $tag eq 'entries' || $tag eq 'pages' )
            && $blog_id != $entry->blog_id )
        {

            # Blog ID do not match; we can't use stashed entries
            undef $entries;
        }
    }

    local $ctx->{__stash}{entries};

    # handle automatic offset based on 'offset' query parameter
    # in case we're invoked through mt-view.cgi or some other
    # app.
    if ( ( $args->{offset} || '' ) eq 'auto' ) {
        $args->{offset} = 0;
        if (   ( $args->{lastn} || $args->{limit} )
            && ( my $app = MT->instance ) )
        {
            if ( $app->isa('MT::App') ) {
                if ( my $offset = $app->param('offset') ) {
                    $args->{offset} = $offset;
                }
            }
        }
    }

    if ( ( $args->{limit} || '' ) eq 'auto' ) {
        my ( $days, $limit );
        my $blog = $ctx->stash('blog');
        if ( $blog && ( $days = $blog->days_on_index ) ) {
            my @ago = offset_time_list( time - 3600 * 24 * $days, $blog_id );
            my $ago = sprintf "%04d%02d%02d%02d%02d%02d",
                $ago[5] + 1900, $ago[4] + 1, @ago[ 3, 2, 1, 0 ];
            $terms{authored_on} = [$ago];
            $args{range_incl}{authored_on} = 1;
        }
        elsif ( $blog && ( $limit = $blog->entries_on_index ) ) {
            $args->{lastn} = $limit;
        }
        else {
            delete $args->{limit};
        }
    }
    elsif ( $args->{limit} && ( $args->{limit} > 0 ) ) {
        $args->{lastn} = $args->{limit};
    }

    $terms{status} = MT::Entry::RELEASE();

    if ( !$entries ) {
        my $cat
            = $ctx->{inside_mt_categories}
            ? $ctx->stash('category')
            : $ctx->stash('archive_category');
        if (   $cat
            && $cat->class eq $cat_class_type
            && !$cat->category_set_id )
        {
            $args->{category} ||= [ 'OR', [$cat] ];
        }
    }

    # kinds of <MTEntries> uses...
    #     * from an index template
    #     * from an archive context-- entries are prepopulated

    # Adds a category filter to the filters list.
    if ( my $category_arg = $args->{category} || $args->{categories} ) {
        my ( $cexpr, $cats );
        if ( ref $category_arg ) {
            my $is_and = ( shift @{$category_arg} ) eq 'AND';
            $cats  = [ @{ $category_arg->[0] } ];
            $cexpr = $ctx->compile_category_filter(
                undef, $cats,
                {   'and'    => $is_and,
                    children => $cat_class_type eq 'category'
                    ? ( $args->{include_subcategories} ? 1 : 0 )
                    : ( $args->{include_subfolders} ? 1 : 0 )
                }
            );
        }
        else {
            if (( $category_arg !~ m/\b(AND|OR|NOT)\b|[(|&]/i )
                && ((   $cat_class_type eq 'category'
                        && !$args->{include_subcategories}
                    )
                    || ( $cat_class_type ne 'category'
                        && !$args->{include_subfolders} )
                )
                )
            {
                my @cats
                    = $ctx->cat_path_to_category( $category_arg,
                    [ \%blog_terms, \%blog_args ],
                    $cat_class_type );
                if (@cats) {
                    $cats = \@cats;
                }
                $cexpr
                    = $ctx->compile_category_filter( $category_arg, $cats );
            }
            else {
                my @cats = $cat_class->load( \%blog_terms, \%blog_args );
                if (@cats) {
                    $cats = \@cats;
                }
                $cexpr = $ctx->compile_category_filter(
                    $category_arg,
                    $cats,
                    {   children => $cat_class_type eq 'category'
                        ? ( $args->{include_subcategories} ? 1 : 0 )
                        : ( $args->{include_subfolders} ? 1 : 0 )
                    }
                );
            }
        }
        if ($cexpr) {
            my %map;
            require MT::Placement;
            my @cat_ids = map { $_->id } @$cats;
            my $preloader = sub {
                my ($id) = @_;
                my @c_ids = MT::Placement->load(
                    { category_id => \@cat_ids,       entry_id    => $id },
                    { fetchonly   => ['category_id'], no_triggers => 1 }
                );
                my %map;
                $map{ $_->category_id } = 1 for @c_ids;
                \%map;
            };

            my $filter_only_by_join = 0;
            if ( !$entries ) {
                if ( $category_arg !~ m/\bNOT\b/i ) {
                    return MT::Template::Context::_hdlr_pass_tokens_else(@_)
                        unless @cat_ids;
                    push @{ $args{joins} }, MT::Placement->join_on(
                        'entry_id',
                        {   category_id => \@cat_ids,
                            %blog_terms
                        },
                        { %blog_args, unique => 1 }
                    );

                    # We can filter by "JOIN" statement for simple args. (single tag, "or" condition)
                    $filter_only_by_join = 1 if $category_arg !~ m/\b(AND|NOT)\b|\(|\)/i;
                }
            }
            unless ($filter_only_by_join) {
                push @filters, sub { $cexpr->( $preloader->( $_[0]->id ) ) };
            }
        }
        else {
            return $ctx->error(
                MT->translate(
                    "You have an error in your '[_2]' attribute: [_1]",
                    $category_arg, $cat_class_type
                )
            );
        }
    }

    # Adds a tag filter to the filters list.
    if ( my $tag_arg = $args->{tags} || $args->{tag} ) {
        my $status = $ctx->set_tag_filter_context({
            objects     => $entries,
            tag_arg     => $tag_arg,
            blog_terms  => \%blog_terms,
            blog_args   => \%blog_args,
            object_args => $entries ? undef : \%args,
            filters     => \@filters,
            datasource  => $class->datasource,
        });

        return $ctx->error( $ctx->errstr ) unless $status;
        return $ctx->_hdlr_pass_tokens_else($args, $cond) if $status eq 'no_matching_tags';
    }

    # Adds an author filter to the filters list.
    if ( my $author_name = $args->{author} ) {
        require MT::Author;
        my $author = MT::Author->load( { name => $author_name } )
            or return $ctx->error(
            MT->translate( "No such user '[_1]'", $author_name ) );
        if ($entries) {
            push @filters, sub { $_[0]->author_id == $author->id };
        }
        else {
            $terms{author_id} = $author->id;
        }
    }

    if ( my $f = MT::Component->registry( "tags", "filters", "Entries" ) ) {
        foreach my $set (@$f) {
            foreach my $fkey ( keys %$set ) {
                if ( exists $args->{$fkey} ) {
                    my $h = $set->{$fkey}{code}
                        ||= MT->handler_to_coderef( $set->{$fkey}{handler} );
                    next unless ref($h) eq 'CODE';

                    local $ctx->{filters} = \@filters;
                    local $ctx->{terms}   = \%terms;
                    local $ctx->{args}    = \%args;
                    $h->( $ctx, $args, $cond );
                }
            }
        }
    }

    # Adds an ID filter to the filter list.
    if (   ( my $target_id = $args->{id} )
        && ( ref( $args->{id} ) || ( $args->{id} =~ m/^\d+$/ ) ) )
    {
        if ($entries) {
            if ( ref $target_id eq 'ARRAY' ) {
                my %ids = map { $_ => 1 } @$target_id;
                push @filters, sub { exists $ids{ $_[0]->id } };
            }
            else {
                push @filters, sub { $_[0]->id == $target_id };
            }
        }
        else {
            $terms{id} = $target_id;
        }
    }

    if ( $args->{namespace} ) {
        my $namespace = $args->{namespace};

        my $need_join = 0;
        for my $f (
            qw{ min_score max_score min_rate max_rate min_count max_count scored_by }
            )
        {
            if ( $args->{$f} ) {
                $need_join = 1;
                last;
            }
        }
        if ($need_join) {
            my $scored_by = $args->{scored_by};
            if ($scored_by) {
                require MT::Author;
                my $author = MT::Author->load( { name => $scored_by } )
                    or return $ctx->error(
                    MT->translate( "No such user '[_1]'", $scored_by ) );
                $scored_by = $author;
            }

            push @{ $args{joins} }, MT->model('objectscore')->join_on(
                undef,
                {   object_id => \'=entry_id',
                    object_ds => 'entry',
                    namespace => $namespace,
                    (   !$entries && $scored_by
                        ? ( author_id => $scored_by->id )
                        : ()
                    ),
                },
                { unique => 1, }
            );
            if ( $entries && $scored_by ) {
                push @filters,
                    sub { $_[0]->get_score( $namespace, $scored_by ) };
            }
        }

        # Adds a rate or score filter to the filter list.
        if ( $args->{min_score} ) {
            push @filters,
                sub { $_[0]->score_for($namespace) >= $args->{min_score}; };
        }
        if ( $args->{max_score} ) {
            push @filters,
                sub { $_[0]->score_for($namespace) <= $args->{max_score}; };
        }
        if ( $args->{min_rate} ) {
            push @filters,
                sub { $_[0]->score_avg($namespace) >= $args->{min_rate}; };
        }
        if ( $args->{max_rate} ) {
            push @filters,
                sub { $_[0]->score_avg($namespace) <= $args->{max_rate}; };
        }
        if ( $args->{min_count} ) {
            push @filters,
                sub { $_[0]->vote_for($namespace) >= $args->{min_count}; };
        }
        if ( $args->{max_count} ) {
            push @filters,
                sub { $_[0]->vote_for($namespace) <= $args->{max_count}; };
        }
    }

    # Adds an count of comments filter to the filter list.
    if ( exists $args->{min_comment} && exists $args->{max_comment} ) {
        $terms{comment_count}
            = { 'between' =>
                [ int( $args->{min_comment} ), int( $args->{max_comment} ) ]
            };
    }
    elsif ( exists $args->{min_comment} ) {
        $terms{comment_count} = { '>=' => int( $args->{min_comment} ) };
    }
    elsif ( exists $args->{max_comment} ) {
        $terms{comment_count} = { '<=' => int( $args->{max_comment} ) };
    }

    my $published = $ctx->{__stash}{entry_ids_published} ||= {};
    if ( $args->{unique} ) {
        push @filters, sub { !exists $published->{ $_[0]->id } }
    }

    my $namespace        = $args->{namespace};
    my $no_resort        = 0;
    my $post_sort_limit  = 0;
    my $post_sort_offset = 0;
    my @entries;
    if ( !$entries ) {
        my ( $start, $end )
            = ( $ctx->{current_timestamp}, $ctx->{current_timestamp_end} );
        if ((   !$archiver || ( !$archiver->contenttype_based
                    && !$archiver->contenttype_group_based )
            )
            && $start
            && $end
            )
        {
            $terms{authored_on} = [ $start, $end ];
            $args{range_incl}{authored_on} = 1;
        }
        if ( my $days = $args->{days} ) {
            my @ago = offset_time_list( time - 3600 * 24 * $days, $blog_id );
            my $ago = sprintf "%04d%02d%02d%02d%02d%02d",
                $ago[5] + 1900, $ago[4] + 1, @ago[ 3, 2, 1, 0 ];
            $terms{authored_on} = [$ago];
            $args{range_incl}{authored_on} = 1;
        }
        else {

            # Check attributes
            my $found_valid_args = 0;
            foreach my $valid_key (
                'lastn',     'category', 'categories', 'tag',
                'tags',      'author',   'days',       'min_score',
                'max_score', 'min_rate', 'max_rate',   'min_count',
                'max_count'
                )
            {
                if ( exists( $args->{$valid_key} ) ) {
                    $found_valid_args = 1;
                    last;
                }
            }

            if ( !$found_valid_args ) {

                # Uses weblog settings
                if ( my $days = $blog ? $blog->days_on_index : 10 ) {
                    my @ago = offset_time_list( time - 3600 * 24 * $days,
                        $blog_id );
                    my $ago = sprintf "%04d%02d%02d%02d%02d%02d",
                        $ago[5] + 1900, $ago[4] + 1, @ago[ 3, 2, 1, 0 ];
                    $terms{authored_on} = [$ago];
                    $args{range_incl}{authored_on} = 1;
                }
                elsif ( my $limit = $blog ? $blog->entries_on_index : 10 ) {
                    $args->{lastn} = $limit;
                }
            }
        }

        # Adds class_type
        $terms{class} = $class_type;

        $args{'sort'} = 'authored_on';
        if ( $args->{sort_by} ) {
            $args->{sort_by} =~ s/:/./;    # for meta:name => meta.name
            $args->{sort_by} = 'ping_count'
                if $args->{sort_by} eq 'trackback_count';
            if ( $class->is_meta_column( $args->{sort_by} ) ) {
                $post_sort_limit  = delete( $args->{limit} )  || 0;
                $post_sort_offset = delete( $args->{offset} ) || 0;
                if ( $post_sort_limit || $post_sort_offset ) {
                    delete $args->{lastn};
                }
                $no_resort = 0;
            }
            elsif ( $class->has_column( $args->{sort_by} ) ) {
                $args{sort} = $args->{sort_by};
                $no_resort = 1;
            }
            elsif (
                $args->{limit}
                && (   'score' eq $args->{sort_by}
                    || 'rate' eq $args->{sort_by} )
                )
            {
                $post_sort_limit  = delete( $args->{limit} )  || 0;
                $post_sort_offset = delete( $args->{offset} ) || 0;
                if ( $post_sort_limit || $post_sort_offset ) {
                    delete $args->{lastn};
                }
                $no_resort = 0;
            }
        }

        if (%fields) {

            # specifies we need a join with entry_meta;
            # for now, we support one join
            my ( $col, $val ) = %fields;
            my $type = MT::Meta->metadata_by_name( $class, 'field.' . $col );
            push @{ $args{joins} }, [
                $class->meta_pkg,
                undef,
                {   type          => 'field.' . $col,
                    $type->{type} => $val,
                    'entry_id'    => \'= entry_id'
                }
            ];
        }

        if ( !@filters ) {
            if ( ( my $last = $args->{lastn} ) && ( !exists $args->{limit} ) )
            {
                $args{sort} = [
                    { column => 'authored_on', desc => 'DESC' },
                    { column => 'id',          desc => 'DESC' },
                ];
                $args{limit} = $last;
                $no_resort = 0 if $args->{sort_by};
            }
            else {
                if ( $args{sort} eq 'authored_on' ) {
                    my $dir = $args->{sort_order} || 'descend';
                    $dir = ( 'descend' eq $dir ) ? "DESC" : "ASC";
                    $args{sort} = [
                        { column => 'authored_on', desc => $dir },
                        { column => 'id',          desc => $dir },
                    ];
                }
                else {
                    $args{direction} = $args->{sort_order} || 'descend';
                }
                $no_resort = 1 unless $args->{sort_by};
                if (   ( my $last = $args->{lastn} )
                    && ( exists $args->{limit} ) )
                {
                    $args{limit} = $last;
                }
            }
            $args{offset} = $args->{offset} if $args->{offset};

            if ( $args->{recently_commented_on} ) {
                my $entries_iter
                    = _rco_entries_iter( \%terms, \%args, \%blog_terms,
                    \%blog_args );
                my $limit = $args->{recently_commented_on};
                while ( my $e = $entries_iter->() ) {
                    push @entries, $e;
                    last unless --$limit;
                }
                $no_resort = $args->{sort_order} || $args->{sort_by} ? 0 : 1;
            }
            else {
                @entries = $class->load( \%terms, \%args );
            }
        }
        else {
            if ( ( $args->{lastn} ) && ( !exists $args->{limit} ) ) {
                $args{direction} = 'descend';
                $args{sort}      = 'authored_on';
                $no_resort = 0 if $args->{sort_by};
            }
            else {
                $args{direction} = $args->{sort_order} || 'descend';
                $no_resort = 1 unless $args->{sort_by};
            }
            my $iter;
            if ( $args->{recently_commented_on} ) {
                $args->{lastn} = $args->{recently_commented_on};
                $iter = _rco_entries_iter( \%terms, \%args, \%blog_terms,
                    \%blog_args );
                $no_resort = $args->{sort_order} || $args->{sort_by} ? 0 : 1;
            }
            else {
                $iter = $class->load_iter( \%terms, \%args );
            }
            my $i   = 0;
            my $j   = 0;
            my $off = $args->{offset} || 0;
            my $n   = $args->{lastn};
        ENTRY: while ( my $e = $iter->() ) {
                for (@filters) {
                    next ENTRY unless $_->($e);
                }
                next if $off && $j++ < $off;
                push @entries, $e;
                $i++;
                $iter->end, last if $n && $i >= $n;
            }
        }
    }
    else {

        # Don't resort a predefined list that's not in a published archive
        # page when we didn't request sorting.
        if ( $args->{sort_by} || $args->{sort_order} || $ctx->{archive_type} )
        {
            my $so
                = $args->{sort_order}
                || ( $blog ? $blog->sort_order_posts : undef )
                || '';
            my $col = $args->{sort_by} || 'authored_on';
            if ( $col ne 'score' ) {
                if ( my $def = $class->column_def($col) ) {
                    if ( $def->{type} =~ m/^integer|float$/ ) {
                        @$entries
                            = $so eq 'ascend'
                            ? sort { $a->$col() <=> $b->$col() } @$entries
                            : sort { $b->$col() <=> $a->$col() } @$entries;
                    }
                    else {
                        @$entries
                            = $so eq 'ascend'
                            ? sort { $a->$col() cmp $b->$col() } @$entries
                            : sort { $b->$col() cmp $a->$col() } @$entries;
                    }
                    $no_resort = 1;
                }
                else {
                    $col =~ s/(^field):(.*)/$1.$2/ig;
                    if ( $class->is_meta_column($col) ) {
                        my $type = MT::Meta->metadata_by_name( $class, $col );
                        no warnings;
                        if ( $type->{type} =~ m/integer|float/ ) {
                            @$entries
                                = $so eq 'ascend'
                                ? sort { $a->$col() <=> $b->$col() }
                                @$entries
                                : sort { $b->$col() <=> $a->$col() }
                                @$entries;
                        }
                        else {
                            @$entries
                                = $so eq 'ascend'
                                ? sort { $a->$col() cmp $b->$col() }
                                @$entries
                                : sort { $b->$col() cmp $a->$col() }
                                @$entries;
                        }
                        $no_resort = 1;
                    }
                }
            }
        }
        else {
            $no_resort = 1;
        }

        if (@filters) {
            my $i   = 0;
            my $j   = 0;
            my $off = $args->{offset} || 0;
            my $n   = $args->{lastn};
        ENTRY2: foreach my $e (@$entries) {
                for (@filters) {
                    next ENTRY2 unless $_->($e);
                }
                next if $off && $j++ < $off;
                push @entries, $e;
                $i++;
                last if $n && $i >= $n;
            }
        }
        else {
            my $offset;
            if ( $offset = $args->{offset} ) {
                if ( $offset < scalar @$entries ) {
                    @entries = @$entries[ $offset .. $#$entries ];
                }
                else {
                    @entries = ();
                }
            }
            else {
                @entries = @$entries;
            }
            if ( my $last = $args->{lastn} ) {
                if ( scalar @entries > $last ) {
                    @entries = @entries[ 0 .. $last - 1 ];
                }
            }
        }
    }

    # $entries were on the stash or were just loaded
    # based on a start/end range.
    my $res     = '';
    my $tok     = $ctx->stash('tokens');
    my $builder = $ctx->stash('builder');
    if ( !$no_resort && ( scalar @entries ) ) {
        my $col = $args->{sort_by} || 'authored_on';
        if ( 'score' eq $col ) {
            my $so = $args->{sort_order} || '';
            my %e = map { $_->id => $_ } @entries;
            my @eid = keys %e;
            require MT::ObjectScore;
            my $scores = MT::ObjectScore->sum_group_by(
                {   'object_ds' => $class_type,
                    'namespace' => $namespace,
                    object_id   => \@eid
                },
                {   'sum' => 'score',
                    group => ['object_id'],
                    $so eq 'ascend'
                    ? ( direction => 'ascend' )
                    : ( direction => 'descend' ),
                }
            );
            my @tmp;
            my $i = 0;
            while ( my ( $score, $object_id ) = $scores->() ) {
                $i++, next if $post_sort_offset && $i < $post_sort_offset;
                push @tmp, delete $e{$object_id} if exists $e{$object_id};
                $scores->end, last unless %e;
                $i++;
                $scores->end, last
                    if $post_sort_limit
                    && ( scalar @tmp ) >= $post_sort_limit;
            }

            if ( !$post_sort_limit || ( scalar @tmp ) < $post_sort_limit ) {
                foreach ( values %e ) {
                    if ( $so eq 'ascend' ) {
                        unshift @tmp, $_;
                    }
                    else {
                        push @tmp, $_;
                    }
                    last
                        if $post_sort_limit
                        && ( scalar @tmp ) >= $post_sort_limit;
                }
            }
            @entries = @tmp;
        }
        elsif ( 'rate' eq $col ) {
            my $so = $args->{sort_order} || '';
            my %e = map { $_->id => $_ } @entries;
            my @eid = keys %e;
            require MT::ObjectScore;
            my $scores = MT::ObjectScore->avg_group_by(
                {   'object_ds' => $class_type,
                    'namespace' => $namespace,
                    object_id   => \@eid
                },
                {   'avg' => 'score',
                    group => ['object_id'],
                    $so eq 'ascend'
                    ? ( direction => 'ascend' )
                    : ( direction => 'descend' ),
                }
            );
            my @tmp;
            my $i = 0;
            while ( my ( $score, $object_id ) = $scores->() ) {
                $i++, next if $post_sort_offset && $i < $post_sort_offset;
                push @tmp, delete $e{$object_id} if exists $e{$object_id};
                $scores->end, last unless %e;
                $i++;
                $scores->end, last
                    if $post_sort_limit
                    && ( scalar @tmp ) >= $post_sort_limit;
            }
            if ( !$post_sort_limit || ( scalar @tmp ) < $post_sort_limit ) {
                foreach ( values %e ) {
                    if ( $so eq 'ascend' ) {
                        unshift @tmp, $_;
                    }
                    else {
                        push @tmp, $_;
                    }
                    last
                        if $post_sort_limit
                        && ( scalar @tmp ) >= $post_sort_limit;
                }
            }
            @entries = @tmp;
        }
        elsif ( $col =~ m/^field.(.*)/ig ) {
            my $so = $args->{sort_order} || 'descend';
            if ( $class->is_meta_column($col) ) {
                my $type = MT::Meta->metadata_by_name( $class, $col );
                no warnings;
                if ( $type->{type} =~ m/integer|float/ ) {
                    @entries
                        = $so eq 'ascend'
                        ? sort { $a->$col() <=> $b->$col() } @entries
                        : sort { $b->$col() <=> $a->$col() } @entries;
                }
                else {
                    @entries
                        = $so eq 'ascend'
                        ? sort { $a->$col() cmp $b->$col() } @entries
                        : sort { $b->$col() cmp $a->$col() } @entries;
                }
            }
            if ($post_sort_limit) {
                @entries = splice @entries, $post_sort_offset,
                    $post_sort_limit;
            }
            elsif ($post_sort_offset) {
                splice @entries, 0, $post_sort_offset;

            }
        }
        else {
            my $so
                = $args->{sort_order}
                || ( $blog ? $blog->sort_order_posts : 'descend' )
                || '';
            $so = $so eq 'ascend' ? 1 : -1;
            my $type;
            if ( my $def = $class->column_def($col) ) {
                $type = $def->{type};
            }
            elsif ( $class->is_meta_column($col) ) {
                $type = MT::Meta->metadata_by_name( $class, $col );
            }
            my $func;
            no warnings;
            if ( $type and $type =~ m/^integer|float$/ ) {
                $func = sub { $so * ( $a->$col() <=> $b->$col() ) };
            }
            elsif ( $col eq 'authored_on' ) {
                $func = sub {
                    $so
                        * (    ( $a->$col() cmp $b->$col() )
                            || ( $a->id() cmp $b->id() ) );
                };
            }
            else {
                $func = sub { $so * ( $a->$col() cmp $b->$col() ) };
            }
            if ($func) {
                @entries = sort $func @entries;
            }
        }
    }
    my ( $last_day, $next_day ) = ('00000000') x 2;
    my $i = 0;
    local $ctx->{__stash}{entries}
        = ( @entries && defined $entries[0] ) ? \@entries : undef;
    my $glue = $args->{glue};
    my $vars = $ctx->{__stash}{vars} ||= {};
    MT::Meta::Proxy->bulk_load_meta_objects( \@entries );
    for my $e (@entries) {
        local $vars->{__first__}    = !$i;
        local $vars->{__last__}     = !defined $entries[ $i + 1 ];
        local $vars->{__odd__}      = ( $i % 2 ) == 0;            # 0-based $i
        local $vars->{__even__}     = ( $i % 2 ) == 1;
        local $vars->{__counter__}  = $i + 1;
        local $ctx->{__stash}{blog} = $e->blog;
        local $ctx->{__stash}{blog_id}       = $e->blog_id;
        local $ctx->{__stash}{entry}         = $e;
        local $ctx->{current_timestamp}      = $e->authored_on;
        local $ctx->{modification_timestamp} = $e->modified_on;
        my $this_day = substr( ( $e->authored_on || '' ), 0, 8 );
        my $next_day = $this_day;
        my $footer   = 0;

        if ( defined $entries[ $i + 1 ] ) {
            $next_day
                = substr( ( $entries[ $i + 1 ]->authored_on || '' ), 0, 8 );
            $footer = $this_day ne $next_day;
        }
        else { $footer++ }
        my $allow_comments = 0;
        $published->{ $e->id }++;
        my $out = $builder->build(
            $ctx, $tok,
            {   %$cond,
                DateHeader    => ( $this_day ne $last_day ),
                DateFooter    => $footer,
                EntriesHeader => !$i,
                EntriesFooter => !defined $entries[ $i + 1 ],
                PagesHeader   => !$i,
                PagesFooter   => !defined $entries[ $i + 1 ],
            }
        );
        return $ctx->error( $builder->errstr ) unless defined $out;
        $last_day = $this_day;
        $res .= $glue if defined $glue && $i && length($res) && length($out);
        $res .= $out;
        $i++;
    }
    if ( !@entries ) {
        return MT::Template::Context::_hdlr_pass_tokens_else(@_);
    }

    $res;
}

###########################################################################

=head2 EntriesHeader

The contents of this container tag will be displayed when the first
entry listed by a L<Entries> tag is reached.

=for tags entries

=cut

###########################################################################

=head2 EntriesFooter

The contents of this container tag will be displayed when the last
entry listed by a L<Entries> tag is reached.

=for tags entries

=cut

###########################################################################

=head2 EntryPrevious

A block tag providing a context for the entry immediately preceding the
current entry in context (in terms of authored date).

=cut

sub _hdlr_entry_previous {
    _hdlr_entry_nextprev( 'previous', @_ );
}

###########################################################################

=head2 EntryNext

A block tag providing a context for the entry immediately following the
current entry in context (in terms of authored date).

=cut

sub _hdlr_entry_next {
    _hdlr_entry_nextprev( 'next', @_ );
}

sub _hdlr_entry_nextprev {
    my ( $meth, $ctx, $args, $cond ) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error();
    my $terms = { status => MT::Entry::RELEASE() };
    $terms->{by_author} = 1 if $args->{by_author};
    $terms->{by_category} = 1 if $args->{by_category} || $args->{by_folder};
    my $entry = $e->$meth($terms);
    my $res   = '';
    if ($entry) {
        my $builder = $ctx->stash('builder');
        local $ctx->{__stash}->{entry} = $entry;
        local $ctx->{current_timestamp} = $entry->authored_on;
        my $out = $builder->build( $ctx, $ctx->stash('tokens'), $cond );
        return $ctx->error( $builder->errstr ) unless defined $out;
        $res .= $out;
    }
    $res;
}

###########################################################################

=head2 DateHeader

A container tag whose contents will be displayed if the entry in context
was posted on a new day in the list.

B<Example:>

    <mt:Entries>
        <mt:DateHeader>
            <h2><$mt:EntryDate format="%A, %B %e, %Y"$></h2>
        </mt:DateHeader>
        <!-- display entry here -->
    </mt:Entries>

=for tags entries

=cut

###########################################################################

=head2 DateFooter

A container tag whose contents will be displayed if the entry in context
is the last entry in the group of entries for a given day.

B<Example:>

    <mt:Entries>
        <!-- display entry here -->
        <mt:DateFooter>
            <hr />
        </mt:DateFooter>
    </mt:Entries>

=for tags entries

=cut

###########################################################################

=head2 EntryIfExtended

Conditional tag that is positive when content is in the extended text
field of the current entry in context.

=cut

sub _hdlr_entry_if_extended {
    my ( $ctx, $args, $cond ) = @_;
    my $entry = $ctx->stash('entry');
    my $more  = '';
    if ($entry) {
        $more = $entry->text_more;
        $more = '' unless defined $more;
        $more =~ s!(^\s+|\s+$)!!g;
    }
    if ( $more ne '' ) {
        return 1;
    }
    else {
        return 0;
    }
}

###########################################################################

=head2 AuthorHasEntry

A conditional tag that is true when the author currently in context
has written one or more entries that have been published.

    <mt:AuthorHasEntry>
    <a href="<$mt:ArchiveLink type="Author">">Archive for this author</a>
    </mt:AuthorHasEntry>

=for tags authors, entries

=cut

sub _hdlr_author_has_entry {
    my ($ctx) = @_;
    my $author = $ctx->stash('author')
        or return $ctx->_no_author_error();

    my %terms;
    $terms{blog_id}   = $ctx->stash('blog_id');
    $terms{author_id} = $author->id;
    $terms{class}     = 'entry';
    $terms{status}    = MT::Entry::RELEASE();

    my $class = MT->model('entry');
    $class->exist( \%terms );
}

###########################################################################

=head2 EntriesCount

Returns the count of a list of entries that are currently in context
(ie: used in an archive template, or inside an L<Entries> tag). If no
entry list context exists, it will fallback to the list that would be
selected for a generic L<Entries> tag (respecting number of days or
entries configured to publish on the blog's main index template).

=for tags count

=cut

sub _hdlr_entries_count {
    my ( $ctx, $args, $cond ) = @_;
    my $e = $ctx->stash('entries');

    my $count;
    if ($e) {
        $count = scalar @$e;
    }
    else {
        my $class_type = $args->{class_type} || 'entry';
        my $class = MT->model($class_type);
        my $cat_class
            = MT->model( $class_type eq 'entry' ? 'category' : 'folder' );

        my ( %terms, %args );
        my $blog_id = $ctx->stash('blog_id');

        use MT::Entry;
        $terms{blog_id} = $blog_id;
        $terms{status}  = MT::Entry::RELEASE();
        my ( $days, $limit );
        my $blog = $ctx->stash('blog');
        if ( $blog && ( $days = $blog->days_on_index ) ) {
            my @ago = offset_time_list( time - 3600 * 24 * $days,
                $ctx->stash('blog_id') );
            my $ago = sprintf "%04d%02d%02d%02d%02d%02d",
                $ago[5] + 1900, $ago[4] + 1, @ago[ 3, 2, 1, 0 ];
            $terms{authored_on} = [$ago];
            $args{range_incl}{authored_on} = 1;
        }
        elsif ( $blog && ( $limit = $blog->entries_on_index ) ) {
            $args->{lastn} = $limit;
        }
        $args{'sort'} = 'authored_on';
        $args{direction} = 'descend';

        my $iter = $class->load_iter( \%terms, \%args );
        my $i    = 0;
        my $last = $args->{lastn};
        while ( my $entry = $iter->() ) {
            if ( $last && $last <= $i ) {
                return $i;
            }
            $i++;
        }
        $count = $i;
    }
    return $ctx->count_format( $count, $args );
}

###########################################################################

=head2 EntryID

Ouptuts the numeric ID for the current entry in context.

B<Attributes:>

=over 4

=item * pad (optional; default "0")

Adds leading zeros to create a 6 character string. The default is 0 (false). This is equivalent to using the C<zero_pad> global filter with a value of 6.

=back

=cut

sub _hdlr_entry_id {
    my ( $ctx, $args ) = @_;
    my $e = $ctx->stash('entry');
    if ( !$e && $ctx->stash('content') ) {
        return $ctx->invoke_handler( 'contentid', $args );
    }
    if ( !$e ) {
        return $ctx->_no_entry_error();
    }
    return $args && $args->{pad} ? ( sprintf "%06d", $e->id ) : $e->id;
}

###########################################################################

=head2 EntryTitle

Outputs the title of the current entry in context.

B<Attributes:>

=over 4

=item * generate (optional)

If specified, will draw content from the "main" text field of
the entry if the title is empty.

=back

=cut

sub _hdlr_entry_title {
    my ( $ctx, $args ) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error();
    my $title = defined $e->title ? $e->title : '';
    $title = first_n_text( $e->text, const('LENGTH_ENTRY_TITLE_FROM_TEXT') )
        if !$title && $args->{generate};
    return $title;
}

###########################################################################

=head2 EntryStatus

Intended for application template use only. Displays the status of the
entry in context. This will output one of "Draft", "Publish", "Review"
or "Future".

=cut

sub _hdlr_entry_status {
    my ($ctx) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error();
    return MT::Entry::status_text( $e->status );
}

###########################################################################

=head2 EntryFlag

Used to output any of the status fields for the current entry in
context.

B<Attributes:>

=over 4

=item * flag (required)

Accepts one of: 'allow_pings', 'allow_comments'.

=back

=cut

sub _hdlr_entry_flag {
    my ( $ctx, $args ) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error();
    my $flag = lc $args->{flag}
        or return $ctx->error(
        MT->translate('You used <$MTEntryFlag$> without a flag.') );
    $e->has_column($flag)
        or return $ctx->error(
        MT->translate(
            "You have an error in your '[_2]' attribute: [_1]", $flag,
            'flag'
        )
        );
    my $v = $e->$flag();
    ## The logic here: when we added the convert_breaks flag, we wanted it
    ## to default to checked, because we added it in 2.0, and people had
    ## previously been using the global convert_paras setting, so we needed
    ## that to be used if it wasn't defined. So that's the reason for the
    ## second test (else) (should we be looking at blog->convert_paras?).
    ## When we added allow_pings, we only want this to be applied if
    ## explicitly checked.
    if ( $flag eq 'allow_pings' || $flag eq 'allow_comments' ) {
        return defined $v ? $v : 0;
    }
    else {
        return defined $v ? $v : 1;
    }
}

###########################################################################

=head2 EntryBody

Outputs the "main" text of the current entry in context.

B<Attributes:>

=over 4

=item * convert_breaks (optional; default "1")

Accepted values are '0' and '1'. Typically, this attribute is
used to disable (with a value of '0') the processing of the entry
text based on the text formatting option for the entry.

=item * words (optional)

Accepts any positive integer to limit the number of words
that are output.

=back

=cut

sub _hdlr_entry_body {
    my ( $ctx, $args ) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error();
    my $text = $e->text;
    $text = '' unless defined $text;

    # Strip the mt:asset-id attribute from any span tags...
    if ( $text =~ m/\smt:asset-id="\d+"/ ) {
        $text = asset_cleanup($text);
    }

    my $blog = $ctx->stash('blog');
    my $convert_breaks
        = exists $args->{convert_breaks} ? $args->{convert_breaks}
        : defined $e->convert_breaks     ? $e->convert_breaks
        : ( $blog ? $blog->convert_paras : '__default__' );
    if ($convert_breaks) {
        my $filters = $e->text_filters;
        push @$filters, '__default__' unless @$filters;
        $text = MT->apply_text_filters( $text, $filters, $ctx );
    }
    return first_n_text( $text, $args->{words} ) if exists $args->{words};

    return $text;
}

###########################################################################

=head2 EntryMore

Outputs the "extended" text of the current entry in context. Refer to the
L<EntryBody> tag for supported attributes.

=cut

sub _hdlr_entry_more {
    my ( $ctx, $args ) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error();
    my $text = $e->text_more;
    $text = '' unless defined $text;

    # Strip the mt:asset-id attribute from any span tags...
    if ( $text =~ m/\smt:asset-id="\d+"/ ) {
        $text = asset_cleanup($text);
    }

    my $blog = $ctx->stash('blog');
    my $convert_breaks
        = exists $args->{convert_breaks} ? $args->{convert_breaks}
        : defined $e->convert_breaks     ? $e->convert_breaks
        : ( $blog ? $blog->convert_paras : '__default__' );
    if ($convert_breaks) {
        my $filters = $e->text_filters;
        push @$filters, '__default__' unless @$filters;
        $text = MT->apply_text_filters( $text, $filters, $ctx );
    }
    return first_n_text( $text, $args->{words} ) if exists $args->{words};

    return $text;
}

###########################################################################

=head2 EntryExcerpt

Ouputs the value of the excerpt field of the current entry in context.
If the excerpt field is empty, it will draw from the main text of the
entry to generate an excerpt.

B<Attributes:>

=over 4

=item * no_generate (optional)

If the excerpt field is empty, this flag will prevent the generation
of an excerpt using the main text of the entry.

=item * words (optional; default "40")

Controls the length of the auto-generated entry excerpt. Does B<not>
limit the content when the excerpt field contains content.

=item * convert_breaks (optional; default "0")

When set to '1', applies the text formatting filters on the excerpt
content.

=back

=cut

sub _hdlr_entry_excerpt {
    my ( $ctx, $args ) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error();
    if ( my $excerpt = $e->excerpt ) {
        return $excerpt unless $args->{convert_breaks};
        my @filters = ('__default__');
        return MT->apply_text_filters( $excerpt, \@filters, $ctx );
    }
    elsif ( $args->{no_generate} ) {
        return '';
    }
    my $blog = $ctx->stash('blog');
    my $words
        = $ctx->var('search_results') ? MT->config->SearchExcerptWords
        : $args->{words}              ? $args->{words}
        : $blog                       ? $blog->words_in_excerpt
        :                               40;
    my $excerpt = _hdlr_entry_body( $ctx, { words => $words, %$args } );
    return '' unless $excerpt;
    return $excerpt . '...';
}

###########################################################################

=head2 EntryKeywords

Outputs the value of the keywords field for the current entry in context.

=cut

sub _hdlr_entry_keywords {
    my ($ctx) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error();
    return defined $e->keywords ? $e->keywords : '';
}

###########################################################################

=head2 EntryLink

Outputs absolute URL pointing to an archive page related to the the current entry in context.

By default the tag will generate a URL to the "Preferred Archive" type specified in the blog's Publishing Settings (which is usually the Entry archive), but the link can be modified by specifying the desired archive type.

=head4 Attributes

=over 4

=item * archive_type (optional)

=item * type (optional, alias of archive_type)

Identifies the archive type to use when creating the link. Valid archive types are case sensitive:

=over 4

=item * Category

=item * Monthly

=item * Weekly

=item * Daily

=item * Individual

=item * Author

=item * Yearly

=item * Author-Daily

=item * Author-Weekly

=item * Author-Monthly

=item * Author-Yearly

=item * Category-Daily

=item * Category-Weekly

=item * Category-Monthly

=item * Category-Yearly

=back

=head4 Examples

Link to the main category archive of the entry in context:

    <a href="<$mt:EntryLink type="Category"$>"><$mt:EntryCategory$></a>

Link to the appropriate Monthly archive for the current entry (assuming
Monthly archives are published), you can use this:

    <a href="<$mt:EntryLink type="Monthly"$>"><$mt:EntryDate format="%B %Y"$> Archives</a>

Link to other entries by the current author (assuming Author archives are published):

    <a href="<$mt:EntryLink type="Author"$>"><$mt:EntryAuthorDisplayName$></a>

=head4 Related Tags

=item * L<EntryPermalink>

=back

=for tags entry, function, template tag

=cut

sub _hdlr_entry_link {
    my ( $ctx, $args ) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error();
    my $blog = $ctx->stash('blog');
    my $arch = $blog->archive_url || '';
    $arch = $blog->site_url if $e->class eq 'page';
    $arch .= '/' unless $arch =~ m!/$!;

    my $at = $args->{type} || $args->{archive_type};
    if ($at) {
        return $ctx->error(
            MT->translate(
                "You used an [_1] tag for linking into '[_2]' archives, but that archive type is not published.",
                '<$MTEntryLink$>',
                $at
            )
        ) unless $blog->has_archive_type($at);
    }
    my $archive_filename = $e->archive_file( $at ? $at : () );
    if ($archive_filename) {
        my $link = $arch . $archive_filename;
        $link = MT::Util::strip_index( $link, $blog )
            unless $args->{with_index};
        $link;
    }
    else { return "" }
}

###########################################################################

=head2 EntryBasename

Outputs the basename field for the current entry in context.

B<Attributes:>

=over 4

=item * separator (optional)

Accepts either "-" or "_". If unspecified, the raw basename value is
returned.

=back

=cut

sub _hdlr_entry_basename {
    my ( $ctx, $args ) = @_;
    my $e = $ctx->stash('entry');
    return $ctx->invoke_handler( 'contentidentifier', $args, '' )
        if !$e && $ctx->stash('content');
    return $ctx->_no_entry_error() unless $e;
    my $basename = $e->basename() || '';
    if ( my $sep = $args->{separator} ) {
        if ( $sep eq '-' ) {
            $basename =~ s/_/-/g;
        }
        elsif ( $sep eq '_' ) {
            $basename =~ s/-/_/g;
        }
    }
    return $basename;
}

###########################################################################

=head2 EntryAtomID

Outputs the unique Atom ID for the current entry in context.

=cut

sub _hdlr_entry_atom_id {
    my ( $ctx, $args, $cond ) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error();
    return
           $e->atom_id()
        || $e->make_atom_id()
        || $ctx->error(
        MT->translate( "Could not create atom id for entry [_1]", $e->id ) );
}

###########################################################################

=head2 EntryPermalink

An absolute URL pointing to the archive page containing this entry. An
anchor (#) is included if the permalink is not pointing to an Individual
Archive page.

Most of the time, you'll want to use this inside a hyperlink. So, inside
any L<Entries> loop, you can make a link to an entry like this:

    <a href="<$mt:EntryPermalink$>"><$mt:EntryTitle$></a>

B<Attributes:>

=over 4

=item * type or archive_type (optional)

Specifies an alternative archive type to use instead of the individual
archive.

=item * valid_html (optional; default "0")

When publishing entry permalinks for non-individual archive templates, an
anchor must be appended to the URL for the link to point to the
proper entry within that archive. If 'valid_html' is unspecified,
the anchor name is simply a number-- the ID of the entry. If specified,
an 'a' is prepended to the number so the anchor name is considered
valid HTML.

=item * with_index (optional; default "0")

If assigned, will retain any index filename at the end of the permalink.

=back

=cut

sub _hdlr_entry_permalink {
    my ( $ctx, $args ) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error();
    my $blog = $ctx->stash('blog');
    my $at = $args->{type} || $args->{archive_type};
    if ($at) {
        return $ctx->error(
            MT->translate(
                "You used an [_1] tag for linking into '[_2]' archives, but that archive type is not published.",
                '<$MTEntryPermalink$>',
                $at
            )
        ) unless $blog->has_archive_type($at);
    }
    my $link = $e->permalink( $args ? $at : undef,
        { valid_html => $args->{valid_html} } )
        or return $ctx->error( $e->errstr );
    $link = MT::Util::strip_index( $link, $blog ) unless $args->{with_index};
    $link;
}

###########################################################################

=head2 EntryClass

Pages and entries are technically very similar to one another. In fact
most, if not all, of the C<<mt:Entry*>> tags will work for publishing pages
and vice versa. Therefore, to more clearly differentiate within
templates between pages and entries the <mt:EntryClass> tag returns one of
two values: "page" or "entry" depending upon the current context you are
in.

B<Example:>

    <mt:If tag="EntryClass" eq="page">
        (we're publishing a page)
    <mt:Else>
        (we're publishing something else -- probably an entry)
    </mt:If>

=cut

sub _hdlr_entry_class {
    my ( $ctx, $args ) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error();
    $e->class;
}

###########################################################################

=head2 EntryClassLabel

Returns the localized name of the type of entry being published.
For English blogs, this is the word "Page" or "Entry".

B<Example:>

    <$mt:EntryClassLabel$>

=cut

sub _hdlr_entry_class_label {
    my ( $ctx, $args ) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error();
    $e->class_label;
}

###########################################################################

=head2 EntryAuthor

Outputs the username of the author for the current entry in context.
B<This tag is considered deprecated in favor of
L<EntryAuthorDisplayName>. It is not recommended to publish MT
usernames.>

=for tags deprecated

=cut

# FIXME: This should be a container tag providing an author
# context for the entry in context.
sub _hdlr_entry_author {
    my ($ctx) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error();
    my $a = $e->author;
    return $a ? $a->name || '' : '';
}

###########################################################################

=head2 EntryAuthorDisplayName, EntryModifiedAuthorDisplayName

Outputs the display name of the (last modified) author for the current entry in context.
If the author has not provided a display name for publishing, this tag
will output an empty string.

=cut

sub _hdlr_entry_author_display_name {
    my ($ctx) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error();
    my $author = $e->author;
    return $author ? $author->nickname || '' : '';
}

sub _hdlr_entry_modified_author_display_name {
    my ($ctx) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error();
    my $author = $e->modified_author;
    return $author ? $author->nickname || '' : '';
}

###########################################################################

=head2 EntryAuthorNickname

An alias of L<EntryAuthorDisplayName>. B<This tag is deprecated in
favor of L<EntryAuthorDisplayName>.>

=for tags deprecated

=cut

sub _hdlr_entry_author_nick {
    my ($ctx) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error();
    my $a = $e->author;
    return $a ? $a->nickname || '' : '';
}

###########################################################################

=head2 EntryAuthorUsername, EntryModifiedAuthorUsername

Outputs the username of the (last modified) author for the entry currently in context.
B<NOTE: it is not recommended to publish MT usernames.>

=cut

sub _hdlr_entry_author_username {
    my ($ctx) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error();
    my $author = $e->author;
    return $author ? $author->name || '' : '';
}

sub _hdlr_entry_modified_author_username {
    my ($ctx) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error();
    my $author = $e->modified_author;
    return $author ? $author->name || '' : '';
}

###########################################################################

=head2 EntryAuthorEmail, EntryModifiedAuthorEmail

Outputs the email address of the (last modified) author for the current entry in context.
B<NOTE: it is not recommended to publish e-mail addresses for MT users.>

B<Attributes:>

=over 4

=item * spam_protect (optional; default "0")

If specified, this will apply a light obfuscation of the email address,
by encoding any characters that will identify it as an email address
(C<:>, C<@>, and C<.>) into HTML entities.

=back

=cut

sub _hdlr_entry_author_email {
    my ( $ctx, $args ) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error();
    my $author = $e->author;
    return '' unless $author && defined $author->email;
    return $args
        && $args->{'spam_protect'} ? spam_protect( $author->email ) : $author->email;
}

sub _hdlr_entry_modified_author_email {
    my ( $ctx, $args ) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error();
    my $author = $e->modified_author;
    return '' unless $author && defined $author->email;
    return $args
        && $args->{'spam_protect'} ? spam_protect( $author->email ) : $author->email;
}

###########################################################################

=head2 EntryAuthorURL, EntryModifiedAuthorURL

Outputs the Website URL field from the (last modified) author's profile for the
current entry in context.

=cut

sub _hdlr_entry_author_url {
    my ( $ctx, $args ) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error();
    my $author = $e->author;
    return $author ? $author->url || "" : "";
}

sub _hdlr_entry_modified_author_url {
    my ( $ctx, $args ) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error();
    my $author = $e->modified_author;
    return $author ? $author->url || "" : "";
}

###########################################################################

=head2 EntryAuthorLink, EntryModifiedAuthorLink

Outputs a linked (last modified) author name suitable for publishing in the 'byline'
of an entry.

B<Attributes:>

=over 4

=item * new_window

If specified, the published link is given a C<target> attribute of '_blank'.

=item * show_email (optional; default "0")

If set, will allow publishing of an email address if the URL field
for the author is empty.

=item * spam_protect (optional)

If specified, this will apply a light obfuscation of any email address
published, by encoding any characters that will identify it as an email
address (C<:>, C<@>, and C<.>) into HTML entities.

=item * type (optional)

Accepted values: C<url>, C<email>, C<archive>. Note: an 'archive' type
requires publishing of "Author" archives.

=item * show_hcard (optional; default "0")

If present, adds additional CSS class names to the link tag published,
identifying the link as a url or email address depending on the type of
link published.

=back

=cut

sub _hdlr_entry_author_link {
    my ( $ctx, $args, $cond ) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error();
    my $author = $e->author;
    return '' unless $author;
    __hdlr_entry_author_link($ctx, $args, $cond, $author);
}

sub _hdlr_entry_modified_author_link {
    my ( $ctx, $args, $cond ) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error();
    my $author = $e->modified_author;
    return '' unless $author;
    __hdlr_entry_author_link($ctx, $args, $cond, $author);
}

sub __hdlr_entry_author_link {
    my ( $ctx, $args, $cond, $author ) = @_;

    my $type = $args->{type} || '';

    if ( $type && $type eq 'archive' ) {
        require MT::Author;
        if ( $author->type == MT::Author::AUTHOR() ) {
            local $ctx->{__stash}{author} = $author;
            local $ctx->{current_archive_type} = undef;
            if (my $link = $ctx->invoke_handler(
                    'archivelink', { type => 'Author' }, $cond
                )
                )
            {
                my $target = $args->{new_window} ? ' target="_blank"' : '';
                my $displayname
                    = encode_html( remove_html( $author->nickname || '' ) );
                return sprintf qq{<a href="%s"%s>%s</a>}, $link, $target,
                    $displayname;
            }
        }
    }

    return MT::Template::Tags::Common::hdlr_author_link( @_, $author );
}

###########################################################################

=head2 EntryAuthorID, EntryModifiedAuthorID

Outputs the numeric ID of the (last modified) author for the current entry in context.

=cut

sub _hdlr_entry_author_id {
    my ($ctx) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error();
    my $author = $e->author;
    return $author ? $author->id || '' : '';
}

sub _hdlr_entry_modified_author_id {
    my ($ctx) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error();
    my $author = $e->modified_author;
    return $author ? $author->id || '' : '';
}

###########################################################################

=head2 AuthorEntryCount

Returns the number of published entries associated with the author
currently in context.

=for tags authors

=cut

sub _hdlr_author_entry_count {
    my ( $ctx, $args, $cond ) = @_;
    my $author = $ctx->stash('author');
    unless ($author) {
        my $e = $ctx->stash('entry');
        $author = $e->author if $e;
    }
    return $ctx->_no_author_error() unless $author;

    my ( %terms, %args );
    my $class = MT->model('entry');
    $ctx->set_blog_load_context( $args, \%terms, \%args )
        or return $ctx->error( $ctx->errstr );
    $terms{author_id} = $author->id;
    $terms{status}    = MT::Entry::RELEASE();
    my $count = $class->count( \%terms, \%args );
    return $ctx->count_format( $count, $args );
}

###########################################################################

=head2 EntryDate

Outputs the 'authored' date of the current entry in context.
See the L<Date> tag for supported attributes.

=for tags date

=cut

sub _hdlr_entry_date {
    my ( $ctx, $args ) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error();
    $args->{ts} = $e->authored_on;
    return $ctx->build_date($args);
}

###########################################################################

=head2 EntryCreatedDate

Outputs the creation date of the current entry in context.
See the L<Date> tag for supported attributes.

=for tags date

=cut

sub _hdlr_entry_create_date {
    my ( $ctx, $args ) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error();
    $args->{ts} = $e->created_on;
    return $ctx->build_date($args);
}

###########################################################################

=head2 EntryModifiedDate

Outputs the modification date of the current entry in context.
See the L<Date> tag for supported attributes.

=for tags date

=cut

sub _hdlr_entry_mod_date {
    my ( $ctx, $args ) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error();
    $args->{ts} = $e->modified_on || $e->created_on;
    return $ctx->build_date($args);
}

###########################################################################

=head2 EntryBlogID

The numeric system ID of the blog that is parent to the entry currently
in context.

B<Example:>

    <$mt:EntryBlogID$>

=for tags entries, blogs

=cut

=head2 EntrySiteID

The numeric system ID of the site that is parent to the entry currently
in context.

B<Example:>

    <$mt:EntrySiteID$>

=for tags entries, sites

=cut

sub _hdlr_entry_blog_id {
    my ( $ctx, $args ) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error();
    return $args
        && $args->{pad} ? ( sprintf "%06d", $e->blog_id ) : $e->blog_id;
}

###########################################################################

=head2 EntryBlogName

Returns the blog name of the blog to which the entry in context belongs.
The blog name is set in the General Blog Settings.

B<Example:>

    <$mt:EntryBlogName$>

=for tags entries, blogs

=cut

=head2 EntrySiteName

Returns the site name of the site to which the entry in context belongs.
The site name is set in the General Site Settings.

B<Example:>

    <$mt:EntrySiteName$>

=for tags entries, sites

=cut

sub _hdlr_entry_blog_name {
    my ( $ctx, $args ) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error();
    my $b = MT::Blog->load( $e->blog_id )
        or return $ctx->error(
        MT->translate( 'Cannot load blog #[_1].', $e->blog_id ) );
    return $b->name;
}

###########################################################################

=head2 EntryBlogDescription

Returns the blog description of the blog to which the entry in context
belongs. The blog description is set in the General Blog Settings.

B<Example:>

    <$mt:EntryBlogDescription$>

=for tags blogs, entries

=cut

=head2 EntrySiteDescription

Returns the site description of the site to which the entry in context
belongs. The site description is set in the General Site Settings.

B<Example:>

    <$mt:EntrySiteDescription$>

=for tags sites, entries

=cut

sub _hdlr_entry_blog_description {
    my ( $ctx, $args ) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error();
    my $b = MT::Blog->load( $e->blog_id )
        or return $ctx->error(
        MT->translate( 'Cannot load blog #[_1].', $e->blog_id ) );
    my $d = $b->description;
    return defined $d ? $d : '';
}

###########################################################################

=head2 EntryBlogURL

Returns the blog URL for the blog to which the entry in context belongs.

B<Example:>

    <$mt:EntryBlogURL$>

=for tags blogs, entries

=cut

=head2 EntrySiteURL

Returns the site URL for the site to which the entry in context belongs.

B<Example:>

    <$mt:EntrySiteURL$>

=for tags sites, entries

=cut

sub _hdlr_entry_blog_url {
    my ( $ctx, $args ) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error();
    my $b = MT::Blog->load( $e->blog_id )
        or return $ctx->error(
        MT->translate( 'Cannot load blog #[_1].', $e->blog_id ) );
    return $b->site_url;
}

###########################################################################

=head2 EntryEditLink

A link to edit the entry in context from the Movable Type CMS. This tag is
only recognized in system templates where an authenticated user is
logged-in.

B<Attributes:>

=over 4

=item * text (optional; default "Edit")

A phrase to use for the edit link.

=back

B<Example:>

    <$mt:EntryEditLink$>

=for tags search

=cut

sub _hdlr_entry_edit_link {
    my ( $ctx, $args ) = @_;
    my $user = $ctx->stash('user') or return '';
    my $entry = $ctx->stash('entry')
        or return $ctx->error(
        MT->translate(
            'You used an [_1] tag outside of the proper context.',
            '<$MTEntryEditLink$>'
        )
        );
    my $blog_id = $entry->blog_id;
    my $cfg     = MT->config;
    my $url     = $cfg->AdminCGIPath || $cfg->CGIPath;
    $url .= '/' unless $url =~ m!/$!;
    require MT::Permission;
    my $perms = MT::Permission->load(
        {   author_id => $user->id,
            blog_id   => $blog_id
        }
    );
    return '' unless $perms && $perms->can_edit_entry( $entry, $user );
    my $app = MT->instance;
    my $edit_text = $args->{text} || $app->translate("Edit");
    return sprintf q([<a href="%s%s%s">%s</a>]), $url, $cfg->AdminScript,
        $app->uri_params(
        'mode' => 'view',
        args   => {
            '_type' => $entry->class,
            id      => $entry->id,
            blog_id => $blog_id
        }
        ),
        $edit_text;
}

###########################################################################

=head2 WebsiteEntryCount

Returns the number of published entries associated with the website
currently in context.

=for tags multiblog, count, websites, entries

=cut

###########################################################################

=head2 BlogEntryCount

Returns the number of published entries associated with the blog
currently in context.

=for tags multiblog, count, blogs, entries

=cut

=head2 SiteEntryCount

Returns the number of published entries associated with the site
currently in context.

=for tags multiblog, count, sites, entries

=cut

sub _hdlr_blog_entry_count {
    my ( $ctx, $args, $cond ) = @_;
    my $class_type = $args->{class_type} || 'entry';
    my $class = MT->model($class_type);
    my ( %terms, %args );
    $ctx->set_blog_load_context( $args, \%terms, \%args )
        or return $ctx->error( $ctx->errstr );
    $terms{status} = MT::Entry::RELEASE();
    my $count = $class->count( \%terms, \%args );
    return $ctx->count_format( $count, $args );
}

1;
