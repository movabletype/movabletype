# Movable Type (r) (C) 2001-2013 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Entry;

use strict;

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
use MT::Util qw( archive_file_for discover_tb start_end_period extract_domain
    extract_domains weaken first_n_words remove_html encode_html trim );
use MT::I18N qw( const );

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

sub HOLD ()     {1}
sub RELEASE ()  {2}
sub REVIEW ()   {3}
sub FUTURE ()   {4}
sub JUNK ()     {5}
sub UNPUBLISH() {6}

use Exporter;
*import = \&Exporter::import;
use vars qw( @EXPORT_OK %EXPORT_TAGS);
@EXPORT_OK = qw( HOLD RELEASE FUTURE );
%EXPORT_TAGS = ( constants => [qw(HOLD RELEASE FUTURE)] );

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
                require MT::Entry;
                my $status_file
                    = $status == MT::Entry::HOLD()      ? 'draft.gif'
                    : $status == MT::Entry::RELEASE()   ? 'success.gif'
                    : $status == MT::Entry::REVIEW()    ? 'warning.gif'
                    : $status == MT::Entry::FUTURE()    ? 'future.gif'
                    : $status == MT::Entry::JUNK()      ? 'warning.gif'
                    : $status == MT::Entry::UNPUBLISH() ? 'unpublished.gif'
                    :                                     '';
                my $status_img
                    = MT->static_path . 'images/status_icons/' . $status_file;
                my $view_img
                    = MT->static_path . 'images/status_icons/view.gif';
                my $view_link_text
                    = MT->translate( 'View [_1]', $class_label );
                my $view_link = $obj->status == MT::Entry::RELEASE()
                    ? qq{
                    <span class="view-link">
                      <a href="$permalink" target="_blank">
                        <img alt="$view_link_text" src="$view_img" />
                      </a>
                    </span>
                }
                    : '';

                my $out = qq{
                    <span class="icon status $lc_status_class">
                      <a href="$edit_url"><img alt="$status_class" src="$status_img" /></a>
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
                push @{ $db_args->{joins} }, MT->model('placement')->join_on(
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
                my $id  = MT->app->param('filter_val');
                my $cat = MT->model('category')->load($id)
                    or return $prop->error(
                    MT->translate(
                        '[_1] ( id:[_2] ) does not exists.',
                        $prop->datasource->container_label,
                        $id
                    )
                    );
                return { option => 'equal', value => $cat->id };
            },
            label_via_param => sub {
                my $prop  = shift;
                my ($app) = @_;
                my $id    = $app->param('filter_val');
                my $cat   = MT->model('category')->load($id)
                    or return $prop->error(
                    MT->translate(
                        '[_1] ( id:[_2] ) does not exists.',
                        $prop->datasource->container_label,
                        $id
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
            order            => 500,
            display          => 'default',
            base             => '__virtual.string',
            col_class        => 'string',
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
                my ( $prop, $args, $db_terms, $db_args ) = @_;
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
                my $query  = $args->{string};
                if ( 'contains' eq $option ) {
                    $query = { like => "%$query%" };
                }
                elsif ( 'not_contains' eq $option ) {
                    $query = { not_like => "%$query%" };
                }
                elsif ( 'beginning' eq $option ) {
                    $query = { like => "$query%" };
                }
                elsif ( 'end' eq $option ) {
                    $query = { like => "%$query" };
                }
                push @{ $db_args->{joins} }, MT->model('placement')->join_on(
                    undef,
                    {   entry_id => \'= entry_id',
                        ( $blog_id ? ( blog_id => $blog_id ) : () ),
                    },
                    {   unique => 1,
                        join   => MT->model( $prop->category_class )->join_on(
                            undef,
                            {   label => $query,
                                id    => \'= placement_category_id',
                                ( $blog_id ? ( blog_id => $blog_id ) : () ),
                            },
                            { unique => 1, }
                        ),
                    },
                );
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
        comment_count => {
            auto         => 1,
            display      => 'default',
            label        => 'Comments',
            filter_label => '__COMMENT_COUNT',
            order        => 800,
            html_link    => sub {
                my $prop = shift;
                my ( $obj, $app, $opts ) = @_;
                return unless $app->can_do('access_to_comment_list');
                return $app->uri(
                    mode => 'list',
                    args => {
                        _type      => 'comment',
                        filter     => 'entry',
                        filter_val => $obj->id,
                        blog_id    => $opts->{blog_id} || 0,
                    },
                );
            },
        },
        ping_count => {
            auto         => 1,
            display      => 'optional',
            label        => 'Trackbacks',
            filter_label => '__PING_COUNT',
            order        => 900,
            html_link    => sub {
                my $prop = shift;
                my ( $obj, $app, $opts ) = @_;
                return unless $app->can_do('access_to_trackback_list');
                return $app->uri(
                    mode => 'list',
                    args => {
                        _type      => 'ping',
                        filter     => 'entry_id',
                        filter_val => $obj->id,
                        blog_id    => $opts->{blog_id} || 0,
                    },
                );
            },
        },
        text => {
            auto    => 1,
            display => 'none',
            label   => 'Body',
        },
        text_more => {
            auto    => 1,
            display => 'none',
            label   => 'Extended',
        },
        excerpt => {
            auto    => 1,
            display => 'none',
            label   => 'Excerpt',
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
        created_on => {
            base    => '__virtual.created_on',
            display => 'none',
        },
        basename => {
            label   => 'Basename',
            display => 'none',
            auto    => 1,
        },
        commented_on => {
            base          => '__virtual.date',
            label         => 'Date Commented',
            comment_class => 'comment',
            display       => 'none',
            terms         => sub {
                my $prop = shift;
                my ( $args, $db_terms, $db_args ) = @_;
                my $option = $args->{option};
                my $query;
                my $blog = MT->app ? MT->app->blog : undef;
                require MT::Util;
                my $now = MT::Util::epoch2ts( $blog, time() );
                my $from   = $args->{from}   || undef;
                my $to     = $args->{to}     || undef;
                my $origin = $args->{origin} || undef;
                $from   =~ s/\D//g;
                $to     =~ s/\D//g;
                $origin =~ s/\D//g;
                $from .= '000000' if $from;
                $to   .= '235959' if $to;

                if ( 'range' eq $option ) {
                    $query = [
                        '-and',
                        { op => '>', value => $from },
                        { op => '<', value => $to },
                    ];
                }
                elsif ( 'days' eq $option ) {
                    my $days   = $args->{days};
                    my $origin = MT::Util::epoch2ts( $blog,
                        time - $days * 60 * 60 * 24 );
                    $query = [
                        '-and',
                        { op => '>', value => $origin },
                        { op => '<', value => $now },
                    ];
                }
                elsif ( 'before' eq $option ) {
                    $query = { op => '<', value => $origin . '000000' };
                }
                elsif ( 'after' eq $option ) {
                    $query = { op => '>', value => $origin . '235959' };
                }
                elsif ( 'future' eq $option ) {
                    $query = { op => '>', value => $now };
                }
                elsif ( 'past' eq $option ) {
                    $query = { op => '<', value => $now };
                }
                $db_args->{joins} ||= [];
                push @{ $db_args->{joins} },
                    MT->model( $prop->comment_class )->join_on(
                    undef,
                    { entry_id => \'= entry_id', created_on => $query },
                    { unique   => 1, },
                    );
                return;
            },
            sort => 0,
        },
        author_id => {
            auto            => 1,
            filter_editable => 0,
            display         => 'none',
            label           => 'Author ID',
            label_via_param => sub {
                my $prop = shift;
                my ( $app, $val ) = @_;
                my $author = MT->model('author')->load($val);
                return MT->translate( 'Entries by [_1]', $author->nickname, );
            },
        },
        tag          => { base => '__virtual.tag', },
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
                    my $status
                        = $val eq 'enabled'
                        ? MT::Author::ACTIVE()
                        : MT::Author::INACTIVE();
                    $db_args->{joins} ||= [];
                    push @{ $db_args->{joins} }, MT->model('author')->join_on(
                        undef,
                        {   id     => \'= entry_author_id',
                            status => $status,
                        },
                    );
                }
            },
        },
        current_context => { base => '__common.current_context', },
        content => {
            base    => '__virtual.content',
            fields  => [qw(title text text_more keywords excerpt basename)],
            display => 'none',
        },
    };
}

