# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::ContentFieldType;
use strict;
use warnings;

sub core_content_field_types {
    {   content_type     => _content_type_registry(),
        single_line_text => _single_line_text_registry(),
        multi_line_text  => _multi_line_text_registry(),
        number           => _number_registry(),
        url              => _url_registry(),
        date_and_time    => _date_time_registry(),
        date_only        => _date_registry(),
        time_only        => _time_registry(),
        select_box       => _select_box_registry(),
        radio_button     => _radio_button_registry(),
        checkboxes       => _checkboxes_registry(),
        asset            => _asset_registry(),
        asset_audio      => _audio_registry(),
        asset_video      => _video_registry(),
        asset_image      => _image_registry(),
        embedded_text    => _embedded_text_registry(),
        categories       => _categories_registry(),
        tags             => _tags_registry(),
        list             => _list_registry(),
        tables           => _table_registry(),
        text_label       => _text_label_registry(),
    };
}

sub _content_type_registry {
    {   label                => 'Content Type',
        data_type            => 'integer',
        order                => 10,
        icon_class           => 'ic_contentstype',
        can_data_label_field => 0,
        data_load_handler =>
            '$Core::MT::ContentFieldType::Common::data_load_handler_multiple',
        field_html => 'field_html/field_html_content_type.tmpl',
        field_html_params =>
            '$Core::MT::ContentFieldType::ContentType::field_html_params',
        field_type_validation_handler =>
            '$Core::MT::ContentFieldType::ContentType::field_type_validation_handler',
        field_value_handler =>
            '$Core::MT::ContentFieldType::ContentType::field_value_handler',
        ss_validator =>
            '$Core::MT::ContentFieldType::ContentType::ss_validator',
        tag_handler =>
            '$Core::MT::ContentFieldType::ContentType::tag_handler',
        feed_value_handler =>
            '$Core::MT::ContentFieldType::ContentType::feed_value_handler',
        preview_handler =>
            '$Core::MT::ContentFieldType::ContentType::preview_handler',
        search_handler =>
            '$Core::MT::ContentFieldType::ContentType::search_handler',
        site_data_import_handler =>
            '$Core::MT::ContentFieldType::ContentType::site_data_import_handler',
        site_import_handler =>
            '$Core::MT::ContentFieldType::ContentType::site_import_handler',
        theme_import_handler =>
            '$Core::MT::ContentFieldType::ContentType::theme_import_handler',
        theme_export_handler =>
            '$Core::MT::ContentFieldType::ContentType::theme_export_handler',
        list_props => {
            content_type =>
                { html => '$Core::MT::ContentFieldType::ContentType::html' },
            id => {
                base    => '__virtual.integer',
                col     => 'value_integer',
                display => 'none',
                terms => '$Core::MT::ContentFieldType::ContentType::terms_id',
            },
        },
        options_validation_handler =>
            '$Core::MT::ContentFieldType::ContentType::options_validation_handler',
        options_pre_save_handler =>
            '$Core::MT::ContentFieldType::ContentType::options_pre_save_handler',
        options_html => 'content_field_type_options/content_type.tmpl',
        options_html_params =>
            '$Core::MT::ContentFieldType::ContentType::options_html_params',
        options => [
            qw(
                label
                description
                required
                display
                multiple
                max
                min
                source
                )
        ],
    };
}

sub _single_line_text_registry {
    {   label                => 'Single Line Text',
        data_type            => 'varchar',
        order                => 20,
        icon_class           => 'ic_singleline',
        can_data_label_field => 1,
        field_html           => 'field_html/field_html_single_line_text.tmpl',
        field_html_params =>
            '$Core::MT::ContentFieldType::SingleLineText::field_html_params',
        field_value_handler =>
            '$Core::MT::ContentFieldType::SingleLineText::field_value_handler',
        replaceable => 1,
        ss_validator =>
            '$core::MT::ContentFieldType::SingleLineText::ss_validator',
        list_props => {
            single_line_text => {
                base  => '__virtual.string',
                col   => 'value_varchar',
                terms => '$Core::MT::ContentFieldType::Common::terms_text',
                use_blank => 1,
            },
        },
        options_validation_handler =>
            '$Core::MT::ContentFieldType::SingleLineText::options_validation_handler',
        options_html => 'content_field_type_options/single_line_text.tmpl',
        options      => [
            qw(
                label
                description
                required
                display
                min_length
                max_length
                initial_value
                )
        ],
    };
}

sub _multi_line_text_registry {
    {   label                => 'Multi Line Text',
        data_type            => 'text',
        order                => 30,
        icon_class           => 'ic_multiline',
        can_data_label_field => 0,
        field_html           => 'field_html/field_html_multi_line_text.tmpl',
        field_html_params =>
            '$Core::MT::ContentFieldType::MultiLineText::field_html_params',
        data_load_handler =>
            '$Core::MT::ContentFieldType::MultiLineText::data_load_handler',
        field_value_handler =>
            '$Core::MT::ContentFieldType::MultiLineText::field_value_handler',
        replaceable => 1,
        list_props  => {
            multi_line_text => {
                base  => '__virtual.string',
                col   => 'value_text',
                html  => '$Core::MT::ContentFieldType::Common::html_text',
                terms => '$Core::MT::ContentFieldType::Common::terms_text',
                use_blank => 1,
            },
        },
        theme_data_import_handler =>
            '$Core::MT::ContentFieldType::MultiLineText::theme_data_import_handler',
        options_html => 'content_field_type_options/multi_line_text.tmpl',
        options_html_params =>
            '$Core::MT::ContentFieldType::MultiLineText::options_html_params',
        options => [
            qw(
                label
                description
                required
                display
                initial_value
                input_format
                )
        ],
    };
}

