# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Tag;

use strict;
use warnings;
use base qw( MT::Object );
use MT::Util;

__PACKAGE__->install_properties(
    {   column_defs => {
            'id'         => 'integer not null auto_increment primary key',
            'name'       => 'string(255) not null',
            'n8d_id'     => 'integer',
            'is_private' => 'boolean'
        },
        indexes => {
            name    => 1,
            n8d_id  => 1,
            name_id => { columns => [ 'name', 'id' ], },

            # for MTTags
            private_id_name => { columns => [ 'is_private', 'id', 'name' ], },
        },
        defaults => {
            n8d_id     => 0,
            is_private => 0,
        },
        child_classes => ['MT::ObjectTag'],
        datasource    => 'tag',
        primary_key   => 'id',
    }
);

sub class_label {
    return MT->translate('Tag');
}

sub class_label_plural {
    return MT->translate('Tags');
}

sub list_props {
    return {
        id => {
            base  => '__virtual.id',
            order => 50,
        },
        name => {
            auto    => 1,
            label   => 'Name',
            display => 'force',
            order   => 100,
            html    => sub {
                my $prop = shift;
                my ( $obj, $app ) = @_;
                my $name = MT::Util::encode_html( $obj->name );
                my $id   = $obj->id;
                return
                    qq{<a href="#tagid-$id" class="edit-tag" onclick="editTagName(this);">$name</a>};
            },
        },
        _blog => {
            view  => [],
            terms => sub {
                my ( $prop, $args, $db_terms, $db_args, $opts ) = @_;
                my $blog_id = $opts->{blog_ids};
                $db_args->{joins} ||= [];
                push @{ $db_args->{joins} },
                    MT->model('objecttag')->join_on(
                    undef,
                    {   blog_id => $blog_id,
                        tag_id  => \'= tag_id',
                    },
                    { unique => 1, },
                    );
                return;
            },
        },
        entry_count => {
            label       => 'Entries',
            base        => '__virtual.integer',
            count_class => 'entry',
            display     => 'default',
            order       => 200,
            col         => 'id',
            entry_class => 'entry',
            view        => [ 'website', 'blog' ],
            view_filter => 'none',
            raw         => sub {
                my ( $prop, $obj ) = @_;
                my $blog_id = MT->app->param('blog_id') || 0;
                MT->model('objecttag')->count(
                    {   ( $blog_id ? ( blog_id => $blog_id ) : () ),
                        tag_id            => $obj->id,
                        object_datasource => 'entry',
                    },
                    {   join => MT::Entry->join_on(
                            undef,
                            {   class => $prop->entry_class,
                                id    => \'= objecttag_object_id',
                            }
                        ),
                    }
                );
            },
            html_link => sub {
                my ( $prop, $obj, $app ) = @_;
                $app->can_do( 'access_to_' . $prop->entry_class . '_list' )
                    || return;
                return $app->uri(
                    mode => 'list',
                    args => {
                        _type      => $prop->count_class,
                        blog_id    => $app->param('blog_id') || 0,
                        filter     => 'tag',
                        filter_val => $obj->name,
                    },
                );
            },
            bulk_sort => sub {
                my $prop = shift;
                my ( $objs, $options ) = @_;
                my $iter = MT->model('objecttag')->count_group_by(
                    {   (   scalar @{ $options->{blog_ids} || [] }
                            ? ( blog_id => $options->{blog_id} )
                            : ()
                        ),
                        object_datasource => 'entry',
                    },
                    {   sort      => 'cnt',
                        direction => 'ascend',
                        group     => ['tag_id'],
                        join      => MT::Entry->join_on(
                            undef,
                            {   class => $prop->entry_class,
                                id    => \'= objecttag_object_id',
                            }
                        ),
                    },
                );
                my %counts;
                while ( my ( $cnt, $id ) = $iter->() ) {
                    $counts{$id} = $cnt;
                }
                return sort {
                    ( $counts{ $a->id } || 0 ) <=> ( $counts{ $b->id } || 0 )
                } @$objs;
            },
        },
        for_entry => {
            base        => '__virtual.hidden',
            label       => 'Tags with Entries',
            display     => 'none',
            entry_class => 'entry',
            view        => [ 'website', 'blog' ],
            singleton   => '1',
            terms       => sub {
                my $prop = shift;
                my ( $args, $db_terms, $db_args, $options ) = @_;
                my $blog_id = $options->{blog_ids};
                $db_args->{joins} ||= [];
                push @{ $db_args->{joins} }, MT->model('objecttag')->join_on(
                    'tag_id',
                    {   object_datasource =>
                            'entry',    # set 'entry' even if searching pages.
                    },
                    {   group  => ['tag_id'],
                        unique => 1,
                        join   => MT::Entry->join_on(
                            undef,
                            {   class => $prop->entry_class,
                                id    => \'= objecttag_object_id',
                            }
                        ),
                    }
                );
                return;
            },
        },
        is_private => {
            base                  => '__virtual.single_select',
            label                 => 'Private',
            display               => 'none',
            verb                  => ' ',
            single_select_options => [
                { label => MT->translate('Private'),     value => 1, },
                { label => MT->translate('Not Private'), value => 0, },
            ],
        },
        page_count => {
            base        => 'tag.entry_count',
            label       => 'Pages',
            display     => 'default',
            order       => 300,
            count_class => 'page',
            entry_class => 'page',
            view        => [ 'website', 'blog' ],

        },
        for_page => {
            base        => 'tag.for_entry',
            label       => 'Tags with Pages',
            entry_class => 'page',
            view        => [ 'website', 'blog' ],
        },
        asset_count => {
            label       => 'Assets',
            base        => '__virtual.integer',
            display     => 'default',
            order       => 400,
            view        => [ 'website', 'blog' ],
            view_filter => 'none',
            raw         => sub {
                my ( $prop, $obj ) = @_;
                my $blog_id = MT->app->param('blog_id') || 0;
                MT->model('objecttag')->count(
                    {   ( $blog_id ? ( blog_id => $blog_id ) : () ),
                        tag_id            => $obj->id,
                        object_datasource => 'asset',
                    },
                );
            },
            html_link => sub {
                my ( $prop, $obj, $app ) = @_;
                $app->can_do('access_to_asset_list') or return;
                return $app->uri(
                    mode => 'list',
                    args => {
                        _type      => 'asset',
                        blog_id    => $app->param('blog_id') || 0,
                        filter     => 'tag',
                        filter_val => $obj->name,
                    },
                );
            },
            bulk_sort => sub {
                my $prop = shift;
                my ( $objs, $options ) = @_;
                my $iter = MT->model('objecttag')->count_group_by(
                    {   (   $options->{blog_id}
                            ? ( blog_id => $options->{blog_id} )
                            : ()
                        ),
                        object_datasource => 'asset',
                    },
                    {   sort      => 'cnt',
                        direction => 'ascend',
                        group     => ['tag_id'],
                    },
                );
                my %counts;
                while ( my ( $cnt, $id ) = $iter->() ) {
                    $counts{$id} = $cnt;
                }
                return sort {
                    ( $counts{ $a->id } || 0 ) <=> ( $counts{ $b->id } || 0 )
                } @$objs;
            },
        },
        for_asset => {
            base      => '__virtual.hidden',
            label     => 'Tags with Assets',
            display   => 'none',
            view      => [ 'website', 'blog' ],
            singleton => '1',
            terms     => sub {
                my $prop = shift;
                my ( $args, $db_terms, $db_args, $options ) = @_;
                my $blog_id = $options->{blog_ids};
                $db_args->{joins} ||= [];
                push @{ $db_args->{joins} },
                    MT->model('objecttag')->join_on(
                    'tag_id',
                    { object_datasource => 'asset', },
                    {   group  => ['tag_id'],
                        unique => 1,
                    }
                    );
                return;
            },
        },
        content => {
            base    => '__virtual.content',
            fields  => [qw( name )],
            display => 'none',
        },
    };
}

