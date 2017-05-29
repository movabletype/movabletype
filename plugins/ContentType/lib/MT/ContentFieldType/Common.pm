package MT::ContentFieldType::Common;
use strict;
use warnings;
use base 'Exporter';

our @EXPORT_OK = qw(
    get_cd_ids_by_inner_join
    get_cd_ids_by_left_join
);

use MT::Asset;
use MT::ContentData;
use MT::ContentFieldIndex;
use MT::Util ();

sub get_cd_ids_by_inner_join {
    my $prop       = shift;
    my $join_terms = shift || {};
    my $join_args  = shift || {};
    my ( $args, $db_terms, $db_args ) = @_;

    my $join = MT::ContentFieldIndex->join_on(
        undef,
        {   content_data_id  => \'= cd_id',
            content_field_id => $prop->content_field_id,
            %{$join_terms},
        },
        {   unique => 1,
            %{$join_args},
        },
    );
    _get_cd_ids( $db_terms, $join );
}

sub get_cd_ids_by_left_join {
    my $prop       = shift;
    my $join_terms = shift;
    my $join_args  = shift || {};
    my ( $args, $db_terms, $db_args ) = @_;

    my $join = MT::ContentFieldIndex->join_on(
        undef,
        $join_terms,
        {   type      => 'left',
            condition => {
                content_data_id  => \'= cd_id',
                content_field_id => $prop->content_field_id,
            },
            unique => 1,
            %{$join_args},
        }
    );
    _get_cd_ids( $db_terms, $join );
}

sub _get_cd_ids {
    my ( $db_terms, $join ) = @_;
    my @cd_ids;
    my $iter = MT::ContentData->load_iter( $db_terms,
        { join => $join, fetchonly => { id => 1 } } );
    while ( my $cd = $iter->() ) {
        push @cd_ids, $cd->id;
    }
    @cd_ids ? \@cd_ids : 0;
}

sub terms_text {
    my $prop = shift;
    my ( $args, $db_terms, $db_args ) = @_;

    my $join_terms = $prop->super(@_);
    my $cd_ids = get_cd_ids_by_left_join( $prop, $join_terms, undef, @_ );
    { id => $cd_ids };
}

sub data_getter_multiple {
    my ( $app, $field_data ) = @_;
    my $field_id = $field_data->{id};
    [ $app->param("content-field-${field_id}") ];
}

sub data_getter_asset {
    my ( $app, $field_data ) = @_;
    my $field_id = $field_data->{id};
    my $asset_ids = $app->param( 'content-field-' . $field_id ) || '';
    [ split ',', $asset_ids ];
}

sub ss_validator_datetime {
    my ( $app, $field_data, $data ) = @_;

    unless ( !defined $data || $data eq '' || MT::Util::is_valid_date($data) )
    {
        my $field_type  = $field_data->{type};
        my $field_label = $field_data->{options}{label};

        return $app->translate( 'Invalid [_1] in "[_2]" field.',
            $field_type, $field_label );
    }

    undef;
}

sub ss_validator_multiple {
    my ( $app, $field_data, $data, $type_label, $type_label_plural ) = @_;

    if ( !defined $type_label_plural ) {
        if ( defined $type_label ) {
            $type_label_plural = $type_label;
        }
        else {
            $type_label        = 'option';
            $type_label_plural = 'options';
        }
    }

    my $options = $field_data->{options} || {};

    my $field_label = $options->{label};
    my $multiple    = $options->{multiple};
    my $max         = $options->{max};
    my $min         = $options->{min};

    if ( $multiple && $max && @{$data} > $max ) {
        return $app->translate(
            '[_1] less than or equal to [_2] must be selected in "[_3]" field.',
            ucfirst($type_label_plural), $max, $field_label
        );
    }
    elsif ( $multiple && $min && @{$data} < $min ) {
        return $app->translate(
            '[_1] greater than or equal to [_2] must be selected in "[_3]" field.',
            ucfirst($type_label_plural), $min, $field_label
        );
    }
    if ( !$multiple && @{$data} >= 2 ) {
        return $app->translate(
            'Only 1 [_1] can be selected in "[_2]" field.',
            lc($type_label), $field_label );
    }

    undef;
}

1;