sub _number_registry {
    {   label                => 'Number',
        data_type            => 'double',
        order                => 40,
        can_data_label_field => 0,
        field_html           => 'field_html/field_html_number.tmpl',
        field_html_params =>
            '$Core::MT::ContentFieldType::Number::field_html_params',
        replaceable  => 1,
        ss_validator => '$Core::MT::ContentFieldType::Number::ss_validator',
        list_props   => {
            number => {
                base  => '__virtual.double',
                col   => 'value_double',
                terms => '$Core::MT::ContentFieldType::Common::terms_text',
                use_blank  => 1,
                use_signed => 1,
            },
        },
        options_validation_handler =>
            '$Core::MT::ContentFieldType::Number::options_validation_handler',
        options_html => 'content_field_type_options/number.tmpl',
        options      => [
            qw(
                label
                description
                required
                display
                min_value
                max_value
                decimal_places
                initial_value
                )
        ],
    };
}

sub _url_registry {
    {   label                => 'URL',
        data_type            => 'text',
        order                => 50,
        can_data_label_field => 1,
        replaceable          => 1,
        field_html           => 'field_html/field_html_url.tmpl',
        ss_validator => '$Core::MT::ContentFieldType::URL::ss_validator',
        list_props   => {
            url => {
                base  => '__virtual.string',
                col   => 'value_text',
                terms => '$Core::MT::ContentFieldType::Common::terms_text',
                use_blank => 1,
            },
        },
        options_validation_handler =>
            '$Core::MT::ContentFieldType::URL::options_validation_handler',
        options_html => 'content_field_type_options/url.tmpl',
        options      => [
            qw(
                label
                description
                required
                display
                initial_value
                )
        ],
    };
}

sub _date_time_registry {
    {   label                => 'Date and Time',
        data_type            => 'datetime',
        order                => 60,
        can_data_label_field => 0,
        field_html           => 'field_html/field_html_datetime.tmpl',
        field_html_params =>
            '$Core::MT::ContentFieldType::DateTime::field_html_params',
        field_value_handler =>
            '$Core::MT::ContentFieldType::Common::field_value_handler_datetime',
        data_load_handler =>
            '$Core::MT::ContentFieldType::DateTime::data_load_handler',
        feed_value_handler =>
            '$Core::MT::ContentFieldType::DateTime::feed_value_handler',
        preview_handler =>
            '$Core::MT::ContentFieldType::DateTime::preview_handler',
        ss_validator =>
            '$Core::MT::ContentFieldType::Common::ss_validator_datetime',
        list_props => {
            date_and_time => {
                base => '__virtual.date',
                col  => 'value_datetime',
                html => '$Core::MT::ContentFieldType::DateTime::html',
                terms =>
                    '$Core::MT::ContentFieldType::Common::terms_datetime',
                use_blank  => 1,
                use_future => 1,
            },
        },
        options_validation_handler =>
            '$Core::MT::ContentFieldType::DateTime::options_validation_handler',
        options_pre_save_handler =>
            '$Core::MT::ContentFieldType::DateTime::options_pre_save_handler',
        options_pre_load_handler =>
            '$Core::MT::ContentFieldType::DateTime::options_pre_load_handler',
        options_html => 'content_field_type_options/date_time.tmpl',
        options      => [
            qw(
                label
                description
                required
                display
                initial_value
                )
        ],
    };
}

sub _date_registry {
    {   label                => 'Date',
        data_type            => 'datetime',
        order                => 70,
        icon_class           => 'ic_date',
        can_data_label_field => 0,
        field_html           => 'field_html/field_html_date.tmpl',
        field_html_params =>
            '$Core::MT::ContentFieldType::Date::field_html_params',
        field_value_handler =>
            '$Core::MT::ContentFieldType::Common::field_value_handler_datetime',
        data_load_handler =>
            '$Core::MT::ContentFieldType::Date::data_load_handler',
        feed_value_handler =>
            '$Core::MT::ContentFieldType::Date::feed_value_handler',
        preview_handler =>
            '$Core::MT::ContentFieldType::Date::preview_handler',
        ss_validator =>
            '$Core::MT::ContentFieldType::Common::ss_validator_datetime',
        list_props => {
            date_only => {
                base => '__virtual.date',
                col  => 'value_datetime',
                html => '$Core::MT::ContentFieldType::Date::html',
                terms =>
                    '$Core::MT::ContentFieldType::Common::terms_datetime',
                use_blank  => 1,
                use_future => 1,
            },
        },
        options_validation_handler =>
            '$Core::MT::ContentFieldType::Date::options_validation_handler',
        options_pre_save_handler =>
            '$Core::MT::ContentFieldType::Date::options_pre_save_handler',
        options_pre_load_handler =>
            '$Core::MT::ContentFieldType::Date::options_pre_load_handler',
        options_html => 'content_field_type_options/date.tmpl',
        options      => [
            qw(
                label
                description
                required
                display
                initial_value
                )
        ],
    };
}

