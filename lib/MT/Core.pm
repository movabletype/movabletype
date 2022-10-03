# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Core;

use strict;
use warnings;
use MT;
use base 'MT::Component';

# This is just to make our localization scanner happy
sub trans {
    return shift;
}

sub name {
    return "Core";
}

my $core_registry;

BEGIN {
    $core_registry = {
        version        => MT->VERSION,
        schema_version => MT->schema_version,
        object_drivers => {
            'mysql' => {
                label          => 'MySQL Database (Recommended)',
                dbd_package    => 'DBD::mysql',
                config_package => 'DBI::mysql',
                display        => [
                    'dbserver', 'dbname', 'dbuser', 'dbpass',
                    'dbport',   'dbsocket'
                ],
                recommended => 1,
            },
            'postgres' => {
                label          => 'PostgreSQL Database',
                dbd_package    => 'DBD::Pg',
                dbd_version    => '1.32',
                config_package => 'DBI::postgres',
                display =>
                    [ 'dbserver', 'dbname', 'dbuser', 'dbpass', 'dbport' ],
            },
            'sqlite' => {
                label          => 'SQLite Database',
                dbd_package    => 'DBD::SQLite',
                config_package => 'DBI::sqlite',
                display        => ['dbpath'],
            },
            'sqlite2' => {
                label          => 'SQLite Database (v2)',
                dbd_package    => 'DBD::SQLite2',
                config_package => 'DBI::sqlite',
                display        => ['dbpath'],
            },
        },
        db_form_data => {
            dbserver => {
                element => 'input',
                type    => 'text',
                label   => 'Database Server',
                default => 'localhost',
                hint    => sub {
                    MT->translate("This is often 'localhost'.");
                },
                show_hint => 1,
                order     => 10,
            },
            dbname => {
                element => 'input',
                type    => 'text',
                label   => 'Database Name',
                order   => 20,
            },
            dbuser => {
                element => 'input',
                type    => 'text',
                label   => 'Username',
                order   => 30,
            },
            dbpass => {
                element => 'input',
                type    => 'password',
                label   => 'Password',
                order   => 40,
            },
            dbpath => {
                element => 'input',
                type    => 'text',
                label   => 'Database Path',
                default => './db/mt.db',
                hint    => sub {
                    MT->translate(
                        "The physical file path for your SQLite database. ");
                },
                show_hint => 1,
                order     => 50,
            },
            dbport => {
                advanced => 1,
                element  => 'input',
                type     => 'text',
                label    => 'Database Port',
                order    => 10,
            },
            dbsocket => {
                advanced => 1,
                element  => 'input',
                type     => 'text',
                label    => 'Database Socket',
                order    => 20,
            },
        },
        object_types => {
            'entry'           => 'MT::Entry',
            'author'          => 'MT::Author',
            'asset'           => 'MT::Asset',
            'file'            => 'MT::Asset',
            'asset.file'      => 'MT::Asset',
            'asset.image'     => 'MT::Asset::Image',
            'image'           => 'MT::Asset::Image',
            'asset.audio'     => 'MT::Asset::Audio',
            'audio'           => 'MT::Asset::Audio',
            'asset.video'     => 'MT::Asset::Video',
            'video'           => 'MT::Asset::Video',
            'entry.page'      => 'MT::Page',
            'page'            => 'MT::Page',
            'category.folder' => 'MT::Folder',
            'folder'          => 'MT::Folder',
            'category'        => 'MT::Category',
            'user'            => 'MT::Author',
            'commenter'       => 'MT::Author',
            'blog'            => 'MT::Blog',
            'site'            => 'MT::Blog',
            'blog.website'    => 'MT::Website',
            'website'         => 'MT::Website',
            'template'        => 'MT::Template',
            'comment'         => 'MT::Comment',
            'notification'    => 'MT::Notification',
            'templatemap'     => 'MT::TemplateMap',
            'banlist'         => 'MT::IPBanList',
            'ipbanlist'       => 'MT::IPBanList',
            'tbping'          => 'MT::TBPing',
            'ping'            => 'MT::TBPing',
            'ping_cat'        => 'MT::TBPing',
            'log'             => 'MT::Log',
            'log.ping'        => 'MT::Log::TBPing',
            'log.entry'       => 'MT::Log::Entry',
            'log.comment'     => 'MT::Log::Comment',
            'log.system'      => 'MT::Log',
            'tag'             => 'MT::Tag',
            'role'            => 'MT::Role',
            'association'     => 'MT::Association',
            'permission'      => 'MT::Permission',
            'fileinfo'        => 'MT::FileInfo',
            'deletefileinfo'  => 'MT::DeleteFileInfo',
            'placement'       => 'MT::Placement',
            'plugindata'      => 'MT::PluginData',
            'session'         => 'MT::Session',
            'trackback'       => 'MT::Trackback',
            'config'          => 'MT::Config',
            'objecttag'       => 'MT::ObjectTag',
            'objectscore'     => 'MT::ObjectScore',
            'objectasset'     => 'MT::ObjectAsset',
            'filter'          => 'MT::Filter',
            'touch'           => 'MT::Touch',
            'failedlogin'     => 'MT::FailedLogin',
            'accesstoken'     => 'MT::AccessToken',

            # MT7
            'category_set'        => 'MT::CategorySet',
            'cd'                  => 'MT::ContentData',
            'content_data'        => 'MT::ContentData',
            'cf'                  => 'MT::ContentField',
            'content_field'       => 'MT::ContentField',
            'cf_idx'              => 'MT::ContentFieldIndex',
            'content_field_index' => 'MT::ContentFieldIndex',
            'content_type'        => 'MT::ContentType',
            'objectcategory'      => 'MT::ObjectCategory',
            'rebuild_trigger'     => 'MT::RebuildTrigger',

            # TheSchwartz tables
            'ts_job'        => 'MT::TheSchwartz::Job',
            'ts_error'      => 'MT::TheSchwartz::Error',
            'ts_exitstatus' => 'MT::TheSchwartz::ExitStatus',
            'ts_funcmap'    => 'MT::TheSchwartz::FuncMap',

            # group
            'group' => 'MT::Group',
        },
        object_type_aliases => {
            cd        => ['content_data'],
            cf        => ['content_field'],
            cf_idx    => ['content_field_index'],
            ipbanlist => ['banlist'],
            tbping    => [ 'ping', 'ping_cat' ],
        },
        list_properties => {
            __virtual => {
                base => {
                    init => sub {
                        my $prop = shift;
                        if ( $prop->has('col') ) {
                            $prop->{raw} = sub {
                                my $prop  = shift;
                                my ($obj) = @_;
                                my $col   = $prop->col;
                                return $obj->$col;
                                }
                                unless $prop->has('raw');
                            $prop->{sort} = sub {
                                my $prop = shift;
                                my ( $terms, $args ) = @_;
                                $args->{sort} = $prop->col;
                                return;
                                }
                                unless $prop->has('sort')
                                || $prop->has('bulk_sort')
                                || $prop->has('sort_method');
                        }
                    },
                    label => '',
                },
                hidden => {
                    base  => '__virtual.base',
                    terms => sub {
                        my $prop = shift;
                        my ( $args, $db_terms, $db_args ) = @_;
                        my $col    = $prop->col or die;
                        my $option = $args->{option};
                        my $value  = $args->{value};
                        if ( $prop->is_meta ) {
                            return $prop->join_meta( $db_args, $value );
                        }
                        else {
                            return { $col => $value };
                        }
                    },
                    filter_tmpl => '<mt:Var name="filter_form_hidden">',
                    base_type   => 'hidden',
                    priority    => 4,
                },
                string => {
                    base      => '__virtual.base',
                    col_class => 'string',
                    terms     => sub {
                        my $prop = shift;
                        my ( $args, $db_terms, $db_args ) = @_;
                        my $col    = $prop->col or die;
                        my $option = $args->{option};
                        my $query  = $args->{string};
                        if ( 'contains' eq $option ) {
                            $query = { like => "%$query%" };
                        }
                        elsif ( 'not_contains' eq $option ) {
                            $query
                                = [ { not_like => "%$query%" }, \'IS NULL' ];
                        }
                        elsif ( 'beginning' eq $option ) {
                            $query = { like => "$query%" };
                        }
                        elsif ( 'end' eq $option ) {
                            $query = { like => "%$query" };
                        }
                        elsif ( 'blank' eq $option ) {
                            $query = [ \'IS NULL', '' ];
                        }
                        elsif ( 'not_blank' eq $option ) {
                            $query
                                = [ '-and', \'IS NOT NULL', { not => '' } ];
                        }
                        if ( $prop->is_meta ) {
                            return $prop->join_meta( $db_args, $query );
                        }
                        else {
                            return { $col => $query };
                        }
                    },
                    filter_tmpl => sub {
                        my $prop = shift;
                        my $tmpl
                            = $prop->use_blank
                            ? 'filter_form_blank_string'
                            : 'filter_form_string';
                        qq{<mt:var name="${tmpl}">};
                    },
                    base_type      => 'string',
                    args_via_param => sub {
                        my $prop = shift;
                        my ( $app, $val ) = @_;
                        return { option => 'equal', string => $val };
                    },
                    label_via_param => sub {
                        my $prop = shift;
                        my ( $app, $val ) = @_;
                        return MT->translate(
                            '[_1] in [_2]: [_3]',
                            $prop->datasource->class_label_plural,
                            $prop->label,
                            MT::Util::encode_html($val),
                        );
                    },
                    priority => 7,
                },
                integer => {
                    base      => '__virtual.base',
                    col_class => 'num',

                    #sort_method => sub {
                    #    my $prop = shift;
                    #    my ( $obj_a, $obj_b ) = @_;
                    #    my $col = $prop->{col};
                    #    return $obj_a->$col <=> $obj_b->$col;
                    #},
                    terms => sub {
                        my $prop = shift;
                        my ( $args, $db_terms, $db_args ) = @_;
                        my $col    = $prop->col or die;
                        my $option = $args->{option};
                        my $value  = $args->{value};
                        my $query;
                        if ( 'equal' eq $option ) {
                            $query = $value;
                        }
                        elsif ( 'not_equal' eq $option ) {
                            $query = [ { not => $value }, \'IS NULL' ];
                        }
                        elsif ( 'greater_than' eq $option ) {
                            $query = { '>' => $value };
                        }
                        elsif ( 'greater_equal' eq $option ) {
                            $query = { '>=' => $value };
                        }
                        elsif ( 'less_than' eq $option ) {
                            $query = { '<' => $value };
                        }
                        elsif ( 'less_equal' eq $option ) {
                            $query = { '<=' => $value };
                        }
                        elsif ( 'blank' eq $option ) {
                            $query = \'IS NULL';
                        }
                        elsif ( 'not_blank' eq $option ) {
                            $query = \'IS NOT NULL';
                        }
                        if ( $prop->is_meta ) {
                            return $prop->join_meta( $db_args, $query );
                        }
                        else {
                            return { $col => $query };
                        }
                    },
                    args_via_param => sub {
                        my $prop = shift;
                        my ( $app, $val ) = @_;
                        return { option => 'equal', value => $val };
                    },
                    filter_tmpl => sub {
                        my $prop       = shift;
                        my $base_type  = $prop->base_type;
                        my $use_blank  = $prop->use_blank ? 'blank_' : '';
                        my $use_signed = $prop->use_signed ? 'signed_' : '';
                        my $tmpl
                            = "filter_form_${use_blank}${use_signed}${base_type}";
                        qq{<mt:Var name="${tmpl}">};
                    },
                    base_type          => 'integer',
                    priority           => 4,
                    default_sort_order => 'descend',
                },
                float => {
                    base        => '__virtual.integer',
                    col_class   => 'num',
                    data_format => '%.1f',
                    html        => sub {
                        my ( $prop, $obj ) = @_;
                        my $col = $prop->col;
                        return sprintf $prop->data_format, $obj->$col;
                    },
                    base_type => 'float',
                },
                double => { base => '__virtual.float' },
                date   => {
                    base          => '__virtual.base',
                    col_class     => 'date',
                    use_future    => 0,
                    validate_item => sub {
                        my $prop   = shift;
                        my ($item) = @_;
                        my $args   = $item->{args};
                        my $option = $args->{option}
                            or return $prop->error(
                            MT->translate('option is required') );
                        my %params = (
                            range  => { from   => 1, to => 1 },
                            before => { origin => 1 },
                            after  => { origin => 1 },
                            days   => { days   => 1 },
                        );

                        my $using = $params{$option};
                        $using->{option} = 1;
                        for my $key ( keys %$args ) {
                            if ( $using->{$key} ) {
                                ## validate it
                                if ( $key eq 'days' ) {
                                    return $prop->error(
                                        MT->translate(
                                            q{Days must be a number.})
                                    ) if $args->{days} =~ /\D/;
                                }
                                elsif ( $key ne 'option' ) {
                                    my $date = $args->{$key};
                                    return $prop->error(
                                        MT->translate(q{Invalid date.}) )
                                        unless $date
                                        =~ m/^\d{4}\-\d{2}\-\d{2}$/;
                                }
                            }
                            else {
                                ## or remove from $args.
                                delete $args->{$key};
                            }
                        }
                        return 1;
                    },
                    terms => sub {
                        my $prop = shift;
                        my ( $args, $db_terms, $db_args ) = @_;
                        my $col      = $prop->col;
                        my $option   = $args->{option};
                        my $boundary = $args->{boundary};
                        my $query;
                        my $blog = MT->app ? MT->app->blog : undef;
                        require MT::Util;
                        my $now = MT::Util::epoch2ts( $blog, time() );
                        my $from   = $args->{from}   || '';
                        my $to     = $args->{to}     || '';
                        my $origin = $args->{origin} || '';
                        $from =~ s/\D//g;
                        $to =~ s/\D//g;
                        $origin =~ s/\D//g;
                        $from .= '000000' if $from;
                        $to   .= '235959' if $to;

                        if ( 'range' eq $option ) {
                            $query = [
                                '-and',
                                { op => '>=', value => $from },
                                { op => '<=', value => $to },
                            ];
                        }
                        elsif ( 'days' eq $option ) {
                            my $days   = $args->{days};
                            my $origin = MT::Util::epoch2ts( $blog,
                                time - $days * 60 * 60 * 24 );
                            $query = [
                                '-and',
                                { op => '>', value => $origin },
                                { op => '<', value => $now },
                            ];
                        }
                        elsif ( 'before' eq $option ) {
                            if ($boundary) {
                                $query = {
                                    op    => '<=',
                                    value => $origin . '235959',
                                };
                            }
                            else {
                                $query = {
                                    op    => '<',
                                    value => $origin . '000000'
                                };
                            }
                        }
                        elsif ( 'after' eq $option ) {
                            if ($boundary) {
                                $query = {
                                    op    => '>=',
                                    value => $origin . '000000',
                                };
                            }
                            else {
                                $query = {
                                    op    => '>',
                                    value => $origin . '235959'
                                };
                            }
                        }
                        elsif ( 'future' eq $option ) {
                            $query = {
                                op    => '>',
                                value => $now
                            };
                        }
                        elsif ( 'past' eq $option ) {
                            $query = {
                                op    => '<',
                                value => $now
                            };
                        }
                        elsif ( 'blank' eq $option ) {
                            $query = \'IS NULL';
                        }
                        elsif ( 'not_blank' eq $option ) {
                            $query = \'IS NOT NULL';
                        }

                        if ( $prop->is_meta ) {
                            $prop->join_meta( $db_args, $query );
                        }
                        else {
                            return { $col => $query };
                        }
                    },
                    args_via_param => sub {
                        my $prop = shift;
                        my ( $app, $val ) = @_;
                        my $param;
                        if ( $val =~ m/\-/ ) {
                            my ( $from, $to ) = split /-/, $val;
                            $from = undef unless $from =~ m/^\d{8}$/;
                            $to   = undef unless $to =~ m/^\d{8}$/;
                            $from =~ s/^(\d{4})(\d{2})(\d{2})$/$1-$2-$3/;
                            $to =~ s/^(\d{4})(\d{2})(\d{2})$/$1-$2-$3/;
                            $param
                                = $from && $to
                                ? {
                                option => 'range',
                                from   => $from,
                                to     => $to
                                }
                                : $from
                                ? { option => 'after', origin => $from }
                                : { option => 'before', origin => $to };
                        }
                        elsif ( $val =~ m/(\d+)days/i ) {
                            $param = { option => 'days', days => $1 };
                        }
                        elsif ( $val eq 'future' ) {
                            $param = { option => 'future' };
                        }
                        elsif ( $val eq 'past' ) {
                            $param = { option => 'past' };
                        }
                        return $param;
                    },
                    label_via_param => sub {
                        my $prop = shift;
                        my ( $app, $val ) = @_;
                        require MT::Util;
                        if ( $val =~ m/\-/ ) {
                            my ( $from, $to ) = split /-/, $val;
                            $from = undef unless $from =~ m/^\d{8}$/;
                            $to   = undef unless $to =~ m/^\d{8}$/;
                            my $format = '%x';
                            $from = MT::Util::format_ts(
                                $format, $from . '000000',
                                undef,   MT->current_language
                            ) if $from;
                            $to = MT::Util::format_ts(
                                $format, $to . '000000',
                                undef,   MT->current_language
                            ) if $to;
                            if ( $from && $to ) {
                                return MT->translate(
                                    '[_1] [_2] between [_3] and [_4]',
                                    $prop->datasource->class_label_plural,
                                    $prop->label,
                                    $from,
                                    $to,
                                );
                            }
                            elsif ($from) {
                                return MT->translate(
                                    '[_1] [_2] since [_3]',
                                    $prop->datasource->class_label_plural,
                                    $prop->label,
                                    $from,
                                );
                            }
                            else {
                                return MT->translate(
                                    '[_1] [_2] or before [_3]',
                                    $prop->datasource->class_label_plural,
                                    $prop->label,
                                    $to,
                                );
                            }
                        }
                        elsif ( $val =~ m/(\d+)days/i ) {
                            return MT->translate(
                                '[_1] [_2] these [_3] days',
                                $prop->datasource->class_label_plural,
                                $prop->label, $1,
                            );
                        }
                        elsif ( $val eq 'future' ) {
                            return MT->translate(
                                '[_1] [_2] future',
                                $prop->datasource->class_label_plural,
                                $prop->label,
                            );
                        }
                        elsif ( $val eq 'past' ) {
                            return MT->translate(
                                '[_1] [_2] past',
                                $prop->datasource->class_label_plural,
                                $prop->label,
                            );
                        }
                    },

                    filter_tmpl => sub {
                        ## since __trans macro doesn't work with including itself
                        ## recursively, so do translate by hand here.
                        my $prop  = shift;
                        my $label = '<mt:var name="label" encode_html="1">';
                        my $tmpl
                            = $prop->use_future
                            ? 'filter_form_future_date'
                            : 'filter_form_date';
                        my $opts;
                        if ( $prop->use_future ) {
                            if ( $prop->use_blank ) {
                                $opts
                                    = '<mt:var name="future_blank_date_filter_options">';
                            }
                            else {
                                $opts
                                    = '<mt:var name="future_date_filter_options">';
                            }
                        }
                        else {
                            if ( $prop->use_blank ) {
                                $opts
                                    = '<mt:var name="blank_date_filter_options">';
                            }
                            else {
                                $opts = '<mt:var name="date_filter_options">';
                            }
                        }
                        my $contents
                            = $prop->use_future
                            ? '<mt:var name="future_date_filter_contents">'
                            : '<mt:var name="date_filter_contents">';
                        return MT->translate(
                            '<mt:var name="[_1]"> [_2] [_3] [_4]',
                            $tmpl, $label, $opts, $contents );
                    },
                    base_type => 'date',
                    html      => sub {
                        my $prop = shift;
                        my ( $obj, $app, $opts ) = @_;
                        my $ts          = $prop->raw(@_) or return '';
                        my $date_format = MT::App::CMS::LISTING_DATE_FORMAT();
                        my $blog        = $opts->{blog};
                        my $is_relative
                            = ( $app->user->date_format || 'relative' ) eq
                            'relative' ? 1 : 0;
                        my $date = $is_relative
                            ? MT::Util::relative_date( $ts, time, $blog )
                            : MT::Util::format_ts(
                            $date_format,
                            $ts,
                            $blog,
                            $app->user ? $app->user->preferred_language
                            : undef
                            );
                        my $timestamp = MT::Util::format_ts(
                            '%Y-%m-%d %H:%M:%S',
                            $ts,
                            $blog,
                            );
                        return qq{<span title="$timestamp">$date</span>};
                    },
                    priority           => 5,
                    default_sort_order => 'descend',
                },
                single_select => {
                    base             => '__virtual.base',
                    sort             => 0,
                    singleton        => 1,
                    normalized_value => sub {
                        my $prop     = shift;
                        my ($args)   = @_;
                        my $lc_value = lc $args->{value};

                        for my $o ( @{ $prop->single_select_options } ) {
                            if ( $o->{text} && lc $o->{text} eq $lc_value ) {
                                return $o->{value};
                            }
                        }

                        return $args->{value};
                    },
                    terms => sub {
                        my $prop = shift;
                        my ( $args, $db_terms, $db_args ) = @_;
                        my $col = $prop->col || $prop->type or die;
                        my $value = $prop->normalized_value(@_);

                        if ( $col =~ /\./ ) {
                            my ( $parent, $c ) = split /\./, $col;
                            $db_args->{joins} ||= [];
                            my $ds = $prop->datasource->datasource;
                            push @{ $db_args->{joins} },
                                MT->model($parent)->join_on(
                                undef,
                                {   id => \"=${ds}_${parent}_id",
                                    $c => $value
                                },
                                );
                            return;
                        }
                        else {
                            return { $col => $value };
                        }
                    },
                    label_via_param => sub {
                        my $prop = shift;
                        my ( $app, $val ) = @_;
                        my $opts = $prop->single_select_options;
                        my ($selected) = grep { $_->{value} eq $val } @$opts
                            or return $prop->error(
                            MT->translate('Invalid parameter.') );
                        return MT->translate(
                            '[_1] [_3] [_2]',
                            $prop->label,
                            $selected->{label},
                            (   defined $prop->verb
                                ? $prop->verb
                                : $app->translate('__SELECT_FILTER_VERB')
                            )
                        );
                    },
                    args_via_param => sub {
                        my $prop = shift;
                        my ( $app, $val ) = @_;
                        return { value => $val };
                    },
                    filter_tmpl =>
                        '<mt:Var name="filter_form_single_select">',
                    base_type => 'single_select',
                    priority  => 2,
                },
                id => {
                    auto               => 1,
                    default_sort_order => 'ascend',
                    label              => 'ID',
                },
                ## translate('No Title')
                ## translate('No Name')
                ## translate('No Label')
                label => {
                    auto              => 1,
                    label             => 'Label',
                    display           => 'force',
                    alternative_label => 'No label',
                    html => \&MT::ListProperty::common_label_html,
                },
                title => {
                    base              => '__virtual.label',
                    alternative_label => 'No Title',
                },
                name => {
                    base              => '__virtual.label',
                    alternative_label => 'No Name',
                },
                created_on => {
                    auto    => 1,
                    label   => 'Date Created',
                    display => 'optional',
                },
                modified_on => {
                    auto    => 1,
                    label   => 'Date Modified',
                    display => 'optional',
                },
                author_name => {
                    label        => 'Created by',
                    filter_label => 'Created by',
                    display      => 'default',
                    base         => '__virtual.string',
                    raw          => sub {
                        my ( $prop, $obj ) = @_;
                        my $col
                            = $prop->datasource->has_column('author_id')
                            ? 'author_id'
                            : 'created_by';

                      # If there's no value in the column then no voter ID was
                      # recorded.
                        return '' if !$obj->$col;

                        my $author = MT->model('author')->load( $obj->$col );
                        return $author
                            ? ( $author->nickname || $author->name )
                            : MT->translate('*User deleted*');
                    },
                    terms => sub {
                        my $prop = shift;
                        my ( $args, $load_terms, $load_args ) = @_;
                        my $col
                            = $prop->datasource->has_column('author_id')
                            ? 'author_id'
                            : 'created_by';
                        my $driver  = $prop->datasource->driver;
                        my $colname = $driver->dbd->db_column_name(
                            $prop->datasource->datasource, $col );
                        $prop->{col} = 'name';
                        my $name_query = $prop->super(@_);
                        $prop->{col} = 'nickname';
                        my $nick_query = $prop->super(@_);
                        $load_args->{joins} ||= [];
                        push @{ $load_args->{joins} },
                            MT->model('author')->join_on(
                            undef,
                            [   { id => \"= $colname" },
                                '-and',
                                [   $name_query,
                                    (   $args->{'option'} eq 'not_contains'
                                        ? '-and'
                                        : '-or'
                                    ),
                                    $nick_query,
                                ]
                            ],
                            {}
                            );
                    },
                    bulk_sort => sub {
                        my $prop = shift;
                        my ($objs) = @_;
                        my $col
                            = $prop->datasource->has_column('author_id')
                            ? 'author_id'
                            : 'created_by';
                        my %author_id
                            = map { ( $_->$col ) ? ( $_->$col => 1 ) : () }
                            @$objs;
                        my @authors = MT->model('author')
                            ->load( { id => [ keys %author_id ] } );
                        my %nickname = map {
                                  $_->id => defined $_->nickname
                                ? $_->nickname
                                : ''
                        } @authors;
                        $nickname{0} = '';    # fallback
                        return sort {
                            $nickname{ $a->$col || 0 }
                                cmp $nickname{ $b->$col || 0 }
                        } @$objs;
                    },
                },
                modified_by => {
                    label        => 'Modified by',
                    filter_label => 'Modified by',
                    display      => 'optional',
                    base         => '__virtual.string',
                    raw          => sub {
                        my ( $prop, $obj ) = @_;

                        # If there's no value in the column then no voter ID was
                        # recorded.
                        return '' if !$obj->modified_by;

                        my $author = MT->model('author')->load( $obj->modified_by );
                        return $author
                            ? ( $author->nickname || $author->name )
                            : MT->translate('*User deleted*');
                    },
                    terms => sub {
                        my $prop = shift;
                        my ( $args, $load_terms, $load_args ) = @_;
                        my $driver  = $prop->datasource->driver;
                        my $colname = $driver->dbd->db_column_name(
                            $prop->datasource->datasource, 'modified_by' );
                        $prop->{col} = 'name';
                        my $name_query = $prop->super(@_);
                        $prop->{col} = 'nickname';
                        my $nick_query = $prop->super(@_);
                        $load_args->{joins} ||= [];
                        push @{ $load_args->{joins} },
                            MT->model('author')->join_on(
                            undef,
                            [   { id => \"= $colname" },
                                '-and',
                                [   $name_query,
                                    (   $args->{'option'} eq 'not_contains'
                                        ? '-and'
                                        : '-or'
                                    ),
                                    $nick_query,
                                ]
                            ],
                            {}
                            );
                    },
                    bulk_sort => sub {
                        my $prop = shift;
                        my ($objs) = @_;
                        my %author_id
                            = map { ( $_->modified_by ) ? ( $_->modified_by => 1 ) : () }
                            @$objs;
                        my @authors = MT->model('author')
                            ->load( { id => [ keys %author_id ] } );
                        my %nickname = map {
                                  $_->id => defined $_->nickname
                                ? $_->nickname
                                : ''
                        } @authors;
                        $nickname{0} = '';    # fallback
                        return sort {
                            $nickname{ $a->modified_by || 0 }
                                cmp $nickname{ $b->modified_by || 0 }
                        } @$objs;
                    },
                },
                tag => {
                    base    => '__virtual.string',
                    label   => 'Tag',
                    display => 'none',
                    terms   => sub {
                        my $prop = shift;
                        my ( $args, $base_terms, $base_args, $opts ) = @_;
                        my $option  = $args->{option};
                        my $query   = $args->{string};
                        my $blog_id = $opts->{blog_ids};
                        if ( 'contains' eq $option ) {
                            $query = { like => "%$query%" };
                        }
                        elsif ( 'not_contains' eq $option ) {

                            # After searching by LIKE, negate that results.
                            $query = { like => "%$query%" };
                        }
                        elsif ( 'beginning' eq $option ) {
                            $query = { like => "$query%" };
                        }
                        elsif ( 'end' eq $option ) {
                            $query = { like => "%$query" };
                        }
                        my $ds           = $prop->object_type;
                        my $tagged_class = $prop->tagged_class || $ds;
                        my $ds_join      = MT->model($ds)->join_on(
                            undef,
                            {   id => \'= objecttag_object_id',
                                ( $blog_id ? ( blog_id => $blog_id ) : () ),
                                (   $tagged_class eq '*' ? ()
                                    : ( class => $tagged_class )
                                ),
                            },
                            {   unique => 1,
                                (   $tagged_class eq '*' ? ( no_class => 1 )
                                    : ()
                                ),
                            }
                        );
                        my $tag_ds = $prop->tag_ds || $ds;

                        my @objecttag_terms_args = (
                            { object_datasource => $tag_ds },
                            {   fetchonly => { object_id => 1 },
                                unique    => 1,
                                joins     => [
                                    MT->model('tag')->join_on(
                                        undef,
                                        {   (          $option eq 'blank'
                                                    || $option eq 'not_blank'
                                                )
                                            ? ()
                                            : ( name => $query ),
                                            id => \'= objecttag_tag_id',
                                        },
                                    ),
                                    $ds_join,
                                ],
                            }
                        );
                        if ( 'not_contains' eq $option || 'blank' eq $option )
                        {
                            my @ids = map( $_->object_id,
                                MT->model('objecttag')
                                    ->load(@objecttag_terms_args) );
                            @ids ? { id => { not => \@ids } } : ();
                        }
                        else {
                            $base_args->{joins} ||= [];
                            push @{ $base_args->{joins} },
                                MT->model('objecttag')
                                ->join_on( undef, @objecttag_terms_args );
                        }
                    },
                },
                object_count => {
                    base               => '__virtual.integer',
                    col_class          => 'num',
                    default_sort_order => 'descend',
                    ref_column         => 'id',
                    raw                => sub {
                        my $prop = shift;
                        my ( $obj, $app, $opts ) = @_;
                        my $count_terms
                            = $prop->has('count_terms')
                            ? $prop->count_terms($opts)
                            : {};
                        my $count_args
                            = $prop->has('count_args')
                            ? $prop->count_args($opts)
                            : {};
                        MT->model( $prop->count_class )
                            ->count(
                            { %$count_terms, $prop->count_col => $obj->id },
                            $count_args, );
                    },
                    html => sub {
                        my $prop = shift;
                        my ( $obj, $app ) = @_;
                        my $count = $prop->raw(@_);
                        if ( $prop->has('list_permit_action') ) {
                            my $user = $app->user;
                            my $perm = $user->permissions(
                                  $obj->isa('MT::Blog')       ? ( $obj->id )
                                : $obj->has_column('blog_id') ? $obj->blog_id
                                : 0
                            );
                            return $count
                                unless $perm->can_do(
                                $prop->list_permit_action );
                        }
                        my $args;
                        if ( $prop->filter_type eq 'blog_id' ) {
                            $args = {
                                _type => $prop->list_screen
                                    || $prop->count_class,
                                blog_id => $obj->id,
                            };
                        }
                        else {
                            $args = {
                                _type => $prop->list_screen
                                    || $prop->count_class,
                                blog_id =>
                                    ( $app->blog ? $app->blog->id : 0 ),
                                (   $prop->has('filter_type')
                                    ? ( filter     => $prop->filter_type,
                                        filter_val => $obj->id,
                                        )
                                    : ()
                                ),
                            };
                        }
                        my $uri = $app->uri(
                            mode => 'list',
                            args => $args,
                        );
                        return qq{<a href="$uri">$count</a>};
                    },
                    bulk_sort => sub {
                        my $prop = shift;
                        my ( $objs, $opts ) = @_;
                        my $count_terms
                            = $prop->has('count_terms')
                            ? $prop->count_terms($opts)
                            : {};
                        my $count_args
                            = $prop->has('count_args')
                            ? $prop->count_args($opts)
                            : {};
                        my $iter
                            = MT->model( $prop->count_class )
                            ->count_group_by(
                            $count_terms,
                            {   %$count_args,
                                sort      => 'cnt',
                                direction => 'descend',
                                group     => [ $prop->count_col, ],
                            },
                            );
                        return @$objs unless $iter;
                        my @res;
                        my %obj_map = map { $_->id => $_ } @$objs;

                        while ( my ( $count, $id ) = $iter->() ) {
                            next unless $id;
                            push @res, delete $obj_map{$id} if $obj_map{$id};
                        }
                        push @res, values %obj_map;
                        return reverse @res;
                    },
                    terms => 0,
                    grep  => sub {
                        my $prop = shift;
                        my ( $args, $objs, $opts ) = @_;
                        my $count_terms
                            = $prop->has('count_terms')
                            ? $prop->count_terms($opts)
                            : {};
                        my $count_args
                            = $prop->has('count_args')
                            ? $prop->count_args($opts)
                            : {};
                        my $iter
                            = MT->model( $prop->count_class )
                            ->count_group_by(
                            $count_terms,
                            {   %$count_args,
                                direction => 'descend',
                                group     => [ $prop->count_col, ],
                            },
                            );
                        my %map;
                        while ( my ( $count, $id ) = $iter->() ) {
                            $map{$id} = $count;
                        }
                        my $op
                            = $args->{option} eq 'equal'         ? '=='
                            : $args->{option} eq 'not_equal'     ? '!='
                            : $args->{option} eq 'greater_than'  ? '<'
                            : $args->{option} eq 'greater_equal' ? '<='
                            : $args->{option} eq 'less_than'     ? '>'
                            : $args->{option} eq 'less_equal'    ? '>='
                            :                                      '';
                        return @$objs unless $op;
                        my $val     = $args->{value};
                        my $sub     = eval "sub { $val $op shift }";
                        my $ref_col = $prop->ref_column;
                        return
                            grep { $sub->( $map{ $_->$ref_col } || 0 ) }
                            @$objs;
                    },
                },
            },
            __common => {
                __legacy => {
                    label           => 'Legacy Quick Filter',
                    priority        => 1,
                    filter_editable => 0,
                    singleton       => 1,
                    terms           => sub {
                        my $prop = shift;
                        my ( $args, $db_terms, $db_args ) = @_;
                        my $ds         = $args->{ds};
                        my $filter_key = $args->{filter_key};
                        my $filter_val = $args->{filter_val};
                        if ($filter_val) {
                            MT->app->param( 'filter_val', $filter_val );
                        }
                        my $filter
                            = MT->registry(
                            applications => cms => list_filters => $ds =>
                                $filter_key )
                            or die "No regacy filter";
                        if ( my $code = $filter->{code}
                            || MT->handler_to_coderef( $filter->{handler} ) )
                        {
                            $code->( $db_terms, $db_args );
                        }
                        return undef;
                    },
                    filter_tmpl => '<mt:var name="filter_form_legacy">',
                },
                __id => {
                    base        => '__virtual.integer',
                    col         => 'id',
                    display     => 'none',
                    view_filter => [],
                    condition   => sub {
                        my $prop = shift;
                        return $prop->datasource->has_column('id') ? 1 : 0;
                    },
                },
                pack => {
                    view          => [],
                    terms         => \&MT::Filter::pack_terms,
                    grep          => \&MT::Filter::pack_grep,
                    requires_grep => \&MT::Filter::pack_requires_grep,
                },
                blog_id => {
                    auto            => 0,
                    col             => 'blog_id',
                    display         => 'none',
                    filter_editable => 0,
                },
                blog_name => {
                    label        => 'Site Name',
                    filter_label => 'Site Name',
                    order        => 10000,
                    display      => 'default',
                    site_name    => 1,
                    view         => [ 'system', 'website' ],
                    bulk_html    => sub {
                        my $prop     = shift;
                        my ($objs)   = @_;
                        my %blog_ids = map { $_->blog_id => 1 } @$objs;
                        my @blogs    = MT->model('blog')->load(
                            { id => [ keys %blog_ids ], },
                            {   fetchonly => {
                                    id        => 1,
                                    name      => 1,
                                    parent_id => 1,
                                }
                            }
                        );
                        my %blog_map = map { $_->id        => $_ } @blogs;
                        my %site_ids = map { $_->parent_id => 1 }
                            grep {
                            $_->parent_id
                                && !$blog_map{ $_->parent_id }
                            } @blogs;
                        my @sites;
                        @sites
                            = MT->model('website')
                            ->load( { id => [ keys %site_ids ], },
                            { fetchonly => { id => 1, name => 1, }, } )
                            if keys %site_ids;
                        my %blog_site_map
                            = map { $_->id => $_ } ( @blogs, @sites );
                        my @out;

                        for my $obj (@$objs) {
                            if ( !$obj->blog_id ) {
                                push @out, MT->translate('(system)');
                                next;
                            }
                            my $blog = $blog_site_map{ $obj->blog_id };
                            unless ($blog) {
                                push @out,
                                    MT->translate('*Website/Blog deleted*');
                                next;
                            }
                            my $site;
                            if ($blog->parent_id
                                && ( $site
                                    = $blog_site_map{ $blog->parent_id } )
                                && $prop->site_name
                                )
                            {
                                push @out,
                                    join( '/', $site->name, $blog->name );
                            }
                            else {
                                push @out, $blog->name;
                            }
                        }
                        return map { MT::Util::encode_html($_) } @out;
                    },
                    condition => sub {
                        my $prop = shift;
                        $prop->datasource->has_column('blog_id') or return;
                        my $app = MT->app or return;
                        return !$app->blog || !$app->blog->is_blog;
                    },
                    bulk_sort => sub {
                        my $prop    = shift;
                        my ($objs)  = @_;
                        my %blog_id = map { $_->blog_id => 1 } @$objs;
                        my @blogs
                            = MT->model('blog')
                            ->load( { id => [ keys %blog_id ] },
                            { no_class => 1, } );
                        my %blogname = map { $_->id => $_->name } @blogs;
                        return sort {
                            $blogname{ $a->blog_id }
                                cmp $blogname{ $b->blog_id }
                        } @$objs;
                    },
                },
                current_user => {
                    base            => '__virtual.hidden',
                    label           => 'My Items',
                    order           => 20000,
                    display         => 'none',
                    filter_editable => 0,
                    condition       => sub {
                        my $prop  = shift;
                        my $class = $prop->datasource;
                        return $class->has_column('author_id')
                            || $class->has_column('created_by');
                    },
                    terms => sub {
                        my $prop = shift;
                        my ( $args, $load_terms, $load_args ) = @_;
                        my $app = MT->app or return;
                        my $class = $prop->datasource;
                        my $col
                            = $class->has_column('author_id')
                            ? 'author_id'
                            : 'created_by';
                        return { $col => $app->user->id };
                    },
                    singleton       => 1,
                    label_via_param => sub {
                        my $prop  = shift;
                        my $class = $prop->datasource;
                        return MT->translate( 'My [_1]',
                            $class->class_label_plural );
                    },
                },
                current_context => {
                    base  => '__virtual.hidden',
                    label => sub {
                        my $prop = shift;
                        my ($settings) = @_;
                        return MT->translate(
                            '[_1] of this Site',
                            $settings->{object_label_plural}
                                || $prop->datasource->class_label_plural,
                        );
                    },
                    order           => 30000,
                    view            => 'website',
                    display         => 'none',
                    filter_editable => 1,
                    condition       => sub {
                        my $prop = shift;
                        $prop->datasource->has_column('blog_id');
                    },
                    terms => sub {
                        my $prop = shift;
                        my ( $args, $load_terms, $load_args, $opts ) = @_;
                        { blog_id => $opts->{blog_id} };
                    },
                    singleton => 1,
                },
                content => {
                    base            => '__virtual.hidden',
                    filter_editable => 0,
                    terms           => sub {
                        my ( $prop, $args, $db_terms, $db_args ) = @_;
                        my $defaults = $prop->{fields};
                        my $option   = $args->{option};
                        my $query    = $args->{string};
                        my $and_or;
                        if ( 'contains' eq $option ) {
                            $query = { like => "%$query%" };
                            $and_or = '-or';
                        }
                        elsif ( 'not_contains' eq $option ) {
                            $query = { not_like => "%$query%" };
                            $and_or = '-and';
                        }

                        my @fields;
                        if ( my $specifieds = $args->{fields} ) {
                            @fields = grep {
                                my $f = $_;
                                grep { $_ eq $f } @$defaults
                            } split ',', $specifieds;
                        }
                        else {
                            @fields = @{ $defaults || [] };
                        }

                        my @terms;
                        for my $c (@fields) {
                            push @terms, ( @terms ? $and_or : () ),
                                { $c => $query, };
                        }

                        \@terms;
                    },
                },
            },
            website       => '$Core::MT::Website::list_props',
            blog          => '$Core::MT::Blog::list_props',
            entry         => '$Core::MT::Entry::list_props',
            page          => '$Core::MT::Page::list_props',
            asset         => '$Core::MT::Asset::list_props',
            category      => '$Core::MT::Category::list_props',
            folder        => '$Core::MT::Folder::list_props',
            author        => '$Core::MT::Author::list_props',
            member        => '$Core::MT::Author::member_list_props',
            tag           => '$Core::MT::Tag::list_props',
            banlist       => '$Core::MT::IPBanList::list_props',
            association   => '$Core::MT::Association::list_props',
            role          => '$Core::MT::Role::list_props',
            notification  => '$Core::MT::Notification::list_props',
            log           => '$Core::MT::Log::list_props',
            filter        => '$Core::MT::Filter::list_props',
            permission    => '$Core::MT::Permission::list_props',
            template      => '$Core::MT::Template::list_props',
            templatemap   => '$Core::MT::TemplateMap::list_props',
            category_set  => '$Core::MT::CategorySet::list_props',
            content_type  => '$Core::MT::ContentType::list_props',
            content_field => '$Core::MT::ContentField::list_props',
            content_data  => '$Core::MT::ContentData::list_props',
            group         => '$Core::MT::Group::list_props',
            group_member  => '$Core::MT::Group::member_list_props',
        },
        system_filters => {
            entry        => '$Core::MT::Entry::system_filters',
            page         => '$Core::MT::Page::system_filters',
            tag          => '$Core::MT::Tag::system_filters',
            asset        => '$Core::MT::Asset::system_filters',
            author       => '$Core::MT::Author::system_filters',
            member       => '$Core::MT::Author::member_system_filters',
            log          => '$Core::MT::Log::system_filters',
            association  => '$Core::MT::Association::system_filters',
            group        => '$Core::MT::Group::system_filters',
            group_member => '$Core::MT::Group::member_system_filters',
            website      => '$Core::MT::Website::system_filters',
        },
        listing_screens => {
            website => {
                object_label     => 'Site',
                primary          => 'name',
                view             => 'system',
                default_sort_key => 'name',
                scope_mode       => 'none',
                condition        => sub {
                    require MT::CMS::Website;
                    return MT::CMS::Website::can_view_website_list(
                        MT->instance );
                },
            },
            blog => {
                object_label     => 'Child Site',
                view             => [qw( system website )],
                primary          => 'name',
                default_sort_key => 'name',
                scope_mode       => 'none',
                condition        => sub {
                    require MT::CMS::Blog;
                    return MT::CMS::Blog::can_view_blog_list( MT->instance );
                },
                data_api_condition => sub {1},
            },
            entry => {
                object_label        => 'Entry',
                primary             => 'title',
                default_sort_key    => 'authored_on',
                data_api_scope_mode => 'this',
                permission          => "access_to_entry_list",
                data_api_permission => undef,
                view                => [ 'website', 'blog' ],
                feed_link           => sub {
                    my ($app) = @_;
                    return 1 if $app->user->is_superuser;

                    if ( $app->blog ) {
                        return 1
                            if $app->user->can_do( 'get_entry_feed',
                            at_least_one => 1 );
                    }
                    else {
                        my $iter = MT->model('permission')->load_iter(
                            {   author_id => $app->user->id,
                                blog_id   => { not => 0 },
                            }
                        );
                        my $cond;
                        while ( my $p = $iter->() ) {
                            $cond = 1, last
                                if $p->can_do('get_entry_feed');
                        }
                        return $cond ? 1 : 0;
                    }
                    0;
                },
            },
            page => {
                object_label        => 'Page',
                primary             => 'title',
                default_sort_key    => 'modified_on',
                data_api_scope_mode => 'this',
                permission          => 'access_to_page_list',
                data_api_permission => undef,
                view                => [ 'website', 'blog' ],
                feed_link           => sub {
                    my ($app) = @_;
                    return 1 if $app->user->is_superuser;

                    if ( $app->blog ) {
                        return 1
                            if $app->user->can_do( 'get_page_feed',
                            at_least_one => 1 );
                    }
                    else {
                        my $iter = MT->model('permission')->load_iter(
                            {   author_id => $app->user->id,
                                blog_id   => { not => 0 },
                            }
                        );
                        my $cond;
                        while ( my $p = $iter->() ) {
                            $cond = 1, last
                                if $p->can_do('get_page_feed');
                        }
                        return $cond ? 1 : 0;
                    }
                    0;
                },
            },
            asset => {
                object_label        => 'Asset',
                primary             => 'label',
                data_api_scope_mode => 'strict',
                permission          => 'access_to_asset_list',
                data_api_permission => undef,
                default_sort_key    => 'created_on',
            },
            log => {
                object_label        => 'Log',
                default_sort_key    => 'created_on',
                primary             => 'message',
                data_api_scope_mode => 'this',
                condition           => sub {
                    my $app     = MT->instance;
                    my $user    = $app->user;
                    my $blog_id = $app->param('blog_id');
                    return 1 if $user->is_superuser;
                    return 0 unless defined $blog_id;

                    my $terms;
                    push @$terms, { author_id => $user->id };
                    if ($blog_id) {
                        my $blog = MT->model('blog')->load($blog_id);
                        my @blog_ids;
                        push @blog_ids, $blog_id;
                        if ( $blog && !$blog->is_blog ) {
                            push @blog_ids, map { $_->id } @{ $blog->blogs };
                        }
                        push @$terms,
                            [
                            '-and',
                            {   blog_id => \@blog_ids,
                                permissions =>
                                    { like => "\%'view_blog_log'\%" },
                            }
                            ];
                    }
                    else {
                        push @$terms,
                            [
                            '-and',
                            [   {   blog_id => 0,
                                    permissions =>
                                        { like => "\%'view_log'\%" },
                                },
                                '-or',
                                {   blog_id => \' > 0',
                                    permissions =>
                                        { like => "\%'view_blog_log'\%" },
                                }
                            ]
                            ];
                    }

                    my $cnt = MT->model('permission')->count($terms);
                    return ( $cnt && $cnt > 0 ) ? 1 : 0;
                },
                feed_link => sub {
                    my ($app) = @_;
                    return 1 if $app->user->is_superuser;
                    return 1 if $app->can_do('get_all_system_feed');

                    if ( $app->blog ) {
                        return 1
                            if $app->user->can_do( 'get_system_feed',
                            at_least_one => 1 );
                    }
                    else {
                        my $iter = MT->model('permission')->load_iter(
                            {   author_id => $app->user->id,
                                blog_id   => { not => 0 },
                            }
                        );
                        my $cond;
                        while ( my $p = $iter->() ) {
                            $cond = 1, last
                                if $p->can_do('get_system_feed');
                        }
                        return $cond ? 1 : 0;
                    }

                    0;
                },
                feed_label   => 'Activity Feed',
                screen_label => 'Activity Log',
            },
            category => {
                object_label          => 'Category',
                primary               => 'label',
                template              => 'list_category.tmpl',
                contents_label        => 'Entry',
                contents_label_plural => 'Entries',
                permission            => sub {
                    my $app = shift;
                    if ( $app->param('is_category_set') ) {
                        return 'access_to_category_set_list';
                    }
                    else {
                        return 'access_to_category_list';
                    }
                },
                data_api_permission => undef,
                view                => [ 'website', 'blog' ],
                scope_mode          => 'this',
                condition           => sub {
                    my $app = shift;
                    ( $app->param('_type') || '' ) ne 'filter';
                },
            },
            folder => {
                primary               => 'label',
                object_label          => 'Folder',
                template              => 'list_category.tmpl',
                search_type           => 'page',
                contents_label        => 'Page',
                contents_label_plural => 'Pages',
                permission            => {
                    permit_action => 'access_to_folder_list',
                    inherit       => 0,
                },
                data_api_permission => undef,
                view                => [ 'website', 'blog' ],
                scope_mode          => 'this',
                condition           => sub {
                    my $app = shift;
                    ( $app->param('_type') || '' ) ne 'filter';
                },
            },
            author => {
                object_label        => 'Author',
                primary             => 'name',
                permission          => 'manage_users_groups',
                data_api_permission => undef,
                default_sort_key    => 'name',
                view                => 'system',
                scope_mode          => 'none',
            },
            member => {
                primary             => 'name',
                object_label        => 'Member',
                object_label_plural => 'Members',
                object_type         => 'author',
                default_sort_key    => 'name',
                view                => [ 'blog', 'website' ],
                scope_mode          => 'none',
                permission          => {
                    permit_action => 'access_to_blog_member_list',
                    inherit       => 0,
                },
            },
            tag => {
                primary      => 'name',
                object_label => 'Tag',
                permission   => {
                    permit_action => 'access_to_tag_list',
                    inherit       => 0,
                },
                data_api_permission => undef,
                default_sort_key    => 'name',
                view                => [ 'blog', 'website' ],
                scope_mode          => 'none',
            },
            association => {
                object_label        => 'Permission',
                object_label_plural => 'Permissions',
                object_type         => 'association',
                search_type         => 'author',
                default_sort_key    => 'created_on',
                primary             => [ 'user_name', 'role_name' ],
                view                => 'system',
            },
            role => {
                object_label     => 'Role',
                object_type      => 'role',
                search_type      => 'author',
                primary          => 'name',
                permission       => 'access_to_role_list',
                default_sort_key => 'name',
                view             => 'system',
            },
            banlist => {
                object_label        => 'IP address',
                object_label_plural => 'IP addresses',
                action_label        => 'IP address',
                action_label_plural => 'IP addresses',
                zero_state          => 'IP address',
                condition           => sub {
                    my $app = shift;
                    return 1 if MT->config->ShowIPInformation;
                    $app->errtrans(
                        'IP Banlist is disabled by system configuration.');
                },
                primary          => 'ip',
                permission       => 'access_to_banlist',
                default_sort_key => 'created_on',
                screen_label     => 'IP Banning Settings',
            },
            notification => {
                object_label => 'Contact',
                condition    => sub {
                    my $app = shift;
                    return 1 if MT->config->EnableAddressbook;
                    $app->errtrans(
                        'Address Book is disabled by system configuration.');
                },
                permission       => 'access_to_notification_list',
                primary          => [ 'email', 'url' ],
                default_sort_key => 'created_on',
                screen_label     => 'Manage Address Book',
            },
            filter => {
                object_label     => 'Filter',
                view             => 'system',
                permission       => 'access_to_filter_list',
                primary          => 'label',
                default_sort_key => 'created_on',
                scope_mode       => 'none',
            },
            permission => {
                condition           => sub {0},
                data_api_condition  => sub {1},
                data_api_scope_mode => 'this',
            },
            template     => { data_api_scope_mode => 'strict', },
            category_set => {
                object_label        => 'Category Set',
                primary             => 'name',
                view                => [ 'website', 'blog' ],
                default_sort_key    => 'name',
                data_api_permission => undef,
                scope_mode          => 'this',
                permission          => 'access_to_category_set_list',
            },
            content_type => {
                screen_label        => 'Manage Content Type',
                object_label        => 'Content Type',
                object_label_plural => 'Content Types',
                object_type         => 'content_type',
                scope_mode          => 'this',
                use_filters         => 0,
                view                => [ 'website', 'blog' ],
                primary             => 'name',
                permission          => 'access_to_content_type_list',
            },
            content_field => {
                object_label        => 'Content Field',
                object_label_plural => 'Content Fields',
                object_type         => 'content_field',
                condition           => sub {0},
                data_api_condition  => sub {1},
                scope_mode          => 'this',
                use_filters         => 0,
                view                => [ 'website', 'blog' ],
                primary             => 'name',
            },
            group => {
                object_label     => 'Group',
                default_sort_key => 'name',
                primary          => 'name',
                permission       => 'administer,manage_users_groups',
                view             => 'system',
            },
            group_member => {
                screen_label        => 'Manage Group Members',
                object_label_plural => 'Group Members',
                object_label        => 'Group Member',
                object_type         => 'association',
                default_sort_key    => 'name',
                permission          => 'administer,manage_users_groups',
                primary             => 'name',
                view                => 'system',
                search_label        => 'User',
                search_type         => 'author',
            },
        },
        summaries => {
            'author' => {
                entry_count => {
                    type => 'integer',
                    code =>
                        '$Core::MT::Summary::Author::summarize_entry_count',
                    expires => {
                        'MT::Entry' => {
                            id_column => 'author_id',
                            code =>
                                '$Core::MT::Summary::Author::expire_entry_count',
                        },
                    },
                },
                comment_count => {
                    type => 'integer',
                    code =>
                        '$Core::MT::Summary::Author::summarize_comment_count',
                    expires => {
                        'MT::Comment' => {
                            id_column => 'commenter_id',
                            code =>
                                '$Core::MT::Summary::Author::expire_comment_count',
                        },
                        'MT::Entry' => {
                            id_column => 'author_id',
                            code =>
                                '$Core::MT::Summary::Author::expire_comment_count_entry',
                        },
                    },
                },
            },
            'entry' => {
                all_assets => {
                    type => 'text',
                    code => '$Core::MT::Summary::Entry::summarize_all_assets',
                    expires => {
                        'MT::ObjectAsset' => {
                            id_column => 'object_id',
                            code      => '$Core::MT::Summary::expire_all',
                        }
                    }
                }
            },
        },
        backup_instructions => \&load_backup_instructions,
        permissions         => \&load_core_permissions,
        config_settings     => {
            'AtomApp' => {
                type    => 'HASH',
                default => {
                    weblog   => 'MT::AtomServer::Weblog::Legacy',
                    '1.0'    => 'MT::AtomServer::Weblog',
                    comments => 'MT::AtomServer::Comments',
                },
            },
            'SchemaVersion'                => undef,
            'MTVersion'                    => undef,
            'MTReleaseNumber'              => undef,
            'RequiredCompatibility'        => { default => 0 },
            'EnableSessionKeyCompat'       => { default => 0 },
            'NotifyUpgrade'                => { default => 1 },
            'Database'                     => undef,
            'DBHost'                       => undef,
            'DBSocket'                     => undef,
            'DBPort'                       => undef,
            'DBUser'                       => undef,
            'DBPassword'                   => undef,
            'DBMaxRetries'                 => { default => 3 },
            'DBRetryInterval'              => { default => 1 },
            'PIDFilePath'                  => undef,
            'DefaultLanguage'              => { default => 'en_US', },
            'DefaultSupportedLanguages'    => undef,
            'LocalPreviews'                => { default => 0 },
            'EnableAutoRewriteOnIIS'       => { default => 1 },
            'IISFastCGIMonitoringFilePath' => undef,
            'DefaultCommenterAuth'         => { default => 'MovableType' },
            'TemplatePath'                 => {
                default => 'tmpl',
                path    => 1,
            },
            'WeblogTemplatesPath' => {
                default => 'default_templates',
                path    => 1,
            },
            'AltTemplatePath' => {
                default => 'alt-tmpl',
                path    => 1,
                type    => 'ARRAY',
            },
            'CSSPath'    => { default => 'css', },
            'ImportPath' => {
                default => 'import',
                path    => 1,
            },
            'PluginPath' => {
                default => 'plugins',
                path    => 1,
                type    => 'ARRAY',
            },
            'LocalLib' => {
                default => undef,
                path    => 1,
                type    => 'ARRAY',
            },
            'EnableArchivePaths' => { default => 0, },
            'SearchTemplatePath' => {
                default => 'search_templates',
                path    => 1,
                type    => 'ARRAY',
            },
            'ContentDataSearchTemplatePath' => {
                default => sub { $_[0]->SearchTemplatePath }
            },
            'ThemesDirectory' => {
                default => 'themes',
                path    => 1,
                type    => 'ARRAY',
            },
            'SupportDirectoryPath' => { default => '', },
            'SupportDirectoryURL'  => { default => '' },
            'ObjectDriver'         => undef,
            'ObjectCacheLimit'     => { default => 1000 },
            'ObjectCacheDisabled'  => undef,
            'DisableObjectCache'   => { default => 0, },
            'AllowedTextFilters'   => undef,
            'Serializer'           => { default => 'MT', },
            'SendMailPath'         => { default => '/usr/lib/sendmail', },
            'RsyncPath'            => undef,
            'TimeOffset'           => { default => 0, },
            'WSSETimeout'          => { default => 120, },
            'StaticWebPath'        => { default => '', },
            'StaticFilePath'       => undef,
            'CGIPath'              => { default => '/cgi-bin/', },
            'AdminCGIPath'         => {
                default => sub { $_[0]->CGIPath }
            },
            'BaseSitePath'                   => undef,
            'BaseTemplatePath'               => { default => undef },
            'HideBaseSitePath'               => { default => 0, },
            'HidePerformanceLoggingSettings' => { default => 0, },
            'HidePaformanceLoggingSettings' =>
                { alias => 'HidePerformanceLoggingSettings' },
            'CookieDomain'          => undef,
            'CookiePath'            => undef,
            'MailModule'            => { default => 'MIME::Lite', },
            'MailEncoding'          => { default => 'UTF-8', },
            'MailTransfer'          => { default => 'sendmail' },
            'MailTransferEncoding'  => undef,
            'MailLogAlways'         => undef,
            'SMTPServer'            => { default => 'localhost', },
            'SMTPAuth'              => { default => 0, },
            'SMTPUser'              => undef,
            'SMTPPassword'          => undef,
            'SMTPPort'              => undef,
            'SMTPTimeout'           => { default => 10 },
            'SMTPSSLVerifyNone'     => undef,
            'SMTPSSLVersion'        => undef,
            'SMTPOptions'           => { type => 'HASH' },
            'SMTPAuthSASLMechanism' => undef,
            'FTPSSSLVerifyNone'     => undef,
            'FTPSSSLVersion'        => undef,

            # MTC-26629
            'FTPSOptions' => {
                type    => 'HASH',
                default => { ReuseSession => 1 }
            },
            'SSLVerifyNone'     => undef,
            'SSLVersion'        => undef,
            'DebugEmailAddress' => undef,
            'WeblogsPingURL' => { default => 'http://rpc.weblogs.com/RPC2', },
            'MTPingURL' =>
                { default => 'http://www.movabletype.org/update/', },
            'CGIMaxUpload' => {
                handler => \&CGIMaxUpload,
                default => 20_480_000,
            },
            'DBUmask'                => { default => '0111', },
            'HTMLUmask'              => { default => '0111', },
            'UploadUmask'            => { default => '0111', },
            'DirUmask'               => { default => '0000', },
            'HTMLPerms'              => { default => '0666', },
            'UploadPerms'            => { default => '0666', },
            'NoTempFiles'            => { default => 0, },
            'TempDir'                => { default => '/tmp', },
            'ExportTempDir'          => { default => undef },
            'RichTextEditor'         => { default => 'archetype', },
            'WYSIWYGEditor'          => undef,
            'SourceEditor'           => undef,
            'Editor'                 => { default => 'tinymce', },
            'EditorStrategy'         => { default => 'Multi', },
            'EntriesPerRebuild'      => { default => 40, },
            'UseNFSSafeLocking'      => { default => 0, },
            'NoLocking'              => { default => 0, },
            'NoHTMLEntities'         => { default => 1, },
            'NoCDATA'                => { default => 0, },
            'NoPlacementCache'       => { default => 0, },
            'NoPublishMeansDraft'    => { default => 0, },
            'IgnoreISOTimezones'     => { default => 0, },
            'PingTimeout'            => { default => 60, },
            'HTTPTimeout'            => { default => 60 },
            'PingInterface'          => undef,
            'HTTPInterface'          => undef,
            'PingProxy'              => undef,
            'HTTPProxy'              => undef,
            'HTTPSProxy'             => undef,
            'PingNoProxy'            => { default => 'localhost', },
            'HTTPNoProxy'            => { default => 'localhost', },
            'HeaderCacheControl'     => undef,
            'ImageDriver'            => { default => 'ImageMagick', },
            'ImageQualityJpeg'       => { default => 85 },
            'ImageQualityPng'        => { default => 7 },
            'AutoChangeImageQuality' => { default => 1 },
            'NetPBMPath'             => undef,
            'AdminScript'            => { default => 'mt.cgi', },
            'ActivityFeedScript'     => { default => 'mt-feed.cgi', },
            'ActivityFeedItemLimit'  => { default => 50, },
            'CommentScript'          => { default => 'mt-comments.cgi', },
            'TrackbackScript'        => { default => 'mt-tb.cgi', },
            'SearchScript'           => {
                default => 'mt-search.cgi',
                handler => \&SearchScript,
            },
            'FreeTextSearchScript'    => { default => 'mt-ftsearch.cgi', },
            'ContentDataSearchScript' => { default => 'mt-cdsearch.cgi' },
            'XMLRPCScript'            => { default => 'mt-xmlrpc.cgi', },
            'AtomScript'              => { default => 'mt-atom.cgi', },
            'UpgradeScript'           => { default => 'mt-upgrade.cgi', },
            'CheckScript'             => { default => 'mt-check.cgi', },
            'DataAPIScript'           => { default => 'mt-data-api.cgi', },
            'PublishCharset'          => { default => 'utf-8', },
            'SafeMode'                => { default => 1, },
            'AllowFileInclude'        => { default => 0, },
            'GlobalSanitizeSpec'      => {
                default =>
                    'a href,b,i,br/,p,strong,em,ul,ol,li,blockquote,pre',
            },
            'GenerateTrackBackRSS'                   => { default => 0, },
            'DBIRaiseError'                          => { default => 0, },
            'DBIShowErrorStatement'                  => { default => 0, },
            'SearchAlwaysAllowTemplateID'            => { default => 0, },
            'ContentDataSearchAlwaysAllowTemplateID' => {
                default => sub { $_[0]->SearchAlwaysAllowTemplateID }
            },
            'PreviewInNewWindow'  => { default => 1, },
            'BasenameCheckCompat' => { default => 0, },

            ## Search settings, copied from Jay's mt-search and integrated
            ## into default config.
            'NoOverride'              => { default => '', },
            'RegexSearch'             => { default => 0, },
            'CaseSearch'              => { default => 0, },
            'ResultDisplay'           => { default => 'descend', },
            'ExcerptWords'            => { default => 40, },
            'SearchElement'           => { default => 'entries', },
            'ExcludeBlogs'            => undef,
            'ContentDataExcludeBlogs' => {
                default => sub { $_[0]->ExcludeBlogs }
            },
            'IncludeBlogs'            => undef,
            'ContentDataIncludeBlogs' => {
                default => sub { $_[0]->IncludeBlogs }
            },
            'DefaultTemplate'     => { default => 'default.tmpl', },
            'Type'                => { default => 'straight', },
            'MaxResults'          => { default => '20', },
            'SearchCutoff'        => { default => '9999999', },
            'CommentSearchCutoff' => { default => '30', },
            'AltTemplate'         => {
                type    => 'ARRAY',
                default => 'feed results_feed.tmpl',
            },
            'SearchSortBy'            => undef,
            'ContentDataSearchSortBy' => {
                default => sub { $_[0]->SearchSortBy }
            },
            'SearchSortOrder'  => { default => 'ascend', },
            'SearchNoOverride' => { default => 'SearchMaxResults', },
            'ContentDataSearchNoOverride' => {
                default => sub { $_[0]->SearchNoOverride }
            },
            'SearchResultDisplay'            => { alias => 'ResultDisplay', },
            'ContentDataSearchResultDisplay' => {
                default => sub { $_[0]->SearchResultDisplay }
            },
            'SearchExcerptWords'    => { alias => 'ExcerptWords', },
            'SearchDefaultTemplate' => { alias => 'DefaultTemplate', },
            'ContentDataSearchDefaultTemplate' =>
                { default => 'content_data_default.tmpl' },
            'SearchMaxResults'            => { alias => 'MaxResults', },
            'ContentDataSearchMaxResults' => {
                default => sub { $_[0]->SearchMaxResults }
            },
            'SearchAltTemplate'            => { alias => 'AltTemplate' },
            'ContentDataSearchAltTemplate' => {
                type    => 'ARRAY',
                default => 'feed content_data_results_feed.tmpl',
            },
            'SearchPrivateTags'         => { default => 0 },
            'DeepCopyRecursiveLimit'    => { default => 2 },
            'BulkLoadMetaObjectsLimit'  => { default => 100 },
            'DisableMetaObjectCache'    => { default => 1, },
            'ReturnToURL'               => undef,
            'DynamicComments'           => { default => 0, },
            'SignOnPublicKey'           => { default => '', },
            'ThrottleSeconds'           => { default => 20, },
            'SearchCacheTTL'            => { default => 20, },
            'ContentDataSearchCacheTTL' => {
                default => sub { $_[0]->SearchCacheTTL }
            },
            'SearchThrottleSeconds'            => { default => 5 },
            'ContentDataSearchThrottleSeconds' => {
                default => sub { $_[0]->SearchThrottleSeconds }
            },
            'SearchThrottleIPWhitelist'            => undef,
            'ContentDataSearchThrottleIPWhitelist' => {
                default => sub { $_[0]->SearchThrottleIPWhitelist }
            },
            'SearchContentTypes' => undef,
            'CMSSearchLimit'     => { default => 125 },
            'OneHourMaxPings'    => { default => 10, },
            'OneDayMaxPings'     => { default => 50, },
            'SupportURL'         => {
                default => 'http://www.sixapart.com/movabletype/support/',
            },
            'NewsURL' =>
                { default => 'http://www.sixapart.com/movabletype/news/', },
            'NewsboxURL' => {
                default => 'https://www.movabletype.org/news/newsbox.json',
            },
            'FeedbackURL' => { default => 'http://www.movabletype.org/feedback.html', },

            'EmailAddressMain'         => undef,
            'EmailReplyTo'             => undef,
            'EmailNotificationBcc'     => { default => 1, },
            'CommentSessionTimeout'    => { default => 60 * 60 * 24 * 3, },
            'UserSessionTimeout'       => { default => 60 * 60 * 4, },
            'AutosaveSessionTimeout'   => { default => 60 * 60 * 24 * 30, },
            'UserSessionCookieName'    => { default => \&UserSessionCookieName },
            'UserSessionCookieDomain'  => { default => '<$MTBlogHost exclude_port="1"$>' },
            'UserSessionCookiePath'    => { default => \&UserSessionCookiePath },
            'UserSessionCookieTimeout' => { default => 60 * 60 * 4, },
            'MaxUserSession'           => { default => 10000 },
            'LaunchBackgroundTasks'    => { default => 0 },
            'TransparentProxyIPs'      => { default => 0, },
            'DebugMode'                => { default => 0, },
            'ShowIPInformation'        => { default => 0, },
            'AllowComments'            => { default => 1, },
            'AllowPings'               => { default => 1, },
            'HelpURL'                  => undef,

            #'HelpURL'               => {
            #    default => 'http://www.sixapart.com/movabletype/docs/4.0/',
            #},
            'UsePlugins'               => { default => 1, },
            'PluginAlias'              => { type    => 'HASH', },
            'PluginSwitch'             => { type    => 'HASH', },
            'PluginSchemaVersion'      => { type    => 'HASH', },
            'YAMLModule'               => { default => undef },
            'OutboundTrackbackLimit'   => { default => 'any', },
            'OutboundTrackbackDomains' => { type    => 'ARRAY', },
            'IndexBasename'            => { default => 'index', },
            'LogExportEncoding'        => { default => 'utf-8', },
            'ActivityFeedsRunTasks'    => { default => 1, },
            'ExportEncoding'           => { default => 'utf-8', },
            'SQLSetNames'              => undef,
            'UseSQLite2'               => { default => 0, },

            #'UseJcodeModule'  => { default => 0, },
            'DefaultTimezone'    => { default => '0', },
            'CategoryNameNodash' => { default => '0', },
            'DefaultListPrefs'   => { type    => 'HASH', },
            'DefaultEntryPrefs'  => {
                type    => 'HASH',
                default => {
                    type   => 'Default',    # Default|All|Custom
                    button => 'Below',      # Above|Below|Both
                    height => 162,          # textarea height
                },
            },
            'DeleteFilesAfterRebuild'   => { default => 0, },
            'DeleteFilesAtRebuild'      => { default => 1, },
            'RebuildAtDelete'           => { default => 1, },
            'MaxTagAutoCompletionItems' => { default => 1000, }, ## DEPRECATED
            'NewUserBlogTheme'        => undef,                  ## DEPRECATED
            'NewUserDefaultWebsiteId' => undef,                  ## DEPRECATED
            'NewUserTemplateBlogId'   => undef,                  ## DEPRECATED
            'DefaultSiteURL'          => undef,                  ## DEPRECATED
            'DefaultSiteRoot'         => undef,                  ## DEPRECATED
            'DefaultUserLanguage'     => undef,
            'DefaultUserTagDelimiter' => {
                handler => \&DefaultUserTagDelimiter,
                default => 'comma',
            },
            'UserPasswordValidation' => { type    => 'ARRAY', },
            'UserPasswordMinLength'  => { default => 8, },
            'AuthenticationModule'   => { default => 'MT', },
            'AuthLoginURL'           => undef,
            'AuthLogoutURL'          => undef,
            'DefaultAssignments'     => { default => '' },
            'AutoSaveFrequency'      => { default => 5 },
            'FuturePostFrequency'    => { default => 1 },
            'UnpublishPostFrequency' => { default => 1 },
            'AssetCacheDir'          => { default => 'assets_c', },
            'IncludesDir'            => { default => 'includes_c', },
            'MemcachedServers'       => { type    => 'ARRAY', },
            'MemcachedNamespace'     => undef,
            'MemcachedDriver'        => { default => 'Cache::Memcached' },
            'CommenterRegistration'  => {
                type    => 'HASH',
                default => {
                    Allow  => '1',
                    Notify => q(),
                },
            },
            'CaptchaSourceImageBase' => undef,
            'SecretToken'            => { default => \&SecretToken, },
            ## NaughtyWordChars settings
            'NwcSmartReplace' => { default => 0, },
            'NwcReplaceField' =>
                { default => 'title,text,text_more,keywords,excerpt,tags', },
            'DisableNotificationPings' => { default => 0 },
            'SyncTarget'               => { type    => 'ARRAY' },
            'RsyncOptions'             => undef,
            'UserpicAllowRect'         => { default => 0 },
            'UserpicMaxUpload'         => { default => 0 },
            'UserpicThumbnailSize'     => { default => 100 },

            ## Stats settings
            'StatsCacheTTL'        => { default => 15 },          # in minutes
            'StatsCachePublishing' => { default => 'OnLoad' },    # Off|OnLoad

            # Basename settings
            'AuthorBasenameLimit' => { default => 30 },
            'PerformanceLogging'  => { default => 0 },
            'PerformanceLoggingPath' =>
                { handler => \&PerformanceLoggingPath },
            'PerformanceLoggingThreshold' => { default => 0.1 },
            'ProcessMemoryCommand' => { default => \&ProcessMemoryCommand },
            'PublishCommenterIcon' => { default => 1 },
            'EnableAddressBook'    => { default => 0 },
            'SingleCommunity'      => { default => 1 },
            'DefaultTemplateSet'   => { default => 'mt_blog' },
            'DefaultWebsiteTheme'  => { default => 'mont-blanc' },
            'DefaultBlogTheme'     => { default => 'mont-blanc' },
            'ThemeStaticFileExtensions' => {
                default =>
                    'html jpg jpeg gif png js css ico flv swf otf ttf svg'
            },
            'AssetFileTypes'            => { type    => 'HASH' },
            'AssetFileExtensions'       => { default => undef },
            'DeniedAssetFileExtensions' => {
                default =>
                    q{ascx,asis,asp,aspx,bat,cfc,cfm,cgi,cmd,com,cpl,dll,exe,htaccess,htm,html,inc,jhtml,js,jsb,jsp,mht,mhtml,msi,php\d?,phps,phtm,phtml,pif,pl,pwml,py,reg,scr,sh,shtm,shtml,vbs,vxd,pm,so,rb,htc}
            },

            'FastCGIMaxTime'     => { default => 60 * 60 },    # 1 hour
            'FastCGIMaxRequests' => { default => 1000 },       # 1000 requests

            'RPTFreeMemoryLimit'      => undef,
            'RPTProcessCap'           => undef,
            'RPTSwapMemoryLimit'      => undef,
            'SchwartzClientDeadline'  => undef,
            'SchwartzFreeMemoryLimit' => undef,
            'SchwartzSwapMemoryLimit' => undef,

            # Revision History
            'TrackRevisions'    => { default => 1 },
            'RevisioningDriver' => { default => 'Local' },

            # User Lockout
            'UserLockoutLimit'               => { default => 6 },
            'UserLockoutInterval'            => { default => 1800 },
            'IPLockoutLimit'                 => { default => 10 },
            'IPLockoutInterval'              => { default => 1800 },
            'FailedLoginExpirationFrequency' => { default => 86400 },
            'LockoutExpireFrequency' =>
                { alias => 'FailedLoginExpirationFrequency' },
            'LockoutIPWhitelist' => undef,
            'LockoutNotifyTo'    => undef,

            # DataAPI
            'AccessTokenTTL'          => { default => 60 * 60, },
            'DataAPICORSAllowOrigin'  => { default => undef },
            'DataAPICORSAllowMethods' => { default => '*' },
            'DataAPICORSAllowHeaders' =>
                { default => 'X-MT-Authorization, X-Requested-With' },
            'DataAPICORSExposeHeaders' =>
                { default => 'X-MT-Next-Phase-URL' },
            'DisableResourceField' => {
                type    => 'HASH',
                default => {}
            },
            'DataAPIDisableSite'   => undef,
            'RebuildOffsetSeconds' => { default => 20 },

            # Enterprise.pack
            'LDAPOptions'           => { type => 'HASH' },
            'LDAPAuthURL'           => { type => 'ARRAY' },
            'LDAPAuthBindDN'        => { type => 'ARRAY' },
            'LDAPAuthPassword'      => { type => 'ARRAY' },
            'LDAPAuthSASLMechanism' => {
                default => 'PLAIN',
                type    => 'ARRAY',
            },
            'LDAPUserSearchBase'    => { type  => 'ARRAY' },
            'LDAPGroupSearchBase'   => { type  => 'ARRAY' },
            'AuthLDAPURL'           => { alias => 'LDAPAuthURL' },
            'AuthLDAPBindDN'        => { alias => 'LDAPAuthBindDN' },
            'AuthLDAPPassword'      => { alias => 'LDAPAuthPassword' },
            'AuthLDAPSASLMechanism' => { alias => 'LDAPAuthSASLMechanism' },

            'RestrictedPSGIApp' => { type    => 'ARRAY' },
            'XFrameOptions'     => { default => 'SAMEORIGIN' },
            'XXSSProtection'    => undef,
            'ReferrerPolicy'    => undef,
            'DynamicCacheTTL'   => { default => 0 },

            # Activity logging
            'LoggerLevel'    => { default => 'info' },
            'LoggerPath'     => undef,
            'LoggerModule'   => undef,
            'LoggerFileName' => undef,
            'LoggerConfig'   => undef,

            # Notification Center
            'NotificationCacheTTL' => { default => 3600 },

            # Dashboard
            'DisableVersionCheck' => undef,

            # Content Field Type - MT7
            'NumberFieldDecimalPlaces' => { default => 5 },
            'NumberFieldMaxValue'      => { default => 2147483647 },
            'NumberFieldMinValue'      => { default => -2147483648 },

            # RebuildTrigger - MT7
            'DefaultAccessAllowed' => { default => 1 },
            'AccessOverrides'      => undef,

            'JSONCanonicalization' => { default => 1 },
            'UseMTCommonJSON'      => { default => 0 },
            'UseSVGForEverybody'   => { default => 0 },
            'UseJQueryJSON'        => { default => 0 },

            'RequiredUserEmail'       => { default => 1 },
            'DefaultClassParamFilter' => { default => 'all' },

            'UseTraditionalTransformer' => undef,
            'DisableValidateParam'      => undef,
            'UseExternalArchiver' => undef,
            'BinTarPath' => undef,
            'BinZipPath' => undef,
            'BinUnzipPath' => undef,

            'MaxFavoriteSites' => { default => 5 },
            'DisableImagePopup' => undef,
            'ForceExifRemoval' => { default => 1 },
            'TemporaryFileExpiration' => { default => 60 * 60 },
            'PSGIStreaming' => { default => 1 },
            'PSGIServeStatic' => { default => 1 },
            'HideVersion' => { default => 1 },
            'HideConfigWarnings' => { default => undef },
            'GlobalTemplateMaxRevisions' => { default => 20 },
            'DisableQuickPost' => { default => 0 },
            'DisableActivityFeeds' => { default => 0 },
            'DefaultStatsProvider' => { default => 'GoogleAnalyticsV4' },
            'DefaultListLimit' => { default => '50' },
            'WaitAfterReboot' => { default => '1.0' },
            'DisableMetaRefresh' => { default => 1 },
            'DynamicTemplateAllowPHP' => { default => 1 },
        },
        upgrade_functions => \&load_upgrade_fns,
        applications      => {
            'xmlrpc' => {
                handler => 'MT::XMLRPCServer',
                script  => sub { MT->config->XMLRPCScript },
                type    => 'xmlrpc',
            },
            'atom' => {
                handler => 'MT::AtomServer',
                script  => sub { MT->config->AtomScript },
                type    => 'run_once',
            },
            'feeds' => {
                handler => 'MT::App::ActivityFeeds',
                script  => sub { MT->config->ActivityFeedScript },
            },
            'wizard' => {
                handler => 'MT::App::Wizard',
                script  => sub {'mt-wizard.cgi'},
                type    => 'run_once',
            },
            'check' => {
                script => sub { MT->config->CheckScript },
                type   => 'run_once',
            },
            'new_search' => {
                handler => 'MT::App::Search',
                script  => sub { MT->config->SearchScript },
                tags    => sub {
                    require MT::Template::Context::Search;
                    return MT::Template::Context::Search->load_core_tags();
                },
                methods => sub { MT->app->core_methods() },
                default => sub { MT->app->core_parameters() },
            },
            'ft_search' => {
                handler => 'MT::App::Search::FreeText',
                script  => sub { MT->config->FreeTextSearchScript },
                tags    => sub {
                    require MT::Template::Context::Search;
                    return MT::Template::Context::Search->load_core_tags();
                },
                methods => sub { MT->app->core_methods() },
                default => sub { MT->app->core_parameters() },
            },
            'cd_search' => {
                handler => 'MT::App::Search::ContentData',
                script  => sub { MT->config->ContentDataSearchScript },
                tags    => sub {
                    require MT::Template::Context::Search;
                    return MT::Template::Context::Search->load_core_tags();
                },
                methods => sub { MT->app->core_methods() },
                default => sub { MT->app->core_parameters() },
            },
            'cms' => {
                handler         => 'MT::App::CMS',
                type            => 'psgi_streaming',
                script          => sub { MT->config->AdminScript },
                cgi_path        => sub { MT->config->AdminCGIPath },
                cgi_base        => 'mt',
                page_actions    => sub { MT->app->core_page_actions(@_) },
                content_actions => sub { MT->app->core_content_actions(@_) },
                list_actions    => sub { MT->app->core_list_actions(@_) },
                menu_actions    => sub { MT->app->core_menu_actions(@_) },
                user_actions    => sub { MT->app->core_user_actions(@_) },
                search_apis     => sub {
                    require MT::CMS::Search;
                    return MT::CMS::Search::core_search_apis( MT->app, @_ );
                },
                menus          => sub { MT->app->core_menus() },
                methods        => sub { MT->app->core_methods() },
                widgets        => sub { MT->app->core_widgets() },
                import_formats => sub {
                    require MT::Import;
                    return MT::Import->core_import_formats();
                },
                compose_menus => sub { MT->app->core_compose_menus() },
                user_menus    => sub { MT->app->core_user_menus() },
                enable_object_methods =>
                    sub { MT->app->core_enable_object_methods() },
                site_stats_lines =>
                    sub { MT::CMS::Dashboard->site_stats_widget_lines() },
            },
            upgrade => {
                handler => 'MT::App::Upgrader',
                methods => '$Core::MT::App::Upgrader::core_methods',
                script  => sub { MT->config->UpgradeScript },
                type    => 'run_once',
            },
            'data_api' => {
                handler   => 'MT::App::DataAPI',
                script    => sub { MT->config->DataAPIScript },
                methods   => sub { MT->app->core_methods() },
                endpoints => sub { MT->app->core_endpoints() },
                resources => sub { MT::DataAPI::Resource->core_resources() },
                formats   => sub { MT::DataAPI::Format->core_formats() },
                default_format => 'json',
                query_builder =>
                    '$Core::MT::DataAPI::Endpoint::Common::query_builder',

                # This is for search endpoint.
                default        => sub { MT->app->core_parameters() },
                import_formats => sub {
                    require MT::Import;
                    return MT::Import->core_import_formats();
                },
            },
        },
        web_services    => undef,
        stats_providers => undef,
        archive_types   => \&load_archive_types,
        tags            => \&load_core_tags,
        text_filters    => {
            '__default__' => {
                label   => 'Convert Line Breaks',
                handler => sub {
                    MT->config->UseTraditionalTransformer
                        ? MT::Util::html_text_transform_traditional(@_)
                        : MT::Util::html_text_transform(@_);
                }
            },
            'richtext' => {
                label     => 'Rich Text',
                handler   => 'MT::Util::rich_text_transform',
                condition => sub {
                    my ($type) = @_;
                    return 1 if $type && ( $type ne 'comment' );
                },
            },
        },
        richtext_editors => {
            'archetype' => {
                label    => 'Movable Type Default',
                template => 'archetype_editor.tmpl',
            },
        },
        commenter_authenticators => \&load_core_commenter_auth,
        captcha_providers        => \&load_captcha_providers,
        tasks                    => \&load_core_tasks,
        default_templates        => \&load_default_templates,
        template_sets            => {
            mt_blog => {
                label => "Classic Blog",
                order => 100,

                # means, load from 'default_templates' registry
                # which we've established for core templates with
                # the MT 4.0 registry
                templates => '*',
            },
        },
        theme_element_handlers =>
            '$Core::MT::Theme::core_theme_element_handlers',
        junk_filters => \&load_junk_filters,
        task_workers => {
            'mt_rebuild' => {
                label => "Publishes content.",
                class => 'MT::Worker::Publish',
            },
            'mt_sync' => {
                label => "Synchronizes content to other server(s).",
                class => 'MT::Worker::Sync',
            },
            'mt_summarize' => {
                label => "Refreshes object summaries.",
                class => 'MT::Worker::Summarize',
            },
            'mt_summary_watcher' => {
                label => "Adds Summarize workers to queue.",
                class => 'MT::Worker::SummaryWatcher',
            }
        },
        archivers => {
            'zip' => {
                class     => 'MT::Util::Archive::Zip',
                label     => 'zip',
                extension => 'zip',
                mimetype  => 'application/zip',
            },
            'tgz' => {
                class     => 'MT::Util::Archive::Tgz',
                label     => 'tar.gz',
                extension => 'tar.gz',
                mimetype  => 'application/x-tar-gz',
            },
        },
        template_snippets => {
            'insert_entries' => {
                trigger => 'entries',
                label   => 'Entries List',
                content =>
                    qq{<mt:Entries lastn="10">\n    \$0\n</mt:Entries>\n},
            },
            'blog_url' => {
                trigger => 'blogurl',
                label   => 'Blog URL',
                content => '<$mt:BlogURL$>$0',
            },
            'blog_id' => {
                trigger => 'blogid',
                label   => 'Blog ID',
                content => '<$mt:BlogID$>$0',
            },
            'blog_name' => {
                trigger => 'blogname',
                label   => 'Blog Name',
                content => '<$mt:BlogName$>$0',
            },
            'entry_body' => {
                trigger => 'entrybody',
                label   => 'Entry Body',
                content => '<$mt:EntryBody$>$0',
            },
            'entry_excerpt' => {
                trigger => 'entryexcerpt',
                label   => 'Entry Excerpt',
                content => '<$mt:EntryExcerpt$>$0',
            },
            'entry_link' => {
                trigger => 'entrylink',
                label   => 'Entry Link',
                content => '<$mt:EntryLink$>$0',
            },
            'entry_more' => {
                trigger => 'entrymore',
                label   => 'Entry Extended Text',
                content => '<$mt:EntryMore$>$0',
            },
            'entry_title' => {
                trigger => 'entrytitle',
                label   => 'Entry Title',
                content => '<$mt:EntryTitle$>$0',
            },
            'if' => {
                trigger => 'mtif',
                label   => 'If Block',
                content => qq{<mt:if name="variable">\n    \$0\n</mt:if>\n},
            },
            'if_else' => {
                trigger => 'mtife',
                label   => 'If/Else Block',
                content =>
                    qq{<mt:if name="variable">\n    \$0\n<mt:else>\n\n</mt:if>\n},
            },
            'include_module' => {
                trigger => 'module',
                label   => 'Include Template Module',
                content => '<$mt:Include module="$0"$>',
            },
            'include_file' => {
                trigger => 'file',
                label   => 'Include Template File',
                content => '<$mt:Include file="$0"$>',
            },
            'getvar' => {
                trigger => 'get',
                label   => 'Get Variable',
                content => '<$mt:var name="$0"$>',
            },
            'setvar' => {
                trigger => 'set',
                label   => 'Set Variable',
                content => '<$mt:var name="$0" value="value"$>',
            },
            'setvarblock' => {
                trigger => 'setb',
                label   => 'Set Variable Block',
                content =>
                    qq{<mt:SetVarBlock name="variable">\n    \$0\n</mt:SetVarBlock>\n},
            },
            'widget_manager' => {
                trigger => 'widget',
                label   => 'Widget Set',
                content => '<$mt:WidgetSet name="$0"$>',
            },
        },
        content_field_types =>
            '$Core::MT::ContentFieldType::core_content_field_types',
    };
}

