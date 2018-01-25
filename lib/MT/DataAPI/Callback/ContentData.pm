package MT::DataAPI::Callback::ContentData;
use strict;
use warnings;

use MT::ContentStatus;

sub can_list {
    my ( $eh, $app, $terms, $args, $options ) = @_;

    my $status = $app->param('status');
    if (   defined($status)
        && lc($status) ne 'publish'
        && $app->user->is_anonymous )
    {
        return 0;
    }

    1;
}

sub can_view {
    my ( $eh, $app, $id, $objp ) = @_;
    my $obj = $objp->force();
    return 1 if $obj->status == MT::ContentStatus::RELEASE;
    my $user = $app->user or return;
    return $user->permissions( $obj->blog_id )
        ->can_edit_content_data( $obj, $user );
}

sub cms_pre_load_filtered_list {
    my ( $cb, $app, $filter, $load_options, $cols ) = @_;

    my $user = $app->user;
    return
           if $user->is_superuser
        || $user->can_do('publish_all_content_data')
        || $user->can_do('edit_all_content_data');

    my $terms = $load_options->{terms} ||= {};
    my $blog_ids;
    $blog_ids = delete $terms->{blog_id}
        if exists $terms->{blog_id};

    my $make_week_perm_filter = sub {
        my ($blog_id) = @_;

        my @f = ();

        if ($blog_id) {
            push @f, { blog_id => $blog_id }, '-and';
        }

        push @f,
            [
            { status => MT::ContentStatus::RELEASE(), },
            '-or',
            { author_id => $user->id, }
            ];

        \@f;
    };

    my %filters = ();
    for my $id ( ref $blog_ids ? @$blog_ids : $blog_ids ) {
        $filters{ $id || 0 } = $make_week_perm_filter->($id);
    }

    require MT::Permission;
    my $iter = MT::Permission->load_iter(
        {   author_id => $user->id,
            (   $blog_ids
                ? ( blog_id => $blog_ids )
                : ( blog_id => { 'not' => 0 } )
            ),
        }
    );

    my $content_type = MT->model('content_type')
        ->load( $app->param('content_type_id') || 0 );

    while ( my $perm = $iter->() ) {
        my $blog_id = $perm->blog_id;
        if (   $perm->can_do('publish_all_content_data')
            || $perm->can_do('edit_all_content_data') )
        {
            $filters{$blog_id} = { blog_id => $blog_id, };
        }
        elsif ($content_type) {
            if ($perm->can_do(
                    'publish_all_content_data_' . $content_type->unique_id
                )
                || $perm->can_do(
                    'edit_all_content_data_' . $content_type->unique_id
                )
                )
            {
                $filters{$blog_id} = { blog_id => $blog_id, };
            }
        }
        else {
            $filters{$blog_id} = $make_week_perm_filter->($blog_id);
        }
    }

    my $new_terms;
    push @$new_terms, ($terms)
        if ( keys %$terms );
    my @filters = map { +( '-or', $_ ) } values %filters;
    push @$new_terms, ( '-and', @filters ? \@filters : { blog_id => 0 } );
    $load_options->{terms} = $new_terms;

    1;
}

sub save_filter {
    my ( $eh, $app, $obj, $orig ) = @_;

    my $registry     = $app->registry('content_field_types');
    my $content_type = $obj->content_type;
    my $data         = $obj->data;

    for my $field ( @{ $content_type->fields } ) {
        my $field_id   = $field->{id};
        my $field_data = $data->{$field_id};

        if ($field->{options}{required}
            && (   ( !defined $field_data || $field_data eq '' )
                || ( ref $field_data eq 'ARRAY' && @$field_data == 0 )
                || ( ref $field_data eq 'HASH'  && %$field_data == 0 ) )
            )
        {
            return $app->errtrans( '"[_1]" field is required.',
                $field->{options}{label} );
        }

        my $type_registry = $registry->{ $field->{type} };
        my $ss_validator = $type_registry->{ss_validator} or next;
        unless ( ref $ss_validator eq 'CODE' ) {
            $ss_validator = $app->handler_to_coderef($ss_validator);
        }
        if ( my $error = $ss_validator->( $app, $field, $field_data ) ) {
            return $app->errtrans( 'There is an invalid field data: [_1]',
                $error );
        }
    }

    1;
}

1;

