package MT::ContentFieldType::Category;
use strict;
use warnings;

use MT::Category;
use MT::CategoryList;
use MT::ContentField;
use MT::ContentFieldType::Common
    qw( get_cd_ids_by_inner_join get_cd_ids_by_left_join );

sub field_html_params {
    my ( $app, $field_data ) = @_;
    my $value = $field_data->{value};
    $value = ''       unless defined $value;
    $value = [$value] unless ref $value eq 'ARRAY';

    my %values = map { $_ => 1 } @{$value};

    my @cats;
    if ( my $field
        = MT::ContentField->load( $field_data->{content_field_id} ) )
    {
        if ( my $cat_list
            = MT::CategoryList->load( $field->related_cat_list_id || 0 ) )
        {
            @cats = map {
                {   cat_id        => $_->id,
                    cat_label     => $_->label,
                    cat_edit_link => _edit_link( $app, $_ ),
                    $values{ $_->id }
                    ? ( checked => 'checked="checked"' )
                    : (),
                }
            } @{ $cat_list->categories };
        }
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

    my $required = $options->{required} ? 'data-mt-required="1"' : '';

    {   categories => \@cats,
        multiple   => $multiple,
        required   => $required,
    };
}

sub data_getter {
    my ( $app, $field_id ) = @_;
    my @cat_ids = $app->param( 'content-field-' . $field_id );

    my %valid_cats
        = map { $_->id => 1 } MT::Category->load( { id => \@cat_ids },
        { fetchonly => { id => 1 } } );

    [ grep { $valid_cats{$_} } @cat_ids ];
}

sub html {
    my $prop = shift;
    my ( $content_data, $app, $opts ) = @_;

    my $cat_ids = $content_data->data->{ $prop->content_field_id } || [];

    my %cats = map { $_->id => $_ } MT::Category->load( { id => $cat_ids } );
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

    my $label_terms = $prop->super(@_);

    my $option = $args->{option} || '';
    if ( $option eq 'not_contains' ) {
        my $string = $args->{string};
        my $field  = MT::ContentField->load( $prop->content_field_id );

        my @cat_ids = map { $_->id } MT::Category->load(
            {   label => { like => "%${string}%" },
                category_list_id => $field->related_cat_list_id,
            },
            { fetchonly => { id => 1 } },
        );

        my $join_terms = { value_integer => [ \'IS NULL', @cat_ids ] };
        my $cd_ids = get_cd_ids_by_left_join( $prop, $join_terms, undef, @_ );
        $cd_ids ? { id => { not => $cd_ids } } : ();
    }
    elsif ( $option eq 'blank' ) {
        my $join_terms = { value_integer => \'IS NULL' };
        my $cd_ids = get_cd_ids_by_left_join( $prop, $join_terms, undef, @_ );
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

1;