sub id {
    return 'core';
}

sub load_junk_filters {
    require MT::JunkFilter;
    return MT::JunkFilter->core_filters;
}

sub load_core_tasks {
    my $cfg = MT->config;
    return {
        'FuturePost' => {
            label     => 'Publish Scheduled Entries',
            frequency => $cfg->FuturePostFrequency * 60,    # once per minute
            code      => sub {
                MT->instance->publisher->publish_future_posts;
            }
        },
        'UnpublishingPost' => {
            label     => 'Unpublish Past Entries',
            frequency => $cfg->UnpublishPostFrequency * 60,  # once per minute
            code      => sub {
                MT->instance->publisher->unpublish_past_entries;
            }
        },
        'FutureContent' => {
            label     => 'Publish Scheduled Contents',
            frequency => $cfg->FuturePostFrequency * 60,     # once per minute
            code      => sub {
                MT->instance->publisher->publish_future_contents;
            }
        },
        'UnpublishingContent' => {
            label     => 'Unpublish Past Contents',
            frequency => $cfg->UnpublishPostFrequency * 60,  # once per minute
            code      => sub {
                MT->instance->publisher->unpublish_past_contents;
            }
        },
        'AddSummaryWatcher' => {
            label     => 'Add Summary Watcher to queue',
            frequency => 2 * 60,                          # every other minute
            code      => sub {
                require MT::TheSchwartz;
                require TheSchwartz::Job;
                my $job = TheSchwartz::Job->new();
                $job->funcname('MT::Worker::SummaryWatcher');
                $job->uniqkey(1);
                $job->priority(4);
                MT::TheSchwartz->insert($job);
                return;
            },
        },
        'JunkExpiration' => {
            label => 'Junk Folder Expiration',
            frequency => 12 * 60 * 60,    # no more than every 12 hours
            code      => sub {
                require MT::JunkFilter;
                MT::JunkFilter->task_expire_junk;
            },
        },
        'CleanTemporaryFiles' => {
            label     => 'Remove Temporary Files',
            frequency => $cfg->TemporaryFileExpiration,   # once per hour by default
            code      => sub {
                MT::Core->remove_temporary_files;
            },
        },
        'PurgeExpiredSessionRecords' => {
            label => 'Purge Stale Session Records',
            frequency => 60,     # * 60 * 24,   # once a day
            code      => sub {
                MT::Core->purge_session_records;
            }
        },
        'PurgeExpiredDataAPISessionRecords' => {
            label => 'Purge Stale DataAPI Session Records',
            frequency => 60,     # * 60 * 24,   # once a day
            code      => sub {
                require MT::App::DataAPI;
                MT::App::DataAPI->purge_session_records;
            }
        },
        'CleanExpiredFailedLogin' => {
            label     => 'Remove expired lockout data',
            frequency => $cfg->FailedLoginExpirationFrequency,
            code      => sub {
                my $app = MT->instance;
                $app->model('failedlogin')->cleanup($app);
            }
        },
        'CleanFileInfoRecords' => {
            label     => 'Purge Unused FileInfo Records',
            frequency => 60 * 60 * 24,                      # once a day
            code      => sub {
                my $app = MT->instance;
                $app->model('fileinfo')->cleanup;
            }
        },
        'CleanCompiledTemplateFiles' => {
            label     => 'Remove Compiled Template Files',
            frequency => 60 * 60,                            # once per hour
            code      => sub {
                MT::Core->remove_compiled_template_files;
            }
        },
    };
}

