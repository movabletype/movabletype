# Movable Type (r) Open Source (C) 2001-2013 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$
package MT::Template::Tags::Asset;

use strict;

use MT;
use MT::Util qw( offset_time_list );
use MT::Request;
use MT::Asset;

###########################################################################

=head2 Assets

A container tag which iterates over a list of assets.

B<Attributes:>

=over 4

=item * type

Specifies a particular type(s) of asset to select. This may be
one of image, audio, video, or file(a generic for unrecognized file types). 
If unspecified, will select all asset types. Supports a comma-delimited list.

=item * file_ext

Specifies a particular file extension to select. For instance, gif, mp3,
pdf, etc. Supports a comma-delimited list.

=item * days

Selects assets created in the last number of days specified.

=item * author

Selects assets uploaded by a particular author (where the author's
username is given).

=item * lastn

Limits the selection of assets to the specified number.

=item * limit

a positive integer to limit results.

=item * offset

Used in coordination with lastn, starts N assets from the start of the
list. N is a positive integer.

=item * tag

Selects assets with particular tags (supports expressions such as
"interesting AND featured").

=item * sort_by

Supported values: file_name, created_by, created_on, score.

=item * sort_order

Supported values: ascend, descend.

=item * namespace

Used in conjunction with the sort_by attribute when sorting in
"score" order. The namespace identifies the method of scoring to use
in sorting assets.

=item * assets_per_row

When publishing a grid of thumbnails, this attribute sets how many
iterations the Assets tag publishes before setting the state that
enables the L<AssetIsLastInRow> tag. Supported values: numbers between 1
and 100. Also supported is the keyword "auto" which selects the
most aesthetically pleasing number of items per row based on the
total number of assets. For example, if you had 18 total assets, three
rows of six would publish, but for 16 assets, four rows of four
would publish.

=back

B<Example:>

    <mt:Assets lastn="10" type="image" tag="favorite">
       <a href="<mt:AssetURL>">
          <img src="<mt:AssetThumbnailURL height="70">"
               alt="<mt:AssetLabel escape="html">"
               title="<mt:AssetLabel escape="html">" />
       </a>
    </mt:Assets>

=for tags multiblog, assets

=cut

