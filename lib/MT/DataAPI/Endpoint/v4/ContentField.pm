package MT::DataAPI::Endpoint::v4::ContentField;
use strict;
use warnings;

use Hash::Merge::Simple;

use MT::DataAPI::Endpoint::Common;
use MT::DataAPI::Resource;

sub list {
    my ( $app, $endpoint ) = @_;

    my ( $site, $content_type ) = context_objects(@_) or return;

    run_permission_filter( $app, 'data_api_view_permission_filter',
        'content_type', $content_type->id, obj_promise($content_type) )
        or return;

    my $res = filtered_list(
        $app,
        $endpoint,
        'content_field',
        {   blog_id         => $content_type->blog_id,
            content_type_id => $content_type->id,
        }
    ) or return;

    +{  totalResults => $res->{count} || 0,
        items =>
            MT::DataAPI::Resource::Type::ObjectList->new( $res->{objects} ),
    };
}

sub create {
    my ( $app, $endpoint ) = @_;

    my ( $site, $content_type ) = context_objects(@_) or return;

    run_permission_filter( $app, 'data_api_save_permission_filter',
        'content_type', $content_type->id )
        or return;

    my $orig_content_field = $app->model('content_field')->new(
        blog_id         => $content_type->blog_id,
        content_type_id => $content_type->id,
    );

    my $new_content_field
        = $app->resource_object( 'content_field', $orig_content_field )
        or return;

    save_object(
        $app,
        'content_field',
        $new_content_field,
        $orig_content_field,
        sub {
            my $save_method = shift;
            $save_method->() or return;

            my $fields = $content_type->fields;
            my ($field)
                = grep { ( $_->{id} || 0 ) eq $new_content_field->id }
                @$fields;
            unless ($field) {
                $field = { id => $new_content_field->id };
                push @$fields, $field;
            }
            $field->{options} ||= {};
            $field->{options}{label} = $new_content_field->name;

            my $hashes
                = $app->request('data_api_content_field_hashes_for_save')
                || [];
            my $hash = shift @$hashes;
            return unless $hash;

            $field->{options}
                = Hash::Merge::Simple->merge( $field->{options},
                $hash->{options} );

            $content_type->fields($fields);
            $content_type->save
                or return $new_content_field->error( $content_type->errstr );

        }
    ) or return;

    $new_content_field;
}

sub get {
    my ( $app, $endpoint ) = @_;

    my ( $site, $content_type, $content_field ) = context_objects(@_)
        or return;

    run_permission_filter( $app, 'data_api_view_permission_filter',
        'content_type', $content_type->id, obj_promise($content_type) )
        or return;

    run_permission_filter( $app, 'data_api_view_permission_filter',
        'content_field', $content_field->id, obj_promise($content_field) )
        or return;

    $content_field;
}

sub update {
    my ( $app, $endpoint ) = @_;

    my ( $site, $content_type, $orig_content_field ) = context_objects(@_)
        or return;

    run_permission_filter( $app, 'data_api_save_permission_filter',
        'content_type', $content_type->id )
        or return;

    my $new_content_field
        = $app->resource_object( 'content_field', $orig_content_field );

    save_object( $app, 'content_field', $new_content_field ) or return;

    $new_content_field;
}

sub delete {
    my ( $app, $endpoint ) = @_;

    my ( $site, $content_type, $content_field ) = context_objects(@_)
        or return;

    run_permission_filter( $app, 'data_api_save_permission_filter',
        'content_type', $content_type )
        or return;

    run_permission_filter( $app, 'data_api_delete_permission_filter',
        'content_field', $content_field )
        or return;

    $content_field->remove
        or return $app->error(
        $app->translate(
            'Removing [_1] failed: [_2]', $content_field->class_label,
            $content_field->errstr
        ),
        500,
        );

    $app->run_callbacks( 'data_api_post_delete.content_field',
        $app, $content_field );

    $content_field;
}

sub permutate {
    my ( $app, $endpoint ) = @_;

    my ( $site, $content_type ) = context_objects(@_)
        or return;

    run_permission_filter( $app, 'data_api_save_permission_filter',
        'content_type', $content_type )
        or return;

    my $content_fields_json = $app->param('content_fields')
        or return $app->error(
        $app->translate('A parameter "content_fields" is required.'), 400 );

    my $content_fields_array
        = $app->current_format->{unserialize}->($content_fields_json);
    return _invalid_error($app) if ref $content_fields_array ne 'ARRAY';

    my @content_field_ids = map { $_->{id} } @$content_fields_array;
    my @content_fields = MT->model('content_field')->load(
        {   id              => \@content_field_ids,
            content_type_id => $content_type->id,
        }
    );
    my %content_fields_hash = map { $_->id => $_ } @content_fields;
    @content_fields = map { $content_fields_hash{$_} } @content_field_ids;

    my $sorted_orig_ids = join ',',
        sort map { $_->{id} } @{ $content_type->fields };
    my $sorted_param_ids = join ',', sort map { $_->id } @content_fields;
    return _invalid_error($app) if $sorted_orig_ids ne $sorted_param_ids;

    my $order         = 1;
    my %fields_hash   = map { $_->{id} => $_ } @{ $content_type->fields };
    my @sorted_fields = map { $fields_hash{$_} } @content_field_ids;
    $_->{order} = $order++ for @sorted_fields;
    $content_type->fields( \@sorted_fields );
    $content_type->save
        or return $app->error(
        $app->translate(
            'Saving object failed: [_1]', $content_type->errstr
        )
        );

    return MT::DataAPI::Resource->from_object( \@content_fields );
}

sub _invalid_error {
    my $app = shift;
    $app->error( $app->translate('A parameter "content_fields" is invalid.'),
        400 );
}

1;