sub remove_compiled_template_files {
    my $ttl = MT->config->DynamicCacheTTL;
    return '' if !$ttl;

    require MT::FileMgr;
    my $fmgr = MT::FileMgr->new('Local');

    my @compile_dirs;

    # Load all website
    my $iter = MT->model('blog')->load_iter( { class => '*' } );
    while ( my $blog = $iter->() ) {
        push @compile_dirs,
            File::Spec->catdir( $blog->site_path, 'templates_c' );
    }

    foreach my $dir (@compile_dirs) {
        my $compile_glob = File::Spec->catfile( $dir, "*.php" );
        my @files = glob($compile_glob);
        foreach my $file (@files) {
            my $mod_time = $fmgr->file_mod_time($file);
            if ( $ttl < time - $mod_time ) {
                $fmgr->delete($file);
            }
        }
    }

}

sub remove_temporary_files {
    require MT::Session;

    my $expiration = MT->config->TemporaryFileExpiration;

    my @files
        = MT::Session->load(
        { kind => 'TF', start => [ undef, time - $expiration ] },
        { range => { start => 1 } } );
    my $fmgr = MT::FileMgr->new('Local');
    my @ids;
    foreach my $f (@files) {
        if ( $fmgr->delete( $f->name ) ) {
            push @ids, $f->id;
        }
    }
    return unless @ids;
    MT::Session->remove({id => \@ids});

    # This is a silent task; no need to log removal of temporary files
    return '';
}

