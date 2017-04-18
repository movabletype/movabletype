package MT::ContentFieldType::Tag;
use strict;
use warnings;

use MT::Tag;
use MT::ObjectTag;

sub field_html {
    my ( $app, $id, $value ) = @_;
    my $q          = $app->param;
    my $ct_data_id = $q->param('id');
    my @obj_tags   = MT::ObjectTag->load(
        {   object_ds => 'content_data',
            object_id => $ct_data_id
        }
    );
    my $html = '';
    $html
        .= '<input type="text" name="content-field-'
        . $id
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
    my ( $app, $id ) = @_;
    my $q          = $app->param;
    my $ct_data_id = $q->param('id');
    my $tag_names  = $q->param( 'content-field-' . $id );
    my @tag_names  = split ',', $tag_names;
    my @tags       = MT::Tag->load( { name => \@tag_names },
        { binary => { name => 1 } } );
    my @obj_tags = MT::ObjectTag->load(
        {   object_datasource => 'content_data',
            object_id         => $ct_data_id
        }
    );
    foreach my $obj_tag (@obj_tags) {
        $obj_tag->remove
            unless ( grep { $_->id eq $obj_tag->id } @tags );
    }
    foreach my $tag_name (@tag_names) {
        my ($tag) = grep { $_->name eq $tag_name } @tags;
        unless ($tag) {
            $tag = MT::Tag->new;
            $tag->name($tag_name);
            $tag->save or next;
        }
        my $obj_tag = MT::ObjectTag->load(
            {   tag_id            => $tag->id,
                object_datasource => 'content_data',
                object_id         => $ct_data_id
            }
        );
        next if $obj_tag;
        $obj_tag = MT::ObjectTag->new;
        $obj_tag->blog_id( $app->blog->id );
        $obj_tag->tag_id( $tag->id );
        $obj_tag->object_datasource('content_data');
        $obj_tag->object_id($ct_data_id);
        $obj_tag->save;
    }
    return $tag_names;
}

1;

