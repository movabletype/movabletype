# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DefaultTemplates;

use strict;
use warnings;
use utf8;
use open ':utf8';

=pod
Registry storage format for default templates:

default_templates:
    index:
        # The identifier used here never changes for this
        # template. It is also unique.
        main_index:
            filename: (optional; defaults to <identifier>.mtml)
            label: Main Index (auto-translated)
            outfile: (applicable for index templates only)
            rebuild_me: (applicable for index templates only)

=cut

my $loaded = 0;
my $templates;

BEGIN {
    $templates = {
        'index' => {
            'main_index' => {
                label      => 'Main Index',
                outfile    => 'index.html',
                rebuild_me => 1,
            },
            'archive_index' => {
                label      => 'Archive Index',
                outfile    => 'archives.html',
                rebuild_me => 1,
            },
            'styles' => {
                label      => 'Stylesheet',
                outfile    => 'styles.css',
                rebuild_me => 1,
            },
            'javascript' => {
                label      => 'JavaScript',
                outfile    => 'mt.js',
                rebuild_me => 1,
            },
            'feed_recent' => {
                label      => 'Feed - Recent Entries',
                outfile    => 'atom.xml',
                rebuild_me => 1,
            },
            'rsd' => {
                label      => 'RSD',
                outfile    => 'rsd.xml',
                rebuild_me => 1,
            },
        },
        'individual' => {
            'entry' => {
                label => 'Entry',
                mappings =>
                    { entry_archive => { archive_type => 'Individual', }, },
            },
        },
        'page' => {
            'page' => {
                label    => 'Page',
                mappings => { page_archive => { archive_type => 'Page', }, },
            },
        },
        'archive' => {
            'monthly_entry_listing' => {
                label    => 'Monthly Entry Listing',
                mappings => { monthly => { archive_type => 'Monthly', }, },
            },
            'category_entry_listing' => {
                label    => 'Category Entry Listing',
                mappings => { category => { archive_type => 'Category', }, },
            },
        },
        'system' => {
            'dynamic_error' => {
                label => 'Dynamic Error',
                description_label =>
                    'Displays errors for dynamically-published templates.',
            },
            'popup_image' => {
                label => 'Popup Image',
                description_label =>
                    'Displays image when user clicks a popup-linked image.',
            },
            'search_results' => {
                label             => 'Search Results',
                description_label => 'Displays results of a search.',
            },
            'cd_search_results' => {
                label             => 'Search Results for Content Data',
                description_label => 'Displays results of a search for content data.',
            },
        },
        'module' => {
            'banner_header' => { label => 'Banner Header', },
            'banner_footer' => { label => 'Banner Footer', },
            'entry_summary' => { label => 'Entry Summary', },
            'html_head'     => { label => 'HTML Head', },
            'sidebar'       => { label => 'Sidebar', },
        },
        'widget' => {
            'about_this_page'       => { label => 'About This Page', },
            'archive_widgets_group' => { label => 'Archive Widgets Group', },
            'author_archive_list'   => { label => 'Author Archives', },
            'current_author_monthly_archive_list' =>
                { label => 'Current Author Monthly Archives', },
            'calendar'              => { label => 'Calendar', },
            'category_archive_list' => { label => 'Category Archives', },
            'current_category_monthly_archive_list' =>
                { label => 'Current Category Monthly Archives', },
            'creative_commons' => { label => 'Creative Commons', },
            'main_index_widgets_group' =>
                { label => 'Home Page Widgets Group', },
            'monthly_archive_dropdown' =>
                { label => 'Monthly Archives Dropdown', },
            'monthly_archive_list' => { label => 'Monthly Archives', },
            'pages_list'           => { label => 'Page Listing', },
            'recent_assets'        => { label => 'Recent Assets', },
            'powered_by'           => { label => 'Powered By', },
            'recent_entries'       => { label => 'Recent Entries', },
            'search'               => { label => 'Search', },
            'signin'               => { label => 'Sign In', },
            'syndication'          => { label => 'Syndication', },
            'tag_cloud'            => { label => 'Tag Cloud', },
            'date_based_author_archives' =>
                { label => 'Date-Based Author Archives', },
            'date_based_category_archives' =>
                { label => 'Date-Based Category Archives', },
            'openid' => { label => 'OpenID Accepted', },
        },
        'widgetset' => {
            '2column_layout_sidebar' => {
                order   => 1000,
                label   => '2-column layout - Sidebar',
                widgets => [
                    'Search',
                    'About This Page',
                    'Home Page Widgets Group',
                    'Archive Widgets Group',
                    'Page Listing',
                    'Syndication',
                    'OpenID Accepted',
                    'Powered By',
                ],
            },
            '3column_layout_primary_sidebar' => {
                order   => 1000,
                label   => '3-column layout - Primary Sidebar',
                widgets => [
                    'Archive Widgets Group',
                    'Page Listing',
                    'Syndication',
                    'OpenID Accepted',
                    'Powered By',
                ],
            },
            '3column_layout_secondary_sidebar' => {
                order   => 1000,
                label   => '3-column layout - Secondary Sidebar',
                widgets => [
                    'Search',
                    'Home Page Widgets Group',
                    'About This Page',
                ],
            },
        },
        'global:module' => { 'footer-email' => { label => 'Mail Footer', }, },
        'global:email'  => {
            'notify-entry'     => { label => 'Entry Notify', },
            'recover-password' => { label => 'Password Recovery', },
            'lockout-user'     => { label => 'User Lockout', },
            'lockout-ip'       => { label => 'IP Address Lockout', },
        },
    };
}