sub purge_user_session_records {
    my ( $kind, $timeout ) = @_;

    my $iter = MT::Session->load_iter(
        {   kind  => $kind,
            start => [ undef, time - $timeout ],
        },
        { range => { start => 1 } }
    );

    my @ids = ();
    while ( my $s = $iter->() ) {
        push @ids, $s->id unless $s->get('remember');
    }

    return unless @ids;
    MT::Session->remove( { id => \@ids } );
}

sub purge_session_records {
    require MT::Session;

    # remove expired user sessions
    purge_user_session_records( 'US', MT->config->UserSessionTimeout );

    # remove stale search cache
    MT::Session->remove( { kind => 'CS', start => [ undef, time - 60 * 60 ] },
        { range => { start => 1 } } );

    # remove autosave sessions
    MT::Session->remove( { kind => 'AS', start => [ undef, time - MT->config->AutosaveSessionTimeout ] },
        { range => { start => 1 } } );

    # remove all the other session records
    # that have their duration expired
    MT::Session->purge();

    return '';
}

sub load_default_templates {
    require MT::DefaultTemplates;
    return MT::DefaultTemplates->core_default_templates;
}

sub load_captcha_providers {
    return MT->core_captcha_providers;
}

sub load_core_commenter_auth {
    return MT->core_commenter_authenticators;
}

