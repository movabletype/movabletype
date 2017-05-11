package MT::ContentFieldType::List;
use strict;
use warnings;

use MT::ContentField;
use MT::ContentFieldType::Common
    qw( get_cd_ids_by_inner_join get_cd_ids_by_left_join );

sub field_html_params {
    my ( $app, $field_id, $values ) = @_;
    $values = ''        unless defined $values;
    $values = [$values] unless ref $values eq 'ARRAY';

    my $content_field = MT::ContentField->load($field_id);

    {   field_id    => $field_id,
        list_values => $values,
        required    => $content_field->options->{required} ? 1 : 0,
    };
}

sub data_getter {
    my ( $app, $field_id ) = @_;
    [ $app->param("content-field-${field_id}") ];
}

sub html {
    my $prop = shift;
    my ( $content_data, $app, $load_options ) = @_;

    my $field = MT::ContentField->load( $prop->content_field_id );
    my $bullet_or_numbered = $field->options->{bullet_or_numbered} || '';
    my $list_style_type
        = $bullet_or_numbered eq 'numbered' ? 'decimal' : 'disc';

    my $values = $content_data->data->{ $prop->content_field_id } || [];
    my $values_html = join '', (
        map {
            qq{<li class="role-item" style="list-style-type: ${list_style_type}">$_</li>}
        } @{$values}
    );

    "<ul>${values_html}</ul>";
}

sub terms {
    my $prop = shift;
    my ( $args, $db_terms, $db_args ) = @_;

    my $option = $args->{option} || '';
    my $join_args = undef;

    if ( $option eq 'not_contains' ) {
        my $col    = $prop->col;
        my $string = $args->{string};
        my $join_terms
            = { $col => [ \'IS NULL', { like => "%${string}%" } ] };
        my $cd_ids
            = get_cd_ids_by_inner_join( $prop, $join_terms, $join_args, @_ );
        $cd_ids ? { id => { not => $cd_ids } } : ();
    }
    else {
        my $join_terms = $prop->super(@_);
        my $cd_ids
            = get_cd_ids_by_inner_join( $prop, $join_terms, $join_args, @_ );
        { id => $cd_ids };
    }
}

1;

