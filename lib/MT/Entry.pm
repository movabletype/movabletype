# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Entry;

use strict;
use warnings;

use MT::Tag;        # Holds MT::Taggable
use MT::Summary;    # Holds MT::Summarizable
use base
    qw( MT::Object MT::Taggable MT::Scorable MT::Summarizable MT::Revisable );

use MT::Blog;
use MT::Author;
use MT::Category;
use MT::Memcached;
use MT::Placement;
use MT::Comment;
use MT::TBPing;
use MT::Util qw( archive_file_for start_end_period extract_domain
    extract_domains weaken first_n_words remove_html encode_html trim );
use MT::I18N qw( first_n_text const );

use MT::EntryStatus qw(:all);

use Exporter 'import';
our @EXPORT_OK = qw( HOLD RELEASE FUTURE );
our %EXPORT_TAGS = ( constants => [qw(HOLD RELEASE FUTURE)] );

sub CATEGORY_CACHE_TIME () {604800}    ## 7 * 24 * 60 * 60 == 1 week

__PACKAGE__->install_properties(
    {   column_defs => {
            'id'      => 'integer not null auto_increment',
            'blog_id' => 'integer not null',
            'status'  => {
                type       => 'smallint',
                not_null   => 1,
                label      => 'Status',
                revisioned => 1
            },
            'author_id' => {
                type       => 'integer',
                not_null   => 1,
                label      => 'Author',
                revisioned => 1
            },
            'allow_comments' => {
                type       => 'boolean',
                label      => 'Accept Comments',
                revisioned => 1
            },
            'title' => {
                type       => 'string',
                size       => 255,
                label      => 'Title',
                revisioned => 1
            },
            'excerpt' => {
                type       => 'text',
                label      => 'Excerpt',
                revisioned => 1
            },
            'text' => {
                type       => 'text',
                label      => 'Body',
                revisioned => 1
            },
            'text_more' => {
                type       => 'text',
                label      => 'Extended',
                revisioned => 1
            },
            'convert_breaks' => {
                type       => 'string',
                size       => 60,
                label      => 'Format',
                revisioned => 1
            },
            'to_ping_urls' => 'text',
            'pinged_urls'  => 'text',
            'allow_pings'  => {
                type       => 'boolean',
                label      => 'Accept Trackbacks',
                revisioned => 1
            },
            'keywords' => {
                type       => 'text',
                label      => 'Keywords',
                revisioned => 1
            },
            'tangent_cache' => 'text',
            'basename'      => {
                type       => 'string',
                size       => 255,
                label      => 'Basename',
                revisioned => 1
            },
            'atom_id'     => 'string(255)',
            'authored_on' => {
                type       => 'datetime',
                label      => 'Publish Date',
                revisioned => 1
            },
            'week_number'   => 'integer',
            'template_id'   => 'integer',
            'comment_count' => 'integer',
            'ping_count'    => 'integer',
            'junk_log'      => 'string meta',
            'revision'      => 'integer meta',
## Have to keep this around for use in mt-upgrade.cgi.
            'category_id'    => 'integer',
            'unpublished_on' => {
                type       => 'datetime',
                label      => 'Unpublish Date',
                revisioned => 1
            },
        },
        indexes => {
            status      => 1,
            author_id   => 1,
            created_on  => 1,
            modified_on => 1,

            # For lookups
            comment_count => 1,

            auth_stat_class =>
                { columns => [ 'author_id', 'status', 'class' ], },
            blog_basename => { columns => [ 'blog_id', 'basename' ], },

            # Page listings are published in order by title
            title       => 1,
            blog_author => {
                columns => [ 'blog_id', 'class', 'author_id', 'authored_on' ],
            },

            # For optimizing weekly archives, selected by blog, class,
            # status.
            blog_week => {
                columns => [ 'blog_id', 'class', 'status', 'week_number' ],
            },

            # For system-overview listings where we list all entries of
            # a particular class by authored on date
            class_authored => { columns => [ 'class', 'authored_on' ], },

            # For most blog-level listings, where we list all entries
            # in a blog with a particular class by authored on date.
            blog_authored =>
                { columns => [ 'blog_id', 'class', 'authored_on' ], },

            # For most publishing listings, where we list entries in a blog
            # with a particular class, publish status (2) and authored on date
            blog_stat_date => {
                columns =>
                    [ 'blog_id', 'class', 'status', 'authored_on', 'id' ],
            },

            dd_entry_tag_count =>
                { columns => [ 'blog_id', 'status', 'class', 'id' ], },

            # for tag count
            tag_count =>
                { columns => [ 'status', 'class', 'blog_id', 'id' ], },

            #for future unpublish
            class_unpublished =>
                { columns => [ 'class', 'unpublished_on' ], },
            blog_unpublished =>
                { columns => [ 'blog_id', 'class', 'unpublished_on' ], },
        },
        defaults => {
            comment_count => 0,
            ping_count    => 0,
        },
        child_of      => 'MT::Blog',
        child_classes => [
            'MT::Comment',   'MT::Placement',
            'MT::Trackback', 'MT::FileInfo'
        ],
        audit       => 1,
        meta        => 1,
        summary     => 1,
        datasource  => 'entry',
        primary_key => 'id',
        class_type  => 'entry',
    }
);

sub class_label {
    MT->translate("Entry");
}

sub class_label_plural {
    MT->translate("Entries");
}

sub container_type {
    return "category";
}

sub container_label {
    MT->translate("Category");
}

