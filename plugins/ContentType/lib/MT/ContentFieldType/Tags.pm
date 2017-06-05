package MT::ContentFieldType::Tags;
use strict;
use warnings;

use MT::ContentFieldType::Common
    qw( get_cd_ids_by_inner_join get_cd_ids_by_left_join );
use MT::Tag;

sub field_html_params {
    my ( $app, $field_data ) = @_;
    my $value = $field_data->{value};
    $value = [] unless defined $value;

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

    my @tag_list;
    my $iter = MT::Tag->load_iter( { id => $value }, { sort => 'name' } );
    while ( my $t = $iter->() ) {
        push @tag_list,
            {
            id       => $t->id,
            label    => $t->name,
            basename => $t->name,
            path     => [],
            fields   => [],
            };
    }

    {   multiple          => $multiple,
        required          => $required,
        tag_list          => \@tag_list,
        selected_tag_loop => $value,
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

    my %tag_names;
    my $iter = MT::Tag->load_iter( { id => $tag_ids },
        { fetchonly => { id => 1, name => 1 } } );
    while ( my $tag = $iter->() ) {
        $tag_names{ $tag->id } = $tag->name;
    }

    my @links;
    for my $id (@$tag_ids) {
        my $tag_name = $tag_names{$id};
        my $link = _link( $app, $tag_name );
        push @links, qq{<a href="$link">${tag_name}</a>};
    }

    join ', ', @links;
}

sub ss_validator {
    my ( $app, $field_data, $data ) = @_;

    my $options = $field_data->{options} || {};
    my $field_label = $options->{label};

    my $iter
        = MT::Tag->load_iter( { id => $data }, { fetchonly => { id => 1 } } );
    my %valid_tags;
    while ( my $tag = $iter->() ) {
        $valid_tags{ $tag->id } = 1;
    }
    if ( my @invalid_tag_ids = grep { !$valid_tags{$_} } @{$data} ) {
        my $invalid_tag_ids = join ', ', sort(@invalid_tag_ids);
        return $app->translate( 'Invalid Tag IDs: [_1] in "[_2]" field.',
            $invalid_tag_ids, $field_label );
    }

    my $type_label        = 'tag';
    my $type_label_plural = 'tags';
    MT::ContentFieldType::Common::ss_validator_multiple( @_, $type_label,
        $type_label_plural );
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
    my ( $ctx, $args, $cond, $field, $value ) = @_;

    my $iter = MT::Tag->load_iter( { id => $value } );
    my %tags;
    while ( my $tag = $iter->() ) {
        $tags{ $tag->id } = $tag;
    }
    my @ordered_tags = map { $tags{$_} } @{$value};

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
        local $vars->{__first__}   = $i == 1;
        local $vars->{__last__}    = $i == scalar @ordered_tags;
        local $vars->{__odd__}     = ( $i % 2 ) == 1;
        local $vars->{__even__}    = ( $i % 2 ) == 0;
        local $vars->{__counter__} = $i;
        $i++;
        local $ctx->{__stash}{Tag}               = $tag;
        local $ctx->{__stash}{tag_count}         = undef;
        local $ctx->{__stash}{tag_content_count} = undef;
        defined( my $out = $builder->build( $ctx, $tokens, $cond ) )
            or return $ctx->error( $builder->errstr );
        $res .= $glue if defined $glue && length($res) && length($out);
        $res .= $out;
    }
    $res;
}

1;

