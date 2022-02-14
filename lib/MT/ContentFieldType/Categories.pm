# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::ContentFieldType::Categories;
use strict;
use warnings;

use MT::Category;
use MT::CategorySet;
use MT::ContentField;
use MT::ContentFieldType::Common
    qw( get_cd_ids_by_inner_join get_cd_ids_by_left_join );
use MT::Meta::Proxy;
use MT::Util;

sub field_html_params {
    my ( $app, $field_data ) = @_;
    my $value = $field_data->{value};
    $value = ''       unless defined $value;
    $value = [$value] unless ref $value eq 'ARRAY';

    my $options = $field_data->{options};

    my $multiple = '';
    if ( $options->{multiple} ) {
        my $max = $options->{max};
        my $min = $options->{min};
        $multiple = 'data-mt-multiple="1"';
        $multiple .= qq{ data-mt-max-select="${max}"} if $max;
        $multiple .= qq{ data-mt-min-select="${min}"} if $min;
    }

    my $required = $options->{required} ? 'data-mt-required="1"' : '';

    my ( $category_tree, $selected_category_loop )
        = _build_category_list( $app, $field_data );

    my $invalid_category_set;
    if ( $options->{category_set} ) {
        $invalid_category_set
            = MT::CategorySet->exist( $options->{category_set} ) ? 0 : 1;
    }
    else {
        $invalid_category_set = 1;
    }

    {   category_tree          => $category_tree,
        invalid_category_set   => $invalid_category_set,
        multiple               => $multiple,
        required               => $required,
        selected_category_loop => $selected_category_loop,
    };
}

sub _build_category_list {
    my ( $app, $field_data ) = @_;
    my $blog_id = $app->blog->id;

    my $categories = [];
    if ( my $category_set
        = MT::CategorySet->load( $field_data->{options}{category_set} || 0 ) )
    {
        $categories = $category_set->categories;
    }

    my %value = map { $_ => 1 } @{ $field_data->{value} ||= [] };
    my %places = map { $_->id => 1 } grep { $value{ $_->id } } @{$categories};

    my $data = $app->_build_category_list(
        blog_id    => $blog_id,
        cat_set_id => $field_data->{options}{category_set},
        markers    => 1,
        type       => 'category',
    );

    my $cat_tree = [];
    foreach (@$data) {
        next unless exists $_->{category_id};
        push @$cat_tree,
            {
            id       => $_->{category_id},
            label    => $_->{category_label},
            basename => $_->{category_basename},
            path     => $_->{category_path_ids} || [],
            fields   => $_->{category_fields} || [],
            };
    }

    my @sel_cats = grep { $places{$_} } @{ $field_data->{value} };

    ( $cat_tree, \@sel_cats );
}

sub data_load_handler {
    my ( $app, $field_data ) = @_;
    my $field_id          = $field_data->{id};
    my $category_field_id = $app->param("category-${field_id}");
    $category_field_id = '' unless defined $category_field_id;
    [ split ',', $category_field_id ];
}

sub ss_validator {
    my ( $app, $field_data, $data ) = @_;

    my $options = $field_data->{options} || {};

    my $iter = MT::Category->load_iter(
        {   id => @{ $data || [] } ? $data : 0,
            category_set_id => $options->{category_set}
        },
        { fetchonly => { id => 1 } }
    );
    my %valid_cats;
    while ( my $cat = $iter->() ) {
        $valid_cats{ $cat->id } = 1;
    }
    if ( my @invalid_cat_ids = grep { !$valid_cats{$_} } @{$data} ) {
        my $invalid_cat_ids = join ', ', sort(@invalid_cat_ids);
        my $field_label = $options->{label};
        return $app->translate( 'Invalid Category IDs: [_1] in "[_2]" field.',
            $invalid_cat_ids, $field_label );
    }

    my $type_label        = 'category';
    my $type_label_plural = 'categories';
    MT::ContentFieldType::Common::ss_validator_multiple( @_, $type_label,
        $type_label_plural );
}