sub core_default_templates {
    return $templates;
}

sub load {
    my $class   = shift;
    my ($terms) = @_;
    my $tmpls   = $class->templates || [];
    if ($terms) {
        foreach my $key ( keys %$terms ) {
            @$tmpls = grep { $_->{$key} eq $terms->{$key} } @$tmpls;
        }
    }

    # Make a new template object.
    my $convert = sub {
        my $tmpl = shift;
        return unless $tmpl;

        my $tmpl_class = MT->model('template');
        my $tmpl_cols  = $tmpl_class->column_defs();
        my $tmpl_obj   = $tmpl_class->new;
        foreach my $col ( keys %$tmpl_cols ) {
            $tmpl_obj->$col( $tmpl->{$col} )
                if exists $tmpl->{$col};
        }
        return $tmpl_obj;
    };

    return wantarray
        ? ( map { $convert->($_) } @$tmpls )
        : ( @$tmpls ? ( $convert->( $tmpls->[0] ) ) : undef );
}

sub templates {
    my $pkg = shift;
    my ($set) = @_;
    require File::Spec;
    my $all_tmpls;
    my $theme_envelope;
    if ( ref $set ) {
        $all_tmpls      = [$set];
        $theme_envelope = $set->{envelope};
    }
    else {

        # A set of default templates as returned by MT::Component->registry
        # yields an array of hashes.

        my @tmpl_path
            = $set ? ( "template_sets", $set ) : ("default_templates");
        $all_tmpls = MT::Component->registry(@tmpl_path) || [];
    }
    my $weblog_templates_path = MT->config('WeblogTemplatesPath');

    my ( %tmpls, %global_tmpls );
    foreach my $def_tmpl (@$all_tmpls) {

        # copy structure, then run filter

        my $tmpl_hash;
        if ( $def_tmpl->{templates} && ( $def_tmpl->{templates} eq '*' ) ) {
            $tmpl_hash = MT->registry("default_templates");
        }
        else {
            $tmpl_hash = $set ? $def_tmpl->{templates} : $def_tmpl;
        }

        foreach my $tmpl_set ( keys %$tmpl_hash ) {
            next unless ref( $tmpl_hash->{$tmpl_set} ) eq 'HASH';
            foreach my $tmpl_id ( keys %{ $tmpl_hash->{$tmpl_set} } ) {
                next if $tmpl_id eq 'plugin';
                my $plugin = $tmpl_hash->{plugin}
                    || $tmpl_hash->{$tmpl_set}{plugin};
                my $base_path = $def_tmpl->{base_path}
                    || $tmpl_hash->{$tmpl_set}{base_path};
                if ( $plugin && $base_path ) {
                    $base_path = File::Spec->catdir( $plugin->path, $base_path );
                }
                elsif ($theme_envelope) {
                    $base_path
                        = File::Spec->catdir( $theme_envelope, $base_path );
                }
                else {
                    $base_path = $weblog_templates_path;
                }

                my $tmpl = { %{ $tmpl_hash->{$tmpl_set}{$tmpl_id} } };
                my $type = $tmpl_set;
                if ( $tmpl_set =~ m/^global:/ ) {
                    $type =~ s/^global://;
                    $tmpl->{global} = 1;
                }
                $tmpl->{set} = $type;    # system, index, archive, etc.
                $tmpl->{order} = 0 unless exists $tmpl->{order};

                $type = 'custom' if $type eq 'module';
                $type = $tmpl_id if $type eq 'system';
                my $name = $tmpl->{label};
                if ( ref $name eq 'CODE' ) {
                    $name = $name->();
                }
                else {
                    if ($plugin) {
                        $name = $plugin->translate($name);
                    }
                    else {
                        $name = MT->translate($name);
                    }
                }
                $tmpl->{name}       = $name;
                $tmpl->{label}      = $name;
                $tmpl->{type}       = $type;
                $tmpl->{key}        = $tmpl_id;
                $tmpl->{identifier} = $tmpl_id;
                $tmpl->{plugin}     = $plugin;

                if ( exists $tmpl->{widgets} ) {
                    my $widgets = $tmpl->{widgets};
                    my @widgets;
                    foreach my $widget (@$widgets) {
                        if ($plugin) {
                            push @widgets, $plugin->translate($widget);
                        }
                        else {
                            push @widgets, MT->translate($widget);
                        }
                    }
                    $tmpl->{widgets} = \@widgets if @widgets;
                }
                else {

                    # load template if it hasn't been loaded already
                    if ( !exists $tmpl->{text} ) {
                        my $filename = $tmpl->{filename}
                            || ( $tmpl_id . '.mtml' );
                        my $file
                            = File::Spec->catfile( $base_path, $filename );
                        if ( ( -e $file ) && ( -r $file ) ) {
                            local $/ = undef;
                            open my $fin, '<', $file
                                or die "Couldn't open $file: $!";
                            my $data = <$fin>;
                            close $fin;
                            $tmpl->{text} = $data;
                        }
                        else {
                            $tmpl->{text} = '';
                        }
                    }
                }

                my $local_global_tmpls
                    = $tmpl->{global} ? \%global_tmpls : \%tmpls;
                my $tmpl_key = $type . ":" . $tmpl_id;
                if ( exists $local_global_tmpls->{$tmpl_key} ) {

                    # allow components/plugins to override core
                    # templates
                    $local_global_tmpls->{$tmpl_key} = $tmpl
                        if $plugin && ( $plugin->id ne 'core' );
                }
                else {
                    $local_global_tmpls->{$tmpl_key} = $tmpl;
                }
            }
        }
    }

    $pkg->fill_with_missing_system_templates(\%tmpls);

    my @tmpls = ( values(%tmpls), values(%global_tmpls) );

# sort widgets to process last, since they rely on the widgets to exist first.
    @tmpls = sort _template_sort @tmpls;
    MT->run_callbacks( 'DefaultTemplateFilter' . ( $set ? '.' . $set : '' ),
        \@tmpls );
    return \@tmpls;
}

