# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::Template::Tags::Tag;

use strict;
use warnings;

use MT;
use MT::Util qw( encode_url );
use MT::Request;
use MT::Promise qw( delay );

sub _tags_for_blog {
    my ( $ctx, $terms, $args, $type, $include_private ) = @_;
    my $r = MT::Request->instance;
    my $cache_key
        = 'blog_tag_cache:'
        . ( $include_private ? 'include_private:' : '' )
        . $type;
    my $tag_cache = $r->stash($cache_key) || {};
    my @tags;
    my $cache_id;
    my $all_count;
    my $class = $type eq 'content_type' ? MT->model('cd') : MT->model($type);
    my $datasource
        = $type eq 'content_type' ? 'content_data' : $class->datasource;
    my $content_type_id = $ctx->{__stash}{content_type_id};

    if ( ref $terms->{blog_id} eq 'ARRAY' ) {
        $cache_id = join ',', @{ $terms->{blog_id} };
        $cache_id = '!' . $cache_id if $args->{not}{blog_id};
    }
    else {
        $cache_id = $terms->{blog_id} || 'all';
    }
    $cache_id .= ':' . $content_type_id if $content_type_id;
    if ( !$tag_cache->{$cache_id}{tags} ) {
        require MT::Tag;
        my %temp_terms = %$terms;
        $temp_terms{is_private} = 0 unless $include_private;
        @tags = MT::Tag->load_by_datasource( $datasource,
            {%temp_terms}, {%$args} );
        $tag_cache->{$cache_id} = { tags => \@tags };
        $r->stash( $cache_key, $tag_cache );
    }
    else {
        @tags = @{ $tag_cache->{$cache_id}{tags} };
    }

    if ( !exists $tag_cache->{$cache_id}{min} ) {
        require MT::Entry;
        require MT::ObjectTag;
        my $min = 0;
        my $max = 0;
        foreach my $tag (@tags) {

            #clear cached count
            $tag->{__entry_count} = 0 if exists $tag->{__entry_count};
        }
        my %tags = map { $_->id => $_ } @tags;
        my $ext_terms = $class->terms_for_tags();
        $ext_terms->{content_type_id} = $content_type_id if $content_type_id;

        my $count_iter = $class->count_group_by(
            { ( $ext_terms ? (%$ext_terms) : () ), %$terms, },
            {   group  => ['objecttag_tag_id'],
                'join' => MT::ObjectTag->join_on(
                    'object_id',
                    { object_datasource => $datasource, %$terms }, $args
                ),
                'asset' eq lc $type ? ( no_class => 1 ) : (),
                %$args
            }
        );
        while ( my ( $count, $tag_id ) = $count_iter->() ) {
            $tags{$tag_id}->{__entry_count} = $count;
            $min = $count if ( $count && ( $count < $min ) ) || $min == 0;
            $max = $count if $count && ( $count > $max );
            $all_count += $count;
        }
        $tag_cache->{$cache_id}{min}       = $min;
        $tag_cache->{$cache_id}{max}       = $max;
        $tag_cache->{$cache_id}{all_count} = $all_count;
        $tag_cache->{$cache_id}{tags}      = [] unless $min;
    }
    (   $tag_cache->{$cache_id}{tags},
        $tag_cache->{$cache_id}{min},
        $tag_cache->{$cache_id}{max}
        ),
        $tag_cache->{$cache_id}{all_count};
}

sub _tag_sort {
    my ( $tags, $column, $order ) = @_;
    $column ||= 'name';
    $order ||= ( $column eq 'name' ? 'ascend' : 'descend' );
    no warnings;
    if ( $column eq 'rank' or $column eq 'count' ) {
        @$tags
            = grep { $_->{__entry_count} }
            lc $order eq 'ascend'
            ? sort { $a->{__entry_count} <=> $b->{__entry_count} } @$tags
            : sort { $b->{__entry_count} <=> $a->{__entry_count} } @$tags;
    }
    elsif ( $column eq 'id' ) {
        @$tags = grep { $_->{__entry_count} } lc $order eq 'descend'
            ? sort {
            $b->{column_values}{$column} <=> $a->{column_values}{$column}
            } @$tags
            : sort {
            $a->{column_values}{$column} <=> $b->{column_values}{$column}
            } @$tags;
    }
    else {
        @$tags = grep { $_->{__entry_count} } lc $order eq 'descend'
            ? sort {
            lc $b->{column_values}{name} cmp lc $a->{column_values}{name}
            } @$tags
            : sort {
            lc $a->{column_values}{name} cmp lc $b->{column_values}{name}
            } @$tags;
    }
}