sub _time_registry {
    {   label                => 'Time',
        data_type            => 'datetime',
        order                => 80,
        icon_class           => 'ic_time',
        can_data_label_field => 0,
        field_html           => 'field_html/field_html_time.tmpl',
        field_html_params =>
            '$Core::MT::ContentFieldType::Time::field_html_params',
        field_value_handler =>
            '$Core::MT::ContentFieldType::Common::field_value_handler_datetime',
        data_load_handler =>
            '$Core::MT::ContentFieldType::Time::data_load_handler',
        feed_value_handler =>
            '$Core::MT::ContentFieldType::Time::feed_value_handler',
        preview_handler =>
            '$Core::MT::ContentFieldType::Time::preview_handler',
        ss_validator =>
            '$Core::MT::ContentFieldType::Common::ss_validator_datetime',
        list_props => {
            time_only => {
                filter_tmpl =>
                    '$Core::MT::ContentFieldType::Time::filter_tmpl',
                html      => '$Core::MT::ContentFieldType::Time::html',
                terms     => '$Core::MT::ContentFieldType::Time::terms',
                use_blank => 1,
            },
        },
        options_validation_handler =>
            '$Core::MT::ContentFieldType::Time::options_validation_handler',
        options_pre_save_handler =>
            '$Core::MT::ContentFieldType::Date::options_pre_save_handler',
        options_pre_load_handler =>
            '$Core::MT::ContentFieldType::Time::options_pre_load_handler',
        options_html => 'content_field_type_options/time.tmpl',
        options      => [
            qw(
                label
                description
                required
                display
                initial_value
                )
        ],
    };
}

sub _select_box_registry {
    {   label                => 'Select Box',
        data_type            => 'varchar',
        order                => 90,
        icon_class           => 'ic_selectbox',
        can_data_label_field => 0,
        data_load_handler =>
            '$Core::MT::ContentFieldType::Common::data_load_handler_multiple',
        field_html => 'field_html/field_html_select_box.tmpl',
        field_html_params =>
            '$Core::MT::ContentFieldType::SelectBox::field_html_params',
        ss_validator =>
            '$Core::MT::ContentFieldType::SelectBox::ss_validator_multiple',
        tag_handler =>
            '$Core::MT::ContentFieldType::Common::tag_handler_multiple',
        feed_value_handler =>
            '$Core::MT::ContentFieldType::Common::feed_value_handler_multiple',
        preview_handler =>
            '$Core::MT::ContentFieldType::Common::preview_handler_multiple',
        search_handler =>
            '$Core::MT::ContentFieldType::Common::search_handler_multiple',
        list_props => {
            select_box => {
                filter_tmpl =>
                    '$Core::MT::ContentFieldType::Common::filter_tmpl_multiple',
                html => '$Core::MT::ContentFieldType::Common::html_multiple',
                single_select_options =>
                    '$Core::MT::ContentFieldType::Common::single_select_options_multiple',
                terms =>
                    '$Core::MT::ContentFieldType::Common::terms_multiple',
            },
        },
        options_validation_handler =>
            '$Core::MT::ContentFieldType::SelectBox::options_validation_handler',
        options_html => 'content_field_type_options/select_box.tmpl',
        options      => [
            qw(
                label
                description
                required
                display
                multiple
                max
                min
                values
                initial_value
                )
        ],
    };
}

sub _radio_button_registry {
    {   label                => 'Radio Button',
        data_type            => 'varchar',
        order                => 100,
        icon_class           => 'ic_radio',
        can_data_label_field => 0,
        field_html           => 'field_html/field_html_radio_button.tmpl',
        field_html_params =>
            '$Core::MT::ContentFieldType::RadioButton::field_html_params',
        ss_validator =>
            '$Core::MT::ContentFieldType::Common::ss_validator_values',
        tag_handler =>
            '$Core::MT::ContentFieldType::Common::tag_handler_multiple',
        feed_value_handler =>
            '$Core::MT::ContentFieldType::Common::feed_value_handler_multiple',
        preview_handler =>
            '$Core::MT::ContentFieldType::Common::preview_handler_multiple',
        search_handler =>
            '$Core::MT::ContentFieldType::Common::search_handler_multiple',
        list_props => {
            radio_button => {
                filter_tmpl =>
                    '$Core::MT::ContentFieldType::Common::filter_tmpl_multiple',
                html => '$Core::MT::ContentFieldType::Common::html_multiple',
                single_select_options =>
                    '$Core::MT::ContentFieldType::Common::single_select_options_multiple',
                terms =>
                    '$Core::MT::ContentFieldType::Common::terms_multiple',
            },
        },
        options_validation_handler =>
            '$Core::MT::ContentFieldType::RadioButton::options_validation_handler',
        options_html => 'content_field_type_options/radio_button.tmpl',
        options      => [
            qw(
                label
                description
                required
                display
                values
                initial_value
                )
        ],
    };
}

