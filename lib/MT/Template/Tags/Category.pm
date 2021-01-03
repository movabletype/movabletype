# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::Template::Tags::Category;

use strict;
use warnings;

use MT;
use MT::Category;
use MT::ContentStatus;
use MT::Util qw( archive_file_for dirify );
use MT::Promise qw( delay );

sub _load_sibling_categories {
    my ( $ctx, $cat, $class_type ) = @_;
    my $blog_id = $cat->blog_id;
    my $r       = MT::Request->instance;
    my $cats
        = $r->stash( '__cat_cache_'
            . $blog_id . '_'
            . $cat->parent . '_'
            . $cat->category_set_id );
    return $cats if $cats;

    my $class = MT->model($class_type);
    my @cats  = $class->load(
        {   blog_id         => $blog_id,
            parent          => $cat->parent,
            category_set_id => $cat->category_set_id,
        },
        { 'sort' => 'label', direction => 'ascend' },
    );
    $r->stash( '__cat_cache_' . $blog_id . '_' . $cat->parent, \@cats );
    \@cats;
}

sub _get_category_context {
    my ($ctx) = @_;

    my $tag = $ctx->stash('tag');

    # Get our hands on the category for the current context
    # Either in MTCategories, a Category Archive Template
    # Or the category for the current entry
    my $cat = $ctx->stash('category')
        || $ctx->stash('archive_category');

    if ( !defined $cat ) {

        # No category found so far, test the entry
        if ( $ctx->stash('entry') ) {
            $cat = $ctx->stash('entry')->category;

            # Return empty string if entry has no category
            # as the tag has been used in the correct context
            # but there is no category to work with
            return '' if ( !defined $cat );
        }
        elsif ( my $content_data = $ctx->stash('content') ) {
            my $map = $ctx->stash('template_map');
            unless ($map) {
                my $content_type_id = $content_data->content_type_id;
                my $at = $ctx->{archive_type} || 'ContentType';
                ($map) = MT->model('templatemap')->load(
                    { archive_type => $at, is_preferred => 1 },
                    {   join => MT->model('template')->join_on(
                            undef,
                            {   id => \'= templatemap_template_id',
                                content_type_id => $content_type_id,
                            },
                        )
                    }
                );
            }
            return '' if ( !$map || !$map->cat_field_id );
            my ($objectcategory) = MT->model('objectcategory')->load(
                {   object_ds  => 'content_data',
                    object_id  => $content_data->id,
                    cf_id      => $map->cat_field_id,
                    is_primary => 1,
                }
            );
            return '' unless ($objectcategory);
            $cat
                = MT->model('category')->load( $objectcategory->category_id );
        }
        else {
            return $ctx->error(
                MT->translate(
                    "MT[_1] must be used in a [_2] context",
                    $tag,
                    $tag =~ m/folder/ig ? 'folder' : 'category'
                )
            );
        }
    }
    return $cat;
}

sub _sort_cats {
    my ( $ctx, $sort_method, $sort_order, $cats ) = @_;
    my $tag = $ctx->stash('tag');

    # If sort_method is defined
    if ( defined $sort_method ) {
        my $package = $sort_method;

        # Check if it has a package name
        if ( $package =~ /::/ ) {

            # Extract the package name
            $package =~ s/::[^(::)]+$//;

            # Make sure it's loaded
            eval(qq(use $package;));
            if ( my $err = $@ ) {
                return $ctx->error(
                    MT->translate(
                        "Cannot find package [_1]: [_2]",
                        $package, $err
                    )
                );
            }
        }

        # Sort the categories based on sort_method
        if ( $sort_method =~ /::/ ) {
            eval("\@\$cats = sort $sort_method \@\$cats");
        }
        else {
            my $safe = eval { require Safe; new Safe; }
                or return $ctx->error(
                "Cannot evaluate sort_method [$sort_method]: Perl 'Safe' module is required."
                );
            my $vars = $ctx->{__stash}{vars};
            my $ns   = $safe->root;
            {
                no strict 'refs';
                foreach my $v ( keys %$vars ) {
                    ${ $ns . '::' . $v } = $vars->{$v};
                }
                ${ $ns . '::CATS' } = $cats;

                $safe->permit(qw/ sort /);
                {
                    local $SIG{__WARN__} = sub { };
                    $safe->reval("\@\$CATS = sort $sort_method \@\$CATS");
                }
                $cats = ${ $ns . '::CATS' } unless $@;
            }
        }
        if ( my $err = $@ ) {
            return $ctx->error(
                MT->translate(
                    "Error sorting [_2]: [_1]",
                    $err, $tag =~ m/folder/ig ? 'folders' : 'categories'
                )
            );
        }
    }
    else {
        if ( lc $sort_order eq 'descend' ) {
            @$cats = sort { $b->label cmp $a->label } @$cats;
        }
        else {
            @$cats = sort { $a->label cmp $b->label } @$cats;
        }
    }

    return $cats;
}

###########################################################################

=head2 Categories

Produces a list of categories defined for the current blog. This tag 
produces output for every category with no regard to their hierarchical 
structure.

=head4 Attributes

=over

=item * `show_empty`

    Setting this optional attribute to true (1) will include categories with 
    no entries assigned. The default is false (0), where only categories with 
    entries assigned.

=item * `glue`

    A string used to join the output of the separate iterations of MTCategories. 
    This can be as simple as a comma and space (", ") to list out category labels 
    or complex HTML markup to be inserted between the markup generated by MTCategories.

=item * `category_set_id`

    If specified, categories of specified category set will be output.
    If not specified, categories for entry will be output.

=back

=head4 Example

List out the categories used on at least one blog entry, separated by commas:

    Categories: <mt:Categories glue=", "><mt:categorylabel /></mt:Categories>

List all categories and link to categories it the category has one or more entries:

    <MTCategories show_empty="1">
        <mt:if name="__first__">
    <ul>
        </mt:if>
        <mt:if tag="CategoryCount" gte="1">
        <li><a href="<$MTCategoryArchiveLink$>"><$MTCategoryLabel$></a></li>
        <mt:else>
        <li><$MTCategoryLabel$></li>
        </mt:if>
        <mt:if name="__last__">
    </ul>
        </mt:if>
    </MTCategories>

=head4 Related

=over

=item * [Template Loop Meta Variables](/documentation/designer/loop-meta-variables.html) 
offer conditionals for odd, even, first, last, and counter.

=back

=for tags block, categories, category, entrycategories, template tag, multiblog

=cut

