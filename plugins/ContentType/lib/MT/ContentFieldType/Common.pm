package MT::ContentFieldType::Common;
use strict;
use warnings;
use base 'Exporter';

our @EXPORT_OK = qw(
    get_cd_ids_by_inner_join
    get_cd_ids_by_left_join
);

use MT::ContentData;
use MT::ContentField;
use MT::ContentFieldIndex;

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

sub field_html_text {
    my ( $app, $field_id, $value ) = @_;
    $value = '' unless defined $value;

    my $content_field = MT::ContentField->load($field_id);

    my $max_length = $content_field->options->{max_length};
    $max_length = $max_length ? qq{maxlength="${max_length}"} : '';
    my $required = $content_field->options->{required} ? 'required' : '';

    my $html
        = qq{<input type="text" name="content-field-${field_id}" class="text long" value="${value}" mt:watch-change="1" mt:raw-name="1" ${required} ${max_length} />};

    if ( my $min_length = $content_field->options->{min_length} ) {
        $html .= <<"__JS__";
<script>
(function () {
  jQuery('input[name=content-field-${field_id}]').on('keyup', function () {
    if (this.value.length < ${min_length}) {
      this.setCustomValidity(`Please input ${min_length} characters or more.`);
    } else {
      this.setCustomValidity('');
    }
  });
})();
</script>
__JS__
    }

    $html;
}

1;

