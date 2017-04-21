package MT::ContentFieldType::Tag;
use strict;
use warnings;

use MT;
use MT::ContentField;
use MT::Tag;
use MT::ObjectTag;

sub field_html {
    my ( $app, $field_id, $value ) = @_;
    my @obj_tags = MT::ObjectTag->load(
        {   blog_id           => $app->blog->id,
            object_datasource => 'content_field',
            object_id         => $field_id,
        }
    );
    my $html = '';
    $html
        .= '<input type="text" name="content-field-'
        . $field_id
        . '" class="text long" value="';
    my $count = 1;
    foreach my $obj_tag (@obj_tags) {
        my $tag = MT::Tag->load( $obj_tag->tag_id );
        $html .= $tag->name;
        $html .= ',' unless $count == @obj_tags;
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

    my $super = MT->registry( 'list_properties', '__virtual', 'string' );
    my $name_terms = $super->{terms}->( $prop, @_ );

    my $tag_join = MT::Tag->join_on( undef,
        [ { id => \'= objecttag_tag_id' }, $name_terms ] );

    my $objecttag_join = MT::ObjectTag->join_on(
        undef,
        {   blog_id           => MT->app->blog->id,
            object_datasource => 'content_field',
            object_id         => $prop->content_field_id,
        },
        { join => $tag_join, unique => 1 },
    );

    $db_args->{joins} ||= [];
    push @{ $db_args->{joins} }, $objecttag_join;
}

sub html {
    my $prop = shift;
    my ( $content_data, $app, $opts ) = @_;

    my $tag_ids = $content_data->data->{ $prop->content_field_id } || [];

    my %tags = map { $_->id => $_->name } MT::Tag->load( { id => $tag_ids },
        { fetchonly => { id => 1, name => 1 } } );

    join( ',', map { $tags{$_} } @$tag_ids );
}

1;