sub load_core_tags {
    require MT::Template::ContextHandlers;
    return MT::Template::Context::core_tags();
}

sub load_upgrade_fns {
    require MT::Upgrade;
    require MT::Upgrade::Core;
    return MT::Upgrade::Core->upgrade_functions;
}

sub load_backup_instructions {
    require MT::BackupRestore;
    return MT::BackupRestore::core_backup_instructions();
}

sub load_core_permissions {
    require MT::ContentType;
    my @content_type_permissions
        = eval { keys %{ MT->app->model('content_type')->all_permissions } };
    if ( $@ && $MT::DebugMode ) {
        warn "An error occurred when loading the content_type class: $@";
    }

    return {
        'blog.administer_site' => {
            'group'        => 'blog_admin',
            'label'        => 'Manage Sites',
            'order'        => 100,
            'inherit_from' => [
                'blog.comment',              'blog.create_post',
                'blog.edit_all_posts',       'blog.edit_assets',
                'blog.edit_categories',      'blog.edit_config',
                'blog.edit_notifications',   'blog.edit_tags',
                'blog.edit_templates',       'blog.manage_pages',
                'blog.manage_users',         'blog.publish_post',
                'blog.rebuild',              'blog.send_notifications',
                'blog.set_publish_paths',    'blog.upload',
                'blog.view_blog_log',        'blog.manage_feedback',
                'blog.manage_themes',        'blog.create_site',
                'blog.manage_category_set',  'blog.manage_content_data',
                'blog.manage_content_types', @content_type_permissions
            ],
            'permitted_action' => {

                # administer_website
                'save_all_settings_for_website' => 1,
                'access_to_website_list'        => 1,
                'administer_website'            => 1,
                'clone_blog'                    => 1,
                'delete_website'                => 1,

                # administer_blog
                'access_to_blog_association_list'  => 1,
                'access_to_member_list'            => 1,
                'access_to_blog_list'              => 1,
                'access_to_log_list'               => 1,
                'administer_blog'                  => 1,
                'backup_blog'                      => 1,
                'backup_download'                  => 1,
                'create_association'               => 1,
                'delete_association'               => 1,
                'delete_blog'                      => 1,
                'get_blog_feed'                    => 1,
                'get_system_feed'                  => 1,
                'grant_administer_role'            => 1,
                'import_blog_with_authors'         => 1,
                'open_blog_export_screen'          => 1,
                'remove_administer_member'         => 1,
                'remove_administrator_association' => 1,
                'reset_plugin_setting'             => 1,
                'revoke_administer_role'           => 1,
                'save_all_settings_for_blog'       => 1,
                'save_plugin_setting'              => 1,
                'search_authors'                   => 1,
                'search_members'                   => 1,
                'start_backup'                     => 1,
                'start_restore'                    => 1,
                'use_tools:search'                 => 1,

                'remove_user_assoc'            => 1,
                'administer_site'              => 1,
                'manage_member_blogs'          => 1,
                'open_blog_listing_screen'     => 1,
                'open_all_blog_listing_screen' => 1,
            }
        },
        'blog.administer_website' => {
            'group'   => 'blog_admin',
            'label'   => 'Manage Website',
            'order'   => 100,
            'display' => 0,
        },
        'blog.administer_blog' => {
            'group'   => 'blog_admin',
            'label'   => 'Manage Blog',
            'order'   => 100,
            'display' => 0,
        },
        'blog.manage_member_blogs' => {
            'group'   => 'blog_admin',
            'label'   => 'Manage Website with Blogs',
            'order'   => 100,
            'display' => 0,
        },
        'blog.create_site' => {
            'group'            => 'blog_admin',
            'label'            => 'Create Sites',
            'order'            => 200,
            'permitted_action' => {
                'create_blog'                  => 1,
                'create_new_blog'              => 1,
                'use_blog:create_menu'         => 1,
                'edit_new_blog_config'         => 1,
                'open_new_blog_screen'         => 1,
                'set_new_blog_publish_paths'   => 1,
                'use_tools:search'             => 1,
                'create_site'                  => 1,
                'open_blog_listing_screen'     => 1,
                'open_all_blog_listing_screen' => 1,
            }
        },
        'blog.comment' => {
            'group' => 'blog_comment',
            'label' => 'Post Comments',
            'order' => 100,
        },
        'blog.create_post' => {
            'group'            => 'auth_pub',
            'label'            => 'Create Entries',
            'order'            => 100,
            'permitted_action' => {
                'access_to_insert_asset_list'           => 1,
                'access_to_atom_server'                 => 1,
                'access_to_entry_list'                  => 1,
                'access_to_new_entry_editor'            => 1,
                'create_new_entry'                      => 1,
                'create_new_entry_via_xmlrpc_server'    => 1,
                'create_post'                           => 1,
                'edit_own_entry'                        => 1,
                'edit_own_unpublished_entry'            => 1,
                'get_blog_info_via_atom_server'         => 1,
                'get_blog_info_via_xmlrpc_server'       => 1,
                'get_categories_via_xmlrpc_server'      => 1,
                'get_category_list_via_xmlrpc_server'   => 1,
                'get_entries_via_xmlrpc_server'         => 1,
                'get_post_categories_via_xmlrpc_server' => 1,
                'get_tag_list_via_xmlrpc_server'        => 1,
                'insert_asset'                          => 1,
                'open_existing_own_entry_screen'        => 1,
                'open_new_entry_screen'                 => 1,
                'view_feedback'                         => 1,
                'use_entry:manage_menu'                 => 1,
                'use_tools:search'                      => 1,
                'get_entry_feed'                        => 1,
                'add_tags_to_entry_via_list'            => 1,
                'remove_tags_from_entry_via_list'       => 1,
                'edit_entry_authored_on'                => 1,
                'edit_entry_unpublished_on'             => 1,
                'save_edit_prefs'                       => 1,
                'view_thumbnail_image'                  => 1,
            }
        },
        'blog.edit_all_posts' => {
            'group'            => 'auth_pub',
            'inherit_from'     => ['blog.manage_feedback'],
            'label'            => 'Edit All Entries',
            'order'            => 400,
            'permitted_action' => {
                'access_to_entry_list'             => 1,
                'add_tags_to_entry_via_list'       => 1,
                'edit_all_entries'                 => 1,
                'edit_all_posts'                   => 1,
                'edit_all_published_entry'         => 1,
                'edit_all_unpublished_entry'       => 1,
                'handle_junk'                      => 1,
                'handle_not_junk'                  => 1,
                'list_asset'                       => 1,
                'load_next_scheduled_entry'        => 1,
                'open_batch_entry_editor_via_list' => 1,
                'publish_all_entry'                => 1,
                'remove_tags_from_entry_via_list'  => 1,
                'set_entry_draft_via_list'         => 1,
                'use_entry:manage_menu'            => 1,
                'use_tools:search'                 => 1,
                'get_entry_feed'                   => 1,
                'save_multiple_entries'            => 1,
                'open_select_author_dialog'        => 1,
                'insert_asset'                     => 1,
                'access_to_insert_asset_list'      => 1,
                'save_edit_prefs'                  => 1,
                'view_thumbnail_image'             => 1,
            }
        },
        'blog.edit_assets' => {
            'group'            => 'blog_upload',
            'inherit_from'     => ['blog.upload'],
            'label'            => 'Manage Assets',
            'order'            => 200,
            'permitted_action' => {
                'access_to_asset_list'             => 1,
                'add_tags_to_assets'               => 1,
                'add_tags_to_assets_via_list'      => 1,
                'delete_asset'                     => 1,
                'delete_asset_file'                => 1,
                'edit_assets'                      => 1,
                'open_asset_edit_screen'           => 1,
                'view_thumbnail_image'             => 1,
                'remove_tags_from_assets'          => 1,
                'remove_tags_from_assets_via_list' => 1,
                'save_asset'                       => 1,
                'use_tools:search'                 => 1,
                'search_assets'                    => 1,
            }
        },
        'blog.edit_categories' => {
            'group'            => 'blog_admin',
            'label'            => 'Manage Categories',
            'order'            => 400,
            'permitted_action' => {
                'access_to_category_list'   => 1,
                'delete_category'           => 1,
                'edit_categories'           => 1,
                'open_category_edit_screen' => 1,
                'save_category'             => 1,
            }
        },
        'blog.edit_config' => {
            'group'            => 'blog_admin',
            'label'            => 'Change Settings',
            'order'            => 300,
            'permitted_action' => {
                'access_to_blog_config_screen' => 1,
                'access_to_blog_list'          => 1,
                'edit_blog_config'             => 1,
                'edit_config'                  => 1,
                'edit_junk_auto_delete'        => 1,
                'export_blog'                  => 1,
                'import_blog'                  => 1,
                'import_blog_as_me'            => 1,
                'load_next_scheduled_entry'    => 1,
                'open_blog_config_screen'      => 1,
                'open_start_import_screen'     => 1,
                'save_blog_config'             => 1,
            }
        },
        'blog.edit_notifications' => {
            'group'            => 'blog_admin',
            'label'            => 'Manage Address Book',
            'order'            => 500,
            'permitted_action' => {
                'access_to_notification_list' => 1,
                'edit_notifications'          => 1,
                'export_addressbook'          => 1,
                'save_addressbook'            => 1,
                'delete_addressbook'          => 1,
            }
        },
        'blog.edit_tags' => {
            'group'            => 'blog_admin',
            'label'            => 'Manage Tags',
            'order'            => 600,
            'permitted_action' => {
                'access_to_tag_list' => 1,
                'edit_tags'          => 1,
                'remove_tag'         => 1,
                'rename_tag'         => 1,
            }
        },
        'blog.edit_templates' => {
            'group'            => 'blog_design',
            'label'            => 'Manage Templates',
            'order'            => 100,
            'permitted_action' => {
                'access_to_template_list'   => 1,
                'copy_template_via_list'    => 1,
                'edit_templates'            => 1,
                'refresh_template_via_list' => 1,
                'search_templates'          => 1,
                'use_tools:search'          => 1,
                'refresh_templates'         => 1,
                'save_template_prefs'       => 1,
            }
        },

        'blog.manage_feedback' => {
            'group'            => 'blog_comment',
            'label'            => 'Manage Feedback',
            'order'            => 200,
            'permitted_action' => {
                'delete_junk_feedbacks'   => 1,
                'handle_junk'             => 1,
                'handle_not_junk'         => 1,
                'open_blog_config_screen' => 1,
                'save_banlist'            => 1,
                'delete_banlist'          => 1,
                'view_feedback'           => 1,
                'access_to_banlist'       => 1,
                'use_tools:search'        => 1,
                'manage_feedback'         => 1,
            }
        },
        'blog.manage_content_types' => {
            group              => 'blog_design',
            label              => 'Manage Content Types',
            order              => 300,
            'permitted_action' => {
                'create_new_content_type'     => 1,
                'delete_content_type'         => 1,
                'edit_all_content_types'      => 1,
                'edit_own_content_type'       => 1,
                'manage_content_types'        => 1,
                'save_multiple_content_type'  => 1,
                'access_to_content_type_list' => 1,
            }
        },
        'blog.manage_content_data' => {
            group            => 'auth_pub',
            label            => 'Manage All Content Data',
            order            => 700,
            permitted_action => {
                'access_to_content_data_list'             => 1,
                'add_tags_to_content_data_via_list'       => 1,
                'create_new_content_data'                 => 1,
                'edit_all_content_data'                   => 1,
                'edit_all_published_content_data'         => 1,
                'edit_all_unpublished_content_data'       => 1,
                'handle_junk'                             => 1,
                'handle_not_junk'                         => 1,
                'list_asset'                              => 1,
                'load_next_scheduled_content_data'        => 1,
                'open_batch_content_data_editor_via_list' => 1,
                'publish_all_content_data'                => 1,
                'remove_tags_from_content_data_via_list'  => 1,
                'set_content_data_draft_via_list'         => 1,
                'use_content_data:manage_menu'            => 1,
                'get_content_data_feed'                   => 1,
                'save_multiple_content_data'              => 1,
                'open_select_author_dialog'               => 1,
                'insert_asset'                            => 1,
                'access_to_insert_asset_list'             => 1,
                'manage_content_data'                     => 1,
                'use_tools:search'                        => 1,
                'view_thumbnail_image'                    => 1,
            },
        },
        'blog.manage_pages' => {
            'group'            => 'auth_pub',
            'label'            => 'Manage Pages',
            'order'            => 500,
            'permitted_action' => {
                'access_to_insert_asset_list'     => 1,
                'access_to_folder_list'           => 1,
                'access_to_page_list'             => 1,
                'add_tags_to_pages_via_list'      => 1,
                'create_new_page'                 => 1,
                'delete_folder'                   => 1,
                'delete_page'                     => 1,
                'edit_all_pages'                  => 1,
                'edit_own_page'                   => 1,
                'get_page_feed'                   => 1,
                'manage_pages'                    => 1,
                'open_batch_page_editor_via_list' => 1,
                'open_folder_edit_screen'         => 1,
                'open_page_edit_screen'           => 1,
                'remove_tags_from_pages_via_list' => 1,
                'save_folder'                     => 1,
                'save_multiple_pages'             => 1,
                'save_page'                       => 1,
                'set_page_draft_via_list'         => 1,
                'use_tools:search'                => 1,
                'open_blog_listing_screen'        => 1,
                'publish_page_via_list'           => 1,
                'open_select_author_dialog'       => 1,
                'insert_asset'                    => 1,
                'edit_page_basename'              => 1,
                'edit_page_authored_on'           => 1,
                'edit_page_unpublished_on'        => 1,
                'save_edit_prefs'                 => 1,
                'view_thumbnail_image'            => 1,
            }
        },
        'blog.manage_users' => {
            'group'            => 'blog_admin',
            'label'            => 'Manage Users',
            'order'            => 700,
            'permitted_action' => {
                'access_to_blog_member_list' => 1,
                'grant_role_for_blog'        => 1,
                'manage_users'               => 1,
                'search_members'             => 1,
                'search_authors'             => 1,
                'remove_user_assoc'          => 1,
                'revoke_role'                => 1,
                'use_tools:search'           => 1,
            }
        },
        'blog.manage_themes' => {
            'group'            => 'blog_design',
            'label'            => 'Manage Themes',
            'order'            => 200,
            'permitted_action' => {
                'use_design:themes_menu'     => 1,
                'use_tools:themeexport_menu' => 1,
                'open_theme_listing_screen'  => 1,
                'apply_theme'                => 1,
                'open_theme_export_screen'   => 1,
                'do_export_theme'            => 1,
                'refresh_templates'          => 1.
            },
        },
        'blog.publish_post' => {
            'group'            => 'auth_pub',
            'inherit_from'     => ['blog.create_post'],
            'label'            => 'Publish Entries',
            'order'            => 200,
            'permitted_action' => {
                'publish_entry_via_list'             => 1,
                'edit_entry_basename'                => 1,
                'edit_own_published_entry'           => 1,
                'handle_junk_for_own_entry'          => 1,
                'handle_not_junk_for_own_entry'      => 1,
                'load_next_scheduled_entry'          => 1,
                'publish_entry_via_xmlrpc_server'    => 1,
                'publish_new_post_via_atom_server'   => 1,
                'publish_new_post_via_xmlrpc_server' => 1,
                'publish_own_entry'                  => 1,
                'publish_post'                       => 1,
                'set_entry_draft_via_list'           => 1,
                'use_tools:search'                   => 1,
            }
        },
        'blog.rebuild' => {
            'group'            => 'auth_pub',
            'label'            => 'Publish Site',
            'order'            => 600,
            'permitted_action' => {
                'rebuild'                       => 1,
                'publish_entry_via_list'        => 1,
                'publish_content_data_via_list' => 1,
            }
        },
        'blog.send_notifications' => {
            'group'            => 'auth_pub',
            'inherit_from'     => ['blog.create_post'],
            'label'            => 'Send Notifications',
            'order'            => 300,
            'permitted_action' => {
                'open_entry_notification_screen' => 1,
                'send_entry_notification'        => 1,
                'send_notifications'             => 1,
            }
        },
        'blog.set_publish_paths' => {
            'group'            => 'blog_admin',
            'inherit_from'     => ['blog.edit_config'],
            'label'            => 'Set Publishing Paths',
            'order'            => 800,
            'permitted_action' => {
                'edit_blog_pathinfo' => 1,
                'save_blog_pathinfo' => 1,
                'set_publish_paths'  => 1,
            }
        },
        'blog.view_blog_log' => {
            'group'            => 'blog_admin',
            'label'            => 'View Activity Log',
            'order'            => 900,
            'permitted_action' => {
                'export_blog_log'      => 1,
                'get_system_feed'      => 1,
                'open_blog_log_screen' => 1,
                'reset_blog_log'       => 1,
                'search_blog_log'      => 1,
                'view_blog_log'        => 1,
                'use_tools:search'     => 1,
            }
        },
        'blog.manage_category_set' => {
            'group'            => 'blog_admin',
            'label'            => 'Manage Category Set',
            'order'            => 1000,
            'permitted_action' => {
                'edit_category_set'                      => 1,
                'save_category_set'                      => 1,
                'access_to_category_set_list'            => 1,
                'delete_category_set'                    => 1,
                'manage_category_set'                    => 1,
                'open_category_set_category_edit_screen' => 1,
                'save_catefory_set_category'             => 1,
            }
        },
        'blog.upload' => {
            'group'            => 'blog_upload',
            'label'            => 'Upload File',
            'order'            => 100,
            'permitted_action' => {
                'upload'                         => 1,
                'upload_asset_via_atom_server'   => 1,
                'upload_asset_via_xmlrpc_server' => 1,
            }
        },
        'system.administer' => {
            'group'        => 'sys_admin',
            'label'        => 'System Administrator',
            'inherit_from' => [
                'system.edit_templates',      'system.manage_plugins',
                'system.view_log',            'system.create_site',
                'system.sign_in_cms',         'system.sign_in_data_api',
                'system.manage_users_groups', 'system.manage_content_types',
                'system.manage_content_data'
            ],
            'order'            => 0,
            'permitted_action' => {
                'access_to_system_dashboard' => 1,
                'administer'                 => 1,
                'create_role'                => 1,
                'edit_role'                  => 1,
                'get_debug_feed'             => 1,
                'grant_role_for_all_blogs'   => 1,
                'restore_blog'               => 1,
                'save_role'                  => 1,
                'uninstall_theme_package'    => 1,
                'move_blogs'                 => 1,
                'use_tools:search'           => 1,
                'open_system_check_screen'   => 1,
                'use_tools:system_info_menu' => 1,
                'delete_any_filters'         => 1,
            }
        },
        'system.create_blog' => {
            'group'   => 'sys_admin',
            'label'   => 'Create Child Sites',
            'order'   => 200,
            'display' => 0,
        },
        'system.edit_templates' => {
            'group'        => 'sys_admin',
            'inherit_from' => [
                'system.sign_in_cms', 'blog.edit_templates',
                'blog.manage_themes'
            ],
            'label'            => 'Manage Templates',
            'order'            => 250,
            'permitted_action' => {
                'access_to_website_list'       => 1,
                'access_to_blog_list'          => 1,
                'access_to_system_dashboard'   => 1,
                'use_tools:search'             => 1,
                'open_blog_listing_screen'     => 1,
                'open_all_blog_listing_screen' => 1,
                'refresh_templates'            => 1,
                'refresh_template_via_list'    => 1,
            },
        },
        'system.manage_plugins' => {
            'group'            => 'sys_admin',
            'inherit_from'     => ['system.sign_in_cms'],
            'label'            => 'Manage Plugins',
            'order'            => 300,
            'permitted_action' => {
                'config_plugins'             => 1,
                'manage_plugins'             => 1,
                'reset_plugin_setting'       => 1,
                'save_plugin_setting'        => 1,
                'toggle_plugin_switch'       => 1,
                'access_to_system_dashboard' => 1,
            }
        },
        'system.view_log' => {
            'group'            => 'sys_admin',
            'inherit_from'     => ['system.sign_in_cms'],
            'label'            => 'View System Activity Log',
            'order'            => 400,
            'permitted_action' => {
                'export_system_log'          => 1,
                'get_all_system_feed'        => 1,
                'open_system_log_screen'     => 1,
                'reset_system_log'           => 1,
                'search_log'                 => 1,
                'view_log'                   => 1,
                'access_to_system_dashboard' => 1,
                'use_tools:search'           => 1,
            }
        },
        'system.sign_in_cms' => {
            'group'            => 'sys_admin',
            'label'            => 'Sign In(CMS)',
            'order'            => 500,
            'permitted_action' => { 'sign_in_cms' => 1 },
        },
        'system.sign_in_data_api' => {
            'group'            => 'sys_admin',
            'label'            => 'Sign In(Data API)',
            'order'            => 600,
            'permitted_action' => { 'sign_in_data_api' => 1 },
        },
        'system.create_site' => {
            'group'            => 'sys_admin',
            'inherit_from'     => ['system.sign_in_cms'],
            'label'            => 'Create Sites',
            'order'            => 700,
            'permitted_action' => {

                # create website
                'create_new_website'            => 1,
                'create_website'                => 1,
                'use_website:create_menu'       => 1,
                'edit_new_website_config'       => 1,
                'open_new_website_screen'       => 1,
                'set_new_website_publish_paths' => 1,
                'access_to_system_dashboard'    => 1,
                'use_tools:search'              => 1,

                # create blog
                'create_blog'                => 1,
                'create_new_blog'            => 1,
                'use_blog:create_menu'       => 1,
                'edit_new_blog_config'       => 1,
                'open_new_blog_screen'       => 1,
                'set_new_blog_publish_paths' => 1,

                'create_new_site'            => 1,
                'create_site'                => 1,
                'use_site:create_menu'       => 1,
                'edit_new_site_config'       => 1,
                'open_new_site_screen'       => 1,
                'set_new_site_publish_paths' => 1,
                }

        },
        'system.create_website' => {
            'group'   => 'sys_admin',
            'label'   => 'Create Websites',
            'order'   => 700,
            'display' => 0,
        },
        'system.manage_users_groups' => {
            'group'        => 'sys_admin',
            'label'        => 'Manage Users & Groups',
            'order'        => 800,
            'inherit_from' => [ 'system.sign_in_cms', 'blog.manage_users' ],
            'permitted_action' => {
                'access_to_blog_member_list'     => 1,
                'manage_users_groups'            => 1,
                'search_members'                 => 1,
                'search_authors'                 => 1,
                'remove_user_assoc'              => 1,
                'revoke_role'                    => 1,
                'access_to_any_group_list'       => 1,
                'access_to_system_dashboard'     => 1,
                'grant_administer_role'          => 1,
                'grant_role_for_blog'            => 1,
                'access_to_all_association_list' => 1,
                'access_to_system_author_list'   => 1,
                'create_user'                    => 1,
                'access_to_any_permission_list'  => 1,
                'edit_authors'                   => 1,
                'edit_groups'                    => 1,
                'edit_other_profile'             => 1,
                'access_to_website_list'         => 1,
                'access_to_blog_list'            => 1,
                'delete_user_via_list'           => 1,
                'access_to_permission_list'      => 1,
                'create_any_association'         => 1,
                'grant_role_for_all_blogs'       => 1,
                'use_tools:search'               => 1,
            },
        },
        'system.manage_content_data' => {
            group        => 'sys_admin',
            label        => 'Manage All Content Data',
            order        => 900,
            inherit_from => [
                'system.sign_in_cms', 'blog.manage_content_data',
                'blog.edit_assets'
            ],
            permitted_action => {
                'access_to_content_data_list'             => 1,
                'add_tags_to_content_data_via_list'       => 1,
                'create_new_content_data'                 => 1,
                'edit_all_content_data'                   => 1,
                'edit_all_published_content_data'         => 1,
                'edit_all_unpublished_content_data'       => 1,
                'handle_junk'                             => 1,
                'handle_not_junk'                         => 1,
                'list_asset'                              => 1,
                'load_next_scheduled_content_data'        => 1,
                'open_batch_content_data_editor_via_list' => 1,
                'publish_all_content_data'                => 1,
                'remove_tags_from_content_data_via_list'  => 1,
                'set_content_data_draft_via_list'         => 1,
                'use_content_data:manage_menu'            => 1,
                'get_content_data_feed'                   => 1,
                'save_multiple_content_data'              => 1,
                'open_select_author_dialog'               => 1,
                'insert_asset'                            => 1,
                'access_to_insert_asset_list'             => 1,
                'access_to_system_dashboard'              => 1,
                'access_to_website_list'                  => 1,
                'access_to_blog_list'                     => 1,
                'use_tools:search'                        => 1,
                'view_thumbnail_image'                    => 1,
            },
        },
        'system.manage_content_types' => {
            group          => 'sys_admin',
            label          => 'Manage Content Types',
            order          => 1000,
            inherit_from   => [
                'system.manage_content_data', 'blog.manage_category_set',
                'system.sign_in_cms'
            ],
            permitted_action => {
                'access_to_system_dashboard'  => 1,
                'create_new_content_type'     => 1,
                'delete_content_type'         => 1,
                'edit_all_content_types'      => 1,
                'edit_own_content_type'       => 1,
                'manage_content_types'        => 1,
                'save_multiple_content_type'  => 1,
                'access_to_website_list'      => 1,
                'access_to_blog_list'         => 1,
                'use_tools:search'            => 0,
                'access_to_content_type_list' => 1,
                'edit_category_set'           => 1,
            },
        },
    };
}