sub _hdlr_categories {
    my ( $ctx, $args, $cond ) = @_;
    my ( %terms, %args );
    $ctx->set_blog_load_context( $args, \%terms, \%args )
        or return $ctx->error( $ctx->errstr );
    require MT::Placement;
    $args{'sort'} = 'label';
    $args{'direction'}
        = lc( $args->{sort_order} || '' ) eq 'descend' ? 'descend' : 'ascend';

    my $class_type = $args->{class_type} || 'category';
    my $class = MT->model($class_type);
    my $entry_class
        = MT->model( $class_type eq 'category' ? 'entry' : 'page' );
    my %counts;
    my $count_tag
        = $class_type eq 'category'
        ? 'CategoryCount'
        : 'FolderCount';
    my $uncompiled = $ctx->stash('uncompiled') || '';
    my $count_all = 0;

    if ( !$args->{show_empty} || $uncompiled =~ /<\$?mt:?$count_tag/i ) {
        $count_all = 1;
    }
    my $content_type_id;
    if ( $args->{content_type} ) {
        my $content_type = $ctx->get_content_type_context( $args, $cond );
        $content_type_id = $content_type->id if $content_type;
    }
    ## Supplies a routine that will yield the number of entries associated
    ## with the category in context in the most efficient manner.
    ## If we can determine counts will be gathered for all categories,
    ## a 'count_group_by' request is done for MT::Placement to fetch counts
    ## with a single query (storing them in %counts).
    ## Otherwise, counts are collected on an as-needed basis, using the
    ## 'entry_count' method in MT::Category.
    my $counts_fetched   = 0;
    my $content_count_of = !$args->{category_set_id}
        ? sub {
        my $cat = shift;
        return delay( sub { $cat->entry_count } )
            unless $count_all;
        return $cat->entry_count(
            defined $counts{ $cat->id } ? $counts{ $cat->id } : 0 )
            if $counts_fetched;
        return $cat->cache_property(
            'entry_count',
            sub {

                # issue a single count_group_by for all categories
                my $cnt_iter = MT::Placement->count_group_by(
                    {%terms},
                    {   group => ['category_id'],
                        join  => $entry_class->join_on(
                            undef,
                            {   id     => \'=placement_entry_id',
                                status => MT::Entry::RELEASE(),
                            }
                        ),
                    }
                );
                while ( my ( $count, $cat_id ) = $cnt_iter->() ) {
                    $counts{$cat_id} = $count;
                }
                $counts_fetched = 1;
                $counts{ $cat->id };
            }
        );
        }
        : sub {
        my $cat = shift;
        return delay( sub { $cat->content_data_count } )
            unless $count_all;
        return $cat->content_data_count(
            {   count =>
                    ( defined $counts{ $cat->id } ? $counts{ $cat->id } : 0 ),
                $content_type_id
                ? ( content_type_id => $content_type_id )
                : (),

            }
        ) if $counts_fetched;
        return $cat->cache_property(
            'content_data_count',
            sub {
                my $blog = $ctx->stash('blog')
                    or return $ctx->_no_blog_error();
                my @category_fields = MT->model('content_field')
                    ->load( { blog_id => $blog->id, type => 'categories' } );
                my @content_field_ids = map { $_->id } @category_fields;

                my $cnt_iter = MT::ContentFieldIndex->count_group_by(
                    {   content_field_id => [@content_field_ids],
                        $content_type_id
                        ? ( content_type_id => $content_type_id )
                        : (),
                    },
                    {   group => ['value_integer'],
                        join  => MT->model('content_data')->join_on(
                            undef,
                            {   id     => \'=cf_idx_content_data_id',
                                status => MT::ContentStatus::RELEASE(),
                            }
                        ),
                    }
                );
                while ( my ( $count, $cat_id ) = $cnt_iter->() ) {
                    $counts{$cat_id} = $count;
                }
                $counts_fetched = 1;
                $counts{ $cat->id };
            }
        );
        };

    my $category_set_id
        = defined $args->{category_set_id} ? $args->{category_set_id}
        : $ctx->stash('category_set')      ? $ctx->stash('category_set')->id
        :                                    0;
    my $iter
        = $class->load_iter( { %terms, category_set_id => $category_set_id },
        \%args );

    my $res     = '';
    my $builder = $ctx->stash('builder');
    my $tokens  = $ctx->stash('tokens');
    my $glue    = $args->{glue};
    ## In order for this handler to double as the handler for
    ## <MTArchiveList archive_type="Category">, it needs to support
    ## the <$MTArchiveLink$> and <$MTArchiveTitle$> tags
    local $ctx->{inside_mt_categories} = 1;
    my $n          = $args->{lastn};
    my $i          = 0;
    my @categories = ();
    while ( my $cat = $iter->() ) {
        next
            if ( ( !$args->{show_empty} ) && ( !$content_count_of->($cat) ) );
        last if ( defined($n) && scalar(@categories) >= $n );
        push @categories, $cat;
    }
    my $vars = $ctx->{__stash}{vars} ||= {};
    MT::Meta::Proxy->bulk_load_meta_objects( \@categories );
    foreach my $cat (@categories) {
        $i++;
        my $last = $i == scalar(@categories);

        local $ctx->{__stash}{category} = $cat;
        local $ctx->{__stash}{entries};
        local $ctx->{__stash}{category_count};
        local $ctx->{__stash}{blog_id} = $cat->blog_id;
        local $ctx->{__stash}{blog}    = MT::Blog->load( $cat->blog_id );
        local $ctx->{__stash}{folder_header} = ( $i == 1 )
            if $class_type ne 'category';
        local $ctx->{__stash}{folder_footer} = ($last)
            if $class_type ne 'category';
        local $vars->{__first__}   = $i == 1;
        local $vars->{__last__}    = $last;
        local $vars->{__odd__}     = ( $i % 2 ) == 1;
        local $vars->{__even__}    = ( $i % 2 ) == 0;
        local $vars->{__counter__} = $i;
        $ctx->{__stash}{category_count} = $content_count_of->($cat);
        defined(
            my $out = $builder->build(
                $ctx, $tokens,
                {   %$cond,
                    ArchiveListHeader => $i == 1,
                    ArchiveListFooter => $last
                }
            )
        ) or return $ctx->error( $builder->errstr );
        $res .= $glue if defined $glue && length($res) && length($out);
        $res .= $out;
    }
    $res;
}

###########################################################################

=head2 CategoryPrevious

A container tag which creates a category context of the previous
category relative to the current entry category or archived category.

If the current category has sub-categories, then CategoryPrevious
will generate a link to the previous sibling category. For example,
in the following category hierarchy:

    News
        Gossip
        Politics
        Sports
    Events
        Oakland
        Palo Alto
        San Francisco
    Sports
        Local College
        MBA
        NFL

If the current category is "Events" then CategoryPrevious will link to
"News". If the current category is "San Francisco" then CategoryPrevious
will link to "Palo Alto".

B<Attributes:>

=over 4

=item * show_empty

Specifies whether categories with no entries assigned should be counted.

=back

B<Example:>

    <mt:CategoryPrevious>
        <a href="<$mt:ArchiveLink archive_type="Category"$>"><$mt:CategoryLabel$></a>
    </mt:CategoryPrevious>

=for tags categories, archives

=cut

###########################################################################

=head2 CategoryNext

A container tag which creates a category context of the next category
relative to the current entry category or archived category.

If the current category has sub-categories, then CategoryNext will
generate a link to the next sibling category. For example, in the
following category hierarchy:

    News
        Gossip
        Politics
        Sports
    Events
        Oakland
        Palo Alto
        San Francisco
    Sports
        Local College
        MBA
        NFL