sub _checkboxes_registry {
    {   label                => 'Checkboxes',
        data_type            => 'varchar',
        order                => 110,
        icon_class           => 'ic_checkbox',
        can_data_label_field => 0,
        data_load_handler =>
            '$Core::MT::ContentFieldType::Common::data_load_handler_multiple',
        field_html => 'field_html/field_html_checkboxes.tmpl',
        field_html_params =>
            '$Core::MT::ContentFieldType::Checkboxes::field_html_params',
        ss_validator =>
            '$Core::MT::ContentFieldType::Common::ss_validator_multiple',
        tag_handler =>
            '$Core::MT::ContentFieldType::Common::tag_handler_multiple',
        feed_value_handler =>
            '$Core::MT::ContentFieldType::Common::feed_value_handler_multiple',
        preview_handler =>
            '$Core::MT::ContentFieldType::Common::preview_handler_multiple',
        search_handler =>
            '$Core::MT::ContentFieldType::Common::search_handler_multiple',
        list_props => {
            checkboxes => {
                filter_tmpl =>
                    '$Core::MT::ContentFieldType::Common::filter_tmpl_multiple',
                html => '$Core::MT::ContentFieldType::Common::html_multiple',
                single_select_options =>
                    '$Core::MT::ContentFieldType::Common::single_select_options_multiple',
                terms =>
                    '$Core::MT::ContentFieldType::Common::terms_multiple',
            },
        },
        options_validation_handler =>
            '$Core::MT::ContentFieldType::Checkboxes::options_validation_handler',
        options_pre_save_handler =>
            '$Core::MT::ContentFieldType::Checkboxes::options_pre_save_handler',
        options_html => 'content_field_type_options/checkboxes.tmpl',
        options      => [
            qw(
                label
                description
                required
                display
                multiple
                max
                min
                values
                initial_value
                )
        ],
    };
}

sub _asset_registry {
    {   label                => 'Asset',
        data_type            => 'integer',
        order                => 120,
        icon_class           => 'ic_asset',
        can_data_label_field => 0,
        data_load_handler =>
            '$Core::MT::ContentFieldType::Common::data_load_handler_asset',
        field_html => 'field_html/field_html_asset.tmpl',
        field_html_params =>
            '$Core::MT::ContentFieldType::Asset::field_html_params',
        field_value_handler =>
            '$Core::MT::ContentFieldType::Asset::field_value_handler',
        ss_validator => '$Core::MT::ContentFieldType::Asset::ss_validator',
        tag_handler =>
            '$Core::MT::ContentFieldType::Common::tag_handler_asset',
        feed_value_handler =>
            '$Core::MT::ContentFieldType::Asset::feed_value_handler',
        preview_handler =>
            '$Core::MT::ContentFieldType::Asset::preview_handler',
        search_class   => 'asset',
        search_columns => [qw( description file_name label )],
        search_handler =>
            '$Core::MT::ContentFieldType::Common::search_handler_reference',
        site_data_import_handler =>
            '$Core::MT::ContentFieldType::Asset::site_data_import_handler',
        list_props => {
            asset => {
                filter_tmpl =>
                    '$Core::MT::ContentFieldType::Common::filter_tmpl_multiple',
                html => '$Core::MT::ContentFieldType::Asset::html',
                single_select_options =>
                    '$Core::MT::ContentFieldType::Asset::single_select_options',
                terms =>
                    '$Core::MT::ContentFieldType::Common::terms_multiple',
            },
            author_name => {
                base    => '__virtual.author_name',
                display => 'none',
                terms =>
                    '$Core::MT::ContentFieldType::Asset::terms_author_name',
            },
            author_status => {
                base    => 'author.status',
                display => 'none',
                terms =>
                    '$Core::MT::ContentFieldType::Asset::terms_author_status',
            },
            date_created => {
                base    => '__virtual.date',
                col     => 'created_on',
                display => 'none',
                terms   => '$Core::MT::ContentFieldType::Asset::terms_date',
            },
            date_modified => {
                base    => '__virtual.date',
                col     => 'modified_on',
                display => 'none',
                terms   => '$Core::MT::ContentFieldType::Asset::terms_date',
            },
            description => {
                base      => '__virtual.string',
                col       => 'description',
                display   => 'none',
                terms     => '$Core::MT::ContentFieldType::Asset::terms_text',
                use_blank => 1,
            },
            file_extension => {
                base    => '__virtual.string',
                col     => 'file_ext',
                display => 'none',
                terms   => '$Core::MT::ContentFieldType::Asset::terms_text',
            },
            filename => {
                base    => '__virtual.string',
                col     => 'file_name',
                display => 'none',
                terms   => '$Core::MT::ContentFieldType::Asset::terms_text',
            },
            id => {
                base    => '__virtual.integer',
                col     => 'value_integer',
                display => 'none',
                terms   => '$Core::MT::ContentFieldType::Asset::terms_id',
            },
            label => {
                base    => '__virtual.string',
                col     => 'label',
                display => 'none',
                terms   => '$Core::MT::ContentFieldType::Asset::terms_text',
            },
            tag => {
                base      => '__virtual.string',
                col       => 'name',
                display   => 'none',
                terms     => '$Core::MT::ContentFieldType::Asset::terms_tag',
                use_blank => 1,
            },
        },
        options_validation_handler =>
            '$Core::MT::ContentFieldType::Asset::options_validation_handler',
        options_html => 'content_field_type_options/asset.tmpl',
        options      => [
            qw(
                label
                description
                required
                display
                multiple
                allow_upload
                max
                min
                )
        ],
    };
}