sub l10n_class {'MT::L10N'}

sub init_registry {
    my $c = shift;
    return $c->{registry} = $core_registry;
}

# Config handlers for these settings...

sub load_archive_types {
    require MT::ContentPublisher;
    return MT::ContentPublisher->core_archive_types;
}

sub PerformanceLoggingPath {
    my $cfg = shift;
    my ( $path, $default );
    return $cfg->set_internal( 'PerformanceLoggingPath', @_ ) if @_;

    unless ( $path = $cfg->get_internal('PerformanceLoggingPath') ) {
        $path = $default
            = File::Spec->catdir( MT->instance->support_directory_path,
            'logs' );
    }

    return $path
        unless $cfg->get_internal('PerformanceLogging');

    # If the $path is not a writeable directory, we need to
    # do some work to see if we can create it
    if ( !( -d $path and -w $path ) ) {

        # Determine where MT should put its logging data.  It will be
        # the first existing and writeable directory found or created
        # between PerformanceLoggingPath configuration directive value
        # and the default fallback of MT_DIR/support/logs.  If neither
        # can be used, we return an undefined value and simply don't
        # log the performance stats.
        #
        # However, we do log any such errors in the activity log to
        # notify the user that there is a problem.

        my @dirs
            = ( $path, ( $default && $path ne $default ? ($default) : () ) );
        require File::Spec;
        foreach my $dir (@dirs) {
            my $msg = '';
            if ( -d $dir and -w $dir ) {
                $path = $dir;
            }
            elsif ( !-e $dir ) {
                require File::Path;
                eval { File::Path::mkpath( [$dir], 0, 0777 ); $path = $dir; };
                if ($@) {
                    $msg = MT->translate(
                        'Error creating performance logs directory, [_1]. Please either change the permissions to make it writable or specify an alternate using the PerformanceLoggingPath configuration directive. [_2]',
                        $dir, $@
                    );
                }
            }
            elsif ( -e $dir and !-d $dir ) {
                $msg = MT->translate(
                    'Error creating performance logs: PerformanceLoggingPath setting must be a directory path, not a file. [_1]',
                    $dir
                );
            }
            elsif ( -e $dir and !-w $dir ) {
                $msg = MT->translate(
                    'Error creating performance logs: PerformanceLoggingPath directory exists but is not writeable. [_1]',
                    $dir
                );
            }

            if ($msg) {

                # Issue MT log within an eval block in the
                # event that the plugin error is happening before
                # the database has been initialized...
                require MT::Log;
                MT->log(
                    {   message  => $msg,
                        class    => 'system',
                        level    => MT::Log::ERROR(),
                        category => 'performance-log',
                    }
                );
            }
            last if $path;
        }
    }
    return $path;
}

