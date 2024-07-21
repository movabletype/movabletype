package CopyThisContentData::Transformer;
use strict;
use warnings;

use JSON ();

use MT;
use MT::ContentStatus;

my %Skip_cols = map { $_ => 1 } qw(
    created_on
    created_by
    modified_on
    modified_by
    authored_on
    author_id
    unpublished_on
    meta
    current_revision
    id
    identifier
    unique_id
    revision
);

sub template_param_edit_content_data {
    my ( $cb, $app, $param, $tmpl ) = @_;
    my $plugin = _get_plugin();

    # Do nothing for new content data.
    return unless $app->param('id') || $app->param('origin');

    # If this request has origin parameter, remove ID from param;
    if ( my $orig_id = $app->param('origin') ) {
        _set_params( $app, $param, $orig_id );

       # Copied content data does not need CopyThisContentData widget. Finish.
        return;
    }

    # Make a new widget
    my $widget = $tmpl->createElement(
        'app:widget',
        {   id    => 'copy-this-content-data-widget',
            label => $plugin->translate('Copy This Content Data'),
        }
    );

    $widget->appendChild(
        $tmpl->createTextNode(
            '<div style="margin-left: auto; margin-right: auto;"><button type="button" id="copy-this-content-data" name="copy-this-content-data" class="action button btn btn-default" style="width: 100%;">'
                . $plugin->translate('Copy This Content Data')
                . '</button></div>'
        )
    );

    # Insert new widget
    $tmpl->insertBefore( $widget,
        $tmpl->getElementById('entry-publishing-widget') );

    # Support Script
    my $id = $app->param('id');
    my $content_type_id = $app->param('content_type_id');
    my $blog_id = $app->blog->id;
    $param->{jq_js_include} ||= '';
    $param->{jq_js_include} .= <<SCRIPT;
    jQuery('#copy-this-content-data').on('click', function() {
        window.changed = false;
        window.location.href = ScriptURI + '?__mode=copy_this_content_data'
                                        + '&_type=content_data'
                                        + '&type=content_data_${content_type_id}'
                                        + '&content_type_id=${content_type_id}'
                                        + '&blog_id=${blog_id}'
                                        + '&origin=${id}';
    });
SCRIPT
}

sub _set_params {
    my ( $app, $param, $orig_id ) = @_;
    my $content_data_class = $app->model('content_data');
    my $origin             = $content_data_class->load($orig_id) or return;

    unless ( $app->user->permissions( $origin->blog_id )
        ->can_edit_content_data( $origin, $app->user ) )
    {
        $app->param( 'serialized_data', undef );
        return;
    }

    my $cols = $content_data_class->column_names;
    my @meta_cols = map { $_->{name} } MT::Meta->metadata_by_class( $content_data_class );
    for my $col (@$cols, @meta_cols) {
        next if $Skip_cols{$col};
        $param->{$col} = $origin->$col;
    }

    # Change status
    $param->{new_object} = 1;
    $param->{status}     = MT::ContentStatus::HOLD();
    delete $param->{"status_publish"};
    delete $param->{"status_review"};
    delete $param->{"status_spam"};
    delete $param->{"status_future"};
    delete $param->{"status_unpublish"};
    $param->{"status_draft"} = 1;

    # data_label
    my $plugin       = _get_plugin();
    my $content_type = $origin->content_type;
    if ( $content_type->data_label ) {
        $param->{can_edit_data_label} = 0;
        my ($label_field)
            = grep { $_->{unique_id} eq $content_type->data_label }
            @{ $param->{fields} || [] };
        if ($label_field) {
            $label_field->{value} = '' unless defined $label_field->{value};
            $label_field->{value}
                = $plugin->translate( 'Copy of [_1]', $label_field->{value} );
        }
    }
    else {
        $param->{can_edit_data_label} = 1;
        $param->{data_label}
            = $plugin->translate( 'Copy of [_1]',
            $app->param('data_label') || $origin->label );
    }
}

sub _get_plugin {
    MT->component('CopyThisContentData');
}

1;