sub _audio_registry {
    {   label                => 'Audio Asset',
        data_type            => 'integer',
        order                => 130,
        icon_class           => 'ic_audio',
        can_data_label_field => 0,
        data_load_handler =>
            '$Core::MT::ContentFieldType::Common::data_load_handler_asset',
        field_html => 'field_html/field_html_asset.tmpl',
        field_html_params =>
            '$Core::MT::ContentFieldType::Asset::field_html_params',
        field_value_handler =>
            '$Core::MT::ContentFieldType::Asset::field_value_handler',
        ss_validator => '$Core::MT::ContentFieldType::Asset::ss_validator',
        tag_handler =>
            '$Core::MT::ContentFieldType::Common::tag_handler_asset',
        feed_value_handler =>
            '$Core::MT::ContentFieldType::Asset::feed_value_handler',
        preview_handler =>
            '$Core::MT::ContentFieldType::Asset::preview_handler',
        search_class   => 'asset',
        search_columns => [qw( description file_name label )],
        search_handler =>
            '$Core::MT::ContentFieldType::Common::search_handler_reference',
        site_data_import_handler =>
            '$Core::MT::ContentFieldType::Asset::site_data_import_handler',
        list_props => {
            asset_audio => {
                filter_tmpl =>
                    '$Core::MT::ContentFieldType::Common::filter_tmpl_multiple',
                html => '$Core::MT::ContentFieldType::Asset::html',
                single_select_options =>
                    '$Core::MT::ContentFieldType::Asset::single_select_options',
                terms =>
                    '$Core::MT::ContentFieldType::Common::terms_multiple',
            },
            author_name => {
                base    => '__virtual.author_name',
                display => 'none',
                terms =>
                    '$Core::MT::ContentFieldType::Asset::terms_author_name',
            },
            author_status => {
                base    => 'author.status',
                display => 'none',
                terms =>
                    '$Core::MT::ContentFieldType::Asset::terms_author_status',
            },
            date_created => {
                base    => '__virtual.date',
                col     => 'created_on',
                display => 'none',
                terms   => '$Core::MT::ContentFieldType::Asset::terms_date',
            },
            date_modified => {
                base    => '__virtual.date',
                col     => 'modified_on',
                display => 'none',
                terms   => '$Core::MT::ContentFieldType::Asset::terms_date',
            },
            description => {
                base      => '__virtual.string',
                col       => 'description',
                display   => 'none',
                terms     => '$Core::MT::ContentFieldType::Asset::terms_text',
                use_blank => 1,
            },
            file_extension => {
                base    => '__virtual.string',
                col     => 'file_ext',
                display => 'none',
                terms   => '$Core::MT::ContentFieldType::Asset::terms_text',
            },
            filename => {
                base    => '__virtual.string',
                col     => 'file_name',
                display => 'none',
            },
            id => {
                base    => '__virtual.integer',
                col     => 'value_integer',
                display => 'none',
                terms   => '$Core::MT::ContentFieldType::Asset::terms_id',
            },
            label => {
                base    => '__virtual.string',
                col     => 'label',
                display => 'none',
                terms   => '$Core::MT::ContentFieldType::Asset::terms_text',
            },
            tag => {
                base      => '__virtual.string',
                col       => 'name',
                display   => 'none',
                terms     => '$Core::MT::ContentFieldType::Asset::terms_tag',
                use_blank => 1,
            },
        },
        options_validation_handler =>
            '$Core::MT::ContentFieldType::Asset::options_validation_handler',
        options_html => 'content_field_type_options/asset_audio.tmpl',
        options      => [
            qw(
                label
                description
                required
                display
                multiple
                allow_upload
                max
                min
                )
        ],
    };
}