###########################################################################

=head2 Tags

A container tag used for listing all tags in use on the blog in context.

B<Attributes:>

=over 4

=item * glue

A text string that is used to join each of the items together. For example

    <mt:Tags glue=", "><$mt:TagName$></mt:Tags>
    
would print out each tag name separated by a comma and a space.

=item * type

The kind of object for which to show tags. Valid values in a default
installation are C<entry> (the default), C<page>, C<asset>, C<audio>,
C<video> and C<image>. Plugins can extend this to other object classes.

=item * sort_by

The tag object column on which to order the tags. Common values are name and
rank. By default tags are sorted by name.

=item * sort_order

The direction in which to sort tags by the sort_by field. Possible values
are ascend and descend. By default, tags are shown in ascending order
when sorted by name and descending order when sorted by other columns.

=item * limit

A number of tags to show. If given, only the first tags as ordered by
sort_by and sort_order are shown.

=item * top

A number of tags to show. If given, only the given number of tags with
the most uses are shown. For example:

    <mt:Tags top="20">
        <$mt:TagName$>
    </mt:Tags>

is equivalent to

    <mt:Tags limit="20" sort_by="rank">
        <$mt:TagName$>
    </mt:Tags>

Note that even when top is used, the tags are shown in the order specified
with sort_by and sort_order.

=back

The following code is functional on any template. It prints a simple list
of tags for a blog, each linked to a tag search.

    <ul>
        <mt:Tags>
        <li>
            <a href="<$mt:TagSearchLink$>"><$mt:TagName$></a>
        </li>
        </mt:Tags>
    </ul>

Using tags like L<TagRank> and L<TagCount> and proper page styling, you
can make this simple code into a powerful looking and useful "tag cloud".

    <ul>
        <mt:Tags top="20">
        <li class="rank-<$mt:TagRank max="10"$> widget-list-item">
            <a href="<$mt:TagSearchLink$>"><$mt:TagName$></a>
        </li>
        </mt:Tags>
    </ul>

=for tags tags, multiblog, loop

=cut