If the current category is "News" then CategoryNext will link to
"Events". If the current category is "Oakland" then CategoryNext will
link to "Palo Alto".

B<Attributes:>

=over 4

=item * show_empty

Specifies whether categories with no entries assigned should be
counted and displayed.

=back

=for tags categories, archives

=cut

sub _hdlr_category_prevnext {
    my ( $ctx, $args, $cond ) = @_;
    my $class_type = $args->{class_type} || 'category';
    my $class      = MT->model($class_type);
    my $e          = $ctx->stash('entry');
    my $c          = $ctx->stash('content');
    my $tag        = $ctx->stash('tag');
    my $step       = $tag =~ m/Next/i ? 1 : -1;
    defined( my $cat = _get_category_context($ctx) )
        or return $ctx->error( $ctx->errstr );
    return '' if ( $cat eq '' );

    require MT::Placement;
    my $needs_entries;
    my $uncompiled = $ctx->stash('uncompiled') || '';
    $needs_entries
        = $class_type eq 'category'
        ? ( ( $uncompiled =~ /<MT:?Entries/i ) ? 1 : 0 )
        : ( ( $uncompiled =~ /<MT:?Pages/i ) ? 1 : 0 );
    my $needs_contents = ( $uncompiled =~ /<MT:?Contents/i ) ? 1 : 0;
    my $blog_id        = $cat->blog_id;
    my $cats           = _load_sibling_categories( $ctx, $cat, $class_type );

    # Get the sorting info
    my $sort_method = $args->{sort_method}
        || $ctx->stash('subCatsSortMethod');
    my $sort_order
        = $args->{sort_order}
        || $ctx->stash('subCatsSortOrder')
        || 'ascend';
    my $sort_by
        = $args->{sort_by}
        || $ctx->stash('subCatsSortBy')
        || 'user_custom';
    $sort_by = 'user_custom'
        if 'user_custom' ne $sort_by || !$class->has_column($sort_by);
    $sort_by ||= 'user_custom';
    if ($sort_method) {
        $cats = _sort_cats( $ctx, $sort_method, $sort_order, $cats )
            or return $ctx->error( $ctx->errstr );
    }
    elsif ( 'user_custom' eq $sort_by ) {
        my $text;
        if ( $cat->category_set ) {
            $text = $cat->category_set->order || '';
        }
        else {
            my $blog = $ctx->stash('blog');
            my $meta = $class_type . '_order';
            $text = $blog->$meta || '';
        }
        $cats = [ MT::Category::_sort_by_id_list( $text, $cats ) ];
        @$cats = reverse @$cats if $sort_order eq 'descend';
    }
    else {
        $cats = [ sort { $a->$sort_by cmp $b->$sort_by } @$cats ];
        @$cats = reverse @$cats if $sort_order eq 'descend';
    }

    my ( $pos, $idx );
    $idx = 0;
    foreach (@$cats) {
        $pos = $idx, last if $_->id == $cat->id;
        $idx++;
    }
    return '' unless defined $pos;
    $pos += $step;
    while ( $pos >= 0 && $pos < scalar @$cats ) {
        if ( !exists $cats->[$pos]->{_placement_count} ) {
            if ($needs_entries) {
                require MT::Entry;
                my @entries = MT::Entry->load(
                    {   blog_id => $blog_id,
                        status  => MT::Entry::RELEASE()
                    },
                    {   'join' => [
                            'MT::Placement', 'entry_id',
                            { category_id => $cat->id }
                        ],
                        'sort'    => 'authored_on',
                        direction => 'descend',
                    }
                );
                $cats->[$pos]->{_entries}         = \@entries;
                $cats->[$pos]->{_placement_count} = scalar @entries;
            }
            elsif ($needs_contents) {
                my $content_type    = $ctx->stash('content_type');
                my $content_type_id = $content_type ? $content_type->id : '';
                my @contents        = MT->model('content_data')->load(
                    {   blog_id         => $blog_id,
                        status          => MT::ContentStatus::RELEASE(),
                        content_type_id => $content_type_id,
                    },
                    {   join => [
                            'MT::ObjectCategory',
                            'object_id',
                            {   object_ds   => 'content_data',
                                category_id => $cat->id,
                            },
                        ],
                        'sort'    => 'authored_on',
                        direction => 'descend',
                    },
                );
                $cats->[$pos]->{_contents}        = \@contents;
                $cats->[$pos]->{_placement_count} = scalar @contents;
            }
            else {
                $cats->[$pos]->{_placement_count}
                    = $cats->[$pos]->category_set_id
                    ? MT::ObjectCategory->count(
                    { category_id => $cats->[$pos]->id } )
                    : MT::Placement->count(
                    { category_id => $cats->[$pos]->id } );
            }
        }
        $pos += $step, next
            unless $cats->[$pos]->{_placement_count}
            || $args->{show_empty};
        local $ctx->{__stash}{category} = $cats->[$pos];
        local $ctx->{__stash}{entries}  = $cats->[$pos]->{_entries}
            if $needs_entries;

        local $ctx->{__stash}{contents} = $cats->[$pos]->{_contents}
            if $needs_contents;
        local $ctx->{__stash}{category_count}
            = $cats->[$pos]->{_placement_count};
        local $ctx->{__stash}{'subCatsSortOrder'}  = $sort_order;
        local $ctx->{__stash}{'subCatsSortMethod'} = $sort_method;
        local $ctx->{__stash}{'subCatsSortBy'}     = $sort_by;
        return $ctx->slurp( $args, $cond );
    }
    return '';
}

###########################################################################

=head2 SubCategories

A specialized version of the L<Categories> container tag that respects the
hierarchical structure of categories.

B<Attributes:>

=over 4

=item * include_current

An optional boolean attribute that controls the inclusion of the
current category in the list.

=item * sort_method

An optional and advanced usage attribute. A fully qualified Perl method
name to be used to sort the categories.

=item * sort_order

Specifies the sort order of the category labels. Recognized values
are "ascend" and "descend." The default is "ascend." This attribute is
ignored if sort_method has been set.

=item * top

If set to 1, displays only top level categories. Same as using
L<TopLevelCategories>.

=item * category

Specifies a specific category by name for which to return subcategories. 
If subcategory label contains a slash (such as if the category was 
"Mickey/Minnie Mouse"), this will be recognized as the divider specifying
a category and subcategory. To avoid this issue surround the value of the 
category attribute with square brackets:

    category="[Mickey/Minnie Mouse]"

=item * glue

=item * category_set_id

    If specified, categories of specified category set will be output.
    If not specified, categories for entry will be output.

=back

=for tags categories

=cut