sub system_filters {
    return {
        current_website => {
            label => 'Entries in This Website',
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
        commented_in_last_7_days => {
            label => 'Entries with Comments Within the Last 7 Days',
            items => [
                {   type => 'commented_on',
                    args => { option => 'days', days => 7 }
                }
            ],
            order => 1100,
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
        $entry->{__orig_value}->{author_id} = $entry->SUPER::author_id
            unless exists( $entry->{__orig_value}->{author_id} );
    }
    return $entry->SUPER::author_id(@_);
}

sub status {
    my $entry = shift;
    if ( scalar @_ ) {
        $entry->{__orig_value}->{status} = $entry->SUPER::status
            unless exists( $entry->{__orig_value}->{status} );
    }
    return $entry->SUPER::status(@_);
}

sub status_text {
    my $s = $_[0];
          $s == HOLD      ? "Draft"
        : $s == RELEASE   ? "Publish"
        : $s == REVIEW    ? "Review"
        : $s == FUTURE    ? "Future"
        : $s == JUNK      ? "Spam"
        : $s == UNPUBLISH ? "Unpublish"
        :                   '';
}

sub status_int {
    my $s = lc $_[0];    ## Lower-case it so that it's case-insensitive
          $s eq 'draft'     ? HOLD
        : $s eq 'publish'   ? RELEASE
        : $s eq 'review'    ? REVIEW
        : $s eq 'future'    ? FUTURE
        : $s eq 'junk'      ? JUNK
        : $s eq 'spam'      ? JUNK
        : $s eq 'unpublish' ? UNPUBLISH
        :                     undef;
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

sub trackback {
    my $entry = shift;
    $entry->cache_property(
        'trackback',
        sub {
            require MT::Trackback;
            if ( $entry->id ) {
                return
                    scalar MT::Trackback->load( { entry_id => $entry->id } );
            }
        },
        @_
    );
}

sub author {
    my $entry = shift;
    $entry->cache_property(
        'author',
        sub {
            return undef unless $entry->author_id;
            my $req          = MT::Request->instance();
            my $author_cache = $req->stash('author_cache');
            my $author       = $author_cache->{ $entry->author_id };
            unless ($author) {
                require MT::Author;
                $author = MT::Author->load( $entry->author_id )
                    or return undef;
                $author_cache->{ $entry->author_id } = $author;
                $req->stash( 'author_cache', $author_cache );
            }
            $author;
        }
    );
}

sub __load_category_data {
    my $entry = shift;
    my $t     = MT->get_timer;
    $t->pause_partial if $t;
    my $cache  = MT::Memcached->instance;
    my $memkey = $entry->cache_key('categories');
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

    require MT::DataAPI::Resource;
    MT::DataAPI::Resource->expire_cache( 'entry', $place->entry_id );
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

MT::Comment->add_callback(
    'post_save',
    0,
    MT->component('core'),
    sub {
        my ( $cb, $comment ) = @_;
        my $entry = MT::Entry->load( $comment->entry_id )
            or return;
        $entry->clear_cache('comment_latest');
        my $count = MT::Comment->count(
            {   entry_id => $comment->entry_id,
                visible  => 1,
            }
        );
        return unless ( $entry->comment_count != $count );
        $entry->comment_count($count);
        $entry->save;
    },
);

MT::Comment->add_callback(
    'post_remove',
    0,
    MT->component('core'),
    sub {
        my ( $cb, $comment ) = @_;
        my $entry = MT::Entry->load( $comment->entry_id )
            or return;
        $entry->clear_cache('comment_latest');
        if ( $comment->visible ) {
            my $count
                = $entry->comment_count > 0 ? $entry->comment_count - 1 : 0;
            $entry->comment_count($count);
            $entry->save;
        }
    },
);

sub pings {
    my $entry = shift;
    my ( $terms, $args ) = @_;
    my $tb = $entry->trackback;
    return undef unless $tb;
    if ( $terms || $args ) {
        $terms ||= {};
        $terms->{tb_id} = $tb->id;
        return [ MT::TBPing->load( $terms, $args ) ];
    }
    else {
        $entry->cache_property(
            'pings',
            sub {
                [ MT::TBPing->load( { tb_id => $tb->id } ) ];
            }
        );
    }
}

MT::TBPing->add_callback(
    'post_save',
    0,
    MT->component('core'),
    sub {
        my ( $cb, $ping ) = @_;
        require MT::Trackback;
        if ( my $tb = MT::Trackback->load( $ping->tb_id ) ) {
            if ( $tb->entry_id ) {
                my $entry = MT::Entry->load( $tb->entry_id )
                    or return;
                my $count = MT::TBPing->count(
                    {   tb_id   => $tb->id,
                        visible => 1,
                    }
                );
                $entry->ping_count($count);
                $entry->save;
            }
        }
    }
);

MT::TBPing->add_callback(
    'post_remove',
    0,
    MT->component('core'),
    sub {
        my ( $cb, $ping ) = @_;
        require MT::Trackback;
        if ( my $tb = MT::Trackback->load( $ping->tb_id ) ) {
            if ( $tb->entry_id && $ping->visible ) {
                my $entry = MT::Entry->load( $tb->entry_id )
                    or return;
                my $count
                    = $entry->ping_count > 0 ? $entry->ping_count - 1 : 0;
                $entry->ping_count($count);
                $entry->save;
            }
        }
    }
);

sub archive_file {
    my $entry = shift;
    my ($at)  = @_;
    my $blog  = $entry->blog() || return;
    unless ($at) {
        $at = $blog->archive_type_preferred || $blog->archive_type;
        return '' if !$at || $at eq 'None';
        return '' if $at eq 'Page';
        my %at = map { $_ => 1 } split /,/, $at;

        # FIXME: should draw from list of registered archive types
        for my $tat (
            qw( Individual Daily Weekly Author-Monthly Category-Monthly Monthly Category )
            )
        {
            $at = $tat if $at{$tat};
            last;
        }
    }
    archive_file_for( $entry, $blog, $at );
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
    first_n_words( $excerpt,
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

sub discover_tb_from_entry {
    my $entry = shift;
    ## If we need to auto-discover TrackBack ping URLs, do that here.
    my $cfg     = MT->config;
    my $blog    = $entry->blog();
    my $send_tb = $cfg->OutboundTrackbackLimit;
    if (   $send_tb ne 'off'
        && $blog
        && (   $blog->autodiscover_links
            || $blog->internal_autodiscovery )
        )
    {
        my @tb_domains;
        if ( $send_tb eq 'selected' ) {
            @tb_domains = $cfg->OutboundTrackbackDomains;
        }
        elsif ( $send_tb eq 'local' ) {
            my $iter = MT::Blog->load_iter( undef,
                { fetchonly => ['site_url'], no_triggers => 1 } );
            while ( my $b = $iter->() ) {
                next if $b->id == $blog->id;
                push @tb_domains, extract_domain( $b->site_url );
            }
        }
        my $tb_domains;
        if (@tb_domains) {
            $tb_domains = '';
            my %seen;
            foreach (@tb_domains) {
                next unless $_;
                $_ = lc($_);
                next if $seen{$_};
                $tb_domains .= '|' if $tb_domains ne '';
                $tb_domains .= quotemeta($_);
                $seen{$_} = 1;
            }
            $tb_domains = '(' . $tb_domains . ')' if $tb_domains;
        }
        my $archive_domain;
        ($archive_domain) = extract_domains( $blog->archive_url );
        my %to_ping = map { $_ => 1 } @{ $entry->to_ping_url_list };
        my %pinged  = map { $_ => 1 }
            @{ $entry->pinged_url_list( IncludeFailures => 1 ) };
        my $body = $entry->text . ( $entry->text_more || "" );
        $body = MT->apply_text_filters( $body, $entry->text_filters );
        while ( $body =~ m!<a\s.*?\bhref\s*=\s*(["']?)([^'">]+)\1!gsi ) {
            my $url = $2;
            my $url_domain;
            ($url_domain) = extract_domains($url);
            if ( $url_domain =~ m/\Q$archive_domain\E$/i ) {
                next if !$blog->internal_autodiscovery;
            }
            else {
                next if !$blog->autodiscover_links;
            }
            next if $tb_domains && lc($url_domain) !~ m/$tb_domains$/;
            if ( my $item = discover_tb($url) ) {
                $to_ping{ $item->{ping_url} } = 1
                    unless $pinged{ $item->{ping_url} };
            }
        }
        $entry->to_ping_urls( join "\n", keys %to_ping );
    }
}

sub sync_assets {
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
    require MT::Trackback;
    if ( $entry->allow_pings ) {
        my $tb;
        unless ( $tb = $entry->trackback ) {
            $tb = MT::Trackback->new;
            $tb->blog_id( $entry->blog_id );
            $tb->entry_id( $entry->id );
            $tb->category_id(0);    ## category_id can't be NULL
        }
        $tb->title( $entry->title );
        $tb->description( $entry->get_excerpt );
        $tb->url( $entry->permalink );
        $tb->is_disabled(0);
        $tb->save
            or return $entry->error( $tb->errstr );
        $entry->trackback($tb);
    }
    else {
        ## If there is a TrackBack item for this entry, but
        ## pings are now disabled, make sure that we mark the
        ## object as disabled.
        my $tb = $entry->trackback;
        if ( $tb && !$tb->is_disabled ) {
            $tb->is_disabled(1);
            $tb->save
                or return $entry->error( $tb->errstr );
        }
    }

    if ($is_new) {

        # Clear some cache
        $entry->clear_cache();

        my $blog = $entry->blog;
        my $at 
            = $blog->archive_type_preferred
            || $blog->archive_type
            || 'Individual';

        my $key;
        my $publisher  = MT->instance->publisher;
        my $cache_file = MT::Request->instance->cache('file');
        $key = $publisher->archive_file_cache_key( $entry, $blog, $at )
            if $publisher->can('archive_file_cache_key');
        delete $cache_file->{$key}
            if $key && $cache_file && exists $cache_file->{$key};
    }

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

    return 1 unless $obj->id;

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