sub system_filters {
    return {
        entry => {
            label => 'Tags with Entries',
            view  => [ 'website', 'blog' ],
            items => [ { type => 'for_entry', } ],
            order => 100,
        },
        page => {
            label => 'Tags with Pages',
            view  => [ 'website', 'blog' ],
            items => [ { type => 'for_page', } ],
            order => 200,
        },
        asset => {
            label => 'Tags with Assets',
            view  => [ 'website', 'blog' ],
            items => [ { type => 'for_asset', } ],
            order => 300,
        },
        },
        ;
}

sub save {
    my $tag  = shift;
    my $name = $tag->name;
    return $tag->error( MT->translate("Tag must have a valid name") )
        unless defined($name) && length($name);
    my $n8d = $tag->normalize;
    return $tag->error( MT->translate("Tag must have a valid name") )
        unless defined($n8d) && length($n8d);
    if ( $n8d ne $name ) {
        my $n8d_tag = MT::Tag->load( { name => $n8d } );
        if ( !$n8d_tag ) {
            $n8d_tag = new MT::Tag;
            $n8d_tag->name($n8d);
            $n8d_tag->save;
        }
        if ( !$tag->n8d_id || ( $tag->n8d_id != $n8d_tag->id ) ) {
            $tag->n8d_id( $n8d_tag->id );
        }
    }
    else {
        $tag->n8d_id(0) if $tag->n8d_id;
    }

    # maintain the private flag...
    $tag->is_private( $name =~ m/^@/ ? 1 : 0 );
    $tag->SUPER::save();
}