sub _hdlr_sub_categories {
    my ( $ctx, $args, $cond ) = @_;

    my $class_type = $args->{class_type} || 'category';
    my $class = MT->model($class_type);
    my $entry_class
        = MT->model( $class_type eq 'category' ? 'entry' : 'page' );

    my $builder = $ctx->stash('builder');
    my $tokens  = $ctx->stash('tokens');

    # Do we want the current category?
    my $include_current = $args->{include_current};

    # Sorting information
    #   sort_order ::= 'ascend' | 'descend'
    #   sort_method ::= method name (e.g. package::method)
    #
    # sort_method takes precedence
    my $sort_order  = $args->{sort_order} || 'ascend';
    my $sort_by     = $args->{sort_by};
    my $sort_method = $args->{sort_method};

    return $ctx->error(
        MT->translate(
            'Cannot use sort_by and sort_method together in [_1]',
            $ctx->stash('tag'),
        )
    ) if ( $sort_method && $sort_by );
    $sort_by = 'user_custom'
        if !$sort_by || !$class->has_column($sort_by);

    my $category_set_id = $args->{category_set_id} || 0;
    if ( !$category_set_id && $ctx->stash('category_set') ) {
        $category_set_id = $ctx->stash('category_set')->id;
    }

    # Store the tokens for recursion
    local $ctx->{__stash}{subCatTokens} = $tokens;
    my $current_cat;
    my @cats;
    if ( $args->{top} ) {
        @cats = $class->load(
            {   blog_id         => $ctx->stash('blog_id'),
                parent          => '0',
                category_set_id => $category_set_id,
            },
            {   (     ( 'user_custom' eq $sort_by )
                    ? ( sort => 'label' )
                    : ( sort => $sort_by )
                ),
                direction => $sort_order,
            }
        );
    }
    else {

        # Use explicit category or category context
        if ( $args->{category} ) {

            # user specified category; list from this category down
            ($current_cat) = $ctx->cat_path_to_category(
                $args->{category}, $ctx->stash('blog_id'),
                $class_type,       $category_set_id
            );
        }
        else {
            $current_cat = $ctx->stash('category')
                || $ctx->stash('archive_category');
        }
        if ($current_cat) {
            if ($include_current) {

               # If we're to include it, just use it to seed the category list
                @cats = ($current_cat);
            }
            else {

                # Otherwise, use its children
                @cats = $current_cat->children_categories;
            }
        }
    }
    return '' unless @cats;

    my $cats;
    if ($sort_method) {
        $cats = _sort_cats( $ctx, $sort_method, $sort_order, \@cats )
            or return $ctx->error( $ctx->errstr );
    }
    elsif ( 'user_custom' eq $sort_by ) {
        my $text;
        if ($category_set_id) {
            my $category_set
                = MT->model('category_set')->load($category_set_id)
                or return $ctx->error( MT->model('category_set') );
            $text = $category_set->order || '';
        }
        else {
            my $blog = $ctx->stash('blog');
            my $meta = $class_type . '_order';
            $text = $blog->$meta || '';
        }
        @$cats = MT::Category::_sort_by_id_list( $text, \@cats );
        @$cats = reverse @$cats if $sort_order eq 'descend';
    }
    else {
        $cats = [ sort { $a->$sort_by cmp $b->$sort_by } @cats ];
        @$cats = reverse @$cats if $sort_order eq 'descend';
    }

    # Init variables
    my $count = 0;
    my $res   = '';

    # Be sure the regular MT tags know we're in a category context
    local $ctx->{inside_mt_categories}         = 1;
    local $ctx->{__stash}{'subCatsSortOrder'}  = $sort_order;
    local $ctx->{__stash}{'subCatsSortMethod'} = $sort_method;
    local $ctx->{__stash}{'subCatsSortBy'}     = $sort_by;

    MT::Meta::Proxy->bulk_load_meta_objects($cats);

    # Loop through the immediate children (or the current cat,
    # depending on the arguments
    while ( my $cat = shift @$cats ) {
        next if ( !defined $cat );
        local $ctx->{__stash}{'category'}      = $cat;
        local $ctx->{__stash}{'subCatIsFirst'} = !$count;
        local $ctx->{__stash}{'subCatIsLast'}  = !scalar @$cats;
        local $ctx->{__stash}{'folder_header'} = !$count
            if $class_type ne 'category';
        local $ctx->{__stash}{'folder_footer'} = !scalar @$cats
            if $class_type ne 'category';

        local $ctx->{__stash}{'category_count'};

        local $ctx->{__stash}{'entries'} = delay(
            sub {
                my @args = (
                    {   blog_id => $ctx->stash('blog_id'),
                        status  => MT::Entry::RELEASE()
                    },
                    {   'join' => [
                            'MT::Placement', 'entry_id',
                            { category_id => $cat->id }
                        ],
                        'sort'    => 'authored_on',
                        direction => 'descend'
                    }
                );

                my @entries = $entry_class->load(@args);
                \@entries;
            }
        );

        defined( my $out = $builder->build( $ctx, $tokens, $cond ) )
            or return $ctx->error( $ctx->errstr );

        $res .= $out;
        $count++;
    }

    $res;
}

###########################################################################

=head2 TopLevelCategories

A block tag listing the categories that do not have a parent and exist at
"the top" of the category hierarchy. Same as using
C<E<lt>mt:SubCategories top="1"E<gt>>.

=for tags categories

=cut

sub _hdlr_top_level_categories {
    my ( $ctx, $args, $cond ) = @_;

    # Unset the normaly hiding places for categories so
    # MTSubCategories doesn't pick them up
    local $ctx->{__stash}{'category'}         = undef;
    local $ctx->{__stash}{'archive_category'} = undef;
    local $args->{top}                        = 1;

    # Call MTSubCategories
    &_hdlr_sub_categories;
}

###########################################################################

=head2 ParentCategory

A container tag that creates a context to the current category's parent.

B<Example:>

    <mt:ParentCategory>
        Up: <a href="<mt:ArchiveLink>"><mt:CategoryLabel></a>
    </mt:ParentCategory>

=for tags categories

=cut

sub _hdlr_parent_category {
    my ( $ctx, $args, $cond ) = @_;

    my $builder = $ctx->stash('builder');
    my $tokens  = $ctx->stash('tokens');

    # Get the current category
    my $cat = _get_category_context($ctx);
    return if !defined($cat) && defined( $ctx->errstr );
    return '' if ( $cat eq '' );

    # The category must have a parent, otherwise return empty string
    my $parent = $cat->parent_category or return '';

    # Setup the context and let 'er rip
    local $ctx->{__stash}->{category} = $parent;
    defined( my $out = $builder->build( $ctx, $tokens, $cond ) )
        or return $ctx->error( $ctx->errstr );

    $out;
}

###########################################################################

=head2 ParentCategories

A block tag that lists all the ancestors of the current category.

B<Attributes:>

=over 4

=item * glue

This optional attribute is a shortcut for connecting each category
label with its value. Single and double quotes are not permitted in
the string.

=item * exclude_current

This optional boolean attribute controls the exclusion of the
current category in the list.

=back

=for tags categories

=cut

