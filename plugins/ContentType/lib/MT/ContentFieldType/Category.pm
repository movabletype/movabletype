package MT::ContentFieldType::Category;
use strict;
use warnings;

use MT::Category;
use MT::ObjectCategory;

sub field_html {
    my ( $app, $field_id, $value ) = @_;
    $value = ''       unless defined $value;
    $value = [$value] unless ref $value eq 'ARRAY';

    my @cats;
    if ( my $field = MT->model('content_field')->load($field_id) ) {
        if ( my $cat_list
            = MT->model('category_list')
            ->load( $field->related_cat_list_id || 0 ) )
        {
            @cats = @{ $cat_list->categories };
        }
    }

    my $html = '';
    my $num  = 1;

    foreach my $cat (@cats) {
        my $cat_id    = $cat->id;
        my $cat_label = $cat->label;
        my $edit_link = _edit_link( $app, $cat );

        $html .= '<div>';
        $html
            .= "<input type=\"checkbox\" name=\"content-field-$field_id\" id=\"content-field-$field_id-$num\" value=\"$cat_id\"";
        $html .=
            ( grep { $_ eq $cat_id } @$value )
            ? ' checked="checked"'
            : '';
        $html .= " />";
        $html
            .= " <label for=\"content-field-$field_id-$num\">$cat_label</label>";
        $html .= qq{ (<a href="${edit_link}">edit</a>)};
        $html .= '</div>';

        $num++;
    }
    return $html;
}

sub data_getter {
    my ( $app, $field_id ) = @_;
    my @cat_ids = $app->param( 'content-field-' . $field_id );

    my @valid_cats = MT->model('category')
        ->load( { id => \@cat_ids }, { fetchonly => { id => 1 } } );
    my %valid_cats = map { $_->id => 1 } @valid_cats;

    [ grep { $valid_cats{$_} } @cat_ids ];
}

sub html {
    my $prop = shift;
    my ( $content_data, $app, $opts ) = @_;

    my $cat_ids = $content_data->data->{ $prop->content_field_id } || [];

    my %cats
        = map { $_->id => $_ }
        MT->model('category')->load( { id => $cat_ids } );
    my @cats = map { $cats{$_} } @$cat_ids;

    my @links;
    for my $cat (@cats) {
        my $label = $cat->label;
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

    my $option = $args->{option} || '';

    my $super = MT->registry( 'list_properties', '__virtual', 'string' );
    my $label_terms = $super->{terms}->( $prop, @_ );

    if ( $option eq 'not_contains' ) {
        my $string = $args->{string};
        my $field
            = MT->model('content_field')->load( $prop->content_field_id );

        my $category_join = MT->model('category')->join_on(
            undef,
            {   id      => \'= cf_idx_value_integer',
                label   => { like => "%${string}%" },
                list_id => $field->related_cat_list_id,
            },
        );
        my $cf_idx_join = MT::ContentFieldIndex->join_on(
            undef,
            {   content_data_id  => \'= cd_id',
                content_field_id => $prop->content_field_id,
            },
            { join => $category_join, unique => 1 },
        );
        my @cd_ids
            = map { $_->id }
            MT::ContentData->load( { blog_id => MT->app->blog->id },
            { join => $cf_idx_join, fetchonly => { id => 1 } } );
        @cd_ids ? { id => { not => \@cd_ids } } : ();
    }
    elsif ( $option eq 'blank' ) {
        my $cf_idx_join = MT::ContentFieldIndex->join_on(
            undef,
            { value_integer => \'IS NULL' },
            {   type      => 'left',
                condition => {
                    content_data_id  => \'= cd_id',
                    content_field_id => $prop->content_field_id,
                },
            }
        );
        $db_args->{joins} ||= [];
        push @{ $db_args->{joins} }, $cf_idx_join;
    }
    else {
        my $cat_join
            = MT->model('category')
            ->join_on( undef,
            [ { id => \'= cf_idx_value_integer' }, $label_terms ] );
        my $cf_idx_join = MT->model('content_field_index')->join_on(
            undef,
            {   content_data_id  => \'= cd_id',
                content_field_id => $prop->content_field_id,
            },
            { join => $cat_join, unique => 1 },
        );
        $db_args->{joins} ||= [];
        push @{ $db_args->{joins} }, $cf_idx_join;
    }
}

1;