sub html {
    my $prop = shift;
    my ( $content_data, $app, $opts ) = @_;

    my $raw_cat_ids = $content_data->data->{ $prop->content_field_id };
    return '' unless $raw_cat_ids;
    my @cat_ids
        = ref $raw_cat_ids eq 'ARRAY' ? @$raw_cat_ids : ($raw_cat_ids);
    return '' unless @cat_ids;

    my %cats;
    my $iter = MT::Category->load_iter( { id => \@cat_ids },
        { fetchonly => { id => 1, blog_id => 1, label => 1 } } );
    while ( my $cat = $iter->() ) {
        $cats{ $cat->id } = $cat;
    }
    my @cats = grep {$_} map { $cats{$_} } @cat_ids;

    my $can_double_encode = 1;

    my @links;
    for my $cat (@cats) {
        my $label = MT::Util::encode_html( $cat->label, $can_double_encode );
        my $edit_link = _edit_link( $app, $cat );
        push @links, qq{<a href="${edit_link}">${label}</a>};
    }

    join ', ', @links;
}

sub _edit_link {
    my ( $app, $cat ) = @_;
    $app->uri(
        mode => 'edit',
        args => {
            _type   => 'category',
            blog_id => $cat->blog_id,
            id      => $cat->id,
        },
    );
}

# similar to tag terms.
sub terms {
    my $prop = shift;
    my ( $args, $db_terms, $db_args ) = @_;

    my $label_terms = $prop->super(@_);

    my $option = $args->{option} || '';
    if ( $option eq 'not_contains' ) {
        my $string = $args->{string};
        my $field  = MT::ContentField->load( $prop->content_field_id );

        my @cat_ids;
        my $iter = MT::Category->load_iter(
            {   label => { like => "%${string}%" },
                category_set_id => $field->related_cat_set_id,
            },
            { fetchonly => { id => 1 } },
        );
        while ( my $cat = $iter->() ) {
            push @cat_ids, $cat->id;
        }

        my $join_terms = { value_integer => [ \'IS NULL', @cat_ids ] };
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
        my $cat_join
            = MT::Category->join_on( undef,
            [ { id => \'= cf_idx_value_integer' }, $label_terms ] );
        my $join_args = { join => $cat_join };
        my $cd_ids = get_cd_ids_by_inner_join( $prop, undef, $join_args, @_ );
        { id => $cd_ids };
    }
}