sub list_props {
    return {
        id => {
            base  => '__virtual.id',
            order => 100,
        },
        title => {
            base       => '__virtual.title',
            label      => 'Title',
            display    => 'force',
            use_blank  => 1,
            order      => 200,
            sub_fields => [
                {   class   => 'status',
                    label   => 'Status',
                    display => 'default',
                },
                {   class   => 'view-link',
                    label   => 'Link',
                    display => 'default',
                },
                {   class   => 'excerpt',
                    label   => 'Excerpt',
                    display => 'optional',
                },
            ],
            html => sub {
                my $prop        = shift;
                my ($obj)       = @_;
                my $class       = $obj->class;
                my $class_label = $obj->class_label;
                my $title       = $prop->super(@_);
                my $excerpt     = remove_html( $obj->excerpt )
                    || remove_html( $obj->text );
                ## FIXME: Hard coded
                my $len = 40;
                if ( length $excerpt > $len ) {
                    $excerpt = substr( $excerpt, 0, $len );
                    $excerpt .= '...';
                }
                my $id        = $obj->id;
                my $permalink = MT::Util::encode_html( $obj->permalink );
                my $edit_url  = MT->app->uri(
                    mode => 'view',
                    args => {
                        _type   => $class,
                        id      => $obj->id,
                        blog_id => $obj->blog_id,
                    }
                );
                my $status = $obj->status;
                my $status_class
                    = $status == MT::Entry::HOLD()      ? 'Draft'
                    : $status == MT::Entry::RELEASE()   ? 'Published'
                    : $status == MT::Entry::REVIEW()    ? 'Review'
                    : $status == MT::Entry::FUTURE()    ? 'Future'
                    : $status == MT::Entry::JUNK()      ? 'Junk'
                    : $status == MT::Entry::UNPUBLISH() ? 'Unpublish'
                    :                                     '';
                my $lc_status_class = lc $status_class;
                my $status_class_trans = MT->translate($status_class);

                my $status_icon_id
                    = $status == MT::Entry::HOLD()      ? 'ic_draft'
                    : $status == MT::Entry::RELEASE()   ? 'ic_checkbox'
                    : $status == MT::Entry::REVIEW()    ? 'ic_error'
                    : $status == MT::Entry::FUTURE()    ? 'ic_clock'
                    : $status == MT::Entry::JUNK()      ? 'ic_error'
                    : $status == MT::Entry::UNPUBLISH() ? 'ic_stop'
                    :                                     '';
                my $status_icon_color_class
                    = $status == MT::Entry::HOLD()      ? ''
                    : $status == MT::Entry::RELEASE()   ? ' mt-icon--success'
                    : $status == MT::Entry::REVIEW()    ? ' mt-icon--warning'
                    : $status == MT::Entry::FUTURE()    ? ' mt-icon--info'
                    : $status == MT::Entry::JUNK()      ? ' mt-icon--warning'
                    : $status == MT::Entry::UNPUBLISH() ? ' mt-icon--danger'
                    :                                     '';

                my $status_img = '';
                if ($status_icon_id) {
                    my $static_uri = MT->static_path;
                    $status_img = qq{
                        <svg role="img" class="mt-icon mt-icon--sm$status_icon_color_class">
                            <title>$status_class_trans</title>
                            <use xlink:href="${static_uri}images/sprite.svg#$status_icon_id"></use>
                        </svg>
                    };
                }

                my $view_link_text
                    = MT->translate( 'View [_1]', $class_label );
                my $static_uri = MT->static_path;
                my $view_link
                    = ( $obj->status == MT::Entry::RELEASE() && $permalink )
                    ? qq{
                    <span class="view-link">
                      <a href="$permalink" class="d-inline-block" target="_blank">
                        <svg role="img" class="mt-icon mt-icon--sm">
                          <title>$view_link_text</title>
                          <use xlink:href="${static_uri}images/sprite.svg#ic_permalink"></use>
                        </svg>
                      </a>
                    </span>
                }
                    : '';

                my $out = qq{
                    <span class="icon status $lc_status_class">
                      <a href="$edit_url" class="d-inline-block">$status_img</a>
                    </span>
                    <span class="title">
                      $title
                    </span>
                    $view_link
                };
                $out .= qq{<p class="excerpt description">$excerpt</p>}
                    if trim($excerpt);
                return $out;
            },
        },
        author_name => {
            base    => '__virtual.author_name',
            order   => 300,
            display => 'default',
        },
        blog_name => {
            base    => '__common.blog_name',
            display => 'default',
            order   => 400,
        },
        category_id => {
            label           => 'Primary Category',
            filter_label    => 'Category',
            filter_tmpl     => '<mt:Var name="filter_form_hidden">',
            order           => 500,
            display         => 'default',
            base            => '__virtual.integer',
            filter_editable => 0,
            col_class       => 'string',
            view_filter     => [ 'website', 'blog' ],
            category_class  => 'category',
            terms           => sub {
                my ( $prop, $args, $db_terms, $db_args ) = @_;
                my $blog_id = MT->app->blog->id;
                my $cat_id  = $args->{value};
                return $prop->error(
                    MT->translate(
                        '[_1] ( id:[_2] ) does not exists.',
                        $prop->datasource->container_label,
                        $cat_id
                    )
                ) unless $cat_id;

                $db_args->{joins} ||= [];
                push @{ $db_args->{joins} },
                    MT->model('placement')->join_on(
                    undef,
                    {   category_id => $cat_id,
                        entry_id    => \'= entry_id',
                        blog_id     => $blog_id,
                    },
                    { unique => 1, },
                    );
                return;
            },
            args_via_param => sub {
                my $prop = shift;
                my ( $app, $val ) = @_;
                my $cat = MT->model('category')->load($val)
                    or return $prop->error(
                    MT->translate(
                        '[_1] ( id:[_2] ) does not exists.',
                        $prop->datasource->container_label,
                        defined $val ? $val : ''
                    )
                    );
                return { option => 'equal', value => $cat->id };
            },
            label_via_param => sub {
                my $prop = shift;
                my ( $app, $val ) = @_;
                my $cat = MT->model('category')->load($val)
                    or return $prop->error(
                    MT->translate(
                        '[_1] ( id:[_2] ) does not exists.',
                        $prop->datasource->container_label,
                        defined $val ? $val : ''
                    )
                    );
                return if !$app->blog || $app->blog->id != $cat->blog_id;
                my $label = MT->translate(
                    'Entries from category: [_1]',
                    $cat->label . " (ID:" . $cat->id . ")",
                );
                $prop->{filter_label} = MT::Util::encode_html($label);
                $label;
            },
        },
        category => {
            label            => 'Primary Category',
            filter_label     => 'Category',
            use_blank        => 1,
            order            => 500,
            display          => 'default',
            base             => '__virtual.string',
            col_class        => 'string',
            col              => 'label',
            view_filter      => [ 'website', 'blog', 'system' ],
            category_class   => 'category',
            zero_state_label => '-',
            bulk_cats        => sub {
                my $prop = shift;
                my ( $objs, $app, $opts ) = @_;
                return ( $opts->{bulk_cats}, $opts->{bulk_placements} )
                    if $opts->{bulk_cats};
                my @entry_ids = map { $_->id } @$objs;
                my @placements = MT->model('placement')->load(
                    {   entry_id   => \@entry_ids,
                        is_primary => 1,
                    },
                    {   fetchonly => {
                            entry_id    => 1,
                            category_id => 1,
                        }
                    }
                );
                unless ( scalar @placements ) {
                    $opts->{bulk_placements} = {};
                    $opts->{bulk_cats}       = {};
                    return ( {}, {} );
                }
                my %placements
                    = map { $_->entry_id => $_->category_id } @placements;
                $opts->{bulk_placements} = \%placements;
                my @cat_ids = map { $_->category_id } @placements;
                my @categories = MT->model( $prop->category_class )->load(
                    { id => \@cat_ids },
                    {   fetchonly => {
                            id    => 1,
                            label => 1,
                        }
                    }
                );
                my %categories = map { $_->id => $_->label } @categories;
                $opts->{bulk_cats} = \%categories;
                return ( \%categories, \%placements );
            },
            bulk_html => sub {
                my $prop = shift;
                my ( $objs, $app, $opts ) = @_;
                my ( $cats, $placs ) = $prop->bulk_cats(@_);
                return map {
                    MT::Util::encode_html( $cats->{ $placs->{ $_->id } || 0 },
                        1 )
                        || $prop->zero_state_label
                } @$objs;
            },
            bulk_sort => sub {
                my $prop = shift;
                my ( $objs, $app, $opts ) = @_;
                my ( $cats, $placs ) = $prop->bulk_cats(@_);
                return sort {
                    (          $cats->{ $placs->{ $a->id } || 0 }
                            || $prop->zero_state_label )
                        cmp(   $cats->{ $placs->{ $b->id } || 0 }
                            || $prop->zero_state_label )
                } @$objs;
            },
            raw => sub {
                my ( $prop, $obj ) = @_;
                my $cat = $obj->category;
                return $cat ? $cat->label : '';
            },

            #condition => sub {
            #    my $app = MT->app or return;
            #    return !$app->blog         ? 0
            #         : $app->blog->is_blog ? 1
            #         :                       0
            #         ;
            #},
            # single_select_options => sub {
            #     my ($prop)     = shift;
            #     my $blog       = MT->app->blog;
            #     my @categories = MT->model( $prop->category_class )
            #         ->load( { blog_id => $blog->id, } );
            #     return [
            #         {   label => MT->translate('NONE'),
            #             value => 0,
            #         },
            #         map {
            #             {   label => $_->label,
            #                 value => $_->id,
            #             }
            #             } @categories
            #     ];
            # },
            terms => sub {
                my $prop = shift;
                my ( $args, $db_terms, $db_args ) = @_;
                my $blog = MT->app->blog;
                my $blog_id
                    = $blog
                    ? $blog->is_blog
                        ? MT->app->blog->id
                        : [ MT->app->blog->id,
                            map { $_->id } @{ $blog->blogs }
                        ]
                    : 0;
                my $app    = MT->instance;
                my $option = $args->{option};
                if ( 'not_contains' eq $option || 'blank' eq $option ) {
                    my $query = $args->{string};
                    my $label_terms
                        = { $prop->col => { like => "%$query%" } };
                    my @placements = MT->model('placement')->load(
                        ( $blog_id ? { blog_id => $blog_id } : undef ),
                        {   unique => 1,
                            join =>
                                MT->model( $prop->category_class )->join_on(
                                undef,
                                [     ( 'blank' eq $option ) ? ()
                                    : ( $label_terms, '-and' ),
                                    {   id => \'= placement_category_id',
                                        (   $blog_id ? ( blog_id => $blog_id )
                                            : ()
                                        ),
                                    },
                                ],
                                { unique => 1, }
                                ),
                        },
                    );
                    my @entry_ids = map { $_->entry_id } @placements;
                    return unless @entry_ids;
                    my %hash;
                    @hash{@entry_ids} = ();
                    @entry_ids = keys %hash;
                    $db_terms->{id} = { not => \@entry_ids };
                    $db_terms->{class}
                        = $prop->category_class eq 'folder'
                        ? 'page'
                        : 'entry';
                }
                else {
                    my $label_terms = $prop->super(@_);
                    push @{ $db_args->{joins} },
                        MT->model('placement')->join_on(
                        undef,
                        {   entry_id => \'= entry_id',
                            ( $blog_id ? ( blog_id => $blog_id ) : () ),
                        },
                        {   unique => 1,
                            join =>
                                MT->model( $prop->category_class )->join_on(
                                undef,
                                [     ( 'not_blank' eq $option ) ? ()
                                    : ( $label_terms, '-and' ),
                                    {   id => \'= placement_category_id',
                                        (   $blog_id ? ( blog_id => $blog_id )
                                            : ()
                                        ),
                                    },
                                ],
                                { unique => 1, }
                                ),
                        },
                        );
                }
                return;
            },
        },
        authored_on => {
            auto       => 1,
            display    => 'default',
            label      => 'Publish Date',
            use_future => 1,
            order      => 600,
            sort       => sub {
                my $prop = shift;
                my ( $terms, $args ) = @_;
                my $dir = delete $args->{direction};
                $dir = ( 'descend' eq $dir ) ? "DESC" : "ASC";
                $args->{sort} = [
                    { column => $prop->col, desc => $dir },
                    { column => "id",       desc => $dir },
                ];
                return;
            },
        },
        modified_on => {
            base  => '__virtual.modified_on',
            order => 700,
        },
        unpublished_on => {
            auto    => 1,
            display => 'optional',
            label   => 'Unpublish Date',
            order   => 750,
        },
        text => {
            auto      => 1,
            display   => 'none',
            label     => 'Body',
            use_blank => 1,
        },
        text_more => {
            auto      => 1,
            display   => 'none',
            label     => 'Extended',
            use_blank => 1,
        },
        excerpt => {
            auto      => 1,
            display   => 'none',
            label     => 'Excerpt',
            use_blank => 1,
        },
        status => {
            label                 => 'Status',
            col                   => 'status',
            display               => 'none',
            col_class             => 'icon',
            base                  => '__virtual.single_select',
            single_select_options => [
                {   label => MT->translate('Draft'),
                    text  => 'Draft',
                    value => 1,
                },
                {   label => MT->translate('Published'),
                    text  => 'Publish',
                    value => 2,
                },
                {   label => MT->translate('Reviewing'),
                    text  => 'Review',
                    value => 3,
                },
                {   label => MT->translate('Scheduled'),
                    text  => 'Future',
                    value => 4,
                },
                {   label => MT->translate('Junk'),
                    text  => 'Spam',
                    value => 5,
                },
                {   label => MT->translate('Unpublished (End)'),
                    text  => 'Unpublish',
                    value => 6,
                },
            ],
        },
        modified_by => {
            base    => '__virtual.modified_by',
            display => 'optional',
        },
        created_on => {
            base    => '__virtual.created_on',
            display => 'none',
        },
        basename => {
            label   => 'Basename',
            display => 'none',
            auto    => 1,
        },
        author_id => {
            auto            => 1,
            filter_editable => 0,
            display         => 'none',
            label           => 'Author ID',
            label_via_param => sub {
                my $prop = shift;
                my ( $app, $val ) = @_;
                my $author = MT->model('author')->load( $val || 0 )
                    or return $prop->error(
                    MT->translate(
                        '[_1] ( id:[_2] ) does not exists.',
                        MT->translate("Author"),
                        defined $val ? $val : ''
                    )
                    );
                return MT->translate( 'Entries by [_1]', $author->nickname, );
            },
        },
        tag          => { base => '__virtual.tag', use_blank => 1 },
        current_user => {
            base            => '__common.current_user',
            label           => 'My Entries',
            filter_editable => 1,
        },
        author_status => {
            base                  => '__virtual.single_select',
            display               => 'none',
            label                 => 'Author Status',
            single_select_options => [
                { label => MT->translate('Deleted'),  value => 'deleted', },
                { label => MT->translate('Enabled'),  value => 'enabled', },
                { label => MT->translate('Disabled'), value => 'disabled', },
            ],
            terms => sub {
                my $prop = shift;
                my ( $args, $db_terms, $db_args ) = @_;
                my $val = $args->{value};
                if ( $val eq 'deleted' ) {
                    my @all_authors = MT->model('author')
                        ->load( undef, { fetchonly => { id => 1 }, }, );
                    return { author_id =>
                            { not => [ map { $_->id } @all_authors ] }, };
                }
                else {
                    my $datasource = $prop->datasource->datasource;
                    my $status
                        = $val eq 'enabled'
                        ? MT::Author::ACTIVE()
                        : MT::Author::INACTIVE();
                    $db_args->{joins} ||= [];
                    push @{ $db_args->{joins} },
                        MT->model('author')->join_on(
                        undef,
                        {   id     => \"= ${datasource}_author_id",
                            status => $status,
                        },
                        );
                }
            },
        },
        current_context => { base => '__common.current_context', },
        blog_id         => {
            auto            => 1,
            col             => 'blog_id',
            display         => 'none',
            filter_editable => 0,
        },
        content => {
            base    => '__virtual.content',
            fields  => [qw(title text text_more keywords excerpt basename)],
            display => 'none',
        },
        __mobile => {
            alternative_label => 'No Name',
            col               => 'title',
            date_col          => 'authored_on',
            display           => 'force',
            filter_editable   => 0,
            html              => sub {
                my $prop = shift;
                my ( $obj, $app ) = @_;
                my $title       = $prop->common_label_html(@_);
                my $status_icon = $obj->status_icon;
                my $date_col    = $prop->date_col;
                my $date
                    = MT::Util::date_for_listing( $obj->$date_col, $app );
                return qq{
                    <div class="title mb-2">$title</div>
                    <span class="status mr-3">$status_icon</span>
                    <span class="date font-weight-light">$date</span>
                };
            },
        },
    };
}