sub _video_registry {
    {   label                => 'Video Asset',
        data_type            => 'integer',
        order                => 140,
        can_data_label_field => 0,
        data_load_handler =>
            '$Core::MT::ContentFieldType::Common::data_load_handler_asset',
        field_html => 'field_html/field_html_asset.tmpl',
        field_html_params =>
            '$Core::MT::ContentFieldType::Asset::field_html_params',
        field_value_handler =>
            '$Core::MT::ContentFieldType::Asset::field_value_handler',
        ss_validator => '$Core::MT::ContentFieldType::Asset::ss_validator',
        tag_handler =>
            '$Core::MT::ContentFieldType::Common::tag_handler_asset',
        feed_value_handler =>
            '$Core::MT::ContentFieldType::Asset::feed_value_handler',
        preview_handler =>
            '$Core::MT::ContentFieldType::Asset::preview_handler',
        search_class   => 'asset',
        search_columns => [qw( description file_name label )],
        search_handler =>
            '$Core::MT::ContentFieldType::Common::search_handler_reference',
        site_data_import_handler =>
            '$Core::MT::ContentFieldType::Asset::site_data_import_handler',
        list_props => {
            asset_video => {
                filter_tmpl =>
                    '$Core::MT::ContentFieldType::Common::filter_tmpl_multiple',
                html => '$Core::MT::ContentFieldType::Asset::html',
                single_select_options =>
                    '$Core::MT::ContentFieldType::Asset::single_select_options',
                terms =>
                    '$Core::MT::ContentFieldType::Common::terms_multiple',
            },
            author_name => {
                base    => '__virtual.author_name',
                display => 'none',
                terms =>
                    '$Core::MT::ContentFieldType::Asset::terms_author_name',
            },
            author_status => {
                base    => 'author.status',
                display => 'none',
                terms =>
                    '$Core::MT::ContentFieldType::Asset::terms_author_status',
            },
            date_created => {
                base    => '__virtual.date',
                col     => 'created_on',
                display => 'none',
                terms   => '$Core::MT::ContentFieldType::Asset::terms_date',
            },
            date_modified => {
                base    => '__virtual.date',
                col     => 'modified_on',
                display => 'none',
                terms   => '$Core::MT::ContentFieldType::Asset::terms_date',
            },
            description => {
                base      => '__virtual.string',
                col       => 'description',
                display   => 'none',
                terms     => '$Core::MT::ContentFieldType::Asset::terms_text',
                use_blank => 1,
            },
            file_extension => {
                base    => '__virtual.string',
                col     => 'file_ext',
                display => 'none',
                terms   => '$Core::MT::ContentFieldType::Asset::terms_text',
            },
            filename => {
                base    => '__virtual.string',
                col     => 'file_name',
                display => 'none',
            },
            id => {
                base    => '__virtual.integer',
                col     => 'value_integer',
                display => 'none',
                terms   => '$Core::MT::ContentFieldType::Asset::terms_id',
            },
            label => {
                base    => '__virtual.string',
                col     => 'label',
                display => 'none',
                terms   => '$Core::MT::ContentFieldType::Asset::terms_text',
            },
            tag => {
                base      => '__virtual.string',
                col       => 'name',
                display   => 'none',
                terms     => '$Core::MT::ContentFieldType::Asset::terms_tag',
                use_blank => 1,
            },
        },
        options_validation_handler =>
            '$Core::MT::ContentFieldType::Asset::options_validation_handler',
        options_html => 'content_field_type_options/asset_video.tmpl',
        options      => [
            qw(
                label
                description
                required
                display
                multiple
                allow_upload
                max
                min
                )
        ],
    };
}

sub _image_registry {
    {   label                => 'Image Asset',
        data_type            => 'integer',
        order                => 150,
        icon_class           => 'ic_image',
        can_data_label_field => 0,
        data_load_handler =>
            '$Core::MT::ContentFieldType::Common::data_load_handler_asset',
        field_html => 'field_html/field_html_asset.tmpl',
        field_html_params =>
            '$Core::MT::ContentFieldType::Asset::field_html_params',
        field_value_handler =>
            '$Core::MT::ContentFieldType::Asset::field_value_handler',
        ss_validator => '$Core::MT::ContentFieldType::Asset::ss_validator',
        tag_handler =>
            '$Core::MT::ContentFieldType::Common::tag_handler_asset',
        feed_value_handler =>
            '$Core::MT::ContentFieldType::Asset::feed_value_handler',
        preview_handler =>
            '$Core::MT::ContentFieldType::Asset::preview_handler',
        search_class   => 'asset',
        search_columns => [qw( description file_name label )],
        search_handler =>
            '$Core::MT::ContentFieldType::Common::search_handler_reference',
        site_data_import_handler =>
            '$Core::MT::ContentFieldType::Asset::site_data_import_handler',
        list_props => {
            asset_image => {
                filter_tmpl =>
                    '$Core::MT::ContentFieldType::Common::filter_tmpl_multiple',
                html => '$Core::MT::ContentFieldType::Asset::html',
                single_select_options =>
                    '$Core::MT::ContentFieldType::Asset::single_select_options',
                terms =>
                    '$Core::MT::ContentFieldType::Common::terms_multiple',
            },
            author_name => {
                base    => '__virtual.author_name',
                display => 'none',
                terms =>
                    '$Core::MT::ContentFieldType::Asset::terms_author_name',
            },
            author_status => {
                base    => 'author.status',
                display => 'none',
                terms =>
                    '$Core::MT::ContentFieldType::Asset::terms_author_status',
            },
            date_created => {
                base    => '__virtual.date',
                col     => 'created_on',
                display => 'none',
                terms   => '$Core::MT::ContentFieldType::Asset::terms_date',
            },
            date_modified => {
                base    => '__virtual.date',
                col     => 'modified_on',
                display => 'none',
                terms   => '$Core::MT::ContentFieldType::Asset::terms_date',
            },
            description => {
                base      => '__virtual.string',
                col       => 'description',
                display   => 'none',
                terms     => '$Core::MT::ContentFieldType::Asset::terms_text',
                use_blank => 1,
            },
            file_extension => {
                base    => '__virtual.string',
                col     => 'file_ext',
                display => 'none',
                terms   => '$Core::MT::ContentFieldType::Asset::terms_text',
            },
            filename => {
                base    => '__virtual.string',
                col     => 'file_name',
                display => 'none',
            },
            id => {
                base    => '__virtual.integer',
                col     => 'value_integer',
                display => 'none',
                terms   => '$Core::MT::ContentFieldType::Asset::terms_id',
            },
            label => {
                base    => '__virtual.string',
                col     => 'label',
                display => 'none',
                terms   => '$Core::MT::ContentFieldType::Asset::terms_text',
            },
            pixel_height => {
                base    => 'asset.image_height',
                display => 'none',
                terms =>
                    '$Core::MT::ContentFieldType::Asset::terms_image_size',
            },
            pixel_width => {
                base    => 'asset.image_width',
                display => 'none',
                terms =>
                    '$Core::MT::ContentFieldType::Asset::terms_image_size',
            },
            tag => {
                base      => '__virtual.string',
                col       => 'name',
                display   => 'none',
                terms     => '$Core::MT::ContentFieldType::Asset::terms_tag',
                use_blank => 1,
            },
        },
        options_validation_handler =>
            '$Core::MT::ContentFieldType::Asset::options_validation_handler',
        options_html => 'content_field_type_options/asset_image.tmpl',
        options      => [
            qw(
                label
                description
                required
                display
                multiple
                allow_upload
                max
                min
                )
        ],
    };
}

