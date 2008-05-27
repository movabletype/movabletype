package MT::CMS::Plugin;

use strict;
use MT::Util qw( remove_html );

sub cfg_plugins {
    my $app = shift;
    my $q   = $app->param;
    my %param;
    $param{screen_class} = 'settings-screen';
    if ( $q->param('blog_id') ) {
        $q->param( '_type', 'blog' );
        $q->param( 'id',    scalar $q->param('blog_id') );
        $param{screen_id} = "list-plugins";
        $param{screen_class} .= " plugin-settings";
        $param{output} = 'cfg_plugin.tmpl';
        $app->forward("view", \%param);
    }
    else {
        my $cfg = $app->config;
        $param{can_config}  = $app->user->can_manage_plugins;
        $param{use_plugins} = $cfg->UsePlugins;
        build_plugin_table( $app, param => \%param, scope => 'system' );
        $param{nav_config}   = 1;
        $param{nav_settings} = 1;
        $param{nav_plugins}  = 1;
        $param{switched}     = 1 if $app->param('switched');
        $param{'reset'}  = 1 if $app->param('reset');
        $param{saved}    = 1 if $app->param('saved');
        $param{mod_perl} = 1 if $ENV{MOD_PERL};
        $app->add_breadcrumb( $app->translate("Plugin Settings") );
        $param{screen_id} = "list-plugins";
        $param{screen_class} = "plugin-settings";

        $app->load_tmpl( 'cfg_plugin.tmpl', \%param );
    }
}

sub save_config {
    my $app = shift;

    my $q          = $app->param;
    my $plugin_sig = $q->param('plugin_sig');
    my $profile    = $MT::Plugins{$plugin_sig};
    my $blog_id    = $q->param('blog_id');

    $app->validate_magic or return;
    return $app->errtrans("Permission denied.")
        unless $app->user->can_manage_plugins
            or ($blog_id
            and $app->user->permissions($blog_id)->can_administer_blog);

    my %param;
    my @params = $q->param;
    foreach (@params) {
        next if $_ =~ m/^(__mode|return_args|plugin_sig|magic_token|blog_id)$/;
        $param{$_} = $q->param($_);
    }
    if ( $profile && $profile->{object} ) {
        my $plugin = $profile->{object};
        $plugin->error(undef);
        $profile->{object}
          ->save_config( \%param, $blog_id ? 'blog:' . $blog_id : 'system' );
        if ( $plugin->errstr ) {
            return $app->error("Error saving plugin settings: " . $plugin->errstr);
        }
    }

    $app->add_return_arg( saved => 1 );
    $app->call_return;
}

sub reset_config {
    my $app = shift;

    my $q          = $app->param;
    my $plugin_sig = $q->param('plugin_sig');
    my $profile    = $MT::Plugins{$plugin_sig};
    my $blog_id    = $q->param('blog_id');

    $app->validate_magic or return;
    return $app->errtrans("Permission denied.")
        unless $app->user->can_manage_plugins
            or ($blog_id
            and $app->user->permissions($blog_id)->can_administer_blog);

    my %param;
    if ( $profile && $profile->{object} ) {
        $profile->{object}
          ->reset_config( $blog_id ? 'blog:' . $blog_id : 'system' );
    }
    $app->add_return_arg( 'reset' => 1 );
    $app->call_return;
}

sub plugin_control {
    my $app = shift;

    $app->validate_magic or return;
    return unless $app->user->can_manage_plugins;

    my $plugin_sig = $app->param('plugin_sig') || '';
    my $state      = $app->param('state')      || '';

    my $cfg = $app->config;
    if ( $plugin_sig eq '*' ) {
        $cfg->UsePlugins( $state eq 'on' ? 1 : 0, 1 );
    }
    else {
        if ( exists $MT::Plugins{$plugin_sig} ) {
            $cfg->PluginSwitch(
                $plugin_sig . '=' . ( $state eq 'on' ? '1' : '0' ), 1 );
        }
    }
    $cfg->save_config;

    $app->add_return_arg( 'switched' => 1 );
    $app->call_return;
}