sub system_filters {
    return {
        current_website => {
            label => 'Entries in This Site',
            items => [ { type => 'current_context' } ],
            order => 50,
            view  => 'website',
        },
        published => {
            label => 'Published Entries',
            items => [ { type => 'status', args => { value => '2' }, }, ],
            order => 100,
        },
        draft => {
            label => 'Draft Entries',
            items => [ { type => 'status', args => { value => '1' }, }, ],
            order => 200,
        },
        unpublished => {
            label => 'Unpublished Entries',
            items => [ { type => 'status', args => { value => '6' }, }, ],
            order => 300,
        },
        future => {
            label => 'Scheduled Entries',
            items => [ { type => 'status', args => { value => '4' }, }, ],
            order => 500,
        },
        my_posts_on_this_context => {
            label => 'My Entries',
            items => sub {
                [ { type => 'current_user' }, { type => 'current_context' } ]
                ,;
            },
            order => 500,
        },
    };
}

sub cache_key {
    my ( $entry_id, $key );
    if ( @_ == 3 ) {
        ( $entry_id, $key ) = @_[ 1, 2 ];
    }
    else {
        ( $entry_id, $key ) = ( $_[0]->id, $_[1] );
    }
    return sprintf "entry%s-%d", $key, $entry_id;
}

sub author_id {
    my $entry = shift;
    if ( scalar @_ ) {
        $entry->{__orig_value}->{author_id} = $entry->column('author_id')
            unless exists( $entry->{__orig_value}->{author_id} );
    }
    return $entry->column( 'author_id', @_ );
}