sub tag_handler {
    my ( $ctx, $args, $cond, $field_data, $value ) = @_;

    my $category_set_id = $field_data->{options}{category_set}
        or return $ctx->error(
        MT->translate('No category_set setting in content field type.') );

    my $cat_terms = {
        id => @$value ? $value : 0,
        category_set_id => $category_set_id,
    };
    my $cat_args = {};

    if ( my $sort = $args->{sort} ) {
        $cat_args->{sort} = $sort;
        my $direction
            = ( $args->{sort_order} || '' ) eq 'descend'
            ? 'descend'
            : 'ascend';
        $cat_args->{direction} = $direction;
    }

    my $lastn = $args->{lastn};

    my $iter = MT::Category->load_iter( $cat_terms, $cat_args );
    my %categories;
    my @ordered_categories;
    if ( $args->{sort} ) {
        while ( my $cat = $iter->() ) {
            last
                if ( defined $lastn && scalar @ordered_categories >= $lastn );
            push @ordered_categories, $cat;
        }
    }
    else {
        while ( my $cat = $iter->() ) {
            $categories{ $cat->id } = $cat;
        }
        my @category_ids;
        if ( defined $lastn ) {
            if ( $lastn > 0 ) {
                if ( $lastn >= %categories ) {
                    @category_ids = @{$value};
                }
                else {
                    @category_ids = @{$value}[ 0 .. $lastn - 1 ];
                }
            }
        }
        else {
            @category_ids = @{$value};
        }
        @ordered_categories = grep {$_} map { $categories{$_} } @category_ids;
    }

    my $res     = '';
    my $builder = $ctx->stash('builder');
    my $tokens  = $ctx->stash('tokens');
    my $glue    = $args->{glue};
    local $ctx->{inside_mt_categories} = 1;
    my $i = 0;
    my $vars = $ctx->{__stash}{vars} ||= {};
    MT::Meta::Proxy->bulk_load_meta_objects( \@ordered_categories );

    foreach my $cat (@ordered_categories) {
        $i++;
        my $last = $i == scalar(@ordered_categories);

        local $ctx->{__stash}{category} = $cat;
        local $ctx->{__stash}{entries};
        local $ctx->{__stash}{contents};
        local $ctx->{__stash}{category_count};
        local $ctx->{__stash}{blog_id} = $cat->blog_id;
        local $ctx->{__stash}{blog}    = MT::Blog->load( $cat->blog_id );
        local $vars->{__first__}       = $i == 1;
        local $vars->{__last__}        = $last;
        local $vars->{__odd__}         = ( $i % 2 ) == 1;
        local $vars->{__even__}        = ( $i % 2 ) == 0;
        local $vars->{__counter__}     = $i;
        defined(
            my $out = $builder->build(
                $ctx, $tokens,
                {   %$cond,
                    ContentFieldHeader => $i == 1,
                    ContentFieldFooter => $last
                }
            )
        ) or return $ctx->error( $builder->errstr );
        $res .= $glue if defined $glue && length($res) && length($out);
        $res .= $out;
    }
    $res;
}

sub theme_import_handler {
    my ( $theme, $blog, $ct, $cf_value, $field, $cf ) = @_;
    my $cs_name = $field->{options}{category_set};
    if ( defined $cs_name && $cs_name ne '' ) {
        my $cs
            = MT::CategorySet->load(
            { blog_id => $blog->id, name => $cs_name } );
        if ($cs) {
            $cf->related_cat_set_id( $cs->id );
            $cf->save;
            $field->{options}{category_set} = $cs->id;
        }
        else {
            delete $field->{options}{category_set};
        }
    }
}

sub theme_export_handler {
    my ( $app, $blog, $settings, $ct, $field ) = @_;
    my $category_set = MT->model('category_set')
        ->load( $field->{options}{category_set} || 0 );
    if ($category_set) {
        $field->{options}{category_set} = $category_set->name;
    }
    else {
        delete $field->{options}{category_set};
    }
}

sub options_html_params {
    my ( $app, $param ) = @_;

    my @category_sets;
    my $iter = MT::CategorySet->load_iter( { blog_id => $app->blog->id },
        { fetchonly => { id => 1, name => 1 } } );
    while ( my $cat_set = $iter->() ) {
        push @category_sets,
            {
            id   => $cat_set->id,
            name => $cat_set->name,
            };
    }

    return { category_sets => \@category_sets, };
}

sub options_validation_handler {
    my ( $app, $type, $label, $field_label, $options ) = @_;

    my $source = $options->{category_set};
    return $app->translate("You must select a source category set.")
        unless $source;

    my $class = MT->model('category_set');
    return $app->translate(
        "The source category set is not found in this site.",
        $label, $field_label )
        if !$class->exist( { id => $source, blog_id => $app->blog->id } );

    my $multiple = $options->{multiple};
    if ($multiple) {
        my $min = $options->{min};
        return $app->translate(
            "A minimum selection number for '[_1]' ([_2]) must be a positive integer greater than or equal to 0.",
            $label, $field_label
        ) if '' ne $min and $min !~ /^\d+$/;

        my $max = $options->{max};
        return $app->translate(
            "A maximum selection number for '[_1]' ([_2]) must be a positive integer greater than or equal to 1.",
            $label,
            $field_label
        ) if '' ne $max and ( $max !~ /^\d+$/ or $max < 1 );

        return $app->translate(
            "A maximum selection number for '[_1]' ([_2]) must be a positive integer greater than or equal to the minimum selection number.",
            $label,
            $field_label
            )
            if '' ne $min
            and '' ne $max
            and $max < $min;
    }

    return;
}

