package MT::ContentFieldType::Tag;
use strict;
use warnings;

use MT::ContentFieldType::Common
    qw( get_cd_ids_by_inner_join get_cd_ids_by_left_join );
use MT::Tag;

sub field_html {
    my ( $app, $field_id, $value ) = @_;
    $value = '' unless defined $value;
    $value = [] unless ref $value eq 'ARRAY';

    my $html = '';
    $html
        .= '<input type="text" name="content-field-'
        . $field_id
        . '" class="text long" value="';
    my $count = 1;
    foreach my $tag_id (@$value) {
        my $tag = MT::Tag->load($tag_id);
        $html .= $tag->name;
        $html .= ',' unless $count == @$value;
        $count++;
    }
    $html .= '" />';
    return $html;
}

sub data_getter {
    my ( $app, $field_id ) = @_;

    # keep order.
    my @unique_tag_names;
    {
        my @tag_names = split ',',
            scalar( $app->param( 'content-field-' . $field_id ) );

        my %tmp;
        for my $tn (@tag_names) {
            $tn =~ s/^\s*|\s*$//g;

            next if $tmp{$tn};
            $tmp{$tn} = 1;

            push @unique_tag_names, $tn;
        }
    }

    my %existing_tags
        = map { $_->name => $_ }
        MT::Tag->load( { name => \@unique_tag_names },
        { binary => { name => 1 } } );

    for my $utn (@unique_tag_names) {
        unless ( $existing_tags{$utn} ) {
            my $tag = MT::Tag->new;
            $tag->name($utn);
            $tag->save;

            $existing_tags{$utn} = $tag;
        }
    }

    [ map { $existing_tags{$_}->id } @unique_tag_names ];
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

    join ', ', @links;
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

1;