sub _hdlr_parent_categories {
    my ( $ctx, $args, $cond ) = @_;

    my $builder = $ctx->stash('builder');
    my $tokens  = $ctx->stash('tokens');

    # Get the arguments
    my $exclude_current = $args->{'exclude_current'};
    my $glue            = $args->{'glue'};

    # Get the current category
    defined( my $cat = _get_category_context($ctx) )
        or return $ctx->error( $ctx->errstr );
    return '' if ( $cat eq '' );

    my $res = '';

    # Put together the list of parent categories
    # including the current one unless instructed otherwise
    my @cats = $cat->parent_categories;
    @cats = ( $cat, @cats ) unless ($exclude_current);

    MT::Meta::Proxy->bulk_load_meta_objects( \@cats );

    # Start from the top and work our way down
    while ( my $c = pop @cats ) {
        local $ctx->{__stash}->{category} = $c;
        defined( my $out = $builder->build( $ctx, $tokens, $cond ) )
            or return $ctx->error( $ctx->errstr );
        if ( $args->{sub_cats_path_hack} && $out !~ /\w/ ) {
            $out = 'cat-' . $c->id;
        }
        $res .= $glue
            if defined $glue && length($res) && length($out);
        $res .= $out if length($out);
    }
    $res;
}

###########################################################################

=head2 TopLevelParent

A container tag that creates a context to the top-level ancestor of
the current category.

=for tags categories

=cut

sub _hdlr_top_level_parent {
    my ( $ctx, $args, $cond ) = @_;

    my $builder = $ctx->stash('builder');
    my $tokens  = $ctx->stash('tokens');

    # Get the current category
    defined( my $cat = _get_category_context($ctx) )
        or return $ctx->error( $ctx->errstr );
    return '' if ( $cat eq '' );

    my $out = "";

    # Get the list of parents
    my @parents = ( $cat, $cat->parent_categories );

    # If there are any
    # Pop the top one of the list
    if ( scalar @parents ) {
        $cat = pop @parents;
        local $ctx->{__stash}->{category} = $cat;
        defined( $out = $builder->build( $ctx, $tokens, $cond ) )
            or return $ctx->error( $ctx->errstr );
    }

    $out;
}

###########################################################################

=head2 EntriesWithSubCategories

A specialized version of L<Entries> that is aware of subcategories. The
difference between the two tags is the behavior of the category attribute.

B<Attributes:>

=over 4

=item * category

The value of this attribute is a category label. This will include
any entries to that category and any of its subcategories. Since it
is possible for two categories to have the same label, you can specify
one particular category by including its ancestors, separated by
slashes. For instance if you have a category "Flies" and within it
a subcategory labeled "Fruit", you can ask for that category with
category="Flies/Fruit". This would distinguish it from a category
labeled "Fruit" within another called "Food Groups", for example,
which could be identified using category="Food Groups/Fruit".

If any category in the ancestor chain has a slash in its label, the
label must be quoted using square brackets:
category="Beverages/[Coffee/Tea]" identifies a category labeled
Coffee/Tea within a category labeled Beverages.

=back

You can also use any of the other attributes available to L<Entries>;
and they should behave just as they do with the original tag.

=for tags entries, categories

=cut

sub _hdlr_entries_with_sub_categories {
    my ( $ctx, $args, $cond ) = @_;

    my $cat = $ctx->stash('category')
        || $ctx->stash('archive_category');

    my $save_entries = defined $ctx->stash('archive_category');
    my $saved_stash_entries;

    if ( defined $cat ) {
        $saved_stash_entries = $ctx->{__stash}{entries}
            if $save_entries;
        delete $ctx->{__stash}{entries};
    }

    local $args->{include_subcategories} = 1;
    local $args->{category} ||= [ 'OR', [$cat] ] if defined $cat;
    my $res = $ctx->invoke_handler( 'entries', $args, $cond );
    $ctx->{__stash}{entries} = $saved_stash_entries
        if $save_entries && $saved_stash_entries;
    $res;
}

###########################################################################

=head2 IfCategory

A conditional tag used to test for category assignments for the entry
in context, or generically to test for which category is in context.

B<Attributes:>

=over 4

=item * name (or label; optional)

The name of a category. If given, tests the category in context (or
categories of an entry in context) to see if it matches with the given
category name.

=item * type (optional)

Either the keyword "primary" or "secondary". Used to test whether the
specified category (specified by the name or label attribute) is a
primary or secondary category assignment for the entry in context.

=back

B<Examples:>

    <mt:IfCategory>
        (current entry in context has a category assignment)
    </mt:IfCategory>

    <mt:IfCategory type="secondary">
        (current entry in context has one or more secondary category)
    </mt:IfCategory>

    <mt:IfCategory name="News">
        (current entry in context is assigned to the "News" category)
    </mt:IfCategory>

    <mt:IfCategory name="News" type="primary">
        (current entry in context has a "News" category as its primary category)
    </mt:IfCategory>

=for tags entries, categories

=cut

###########################################################################

=head2 EntryIfCategory

This tag has been deprecated in favor of L<IfCategory>.

=for tags deprecated

=cut

sub _hdlr_if_category {
    my ( $ctx, $args, $cond ) = @_;
    my $e             = $ctx->stash('entry');
    my $tag           = lc $ctx->stash('tag');
    my $entry_context = $tag =~ m/(entry|page)if(category|folder)/;
    my $name          = $args->{name} || $args->{label};
    my $primary       = $args->{type} && ( $args->{type} eq 'primary' );
    my $secondary     = $args->{type} && ( $args->{type} eq 'secondary' );
    $entry_context ||= ( $primary || $secondary );
    return $ctx->_no_entry_error() if $entry_context && !$e;
    my $cat
        = $entry_context
        ? $e->category
        : (    $ctx->stash('category')
            || $ctx->stash('archive_category') );

    if ( !$cat && $e && !$entry_context ) {
        $cat           = $e->category;
        $entry_context = 1;
    }
    my $cats = [];
    if ( $cat && ( $primary || !$entry_context ) ) {
        $cats = [$cat];
    }
    elsif ($e) {
        $cats = $e->categories;
    }
    if ( $secondary && $cat ) {
        my @cats = grep { $_->id != $cat->id } @$cats;
        $cats = \@cats;
    }
    if ( !defined $name ) {
        return @$cats ? 1 : 0;
    }
    foreach my $cat (@$cats) {
        return 1 if $cat->label eq $name;
    }
    0;
}

###########################################################################

=head2 SubCatIsFirst

The contents of this container tag will be displayed when the first
category listed by a L<SubCategories> tag is reached.

=for tags categories

=cut

sub _hdlr_sub_cat_is_first {
    my ($ctx) = @_;
    return $ctx->stash('subCatIsFirst');
}

###########################################################################

=head2 SubCatIsLast

The contents of this container tag will be displayed when the last
category listed by a L<SubCategories> tag is reached.

=for tags categories

=cut

sub _hdlr_sub_cat_is_last {
    my ($ctx) = @_;
    return $ctx->stash('subCatIsLast');
}

###########################################################################

=head2 HasSubCategories

Returns true if the current category has a sub-category.

=for tags categories

=cut

sub _hdlr_has_sub_categories {
    my ( $ctx, $args, $cond ) = @_;

    # Get the current category context
    defined( my $cat = _get_category_context($ctx) )
        or return $ctx->error( $ctx->errstr );
    return if ( $cat eq '' );

    # Return the number of children for the category
    my @children = $cat->children_categories;
    scalar @children;
}

