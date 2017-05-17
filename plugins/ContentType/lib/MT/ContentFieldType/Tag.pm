package MT::ContentFieldType::Tag;
use strict;
use warnings;

use MT::ContentField;
use MT::ContentFieldType::Common
    qw( get_cd_ids_by_inner_join get_cd_ids_by_left_join );
use MT::Tag;

sub field_html_params {
    my ( $app, $field_data ) = @_;
    my $value = $field_data->{value};
    $value = [] unless defined $value;

    my $tag_delim = _tag_delim($app);

    my $tags;
    if ( ref $value ) {
        my %tags = map { $_->id => $_ } MT::Tag->load( { id => $value } );
        $tags = join $tag_delim, ( map { $tags{$_}->name } @{$value} );
    }
    else {
        $tags = $value;
    }

    my $options = $field_data->{options};

    my $multiple = '';
    if ( $options->{multiple} ) {
        my $max = $options->{max};
        my $min = $options->{min};
        $multiple = 'data-mt-multiple="1"';
        $multiple .= qq{ data-mt-max-tag="${max}"} if $max;
        $multiple .= qq{ data-mt-min-tag="${min}"} if $min;
    }

    my $required = $options->{required} ? 'data-mt-required="1"' : '';

    my $tag_delim_data = qq{data-mt-tag-delim="${tag_delim}"};

    {   multiple  => $multiple,
        required  => $required,
        tags      => $tags,
        tag_delim => $tag_delim_data,
    };
}

sub data_getter {
    my ( $app, $field_id ) = @_;

    my $unique_tag_names = _get_unique_tags( $app, $field_id );

    my %existing_tags
        = map { $_->name => $_ } MT::Tag->load( { name => $unique_tag_names },
        { binary => { name => 1 } } );

    my $content_field = MT::ContentField->load($field_id);

    if ( $content_field->options->{can_add} ) {
        for my $utn ( @{$unique_tag_names} ) {
            unless ( $existing_tags{$utn} ) {
                my $tag = MT::Tag->new;
                $tag->name($utn);
                $tag->save;

                $existing_tags{$utn} = $tag;
            }
        }
    }

    my @tags = map { $existing_tags{$_}->id }
        grep { $existing_tags{$_} } @{$unique_tag_names};
    \@tags;
}

sub _get_unique_tags {
    my ( $app, $field_id ) = @_;
    my $tag_delim = _tag_delim($app);

    my @tags = split $tag_delim,
        scalar( $app->param("content-field-${field_id}") );

    my @unique_tags;
    my %exist_tags;
    for my $tag (@tags) {
        $tag =~ s/^\s*|\s*$//g;
        if ( $tag ne '' ) {
            next if $exist_tags{$tag}++;
            push @unique_tags, $tag;
        }
    }

    \@unique_tags;
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
        $cd_ids ? { id => { not => \$cd_ids } } : ();
    }
    elsif ( $option eq 'blank' ) {
        my $join_terms = { value_integer => \'IS NULL' };
        my $cd_ids = get_cd_ids_by_left_join( $prop, $join_terms, undef, @_ );
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

    my %tag_names
        = map { $_->id => $_->name } MT::Tag->load( { id => $tag_ids },
        { fetchonly => { id => 1, name => 1 } } );

    my @links;
    for my $id (@$tag_ids) {
        my $tag_name = $tag_names{$id};
        my $link = _link( $app, $tag_name );
        push @links, qq{<a href="$link">${tag_name}</a>};
    }

    my $tag_delim = _tag_delim($app);
    join ', ', @links;
}

sub ss_validator {
    my ( $app, $field_id ) = @_;

    my $content_field = MT::ContentField->load($field_id);
    my $options       = $content_field->options;

    my $field_label = $options->{label};
    my $multiple    = $options->{multiple};
    my $max         = $options->{max};
    my $min         = $options->{min};
    my $can_add     = $options->{can_add};

    my $unique_tags = _get_unique_tags( $app, $field_id );

    if ( !$multiple && @{$unique_tags} >= 2 ) {
        return $app->errtrans( 'Only 1 tag can be input in "[_1]" field.',
            $field_label );
    }
    if ( $multiple && $max && @{$unique_tags} > $max ) {
        return $app->errtrans(
            'Tags less than or equal to [_1] must be input in "[_2]" field.',
            $max, $field_label
        );
    }
    if ( $multiple && $min && @{$unique_tags} < $min ) {
        return $app->errtrans(
            'Tags greater than or equal to [_1] must be input in "[_2]" field.',
            $min, $field_label
        );
    }
    if ( !$can_add ) {
        my $tag_count = MT::Tag->count( { name => $unique_tags },
            { binary => { name => 1 } } );
        if ( $tag_count != @{$unique_tags} ) {
            return $app->errtrans(
                'New tag cannot be created in "[_1]" field.', $field_label );
        }
    }
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

sub _tag_delim {
    my $app = shift;
    chr( $app->user->entry_prefs->{tag_delim} );
}

1;