sub _hdlr_tags {
    my ( $ctx, $args, $cond ) = @_;

    require MT::Tag;
    require MT::ObjectTag;
    require MT::Entry;

    if (   $args->{content_type}
        && $args->{type}
        && $args->{type} ne 'content_type' )
    {
        return $ctx->error(
            MT->translate(
                'content_type modifier cannot be used with type "[_1]".',
                $args->{type}
            )
        );
    }
    my $type
        = $args->{type}         ? $args->{type}
        : $args->{content_type} ? 'content_type'
        :                         MT::Entry->datasource;

    # Include/exclude_sites modifier
    if ( $args->{include_sites} ) {
        $args->{include_blogs} = delete $args->{include_sites};
    }
    if ( $args->{exclude_sites} ) {
        $args->{exclude_blogs} = delete $args->{exclude_sites};
    }

    unless ( $args->{blog_id}
        || $args->{include_blogs}
        || $args->{exclude_blogs} )
    {
        my $app = MT->instance;
        if ( $app->isa('MT::App::Search') ) {
            my $exclude_blogs = $app->{searchparam}{ExcludeBlogs};
            my $include_blogs = $app->{searchparam}{IncludeBlogs};
            if (my $excl
                = ( $exclude_blogs && ( 0 < scalar(@$exclude_blogs) ) )
                ? $exclude_blogs
                : undef
                )
            {
                $args->{exclude_blogs} ||= join ',', @$excl;
            }
            elsif (
                my $incl
                = ( $include_blogs && ( 0 < scalar(@$include_blogs) ) )
                ? $include_blogs
                : undef
                )
            {
                $args->{include_blogs} = join ',', @$incl;
            }
            if ( ( $args->{include_blogs} || $args->{exclude_blogs} )
                && $args->{blog_id} )
            {
                delete $args->{blog_id};
            }
        }
    }

    my ( %blog_terms, %blog_args );
    $ctx->set_blog_load_context( $args, \%blog_terms, \%blog_args )
        or return $ctx->error( $ctx->errstr );
    if ( $type eq 'content_type' ) {
        $ctx->set_content_type_load_context( $args, $cond, \%blog_terms,
            \%blog_args )
            or return;
    }
    local $ctx->{__stash}{content_type_id}
        = delete $blog_terms{content_type_id}
        if $blog_terms{content_type_id};

    my $include_private = defined $args->{include_private}
        && $args->{include_private} == 1 ? 1 : 0;
    my ( $tags, $min, $max, $all_count )
        = _tags_for_blog( $ctx, \%blog_terms, \%blog_args, $type,
        $include_private );
    my $builder = $ctx->stash('builder');
    my $tokens  = $ctx->stash('tokens');
    my $needs_entries
        = ( ( $ctx->stash('uncompiled') || '' ) =~ /<MT:?Entries/i ) ? 1 : 0;
    my $glue = $args->{glue};
    my $res  = '';
    local $ctx->{__stash}{all_tag_count} = undef;
    local $ctx->{inside_mt_tags} = 1;

    if ($needs_entries) {
        foreach my $tag (@$tags) {
            my @args = (
                { status => MT::Entry::RELEASE(), %blog_terms },
                {   sort      => 'authored_on',
                    direction => 'descend',
                    'join'    => MT::ObjectTag->join_on(
                        'object_id',
                        {   tag_id            => $tag->id,
                            object_datasource => $type,
                            %blog_terms
                        },
                        { unique => 1, %blog_args },
                    ),
                    %blog_args,
                }
            );
            $tag->{__entries}
                = delay( sub { my @e = MT::Entry->load(@args); \@e } );
        }
    }

    my $top = $args->{top} || 0;
    my $column
        = $args->{sort_by} ? lc( $args->{sort_by} )
        : $top             ? 'rank'
        :                    'name';
    my $limit = $args->{limit} || 0;
    my @slice_tags;
    if ( $top > 0 && scalar @$tags > $top ) {
        _tag_sort( $tags, 'rank' );
        @slice_tags = @$tags[ 0 .. $top - 1 ];
    }
    else {
        @slice_tags = @$tags;
    }
    _tag_sort( \@slice_tags, $column, $args->{sort_order} || '' );
    if ( $limit > 0 && scalar @slice_tags > $limit ) {
        @slice_tags = @slice_tags[ 0 .. $limit - 1 ];
    }

    local $ctx->{__stash}{include_blogs} = $args->{include_blogs};
    local $ctx->{__stash}{exclude_blogs} = $args->{exclude_blogs};
    local $ctx->{__stash}{blog_ids}      = $args->{blog_ids};
    local $ctx->{__stash}{include_with_website}
        = $args->{include_parent_site} || $args->{include_with_website};
    local $ctx->{__stash}{tag_min_count} = $min;
    local $ctx->{__stash}{tag_max_count} = $max;
    local $ctx->{__stash}{class_type}
        = $type eq 'content_type' ? 'cd' : $type;
    my $vars = $ctx->{__stash}{vars} ||= {};
    my $i = 0;

    foreach my $tag (@slice_tags) {
        $i++;
        local $ctx->{__stash}{Tag}     = $tag;
        local $vars->{__first__}       = $i == 1;
        local $vars->{__last__}        = !defined $slice_tags[$i];
        local $vars->{__odd__}         = ( $i % 2 ) == 1;
        local $vars->{__even__}        = ( $i % 2 ) == 0;
        local $vars->{__counter__}     = $i;
        local $ctx->{__stash}{entries} = $tag->{__entries}
            if exists $tag->{__entries};
        local $ctx->{__stash}{tag_entry_count} = $tag->{__entry_count};
        local $ctx->{__stash}{all_tag_count}   = $all_count;
        defined( my $out = $builder->build( $ctx, $tokens, $cond ) )
            or return $ctx->error( $builder->errstr );
        $res .= $glue if defined $glue && length($res) && length($out);
        $res .= $out;
    }
    $res;
}

###########################################################################

=head2 EntryTags