sub _embedded_text_registry {
    {   label                => 'Embedded Text',
        data_type            => 'text',
        order                => 160,
        can_data_label_field => 0,
        replaceable          => 1,
        list_props           => {
            embedded_text => {
                base  => '__virtual.string',
                col   => 'value_text',
                html  => '$Core::MT::ContentFieldType::Common::html_text',
                terms => '$Core::MT::ContentFieldType::Common::terms_text',
                use_blank => 1,
            },
        },
        options_html => 'content_field_type_options/embedded_text.tmpl',
        options      => [
            qw(
                label
                description
                required
                display
                initial_value
                )
        ],
    };
}

sub _categories_registry {
    {   label                => 'Categories',
        data_type            => 'integer',
        order                => 170,
        icon_class           => 'ic_category',
        can_data_label_field => 0,
        data_load_handler =>
            '$Core::MT::ContentFieldType::Categories::data_load_handler',
        field_html => 'field_html/field_html_categories.tmpl',
        field_html_params =>
            '$Core::MT::ContentFieldType::Categories::field_html_params',
        field_type_validation_handler =>
            '$Core::MT::ContentFieldType::Categories::field_type_validation_handler',
        field_value_handler =>
            '$Core::MT::ContentFieldType::Categories::field_value_handler',
        ss_validator =>
            '$Core::MT::ContentFieldType::Categories::ss_validator',
        tag_handler => '$Core::MT::ContentFieldType::Categories::tag_handler',
        feed_value_handler =>
            '$Core::MT::ContentFieldType::Categories::feed_value_handler',
        preview_handler =>
            '$Core::MT::ContentFieldType::Categories::preview_handler',
        search_class   => 'category',
        search_columns => [qw( basename description label )],
        search_handler =>
            '$Core::MT::ContentFieldType::Common::search_handler_reference',
        site_data_import_handler =>
            '$Core::MT::ContentFieldType::Categories::site_data_import_handler',
        site_import_handler =>
            '$Core::MT::ContentFieldType::Categories::site_import_handler',
        theme_import_handler =>
            '$Core::MT::ContentFieldType::Categories::theme_import_handler',
        theme_export_handler =>
            '$Core::MT::ContentFieldType::Categories::theme_export_handler',
        list_props => {
            categories => {
                base      => '__virtual.string',
                col       => 'label',
                html      => '$Core::MT::ContentFieldType::Categories::html',
                terms     => '$Core::MT::ContentFieldType::Categories::terms',
                use_blank => 1,
            },
        },
        options_validation_handler =>
            '$Core::MT::ContentFieldType::Categories::options_validation_handler',
        options_pre_save_handler =>
            '$Core::MT::ContentFieldType::Categories::options_pre_save_handler',
        options_html => 'content_field_type_options/categories.tmpl',
        options_html_params =>
            '$Core::MT::ContentFieldType::Categories::options_html_params',
        options => [
            qw(
                label
                description
                required
                display
                multiple
                can_add
                max
                min
                category_set
                )
        ],
    };
}

