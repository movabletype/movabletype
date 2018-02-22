# Movable Type (r) (C) 2001-2017 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::ContentFieldType::Tags;
use strict;
use warnings;

use MT::ContentFieldType::Common
    qw( get_cd_ids_by_inner_join get_cd_ids_by_left_join );
use MT::Tag;
use MT::Util;

sub field_html_params {
    my ( $app, $field_data ) = @_;
    my $value = $field_data->{value};
    $value = []       unless $value;
    $value = [$value] unless ref $value eq 'ARRAY';

    my $tag_delim = chr( $app->user->entry_prefs->{tag_delim} );
    $tag_delim .= ' ' if $tag_delim eq ',';

    my $tag_names;
    if ( $app->param('reedit') ) {
        $tag_names = join $tag_delim, @$value;
    }
    else {
        my %tag_hash;    # id => name
        my $iter = MT::Tag->load_iter( { id => $value },
            { fetchonly => [ 'id', 'name' ] } );
        while ( my $tag = $iter->() ) {
            $tag_hash{ $tag->id } = $tag->name;
        }
        my @tag_names = grep { defined $_ } map { $tag_hash{$_} } @$value;
        $tag_names = join $tag_delim, @tag_names;
    }

    my $options = $field_data->{options};

    my $multiple = '';
    if ( $options->{multiple} ) {
        my $max = $options->{max};
        my $min = $options->{min};
        $multiple = 'data-mt-multiple="1"';
        $multiple .= qq{ data-mt-max-select="${max}"} if $max;
        $multiple .= qq{ data-mt-min-select="${min}"} if $min;
    }

    my $required = $options->{required} ? 'required' : '';

    {   multiple  => $multiple,
        required  => $required,
        tag_delim => chr( $app->user->entry_prefs->{tag_delim} ),
        tags      => $tag_names,
        tags_js   => MT::Tag->get_tags_js( $app->blog->id ),
    };
}

sub terms {
    my $prop = shift;
    my ( $args, $db_terms, $db_args ) = @_;

    my $name_terms = $prop->super(@_);

    my $option = $args->{option} || '';
    if ( $option eq 'not_contains' ) {
        my $string = $args->{string};

        my @tag_ids;
        my $iter = MT::Tag->load_iter( { name => { like => "%${string}%" } },
            { fetchonly => { id => 1 } } );
        while ( my $tag = $iter->() ) {
            push @tag_ids, $tag->id;
        }

        my $join_terms = { value_integer => [ \'IS NULL', @tag_ids ] };
        my $cd_ids = get_cd_ids_by_left_join( $prop, $join_terms, undef, @_ );
        $cd_ids ? { id => { not => $cd_ids } } : ();
    }
    elsif ( $option eq 'blank' ) {
        my $join_terms = { value_integer => \'IS NULL' };
        my $cd_ids = get_cd_ids_by_left_join( $prop, $join_terms, undef, @_ );
        { id => $cd_ids };
    }
    elsif ( $option eq 'not_blank' ) {
        my $cd_ids = get_cd_ids_by_inner_join( $prop, undef, undef, @_ );
        { id => $cd_ids };
    }
    else {
        my $join_args = {
            join => MT::Tag->join_on(
                undef, [ { id => \'= cf_idx_value_integer' }, $name_terms ],
            ),
        };
        my $cd_ids = get_cd_ids_by_inner_join( $prop, undef, $join_args, @_ );
        { id => $cd_ids };
    }
}

sub html {
    my $prop = shift;
    my ( $content_data, $app, $opts ) = @_;

    my $tag_ids = $content_data->data->{ $prop->content_field_id } || [];

    my %tag_names;
    my $iter = MT::Tag->load_iter( { id => $tag_ids },
        { fetchonly => { id => 1, name => 1 } } );
    while ( my $tag = $iter->() ) {
        $tag_names{ $tag->id } = $tag->name;
    }

    my $can_double_encode = 1;

    my @links;
    for my $id (@$tag_ids) {
        my $tag_name
            = MT::Util::encode_html( $tag_names{$id}, $can_double_encode );
        my $link = _link( $app, $tag_name );
        push @links, qq{<a href="$link">${tag_name}</a>};
    }

    my $tag_delim = chr( $app->user->entry_prefs->{tag_delim} );
    $tag_delim .= ' ' if $tag_delim eq ',';

    join $tag_delim, @links;
}

sub ss_validator {
    my ( $app, $field_data, $data ) = @_;

    my $options = $field_data->{options} || {};
    my $field_label = $options->{label};

    my $iter = MT::Tag->load_iter( { name => $data },
        { binary => { name => 1 }, fetchonly => [ 'id', 'name' ] } );
    my %valid_tag_hash;    # name => id
    while ( my $tag = $iter->() ) {
        $valid_tag_hash{ $tag->name } = $tag->id;
    }

    my @invalid_tag_names = grep { !$valid_tag_hash{$_} } @$data;
    if ( !$options->{can_add} && @invalid_tag_names ) {
        my $tag_names = join ', ', sort(@invalid_tag_names);
        return $app->translate( 'Cannot create tags [_1] in "[_2]" field.',
            $tag_names, $field_label );
    }
    else {
        for my $tag_name (@invalid_tag_names) {
            my $tag = MT::Tag->new( name => $tag_name );
            $tag->save
                or return $app->translate( 'Cannot create tag "[_1]": [_2]',
                $tag_name, $tag->errstr );
            $valid_tag_hash{$tag_name} = $tag->id;
        }
    }

    my $type_label        = 'tag';
    my $type_label_plural = 'tags';
    my $error = MT::ContentFieldType::Common::ss_validator_multiple( @_,
        $type_label, $type_label_plural );
    return $error if $error;

    @$data = map { $valid_tag_hash{$_} } @$data;
    return;
}