A container tag used to output infomation about the tags assigned
to the entry in context. This tag's functionality is analogous
to that of L<PageTags>.

To avoid printing out the leading text when no entry tags are assigned you
can use the L<EntryIfTagged> conditional block to first test for entry tags
on the entry. You can also use the L<EntryIfTagged> conditional block with
the tag attribute to test for the assignment of a particular entry tag.

B<Attributes:>

=over 4

=item * glue

A text string that is used to join each of the items together. For example:

    <mt:EntryTags glue=", "><$mt:TagName$></mt:EntryTags>

would print out each tag name separated by a comma and a space.

=item * include_private

A boolean value which controls whether private tags (i.e. tags which start
with @) should be output by the block.  The default is 0 which suppresses
the output of private tags.  If set to 1, the tags will be displayed.  

One example of its use is in publishing a list of related entries to the
current entry.

    <mt:EntryIfTagged>
        <mt:EntryID setvar="curentry">

        <mt:SetVarBlock name="relatedtags">
            <mt:EntryTags include_private="1" glue=" OR ">
                <mt:TagName />
            </mt:EntryTags>
        </mt:SetVarBlock>
        <mt:Var name="relatedtags" strip_linefeeds="1" setvar="relatedtags">

        <mt:SetVarBlock name="listitems">
            <mt:Entries tags="$relatedtags" unique="1">
                <mt:Unless tag="EntryID" eq="$curentry">
                    <li>
                        <a href="<mt:EntryPermalink />">
                            <mt:EntryTitle />
                        </a>
                    </li>
                </mt:Unless>
            </mt:Entries>
       </mt:SetVarBlock>

       <mt:If name="listitems">
          <h3>Related Blog Entries</h3>
          <ul>
             <$mt:Var name="listitems"$>
          </ul>
       </mt:If>
    </mt:EntryIfTagged>

In the code sample above, the related entries list is created using the
entry tags of the entry currently in context, built as a boolean C<OR>
statement for the L<Entries> tag and stored in the C<$relatedtags> MT
template variable.  Without including private tags in that list, you
would miss entries that are similarly tagged on the back end.

=back

B<Example:>

The following code can be used anywhere L<Entries> can be used. It prints
a list of all of the tags assigned to each entry returned by L<Entries>
glued together by a comma and a space.

    <mt:If tag="EntryTags">
        The entry "<$mt:EntryTitle$>" is tagged:
        <mt:EntryTags glue=", "><$mt:TagName$></mt:EntryTags>
    </mt:If>

=for tags tags, entries

=cut

sub _hdlr_entry_tags {
    my ( $ctx, $args, $cond ) = @_;

    require MT::Entry;
    my $entry = $ctx->stash('entry');
    return '' unless $entry;
    my $glue = $args->{glue};

    local $ctx->{__stash}{tag_max_count} = undef;
    local $ctx->{__stash}{tag_min_count} = undef;
    local $ctx->{__stash}{all_tag_count} = undef;

    my $builder = $ctx->stash('builder');
    my $tokens  = $ctx->stash('tokens');
    my $res     = '';
    my $i       = 1;
    my $vars    = $ctx->{__stash}{vars} ||= {};
    my $tags    = $entry->get_tag_objects;
    my @tags    = @$tags;
    if ( !$args->{include_private} ) {
        @tags = grep { !$_->is_private } @tags;
    }
    for my $tag (@tags) {
        local $vars->{__first__}   = $i == 1;
        local $vars->{__last__}    = $i == scalar @tags;
        local $vars->{__odd__}     = ( $i % 2 ) == 1;
        local $vars->{__even__}    = ( $i % 2 ) == 0;
        local $vars->{__counter__} = $i;
        $i++;
        local $ctx->{__stash}{Tag}             = $tag;
        local $ctx->{__stash}{tag_count}       = undef;
        local $ctx->{__stash}{tag_entry_count} = undef;
        defined( my $out = $builder->build( $ctx, $tokens, $cond ) )
            or return $ctx->error( $builder->errstr );
        $res .= $glue if defined $glue && length($res) && length($out);
        $res .= $out;
    }
    $res;
}

###########################################################################

=head2 PageTags