sub ProcessMemoryCommand {
    my $cfg = shift;
    my $os  = $^O;
    my $cmd;
    if ( $os eq 'darwin' ) {
        $cmd = 'ps $$ -o rss=';
    }
    elsif ( $os eq 'linux' ) {
        $cmd = 'ps -p $$ -o rss=';
    }
    elsif ( $os eq 'MSWin32' ) {
        $cmd = {
            command => q{tasklist /FI "PID eq $$" /FO TABLE /NH},
            regex   => qr/([\d,]+) K/
        };
    }
    return $cmd;
}

sub SecretToken {
    my $cfg    = shift;
    my @alpha  = ( 'a' .. 'z', 'A' .. 'Z', 0 .. 9 );
    my $secret = join '', map $alpha[ rand @alpha ], 1 .. 40;
    $secret = $cfg->set_internal( 'SecretToken', $secret, 1 );
    $cfg->save_config();
    return $secret;
}

sub DefaultUserTagDelimiter {
    my $mgr = shift;
    return $mgr->set_internal( 'DefaultUserTagDelimiter', @_ ) if @_;
    my $delim = $mgr->get_internal('DefaultUserTagDelimiter');
    if ( lc $delim eq 'comma' ) {
        return ord(',');
    }
    elsif ( lc $delim eq 'space' ) {
        return ord(' ');
    }
    else {
        return ord(',');
    }
}

