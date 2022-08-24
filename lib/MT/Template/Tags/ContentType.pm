# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Template::Tags::ContentType;

use strict;
use warnings;

use MT;
use MT::ContentData;
use MT::ContentField;
use MT::ContentStatus;
use MT::ContentType;
use MT::Util qw( offset_time_list encode_html remove_html );
use MT::Util::ContentType;
use MT::Template::Tags::Common;

=head2 Contents

The Contents tag is a workhorse of MT publishing. It is used for
publishing a selection of contents in a variety of situations. Typically,
the basic use (specified without any attributes) outputs the selection
of contents that are appropriate for the page being published. But you
can use this tag for publishing custom modules, index templates and
widgets to select content in many different ways.

=cut

=head2 ContentsHeader

The contents of this container tag will be displayed when the first
content listed by a L<Contents> tag is reached.

=for tags contents

=cut

=head2 ContentsFooter

The contents of this container tag will be displayed when the last
content listed by a L<Contentss> tag is reached.

=for tags contents 

=cut

sub _hdlr_contents {
    my ( $ctx, $args, $cond ) = @_;

    my $at = $ctx->{current_archive_type} || $ctx->{archive_type};
    my $archiver = MT->publisher->archiver($at);
    my $blog_id
        = $args->{site_id} || $args->{blog_id} || $ctx->stash('blog_id');
    my $blog = $ctx->stash('blog');

    return $ctx->_no_site_error unless $blog_id;

    my ( @filters, %terms, %args, %blog_terms, %blog_args );
    %terms = %blog_terms = ( blog_id => $blog_id );

    my $content_type = _get_content_type( $ctx, $args, \%blog_terms )
        or return;
    my $content_type_id
        = scalar(@$content_type) == 1
        ? $content_type->[0]->id
        : [ map { $_->id } @$content_type ];

    my $class          = MT->model('content_data');
    my $cat_class_type = 'category';
    my $cat_class      = MT->model($cat_class_type);

    my %fields;
    foreach my $arg ( keys %$args ) {
        if ( $arg =~ m/^field:(.+)$/ ) {
            $fields{$1} = $args->{$arg};
        }
    }

    my $use_stash = 1;

    # For the stock Contents tags, clear any prepopulated
    # contents list (placed by archive publishing) if we're invoked
    # with any of the following attributes. A plugin tag may
    # prepopulate the contents stash and then invoke this handler
    # to permit further filtering of the contents.
    my $tag = lc $ctx->stash('tag');
    if ( $tag eq 'contents' && exists( $args->{'author'} ) ) {
        $use_stash = 0;
    }
    if ($use_stash) {
        foreach my $args_key (
            'id',           'blog_id',
            'site_id',      'unique_id',
            'content_type', 'days',
            'include_subcategories',

            # 'include_blogs',
            # 'exclude_blogs',
            # 'blog_ids',
            # 'include_websites',
            # 'exclude_websites',
            # 'site_ids',
            # 'include_sites',
            # 'exclude_sites',
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

    my $archive_contents;
    if ($use_stash) {
        $archive_contents = $ctx->stash('contents');
        if (  !$archive_contents
            && $archiver
            && $archiver->contenttype_group_based )
        {
            $archive_contents
                = $archiver->archive_group_contents( $ctx, $args,
                $content_type_id );
        }
    }
    if ( $archive_contents && scalar @$archive_contents ) {
        my $content = @$archive_contents[0];
        if ( !$content->isa($class) ) {

            # class types do not match; we can't use stashed contents
            undef $archive_contents;
        }
        elsif ( ( $tag eq 'contents' )
            && $blog_id != $content->blog_id )
        {

            # Blog ID do not match; we can't use stashed contents
            undef $archive_contents;
        }
    }

    local $ctx->{__stash}{contents};

    # handle automatic offset based on 'offset' query parameter
    # in case we're invoked through mt-view.cgi or some other
    # app.
    if ( ( $args->{offset} || '' ) eq 'auto' ) {
        $args->{offset} = 0;
        if ( ( $args->{limit} ) && ( my $app = MT->instance ) ) {
            if ( $app->isa('MT::App') ) {
                if ( my $offset = $app->param('offset') ) {
                    $args->{offset} = $offset;
                }
            }
        }
    }

    delete $args->{limit}
        if exists $args->{limit} && $args->{limit} eq 'none';

    $terms{status} = MT::ContentStatus::RELEASE();

    my $map
        = $archiver
        ? $archiver->get_preferred_map(
        {   blog_id         => $blog_id,
            content_type_id => $content_type_id,
            map             => $ctx->stash('template_map'),
        }
        )
        : $ctx->stash('template_map');

    if (  !$archive_contents
        && $map
        && ( my $cat_field = $map->cat_field ) )
    {
        my $cat
            = $ctx->{inside_mt_categories}
            ? $ctx->stash('category')
            : $ctx->stash('archive_category');
        if ( $cat && $cat->class eq $cat_class_type ) {
            my $has_same_field = exists $fields{ $cat_field->name }
                || exists $fields{ $cat_field->unique_id };
            push @{ $args{joins} },
                MT::ContentFieldIndex->join_on(
                'content_data_id',
                {   content_field_id => $cat_field->id,
                    value_integer    => $cat->id
                },
                { alias => 'cat_cf_idx' }
                ) unless $has_same_field;
        }
    }

    # Adds an author filter to the filters list.
    my $author;
    if ( my $author_name = $args->{author} ) {
        require MT::Author;
        $author = MT::Author->load( { name => $author_name } )
            or return $ctx->error(
            MT->translate( "No such user '[_1]'", $author_name ) );
    }
    elsif ( $archiver && $archiver->contenttype_author_based ) {
        $author = $ctx->stash('author');
    }
    if ($author) {
        if ($archive_contents) {
            push @filters, sub { $_[0]->author_id == $author->id };
        }
        else {
            $terms{author_id} = $author->id;
        }
    }

    # Adds an ID filter to the filter list.
    foreach my $id (qw/ id unique_id /) {
        if (( my $target_id = $args->{$id} )
            && (   ref( $args->{$id} )
                || ( $id eq 'id' && $args->{$id} =~ m/^[0-9]+$/ )
                || ( $id eq 'unique_id' ) )
            )
        {
            if ($archive_contents) {
                if ( ref $target_id eq 'ARRAY' ) {
                    my %ids = map { $_ => 1 } @$target_id;
                    push @filters, sub { exists $ids{ $_[0]->id } };
                }
                else {
                    push @filters, sub { $_[0]->id == $target_id };
                }
            }
            else {
                $terms{$id} = $target_id;
            }
        }
    }

    my $published = $ctx->{__stash}{content_ids_published} ||= {};
    if ( $args->{unique} ) {
        push @filters, sub { !exists $published->{ $_[0]->id } }
    }

    $terms{content_type_id} = $content_type_id;

    my $namespace        = $args->{namespace};
    my $no_resort        = 0;
    my $post_sort_limit  = 0;
    my $post_sort_offset = 0;
    my @contents;
    if ( !$archive_contents ) {
        my ( $start, $end )
            = ( $ctx->{current_timestamp}, $ctx->{current_timestamp_end} );
        if ((   !$archiver || ( $archiver->contenttype_based
                    || $archiver->contenttype_group_based )
            )
            && $start
            && $end
            )
        {
            if ( $map && ( my $dt_field_id = $map->dt_field_id ) ) {
                push @{ $args{joins} },
                    MT::ContentFieldIndex->join_on(
                    'content_data_id',
                    [   { content_field_id => $dt_field_id },
                        '-and',
                        [   {   value_datetime =>
                                    { op => '>=', value => $start }
                            },
                            '-and',
                            {   value_datetime =>
                                    { op => '<=', value => $end }
                            }
                        ],
                    ],
                    { alias => 'dt_cf_idx' }
                    );
            }
            else {
                $terms{authored_on} = [ $start, $end ];
                $args{range_incl}{authored_on} = 1;
            }
        }
        if ( my $days = $args->{days} ) {
            my $dt_field_id = 0;
            my $dt_field    = '';

            if ( my $arg = $args->{date_field} ) {
                if (   $arg eq 'authored_on'
                    || $arg eq 'modified_on'
                    || $arg eq 'created_on' )
                {
                    $dt_field = $arg;
                }
                else {
                    my $date_cf = MT->model('cf')->load_by_id_or_name($arg);
                    if ($date_cf) {
                        $dt_field_id = $date_cf->id;
                    }
                }
            }

            unless ( $dt_field || $dt_field_id ) {
                if ($map) {
                    $dt_field_id = $map->dt_field_id;
                }
                unless ($dt_field_id) {
                    $dt_field = 'authored_on';
                }
            }

            my @ago
                = MT::Util::offset_time_list( time - 3600 * 24 * $days,
                $blog_id );
            my $ago = sprintf "%04d%02d%02d%02d%02d%02d",
                $ago[5] + 1900, $ago[4] + 1, @ago[ 3, 2, 1, 0 ];
            if ($dt_field_id) {
                push @{ $args{joins} },
                    MT::ContentFieldIndex->join_on(
                    'content_data_id',
                    [   { content_field_id => $dt_field_id },
                        '-and',
                        { value_datetime => { op => '>=', value => $ago } },
                    ],
                    { alias => 'dt_cf_idx' }
                    );
            }
            else {
                $terms{$dt_field} = [$ago];
                $args{range_incl}{$dt_field} = 1;
            }
        }

        my $sort_by_cf = 0;
        if ( ( my $sort_by = $args->{sort_by} ) || $map && $map->dt_field ) {
            my $cf;
            if ( !$sort_by ) {
                $cf = $map->dt_field;
            }
            elsif ( $sort_by =~ m/^field:.*$/ ) {
                my ( $prefix, $value ) = split ':', $sort_by, 2;
                $cf = _search_content_field(
                    {   content_type_id   => $content_type_id,
                        name_or_unique_id => $value,
                    }
                );
            }
            if ($cf) {
                my $data_type = MT->registry('content_field_types')
                    ->{ $cf->type }{data_type};
                my $join = MT->model('cf_idx')->join_on(
                    'content_data_id',
                    undef,
                    {   sort      => 'value_' . $data_type,
                        direction => $args->{sort_order} || 'descend',
                        alias     => 'cf_idx_' . $cf->id,
                        type      => 'left',
                        condition => {
                            content_data_id  => \'= cd_id',
                            content_field_id => $cf->id,
                        },
                    }
                );
                if ( $args{join} ) {
                    push @{ $args{joins} }, $args{join};
                    push @{ $args{joins} }, $join;
                    delete $args{join};
                }
                elsif ( $args{joins} ) {
                    push @{ $args{joins} }, $join;
                }
                else {
                    push @{ $args{joins} }, $join;
                }
                $sort_by_cf = 1;
                $no_resort  = 1;
            }
            if ( !$sort_by_cf && $sort_by ) {
                if ( $class->is_meta_column($sort_by) ) {
                    $no_resort = 0;
                }
                elsif ( $class->has_column($sort_by) ) {
                    $args{sort} = $sort_by;
                    $no_resort = 1;
                }
            }
        }

        unless ( exists $args{sort} || $sort_by_cf ) {
            $args{sort} = 'authored_on';
        }

        if (%fields) {
            my $field_ct = 0;
            foreach my $key ( keys %fields ) {
                $field_ct++;
                my $value = $fields{$key};
                my $cf    = _search_content_field(
                    {   content_type_id   => $content_type_id,
                        name_or_unique_id => $key,
                    }
                );
                my $type      = $cf->type;
                my $data_type = MT->registry('content_field_types')
                    ->{ $cf->type }{data_type};
                if ( $type eq 'categories' ) {
                    my $category_arg = $value;
                    my ( $cexpr, $cats );
                    if ( ref $category_arg ) {
                        my $is_and = ( shift @{$category_arg} ) eq 'AND';
                        $cats  = [ @{ $category_arg->[0] } ];
                        $cexpr = $ctx->compile_category_filter(
                            undef, $cats,
                            {   'and'    => $is_and,
                                children => $cat_class_type eq 'category'
                                ? ( $args->{include_subcategories}
                                    ? 1
                                    : 0
                                    )
                                : ( $args->{include_subfolders} ? 1 : 0 )
                            }
                        );
                    }
                    else {
                        my $category_set_id = \'> 0';
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
                                $cat_class_type, $category_set_id );
                            if (@cats) {
                                $cats = \@cats;
                            }
                            $cexpr
                                = $ctx->compile_category_filter(
                                $category_arg, $cats );
                        }
                        else {
                            my @cats = $cat_class->load(
                                {   %blog_terms,
                                    category_set_id => $category_set_id,
                                },
                                \%blog_args,
                            );
                            if (@cats) {
                                $cats = \@cats;
                            }
                            $cexpr = $ctx->compile_category_filter(
                                $category_arg,
                                $cats,
                                {   children => $cat_class_type eq 'category'
                                    ? ( $args->{include_subcategories}
                                        ? 1
                                        : 0
                                        )
                                    : ( $args->{include_subfolders}
                                        ? 1
                                        : 0
                                    )
                                }
                            );
                        }
                    }
                    if ($cexpr) {
                        my @cat_ids = map { $_->id } @$cats;
                        my $preloader = sub {
                            my ($cd) = @_;
                            my @c_ids
                                = grep { $cd->is_in_category($_) } @$cats;
                            my %map;
                            $map{ $_->id } = 1 for @c_ids;
                            \%map;
                        };
                        if ( !$archive_contents ) {
                            if ( $category_arg !~ m/\bNOT\b/i ) {
                                return
                                    MT::Template::Context::_hdlr_pass_tokens_else(
                                    @_)
                                    unless @cat_ids;
                                my $join = MT->model('cf_idx')->join_on(
                                    'content_data_id',
                                    {   content_field_id => $cf->id,
                                        value_integer    => \@cat_ids
                                    },
                                    { alias => "cat_cf_idx_$field_ct" }
                                );
                                push @{ $args{joins} }, $join;
                            }
                        }
                        push @filters,
                            sub { $cexpr->( $preloader->( $_[0] ) ) };
                    }
                    else {
                        return $ctx->error(
                            MT->translate(
                                "You have an error in your '[_2]' attribute: [_1]",
                                $category_arg,
                                $key
                            )
                        );
                    }
                }
                elsif ( $type eq 'tags' ) {
                    require MT::Tag;
                    require MT::ObjectTag;

                    my $tag_arg = $value;
                    my $terms;
                    if ( $tag_arg !~ m/\b(AND|OR|NOT)\b|\(|\)/i ) {
                        my @tags = MT::Tag->split( ',', $tag_arg );
                        $terms = { name => \@tags };
                        $tag_arg = join " or ", @tags;
                    }
                    my $tags = [
                        MT::Tag->load(
                            $terms,
                            {   (   $terms
                                    ? ( binary => { name => 1 } )
                                    : ()
                                ),
                                join => MT::ObjectTag->join_on(
                                    'tag_id',
                                    {   object_datasource => 'content_data',
                                        %blog_terms,
                                    },
                                    { %blog_args, unique => 1 }
                                ),
                            }
                        )
                    ];
                    my $cexpr = $ctx->compile_tag_filter( $tag_arg, $tags );
                    if ($cexpr) {
                        my @tag_ids = map {
                            $_->id,
                                ( $_->n8d_id ? ( $_->n8d_id ) : () )
                        } @$tags;
                        my $preloader = sub {
                            my ($cd_id) = @_;
                            my %map;
                            return \%map unless @tag_ids;
                            my $terms = {
                                tag_id            => \@tag_ids,
                                object_id         => $cd_id,
                                object_datasource => 'content_data',
                                %blog_terms,
                            };
                            my $args = {
                                %blog_args,
                                fetchonly   => ['tag_id'],
                                no_triggers => 1
                            };
                            my @ot_ids;
                            @ot_ids = MT::ObjectTag->load( $terms, $args )
                                if @tag_ids;
                            $map{ $_->tag_id } = 1 for @ot_ids;
                            \%map;
                        };
                        if ( !$archive_contents ) {
                            if ( $tag_arg !~ m/\bNOT\b/i ) {
                                return
                                    MT::Template::Context::_hdlr_pass_tokens_else(
                                    @_)
                                    unless @tag_ids;
                                $args{join} = MT::ObjectTag->join_on(
                                    'object_id',
                                    {   tag_id            => \@tag_ids,
                                        object_datasource => 'content_data',
                                        %blog_terms
                                    },
                                    { %blog_args, unique => 1 }
                                );
                            }
                        }
                        push @filters,
                            sub { $cexpr->( $preloader->( $_[0]->id ) ) };
                    }
                    else {
                        return $ctx->error(
                            MT->translate(
                                "You have an error in your '[_2]' attribute: [_1]",
                                $tag_arg,
                                'tag'
                            )
                        );
                    }
                }
                else {
                    my $join = MT->model('cf_idx')->join_on(
                        'content_data_id',
                        {   content_field_id      => $cf->id,
                            'value_' . $data_type => $value,
                        },
                        { alias => 'cf_idx_' . $cf->id }
                    );
                    if ( $args{join} ) {
                        push @{ $args{joins} }, $args{join};
                        push @{ $args{joins} }, $join;
                        delete $args{join};
                    }
                    elsif ( $args{joins} ) {
                        push @{ $args{joins} }, $join;
                    }
                    else {
                        push @{ $args{joins} }, $join;
                    }
                }
            }
        }

        if ( !@filters ) {
            unless ($sort_by_cf) {
                if ( $args{sort} and $args{sort} eq 'authored_on' ) {
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
            }
            $no_resort = 1 unless $args->{sort_by};
            if (   ( exists $args->{limit} )
                && ( my $last = $args->{limit} ) )
            {
                $args{limit} = $last;
            }
            $args{offset} = $args->{offset} if $args->{offset};

            @contents = $class->load( \%terms, \%args );
        }
        else {
            $args{direction} = $args->{sort_order} || 'descend'
                unless $sort_by_cf;
            $no_resort = 1 unless $args->{sort_by};
            my $iter;

            $iter = $class->load_iter( \%terms, \%args );

            my $i   = 0;
            my $j   = 0;
            my $off = $args->{offset} || 0;
            my $n   = $args->{limit};
            my %seen;
        CONTENT_DATA: while ( my $c = $iter->() ) {
                for (@filters) {
                    next CONTENT_DATA unless $_->($c);
                }
                next if $off && $j++ < $off;
                next if $seen{ $c->id }++;
                push @contents, $c;
                $i++;
                $iter->end, last if $n && $i >= $n;
            }
        }
    }
    else {

        # Don't resort a predefined list that's not in a published archive
        # page when we didn't request sorting.
        if (   $args->{sort_by}
            || $args->{sort_order}
            || ( $ctx->{archive_type} && !$ctx->stash('parent_content') ) )
        {
            my $so
                = $args->{sort_order}
                || ( $blog ? $blog->sort_order_posts : undef )
                || '';
            $so = $so eq 'ascend' ? 1 : -1;
            if ( !$args->{sort_by} && $map && ( my $cf = $map->dt_field ) ) {
                my $cf_id = $cf->id;
                if ( $cf->data_type =~ /^(integer|float|double)$/ ) {
                    @$archive_contents = sort {
                        $so
                            * ( ( $a->data->{$cf_id} || 0 )
                            <=> ( $b->data->{$cf_id} || 0 ) )
                    } @$archive_contents;
                }
                else {
                    @$archive_contents = sort {
                        my $a_field = $a->data->{$cf_id};
                        my $b_field = $b->data->{$cf_id};
                        $a_field = '' unless defined $a_field;
                        $b_field = '' unless defined $b_field;
                        $so * ( $a_field cmp $b_field );
                    } @$archive_contents;
                }
                $no_resort = 1;
            }
            else {
                my $col = $args->{sort_by} || 'authored_on';
                if ( my $def = $class->column_def($col) ) {
                    if ( $def->{type} =~ m/^integer|float|double$/ ) {
                        @$archive_contents
                            = sort { $so * ( $a->$col() <=> $b->$col() ) }
                            @$archive_contents;
                    }
                    else {
                        @$archive_contents
                            = sort { $so * ( $a->$col() cmp $b->$col() ) }
                            @$archive_contents;
                    }
                    $no_resort = 1;
                }
                else {
                    if ( $class->is_meta_column($col) ) {
                        my $type = MT::Meta->metadata_by_name( $class, $col );
                        no warnings;
                        if ( $type->{type} =~ m/integer|float|double/ ) {
                            @$archive_contents
                                = sort { $so * ( $a->$col() <=> $b->$col() ) }
                                @$archive_contents;
                        }
                        else {
                            @$archive_contents
                                = sort { $so * ( $a->$col() cmp $b->$col() ) }
                                @$archive_contents;
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
            my $n   = $args->{limit};
        CONTENT_DATA2: foreach my $c (@$archive_contents) {
                for (@filters) {
                    next CONTENT_DATA2 unless $_->($c);
                }
                next if $off && $j++ < $off;
                push @contents, $c;
                $i++;
                last if $n && $i >= $n;
            }
        }
        else {
            my $offset;
            if ( $offset = $args->{offset} ) {
                if ( $offset < scalar @$archive_contents ) {
                    @contents
                        = @$archive_contents[ $offset ..
                        $#$archive_contents ];
                }
                else {
                    @contents = ();
                }
            }
            else {
                @contents = @$archive_contents;
            }
        }
    }

    my $i       = 0;
    my $res     = '';
    my $tok     = $ctx->stash('tokens');
    my $builder = $ctx->stash('builder');

    if ( !$no_resort && @contents ) {
        my $col = $args->{sort_by} || 'authored_on';
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
        if ( $col =~ /^field:(.+)$/ ) {
            my $cf_arg = $1;
            my $cf     = _search_content_field(
                {   content_type_id   => $content_type_id,
                    name_or_unique_id => $cf_arg,
                }
            );
            my $cf_data_type = $cf ? $cf->data_type : '';
            if ( $cf_data_type =~ /^(integer|float|double)$/ ) {
                $func = sub {
                    ( $a->data->{ $cf->id } || 0 )
                        <=> ( $b->data->{ $cf->id } || 0 );
                };
            }
            elsif ($cf_data_type) {
                $func = sub {
                    my $a_field = $a->data->{ $cf->id };
                    my $b_field = $b->data->{ $cf->id };
                    $a_field = '' unless defined $a_field;
                    $b_field = '' unless defined $b_field;
                    return $so * ( $a_field cmp $b_field );
                    }
            }
        }
        elsif ( $type and $type =~ m/^(integer|float|double)$/ ) {
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
            @contents = sort $func @contents;
        }
    }

    my $glue = $args->{glue};
    my $vars = $ctx->{__stash}{vars} ||= {};
    local $ctx->{__stash}{contents}
        = ( @contents && defined $contents[0] ) ? \@contents : undef;
    for my $content_data (@contents) {
        local $vars->{__first__}       = !$i;
        local $vars->{__last__}        = !defined $contents[ $i + 1 ];
        local $vars->{__odd__}         = ( $i % 2 ) == 0;
        local $vars->{__even__}        = ( $i % 2 ) == 1;
        local $vars->{__counter__}     = $i + 1;
        local $ctx->{__stash}{blog}    = $content_data->blog;
        local $ctx->{__stash}{blog_id} = $content_data->blog_id;
        local $ctx->{__stash}{content} = $content_data;

        my $ct_id        = $content_data->content_type_id;
        my $content_type = MT::ContentType->load($ct_id);
        local $ctx->{__stash}{content_type} = $content_type;

        $published->{ $content_data->id }++;
        defined(
            my $out = $builder->build(
                $ctx, $tok,
                {   %{$cond},
                    ContentsHeader => !$i,
                    ContentsFooter => !defined $contents[ $i + 1 ],
                    (   lc $ctx->stash('tag') eq 'contentfield'
                        ? ( ContentFieldHeader => !$i,
                            ContentFieldFooter => !
                                defined $contents[ $i + 1 ],
                            )
                        : ()
                    ),
                }
            )
        ) or return $ctx->error( $builder->errstr );
        $res .= $glue if defined $glue && length($res) && length($out);
        $res .= $out;
        $i++;
    }
    if ( !@contents ) {
        return MT::Template::Context::_hdlr_pass_tokens_else(@_);
    }

    $res;
}

=head2 ContentID

Outputs the numeric ID for the current content in text.

B<Attributes:>

=over 4

=item * pad (optional; default "0")

Adds leading zeros to create a 6 character string. The default is 0 (false). This is equivalent to using the C<zero_pad> global filter with a value of 6.

=back

=cut

sub _hdlr_content_id {
    _check_and_invoke( 'entryid', @_ );
}

=head2 ContentCreatedDate

Outputs the creation date of the current content in context.
See the L<Date> tag for supported attributes.

=for tags date

=cut

sub _hdlr_content_created_date {
    _check_and_invoke( 'entrycreateddate', @_ );
}

=head2 ContentModifiedDate

Outputs the modification date of the current content in context.
See the L<Date> tag for supported attributes.

=for tags date

=cut

sub _hdlr_content_modified_date {
    _check_and_invoke( 'entrymodifieddate', @_ );
}

=head2 ContentUnpublishedDate

Outputs the unpublishing date of the current content in context.
See the L<Date> tag for supported attributes.

=for tags date

=cut

sub _hdlr_content_unpublished_date {
    my ( $ctx, $args, $cond ) = @_;
    my $cd = $ctx->stash('content')
        or return $ctx->_no_content_error();
    $args->{ts} = $cd->unpublished_on or return '';
    return $ctx->build_date($args);
}

=head2 ContentDate

Outputs the 'authored' date of the current content in context.
See the L<Date> tag for supported attributes.

=for tags date

=cut

sub _hdlr_content_date {
    _check_and_invoke( 'entrydate', @_ );
}

=head2 ContentStatus

Intended for application template use only. Displays the status of the
content in context. This will output one of "Draft", "Publish", "Review"
or "Future".

=cut

sub _hdlr_content_status {
    _check_and_invoke( 'entrystatus', @_ );
}

=head2 ContentAuthorDisplayName, ContentModifiedAuthorDisplayName

Outputs the display name of the (last modified) author for the current content in context.
If the author has not provided a display name for publishing, this tag
will output an empty string.

=cut

sub _hdlr_content_author_display_name {
    _check_and_invoke( 'entryauthordisplayname', @_ );
}

sub _hdlr_content_modified_author_display_name {
    _check_and_invoke( 'entrymodifiedauthordisplayname', @_ );
}

=head2 ContentAuthorEmail, ContentModifiedAuthorEmail

Outputs the email address of the (last modified) author for the current content in context.
B<NOTE: it is not recommended to publish e-mail addresses for MT users.>

B<Attributes:>

=over 4

=item * spam_protect (optional; default "0")

If specified, this will apply a light obfuscation of the email address,
by encoding any characters that will identify it as an email address
(C<:>, C<@>, and C<.>) into HTML entities.

=back

=cut

sub _hdlr_content_author_email {
    _check_and_invoke( 'entryauthoremail', @_ );
}

sub _hdlr_content_modified_author_email {
    _check_and_invoke( 'entrymodifiedauthoremail', @_ );
}

=head2 ContentAuthorID, ContentModifiedAuthorID

Outputs the numeric ID of the (last modified) author for the current content in context.

=cut

sub _hdlr_content_author_id {
    _check_and_invoke( 'entryauthorid', @_ );
}

sub _hdlr_content_modified_author_id {
    _check_and_invoke( 'entrymodifiedauthorid', @_ );
}

=head2 ContentAuthorLink, ContentModifiedAuthorLink

Outputs a linked (last modified) author name suitable for publishing in the 'byline'
of a content.

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

sub _hdlr_content_author_link {
    my ( $ctx, $args, $cond ) = @_;
    my $cd = $ctx->stash('content')
        or return $ctx->_no_content_error();
    my $author = $cd->author;
    return '' unless $author;
    __hdlr_content_author_link($ctx, $args, $cond, $author);
}

sub _hdlr_content_modified_author_link {
    my ( $ctx, $args, $cond ) = @_;
    my $cd = $ctx->stash('content')
        or return $ctx->_no_content_error();
    my $author = $cd->modified_author;
    return '' unless $author;
    __hdlr_content_author_link($ctx, $args, $cond, $author);
}

sub __hdlr_content_author_link {
    my ( $ctx, $args, $cond, $author ) = @_;
    my $type = $args->{type} || '';

    if ( $type && $type eq 'archive' ) {
        require MT::Author;
        if ( $author->type == MT::Author::AUTHOR() ) {
            local $ctx->{__stash}{author} = $author;
            local $ctx->{current_archive_type} = undef;
            if (my $link = $ctx->invoke_handler(
                    'archivelink', { type => 'ContentType-Author' },
                    $cond
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

=head2 ContentAuthorURL, ContentModifiedAuthorURL

Outputs the Site URL field from the (last modified) author's profile for the
current content in context.

=cut

sub _hdlr_content_author_url {
    _check_and_invoke( 'entryauthorurl', @_ );
}

sub _hdlr_content_modified_author_url {
    _check_and_invoke( 'entrymodifiedauthorurl', @_ );
}

=head2 ContentAuthorUsername, ContentModifiedAuthorUsername

Outputs the username of the (last modified) author for the content currently in context.
B<NOTE: it is not recommended to publish MT usernames.>

=cut

sub _hdlr_content_author_username {
    _check_and_invoke( 'entryauthorusername', @_ );
}

sub _hdlr_content_modified_author_username {
    _check_and_invoke( 'entrymodifiedauthorusername', @_ );
}

=head2 ContentAuthorUserpic, ContentModifiedAuthorUserpic

Outputs the HTML for the userpic of the (last modified) author for the current content
in context.

=cut

sub _hdlr_content_author_userpic {
    _check_and_invoke( 'entryauthoruserpic', @_ );
}

sub _hdlr_content_modified_author_userpic {
    _check_and_invoke( 'entrymodifiedauthoruserpic', @_ );
}

=head2 ContentAuthorUserpicURL, ContentModifiedAuthorUserpicURL

Outputs the URL for the userpic image of the (last modified) author for the current content
in context.

=cut

sub _hdlr_content_author_userpic_url {
    _check_and_invoke( 'entryauthoruserpicurl', @_ );
}

sub _hdlr_content_modified_author_userpic_url {
    _check_and_invoke( 'entrymodifiedauthoruserpicurl', @_ );
}

=head2 ContentSiteDescription

Returns the site description of the site to which the content in context
belongs. The site description is set in the General Site Settings.

B<Example:>

    <$mt:ContentSiteDescription$>

=for tags sites, contents

=cut

sub _hdlr_content_site_description {
    _check_and_invoke( 'entryblogdescription', @_ );
}

=head2 ContentSiteID

The numeric system ID of the site that is parent to the content currently
in context.

B<Example:>

    <$mt:ContentSiteID$>

=for tags contents, sites

=cut

sub _hdlr_content_site_id {
    _check_and_invoke( 'entryblogid', @_ );
}

=head2 ContentSiteName

Returns the site name of the site to which the content in context belongs.
The site name is set in the General Site Settings.

B<Example:>

    <$mt:ContentSiteName$>

=for tags contents, sites

=cut

sub _hdlr_content_site_name {
    _check_and_invoke( 'entryblogname', @_ );
}

=head2 ContentSiteURL

Returns the site URL for the site to which the content in context belongs.

B<Example:>

    <$mt:ContentSiteURL$>

=for tags sites, contents

=cut

sub _hdlr_content_site_url {
    _check_and_invoke( 'entryblogurl', @_ );
}

=head2 ContentAuthorUserpicAsset, ContentModifiedAuthorUserpicAsset

A block tag providing an asset context for the userpic of the
(last modified) author for the current content in context. See the L<Assets> tag
for more information about publishing assets.

=cut

sub _hdlr_content_author_userpic_asset {
    my ( $ctx, $args, $cond ) = @_;
    my $cd = $ctx->stash('content')
        or return $ctx->_no_content_error();
    my $author = $cd->author;
    return '' unless $author;

    my $asset = $author->userpic or return '';

    my $tok     = $ctx->stash('tokens');
    my $builder = $ctx->stash('builder');

    local $ctx->{__stash}{asset} = $asset;
    return $builder->build( $ctx, $tok, {%$cond} );
}

sub _hdlr_content_modified_author_userpic_asset {
    my ( $ctx, $args, $cond ) = @_;
    my $cd = $ctx->stash('content')
        or return $ctx->_no_content_error();
    my $author = $cd->modified_author;
    return '' unless $author;

    my $asset = $author->userpic or return '';

    my $tok     = $ctx->stash('tokens');
    my $builder = $ctx->stash('builder');

    local $ctx->{__stash}{asset} = $asset;
    return $builder->build( $ctx, $tok, {%$cond} );
}

=head2 ContentUniqueID

Outputs the unique_id field for the current content in context.

=cut

sub _hdlr_content_unique_id {
    my ( $ctx, $args, $cond ) = @_;
    my $cd = $ctx->stash('content')
        or return $ctx->_no_content_error();
    $cd->unique_id;
}

=head2 ContentIdentifier

Outputs the identifier field for the current content in context.

B<Attributes:>

=over 4

=item * separator (optional)

Accepts either "-" or "_". If unspecified, the raw basename value is
returned.

=back

=cut

sub _hdlr_content_identifier {
    my ( $ctx, $args, $cond ) = @_;
    my $cd = $ctx->stash('content')
        or return $ctx->_no_content_error();
    my $identifier = $cd->identifier;
    $identifier = '' unless defined $identifier;
    if ( my $sep = $args->{separator} ) {
        if ( $sep eq '-' ) {
            $identifier =~ s/_/-/g;
        }
        elsif ( $sep eq '_' ) {
            $identifier =~ s/-/_/g;
        }
    }
    $identifier;
}

=head2 ContentsCount

Returns the count of a list of contents that are currently in context
(ie: used in an archive template, or inside an L<Contents> tag). If no
content list context exists, it will fallback to the list that would be
selected for a generic L<Contents> tag (respecting number of days or
contents configured to publish on the blog's main index template).

=for tags count

=cut

sub _hdlr_contents_count {
    my ( $ctx, $args, $cond ) = @_;

    my $count = 0;

    my $contents = $ctx->stash('contents');
    if ($contents) {
        $count = scalar @{$contents};
    }
    else {
        my $by = $args->{by_modified_on} ? 'modified_on' : 'authored_on';

        my %terms = (
            blog_id => $ctx->stash('blog_id'),
            status  => MT::ContentStatus::RELEASE(),
        );
        my %args = (
            sort      => $by,
            direction => 'descend',
        );

        $ctx->set_content_type_load_context( $args, $cond, \%terms, \%args )
            or return;

        $count = MT::ContentData->count( \%terms, \%args );
    }

    $ctx->count_format( $count, $args );
}

=head2 SiteContentCount

Returns the number of published contents associated with the site
currently in context.

=for tags multiblog, count, sites, contents

=cut

sub _hdlr_site_content_count {
    my ( $ctx, $args, $cond ) = @_;
    my ( %terms, %args );
    $ctx->set_content_type_load_context( $args, $cond, \%terms, \%args )
        or return;
    $terms{status} = MT::ContentStatus::RELEASE();
    my $count = MT::ContentData->count( \%terms, \%args );
    return $ctx->count_format( $count, $args );
}

=head2 AuthorContentCount

Returns the number of published contents associated with the author
currently in context.

=for tags authors

=cut

sub _hdlr_author_content_count {
    my ( $ctx, $args, $cond ) = @_;
    my $author = $ctx->stash('author');
    unless ($author) {
        my $cd = $ctx->stash('content');
        $author = $cd->author if $cd;
    }
    return $ctx->_no_author_error() unless $author;

    my ( %terms, %args );
    $ctx->set_content_type_load_context( $args, $cond, \%terms, \%args )
        or return;
    $terms{author_id} = $author->id;
    $terms{status}    = MT::ContentStatus::RELEASE();
    my $count = MT::ContentData->count( \%terms, \%args );
    return $ctx->count_format( $count, $args );
}

=head2 ContentPermalink

TODO: This tag has not been implemented yet.

=cut

sub _hdlr_content_permalink {
    my ( $ctx, $args ) = @_;
    my $c = $ctx->stash('content')
        or return $ctx->_no_content_error();
    my $blog = $ctx->stash('blog');
    my $at = $args->{type} || $args->{archive_type};
    if ($at) {
        return $ctx->error(
            MT->translate(
                "You used an [_1] tag for linking into '[_2]' archives, but that archive type is not published.",
                '<$MTEntryPermalink$>',
                $at
            )
        ) unless $blog->has_archive_type( $at, $c->content_type_id );
    }
    my $link = $c->permalink( $args ? $at : undef,
        { valid_html => $args->{valid_html} } )
        or return $ctx->error( $c->errstr );
    $link = MT::Util::strip_index( $link, $blog )
        unless $args->{with_index};
    $link;
}

=head2 AuthorHasContent

A conditional tag that is true when the author currently in context
has written one or more contents that have been published.

=for tags authors, contents

=cut

sub _hdlr_author_has_content {
    my ( $ctx, $args, $cond ) = @_;
    my $author = $ctx->stash('author')
        or return $ctx->_no_author_error();

    my %terms;
    $terms{blog_id}   = $ctx->stash('blog_id');
    $terms{author_id} = $author->id;
    $terms{status}    = MT::ContentStatus::RELEASE();

    $ctx->set_content_type_load_context( $args, $cond, \%terms )
        or return;

    MT::ContentData->exist( \%terms );
}

=head2 ContentNext

A block tag providing a context for the content immediately following the
current content in context (in terms of authored date).

=cut

sub _hdlr_content_next {
    _hdlr_content_nextprev( 'next', @_ );
}

=head2 ContentPrevious

A block tag providing a context for the content immediately preceding the
current content in context (in terms of authored date).

=cut

sub _hdlr_content_previous {
    _hdlr_content_nextprev( 'previous', @_ );
}

=head2 ContentCalendar

A container tag representing a calendar month that lists a single
calendar "cell" in the calendar display for content.

=for tags calendar

=cut

=head2 CalendarIfContents

A conditional tag that will display its contents if there are any
contents for this day in the site.

=for tags contentcalendar, contents

=cut

=head2 CalendarIfNoContents

A conditional tag that will display its contents if there are not contents
for this day in the site. This tag predates the introduction of L<Else>,
a tag that could be used with L<CalendarIfContents> to replace
C<CalendarIfNoContents>.

=for tags contentcalendar, contents

=cut

sub _hdlr_content_calendar {
    my ( $ctx, $args, $cond ) = @_;
    my $blog_id = $ctx->stash('blog_id');

    my ( %cd_terms, %cd_args );
    $ctx->set_content_type_load_context( $args, $cond, \%cd_terms, \%cd_args )
        or return;

    my $content_type_id = $cd_terms{content_type_id};

    my ($prefix);
    my @ts = MT::Util::offset_time_list( time, $blog_id );
    my $today = sprintf "%04d%02d", $ts[5] + 1900, $ts[4] + 1;
    my $start_with_offset = 0;
    if ( my $start_with = lc( $args->{weeks_start_with} || '' ) ) {
        $start_with_offset = {
            sun => 0,
            mon => 6,
            tue => 5,
            wed => 4,
            thu => 3,
            fri => 2,
            sat => 1,
        }->{ substr( $start_with, 0, 3 ) };

        if ( !defined($start_with_offset) ) {
            return $ctx->error(
                MT->translate(
                    "Invalid weeks_start_with format: must be Sun|Mon|Tue|Wed|Thu|Fri|Sat"
                )
            );
        }
    }
    if ( $prefix = lc( $args->{month} || '' ) ) {
        if ( $prefix eq 'this' ) {
            my $ts = $ctx->{current_timestamp};
            if ( not $ts and ( my $cd = $ctx->stash('content') ) ) {
                $ts = $cd->authored_on();
            }
            if ( not $ts ) {
                return $ctx->error(
                    MT->translate(
                        "You used an [_1] tag without a date context set up.",
                        qq(<MTContentCalendar month="this">)
                    )
                );
            }
            $prefix = substr $ts, 0, 6;
        }
        elsif ( $prefix eq 'last' ) {
            my $year  = substr $today, 0, 4;
            my $month = substr $today, 4, 2;
            if ( $month - 1 == 0 ) {
                $prefix = $year - 1 . "12";
            }
            else {
                $prefix = $year . $month - 1;
            }
        }
        elsif ( $prefix eq 'next' ) {
            my $year  = substr $today, 0, 4;
            my $month = substr $today, 4, 2;
            if ( $month + 1 == 13 ) {
                $prefix = $year + 1 . "01";
            }
            else {
                $prefix = $year . $month + 1;
            }
        }
        else {
            return $ctx->error(
                MT->translate("Invalid month format: must be YYYYMM") )
                unless length($prefix) eq 6;
        }
    }
    else {
        $prefix = $today;
    }
    my ( $cat_name, $cat, $category_set_id, @cat_field_ids );
    my $cat_set_name = '';
    if ( defined $args->{category_set} ) {
        my $category_set;
        my $id            = $args->{category_set};
        my $cat_set_class = MT->model('category_set');
        $category_set = $cat_set_class->load($id) if $id =~ m/^[0-9]+$/;
        $category_set = $cat_set_class->load( { name => $id } )
            unless $category_set;
        if ($category_set) {
            $cat_set_name    = $category_set->name;
            $category_set_id = $category_set->id;
            my @cat_fields = MT->model('cf')->load(
                {   content_type_id    => $content_type_id,
                    related_cat_set_id => $category_set_id
                }
            );
            @cat_field_ids = map { $_->id } @cat_fields;
        }
    }
    if ( defined $args->{category} ) {
        $cat_name = $args->{category};
        $cat      = MT::Category->load(
            {   label   => $cat_name,
                blog_id => $blog_id,
                $category_set_id
                ? ( category_set_id => $category_set_id )
                : ( category_set_id => { op => '>', value => 0 } ),
            }
            )
            or return $ctx->error(
            MT->translate( "No such category '[_1]'", $cat_name ) );
    }
    else {
        $cat_name = '';    ## For looking up cached calendars.
    }
    my $uncompiled     = $ctx->stash('uncompiled') || '';
    my $r              = MT::Request->instance;
    my $calendar_cache = $r->cache('content_calendar');
    unless ($calendar_cache) {
        $r->cache( 'content_calendar', $calendar_cache = {} );
    }
    if (exists $calendar_cache->{ $blog_id . ":"
                . $prefix
                . $cat_name
                . $cat_set_name }
        && $calendar_cache->{ $blog_id . ":"
                . $prefix
                . $cat_name
                . $cat_set_name }{'uc'} eq $uncompiled )
    {
        return $calendar_cache->{ $blog_id . ":"
                . $prefix
                . $cat_name
                . $cat_set_name }{output};
    }
    $today .= sprintf "%02d", $ts[3];
    my ( $start, $end ) = MT::Util::start_end_month($prefix);
    my ( $y, $m ) = unpack 'A4A2', $prefix;
    my $days_in_month = MT::Util::days_in( $m, $y );
    my $pad_start
        = ( MT::Util::wday_from_ts( $y, $m, 1 ) + $start_with_offset ) % 7;
    my $pad_end = 6 - (
        (   MT::Util::wday_from_ts( $y, $m, $days_in_month )
                + $start_with_offset
        ) % 7
    );

    # date_field
    my $dt_field    = 'authored_on';
    my $dt_field_id = 0;
    if ( my $arg = $args->{date_field} ) {
        if (   $arg eq 'authored_on'
            || $arg eq 'modified_on'
            || $arg eq 'created_on' )
        {
            $dt_field = $arg;
        }
        else {
            my $date_cf = '';
            $date_cf = MT->model('content_field')->load($arg)
                if ( $arg =~ /^[0-9]+$/ );
            $date_cf = _search_content_field(
                {   content_type_id   => $content_type_id,
                    name_or_unique_id => $arg,
                }
            );
            if ($date_cf) {
                $dt_field_id = $date_cf->id;
            }
        }
    }

    if ($dt_field_id) {
        my $join = MT::ContentFieldIndex->join_on(
            'content_data_id',
            [   { content_field_id => $dt_field_id },
                '-and',
                [   { value_datetime => { op => '>=', value => $start } },
                    '-and',
                    { value_datetime => { op => '<=', value => $end } }
                ],
            ],
            {   range_incl => { 'value_datetime' => 1 },
                'sort'     => 'value_datetime',
                direction  => 'ascend',
                alias      => 'dt_cf_idx'
            }
        );
        push @{ $cd_args{joins} }, $join;
    }
    if (@cat_field_ids) {
        my $join = MT::ContentFieldIndex->join_on(
            'content_data_id',
            {   content_field_id => [@cat_field_ids],
                ( $cat ? ( value_integer => $cat->id ) : () ),
            },
            { alias => 'cat_cf_idx' }
        );
        push @{ $cd_args{joins} }, $join;
    }
    my $iter = MT::ContentData->load_iter(
        {   blog_id => $blog_id,
            ( !$dt_field_id ? ( $dt_field => [ $start, $end ] ) : () ),
            status => MT::ContentStatus::RELEASE(),
            %cd_terms,
        },
        {   (   !$dt_field_id
                ? ( range_incl => { $dt_field => 1 },
                    'sort'     => $dt_field,
                    direction  => 'ascend'
                    )
                : ()
            ),
            %cd_args,
        }
    );
    my @left;
    my $res          = '';
    my $tokens       = $ctx->stash('tokens');
    my $builder      = $ctx->stash('builder');
    my $iter_drained = 0;

    for my $day ( 1 .. $pad_start + $days_in_month + $pad_end ) {
        my $is_padding = $day < $pad_start + 1
            || $day > $pad_start + $days_in_month;
        my ( $this_day, @cds ) = ('');
        local (
            $ctx->{__stash}{contents}, $ctx->{__stash}{calendar_day},
            $ctx->{current_timestamp}, $ctx->{current_timestamp_end}
        );
        local $ctx->{__stash}{calendar_cell} = $day;
        unless ($is_padding) {
            $this_day = $prefix . sprintf( "%02d", $day - $pad_start );
            my $no_loop = 0;
            if (@left) {
                my $datetime = '';
                if ($dt_field_id) {
                    $datetime = $left[0]->data->{$dt_field_id} || '';
                }
                else {
                    $datetime = $left[0]->authored_on;
                }
                if ( $datetime && substr( $datetime, 0, 8 ) eq $this_day ) {
                    @cds  = @left;
                    @left = ();
                }
                else {
                    $no_loop = 1;
                }
            }
            unless ( $no_loop || $iter_drained ) {
                while ( my $cd = $iter->() ) {

                    my $datetime = '';
                    if ($dt_field_id) {
                        $datetime = $cd->data->{$dt_field_id} || '';
                    }
                    else {
                        $datetime = $cd->authored_on;
                    }
                    my $cd_day = $datetime ? substr( $datetime, 0, 8 ) : '';
                    push( @left, $cd ), last
                        unless $cd_day eq $this_day;
                    push @cds, $cd;
                }
                $iter_drained++ unless @left;
            }
            $ctx->{__stash}{contents}     = \@cds;
            $ctx->{current_timestamp}     = $this_day . '000000';
            $ctx->{current_timestamp_end} = $this_day . '235959';
            $ctx->{__stash}{calendar_day} = $day - $pad_start;
        }
        defined(
            my $out = $builder->build(
                $ctx, $tokens,
                {   %$cond,
                    CalendarWeekHeader   => ( $day - 1 ) % 7 == 0,
                    CalendarWeekFooter   => $day % 7 == 0,
                    CalendarIfContents   => !$is_padding && scalar @cds,
                    CalendarIfNoContents => !$is_padding && !( scalar @cds ),
                    CalendarIfToday      => ( $today eq $this_day ),
                    CalendarIfBlank      => $is_padding,
                }
            )
        ) or return $ctx->error( $builder->errstr );
        $res .= $out;
    }
    $calendar_cache->{ $blog_id . ":" . $prefix . $cat_name }
        = { output => $res, 'uc' => $uncompiled };
    return $res;
}

sub _hdlr_content_nextprev {
    my ( $meth, $ctx, $args, $cond ) = @_;
    my $cd = $ctx->stash('content')
        or return $ctx->_no_content_error();
    my $terms = { status => MT::ContentStatus::RELEASE() };
    $terms->{by_author} = 1 if $args->{by_author};
    $terms->{category_field} = $args->{category_field}
        if $args->{category_field};
    $terms->{date_field} = $args->{date_field} if $args->{date_field};
    my $content_data = $cd->$meth($terms);
    my $res          = '';

    if ($content_data) {
        my $builder = $ctx->stash('builder');
        local $ctx->{__stash}->{content} = $content_data;
        local $ctx->{current_timestamp} = $content_data->authored_on;
        my $out = $builder->build( $ctx, $ctx->stash('tokens'), $cond );
        return $ctx->error( $builder->errstr ) unless defined $out;
        $res .= $out;
    }
    $res;
}

=head2 ContentField

A container tag that lists all of the field values which the content field has.

=cut

=head2 ContentFieldHeader

The contents of this container tag will be displayed when the first
content listed by a L<ContentField> tag is reached.

=for tags contentfield

=cut

=head2 ContentFieldFooter

The contents of this container tag will be displayed when the last
content listed by a L<ContentField> tag is reached.

=for tags contentfield

=cut

sub _hdlr_content_field {
    my ( $ctx, $args, $cond ) = @_;

    my $content_type = $ctx->stash('content_type')
        or return $ctx->_no_content_type_error;
    my $content_data = $ctx->stash('content')
        or return $ctx->_no_content_error;

    my $field_data;
    if ( my $id = $args->{content_field} ) {
        ($field_data) = grep { $_->{id} == $id } @{ $content_type->fields }
            if $id =~ m/^[0-9]+$/;
        ($field_data)
            = grep { defined $_->{unique_id} && $_->{unique_id} eq $id }
            @{ $content_type->fields }
            unless $field_data;
        ($field_data)
            = grep { defined $_->{name} && $_->{name} eq $id }
            @{ $content_type->fields }
            unless $field_data;
        ($field_data)
            = grep { $_->{options}{label} eq $id } @{ $content_type->fields }
            unless $field_data;
    }
    $field_data
        ||= $ctx->stash('content_field_data')
        || ( $args->{content_field} ? undef : $content_type->fields->[0] )
        or return $ctx->_no_content_field_error( $args->{content_field} );

    local $ctx->{__stash}{content_field_data} = $field_data;

    my $value = $content_data->data->{ $field_data->{id} };
    my $check_value = defined $value ? $value : '';

    if (ref $value eq 'ARRAY') {
        $check_value = @$value ? $value->[0] : '';
    }

    return $ctx->_hdlr_pass_tokens_else(@_) if !$check_value && $check_value eq '';

    my $field_type
        = MT->registry('content_field_types')->{ $field_data->{type} }
        or return $ctx->error(
        MT->translate('No Content Field Type could be found.') );

    local $ctx->{__stash}{content_field_type} = $field_type;

    if ( my $tag_handler = $field_type->{tag_handler} ) {
        if ( !ref $tag_handler ) {
            $tag_handler = MT->handler_to_coderef($tag_handler);
        }
        return $ctx->error(
            MT->translate(
                'Invalid tag_handler of [_1].',
                $field_data->{type}
            )
        ) unless ref $tag_handler eq 'CODE';
        $tag_handler->( $ctx, $args, $cond, $field_data, $value );
    }
    else {
        my $tok     = $ctx->stash('tokens');
        my $builder = $ctx->stash('builder');
        my $vars    = $ctx->{__stash}{vars} ||= {};
        local $vars->{__value__} = $value;
        $cond->{ContentFieldHeader} = 1;
        $cond->{ContentFieldFooter} = 1;
        $builder->build( $ctx, $tok, {%$cond} );
    }
}

=head2 ContentFields

A container tag that lists all of the fields which the content has.
This tagset creates a content_field context within which contentfield tag
may be used.

=cut

=head2 ContentFieldsHeader

The contents of this container tag will be displayed when the first
content listed by a L<ContentFields> tag is reached.

=for tags contentfields

=cut

=head2 ContentFieldsFooter

The contents of this container tag will be displayed when the last
content listed by a L<ContentFields> tag is reached.

=for tags contentfields

=cut

sub _hdlr_content_fields {
    my ( $ctx, $args, $cond ) = @_;

    my $content_type = $ctx->stash('content_type')
        or return $ctx->_no_content_type_error;

    my $content_field_types = MT->registry('content_field_types');

    my @field_data = @{ $content_type->fields };
    my $builder    = $ctx->stash('builder');
    my $tokens     = $ctx->stash('tokens');
    my $vars       = $ctx->{__stash}{vars} ||= {};
    my $i          = 1;
    my $res        = '';
    for my $f (@field_data) {
        local $vars->{__first__}   = $i == 1;
        local $vars->{__last__}    = $i == scalar @field_data;
        local $vars->{__odd__}     = ( $i % 2 ) == 1;
        local $vars->{__even__}    = ( $i % 2 ) == 0;
        local $vars->{__counter__} = $i;

        local $ctx->{__stash}{content_field_data} = $f;

        local $vars->{content_field_id}        = $f->{id};
        local $vars->{content_field_unique_id} = $f->{unique_id};
        local $vars->{content_field_type}      = $f->{type};
        local $vars->{content_field_order}     = $f->{order};
        local $vars->{content_field_options}   = $f->{options};
        local $vars->{content_field_type_label}
            = $content_field_types->{ $f->{type} }{label};

        defined(
            my $out = $builder->build(
                $ctx, $tokens,
                {   %{$cond},
                    ContentFieldsHeader => $i == 1,
                    ContentFieldsFooter => $i == scalar @field_data,
                }
            )
        ) or return $ctx->error( $builder->errstr );
        $res .= $out;
        $i++;
    }

    $res;
}

=head2 ContentFieldValue

The function tag which outputs a value of a content field in context of content field.
Possible to control an output value by field_value_handler registry.

=cut

sub _hdlr_content_field_value {
    my ( $ctx, $args, $cond ) = @_;

    my $content_type = $ctx->stash('content_type')
        or return $ctx->_no_content_type_error;
    my $content_data = $ctx->stash('content')
        or return $ctx->_no_content_error;
    my $field_data = $ctx->stash('content_field_data')
        or return $ctx->_no_content_field_error;

    my $field_type = $ctx->stash('content_field_type')
        || MT->registry('content_field_types')->{ $field_data->{type} };
    return $ctx->error(
        MT->translate('No Content Field Type could be found.') )
        unless $field_type;

    my $value = $ctx->{__stash}{vars}{__value__};
    if ( my $handler = $field_type->{field_value_handler} ) {
        if ( !ref $handler ) {
            $handler = MT->handler_to_coderef($handler);
        }
        return $ctx->error(
            MT->translate(
                'Invalid field_value_handler of [_1].',
                $field_data->{type}
            )
        ) unless ref $handler eq 'CODE';
        $value = $handler->( $ctx, $args, $cond, $field_data, $value );
    }

    return $value;
}

=head2 ContentFieldLabel

The function tag which outputs a label of a content field in context of content field.

=cut

sub _hdlr_content_field_label {
    my ( $ctx, $args, $cond ) = @_;

    my $content_type = $ctx->stash('content_type')
        or return $ctx->_no_content_type_error;
    my $content_data = $ctx->stash('content')
        or return $ctx->_no_content_error;
    my $field_data = $ctx->stash('content_field_data')
        or return $ctx->_no_content_field_error;

    $field_data->{options}{label} || '';
}

=head2 ContentFieldType

The function tag which outputs a type of a content field in context of content field.

=cut

sub _hdlr_content_field_type {
    my ( $ctx, $args, $cond ) = @_;

    my $content_type = $ctx->stash('content_type')
        or return $ctx->_no_content_type_error;
    my $content_data = $ctx->stash('content')
        or return $ctx->_no_content_error;
    my $field_data = $ctx->stash('content_field_data')
        or return $ctx->_no_content_field_error;

    $field_data->{type} || '';
}

=head2 ContentLabel

Outputs the label of the current content data in context.

=cut

sub _hdlr_content_label {
    my ( $ctx, $args ) = @_;
    my $content_data = $ctx->stash('content')
        or return $ctx->_no_content_error;
    defined $content_data->label ? $content_data->label : '';
}

=head2 ContentTypeDescription

Returns the description of the current content type in context.

=cut

sub _hdlr_content_type_description {
    my ( $ctx, $args ) = @_;
    my $content_type = $ctx->stash('content_type')
        or return $ctx->_no_content_error;
    defined $content_type->description
        ? $content_type->description
        : '';
}

=head2 ContentTypeName

Outputs the name of the current content type in context.

=cut

sub _hdlr_content_type_name {
    my ( $ctx, $args ) = @_;
    my $content_type = $ctx->stash('content_type')
        or return $ctx->_no_content_error;
    $content_type->name;
}

=head2 ContentTypeID

Ouptuts the numeric ID for the current content type in context.

B<Attributes:>

=over 4

=item * pad (optional; default "0")

Adds leading zeros to create a 6 character string. The default is 0 (false). This is equivalent to using the C<zero_pad> global filter with a value of 6.

=back

=cut

sub _hdlr_content_type_id {
    my ( $ctx, $args ) = @_;
    my $content_type = $ctx->stash('content_type')
        or return $ctx->_no_content_type_error;
    return $args && $args->{pad}
        ? ( sprintf "%06d", $content_type->id )
        : $content_type->id;
}

=head2 ContentTypeUniqueID

Outputs the unique_id field for the current content type in context.

=cut

sub _hdlr_content_type_unique_id {
    my ( $ctx, $args, $cond ) = @_;
    my $content_type = $ctx->stash('content_type')
        or return $ctx->_no_content_type_error();
    $content_type->unique_id;
}

sub _check_and_invoke {
    my ( $tag, $ctx, $args, $cond ) = @_;
    my $cd = $ctx->stash('content')
        or return $ctx->_no_content_error();
    local $ctx->{__stash}{entry} = $cd;
    $ctx->invoke_handler( $tag, $args, $cond );
}

sub _get_content_type {
    my ( $ctx, $args, $blog_terms ) = @_;

    my @content_types      = ();
    my @not_found_blog_ids = ();
    my $blog_ids           = $blog_terms->{blog_id};
    my @blog_ids           = ref $blog_ids ? @$blog_ids : ($blog_ids);

    if ( defined $args->{content_type} && $args->{content_type} ne '' ) {
        for my $blog_id (@blog_ids) {
            my ($ct)
                = MT::Util::ContentType::get_content_types(
                $args->{content_type}, { blog_id => $blog_id } );
            if ($ct) {
                push @content_types, $ct;
            }
            else {
                push @not_found_blog_ids, $blog_id;
            }
        }
    }
    else {
        my $ct = $ctx->stash('content_type');
        unless ($ct) {
            my $tmpl = $ctx->stash('template');
            if ( $tmpl && $tmpl->content_type_id ) {
                $ct
                    = MT->model('content_type')
                    ->load( $tmpl->content_type_id );

                # invalid template_content_type_id
                return $ctx->_no_content_type_error unless $ct;
            }
        }
        if ($ct) {
            @content_types = ($ct);
        }
        else {
            for my $blog_id (@blog_ids) {
                my @ct
                    = MT->model('content_type')
                    ->load( { blog_id => $blog_id } );
                if (@ct) {
                    push @content_types, @ct;
                }
                else {
                    push @not_found_blog_ids, $blog_id;
                }
            }
        }
    }

    if (@not_found_blog_ids) {
        return $ctx->error(
            MT->translate(
                'Content Type was not found. Blog ID: [_1]',
                join( ',', @not_found_blog_ids ),
            )
        );
    }

    return $ctx->_no_content_type_error unless @content_types;

    return \@content_types;
}

sub _search_content_field {
    my ($args) = @_;
    $args ||= {};
    my $content_type_id = $args->{content_type_id} or return;
    my $name_or_unique_id = $args->{name_or_unique_id};
    return unless defined $name_or_unique_id && $name_or_unique_id ne '';
    my $cf = MT->model('content_field')
        ->load_by_id_or_name( $name_or_unique_id, $content_type_id );
    return $cf;
}

1;
