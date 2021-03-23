package ContentInfoWidget;

use strict;
use warnings;
use File::Spec;
use MT::Util;

sub edit_template_param {
    my ( $cb, $app, $param, $tmpl ) = @_;
    my $blog_id = $param->{blog_id} or return;
    my $ct_id   = $param->{content_type_id};
    my $type    = $param->{type};
    my $plugin  = $cb->plugin;
    my $config  = $plugin->get_config_hash;
    if ( my $others = delete $config->{others} ) {
        for my $key ( split /[ ,]+/, $others ) {
            $config->{$key} = 1 if $key;
        }
    }
    return unless $config->{$type};

    my $elements = $tmpl->getElementsByName('related_content') or return;
    my $related  = $elements->[0];
    my $path     = File::Spec->catfile( $plugin->path, 'tmpl', 'widget.tmpl' );
    my $include  = $tmpl->createElement( 'include', { name => $path } );
    $related->appendChild($include);

    # Content Type Selector
    my @content_types
        = MT->model('content_type')->load( { blog_id => $blog_id } );

    my @ct_selects = ();
    my $ct_data    = {};
    my $cf_selects = {};
    my $cf_data    = {};
    foreach my $ct (@content_types) {

        # Content Type
        push @ct_selects,
            {
            id       => $ct->id,
            label    => $ct->name,
            selected => ( $ct_id && $ct_id == $ct->id ? 1 : 0 )
            };
        $ct_data->{ $ct->id } = {
            id        => $ct->id,
            label     => $ct->name,
            unique_id => $ct->unique_id,
        };

        # Content Field
        my $fields = $ct->fields;
        my @cfs    = MT::ContentField->load(
            { content_type_id => $ct->id, type => { not => 'text_label' } } );
        foreach my $cf (@cfs) {
            my ($field) = grep { $_->{id} == $cf->id } @{$fields};
            my $label = $field->{options}{label};
            push @{ $cf_selects->{ $ct->id } }, { id => $cf->id, label => $cf->name };
            my $content_field_types = $app->registry('content_field_types');
            my $type_label          = $content_field_types->{ $cf->type }->{label};
            $type_label = $type_label->()
                if 'CODE' eq ref $type_label;
            $cf_data->{ $cf->id } = {
                id        => $cf->id,
                label     => $label,
                unique_id => $cf->unique_id,
                type      => $type_label,
            };
        }
    }
    $param->{ct_selects} = \@ct_selects;
    $param->{ct_data}    = MT::Util::to_json($ct_data);
    $param->{cf_selects} = MT::Util::to_json($cf_selects);
    $param->{cf_data}    = MT::Util::to_json($cf_data);
}

1;