sub UserSessionCookieName {
    my $mgr = shift;
    if ( $mgr->get_internal('SingleCommunity') ) {
        return 'mt_blog_user';
    }
    else {
        return 'mt_blog%b_user';
    }
}

sub UserSessionCookiePath {
    my $mgr = shift;
    if ( $mgr->get_internal('SingleCommunity') ) {
        return '/';
    }
    else {
        return '<$MTBlogRelativeURL$>';
    }
}

sub CGIMaxUpload {
    my $mgr = shift;
    $mgr->set_internal( 'CGIMaxUpload', @_ ) if @_;

    my $val = $mgr->get_internal('CGIMaxUpload');
    return $mgr->default('CGIMaxUpload') unless $val;

    eval "require Scalar::Util";
    if ( !$@ ) {
        return $mgr->default('CGIMaxUpload')
            unless Scalar::Util::looks_like_number($val);
    }
    else {
        return $mgr->default('CGIMaxUpload')
            unless ( $val =~ /^[+-]?[0-9]+$/ );
    }
    return $val;
}

sub SearchScript {
    my $mgr = shift;

    return $mgr->set_internal( 'SearchScript', @_ ) if @_;

    if ( MT->app && MT->app->isa('MT::App::Search::FreeText') ) {
        return $mgr->get_internal('FreeTextSearchScript');
    }
    elsif ( MT->app && MT->app->isa('MT::App::Search::ContentData') ) {
        return $mgr->get_internal('ContentDataSearchScript');
    }
    else {
        return $mgr->get_internal('SearchScript');
    }
}

1;
__END__

=head1 NAME

MT::Core - Core component for Movable Type functionality.

=head1 METHODS

=head2 MT::Core::trans($phrase)

Stub method that returns the phrase it is given.

=head2 MT::Core->name()

Returns a string identifying this component.

=head2 MT::Core->id()

Returns the identifier for this component.

=head2 MT::Core::load_junk_filters()

Routine that returns the core junk filter registry elements (these
live in the L<MT::JunkFilter> package).

=head2 MT::Core::load_core_tasks()

Routine that returns the core L<MT::TaskMgr> registry elements.

=head2 MT::Core->remove_temporary_files()

Utility method for removing any temporary files that MT generates.

=head2 MT::Core->remove_expired_sessions()

Utility method for clearing expired MT user session records.

=head2 MT::Core->remove_expired_search_caches()

Utility method for removing expired search cache records.

=head2 MT::Core::load_default_templates()

Routine that returns the default template set registry elements.

=head2 MT::Core::load_captcha_providers()

Routine that returns the CAPTCHA provider registry elements.

=head2 MT::Core::load_core_commenter_auth()

Routine that returns the core registry elements for commenter
authentication methods.

=head2 MT::Core::load_core_tags()

Routine that returns the core registry elements for the MT
template tags are enabled for the entire system (excludes
application-specific tags).

=head2 MT::Core::load_upgrade_fns()

Routine that returns the core registry elements for the MT
schema upgrade framework.

=head2 MT::Core::load_backup_instructions

Routine that returns the core registry elements for the MT
Backup/Restore framework.

=head2 MT::Core->l10n_class

Returns the localization package for the core component.

=head2 $core->init_registry()

=head2 MT::Core::load_archive_types()

Routine that returns the core registry elements for the
publishable archive types. See L<MT::ArchiveType>.

=head2 MT::Core::PerformanceLoggingPath

A L<MT::ConfigMgr> get/set method for the C<PerformanceLoggingPath>
configuration setting. If the user has not designated a path, this
will return a default location, which is programatically determined.

=head2 MT::Core::ProcessMemoryCommand

A L<MT::ConfigMgr> get/set method for the C<ProcessMemoryCommand>
configuration setting. If the user has not assigned this themselves,
it will return a default command, determined by the operating system
Movable Type is running on.

=head2 MT::Core::SecretToken

A L<MT::ConfigMgr> get/set method for the C<SecretToken>
configuration setting. If the user has not assigned this themselves,
it will return a random token value, and save it to the database for
future use.

=head2 MT::Core::DefaultUserTagDelimiter

A L<MT::ConfigMgr> get/set method for the C<DefaultUserTagDelimiter>
configuration setting. Translates the keyword values 'comma' and
'space' to the ASCII code for those characters.

=head2 MT::Core::UserSessionCookieName

A L<MT::ConfigMgr> get/set method for the C<UserSessionCookieName>
configuration setting. If the user has not specifically assigned
this setting, a default value is returned, affected by the
C<SingleCommunity> setting. If C<SingleCommunity> is enabled, it
returns a cookie name that is the same for all blogs. If it is
off, it returns a cookie name that is blog-specific (contains the
blog id in the cookie name).

=head2 UserSessionCookiePath

A L<MT::ConfigMgr> get/set method for the C<UserSessionCookiePath>
configuration setting. If the user has not specifically assigned
this setting, a default value is returned, affected by the
C<SingleCommunity> setting. If C<SingleCommunity> is enabled, it
returns a path that is the same for all blogs ('/'). If it is
off, it returns a value that will yield the blog's relative
URL path.

=head2 CGIMaxUpload

A L<MT::ConfigMgr> get/set method for the C<CGIMaxUpload>
configuration setting. If the user sets invalid value for
this directive, the system will be use a default value.


=head1 LICENSE

The license that applies is the one you agreed to when downloading
Movable Type.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