sub status {
    my $entry = shift;
    if ( scalar @_ ) {
        $entry->{__orig_value}->{status} = $entry->column('status')
            unless exists( $entry->{__orig_value}->{status} );
    }
    return $entry->column( 'status', @_ );
}

sub authored_on_obj {
    my $obj = shift;
    return $obj->column_as_datetime('authored_on');
}

sub next {
    my $entry = shift;
    my ($opt) = @_;
    my $terms;
    if ( ref $opt ) {
        $terms = $opt;
    }
    else {
        $terms = $opt ? { status => RELEASE } : {};
    }
    $entry->_nextprev( 'next', $terms );
}

sub previous {
    my $entry = shift;
    my ($opt) = @_;
    my $terms;
    if ( ref $opt ) {
        $terms = $opt;
    }
    else {
        $terms = $opt ? { status => RELEASE } : {};
    }
    $entry->_nextprev( 'previous', $terms );
}

sub _nextprev {
    my $obj   = shift;
    my $class = ref($obj);
    my ( $direction, $terms ) = @_;
    return undef unless ( $direction eq 'next' || $direction eq 'previous' );
    my $next = $direction eq 'next';

    $terms->{author_id} = $obj->author_id if delete $terms->{by_author};
    if ( delete $terms->{by_category} ) {
        if ( my $c = $obj->category ) {
            $terms->{category_id} = $c->id;
        }
        else {
            return undef;
        }
    }

    my $label = '__' . $direction;
    $label .= ':author=' . $terms->{author_id} if exists $terms->{author_id};
    $label .= ':category=' . $terms->{category_id}
        if exists $terms->{category_id};
    return $obj->{$label} if $obj->{$label};

    my $args = {};
    if ( my $cat_id = delete $terms->{category_id} ) {
        my $join = MT::Placement->join_on( 'entry_id',
            { category_id => $cat_id } );
        $args->{join} = $join;
    }

    my $o = $obj->nextprev(
        direction => $direction,
        terms => { blog_id => $obj->blog_id, class => $obj->class, %$terms },
        args  => $args,
        by => ( $class eq 'MT::Page' ) ? 'modified_on' : 'authored_on',
    );
    weaken( $obj->{$label} = $o ) if $o;
    return $o;
}

sub author {
    my $entry = shift;
    $entry->cache_property(
        'author',
        sub {
            my $author_id    = $entry->author_id or return undef;
            my $req          = MT::Request->instance();
            my $author_cache = $req->stash('author_cache');
            my $author       = $author_cache->{$author_id};
            unless ($author) {
                require MT::Author;
                $author = MT::Author->load($author_id) or return undef;
                $author_cache->{$author_id} = $author;
                $req->stash( 'author_cache', $author_cache );
            }
            $author;
        }
    );
}

sub modified_author {
    my $entry = shift;
    $entry->cache_property(
        'modified_author',
        sub {
            my $modified_by  = $entry->modified_by or return undef;
            my $req          = MT::Request->instance();
            my $author_cache = $req->stash('author_cache');
            my $author       = $author_cache->{$modified_by};
            unless ($author) {
                require MT::Author;
                $author = MT::Author->load($modified_by) or return undef;
                $author_cache->{$modified_by} = $author;
                $req->stash( 'author_cache', $author_cache );
            }
            $author;
        }
    );
}

sub __load_category_data {
    my $entry = shift;
    return unless $entry->id;
    my $t     = MT->get_timer;
    $t->pause_partial if $t;
    my $cache  = MT::Memcached->instance;
    my $memkey = $entry->cache_key($entry->id, 'categories');
    my $rows;
    unless ( $rows = $cache->get($memkey) ) {
        require MT::Placement;
        my @maps = MT::Placement->search( { entry_id => $entry->id } );
        $rows = [ map { [ $_->category_id, $_->is_primary ] } @maps ];
        $cache->set( $memkey, $rows, CATEGORY_CACHE_TIME );
    }
    $t->mark('MT::Entry::__load_category_data') if $t;
    return $rows;
}

sub flush_category_cache {
    my ( $copy, $place ) = @_;
    MT::Memcached->instance->delete(
        MT::Entry->cache_key( $place->entry_id, 'categories' ) );
    my $entry = MT::Entry->load( $place->entry_id ) or return;
    $entry->clear_cache('category');
    $entry->clear_cache('categories');
}

MT::Placement->add_trigger( post_save   => \&flush_category_cache );
MT::Placement->add_trigger( post_remove => \&flush_category_cache );

sub category {
    my $entry = shift;
    $entry->cache_property(
        'category',
        sub {
            my $rows = $entry->__load_category_data or return;
            my @rows = grep { $_->[1] } @$rows or return;
            require MT::Category;
            return MT::Category->lookup( $rows[0] );
        }
    );
}

sub categories {
    my $entry = shift;
    $entry->cache_property(
        'categories',
        sub {
            my $rows = $entry->__load_category_data or return;
            my $cats
                = MT::Category->lookup_multi( [ map { $_->[0] } @$rows ] );
            my @cats = sort { $a->label cmp $b->label } @$cats;
            return \@cats;
        }
    );
}

sub is_in_category {
    my $entry = shift;
    my ($cat) = @_;
    my $cats  = $entry->categories;
    for my $c (@$cats) {
        return 1 if $c->id == $cat->id;
    }
    0;
}

sub comments {
    my $entry = shift;
    my ( $terms, $args ) = @_;
    require MT::Comment;
    if ( $terms || $args ) {
        $terms ||= {};
        $terms->{entry_id} = $entry->id;
        return [ MT::Comment->load( $terms, $args ) ];
    }
    else {
        $entry->cache_property(
            'comments',
            sub {
                [ MT::Comment->load( { entry_id => $entry->id } ) ];
            }
        );
    }
}

sub comment_latest {
    my $entry = shift;
    $entry->cache_property(
        'comment_latest',
        sub {
            require MT::Comment;
            MT::Comment->load(
                {   entry_id => $entry->id,
                    visible  => 1
                },
                {   'sort'    => 'created_on',
                    direction => 'descend',
                    limit     => 1,
                }
            );
        }
    );
}

sub archive_file {
    my $entry = shift;
    my ($at)  = @_;
    my $blog  = $entry->blog() || return '';
    unless ($at) {
        $at = $blog->archive_type_preferred || $blog->archive_type;
        return '' if !$at || $at eq 'None';
        return '' if $at eq 'Page';
        my %at = map { $_ => 1 } split /,/, $at;

        # FIXME: should draw from list of registered archive types
        $at = '';
        for my $tat (
            qw( Individual Daily Weekly Author-Monthly Category-Monthly Monthly Category )
            )
        {
            $at = $tat if $at{$tat};
            last;
        }
    }
    my $file = archive_file_for( $entry, $blog, $at );
    $file = '' unless defined $file;
    $file;
}