sub _hdlr_assets {
    my ( $ctx, $args, $cond ) = @_;
    return $ctx->error(
        MT->translate(
            'sort_by="score" must be used in combination with namespace.')
        )
        if ( ( exists $args->{sort_by} )
        && ( 'score' eq $args->{sort_by} )
        && ( !exists $args->{namespace} ) );

    my $class_type = $args->{class_type} || 'asset';
    my $class = MT->model($class_type);
    my $assets;
    my $tag = lc $ctx->stash('tag');
    if ( $tag eq 'entryassets' || $tag eq 'pageassets' ) {
        my $e = $ctx->stash('entry')
            or return $ctx->_no_entry_error();

        if ( $e->has_summary('all_assets') ) {
            @$assets = $e->get_summary_objs( 'all_assets' => 'MT::Asset' );
        }
        else {
            require MT::ObjectAsset;
            @$assets = MT::Asset->load(
                { class => '*' },
                {   join => MT::ObjectAsset->join_on(
                        undef,
                        {   asset_id  => \'= asset_id',
                            object_ds => 'entry',
                            object_id => $e->id
                        }
                    )
                }
            );
        }

        # Call _hdlr_pass_tokens_else if there are no assets, so that MTElse
        # is properly executed if it's present.
        #
        return $ctx->_hdlr_pass_tokens_else(@_) unless @$assets[0];
    }
    else {
        $assets = $ctx->stash('assets');
    }

    local $ctx->{__stash}{assets};
    my ( @filters, %blog_terms, %blog_args, %terms, %args );
    my $blog_id = $ctx->stash('blog_id');

    $ctx->set_blog_load_context( $args, \%blog_terms, \%blog_args )
        or return $ctx->error( $ctx->errstr );
    %terms = %blog_terms;
    %args  = %blog_args;

    # Adds parent filter (skips any generated files such as thumbnails)
    $args{null}{parent} = 1;
    $terms{parent} = \'is null';

    # Adds an author filter to the filters list.
    if ( my $author_name = $args->{author} ) {
        require MT::Author;
        my $author = MT::Author->load( { name => $author_name } )
            or return $ctx->error(
            MT->translate( "No such user '[_1]'", $author_name ) );
        if ($assets) {
            push @filters, sub { $_[0]->created_by == $author->id };
        }
        else {
            $terms{created_by} = $author->id;
        }
    }

    # Added a type filter to the filters list.
    if ( my $type = $args->{type} ) {
        my @types = split( ',', $args->{type} );
        if ($assets) {
            push @filters,
                sub { my $a = $_[0]->class; grep( m/$a/, @types ) };
        }
        else {
            $terms{class} = \@types;
        }
    }
    else {
        $terms{class} = '*';
    }

    # Added a file_ext filter to the filters list.
    if ( my $ext = $args->{file_ext} ) {
        my @exts = split( ',', $args->{file_ext} );
        if ($assets) {
            push @filters,
                sub { my $a = $_[0]->file_ext; grep( m/$a/, @exts ) };
        }
        else {
            $terms{file_ext} = \@exts;
        }
    }

    # Adds a tag filter to the filters list.
    if ( my $tag_arg = $args->{tags} || $args->{tag} ) {
        require MT::Tag;
        require MT::ObjectTag;

        my $terms;
        if ( $tag_arg !~ m/\b(AND|OR|NOT)\b|\(|\)/i ) {
            my @tags = MT::Tag->split( ',', $tag_arg );
            $terms = { name => \@tags };
            $tag_arg = join " or ", @tags;

            my $count = MT::Tag->count(
                $terms,
                {   ( $terms ? ( binary => { name => 1 } ) : () ),
                    join => MT::ObjectTag->join_on(
                        'tag_id',
                        {   object_datasource => MT::Asset->datasource,
                            %blog_terms,
                        },
                        { %blog_args, unique => 1 }
                    ),
                }
            );
            return $ctx->_hdlr_pass_tokens_else(@_)
                unless $count;
        }
        my $tags = [
            MT::Tag->load(
                $terms,
                {   ( $terms ? ( binary => { name => 1 } ) : () ),
                    join => MT::ObjectTag->join_on(
                        'tag_id',
                        {   object_datasource => MT::Asset->datasource,
                            %blog_terms,
                        },
                        { %blog_args, unique => 1 }
                    ),
                }
            )
        ];
        my $cexpr = $ctx->compile_tag_filter( $tag_arg, $tags );
        if ($cexpr) {
            my @tag_ids
                = map { $_->id, ( $_->n8d_id ? ( $_->n8d_id ) : () ) } @$tags;
            my $preloader = sub {
                my ($entry_id) = @_;
                my $terms = {
                    tag_id            => \@tag_ids,
                    object_id         => $entry_id,
                    object_datasource => $class->datasource,
                    %blog_terms,
                };
                my $args = {
                    %blog_args,
                    fetchonly   => ['tag_id'],
                    no_triggers => 1,
                };
                my @ot_ids = MT::ObjectTag->load( $terms, $args ) if @tag_ids;
                my %map;
                $map{ $_->tag_id } = 1 for @ot_ids;
                \%map;
            };
            push @filters, sub { $cexpr->( $preloader->( $_[0]->id ) ) };
        }
        else {
            return $ctx->error(
                MT->translate(
                    "You have an error in your '[_2]' attribute: [_1]",
                    $args->{tags} || $args->{tag}, 'tag'
                )
            );
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
            my $scored_by = $args->{scored_by} || undef;
            if ($scored_by) {
                require MT::Author;
                my $author = MT::Author->load( { name => $scored_by } )
                    or return $ctx->error(
                    MT->translate( "No such user '[_1]'", $scored_by ) );
                $scored_by = $author;
            }

            $args{join} = MT->model('objectscore')->join_on(
                undef,
                {   object_id => \'=asset_id',
                    object_ds => 'asset',
                    namespace => $namespace,
                    (   !$assets && $scored_by
                        ? ( author_id => $scored_by->id )
                        : ()
                    ),
                },
                { unique => 1, }
            );
            if ( $assets && $scored_by ) {
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

    my $no_resort = 0;
    require MT::Asset;
    my @assets;
    if ( !$assets ) {
        my ( $start, $end )
            = ( $ctx->{current_timestamp}, $ctx->{current_timestamp_end} );
        if ( $start && $end ) {
            $terms{created_on} = [ $start, $end ];
            $args{range_incl}{created_on} = 1;
        }
        if ( my $days = $args->{days} ) {
            my @ago = offset_time_list( time - 3600 * 24 * $days,
                $ctx->stash('blog_id') );
            my $ago = sprintf "%04d%02d%02d%02d%02d%02d",
                $ago[5] + 1900, $ago[4] + 1, @ago[ 3, 2, 1, 0 ];
            $terms{created_on} = [$ago];
            $args{range_incl}{created_on} = 1;
        }
        $args{'sort'} = 'created_on';
        if ( $args->{sort_by} ) {
            if ( MT::Asset->has_column( $args->{sort_by} ) ) {
                $args{sort} = $args->{sort_by};
                $no_resort = 1;
            }
            elsif ('score' eq $args->{sort_by}
                || 'rate' eq $args->{sort_by} )
            {
                $no_resort = 0;
            }
        }

        if ( !@filters ) {
            if ( my $last = $args->{lastn} ) {
                $args{'sort'}    = 'created_on';
                $args{direction} = 'descend';
                $args{limit}     = $last;
                $no_resort = 0 if $args->{sort_by};
            }
            else {
                $args{direction} = $args->{sort_order} || 'descend'
                    if exists( $args{sort} );
                $no_resort = 1 unless $args->{sort_by};
                $args{limit} = $args->{limit} if $args->{limit};
            }
            $args{offset} = $args->{offset} if $args->{offset};
            @assets = MT::Asset->load( \%terms, \%args );
        }
        else {
            if ( $args->{lastn} ) {
                $args{direction} = 'descend';
                $args{sort}      = 'created_on';
                $no_resort = 0 if $args->{sort_by};
            }
            else {
                $args{direction} = $args->{sort_order} || 'descend';
                $no_resort = 1 unless $args->{sort_by};
                $args->{lastn} = $args->{limit} if $args->{limit};
            }
            my $iter = MT::Asset->load_iter( \%terms, \%args );
            my $i    = 0;
            my $j    = 0;
            my $off  = $args->{offset} || 0;
            my $n    = $args->{lastn};
        ASSET: while ( my $e = $iter->() ) {
                for (@filters) {
                    next ASSET unless $_->($e);
                }
                next if $off && $j++ < $off;
                push @assets, $e;
                $i++;
                last if $n && $i >= $n;
            }
        }
    }
    else {
        my $blog = $ctx->stash('blog');
        my $so 
            = lc( $args->{sort_order} )
            || ( $blog ? $blog->sort_order_posts : undef )
            || '';
        my $col = lc( $args->{sort_by} || 'created_on' );

        # TBD: check column being sorted; if it is numeric, use numeric sort
        @$assets
            = $so eq 'ascend'
            ? sort { $a->$col() cmp $b->$col() } @$assets
            : sort { $b->$col() cmp $a->$col() } @$assets;
        $no_resort = 1;
        if (@filters) {
            my $i   = 0;
            my $j   = 0;
            my $off = $args->{offset} || 0;
            my $n   = $args->{lastn} || $args->{limit};
        ASSET2: foreach my $e (@$assets) {
                for (@filters) {
                    next ASSET2 unless $_->($e);
                }
                next if $off && $j++ < $off;
                push @assets, $e;
                $i++;
                last if $n && $i >= $n;
            }
        }
        else {
            my $offset;
            if ( $offset = $args->{offset} ) {
                if ( $offset < scalar @$assets ) {
                    @assets = @$assets[ $offset .. $#$assets ];
                }
                else {
                    @assets = ();
                }
            }
            else {
                @assets = @$assets;
            }
            if ( my $last = $args->{lastn} || $args->{limit} ) {
                if ( scalar @assets > $last ) {
                    @assets = @assets[ 0 .. $last - 1 ];
                }
            }
        }
    }

    unless ($no_resort) {
        my $so  = lc( $args->{sort_order} || '' );
        my $col = lc( $args->{sort_by}    || 'created_on' );
        if ( 'score' eq $col ) {
            my $namespace = $args->{namespace};
            my $so        = $args->{sort_order} || '';
            my %a         = map { $_->id => $_ } @assets;
            require MT::ObjectScore;
            my $scores = MT::ObjectScore->sum_group_by(
                { 'object_ds' => 'asset', 'namespace' => $namespace },
                {   'sum' => 'score',
                    group => ['object_id'],
                    $so eq 'ascend'
                    ? ( direction => 'ascend' )
                    : ( direction => 'descend' ),
                }
            );
            my @tmp;
            while ( my ( $score, $object_id ) = $scores->() ) {
                push @tmp, delete $a{$object_id} if exists $a{$object_id};
            }
            if ( $so eq 'ascend' ) {
                unshift @tmp, $_ foreach ( values %a );
            }
            else {
                push @tmp, $_ foreach ( values %a );
            }
            @assets = @tmp;
        }
        elsif ( 'rate' eq $col ) {
            my $namespace = $args->{namespace};
            my $so        = $args->{sort_order} || '';
            my %a         = map { $_->id => $_ } @assets;
            require MT::ObjectScore;
            my $scores = MT::ObjectScore->avg_group_by(
                { 'object_ds' => 'asset', 'namespace' => $namespace },
                {   'avg' => 'score',
                    group => ['object_id'],
                    $so eq 'ascend'
                    ? ( direction => 'ascend' )
                    : ( direction => 'descend' ),
                }
            );
            my @tmp;
            while ( my ( $score, $object_id ) = $scores->() ) {
                push @tmp, delete $a{$object_id} if exists $a{$object_id};
            }
            if ( $so eq 'ascend' ) {
                unshift @tmp, $_ foreach ( values %a );
            }
            else {
                push @tmp, $_ foreach ( values %a );
            }
            @assets = @tmp;
        }
        else {

          # TBD: check column being sorted; if it is numeric, use numeric sort
            @assets
                = $so eq 'ascend'
                ? sort { $a->$col() cmp $b->$col() } @assets
                : sort { $b->$col() cmp $a->$col() } @assets;
        }
    }

    my $res     = '';
    my $tok     = $ctx->stash('tokens');
    my $builder = $ctx->stash('builder');
    my $per_row = $args->{assets_per_row} || 0;
    $per_row -= 1 if $per_row;
    my $row_count   = 0;
    my $i           = 0;
    my $total_count = @assets;
    my $vars        = $ctx->{__stash}{vars} ||= {};

    MT::Meta::Proxy->bulk_load_meta_objects( \@assets );
    for my $a (@assets) {
        local $ctx->{__stash}{asset} = $a;
        local $vars->{__first__}     = !$i;
        local $vars->{__last__}      = !defined $assets[ $i + 1 ];
        local $vars->{__odd__}       = ( $i % 2 ) == 0;           # 0-based $i
        local $vars->{__even__}      = ( $i % 2 ) == 1;
        local $vars->{__counter__}   = $i + 1;
        my $f = $row_count == 0;
        my $l = $row_count == $per_row;
        $l = 1 if ( ( $i + 1 ) == $total_count );
        my $out = $builder->build(
            $ctx, $tok,
            {   %$cond,
                AssetIsFirstInRow => $f,
                AssetIsLastInRow  => $l,
                AssetsHeader      => !$i,
                AssetsFooter      => !defined $assets[ $i + 1 ],
            }
        );
        return $ctx->error( $builder->errstr ) unless defined $out;
        $res .= $out;
        $row_count++;
        $row_count = 0 if $row_count > $per_row;
        $i++;
    }
    if ( !@assets ) {
        return $ctx->_hdlr_pass_tokens_else(@_);
    }

    $res;
}

###########################################################################

=head2 Asset

Container tag that provides an asset context for a specific asset,
from which all asset variable tags can be used to retreive metadata
about that asset.

B<Attributes:>

=over 4

=item * id

The unique numeric id of the asset.

=back

B<Example:>

    <mt:Asset id="10">
        <$mt:AssetLabel$>
    </mt:Asset>

=for tags assets

=cut

sub _hdlr_asset {
    my ( $ctx, $args, $cond ) = @_;
    my $assets = $ctx->stash('assets');
    local $ctx->{__stash}{assets};
    return '' if !defined $args->{id};
    return '' if $assets;

    require MT::Asset;
    my $out = '';
    my $asset = MT::Asset->load( { id => $args->{id} } );

    if ($asset) {
        my $tok     = $ctx->stash('tokens');
        my $builder = $ctx->stash('builder');

        local $ctx->{__stash}{asset} = $asset;
        $out = $builder->build( $ctx, $tok, { %$cond, } );
    }
    $out;
}

###########################################################################

=head2 EntryAssets

A container tag which iterates over a list of assets for the current
entry in context. Supports all the attributes provided by the L<Assets>
tag.

=for tags entries, assets

=cut

###########################################################################

=head2 PageAssets

A container tag which iterates over a list of assets for the current
page in context. Supports all the attributes provided by the L<Assets>
tag.

=for tags pages, assets

=cut

###########################################################################

=head2 AssetsHeader

The contents of this container tag will be displayed when the first
entry listed by a L<Assets> tag is reached.

=for tags assets

=cut

###########################################################################

=head2 AssetsFooter

The contents of this container tag will be displayed when the last
entry listed by a L<Assets> tag is reached.

=for tags assets

=cut

###########################################################################

=head2 AssetIsFirstInRow

A conditional tag that displays its contents if the asset in context is
the first item in the row in context when publishing a grid of
assets (e.g. thumbnails). Grid of assets can be created by specifying
assets_per_row attribute value to L<Assets> block tag.

For example, the first, the fourth and the seventh asset are the
first assets in row when L<Assets> iterates eight assets and
assets_per_row is set to "3".

B<Example:>

    <table>
      <mt:Assets type="image" assets_per_row="4">
        <mt:AssetIsFirstInRow><tr></mt:AssetIsFirstInRow>
          <td><$mt:AssetThumbnailLink$></td>
        <mt:AssetIsLastInRow></tr></mt:AssetIsLastInRow>
      </mt:Assets>
    </table>

=cut

###########################################################################

=head2 AssetIsLastInRow

A conditional tag that displays its contents if the asset in context
is the last item in the row in context when publishing a grid of
assets (e.g. thumbnails). Grid of assets can be created by specifying
assets_per_row attribute value to L<Assets> block tag.

For example, the third, the sixth and the eighth asset are the last
assets in row when L<Assets> iterates eight assets and assets_per_row is
set to "3".

B<Example:>

    <table>
      <mt:Assets type="image" assets_per_row="4">
        <mt:AssetIsFirstInRow><tr></mt:AssetIsFirstInRow>
          <td><$mt:AssetThumbnailLink$></td>
        <mt:AssetIsLastInRow></tr></mt:AssetIsLastInRow>
      </mt:Assets>
    </table>

=for tags assets

=cut

###########################################################################

=head2 AssetID

A numeric system ID of the Asset currently in context.

B<Example:>

    <$mt:AssetID$>

=for tags assets

=cut

sub _hdlr_asset_id {
    my ( $ctx, $args ) = @_;
    my $a = $ctx->stash('asset')
        or return $ctx->_no_asset_error();
    return $args && $args->{pad} ? ( sprintf "%06d", $a->id ) : $a->id;
}

###########################################################################

=head2 AssetFileName

The file name of the asset in context. For file-based assets only. Returns
the file name without the path (i.e. file.jpg, not
/home/user/public_html/images/file.jpg).

B<Example:>

    <$mt:AssetFileName$>

=for tags assets

=cut

sub _hdlr_asset_file_name {
    my ( $ctx, $args ) = @_;
    my $a = $ctx->stash('asset')
        or return $ctx->_no_asset_error();
    return $a->file_name;
}

###########################################################################

=head2 AssetLabel

Returns the label of the asset in context. Label can be specified upon
uploading a file.

B<Example:>

    <$mt:AssetLabel$>

=for tags assets

=cut

sub _hdlr_asset_label {
    my ( $ctx, $args ) = @_;
    my $a = $ctx->stash('asset')
        or return $ctx->_no_asset_error();
    return defined $a->label ? $a->label : '';
}

###########################################################################

=head2 AssetDescription

This tag returns the description text of the asset currently in context.

B<Example:>

    <$mt:AssetDescription$>

=for tags assets

=cut

sub _hdlr_asset_description {
    my ( $ctx, $args ) = @_;
    my $a = $ctx->stash('asset')
        or return $ctx->_no_asset_error();
    return defined $a->description ? $a->description : '';
}

###########################################################################

=head2 AssetURL

Produces a permalink for the uploaded asset.

B<Example:>

    <$mt:AssetURL$>

=for tags assets

=cut

sub _hdlr_asset_url {
    my ( $ctx, $args ) = @_;
    my $a = $ctx->stash('asset')
        or return $ctx->_no_asset_error();
    return $a->url;
}

###########################################################################

=head2 AssetType

Returns the localized name for the type of asset currently in context.
For instance, for an image asset, this will tag will output (for English
blogs), "image".

B<Example:>

    <$mt:AssetType$>

=for tags assets

=cut

sub _hdlr_asset_type {
    my ($ctx) = @_;
    my $a = $ctx->stash('asset')
        or return $ctx->_no_asset_error();
    return lc $a->class_label;
}

###########################################################################

=head2 AssetMimeType

Returns MIME type of the asset in context. MIME type of a file is typically
provided by web browser upon uploading.

B<Example:>

    <$mt:AssetMimeType$>

=for tags assets

=cut

sub _hdlr_asset_mime_type {
    my ($ctx) = @_;
    my $a = $ctx->stash('asset')
        or return $ctx->_no_asset_error();
    return $a->mime_type || '';
}

###########################################################################

=head2 AssetFilePath

Path information of the asset in context. For file-based assets only.
Returns the local file path with the name of the file (i.e.
/home/user/public_html/images/file.jpg).

B<Example:>

    <$mt:AssetFilePath$>

=for tags assets

=cut

sub _hdlr_asset_file_path {
    my ($ctx) = @_;
    my $a = $ctx->stash('asset')
        or return $ctx->_no_asset_error();
    return $a->file_path || '';
}

###########################################################################

=head2 AssetDateAdded

The date the asset in context was added to Movable Type.

B<Attributes:>

=over 4

=item * format

A string that provides the format in which to publish the date. If
unspecified, the default that is appropriate for the language of the blog
is used (for English, this is "%B %e, %Y %l:%M %p"). See the L<Date>
tag for the supported formats.

=item * language

Forces the date to the format associated with the specified language.

=item * utc

Forces the date to UTC format.

=back

B<Example:>

    <$mt:AssetDateAdded$>

=for tags date, assets

=cut

sub _hdlr_asset_date_added {
    my ( $ctx, $args ) = @_;
    my $a = $ctx->stash('asset')
        or return $ctx->_no_asset_error();
    $args->{ts} = $a->created_on;
    return $ctx->build_date($args);
}

###########################################################################

=head2 AssetAddedBy

Display name (or username if display name isn't assigned) of the user
who added the asset to the system.

B<Example:>

    <$mt:AssetAddedBy$>

=for tags assets

=cut

sub _hdlr_asset_added_by {
    my ($ctx) = @_;
    my $a = $ctx->stash('asset')
        or return $ctx->_no_asset_error();

    require MT::Author;
    my $author = MT::Author->load( $a->created_by );
    return '' unless $author;
    return $author->nickname || $author->name;
}

###########################################################################

=head2 AssetProperty

Returns the additional metadata of the asset in context. Some of these
properties only make sense for certain file types. For example, image_width
and image_height apply only to images.

B<Attributes:>

=over 4

=item * property (required)

Specifies what property to return from the tag. B<Supported attribute values:>

=over 4

=item * file_size

asset's file size

=item * image_width

asset's width (for image only; otherwise returns 0)

=item * image_height

asset's height (for image only; otherwise returns 0)

=item * description

asset's description

=back

=item * format

Used in conjunction with file_size property. B<Supported attribute values:>

=over 4

=item * 0

return raw size

=item * 1 (default)

auto format depending on the size

=item * k

size expressed in kilobytes

=item * m

size expressed in megabytes

=back

=back

=for tags assets

=cut

sub _hdlr_asset_property {
    my ( $ctx, $args ) = @_;
    my $a = $ctx->stash('asset')
        or return $ctx->_no_asset_error();
    my $prop = $args->{property};
    return '' unless $prop;

    my $class = ref($a);
    my $ret;
    if ( $prop =~ m/file_size/i ) {
        require MT::FileMgr;
        my $fmgr   = MT::FileMgr->new('Local');
        my $size   = $fmgr->file_size( $a->file_path );
        my $format = $args->{format};
        $format = 1 if !defined $format;

        if ( $format eq '1' ) {
            if ( $size < 1024 ) {
                $ret = sprintf( "%d Bytes", $size );
            }
            elsif ( $size < 1024000 ) {
                $ret = sprintf( "%.1f KB", $size / 1024 );
            }
            else {
                $ret = sprintf( "%.1f MB", $size / 1048576 );
            }
        }
        elsif ( $format =~ m/k/i ) {
            $ret = sprintf( "%.1f", $size / 1024 );
        }
        elsif ( $format =~ m/m/i ) {
            $ret = sprintf( "%.1f", $size / 1048576 );
        }
        else {
            $ret = $size;
        }
    }
    elsif ( $prop =~ m/^image_/ && $class->can($prop) ) {

        # These are numbers, so default to 0.
        $ret = $a->$prop || 0;
    }
    elsif ( $prop =~ m/^image_/ ) {
        $ret = 0;
    }
    else {
        $a->has_column($prop)
            or return $ctx->error(
            MT->translate(
                "You have an error in your '[_2]' attribute: [_1]", $prop,
                'property'
            )
            );
        $ret = $a->$prop || '';
    }

    $ret;
}

###########################################################################

=head2 AssetFileExt

The file extension of the asset in context. For file-based assets only.
Returns the file extension without the leading period (ie: "jpg").

B<Example:>

    <$mt:AssetFileExt$>

=for tags assets

=cut

sub _hdlr_asset_file_ext {
    my ($ctx) = @_;
    my $a = $ctx->stash('asset')
        or return $ctx->_no_asset_error();
    return $a->file_ext || '';
}

###########################################################################

=head2 AssetThumbnailURL

Returns the URL for a thumbnail you wish to generate for the current
asset in context.

B<Attributes:>

=over 4

=item * height

The height of the thumbnail to generate. If this is the only parameter
specified then the thumbnail's width will be scaled proportionally to
the height.

=item * width

The width of the thumbnail to generate. If this is the only parameter
specified then the thumbnail's height will be scaled proportionally
to the width.

=item * scale

The percentage by which to reduce or increase the size of the current
asset.

=item * square

If set to 1 (one) then the thumbnail generated will be square, where
the length of each side of the square will be equal to the shortest
side of the image.

=back

B<Example:>

The following will output thumbnails for all of the assets embedded in all
of the entries on the system. Each thumbnail will be square and have a
max height/width of 100 pixels.

    <mt:Entries>
        <mt:EntryAssets>
            <$mt:AssetThumbnailURL width="100" square="1"$>
        </mt:EntryAssets>
    </mt:Entries>

=for tags assets

=cut

sub _hdlr_asset_thumbnail_url {
    my ( $ctx, $args ) = @_;
    my $a = $ctx->stash('asset')
        or return $ctx->_no_asset_error();
    return '' unless $a->has_thumbnail;

    my %arg;
    foreach ( keys %$args ) {
        $arg{$_} = $args->{$_};
    }
    $arg{Width}  = $args->{width}  if $args->{width};
    $arg{Height} = $args->{height} if $args->{height};
    $arg{Scale}  = $args->{scale}  if $args->{scale};
    $arg{Square} = $args->{square} if $args->{square};
    my ( $url, $w, $h ) = $a->thumbnail_url(%arg);
    return $url || '';
}

###########################################################################

=head2 AssetLink

Returns HTML anchor tag for the asset in context. For example, if the URL
of the asset is C<http://example.com/image.jpg>, the tag returns
C<E<lt>a href="http://example.com/image.jpg"E<gt>image.jpgE<lt>/aE<gt>>.

B<Attributes:>

=over 4

=item * new_window (optional; default "0")

Specifies if the tag generates 'target="_blank"' attribute to the anchor
tag.

=back

B<Example:>

    <$mt:AssetLink$>

=for tags assets

=cut

sub _hdlr_asset_link {
    my ( $ctx, $args ) = @_;
    my $a = $ctx->stash('asset')
        or return $ctx->_no_asset_error();

    my $ret = sprintf qq(<a href="%s"), $a->url;
    if ( $args->{new_window} ) {
        $ret .= qq( target="_blank");
    }
    $ret .= sprintf qq(>%s</a>), $a->file_name;
    $ret;
}

###########################################################################

=head2 AssetThumbnailLink

Produces a thumbnail image, linked to the image asset currently in
context.

B<Attributes:>

=over 4

=item * height

The height of the thumbnail to generate. If this is the only parameter
specified then the thumbnail's width will be scaled proportionally to
the height.

=item * width

The width of the thumbnail to generate. If this is the only parameter
specified then the thumbnail's height will be scaled proportionally
to the width.

=item * scale

The percentage by which to reduce or increase the size of the current
asset.

=item * new_window (optional; default "0")

If set to '1', causes the link to open a new window to the linked asset.

=back

=for tags assets

=cut

sub _hdlr_asset_thumbnail_link {
    my ( $ctx, $args ) = @_;
    my $a = $ctx->stash('asset')
        or return $ctx->_no_asset_error();
    my $class = ref($a);
    return '' unless UNIVERSAL::isa( $a, 'MT::Asset::Image' );

    # # Load MT::Image
    # require MT::Image;
    # my $img = new MT::Image(Filename => $a->file_path)
    #     or return $ctx->error(MT->translate(MT::Image->errstr));

    # Get dimensions
    my %arg;
    $arg{Width}  = $args->{width}  if $args->{width};
    $arg{Height} = $args->{height} if $args->{height};
    $arg{Scale}  = $args->{scale}  if $args->{scale};
    $arg{Square} = $args->{square} if $args->{square};
    my ( $url, $w, $h ) = $a->thumbnail_url(%arg);
    my $ret = sprintf qq(<a href="%s"), $a->url;
    if ( $args->{new_window} ) {
        $ret .= qq( target="_blank");
    }
    $ret .= sprintf qq(><img src="%s" width="%d" height="%d" alt="" /></a>),
        $url, $w, $h;
    $ret;
}

###########################################################################

=head2 AssetCount

Returns the number of assets associated with the active blog.

B<Attributes:>

=over 4

=item type

Allows for filtering by file type. Built-in types supported are "image",
"audio", "video". These types can be extended by plugins.

=back

B<Example:>

    Images available: <$mt:AssetCount type="image"$>

=for tags assets

=cut

sub _hdlr_asset_count {
    my ( $ctx, $args, $cond ) = @_;
    my ( %terms, %args );
    $terms{blog_id} = $ctx->stash('blog_id') if $ctx->stash('blog_id');
    $terms{class} = $args->{type} || '*';
    my $count = MT::Asset->count( \%terms, \%args );
    return $ctx->count_format( $count, $args );
}

1;