###########################################################################

=head2 HasNoSubCategories

Returns true if the current category has no sub-categories.

=for tags categories

=cut

sub _hdlr_has_no_sub_categories {
    !&_hdlr_has_sub_categories;
}

###########################################################################

=head2 HasParentCategory

Returns true if the current category has a parent category other than
the root.

=for tags categories

=cut

sub _hdlr_has_parent_category {
    my ( $ctx, $args ) = @_;

    # Get the current category
    defined( my $cat = _get_category_context($ctx) )
        or return $ctx->error( $ctx->errstr );
    return 0 if ( $cat eq '' );

    # Return the parent of the category
    return $cat->parent_category ? 1 : 0;
}

###########################################################################

=head2 HasNoParentCategory

Returns true if the current category does not have a parent category
other than the root.

B<Example:>

    <mt:Categories>
      <mt:HasNoParentCategory>
        <mt:CategoryLabel> is but an orphan and has no parents.
      <mt:else>
        <mt:CategoryLabel> has a parent category!
      </mt:HasNoParentCategory>
    </mt:Categories>

=for tags categories

=cut

sub _hdlr_has_no_parent_category {
    return !&_hdlr_has_parent_category;
}

###########################################################################

=head2 IfIsAncestor

Conditional tag that is true when the category in context is an ancestor
category of the specified 'child' attribute.

B<Attributes:>

=over 4

=item * child (required)

The label of a category in the current blog.

=back

B<Example:>

    <mt:IfIsAncestor child="Featured">
        (category in context is a parent category
        to a subcategory named "Featured".)
    </mt:IfIsDescendant>

=for tags categories

=cut

sub _hdlr_is_ancestor {
    my ( $ctx, $args ) = @_;

    # Get the current category
    defined( my $cat = _get_category_context($ctx) )
        or return $ctx->error( $ctx->errstr );
    return if ( $cat eq '' );

    # Get the possible child category
    my $blog_id = $ctx->stash('blog_id');
    my $iter    = MT::Category->load_iter(
        {   blog_id => $blog_id,
            label   => $args->{'child'}
        }
    );
    while ( my $child = $iter->() ) {
        if ( $cat->is_ancestor($child) ) {
            $iter->end;
            return 1;
        }
    }

    0;
}

###########################################################################

=head2 IfIsDescendant

Conditional tag that is true when the category in context is a child
category of the specified 'parent' attribute.

B<Attributes:>

=over 4

=item * parent (required)

The label of a category in the current blog.

=back

B<Example:>

    <mt:IfIsDescendant parent="Featured">
        (category in context is a child category
        to the 'Featured' category.)
    </mt:IfIsDescendant>

=for tags categories

=cut

sub _hdlr_is_descendant {
    my ( $ctx, $args ) = @_;

    # Get the current category
    defined( my $cat = _get_category_context($ctx) )
        or return $ctx->error( $ctx->errstr );
    return if ( $cat eq '' );

    # Get the possible parent category
    my $blog_id = $ctx->stash('blog_id');
    my $iter    = MT::Category->load_iter(
        {   blog_id => $blog_id,
            label   => $args->{'parent'}
        }
    );
    while ( my $parent = $iter->() ) {
        if ( $cat->is_descendant($parent) ) {
            $iter->end;
            return 1;
        }
    }

    0;
}

###########################################################################

=head2 EntryCategories

A container tag that lists all of the categories (primary and secondary)
to which the entry is assigned. This tagset creates a category context
within which any category or subcategory tags may be used.

B<Attributes:>

=over 4

=item * glue (optional)

If specified, this string is placed in between each result from the loop.

=back

=cut

sub _hdlr_entry_categories {
    my ( $ctx, $args, $cond ) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error();
    my $cats;
    if ( 'primary' eq lc( $args->{type} || '' ) ) {
        $cats = [ $e->category ]
            if $e->category;
    }
    else {
        $cats = $e->categories;
    }
    return '' unless $cats && @$cats;
    my $builder = $ctx->stash('builder');
    my $tokens  = $ctx->stash('tokens');
    my $res     = '';
    my $glue    = $args->{glue};
    local $ctx->{inside_mt_categories} = 1;

    for my $cat (@$cats) {
        local $ctx->{__stash}->{category} = $cat;
        defined( my $out = $builder->build( $ctx, $tokens, $cond ) )
            or return $ctx->error( $builder->errstr );
        $res .= $glue
            if defined $glue && length($res) && length($out);
        $res .= $out;
    }
    $res;
}

###########################################################################

=head2 EntryPrimaryCategory

This block tag that can be used to set the primary category of the entry
in context. Must be used in an entry context (entry archive or L<Entries> loop).

All categories can be listed using L<EntryCategories> loop tag.

=for tags entries, categories

=cut

sub _hdlr_entry_primary_category {
    my ( $ctx, $args, $cond ) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error();
    my $cat = $e->category;
    return '' unless $cat;
    my $builder = $ctx->stash('builder');
    my $tokens  = $ctx->stash('tokens');
    local $ctx->{inside_mt_categories} = 1;
    local $ctx->{__stash}->{category} = $cat;
    defined( my $out = $builder->build( $ctx, $tokens, $cond ) )
        or return $ctx->error( $builder->errstr );
    $out;
}

###########################################################################

=head2 EntryAdditionalCategories

This block tag iterates over all secondary categories for the entry in
context. Must be used in an entry context (entry archive or L<Entries> loop).

All categories can be listed using L<EntryCategories> loop tag.

=for tags entries, categories

=cut

sub _hdlr_entry_additional_categories {
    my ( $ctx, $args, $cond ) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error();
    my $cats = $e->categories;
    return '' unless $cats && @$cats;
    my $builder = $ctx->stash('builder');
    my $tokens  = $ctx->stash('tokens');
    my $res     = '';
    my $glue    = $args->{glue};
    for my $cat (@$cats) {
        next
            if $e->category && ( $cat->label eq $e->category->label );
        local $ctx->{__stash}->{category} = $cat;
        defined( my $out = $builder->build( $ctx, $tokens, $cond ) )
            or return $ctx->error( $builder->errstr );
        $res .= $glue
            if defined $glue && length($res) && length($out);
        $res .= $out if length($out);
    }
    $res;
}

###########################################################################

=head2 CategoryID

The numeric system ID of the category.

B<Example:>

    <$mt:CategoryID$>

=for tags categories

=cut

sub _hdlr_category_id {
    my ($ctx) = @_;

    # Get the current category
    defined( my $cat = _get_category_context($ctx) )
        or return $ctx->error( $ctx->errstr );
    return if ( $cat eq '' );

    return $cat->id;
}

###########################################################################

=head2 CategoryLabel

The label of the category in context. The current category in context can be
placed there by either the following contexts (in order of precedence):

=over 4

=item * the current category you might be by looping through a list of categories

=item * the current category archive template/mapping you are in

=item * the primary category of the current entry in context

=back

B<Example:>

    <$mt:CategoryLabel$>

=for tags categories

=cut