sub archive_url {
    my $entry = shift;
    my $blog  = $entry->blog() || return;
    my $url   = $blog->archive_url || "";
    $url .= '/' unless $url =~ m!/$!;
    $url . $entry->archive_file(@_);
}

sub permalink {
    my $entry = shift;
    my $blog  = $entry->blog() || return;
    my $url   = $entry->archive_url( $_[0] );
    my $effective_archive_type
        = ( $_[0] || $blog->archive_type_preferred || $blog->archive_type );
    $url
        .= '#'
        . ( $_[1]->{valid_html} ? 'a' : '' )
        . sprintf( "%06d", $entry->id )
        unless ( $effective_archive_type eq 'Individual'
        || $_[1]->{no_anchor} );
    $url;
}

sub all_permalinks {
    my $entry = shift;
    my $blog  = $entry->blog || return;
    my @at    = split /,/, $blog->archive_type;
    return unless @at;
    my @urls;
    for my $at (@at) {
        push @urls, $entry->permalink($at);
    }
    @urls;
}

sub text_filters {
    my $entry   = shift;
    my $filters = $entry->convert_breaks;
    if ( !defined $filters ) {
        my $blog = $entry->blog() || return [];
        $filters = $blog->convert_paras;
    }
    return [] unless $filters;
    if ( $filters eq '1' ) {
        return ['__default__'];
    }
    else {
        return [ split /\s*,\s*/, $filters ];
    }
}

sub get_excerpt {
    my $entry = shift;
    my ($words) = @_;
    return $entry->excerpt if $entry->excerpt;
    my $excerpt
        = MT->apply_text_filters( $entry->text, $entry->text_filters );
    my $blog = $entry->blog() || return;
    first_n_text( $excerpt,
               $words
            || $blog->words_in_excerpt
            || const('DEFAULT_LENGTH_ENTRY_EXCERPT') )
        . '...';
}

sub pinged_url_list {
    my $entry             = shift;
    my (%param)           = @_;
    my $include_failures  = $param{Failures} || $param{OnlyFailures};
    my $exclude_successes = $param{OnlyFailures};
    my $urls              = $entry->pinged_urls;
    return [] unless $urls && $urls =~ /\S/;
    my %urls = map { $_ => 1 } split /\r?\n/, $urls;
    my %to_ping = map { $_ => 1 } @{ $entry->to_ping_url_list };
    foreach ( keys %to_ping ) {
        delete $urls{$_} if exists $urls{$_};
    }
    my @urls = keys %urls;
    foreach (@urls) {
        if (m/^([^ ]+) /) {
            delete $urls{$_};    # remove ones with error messages
            $urls{$1} = 1 if $include_failures;
        }
        else {
            delete $urls{$_} if $exclude_successes;
        }
    }
    [ sort keys %urls ];
}

sub to_ping_url_list {
    my $entry = shift;
    my $urls  = $entry->to_ping_urls;
    return [] unless $urls && $urls =~ /\S/;
    [ split /\r?\n/, $urls ];
}