sub fill_with_missing_system_templates {
    my ($pkg, $tmpls) = @_;

    my $system_default_templates = MT->registry('default_templates')->{system};

    require File::Basename;
    my $weblog_templates_path = MT->config('WeblogTemplatesPath');
    my $basename = File::Basename::basename($weblog_templates_path);  # "default_templates" by default
    my $plugins_with_default_templates;
    for my $tmpl_id (keys %$system_default_templates) {
        next if $tmpl_id eq 'plugin';
        my $key = "$tmpl_id:$tmpl_id";
        next if $tmpls->{$key};
        if (!$plugins_with_default_templates) {
            $plugins_with_default_templates = { '' => $weblog_templates_path };
            for my $plugin_sig (keys %MT::Plugins) {
                next if defined $MT::Plugins{$plugin_sig}{enabled} && !$MT::Plugins{$plugin_sig}{enabled};
                my $plugin                 = $MT::Plugins{$plugin_sig}{object};
                my $full_path              = $plugin->path;
                my $default_templates_path = File::Spec->catdir($full_path, $basename);
                next unless -d $default_templates_path;
                $plugins_with_default_templates->{$plugin_sig} = $default_templates_path;
            }
        }
        my ($plugin, $text);
        for my $plugin_sig (sort keys %$plugins_with_default_templates) {
            my $default_templates_path = $plugins_with_default_templates->{$plugin_sig};
            my $file                   = File::Spec->catfile($default_templates_path, "$tmpl_id.mtml");

            if ((-e $file) && (-r $file)) {
                local $/;
                open my $fin, '<', $file or die "Couldn't open $file: $!";
                $text = <$fin>;
                close $fin;
                $plugin = $MT::Plugins{$plugin_sig}{object} if $plugin_sig;
            }
        }

        my $tmpl = { %{ $system_default_templates->{$tmpl_id} } };
        $tmpl->{set} = 'system';
        my $name = $tmpl->{label};
        if (ref $name eq 'CODE') {
            $name = $name->();
        } else {
            if ($plugin) {
                $name = $plugin->translate($name);
            } else {
                $name = MT->translate($name);
            }
        }
        $tmpl->{name}       = $name;
        $tmpl->{label}      = $name;
        $tmpl->{type}       = $tmpl_id;
        $tmpl->{key}        = $tmpl_id;
        $tmpl->{identifier} = $tmpl_id;
        $tmpl->{order} ||= 0;
        $tmpl->{text}   = defined $text ? $text : '';
        $tmpl->{plugin} = $plugin;

        $tmpls->{$key} = $tmpl;
    }
}

sub _template_sort {
    if ( $a->{type} eq 'widgetset' ) {
        return 1 unless $b->{type} eq 'widgetset';
    }
    elsif ( $b->{type} eq 'widgetset' ) {

        # a is not a widgetset
        return -1;
    }

    # both a, b == widgetset or both a, b != widgetset
    return $a->{order} <=> $b->{order} || $a->{key} cmp $b->{key};
}

#trans('Comment Form')
#trans('Navigation')
#trans('Blog Index')
#trans('Search Results for Content Data')

1;
__END__

=head1 NAME

MT::DefaultTemplates

=head1 METHODS

=head2 templates()

Return the list of the templates in the WeblogTemplatesPath.

=head1 AUTHOR & COPYRIGHT

Please see L<MT/AUTHOR & COPYRIGHT>.

=cut