sub _hdlr_category_label {
    my ( $ctx, $args, $cond ) = @_;

    # Get the current category
    defined( my $cat = _get_category_context($ctx) )
        or return (
        defined( $args->{default} )
        ? $args->{default}
        : $ctx->error( $ctx->errstr )
        );

    return ( defined( $args->{default} ) ? $args->{default} : '' )
        if ( $cat eq '' );

    my $label = $cat->label;
    $label = '' unless defined $label;
    return $label;
}

###########################################################################

=head2 CategoryBasename

Produces the dirified basename defined for the category in context.

B<Attributes:>

=over 4

=item * default

A value to use in the event that no category is in context.

=item * separator

Valid values are "_" and "-", dash is the default value. Specifying an
underscore will convert any dashes to underscores. Specifying a dash will
convert any underscores to dashes.

=back

B<Example:>

    <$mt:CategoryBasename$>

=cut

sub _hdlr_category_basename {
    my ( $ctx, $args, $cond ) = @_;

    # Get the current category
    defined( my $cat = _get_category_context($ctx) )
        or return (
        defined( $args->{default} )
        ? $args->{default}
        : $ctx->error( $ctx->errstr )
        );

    return ( defined( $args->{default} ) ? $args->{default} : '' )
        if ( $cat eq '' );

    my $basename = $cat->basename || '';
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

=head2 CategoryDescription

The description for the category in context.

B<Example:>

    <$mt:CategoryDescription$>

=cut

sub _hdlr_category_desc {
    my ($ctx) = @_;

    # Get the current category
    defined( my $cat = _get_category_context($ctx) )
        or return $ctx->error( $ctx->errstr );
    return if ( $cat eq '' );

    return defined $cat->description ? $cat->description : '';
}

###########################################################################

=head2 CategoryArchiveLink

A link to the archive page of the category.

B<Example:>

    <$mt:CategoryArchiveLink$>

=cut

sub _hdlr_category_archive {
    my ( $ctx, $args ) = @_;

    # Get the current category
    defined( my $cat = _get_category_context($ctx) )
        or return $ctx->error( $ctx->errstr );
    return if ( $cat eq '' or $cat->class_type eq 'folder' );

    my $cat_at_label
        = $ctx->stash('content')
        || $cat->category_set_id
        ? 'ContentType-Category'
        : 'Category';

    my $curr_at
        = $ctx->{current_archive_type}
        || $ctx->{archive_type}
        || $cat_at_label;

    my $blog = $ctx->stash('blog');
    return '' unless $blog || $curr_at eq $cat_at_label;
    if ( $curr_at ne $cat_at_label ) {

        # Check if "Category" or "ContentType-Category"
        # archive is published
        my $at      = $blog->archive_type;
        my @at      = split /,/, $at;
        my $cat_arc = '';
        for (@at) {
            if ( $cat_at_label eq $_ ) {
                $cat_arc = 1;
                last;
            }
        }
        return $ctx->error(
            MT->translate(
                "[_1] cannot be used without publishing [_2] archive.",
                '<$MTCategoryArchiveLink$>',
                $cat_at_label
            )
        ) unless $cat_arc;
    }

    my $content_type_id
        = $ctx->stash('content_type')
        ? $ctx->stash('content_type')->id
        : '';
    my $arch = $blog->archive_url;
    $arch .= '/' unless $arch =~ m!/$!;
    $arch = $arch
        . archive_file_for( undef, $blog, $cat_at_label, $cat, '', '', '',
        $content_type_id );
    $arch = MT::Util::strip_index( $arch, $blog )
        unless $args->{with_index};
    $arch;
}

###########################################################################

=head2 CategoryCount

The number of published entries or content data for the category in context.

B<Example:>

    Contents in this category: <$mt:CategoryCount$>

=for tags categories, count

=cut

sub _hdlr_category_count {
    my ( $ctx, $args, $cond ) = @_;

    # Get the current category
    defined( my $cat = _get_category_context($ctx) )
        or return $ctx->error( $ctx->errstr );
    return if ( $cat eq '' );

    my $count;
    unless ( $cat->category_set_id ) {
        $count = $ctx->stash('category_count');
        $count = $cat->entry_count unless defined $count;
    }
    else {
        my $terms = {};

        if ( my $cf_arg = $args->{content_field} ) {
            if ( $cf_arg =~ /^\d+$/ ) {
                $terms->{content_field_id} = $cf_arg;
            }
            else {
                my $cf
                    = MT->model('content_field')
                    ->load( { unique_id => $cf_arg } );
                if ($cf) {
                    $terms->{content_field_id} = $cf->id;
                }
                else {
                    $terms->{content_field_name} = $cf_arg;
                }
            }
        }
        elsif ( my $cf_stash = $ctx->stash('content_field') ) {
            $terms->{content_field_id} = $cf_stash->id;
        }

        if ( my $ct_arg = $args->{content_type} ) {
            if ( $ct_arg =~ /^\d+$/ ) {
                $terms->{content_type_id} = $ct_arg;
            }
            else {
                my $content_type
                    = $ctx->get_content_type_context( $args, $cond );
                $terms->{content_type_id} = $content_type->id
                    if $content_type;
            }
        }
        elsif ( my $ct_stash = $ctx->stash('content_type') ) {
            $terms->{content_type_id} = $ct_stash->id;
        }

        $count = $cat->content_data_count($terms);
    }

    return $ctx->count_format( $count, $args );
}

###########################################################################

=head2 SubCatsRecurse

Recursively call the L<SubCategories> or L<TopLevelCategories> container
with the subcategories of the category in context. This tag, when placed
at the end of loop controlled by one of the tags above will cause them
to recursively descend into any subcategories that exist during the loop.

B<Attributes:>

=over 4

=item * max_depth (optional)

An optional attribute that specifies the maximum number of times the system
should recurse. The default is infinite depth.

=back

B<Examples:>

The following code prints out a recursive list of categories/subcategories, linking those with entries assigned to their category archive pages.

    <mt:TopLevelCategories>
      <mt:SubCatIsFirst><ul></mt:SubCatIsFirst>
        <mt:If tag="CategoryCount">
            <li><a href="<$mt:CategoryArchiveLink$>"
            title="<$mt:CategoryDescription$>"><mt:CategoryLabel></a>
        <mt:Else>
            <li><$mt:CategoryLabel$>
        </mt:If>
        <$mt:SubCatsRecurse$>
        </li>
    <mt:SubCatIsLast></ul></mt:SubCatIsLast>
    </mt:TopLevelCategories>

Or more simply:

    <mt:TopLevelCategories>
        <$mt:CategoryLabel$>
        <$mt:SubCatsRecurse$>
    </mt:TopLevelCategories>

=for tags categories

=cut

sub _hdlr_sub_cats_recurse {
    my ( $ctx, $args ) = @_;
    my $class_type = $args->{class_type} || 'category';
    my $class = MT->model($class_type);
    my $entry_class
        = MT->model( $class_type eq 'category' ? 'entry' : 'page' );

    # Make sure were in the right context
    # mostly to see if we have anything to actually build
    my $tokens = $ctx->stash('subCatTokens')
        or return $ctx->error(
        MT->translate(
            "[_1] used outside of [_2]",
            $class_type eq 'category'
            ? (qw(MTSubCatRecurse MTSubCategories))
            : (qw(MTSubFolderRecurse MTSubFolders))
        )
        );
    my $builder = $ctx->stash('builder');

    my $cat = $ctx->stash('category');

    # Get the depth info
    my $max_depth = $args->{max_depth};
    my $depth = $ctx->stash('subCatsDepth') || 0;

    # Get the sorting info
    my $sort_method = $ctx->stash('subCatsSortMethod');
    my $sort_order  = $ctx->stash('subCatsSortOrder');
    my $sort_by     = $ctx->stash('subCatsSortBy') || 'user_custom';
    $sort_by = 'user_custom'
        if 'user_custom' ne $sort_by && !$class->has_column($sort_by);
    $sort_by ||= 'user_custom';

    # If we're too deep, return an emtry string because we're done
    return '' if ( $max_depth && $depth >= $max_depth );

    my @cats = $cat->children_categories;
    my $cats;
    if ($sort_method) {
        $cats = _sort_cats( $ctx, $sort_method, $sort_order, \@cats )
            or return $ctx->error( $ctx->errstr );
    }
    elsif ( 'user_custom' eq $sort_by ) {
        my $text;
        if ( $cat->category_set ) {
            $text = $cat->category_set->order || '';
        }
        else {
            my $blog = $ctx->stash('blog');
            my $meta = $class_type . '_order';
            $text = $blog->$meta || '';
        }
        @$cats = MT::Category::_sort_by_id_list( $text, \@cats );
        @$cats = reverse @$cats if $sort_order eq 'descend';
    }
    else {
        $cats = [ sort { $a->$sort_by cmp $b->$sort_by } @cats ];
        @$cats = reverse @$cats if $sort_order eq 'descend';
    }

    # Init variables
    my $count = 0;
    my $res   = '';

    # Loop through each immediate child, incrementing the depth by 1
    while ( my $c = shift @$cats ) {
        next if ( !defined $c );
        local $ctx->{__stash}{'category'}          = $c;
        local $ctx->{__stash}{'subCatIsFirst'}     = !$count;
        local $ctx->{__stash}{'subCatIsLast'}      = !scalar @$cats;
        local $ctx->{__stash}{'subCatsSortOrder'}  = $sort_order;
        local $ctx->{__stash}{'subCatsSortMethod'} = $sort_method;
        local $ctx->{__stash}{'subCatsSortBy'}     = $sort_by;

        local $ctx->{__stash}{'subCatsDepth'}      = $depth + 1;
        local $ctx->{__stash}{vars}->{'__depth__'} = $depth + 1;
        local $ctx->{__stash}{'folder_header'}     = !$count
            if $class_type ne 'category';
        local $ctx->{__stash}{'folder_footer'} = !scalar @$cats
            if $class_type ne 'category';

        local $ctx->{__stash}{'category_count'};

        local $ctx->{__stash}{'entries'} = delay(
            sub {
                my @args = (
                    {   blog_id => $ctx->stash('blog_id'),
                        status  => MT::Entry::RELEASE()
                    },
                    {   'join' => [
                            'MT::Placement', 'entry_id',
                            { category_id => $c->id }
                        ],
                        'sort'    => 'authored_on',
                        direction => 'descend',
                    }
                );

                my @entries = $entry_class->load(@args);
                \@entries;
            }
        );

        defined( my $out = $builder->build( $ctx, $tokens ) )
            or return $ctx->error( $ctx->errstr );

        $res .= $out;
        $count++;
    }

    $res;
}

###########################################################################

=head2 SubCategoryPath

The path to the category relative to L<BlogURL>.

In other words, this tag returns a string that is a concatenation of the
current category and its ancestors. This tag is provided for convenience
and is the equivalent of the following template tags:

    <mt:ParentCategories glue="/"><mt:CategoryBasename /></mt:ParentCategories>

B<Attributes:>

=over 4

=item * separator

Valid values are "_" and "-", dash is the default value. Specifying an
underscore will convert any dashes to underscores. Specifying a dash will
convert any underscores to dashes.

=back

B<Example:>

The category "Bar" in a category "Foo" C<E<lt>$mt:SubCategoryPath$E<gt>> becomes C<foo/bar>.

=for tags categories

=cut

sub _hdlr_sub_category_path {
    my ( $ctx, $args, $cond ) = @_;

    my $builder = $ctx->stash('builder');
    my $dir     = '';
    if ( $args->{separator} ) {
        $dir = "separator='$args->{separator}'";
    }
    my $tokens = $builder->compile( $ctx, "<MTCategoryBasename $dir>" );

    # unfortunately, there's no way to apply a filter that would
    # take the output of the dirify step and, if it were blank,
    # use instead some other property of the category (such as the
    # category ID). this hack tells parent_categories to do that
    # to the output of its contents.
    $args->{'sub_cats_path_hack'} = 1;

    $args->{'glue'} = '/';
    local $ctx->{__stash}->{tokens} = $tokens;
    &_hdlr_parent_categories;
}

###########################################################################

=head2 BlogCategoryCount

Returns the number of categories associated with a blog. This
template tag supports the multiblog template tags.

This template tag also supports all of the same filtering mechanisms
defined by the mt:Categories tag allowing users to retrieve a count
of the number of comments on a blog that meet a certain criteria.

B<Example:>

    <$mt:BlogCategoryCount$>

=for tags multiblog, count, blogs, categories

=cut

=head2 SiteCategoryCount

Returns the number of categories associated with a site. This
template tag supports the multiblog template tags.

This template tag also supports all of the same filtering mechanisms
defined by the mt:Categories tag allowing users to retrieve a count
of the number of comments on a site that meet a certain criteria.

B<Example:>

    <$mt:SiteCategoryCount$>

=for tags multiblog, count, sites, categories

=cut

sub _hdlr_blog_category_count {
    my ( $ctx, $args, $cond ) = @_;
    my ( %terms, %args );
    $ctx->set_blog_load_context( $args, \%terms, \%args )
        or return $ctx->error( $ctx->errstr );
    my $count = MT::Category->count( \%terms, \%args );
    return $ctx->count_format( $count, $args );
}

###########################################################################

=head2 ArchiveCategory

This tag has been deprecated in favor of L<CategoryLabel>.
Returns the label of the current category.

B<Example:>

    <$mt:ArchiveCategory$>

=for tags deprecated

=cut

sub _hdlr_archive_category {
    return &_hdlr_category_label;
}

###########################################################################

=head2 EntryCategory

This tag outputs the main category for the entry. Must be used in an
entry context (entry archive or L<Entries> loop).

All categories can be listed using L<EntryCategories> loop tag.

=cut

sub _hdlr_entry_category {
    my ( $ctx, $args, $cond ) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error();
    my $cat = $e->category;
    return '' unless $cat;
    local $ctx->{__stash}{category} = $e->category;
    &_hdlr_category_label;
}

1;