A container tag used to output infomation about the tags assigned
to the page in context. This tag's functionality is analogous
to that of L<EntryTags> and its attributes are identical.

To avoid printing out the leading text when no page tags are assigned you
can use the L<PageIfTagged> conditional block to first test for tags
on the page. You can also use the L<PageIfTagged> conditional block with
the tag attribute to test for the assignment of a particular tag.

B<Attributes:>

=over 4

=item * glue

A text string that is used to join each of the items together. For example:

    <mt:PageTags glue=", "><$mt:TagName$></mt:PageTags>

would print out each tag name separated by a comma and a space.

=item * include_private

A boolean value which controls whether private tags (i.e. tags which start
with @) should be output by the block. The default is 0 which suppresses the
output of private tags. If set to 1, the tags will be displayed. See
L<EntryTags> for an example of its usage.

=back

B<Example:>

Listing out the page's tags, separated by commas:

    <mt:PageTags glue=", "><$mt:TagName$></mt:PageTags>

=for tags pages, tags

=cut

sub _hdlr_page_tags {
    my ( $ctx, $args, $cond ) = @_;

    return undef unless $ctx->check_page;
    require MT::Page;
    $args->{class_type} = MT::Page->properties->{class_type};
    local $ctx->{__stash}{class_type} = $args->{class_type};
    &_hdlr_entry_tags(@_);
}

###########################################################################

=head2 AssetTags

A container tag used to output infomation about the asset tags assigned
to the asset in context. This tag's functionality is analogous
to that of L<EntryTags> and its attributes are identical.

To avoid printing out the leading text when no asset tags are assigned you
can use the L<AssetIfTagged> conditional block to first test for tags
on the asset. You can also use the L<AssetIfTagged> conditional block with
the tag attribute to test for the assignment of a particular tag.

B<Attributes:>

=over 4

=item * glue

A text string that is used to join each of the items together. For example:

    <mt:AssetTags glue=", "><$mt:TagName$></mt:AssetTags>

would print out each tag name separated by a comma and a space.

=item * include_private

A boolean value which controls whether private tags (i.e. tags which start
with @) should be output by the block. The default is 0 which suppresses the
output of private tags. If set to 1, the tags will be displayed. See
L<EntryTags> for an example of its usage.

=back

B<Example:>

The following code can be used anywhere L<Assets> can be used. It prints
a list of all of the tags assigned to each asset returned by L<Assets>
glued together by a comma and a space.

    <mt:If tag="AssetTags">
        The asset "<$mt:AssetLabel$>" is tagged:
        <mt:AssetTags glue=", "><$mt:TagName$></mt:AssetTags>
    </mt:If>

=for tags tags, assets

=cut

sub _hdlr_asset_tags {
    my ( $ctx, $args, $cond ) = @_;

    require MT::ObjectTag;
    require MT::Asset;
    my $asset = $ctx->stash('asset');
    return '' unless $asset;
    my $glue = $args->{glue};

    local $ctx->{__stash}{tag_max_count} = undef;
    local $ctx->{__stash}{tag_min_count} = undef;
    local $ctx->{__stash}{all_tag_count} = undef;
    local $ctx->{__stash}{class_type}    = 'asset';

    my @assets = MT::Tag->load(
        undef,
        {   'sort' => 'name',
            'join' => MT::ObjectTag->join_on(
                'tag_id',
                {   object_id         => $asset->id,
                    blog_id           => $asset->blog_id,
                    object_datasource => MT::Asset->datasource
                },
                { unique => 1 }
            )
        }
    );
    my $builder = $ctx->stash('builder');
    my $tokens  = $ctx->stash('tokens');
    my $res     = '';
    my $i       = 1;
    my $vars    = $ctx->{__stash}{vars} ||= {};

    if ( !$args->{include_private} ) {
        @assets = grep { !$_->is_private } @assets;
    }

    foreach my $tag (@assets) {
        local $ctx->{__stash}{Tag}             = $tag;
        local $ctx->{__stash}{tag_count}       = undef;
        local $ctx->{__stash}{tag_asset_count} = undef;
        local $vars->{__first__}               = $i == 1;
        local $vars->{__last__}                = $i == scalar @assets;
        local $vars->{__odd__}                 = ( $i % 2 ) == 1;
        local $vars->{__even__}                = ( $i % 2 ) == 0;
        local $vars->{__counter__}             = $i;
        $i++;
        defined( my $out = $builder->build( $ctx, $tokens, $cond ) )
            or return $ctx->error( $builder->errstr );
        $res .= $glue if defined $glue && length($res) && length($out);
        $res .= $out;
    }

    return $res;
}