sub options_pre_save_handler {
    my ( $app, $type, $obj, $options ) = @_;

    $obj->related_cat_set_id( $options->{category_set} );

    return;
}

sub field_value_handler {
    my ( $ctx, $args, $cond, $field_data, $value ) = @_;
    my $content = $ctx->stash('category');
    return $content ? $content->id : '';
}

sub feed_value_handler {
    my ( $app, $field_data, $values ) = @_;

    my $cat_ids = 0;
    if ($values) {
        if ( ref $values eq 'ARRAY' ) {
            $cat_ids = @$values ? $values : 0;
        }
        else {
            $cat_ids = $values || 0;
        }
    }
    my @categories = MT->model('category')->load(
        { id        => $cat_ids },
        { fetchonly => { id => 1, label => 1 } },
    );
    my %label_hash = map { $_->id => $_->label } @categories;

    my $contents = '';
    for my $id (@$values) {
        my $label = $label_hash{$id};
        $label = '' unless defined $label && $label ne '';
        my $encoded_label = MT::Util::encode_html($label);
        $contents .= "<li>$encoded_label (ID:$id)</li>";
    }

    return "<ul>$contents</ul>";
}

sub field_type_validation_handler {
    my $app = shift;
    my $category_set_exists
        = MT::CategorySet->exist( { blog_id => $app->blog->id } );
    unless ($category_set_exists) {
        return $app->translate(
            'There is no category set that can be selected. Please create a category set if you use the Categories field type.'
        );
    }
    return;
}

sub preview_handler {
    my ( $field_data, $values, $content_data ) = @_;
    return '' unless $values;
    unless ( ref $values eq 'ARRAY' ) {
        $values = [$values];
    }
    return '' unless @$values;

    my @categories
        = MT->model('category')
        ->load( { id => $values },
        { fetchonly => { id => 1, label => 1 } }, );
    my %label_hash = map { $_->id => $_->label } @categories;

    my $static_uri = MT->static_path;

    my $contents   = '';
    my $is_primary = 1;
    for my $id (@$values) {
        my $label = $label_hash{$id};
        $label = '' unless defined $label && $label ne '';
        my $encoded_label = MT::Util::encode_html($label);

        my $icon
            = $is_primary
            ? qq{<svg role="img" class="mt-icon--success mt-icon--sm"><title>Primary</title><use xlink:href="${static_uri}images/sprite.svg#ic_fav"></use></svg>}
            : qq{<svg role="img" class="mt-icon mt-icon--sm"><title>Blank</title><use xlink:href="${static_uri}images/sprite.svg#ic_blank"></use></svg>};

        $contents .= "<li>$icon&nbsp;$encoded_label (ID:$id)</li>";
        $is_primary = 0;
    }

    return qq{<ul class="list-unstyled">$contents</ul>};

}

sub site_import_handler {
    my ( $field_data, $content_field, $all_objects ) = @_;
    my $old_category_set_id = $field_data->{options}{category_set} or return;
    my $new_category_set
        = $all_objects->{"MT::CategorySet#$old_category_set_id"}
        or return;
    $field_data->{options}{category_set} = $new_category_set->id;
}

sub site_data_import_handler {
    my ( $field_data, $field_value, $content_data, $all_objects ) = @_;
    return unless $field_value;
    my @old_category_ids
        = ref $field_value eq 'ARRAY' ? @$field_value : ($field_value);
    my @new_category_ids = map { $_->id }
        grep {$_} map { $all_objects->{"MT::Category#$_"} } @old_category_ids;
    @new_category_ids ? \@new_category_ids : undef;
}

1;