sub build_plugin_table {
    my $app = shift;
    my (%opt) = @_;

    my $param = $opt{param};
    my $scope = $opt{scope} || 'system';
    my $cfg   = $app->config;
    my $data  = [];

    # we have to sort the plugin list in an odd fashion...
    #   PLUGINS
    #     (those at the top of the plugins directory and those
    #      that only have 1 .pl script in a plugin folder)
    #   PLUGIN SET
    #     (plugins folders with multiple .pl files)
    my %list;
    my %folder_counts;
    for my $sig ( keys %MT::Plugins ) {
        my $sub = $sig =~ m!/! ? 1 : 0;
        my $obj = $MT::Plugins{$sig}{object};

        # Prevents display of component objects
        next if $obj && !$obj->isa('MT::Plugin');

        my $err = $MT::Plugins{$sig}{error}   ? 0 : 1;
        my $on  = $MT::Plugins{$sig}{enabled} ? 0 : 1;
        my ( $fld, $plg );
        ( $fld, $plg ) = $sig =~ m!(.*)/(.*)!;
        $fld = '' unless $fld;
        $folder_counts{$fld}++ if $fld;
        $plg ||= $sig;
        $list{  $sub
              . sprintf( "%-100s", $fld )
              . ( $obj ? '1' : '0' )
              . $plg } = $sig;
    }
    my @keys = keys %list;
    foreach my $key (@keys) {
        my $fld = substr( $key, 1, 100 );
        $fld =~ s/\s+$//;
        if ( !$fld || ( $folder_counts{$fld} == 1 ) ) {
            my $sig = $list{$key};
            delete $list{$key};
            my $plugin = $MT::Plugins{$sig};
            my $name =
              $plugin && $plugin->{object} ? $plugin->{object}->name : $sig;
            $list{ '0' . ( ' ' x 100 ) . sprintf( "%-102s", $name ) } = $sig;
        }
    }

    my $last_fld = '*';
    my $next_is_first;
    my $id = 0;
    ( my $cgi_path = $cfg->AdminCGIPath || $cfg->CGIPath ) =~ s|/$||;
    for my $list_key ( sort keys %list ) {
        $id++;
        my $plugin_sig = $list{$list_key};
        next if $plugin_sig =~ m/^[^A-Za-z0-9]/;
        my $profile = $MT::Plugins{$plugin_sig};
        my ($plg);
        ($plg) = $plugin_sig =~ m!(?:.*)/(.*)!;
        my $fld = substr( $list_key, 1, 100 );
        $fld =~ s/\s+$//;
        my $folder =
            $fld
          ? $app->translate( "Plugin Set: [_1]", $fld )
          : $app->translate("Individual Plugins");
        my $row;
        my $icon = $app->static_path . 'images/plugin.gif';

        if ( my $plugin = $profile->{object} ) {
            my $plugin_icon;
            if ( $plugin->icon ) {
                $plugin_icon =
                  $app->static_path . $plugin->envelope . '/' . $plugin->icon;
            }
            else {
                $plugin_icon = $icon;
            }
            my $plugin_name = remove_html( $plugin->name() );
            my $config_link = $plugin->config_link();
            my $plugin_page =
              ( $cgi_path . '/' . $plugin->envelope . '/' . $config_link )
              if $config_link;
            my $doc_link = $plugin->doc_link;
            if ( $doc_link && ( $doc_link !~ m!^https?://! ) ) {
                $doc_link =
                  $app->static_path . $plugin->envelope . '/' . $doc_link;
            }

            my ($config_html);
            my %plugin_param;
            my $settings = $plugin->get_config_obj($scope);
            $plugin->load_config( \%plugin_param, $scope );
            if ( my $snip_tmpl =
                $plugin->config_template( \%plugin_param, $scope ) )
            {
                my $tmpl;
                if ( ref $snip_tmpl ne 'MT::Template' ) {
                    require MT::Template;
                    $tmpl = MT::Template->new(
                        type   => 'scalarref',
                        source => ref $snip_tmpl
                        ? $snip_tmpl
                        : \$snip_tmpl

                          # TBD: add path for plugin template directory
                    );
                }
                else {
                    $tmpl = $snip_tmpl;
                }

                # Process template independent of $app to avoid premature
                # localization (give plugin a chance to do L10N first).
                $tmpl->param( \%plugin_param );
                $config_html = $tmpl->output()
                    or $config_html = "Error in configuration template: " . $tmpl->errstr;
                $config_html = $plugin->translate_templatized($config_html)
                  if $config_html =~ m/<(?:__trans|mt_trans) /i;
            }
            else {

                # don't list non-configurable plugins for blog scope...
                next if $scope ne 'system';
            }

            if ( $last_fld ne $fld ) {
                $row = {
                    plugin_sig    => $plugin_sig,
                    plugin_folder => $folder,
                    plugin_set    => $fld ? $folder_counts{$fld} > 1 : 0,
                    plugin_error  => $profile->{error},
                };
                push @$data, $row;
                $last_fld      = $fld;
                $next_is_first = 1;
            }

            my $registry = $plugin->registry;
            my $row      = {
                first                => $next_is_first,
                plugin_name          => $plugin_name,
                plugin_page          => $plugin_page,
                plugin_major         => 1,
                plugin_icon          => $plugin_icon,
                plugin_desc          => $plugin->description(),
                plugin_version       => $plugin->version(),
                plugin_author_name   => $plugin->author_name(),
                plugin_author_link   => $plugin->author_link(),
                plugin_plugin_link   => $plugin->plugin_link(),
                plugin_full_path     => $plugin->{full_path},
                plugin_doc_link      => $doc_link,
                plugin_sig           => $plugin_sig,
                plugin_key           => $plugin->key(),
                plugin_config_link   => $plugin->config_link(),
                plugin_config_html   => $config_html,
                plugin_settings_id   => $settings->id,
                plugin_id            => $id,
                plugin_compat_errors => $registry->{compat_errors},
            };
            my $block_tags = $plugin->registry('tags', 'block');
            my $function_tags = $plugin->registry('tags', 'function');
            my $modifiers = $plugin->registry('tags', 'modifier');
            my $junk_filters = $plugin->registry('junk_filters');
            my $text_filters = $plugin->registry('text_filters');

            $row->{plugin_tags} = MT::App::CMS::listify(
                [

                    # Filter out 'plugin' registry entry
                    grep { !/^<\$?MTplugin\$?>$/ } (
                        (

                            # Format all 'block' tags with <MT(name)>
                            map { s/\?$//; "<MT$_>" }
                              ( keys %{ $block_tags || {} } )
                        ),
                        (

                            # Format all 'function' tags with <$MT(name)$>
                            map { "<\$MT$_\$>" }
                              ( keys %{ $function_tags || {} } )
                        )
                    )
                ]
            ) if $block_tags || $function_tags;
            $row->{plugin_attributes} = MT::App::CMS::listify(
                [

                    # Filter out 'plugin' registry entry
                    grep { $_ ne 'plugin' }
                      keys %{ $modifiers || {} }
                ]
            ) if $modifiers;
            $row->{plugin_junk_filters} = MT::App::CMS::listify(
                [

                    # Filter out 'plugin' registry entry
                    grep { $_ ne 'plugin' }
                      keys %{ $junk_filters || {} }
                ]
            ) if $junk_filters;
            $row->{plugin_text_filters} = MT::App::CMS::listify(
                [

                    # Filter out 'plugin' registry entry
                    grep { $_ ne 'plugin' }
                      keys %{ $text_filters || {} }
                ]
            ) if $text_filters;
            if (   $row->{plugin_tags}
                || $row->{plugin_attributes}
                || $row->{plugin_junk_filters}
                || $row->{plugin_text_filters} )
            {
                $row->{plugin_resources} = 1;
            }
            push @$data, $row;
        }
        else {

            # don't list non-configurable plugins for blog scope...
            next if $scope ne 'system';

            if ( $last_fld ne $fld ) {
                $row = {
                    plugin_sig    => $plugin_sig,
                    plugin_folder => $folder,
                    plugin_set    => $fld ? $folder_counts{$fld} > 1 : 0,
                    plugin_error  => $profile->{error},
                };
                push @$data, $row;
                $last_fld      = $fld;
                $next_is_first = 1;
            }

            # no registered plugin objects--
            $row = {
                first                => $next_is_first,
                plugin_major         => $fld ? 0 : 1,
                plugin_icon          => $icon,
                plugin_name          => $plugin_sig,
                plugin_sig           => $plugin_sig,
                plugin_error         => $profile->{error},
                plugin_disabled      => $profile->{enabled} ? 0 : 1,
                plugin_id            => $id,
            };
            push @$data, $row;
        }
        $next_is_first = 0;
    }
    $param->{plugin_loop} = $data;
}

1;