###########################################################################

=head2 EntryIfTagged

Conditional tag used to test whether the current entry in context has
been assigned tags, or if it is assigned a specific tag.

B<Attributes:>

=over 4

=item * tag or name

If either 'name' or 'tag' are specified, tests the entry in context
for whether it has a tag association by that name.

=item * include_private

A boolean value which controls whether private tags (i.e. tags which start
with @) should be output by the block. The default is 0 which suppresses the
output of private tags. If set to 1, the tags will be displayed. See
L<EntryTags> for an example of its usage.

=back

=for tags tags, entries

=cut

sub _hdlr_entry_if_tagged {
    my ( $ctx, $args, $cond ) = @_;
    my $entry = $ctx->stash('entry');
    return 0 unless $entry;
    my $tag
        = defined $args->{name}
        ? $args->{name}
        : ( defined $args->{tag} ? $args->{tag} : '' );
    if ( $tag ne '' ) {
        $entry->has_tag($tag);
    }
    else {
        my @tags = $entry->tags;
        @tags = grep /^[^@]/, @tags
            if !$args->{include_private};
        return @tags ? 1 : 0;
    }
}

###########################################################################

=head2 PageIfTagged

This template tag evaluates a block of code if a tag has been assigned
to the current entry in context. If the tag attribute is not assigned,
then the template tag will evaluate if any tag is present.

B<Attributes:>

=over 4

=item * tag

If present, the template tag will evaluate if the specified tag is
assigned to the current page.

=item * include_private

A boolean value which controls whether private tags (i.e. tags which start
with @) should be output by the block. The default is 0 which suppresses the
output of private tags. If set to 1, the tags will be displayed. See
L<EntryTags> for an example of its usage.

=back

B<Example:>

    <mt:PageIfTagged tag="Foo">
      <!-- do something -->
    <mt:Else>
      <!-- do something else -->
    </mt:PageIfTagged>

=cut

sub _hdlr_page_if_tagged {
    my ( $ctx, $args, $cond ) = @_;

    return undef unless $ctx->check_page(@_);
    require MT::Page;
    $args->{class_type} = MT::Page->properties->{class_type};
    &_hdlr_entry_if_tagged(@_);
}

###########################################################################

=head2 AssetIfTagged

A conditional tag whose contents will be displayed if the asset in
context has tags.

B<Attributes:>

=over 4

=item * tag or name

If either 'name' or 'tag' are specified, tests the asset in context
for whether it has a tag association by that name.

=item * include_private

A boolean value which controls whether private tags (i.e. tags which start
with @) should be output by the block. The default is 0 which suppresses the
output of private tags. If set to 1, the tags will be displayed. See
L<EntryTags> for an example of its usage.

=back

=for tags assets, tags

=cut

sub _hdlr_asset_if_tagged {
    my ( $ctx, $args ) = @_;
    my $a = $ctx->stash('asset')
        or return $ctx->_no_asset_error();

    my $tag
        = defined $args->{name}
        ? $args->{name}
        : ( defined $args->{tag} ? $args->{tag} : '' );
    if ( $tag ne '' ) {
        $a->has_tag($tag);
    }
    else {
        my @tags = $a->tags;
        @tags = grep /^[^@]/, @tags
            if !$args->{include_private};
        return @tags ? 1 : 0;
    }
}

###########################################################################

=head2 TagSearchLink