sub _tags_registry {
    {   label                => 'Tags',
        data_type            => 'integer',
        order                => 180,
        icon_class           => 'ic_tag',
        can_data_label_field => 0,
        data_load_handler =>
            '$Core::MT::ContentFieldType::Tags::data_load_handler',
        field_html => 'field_html/field_html_tags.tmpl',
        field_html_params =>
            '$Core::MT::ContentFieldType::Tags::field_html_params',
        field_value_handler =>
            '$Core::MT::ContentFieldType::Tags::field_value_handler',
        feed_value_handler =>
            '$Core::MT::ContentFieldType::Tags::feed_value_handler',
        preview_handler =>
            '$Core::MT::ContentFieldType::Tags::preview_handler',
        search_class   => 'tag',
        search_columns => [qw( name )],
        search_handler =>
            '$Core::MT::ContentFieldType::Common::search_handler_reference',
        site_data_import_handler =>
            '$Core::MT::ContentFieldType::Tags::site_data_import_handler',
        ss_validator => '$Core::MT::ContentFieldType::Tags::ss_validator',
        tag_handler  => '$Core::MT::ContentFieldType::Tags::tag_handler',
        list_props   => {
            tags => {
                base      => '__virtual.string',
                col       => 'name',
                html      => '$Core::MT::ContentFieldType::Tags::html',
                terms     => '$Core::MT::ContentFieldType::Tags::terms',
                use_blank => 1,
            },
        },
        options_validation_handler =>
            '$Core::MT::ContentFieldType::Tags::options_validation_handler',
        options_html => 'content_field_type_options/tags.tmpl',
        options      => [
            qw(
                label
                description
                required
                display
                multiple
                can_add
                max
                min
                initial_value
                )
        ],
    };
}

sub _list_registry {
    {   label                => '__LIST_FIELD_LABEL',
        data_type            => 'varchar',
        order                => 190,
        icon_class           => 'ic_list',
        can_data_label_field => 0,
        data_load_handler =>
            '$Core::MT::ContentFieldType::Common::data_load_handler_multiple',
        field_html => 'field_html/field_html_list.tmpl',
        field_html_params =>
            '$Core::MT::ContentFieldType::List::field_html_params',
        tag_handler => '$Core::MT::ContentFieldType::List::tag_handler',
        feed_value_handler =>
            '$Core::MT::ContentFieldType::List::feed_value_handler',
        preview_handler =>
            '$Core::MT::ContentFieldType::List::preview_handler',
        replace_handler =>
            '$Core::MT::ContentFieldType::List::replace_handler',
        search_handler => '$Core::MT::ContentFieldType::List::search_handler',
        list_props     => {
            list => {
                base            => '__virtual.string',
                col             => 'value_varchar',
                display         => 'none',
                filter_editable => 0,
                html            => '$Core::MT::ContentFieldType::List::html',
                terms           => '$Core::MT::ContentFieldType::List::terms',
            },
        },
        options_html => 'content_field_type_options/list.tmpl',
        options      => [
            qw(
                label
                description
                required
                display
                )
        ],
    };
}

sub _table_registry {
    {   label                => 'Table',
        data_type            => 'text',
        order                => 200,
        can_data_label_field => 0,
        data_load_handler =>
            '$Core::MT::ContentFieldType::Table::data_load_handler',
        field_html => 'field_html/field_html_table.tmpl',
        field_html_params =>
            '$Core::MT::ContentFieldType::Table::field_html_params',
        tag_handler => '$Core::MT::ContentFieldType::Table::tag_handler',
        feed_value_handler =>
            '$Core::MT::ContentFieldType::Table::feed_value_handler',
        preview_handler =>
            '$Core::MT::ContentFieldType::Table::preview_handler',

        # search_handler =>
        #     '$Core::MT::ContentFieldType::Table::search_handler',
        list_props => {
            tables => {
                base            => '__virtual.string',
                col             => 'value_text',
                display         => 'none',
                filter_editable => 0,
                html            => '$Core::MT::ContentFieldType::Table::html',
                terms => '$Core::MT::ContentFieldType::Common::terms_text',
            },
        },
        options_validation_handler =>
            '$Core::MT::ContentFieldType::Table::options_validation_handler',
        options_html => 'content_field_type_options/tables.tmpl',
        options      => [
            qw(
                label
                description
                display
                initial_rows
                increase_decrease_rows
                initial_cols
                increase_decrease_cols
                )
        ],
    };
}

sub _text_label_registry {
    {
        label                => 'Text Display Area',
        data_type            => 'text',
        order                => 210,
        can_data_label_field => 0,
        field_html           => 'field_html/field_html_text_label.tmpl',
        field_html_params =>
          '$Core::MT::ContentFieldType::TextLabel::field_html_params',
        tag_handler => '$Core::MT::ContentFieldType::TextLabel::tag_handler',
        feed_value_handler =>
          '$Core::MT::ContentFieldType::TextLabel::feed_value_handler',
        preview_handler =>
          '$Core::MT::ContentFieldType::TextLabel::preview_handler',
        options_html => 'content_field_type_options/text_label.tmpl',
        options      => [
            qw(
              label
              text
              )
        ],
    };
}

1;