sub _link {
    my ( $app, $tag_name ) = @_;
    $app->uri(
        mode => 'list',
        args => {
            _type      => 'tag',
            blog_id    => $app->blog->id,
            filter     => 'name',
            filter_val => $tag_name,
        },
    );
}

sub tag_handler {
    my ( $ctx, $args, $cond, $field_data, $value ) = @_;

    my $is_preview = eval {
               MT->app->can('mode')
            && MT->app->mode
            && MT->app->mode eq 'preview_content_data';
    };

    my $iter;
    if ($is_preview) {
        $iter = MT::Tag->load_iter( { name => $value },
            { binary => { name => 1 } } );
    }
    else {
        $iter = MT::Tag->load_iter( { id => $value } );
    }

    my %tags;
    while ( my $tag = $iter->() ) {
        my $key = $is_preview ? $tag->name : $tag->id;
        $tags{$key} = $tag;
    }

    my @ordered_tags;
    for my $v (@$value) {
        my $tag = $tags{$v};
        if ( !$tag && $is_preview ) {
            my $is_private = $v =~ /^@/ ? 1 : 0;
            $tag = MT::Tag->new(
                name       => $v,
                is_private => $is_private,
            );
        }
        if ($tag) {
            push @ordered_tags, $tag;
        }
    }

    my $glue = $args->{glue};

    local $ctx->{__stash}{tag_max_count} = undef;
    local $ctx->{__stash}{tag_min_count} = undef;
    local $ctx->{__stash}{all_tag_count} = undef;

    my $builder = $ctx->stash('builder');
    my $tokens  = $ctx->stash('tokens');
    my $res     = '';
    my $i       = 1;
    my $vars    = $ctx->{__stash}{vars} ||= {};
    if ( !$args->{include_private} ) {
        @ordered_tags = grep { !$_->is_private } @ordered_tags;
    }
    for my $tag (@ordered_tags) {
        local $vars->{__first__}                 = $i == 1;
        local $vars->{__last__}                  = $i == scalar @ordered_tags;
        local $vars->{__odd__}                   = ( $i % 2 ) == 1;
        local $vars->{__even__}                  = ( $i % 2 ) == 0;
        local $vars->{__counter__}               = $i;
        local $ctx->{__stash}{Tag}               = $tag;
        local $ctx->{__stash}{tag_count}         = undef;
        local $ctx->{__stash}{tag_content_count} = undef;
        defined(
            my $out = $builder->build(
                $ctx, $tokens,
                {   %$cond,
                    ContentFieldHeader => $i == 1,
                    ContentFieldFooter => $i == scalar @ordered_tags
                }
            )
        ) or return $ctx->error( $builder->errstr );
        $res .= $glue if defined $glue && length($res) && length($out);
        $res .= $out;
        $i++;
    }
    $res;
}

sub data_load_handler {
    my ( $app, $field_data ) = @_;
    my $tag_delim = chr( $app->user->entry_prefs->{tag_delim} );
    my @tag_names = split $tag_delim,
        $app->param( 'content-field-' . $field_data->{id} );
    for (@tag_names) {
        $_ =~ s/^\s+//;
        $_ =~ s/\s+$//;
    }
    return [ grep { defined $_ && $_ ne '' } @tag_names ];
}

sub options_validation_handler {
    my ( $app, $type, $label, $field_label, $options ) = @_;

    my $initial_value = $options->{initial_value};
    if ( defined $initial_value and $initial_value ne '' ) {
        return $app->translate(
            "An initial value of '[_1]' ([_2]) must be an shorter than 255 characters",
            $label, $field_label
        ) if length($initial_value) > 255;
    }

    return;
}

sub field_value_handler {
    my ( $ctx, $args, $cond, $field_data, $value ) = @_;
    my $content = $ctx->stash('Tag');
    return $content ? $content->id : '';
}

sub feed_value_handler {
    my ( $app, $field_data, $values ) = @_;

    my @tags = MT->model('tag')
        ->load( { id => $values }, { fetchonly => { id => 1, name => 1 } }, );
    my %name_hash = map { $_->id => $_->name } @tags;

    my $contents = '';
    for my $id (@$values) {
        my $name = $name_hash{$id};
        $name = '' unless defined $name && $name ne '';
        my $encoded_name = MT::Util::encode_html($name);
        $contents .= "<li>$encoded_name (ID:$id)</li>";
    }

    return "<ul>$contents</ul>";
}

sub preview_handler {
    my ( $values, $field_id, $content_data ) = @_;
    return '' unless $values;
    unless ( ref $values eq 'ARRAY' ) {
        $values = [$values];
    }
    return '' unless @$values;

    my @tags = MT->model('tag')
        ->load( { id => $values }, { fetchonly => { id => 1, name => 1 } }, );
    my %name_hash = map { $_->id => $_->name } @tags;

    my $contents = '';
    for my $id (@$values) {
        my $name = $name_hash{$id};
        $name = '' unless defined $name && $name ne '';
        my $encoded_name = MT::Util::encode_html($name);
        $contents .= "<li>$encoded_name (ID:$id)</li>";
    }

    return qq{<ul class="list-unstyled">$contents</ul>};
}

sub search_handler {
    my ( $search_regex, $tag_ids, $field_data, $content_data ) = @_;
    return 0 unless defined $tag_ids;
    $tag_ids = [$tag_ids] unless ref $tag_ids eq 'ARRAY';
    my $iter = MT->model('tag')->load_iter( { id => $tag_ids } );
    while ( my $tag = $iter->() ) {
        return 1 if $tag->name =~ /$search_regex/;
    }
    0;
}

1;