A variable tag that outputs a link to a tag search for the entry tag in
context. This tag can be used whenever a tag context is present (e.g.
within an L<Tags>, L<EntryTags>, L<PageTags> or L<AssetTags> block.

Like all variable tags, you can apply any of the supported global modifiers
to L<TagSearchLink> to do further transformations.

The example below shows each tag in a cloud tag linked to a search for other
entries with that tag assigned.

    <h1>Tag cloud</h1>
    <div id="tagcloud">
        <mt:Tags>
            <h<$mt:TagRank$>>
                <a href="<$mt:TagSearchLink$>"><$mt:TagName$></a>
            </h<$mt:TagRank$>>
        </mt:Tags>
    </div>

The search link will look something like:

    http://example.com/mt/mt-search.cgi?blog_id=1&tag=politics

Using Apache rewriting, the search URL can be cleaned up to look
something like:

    http://example.com/tag/politics

A URL like this would have to be built like this:

    <$mt:BlogURL$>tag/<$mt:TagName normalize="1"$>

And of course, you would have to create the .htaccess rules to translate
this into a request to mt-search.cgi.

B<Attributes:>

=over 4

=item * tmpl_blog_id

If present, the template tag will add 'blog_id' parameter for a link.

=back

=for tags tags, multiblog

=cut

sub _hdlr_tag_search_link {
    my ( $ctx, $args, $cond ) = @_;
    my $tag = $ctx->stash('Tag');
    return '' unless $tag;

    my ( %blog_terms, %blog_args );
    unless ( $args->{blog_id}
        || $args->{include_blogs}
        || $args->{exclude_blogs} )
    {
        $args->{include_blogs}        = $ctx->stash('include_blogs');
        $args->{exclude_blogs}        = $ctx->stash('exclude_blogs');
        $args->{blog_ids}             = $ctx->stash('blog_ids');
        $args->{include_with_website} = $ctx->stash('include_with_website');
    }
    $ctx->set_blog_load_context( $args, \%blog_terms, \%blog_args )
        or return $ctx->error( $ctx->errstr );

    my $param = '';
    my $blogs = $blog_terms{blog_id};

    my $template_blog_id;
    if ( defined $args->{tmpl_blog_id} ) {
        $template_blog_id = $args->{tmpl_blog_id};
        return $ctx->error(
            MT->translate( 'Invalid [_1] parameter.', 'tmpl_blog_id' ) )
            if ( $template_blog_id !~ m/^\d+$/ ) || !$template_blog_id;
    }
    else {
        if ( my $blog = $ctx->stash('blog') ) {
            $template_blog_id = $blog->id
                if !$blog->is_blog;
        }
    }

    if ($blogs) {
        if ( ref $blogs eq 'ARRAY' ) {
            if ( $blog_args{not}{blog_id} ) {
                $param .= 'ExcludeBlogs=' . join( ',', @$blogs );
            }
            else {
                $param .= 'IncludeBlogs=' . join( ',', @$blogs );
            }
        }
        else {
            $param .= 'IncludeBlogs=' . $blogs;
        }
        $param .= '&amp;';
    }
    $param .= 'tag=' . encode_url( $tag->name );
    $param .= '&amp;limit=' . $ctx->{config}->MaxResults;
    $param .= '&amp;blog_id=' . $template_blog_id if $template_blog_id;
    my $path = $ctx->cgi_path;
    $path . $ctx->{config}->SearchScript . '?' . $param;
}

###########################################################################

=head2 TagRank

A variable tag which returns a number from 1 to 6 (by default) which
represents the rating of the entry tag in context in terms of usage
where '1' is used for the most often used tags, '6' for the least often.
This tag can be used anytime a tag context exists (e.g. within an L<Tags>,
L<EntryTags>, L<PageTags> or L<AssetTags> block).

This is suitable for creating "tag clouds" in which L<TagRank> can
determine what level of header (h1 - h6) to apply to the tag.

B<Attributes:>

=over 4

=item * max (optional; default "6")

Allows a user to specify the upper bound of the scale.

=back

The following is a very basic tag cloud suitable for an index template or,
with some styling, a sidebar of any page.

    <h1>Tag cloud</h1>
    <div id="tagcloud">
        <mt:Tags>
            <h<$mt:TagRank$>>
                <a href="<$mt:TagSearchLink$>"><$mt:TagName$></a>
            </h<$mt:TagRank$>>
        </mt:Tags>
    </div>

=for tags multiblog

=for tags tags

=cut

sub _hdlr_tag_rank {
    my ( $ctx, $args, $cond ) = @_;

    my $max_level = $args->{max} || 6;
    unless ( $args->{blog_id}
        || $args->{include_blogs}
        || $args->{exclude_blogs} )
    {
        $args->{include_blogs}        = $ctx->stash('include_blogs');
        $args->{exclude_blogs}        = $ctx->stash('exclude_blogs');
        $args->{blog_ids}             = $ctx->stash('blog_ids');
        $args->{include_with_website} = $ctx->stash('include_with_website');
    }
    my ( %blog_terms, %blog_args );
    $ctx->set_blog_load_context( $args, \%blog_terms, \%blog_args )
        or return $ctx->error( $ctx->errstr );

    my $tag = $ctx->stash('Tag');
    return '' unless $tag;

    my $class_type = $ctx->stash('class_type')
        || 'entry';    # FIXME: defaults to?
    my $class     = MT->model($class_type);
    my $ds        = $class->datasource;
    my $ext_terms = $class->terms_for_tags();

    my $ntags = $ctx->stash('all_tag_count');
    my $min   = $ctx->stash('tag_min_count');
    my $max   = $ctx->stash('tag_max_count');
    unless ( defined $min && defined $max && $ntags ) {
        ( undef, $min, $max, $ntags )
            = _tags_for_blog( $ctx, \%blog_terms, \%blog_args, $class_type );
        $ctx->stash( 'tag_max_count', $max );
        $ctx->stash( 'tag_min_count', $min );
        $ctx->stash( 'all_tag_count', $ntags );
    }
    return 1 unless $ntags;
    my $factor;

    if ( $max - $min == 0 ) {
        $min -= $max_level;
        $factor = 1;
    }
    else {
        $factor = ( $max_level - 1 ) / log( $max - $min + 1 );
    }

    if ( $ntags < $max_level ) {
        $factor *= ( $ntags / $max_level );
    }

    my $terms = $class->terms_for_tags() || {};
    my $count = $class->tagged_count( $tag->id, { %$terms, %blog_terms } );

    if ( $count - $min + 1 == 0 ) {
        return 0;
    }

    my $level = int( log( $count - $min + 1 ) * $factor );
    $max_level - $level;
}

###########################################################################

=head2 TagLabel

An alias for the 'TagName' tag.

=cut

###########################################################################

=head2 TagName

Outputs the name of the current tag in context.

B<Attributes:>

=over 4

=item * normalize (optional; default "0")

If specified, outputs the "normalized" form of the tag. A normalized
tag has been stripped of any spaces and punctuation and is only
lowercase.

=back

=over 4

=item * quote (optional; default "0")

If specified, causes any tag with spaces in it to be wrapped in quote
marks.

=back

=for tags tags

=cut

sub _hdlr_tag_name {
    my ( $ctx, $args, $cond ) = @_;
    my $tag = $ctx->stash('Tag');
    return '' unless $tag;
    my $name = defined $tag->name && $tag->name ne '' ? $tag->name : '';
    if ( $args->{quote} && $name =~ m/ / ) {
        $name = '"' . $name . '"';
    }
    elsif ( $args->{normalize} ) {
        $name = MT::Tag->normalize($name);
    }
    $name;
}

###########################################################################

=head2 TagID

Outputs the numeric ID of the tag currently in context.

=for tags tags

=cut

sub _hdlr_tag_id {
    my ( $ctx, $args, $cond ) = @_;
    my $tag = $ctx->stash('Tag');
    return '' unless $tag;
    $tag->id;
}

###########################################################################

=head2 TagCount

Returns the number of entries that have been tagged with the current tag
in context.

=for tags tags, count

=cut

sub _hdlr_tag_count {
    my ( $ctx, $args, $cond ) = @_;
    my $count      = $ctx->stash('tag_entry_count');
    my $tag        = $ctx->stash('Tag');
    my $blog_id    = $ctx->stash('blog_id');
    my $class_type = $ctx->stash('class_type')
        || 'entry';    # FIXME: defaults to?
    my $class = MT->model($class_type);
    my %term
        = $class_type eq 'entry' || $class_type eq 'page'
        ? ( status => MT::Entry::RELEASE() )
        : ();
    if ( $tag && $class ) {

        unless ( defined $count ) {
            $count = $class->tagged_count( $tag->id,
                { %term, blog_id => $blog_id } );
        }
    }
    $count ||= 0;
    return $ctx->count_format( $count, $args );
}

1;