# TBD: Write a test for this routine
sub make_atom_id {
    my $entry = shift;

    my $blog = $entry->blog;
    my ( $host, $year, $path, $blog_id, $entry_id );
    $blog_id  = $blog->id;
    $entry_id = $entry->id;
    my $url = $blog->site_url || '';
    return unless $url;
    $url .= '/' unless $url =~ m!/$!;
    if ( $url && ( $url =~ m!^https?://([^/:]+)(?::\d+)?(/.*)$! ) ) {
        $host = $1;
        $path = $2;
    }
    if ( $entry->authored_on && ( $entry->authored_on =~ m/^(\d{4})/ ) ) {
        $year = $1;
    }
    return unless $host && $year && $path && $blog_id && $entry_id;
    qq{tag:$host,$year:$path/$blog_id.$entry_id};
}

# Deprecated (case #112321).
sub sync_assets {
    require MT::Util::Deprecated;
    MT::Util::Deprecated::warning(since => '7.8');

    my $entry = shift;
    my $text = ( $entry->text || '' ) . "\n" . ( $entry->text_more || '' );

    require MT::ObjectAsset;
    my @assets = MT::ObjectAsset->load(
        {   object_id => $entry->id,
            blog_id   => $entry->blog_id,
            object_ds => $entry->datasource,
            embedded  => 1,
        }
    );
    my %assets = map { $_->asset_id => $_->id } @assets;
    while ( $text
        =~ m!<form[^>]*?\smt:asset-id=["'](\d+)["'][^>]*?>(.+?)</form>!gis )
    {
        my $id      = $1;
        my $innards = $2;

        # reference to an existing asset...
        if ( exists $assets{$id} ) {
            $assets{$id} = 0;
        }
        else {

            # is asset exists?
            my $asset = MT->model('asset')->load( { id => $id } ) or next;

            my $map = new MT::ObjectAsset;
            $map->blog_id( $entry->blog_id );
            $map->asset_id($id);
            $map->object_ds( $entry->datasource );
            $map->object_id( $entry->id );
            $map->embedded(1);
            $map->save;
            $assets{$id} = 0;
        }
    }
    if ( my @old_maps = grep { $assets{ $_->asset_id } } @assets ) {
        my @old_ids = map { $_->id } grep { $_->embedded } @old_maps;
        MT::ObjectAsset->remove( { id => \@old_ids } )
            if @old_ids;
    }
    return 1;
}

sub save {
    my $entry = shift;
    my $is_new = $entry->id ? 0 : 1;

    ## If there's no basename specified, create a unique basename.
    if ( !defined( $entry->basename ) || ( $entry->basename eq '' ) ) {
        my $name = MT::Util::make_unique_basename($entry);
        $entry->basename($name);
    }

    require bytes;
    if ( bytes::length($entry->basename) > 246 ) {
        return $entry->error( MT->translate("basename is too long." ) );
    }

    if ( !$entry->id && !$entry->authored_on ) {
        my @ts = MT::Util::offset_time_list( time, $entry->blog_id );
        my $ts = sprintf '%04d%02d%02d%02d%02d%02d',
            $ts[5] + 1900, $ts[4] + 1, @ts[ 3, 2, 1, 0 ];
        $entry->authored_on($ts);
    }
    if ( my $dt = $entry->authored_on_obj ) {
        my ( $yr, $w ) = $dt->week;
        $entry->week_number( $yr * 100 + $w )
            if $yr * 100 + $w != ( $entry->week_number || 0 );
    }
    unless ( $entry->SUPER::save(@_) ) {
        print STDERR "error during save: " . $entry->errstr . "\n";
        die $entry->errstr;
    }
    if ( !$entry->atom_id && ( ( $entry->status || 0 ) != HOLD ) ) {
        $entry->atom_id( $entry->make_atom_id() );
        $entry->SUPER::save(@_) if $entry->atom_id;
    }

    ## If pings are allowed on this entry, create or update
    ## the corresponding TrackBack object for this entry.
    if ( MT->has_plugin('Trackback') ) {
        require Trackback::Entry;
        Trackback::Entry::_save_trackback($entry);
    }

    $entry->clear_cache() if $is_new;

    my $blog = $entry->blog;
    my $at
        = $blog->archive_type_preferred
        || $blog->archive_type
        || 'Individual';
    $at = 'Page' if $entry->class eq 'page';

    my $key;
    my $publisher  = MT->instance->publisher;
    my $cache_file = MT::Request->instance->cache('file');
    $key = $publisher->archive_file_cache_key( $entry, $blog, $at )
        if $publisher->can('archive_file_cache_key');
    delete $cache_file->{$key}
        if $key && $cache_file && exists $cache_file->{$key};

    1;
}

sub remove {
    my $entry = shift;
    if ( ref $entry ) {
        $entry->remove_children( { key => 'entry_id' } ) or return;

        # Remove MT::ObjectAsset records
        my $class = MT->model('objectasset');
        $class->remove(
            { object_id => $entry->id, object_ds => $entry->datasource } );
    }

    $entry->SUPER::remove(@_);
}

sub blog {
    my ($entry) = @_;
    $entry->cache_property(
        'blog',
        sub {
            my $blog_id = $entry->blog_id;
            require MT::Blog;
            MT::Blog->load($blog_id)
                or $entry->error(
                MT->translate(
                    "Loading blog '[_1]' failed: [_2]",
                    $blog_id,
                    MT::Blog->errstr
                        || MT->translate("record does not exist.")
                )
                );
        }
    );
}

sub to_hash {
    my $entry = shift;
    my $hash  = $entry->SUPER::to_hash(@_);

    $hash->{'entry.text_html'}
        = sub { MT->apply_text_filters( $entry->text, $entry->text_filters ) };
    $hash->{'entry.text_more_html'} = sub {
        MT->apply_text_filters( $entry->text_more, $entry->text_filters );
    };
    $hash->{'entry.permalink'}                     = $entry->permalink;
    $hash->{'entry.status_text'}                   = $entry->status_text;
    $hash->{ 'entry.status_is_' . $entry->status } = 1;
    $hash->{'entry.created_on_iso'}
        = sub { MT::Util::ts2iso( $entry->blog_id, $entry->created_on ) };
    $hash->{'entry.modified_on_iso'}
        = sub { MT::Util::ts2iso( $entry->blog_id, $entry->modified_on ) };
    $hash->{'entry.authored_on_iso'}
        = sub { MT::Util::ts2iso( $entry->blog_id, $entry->authored_on ) };

    # Populate author info
    my $auth = $entry->author or return $hash;
    my $auth_hash = $auth->to_hash;
    $hash->{"entry.$_"} = $auth_hash->{$_} foreach keys %$auth_hash;

    $hash;
}

# overrides MT::Revisable method
sub gather_changed_cols {
    my $obj = shift;
    my ( $orig, $app ) = @_;

    MT::Revisable::gather_changed_cols( $obj, @_ );
    my $changed_cols = $obj->{changed_revisioned_cols} || [];

    # When an entry is saved at first and 'unpublished_on' is undef,
    # 'unpublished_on' is added to 'changed_revisioned_cols'.
    unless ( $obj->id ) {
        unless ( $obj->unpublished_on ) {
            push @$changed_cols, 'unpublished_on';
            $obj->{changed_revisioned_cols} = $changed_cols;
        }
        return 1;
    }

    # there is a changed col; no need to check something else
    return 1 if @$changed_cols;

    # check if tag was changed
    my $tag_changed = 0;
    my @objecttags  = MT->model('objecttag')->load(
        {   object_id         => $obj->id,
            object_datasource => $obj->datasource,
            blog_id           => $obj->blog_id
        }
    );

    # This relies on the fact that MT::CMS::Entry::pre_save is called before
    # (callback priority) and set_tags has already done the right job to tags.
    my @tag_names = $obj->get_tags;

    # the number of tags have changed
    $tag_changed = 1 if scalar(@tag_names) != scalar(@objecttags);

    unless ($tag_changed) {
        if (@tag_names) {
            my @tags = MT::Tag->load( { name => \@tag_names },
                { binary => { name => 1 } } );

            # XXX: just in case...
            $tag_changed = 1 if scalar(@tags) != scalar(@objecttags);

            my %tags = map { $_->id => 1 } @tags;
            foreach my $objecttag (@objecttags) {
                delete $tags{ $objecttag->tag_id };
            }

            # there are changes in the list of tags
            $tag_changed = 1 if keys(%tags);
        }
    }

    push @$changed_cols, 'tags' if $tag_changed;

    # check if category was changed
    my $cat_changed = 0;
    my @category_ids;
    eval {
        @category_ids = split /\s*,\s*/,
            ( $app->param('category_ids') || '' );

     # page has root folder (id:-1) for default and should be removed from ids
        @category_ids = grep { $_ != -1 } @category_ids;
    };
    unless ($@) {
        my @placements
            = MT->model('placement')->load( { entry_id => $obj->id } );

        # the number of categories have changed
        $cat_changed = 1 if scalar(@category_ids) != scalar(@placements);

        my $primary_cat_id;
        unless ($cat_changed) {
            my %categories = map { $_ => 1 } @category_ids;
            foreach my $placement (@placements) {
                $primary_cat_id = $placement->category_id
                    if $placement->is_primary;
                delete $categories{ $placement->category_id };
            }

            # there are changes in the list of categories
            $cat_changed = 1 if keys(%categories);
        }

        unless ($cat_changed) {
            if ((      @category_ids
                    && $primary_cat_id
                    && ( $category_ids[0] != $primary_cat_id )
                )
                || ( !$primary_cat_id && @category_ids )
                || ( $primary_cat_id  && !@category_ids )
                )
            {

                # primary category was changed
                $cat_changed = 1;
            }
        }

        push @$changed_cols, 'categories' if $cat_changed;
    }

    $obj->{changed_revisioned_cols} = $changed_cols
        if $cat_changed || $tag_changed;
    1;
}

sub pack_revision {
    my $obj    = shift;
    my $values = MT::Revisable::pack_revision($obj);

    # add category placements and tag associations
    my ( @tags, @cats );
    if ( my $tags = $obj->get_tag_objects ) {
        @tags = map { $_->id } @$tags
            if @$tags;
    }

    # a revision may remove all the tags
    $values->{__rev_tags} = \@tags;

    my $primary = $obj->category;
    if ( my $cats = $obj->categories ) {
        @cats = map { [ $_->id, $_->id == $primary->id ? 1 : 0 ] } @$cats
            if @$cats;
    }

    # a revision may remove all the categories
    $values->{__rev_cats} = \@cats;

    $values;
}

sub unpack_revision {
    my $obj = shift;
    my ($packed_obj) = @_;
    MT::Revisable::unpack_revision( $obj, @_ );

    # restore category placements and tag associations
    if ( my $rev_tags = delete $packed_obj->{__rev_tags} ) {
        delete $obj->{__tags};
        delete $obj->{__tag_objects};
        MT::Tag->clear_cache(
            datasource => $obj->datasource,
            ( $obj->blog_id ? ( blog_id => $obj->blog_id ) : () )
        );

        require MT::Memcached;
        MT::Memcached->instance->delete( $obj->tag_cache_key );

        if (@$rev_tags) {
            my $lookups = MT::Tag->lookup_multi($rev_tags);
            my @tags = grep {defined} @$lookups;
            $obj->{__tags}             = [ map { $_->name } @tags ];
            $obj->{__tag_objects}      = \@tags;
            $obj->{__missing_tags_rev} = 1
                if scalar(@tags) != scalar(@$lookups);
        }
        else {
            $obj->{__tags}        = [];
            $obj->{__tag_objects} = [];
        }
    }

    if ( my $rev_cats = delete $packed_obj->{__rev_cats} ) {
        $obj->clear_cache('category');
        $obj->clear_cache('categories');

        my ( $cat, @cats );
        if (@$rev_cats) {
            my ($primary) = grep { $_->[1] } @$rev_cats;
            $cat = MT::Category->lookup( $primary->[0] );
            my $cats = MT::Category->lookup_multi(
                [ map { $_->[0] } @$rev_cats ] );
            @cats = sort { $a->label cmp $b->label } grep {defined} @$cats;
            $obj->{__missing_cats_rev} = 1
                if scalar(@cats) != scalar(@$cats);
        }
        $obj->cache_property( 'category',   undef, $cat );
        $obj->cache_property( 'categories', undef, \@cats );
    }
}

sub is_entry {
    my $class = shift;
    return $class->class eq 'entry' ? 1 : 0;
}

sub terms_for_tags {
    return { status => MT::Entry::RELEASE() };
}

sub attach_categories {
    my $obj = shift;
    my @cats = @_ or return [];

    # Check whether or not all arguments are MT:Category objects.
    for my $cat (@cats) {
        next if eval { $cat->isa('MT::Category') } && $cat->id;
        return $obj->error(
            MT->translate(
                'Invalid arguments. They all need to be saved MT::Category objects.'
            )
        );
    }

    # Remove already attached categories.
    my @attach_cats;
    my @current_place = MT->model('placement')->load(
        {   entry_id    => $obj->id,
            category_id => [ map { $_->id } @cats ],
        }
    );
    for my $cat (@cats) {
        next if grep { $_->category_id == $cat->id } @current_place;
        push @attach_cats, $cat;
    }

    # Attach assets.
    my $has_primary = MT->model('placement')->count(
        {   entry_id   => $obj->id,
            is_primary => 1,
        }
    );
    my $current_cats = $obj->categories;
    for my $cat (@attach_cats) {
        my $place = MT->model('placement')->new;
        $place->set_values(
            {   blog_id     => $obj->blog->id,
                entry_id    => $obj->id,
                category_id => $cat->id,
                is_primary  => $has_primary ? 0 : 1,
            },
        );
        $place->save or return $obj->error( $place->errstr );

        # Update cache.
        $obj->cache_property( 'category', undef, $cat )
            unless $has_primary;

        # Entry does not have more than one primary category.
        $has_primary = 1;
    }

    # Update cache.
    my @new_cats = (
        @attach_cats, $current_cats && @$current_cats ? @$current_cats : ()
    );
    @new_cats = sort { $a->label cmp $b->label } @new_cats;
    $obj->cache_property( 'categories', undef, \@new_cats );

    return \@attach_cats;
}

sub update_categories {
    my $obj  = shift;
    my @cats = @_;

    # Check whether or not all arguments are MT:Category objects.
    for my $cat (@cats) {
        next if eval { $cat->isa('MT::Category') } && $cat->id;
        return $obj->error(
            MT->translate(
                'Invalid arguments. They all need to be saved MT::Category objects.'
            )
        );
    }

    # Detach all if no category.
    unless (@cats) {
        MT::Placement->remove( { entry_id => $obj->id, } )
            or return $obj->error( MT::Placement->errstr );

        MT::Memcached->instance->delete(
            MT::Entry->cache_key( $obj->id, 'categories' ) );
        $obj->clear_cache('category');
        $obj->clear_cache('categories');

        return [];
    }

    # Detach categories
    MT::Placement->remove(
        {   entry_id    => $obj->id,
            category_id => { not => [ map { $_->id } @cats ] },
        }
    ) or return $obj->error( MT::Placement->errstr );

    # Attach/update categories
    my $is_primary    = 1;
    my @current_place = MT::Placement->load(
        {   blog_id  => $obj->blog_id,
            entry_id => $obj->id,
        }
    );
    for my $cat (@cats) {
        my ($place) = grep { $_->category_id == $cat->id } @current_place;
        if ($place) {

            # Already attached category.
            # If is_primary field is changed, save MT::Placement record.
            do { $is_primary = 0; next } if $place->is_primary == $is_primary;
            $place->is_primary($is_primary);
        }
        else {
            $place = MT::Placement->new;
            $place->set_values(
                {   blog_id     => $obj->blog_id,
                    entry_id    => $obj->id,
                    category_id => $cat->id,
                    is_primary  => $is_primary,
                }
            );
        }
        $place->save or return $obj->error( $place->errstr );

        # Update cache.
        $obj->cache_property( 'category', undef, $cat ) if $is_primary;

        # Entry does not have more than one primary category.
        $is_primary = 0;
    }

    # Update cache.
    @cats = sort { $a->label cmp $b->label } @cats;
    $obj->cache_property( 'categories', undef, \@cats );

    return \@cats;
}

sub attach_assets {
    my $obj = shift;
    my @assets = @_ or return [];

    # Check whether or not all arguments are MT:Asset objects.
    for my $asset (@assets) {
        next if eval { $asset->isa('MT::Asset') } && $asset->id;
        return $obj->error(
            MT->translate(
                'Invalid arguments. They all need to be saved MT::Asset objects.'
            )
        );
    }

    # Remove already attached assets.
    my @attach_assets;
    my @current_oa = MT->model('objectasset')->load(
        {   blog_id   => $obj->blog->id,
            object_ds => 'entry',
            object_id => $obj->id,
            asset_id  => [ map { $_->id } @assets ],
        },
    );
    for my $asset (@assets) {
        next if grep { $_->asset_id == $asset->id } @current_oa;
        push @attach_assets, $asset;
    }

    # Attach assets.
    for my $asset (@attach_assets) {
        my $oa = MT->model('objectasset')->new;
        $oa->set_values(
            {   blog_id   => $obj->blog->id,
                object_ds => 'entry',
                object_id => $obj->id,
                asset_id  => $asset->id,
            }
        );
        $oa->save or return $oa->errstr;
    }

    return \@attach_assets;
}

sub update_assets {
    my $obj    = shift;
    my @assets = @_;

    # Check whether or not all arguments are MT:Asset objects.
    for my $asset (@assets) {
        next if eval { $asset->isa('MT::Asset') } && $asset->id;
        return $obj->error(
            MT->translate(
                'Invalid arguments. They all need to be saved MT::Asset objects.'
            )
        );
    }

    # Detach all assets if no assets.
    unless (@assets) {
        MT->model('objectasset')->remove(
            {   object_ds => 'entry',
                object_id => $obj->id,
            }
        ) or return $obj->error( MT->model('objectasset')->errstr );
        return [];
    }

    # Detach assets.
    my @asset_ids = map { $_->id } @assets;
    MT->model('objectasset')->remove(
        {   object_ds => 'entry',
            object_id => $obj->id,
            asset_id  => { not => \@asset_ids },
        }
    ) or return $obj->error( MT->model('objectasset')->errstr );

    # Remove already attached assets.
    my @attaching_assets = @assets;
    my @current_oa       = MT->model('objectasset')->load(
        {   object_ds => 'entry',
            object_id => $obj->id,
            asset_id  => \@asset_ids,
        }
    );
    if (@current_oa) {
        my %current_oa_id = map { ( $_->asset_id => 1 ) } @current_oa;
        @assets = grep { !$current_oa_id{ $_->id } } @assets;
    }

    # Attach assets.
    for my $asset (@assets) {
        my $oa = MT->model('objectasset')->new;
        $oa->set_values(
            {   blog_id   => $obj->blog->id,
                object_ds => 'entry',
                object_id => $obj->id,
                asset_id  => $asset->id,
            }
        );
        $oa->save or return $obj->error( $oa->errstr );
    }

    return \@attaching_assets;
}

sub set_values {
    my $obj = shift;
    my ( $values, $args ) = @_;

    $obj->SUPER::set_values(@_);

    # If 'unpublished_on' in revision data is undef, set value.
    return unless grep { $_ eq 'unpublished_on' } keys %$values;
    return if defined $values->{'unpublished_on'};
    if (   $args
        && exists( $args->{no_changed_flag} )
        && $args->{no_changed_flag} )
    {
        $obj->column( 'unpublished_on', $values->{'unpublished_on'}, $args );
    }
    else {
        $obj->unpublished_on( $values->{'unpublished_on'}, $args );
    }
}

# Register entry post-save callback for rebuild triggers
MT->add_callback(
    'cms_post_save.entry', 10,
    MT->component('core'),
    sub { MT->model('rebuild_trigger')->runner( 'post_entry_save', @_ ); }
);
MT->add_callback(
    'api_post_save.entry', 10,
    MT->component('core'),
    sub { MT->model('rebuild_trigger')->runner( 'post_entry_save', @_ ); }
);
MT->add_callback(
    'cms_post_bulk_save.entries',
    10,
    MT->component('core'),
    sub {
        MT->model('rebuild_trigger')->runner( 'post_entries_bulk_save', @_ );
    }
);
MT->add_callback(
    'scheduled_post_published', 10,
    MT->component('core'),
    sub { MT->model('rebuild_trigger')->runner( 'post_entry_pub', @_ ); }
);
MT->add_callback(
    'unpublish_past_entries', 10,
    MT->component('core'),
    sub { MT->model('rebuild_trigger')->runner( 'post_entry_unpub', @_ ); }
);

#trans('Draft')
#trans('Review')
#trans('Future')
#trans('Spam')

1;
__END__

=head1 NAME

MT::Entry - Movable Type entry record

=head1 SYNOPSIS

    use MT::Entry;
    my $entry = MT::Entry->new;
    $entry->blog_id($blog->id);
    $entry->status(MT::Entry::RELEASE());
    $entry->author_id($author->id);
    $entry->title('My title');
    $entry->text('Some text');
    $entry->save
        or die $entry->errstr;

=head1 DESCRIPTION

An I<MT::Entry> object represents an entry in the Movable Type system. It
contains all of the metadata about the entry (author, status, category, etc.),
as well as the actual body (and extended body) of the entry.

=head1 USAGE

As a subclass of I<MT::Object>, I<MT::Entry> inherits all of the
data-management and -storage methods from that class; thus you should look
at the I<MT::Object> documentation for details about creating a new object,
loading an existing object, saving an object, etc.

The following methods are unique to the I<MT::Entry> interface:

=head2 $entry->next

Loads and returns the next entry, where "next" is defined as the next record
in ascending chronological order (the entry posted after the current entry).
entry I<$entry>).

Returns an I<MT::Entry> object representing this next entry; if there is not
a next entry, returns C<undef>.

Caches the return value internally so that subsequent calls will not have to
re-query the database.

=head2 $entry->previous

Loads and returns the previous entry, where "previous" is defined as the
previous record in ascending chronological order (the entry posted before the
current entry I<$entry>).

Returns an I<MT::Entry> object representing this previous entry; if there is
not a next entry, returns C<undef>.

Caches the return value internally so that subsequent calls will not have to
re-query the database.

=head2 $entry->author

Returns an I<MT::Author> object representing the author of the entry
I<$entry>. If the author record has been removed, returns C<undef>.

Caches the return value internally so that subsequent calls will not have to
re-query the database.

=head2 $entry->category

Returns an I<MT::Category> object representing the primary category of the
entry I<$entry>. If a primary category has not been assigned, returns
C<undef>.

Caches the return value internally so that subsequent calls will not have to
re-query the database.

=head2 $entry->categories

Returns a reference to an array of I<MT::Category> objects representing the
categories to which the entry I<$entry> has been assigned (both primary and
secondary categories). If the entry has not been assigned to any categories,
returns a reference to an empty array.

Caches the return value internally so that subsequent calls will not have to
re-query the database.

=head2 $entry->is_in_category($cat)

Returns true if the entry I<$entry> has been assigned to entry I<$cat>, false
otherwise.

=head2 $entry->comments

Returns a reference to an array of I<MT::Comment> objects representing the
comments made on the entry I<$entry>. If no comments have been made on the
entry, returns a reference to an empty array.

Caches the return value internally so that subsequent calls will not have to
re-query the database.

=head2 $entry->archive_file([ $archive_type ])

Returns the name of/path to the archive file for the entry I<$entry>. If
I<$archive_type> is not specified, and you are using multiple archive types
for your blog, the path is created from the preferred archive type that you
have selected. If I<$archive_type> is specified, it should be one of the
following values: C<Individual>, C<Daily>, C<Weekly>, C<Monthly>, and
C<Category>.

=head2 $entry->archive_url([ $archive_type ])

Returns the absolute URL to the archive page for the entry I<$entry>. This
calls I<archive_file> internally, so if I<$archive_type> is specified, it
is merely passed through to that method. In other words, this is the
blog Archive URL plus the results of I<archive_file>.

=head2 $entry->permalink([ $archive_type ])

Returns the (smart) permalink for the entry I<$entry>. Internally this calls
I<archive_url>, which calls I<archive_file>, so I<$archive_type> (if
specified) is merely passed through to that method. The result of this
method is the same as I<archive_url> plus the URI fragment
(C<#entry_id>), unless the preferred archive type is Individual, in which
case the two methods give exactly the same results.

=head2 $entry->text_filters

Returns a reference to an array of text filter keynames (the short names
that are the first argument to I<MT::add_text_filter>. This list can be
passed directly in as the second argument to I<MT::apply_text_filters>.

=head2 $entry->attach_categories(@categories)

Attaches I<@categories> to the entry. If I<@categories> is empty, this method
returns array reference of empty array. If I<@categories> contains non MT::Category
object or unsaved MT::Category object, this method returns undef, This method
returns array reference of attached categories.

=head2 $entry->update_categories(@categories)

Updates attached categories with I<@categories>. If I<@categories> is empty,
all categories will be detached. This method returns array reference of categories
attaching entry.

=head2 $entry->attach_assets(@assets)

Attaches I<@assets> to the entry. If I<@assets> is empty, this method returns array
reference of empty array. If I<@assets> contains non MT::Asset object or
unsaved MT::Asset object, this method returns undef. This method returns
array reference of attached assets.

=head2 $entry->update_assets(@assets)

Updates attached assets with I<@assets>. If I<@assets> is empty, all assets will be detached.
This method returns array reference of assets attaching entry.

=head1 DATA ACCESS METHODS

The I<MT::Entry> object holds the following pieces of data. These fields can
be accessed and set using the standard data access methods described in the
I<MT::Object> documentation.

=over 4

=item * id

The numeric ID of the entry.

=item * blog_id

The numeric ID of the blog in which this entry has been posted.

=item * author_id

The numeric ID of the author who posted this entry.

=item * status

The status of the entry, either Publish (C<2>) or Draft (C<1>).

=item * allow_comments

An integer flag specifying whether comments are allowed on this entry. This
setting determines whether C<E<lt>MTEntryIfAllowCommentsE<gt>> containers are
displayed for this entry. Possible values are 0 for not allowing any additional
comments and 1 for allowing new comments to be made on the entry.

=item * convert_breaks

A boolean flag specifying whether line and paragraph breaks should be converted
when rebuilding this entry.

=item * title

The title of the entry.

=item * excerpt

The excerpt of the entry.

=item * text

The main body text of the entry.

=item * text_more

The extended body text of the entry.

=item * created_on

The timestamp denoting when the entry record was created, in the format
C<YYYYMMDDHHMMSS>. Note that the timestamp has already been adjusted for the
selected timezone.

=item * modified_on

The timestamp denoting when the entry record was last modified, in the
format C<YYYYMMDDHHMMSS>. Note that the timestamp has already been adjusted
for the selected timezone.

=back

=head1 DATA LOOKUP

In addition to numeric ID lookup, you can look up or sort records by any
combination of the following fields. See the I<load> documentation in
I<MT::Object> for more information.

=over 4

=item * blog_id

=item * status

=item * author_id

=item * created_on

=item * modified_on

=back

=head1 NOTES

=over 4

=item *

When you remove an entry using I<MT::Entry::remove>, in addition to removing
the entry record, all of the comments and placements (I<MT::Comment> and
I<MT::Placement> records, respectively) for this entry will also be removed.

=back

=head1 AUTHOR & COPYRIGHTS

Please see the I<MT> manpage for author, copyright, and license information.

=cut