sub normalize {
    my $tag = shift;
    my ($str) = @_;
    if ( !@_ && !( ref $tag ) ) {
        $str = $tag;
    }
    elsif ( !$str && ( ref $tag ) ) {
        $str = $tag->name;
    }

    my $private = $str =~ m/^@/;
    $str =~ s/[@!`\\<>\*&#\/~\?'"\.\,=\(\)\${}\[\];:\ \+\-\r\n]+//gs;
    $str = lc $str;
    $str = '@' . $str if $private;
    $str;
}

sub remove {
    my $tag = shift;
    my $n8d_tag;
    if ( ref $tag ) {
        if ( !$tag->n8d_id ) {

            # normalized tag! we can't delete if others reference us
            my $child_tags = MT::Tag->exist( { n8d_id => $tag->id } );
            return $tag->error(
                MT->translate("This tag is referenced by others.") )
                if $child_tags;
        }
        else {
            $n8d_tag = MT::Tag->load( $tag->n8d_id );
        }
    }
    $tag->remove_children( { key => 'tag_id' } );
    $tag->SUPER::remove(@_)
        or return $tag->error( $tag->errstr );

    # check for an orphaned normalized tag and delete if necessary
    if ($n8d_tag) {

        # Normalized tag, no longer referenced by other tags...
        if ( !MT::Tag->exist( { n8d_id => $n8d_tag->id } ) ) {

            # Noramlized tag that no longer has any object tag associations
            require MT::ObjectTag;
            if ( !MT::ObjectTag->exist( { tag_id => $n8d_tag->id } ) ) {
                $n8d_tag->remove
                    or return $tag->error( $n8d_tag->errstr );
            }
        }
    }
    1;
}

sub split {
    my $pkg = shift;
    my ( $delim, $str ) = @_;
    $delim = quotemeta($delim);
    my @tags;
    $str =~ s/(^\s+|\s+$)//gs;
    while ( length($str)
        && ( $str =~ m/^(((['"])(.*?)\3[^$delim]*?|.*?)($delim\s*|$))/s ) )
    {
        $str = substr( $str, length($1) );
        my $tag = defined $4 ? $4 : $2;

        #$tag =~ s/(^[\s,]+|[\s,]+$)//gs;
        $tag =~ s/(^\s+|\s+$)//gs;

        #$tag =~ s/\s+/ /gs;
        my $n8d_tag = MT::Tag->normalize($tag);
        next if $n8d_tag eq '';
        push @tags, $tag if $tag ne '';
    }
    @tags;
}

sub join {
    my $obj = shift;
    my ( $delim, @tags ) = @_;
    my $tags = '';
    foreach (@tags) {
        $tags .= $delim . ( $delim eq ' ' ? '' : ' ' ) if $tags ne '';
        if (m/\Q$delim\E/) {
            if (m/"/) {
                $tags .= "'" . $_ . "'";
            }
            else {
                $tags .= '"' . $_ . '"';
            }
        }
        else {
            $tags .= $_;
        }
    }
    $tags;
}

sub load_by_datasource {
    my $pkg = shift;
    my ( $datasource, $terms, $args ) = @_;
    $args ||= {};
    $args->{'sort'} ||= 'name';
    my $blog_id;
    my %jargs;
    if ( $terms->{blog_id} ) {
        $blog_id = $terms->{blog_id};
        delete $terms->{blog_id};
        if ( $args->{not} && $args->{not}{blog_id} ) {
            $jargs{not}{blog_id} = 1;
        }
    }
    require MT::ObjectTag;
    $args->{'join'} ||= MT::ObjectTag->join_on(
        'tag_id',
        {   $blog_id ? ( blog_id => $blog_id ) : (),
            object_datasource => $datasource
        },
        { unique => 1, %jargs }
    );
    my @tags;
    my $iter = MT::Tag->load_iter( $terms, $args );
    while ( my $tag = $iter->() ) {
        push @tags, $tag;
    }
    @tags;
}

# static method for tag cache control
sub cache_obj {
    my $pkg     = shift;
    my (%param) = @_;
    my $user_id = $param{user_id};
    my $blog_id = $param{blog_id};
    my $ds      = $param{datasource};

    require MT::Session;

    # Clear any tag cache if tags were modified upon saving
    my $sess_id
        = ( $user_id ? 'user:' . $user_id . ';' : '' )
        . ( $blog_id ? 'blog:' . $blog_id . ';' : '' )
        . 'datasource:'
        . $ds
        . ( $param{private} ? ';private' : '' );
    my $tag_cache = MT::Session::get_unexpired_value(
        60 * 60,
        {   kind => 'TC',      # tag cache
            id   => $sess_id
        }
    );
    if ( !$tag_cache ) {
        $tag_cache = new MT::Session;
        $tag_cache->kind('TC');
        $tag_cache->id($sess_id);
        $tag_cache->start(time);
    }
    $tag_cache;
}

sub clear_cache {
    my $pkg     = shift;
    my (%param) = @_;
    my $blog_id = $param{blog_id};
    my $user_id = $param{user_id};
    my $ds      = $param{datasource};

    my $tag_cache;
    my $sess_id
        = ( $user_id ? 'user:' . $user_id . ';' : '' )
        . ( $blog_id ? 'blog:' . $blog_id . ';' : '' )
        . 'datasource:'
        . $ds
        . ( $param{private} ? ';private' : '' );
    require MT::Session;
    $tag_cache = MT::Session->load(
        {   kind => 'TC',
            id   => $sess_id
        }
    );
    $tag_cache->remove if $tag_cache;

    $sess_id
        = ( $blog_id ? 'blog:' . $blog_id . ';' : '' )
        . 'datasource:'
        . $ds
        . ';private';
    $tag_cache = MT::Session->load(
        {   kind => 'TC',
            id   => $sess_id
        }
    );
    $tag_cache->remove if $tag_cache;
}

### DEPRECATED
sub cache {
    require MT::Util::Deprecated;
    MT::Util::Deprecated::warning(since => '7.8');
    my $pkg     = shift;
    my (%param) = @_;
    my $user_id = $param{user_id};
    my $blog_id = $param{blog_id};
    my $class   = $param{class};
    if ( ref($class) eq 'SCALAR' ) {
        $class = eval "use $class;";
        if ( my $err = $@ ) {
            $class = eval 'use MT::Entry;';
        }
    }
    my $ds = $class->datasource;
    $param{datasource} = $ds;

    my $tag_cache = $pkg->cache_obj(%param);
    my $data      = $tag_cache->get('tag_cache');

    if ( ref($data) ne 'ARRAY' ) {
        my $private      = $param{private};
        my $class_column = $class->properties->{class_column};

        # FIXME: this should be a parameter; breaks MVC model
        my $limit = MT->config->MaxTagAutoCompletionItems;
        require MT::ObjectTag;
        my @tags = map { $_->name } MT::Tag->load(
            undef,
            {   ( $private ? () : ( 'name' => { not_like => '@%' } ) ),
                join => MT::ObjectTag->join_on(
                    undef,
                    {   tag_id => \'= tag_id',
                        ( $blog_id ? ( blog_id => $blog_id ) : () ),
                        object_datasource => $ds,
                    },
                    {   unique => 1,
                        join   => $class->join_on(
                            undef,
                            {   'id' => \'= objecttag_object_id',
                                ( $blog_id ? ( blog_id => $blog_id ) : () ),
                                (   $class_column
                                    ? ( $class_column => $class->class_type )
                                    : ()
                                ),
                            },
                            {   sort => (
                                    $class eq 'MT::Entry' ? 'authored_on'
                                    : 'modified_on'
                                ),
                                direction => 'descend'
                            }
                        )
                    }
                ),
                limit     => $limit,
                fetchonly => [ 'id', 'name' ]
            }
        );
        if (@tags) {
            $data = \@tags;
            $tag_cache->set( 'tag_cache', \@tags );
            $tag_cache->save;
        }
    }
    $data || [];
}

sub get_tags_js {
    my $class = shift;
    my ($blog_id) = @_;
    return undef unless $blog_id;

    require MT::ObjectTag;
    require MT::Util;
    my $tags_js = MT::Util::to_json(
        [   map { $_->name } MT::Tag->load(
                undef,
                {   join => [
                        'MT::ObjectTag', 'tag_id',
                        { blog_id => $blog_id }, { unique => 1 }
                    ]
                }
            )
        ]
    );
    $tags_js =~ s!/!\\/!g;

    return $tags_js;
}

# An interface for any MT::Object that wishes to utilize tags themselves

package MT::Taggable;

use constant TAG_CACHE_TIME => 7 * 24 * 60 * 60;    ## 1 week

sub install_properties {
    my $pkg = shift;
    my ($class) = @_;

    # synchronize tags if necessary
    $class->add_trigger( post_save  => \&post_save_tags );
    $class->add_trigger( pre_remove => \&pre_remove_tags );
}

# post_save trigger for MT::Taggable objects to synchronize tags upon save.
sub post_save_tags {
    my $class = shift;
    my ($obj) = @_;
    $obj->save_tags;
}

sub pre_remove_tags {
    my $class = shift;
    my ($obj) = @_;
    $obj->remove_tags if ref $obj;
}

sub tag_cache_key {
    my $obj = shift;
    return undef unless $obj->id;
    return sprintf "%stags-%d", $obj->datasource, $obj->id;
}

sub __load_tags {
    my $obj = shift;
    my $t   = MT->get_timer;
    $t->pause_partial if $t;

    if ( !$obj->id ) {
        $obj->{__tags} = [];
        return $obj->{__tag_objects} = [];
    }
    return if exists $obj->{__tag_objects};

    require MT::Memcached;
    my $cache  = MT::Memcached->instance;
    my $memkey = $obj->tag_cache_key;
    my @tags;
    if ( my $tag_ids = $cache->get($memkey) ) {
        @tags = grep {defined} @{ MT::Tag->lookup_multi($tag_ids) };
    }
    else {
        require MT::ObjectTag;
        my $iter = MT::Tag->load_iter(
            undef,
            {   sort => 'name',
                join => [
                    'MT::ObjectTag',
                    'tag_id',
                    {   object_id         => $obj->id,
                        object_datasource => $obj->datasource
                    },
                    { unique => 1 }
                ],
            }
        );
        while ( my $tag = $iter->() ) {
            push @tags, $tag;
        }
        $cache->set( $memkey, [ map { $_->id } @tags ], TAG_CACHE_TIME );
    }
    $obj->{__tags} = [ map { $_->name } @tags ];
    $t->mark('MT::Tag::__load_tags') if $t;
    $obj->{__tag_objects} = \@tags;
}

sub get_tags {
    my $obj = shift;
    $obj->__load_tags
        unless $obj->{__tags} && @{ $obj->{__tags} } || $obj->{__save_tags};
    return @{ $obj->{__tags} };
}

sub get_tag_objects {
    my $obj = shift;
    $obj->__load_tags;
    return $obj->{__tag_objects};
}

sub set_tags {
    my $obj  = shift;
    my @tags = @_;
    my $opt  = ref $tags[-1] ? pop @tags : {};

    $obj->{__tags}            = [ sort @tags ];
    $obj->{__save_tags}       = 1;
    $obj->{__force_save_tags} = 1 if $opt->{force};
}

sub save_tags {
    my $obj = shift;
    return 1 unless $obj->{__save_tags};
    require MT::ObjectTag;
    my $clear_cache = 0;
    my @tags        = @{ $obj->{__tags} };
    if ( scalar(@tags) < 1 ) {
        $obj->remove_tags();
        return 1;
    }
    return 1 unless delete $obj->{__force_save_tags} || @tags;

    my $t = MT->get_timer;
    $t->pause_partial if $t;

    $obj->{__tag_objects} = [];
    my $blog_id = $obj->has_column('blog_id') ? $obj->blog_id : 0;
    my @existing_tags = MT::ObjectTag->load(
        {   object_id         => $obj->id,
            object_datasource => $obj->datasource
        }
    );
    my %existing_tags = map { $_->tag_id => $_ } @existing_tags;
    foreach my $tag_name (@tags) {
        my $tag = MT::Tag->load( { name => $tag_name },
            { binary => { name => 1 } } );
        if ($tag) {
            if ( exists $existing_tags{ $tag->id } ) {
                $existing_tags{ $tag->id } = 0;
                push @{ $obj->{__tag_objects} }, $tag;
                next;
            }
        }
        else {

            # new tag
            $tag = new MT::Tag;
            $tag->name($tag_name);
            $tag->save or next;
            $clear_cache = 1;
        }
        my $otag = new MT::ObjectTag;
        $otag->blog_id($blog_id);
        $otag->tag_id( $tag->id );
        $otag->object_id( $obj->id );
        $otag->object_datasource( $obj->datasource );
        $otag->save or return $obj->error( $otag->errstr );
        $existing_tags{ $tag->id } = 0;
        $clear_cache = 1;

        push @{ $obj->{__tag_objects} }, $tag;
    }

    foreach my $otag ( values %existing_tags ) {
        next unless ref $otag;
        my $this_tag_id = $otag->tag_id;
        $otag->remove;
        if ( !MT::ObjectTag->exist( { tag_id => $this_tag_id } ) ) {

            # no more references to this tag... just delete it now
            if ( my $tag = MT::Tag->load($this_tag_id) ) {
                $tag->remove;
            }
        }
        $clear_cache = 1;
    }
    delete $obj->{__save_tags};
    if ($clear_cache) {
        MT::Tag->clear_cache(
            datasource => $obj->datasource,
            ( $blog_id ? ( blog_id => $blog_id ) : () )
        );

        require MT::Memcached;
        MT::Memcached->instance->delete( $obj->tag_cache_key );
    }
    $t->mark('MT::Tag::save_tags') if $t;
    1;
}

sub tags {
    my $obj = shift;
    $obj->set_tags(@_) if @_;
    $obj->get_tags;
}

sub add_tags {
    my $obj    = shift;
    my (@tags) = @_;
    my @etags  = $obj->tags;
    push @tags, @etags;
    my %uniq;
    @uniq{@tags} = ();
    $obj->set_tags( keys %uniq );
}

sub remove_tags {
    my $obj = shift;
    my (@tags) = @_;
    if (@tags) {
        my @etags = $obj->tags;
        my %uniq;
        @uniq{@etags} = ();
        delete $uniq{$_} for @tags;
        if ( keys %uniq ) {
            $obj->set_tags( keys %uniq );
            return;
        }
    }
    require MT::ObjectTag;
    my @et = MT::ObjectTag->load(
        {   object_id         => $obj->id,
            object_datasource => $obj->datasource
        }
    );
    $_->remove for @et;
    $obj->{__tags} = [];
    delete $obj->{__save_tags};
    MT::Tag->clear_cache(
        datasource => $obj->datasource,
        ( $obj->blog_id ? ( blog_id => $obj->blog_id ) : () )
    ) if @et;

    require MT::Memcached;
    MT::Memcached->instance->delete( $obj->tag_cache_key );
}

sub has_tag {
    my $obj = shift;
    my ($tag) = @_;
    $tag = $tag->name if ref $tag;
    foreach ( $obj->tags ) {
        return 1 if $tag eq $_;
    }
    0;
}

# counts number of tags
sub tag_count {
    my $obj     = shift;
    my ($terms) = @_;
    my $pkg     = ref $obj ? ref $obj : $obj;
    $terms ||= {};
    my $jterms = {};
    if ( ref $obj ) {
        $terms->{object_id} = $obj->id      if $obj->id;
        $jterms->{blog_id}  = $obj->blog_id if $obj->column('blog_id');
    }
    if ( $terms->{blog_id} ) {
        $jterms->{blog_id} = $terms->{blog_id};
        delete $terms->{blog_id};
    }
    $jterms->{object_datasource} = $obj->datasource;
    my $pkg_terms = {};
    $pkg_terms->{id} = \'=objecttag_object_id';
    if ( $pkg->class_type eq 'entry' or $pkg->class_type eq 'page' ) {
        $pkg_terms->{class} = $pkg->class_type;
    }
    require MT::ObjectTag;
    MT::Tag->count(
        undef,
        {   join => MT::ObjectTag->join_on(
                'tag_id', $jterms,
                { unique => 1, join => $pkg->join_on( undef, $pkg_terms ) }
            )
        }
    );
}

# counts number of objects tagged with a given tag
sub tagged_count {
    my $obj = shift;
    my ( $tag_id, $terms ) = @_;
    $terms ||= {};
    my $jterms = {};
    my $pkg = ref $obj ? ref $obj : $obj;
    if ( defined $tag_id && ( $tag_id =~ m/\D/ ) ) {
        my $n8d_tag = MT::Tag->normalize($tag_id);
        my $tag     = MT::Tag->load(
            { name => [ $tag_id, $n8d_tag ] },
            { binary => { name => 1 } }
        );
        return 0 unless $tag;
        $tag_id = $tag->id;
    }
    if ( ref $obj ) {
        $terms->{object_id} = $obj->id      if $obj->id;
        $jterms->{blog_id}  = $obj->blog_id if $obj->column('blog_id');
    }
    else {
        $jterms->{blog_id} = $terms->{blog_id} if $terms->{blog_id};
    }
    $jterms->{object_datasource} = $pkg->datasource;
    $jterms->{tag_id} = $tag_id if $tag_id;
    my $args
        = {
        join => [ 'MT::ObjectTag', 'object_id', $jterms, { unique => 1 } ]
        };
    require MT::ObjectTag;
    $pkg->count( $terms, $args );
}

sub terms_for_tags {
    return undef;
}

1;
__END__

=head1 NAME

MT::Tag - Movable Type tag record and methods

=head1 SYNOPSIS

    use MT::Tag;
    my $tag = MT::Tag->new;
    $tag->name('favorite');
    $tag->save
        or die $tag->errstr;

=head1 DATA ACCESS METHODS

The I<MT::Tag> object holds the following pieces of data. These fields
can be accessed and set using the standard data access methods described in
the L<MT::Object> documentation.

=over 4

=item * id

The numeric ID of the tag.

=item * name

The name of the tag.

=item * n8d_id

The ID of a "normalized" version of this tag. If undef or 0, it would
signifiy this tag is a normalized tag name.

=back

=head1 DATA LOOKUP

In addition to numeric ID lookup, you can look up or sort records by any
combination of the following fields. See the I<load> documentation in
I<MT::Object> for more information.

=over 4

=item * name

=back

=head1 OTHER METHODS

=head2 cache

Return the entry tags. If there are no cached tags, they are loaded
first. If the tags have already been loaded with this method, that
data is returned instead.

=head2 cache_obj

Cache the session tags.

=head2 clear_cache

Remove the tag cache.

=head2 join($seperator, @tags)

Return the given I<tags> as a string with the defined I<seperator>.

=head2 split($seperator, $tags)

Split-up the given I<tags> string by the given I<seperator>.

=head2 normalize($tag)

Sanitize the text (remove potentially characters) and lower-case the
I<tag>. The I<tag> may be given as a string or as a tag object. In the
case of the latter, C<$tag-E<gt>name> attribute is used.

=head2 load_by_datasource($datasource, $terms, $args)

Return a list of tags given by an object I<datasource> type, selection
I<terms> and I<arguments>.

=head2 $tag->save()

Save the literal as well as a normalized copy if one does not exist.

=head2 $tag->remove()

Remove the tag and all its children unless it is referenced by another
entry.

=head2 MT::Tag->class_label

Returns the localized descriptive name for this class.

=head2 MT::Tag->class_label_plural

Returns the localized, plural descriptive name for this class.

=head2 MT::Tag->list_props

Returns the list_properties registry of this class.

=head2 MT::Tag->system_filters

Returns the system_filters registry of this class.

=head2 MT::Tag->get_tags_js($blog_id)

Returns JSON array of tag names in the site specified by I<$blog_id>.

=head1 NOTES

=over 4

=item *

When you remove a tag using I<MT::Tag::remove>, in addition to
removing the tag record, all of the related I<MT::ObjectTag> records are
removed as well.

=back

=head1 AUTHOR & COPYRIGHT

Please see L<MT/AUTHOR & COPYRIGHT>.

=cut
