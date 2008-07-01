# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package MT::Component;

use strict;
use base qw( Class::Accessor::Fast MT::ErrorHandler );
use MT::Util qw( encode_js weaken );

__PACKAGE__->mk_accessors(qw( id path envelope version schema_version ));

#BEGIN {
#
#    # my @registry_methods = qw( callbacks upgrade_functions object_types
#    #     junk_filters text_filters permissions importers rebuild_options
#    #     tasks );
#    my @registry_methods = qw( callbacks );
#    foreach my $meth (@registry_methods) {
#        my $sub = sub { &_getset( shift, $meth, @_ ) };
#        no strict 'refs';
#        *$meth = $sub;
#    }
#}

# static method
sub select {
    my ( $pkg, $class ) = @_;
    if ( $class && $class !~ m/::/ ) {
        $class = $pkg . '::' . $class;
    }
    elsif ( !$class ) {
        $class = $pkg;
    }
    return @MT::Components if $class eq 'MT::Component';
    return @MT::Plugins if $class eq 'MT::Plugin';
    return grep { UNIVERSAL::isa( $_, $class ) } @MT::Components;
}

sub new {
    my $class = shift;
    my ($self) = ref $_[0] ? @_ : {@_};
    bless $self, $class;
    $self->init();
    $self;
}

sub init {
    my $c = shift;
    $c->init_registry() or return;

    # plugin callbacks are initialized after they finish loading.
    $c->init_callbacks() unless $c->isa('MT::Plugin');
    $c;
}

sub init_callbacks {
    my $c = shift;

    # Tricky; we only want to add this callback IF the plugin
    # has an init_app callback of it's own; at the same time
    # we have to declare a superclass init_app method so if
    # the plugin uses $plugin->SUPER::init_app(), it works.
    # So we test here to see if the signature of the init_app
    # method is something other than our stub init_app
    # method in MT::Component (same goes for init_request below)
    if ( $c->can('init_app') != \&MT::Component::init_app ) {
        MT->add_callback(
            'init_app',
            5, $c,
            sub {
                my $cb = shift;
                local $MT::plugin_registry = $c->{registry};
                $c->init_app(@_);
            }
        );
    }
    elsif (_getset( $c, 'init_app' )
        || _getset( $c, 'applications' ) )
    {
        MT->add_callback( 'init_app', 5, $c, \&on_init_app );
    }

    if ( $c->can('init_request') != \&MT::Component::init_request ) {
        MT->add_callback(
            'init_request',
            5, $c,
            sub {
                my $cb = shift;
                local $MT::plugin_registry = $c->{registry};
                $c->init_request(@_);
            }
        );
    }
    elsif ( _getset( $c, 'init_request' ) || _getset( $c, 'applications' ) ) {
        MT->add_callback( 'init_request', 5, $c, \&on_init_request );
    }

    if ( $c->{init_tasks} ) {
        MT->add_callback( 'tasks', 5, $c, $c->{init_tasks} );
    }
    elsif ( $c->can('init_tasks') ) {
        MT->add_callback( 'tasks', 5, $c,
            sub { my $cb = shift; $c->init_tasks(@_) } );
    }

    if ( my $callbacks = $c->callbacks ) {
        if ( ref $callbacks eq 'ARRAY' ) {
            foreach my $cb (@$callbacks) {
                MT->add_callback( $_->{name}, $cb->{priority} || 5,
                    $c, $cb->{handler} || $cb->{code} );
            }
        }
        elsif ( ref $callbacks eq 'HASH' ) {
            foreach my $cbname ( keys %$callbacks ) {
                if ( ref $callbacks->{$cbname} eq 'CODE' ||  (ref $callbacks->{$cbname} eq '' && $callbacks->{$cbname})) {
                    MT->add_callback( $cbname, 5, $c, $callbacks->{$cbname} );
                }
                elsif ( ref $callbacks->{$cbname} eq 'HASH' ) {
                    MT->add_callback(
                        $callbacks->{$cbname}{callback} || $cbname,
                        $callbacks->{$cbname}{priority} || 5,
                        $c,
                        $callbacks->{$cbname}{handler}
                          || $callbacks->{$cbname}{code}
                    );
                }
                elsif ( ref $callbacks->{$cbname} eq 'ARRAY' ) {
                    my $list = $callbacks->{$cbname};
                    MT->add_callback( $cbname, $_->{priority} || 5,
                        $c, $_->{handler} || $_->{code} )
                      foreach @$list;
                }
            }
        }
    }
    if (my $init = _getset( $c, 'init' )) {
        if ( !ref($init) ) {
            $init = MT->handler_to_coderef($init);
        }
        return $init->($c);
    }
    return 1;
}

sub load_registry {
    my $c      = shift;
    my ($file) = @_;
    my $path   = $c->path or return;
    $path = File::Spec->catfile( $c->path, $file );
    return unless -f $path;
    require YAML::Tiny;
    my $y = eval { YAML::Tiny->read($path) }
        or die "Error reading $path: " . $YAML::Tiny::errstr;
    if ( ref($y) ) {

        # skip over non-hash elements
        shift @$y while @$y && ( ref( $y->[0] ) ne 'HASH' );
        return $y->[0] if @$y;
    }
    return {};
}

sub init_registry {
    my $c = shift;
    my $r = $c->load_registry("config.yaml");
    if ( !$r ) {
        return 1;
    }

   # TBD: 'extends' support...
   # if (my $ext = $r->{extends}) {
   #     # require any other components declared here
   #     $ext = [ $ext ] unless ref($ext) eq 'ARRAY';
   #     foreach my $comp (@$ext) {
   #         MT->require_component($comp)
   #             or return $c->error("Error loading required component: $comp");
   #     }
   # }
    $c->registry($r);

    # map key registry elements into metadata
    foreach my $prop (qw(version schema_version)) {
        $c->$prop( $r->{$prop} ) if exists $r->{$prop};
    }
    $c->name( $r->{label} ) if exists $r->{label};
    return 1;
}

sub callbacks {
    my $c = shift;
    my $root_cb = _getset($c, 'callbacks') || {};
    my $apps = _getset($c, 'applications');
    for my $app (keys %$apps) {
        my @path = qw( applications );
        push @path, $app;
        my $r = $c->registry( @path );
        if ($r) {
            my $cb = _getset($r, 'callbacks') || {};
            MT::__merge_hash($root_cb, $cb);
        }
    }
    return $root_cb;
}

# STUB
sub init_app { }
sub init_request { }

sub on_init_app {
    my $cb      = shift;
    my $c       = $cb->plugin;
    my ($app)   = @_;
    my $app_pkg = ref $app;
    my $init;
    if ( $init = _getset( $c, 'init_app' ) ) {
        if ( ref $init eq 'HASH' ) {
            $init = $init->{$app_pkg};
        }
    }
    else {
        $init = $c->registry( "applications", $app->id, "init" );
    }
    if ( $init && !ref($init) ) {
        $init = MT->handler_to_coderef($init);
    }
    if ( $init && ( ref $init eq 'CODE' ) ) {
        local $MT::plugin_registry = $c->{registry};
        $init->( $c, @_ );
    }
    elsif ( $c->can('init_app') ) {
        local $MT::plugin_registry = $c->{registry};
        $c->init_app(@_);
    }
}

sub on_init_request {
    my $cb      = shift;
    my $c       = $cb->plugin;
    my ($app)   = @_;
    my $app_pkg = ref $app;
    my $init;
    if ( $init = _getset( $c, 'init_request' ) ) {
        if ( ref $init eq 'HASH' ) {
            $init = $init->{$app_pkg} if exists $init->{$app_pkg};
        }
    }
    else {
        $init = $c->registry( "applications", $app->id, "init_request" );
    }
    if ( $init && !ref($init) ) {
        $init = MT->handler_to_coderef($init);
    }
    if ( ref $init eq 'CODE' ) {
        local $MT::plugin_registry = $c->{registry};
        $init->( $app, @_ );
    }
}

sub _getset {
    my $c = shift;
    my ($prop) = @_;
    if ( exists $c->{registry}{$prop} ) {
        if ( @_ > 1 ) {
            return $c->{registry}{$prop} = $_[1];
        }
        else {
            my $out = $c->{registry}{$prop};

            # Handle reference to another YAML file
            # (ie, app-cms.yaml/tags.yaml/etc.)
            if ( defined($out) && !ref($out) && ( $out =~ m/^[-\w]+\.yaml$/ ) )
            {
                my $r = $c->load_registry($out);
                if ($r) {
                    return $c->{registry}{$prop} = $r;
                }
                return undef;
            }
            return $out;
        }
    }
    return @_ > 1 ? $c->{$prop} = $_[1] : $c->{$prop};
}

sub _getset_translate {
    my $c = shift;
    my ($p) = @_;
    if ( !$p ) {
        $p = ( caller(1) )[3];
        $p =~ s/.*:://;
    }
    my $return;
    if ( exists $c->{registry}{$p} ) {
        $return = @_ > 1 ? $c->{registry}{$p} = $_[1] : $c->{registry}{$p};
    }
    else {
        $return = @_ > 1 ? $c->{$p} = $_[1] : $c->{$p};
    }
    return $c->l10n_filter( defined $return ? $return : '' );
}

sub name { &_getset_translate }

sub label {
    my $c = shift;
    return $c->_getset('label') || $c->name();
}

sub description { &_getset_translate }

sub needs_upgrade {
    my $c  = shift;
    my $sv = $c->schema_version;
    return 0 unless defined $sv;
    my $key     = 'PluginSchemaVersion';
    my $id      = $c->id;
    my $ver     = MT->config($key);
    my $cfg_ver = $ver->{$id} if $ver;
    if ( ( !defined $cfg_ver ) || ( $cfg_ver < $sv ) ) {
        return 1;
    }
    0;
}

sub template_paths {
    my $c = shift;

    my $mt   = MT->instance;
    my $path = $mt->config('TemplatePath');

    my @paths;
    my $dir = File::Spec->catdir( $c->path, 'tmpl' );
    push @paths, $dir if -d $dir;
    $dir = $c->path;
    push @paths, $dir if -d $dir;
    if ( my $alt_path = $mt->config('AltTemplatePath') ) {
        if ( -d $alt_path ) {    # AltTemplatePath is absolute
            push @paths, File::Spec->catdir( $alt_path, $mt->{template_dir} )
              if $mt->{template_dir};
            push @paths, $alt_path;
        }
    }
    push @paths, File::Spec->catdir( $path, $mt->{template_dir} )
      if $mt->{template_dir};
    push @paths, $path;
    return @paths;
}

sub load_tmpl {
    my $c = shift;
    my ($file, $param) = @_;

    my $mt = MT->instance;
    my $type = { 'SCALAR' => 'scalarref', 'ARRAY' => 'arrayref' }->{ ref $file }
      || 'filename';

    require MT::Template;
    my $tmpl = MT::Template->new(
        type   => $type,
        source => $file,
        path   => [ $c->template_paths ],
        ($mt->isa('MT::App') ? ( filter => sub {
            my ($str, $fname) = @_;
            if ($fname) {
                $fname = File::Basename::basename($fname);
                $fname =~ s/\.tmpl$//;
                $mt->run_callbacks("template_source.$fname", $mt, @_);
            } else {
                $mt->run_callbacks("template_source", $mt, @_);
            }
            return $str;
        }) : ()),
    );
    return $c->error(
        $mt->translate( "Loading template '[_1]' failed: [_2]", $file, MT::Template->errstr ) )
      unless defined $tmpl;
    my $text = $tmpl->text;
    if (($text =~ m/<(mt|_)_trans/i) && ($c->id)) {
        $tmpl->text( '<__trans_section component="' . $c->id . '">' . $text . '</__trans_section>');
    }
    $tmpl->{__file} = $file if $type eq 'filename';

    ## We do this in load_tmpl because show_error and login don't call
    ## build_page; so we need to set these variables here.
    $mt->set_default_tmpl_params($tmpl);
    $tmpl->param($param) if $param;

    return $tmpl;
}

sub l10n_class { _getset( shift, 'l10n_class', @_ ) || 'MT::L10N' }

sub translate {
    my $c       = shift;
    my $handles = MT->request('l10n_handle') || {};
    my $h       = $handles->{ $c->id };
    unless ($h) {
        my $lang = MT->current_language || MT->config->DefaultLanguage;
        eval "require " . $c->l10n_class . ";";
        if ($@) {
            $h = MT->language_handle;
        }
        else {
            $h = $c->l10n_class->get_handle($lang);
        }
        $handles->{ $c->id } = $h;
        MT->request( 'l10n_handle', $handles );
    }
    my ( $format, @args ) = @_;
    foreach (@args) {
        $_ = $_->() if ref($_) eq 'CODE';
    }
    my $enc = MT->instance->config('PublishCharset');
    my $str;
    if ($h) {
        if ( $enc =~ m/utf-?8/i ) {
            $str = $h->maketext( $format, @args );
        }
        else {
            $str = MT::I18N::encode_text(
                $h->maketext(
                    $format,
                    map { MT::I18N::encode_text( $_, $enc, 'utf-8' ) } @args
                ),
                'utf-8', $enc
            );
        }
    }
    if ( !defined $str ) {
        $str = MT->translate(@_);
    }
    $str;
}

sub translate_templatized {
    my $c = shift;
    my ($text) = @_;
    my @cstack;
    while (1) {
        $text =~ s!(<(/)?(?:_|MT)_TRANS(_SECTION)?(?:(?:\s+((?:\w+)\s*=\s*(["'])(?:(<(?:[^"'>]|"[^"]*"|'[^']*')+)?>|[^\5]+?)*?\5))+?\s*/?)?>)!
        my($msg, $close, $section, %args) = ($1, $2, $3);
        while ($msg =~ /\b(\w+)\s*=\s*(["'])((?:<(?:[^"'>]|"[^"]*"|'[^']*')+?>|[^\2])*?)?\2/g) {  #"
            $args{$1} = $3;
        }
        if ($section) {
            if ($close) {
                $c = pop @cstack;
            } else {
                if ($args{component}) {
                    push @cstack, $c;
                    $c = MT->component($args{component});
                }
                else {
                    die "__trans_section without a component argument";
                }
            }
            '';
        } else {
            $args{params} = '' unless defined $args{params};
            my @p = map MT::Util::decode_html($_),
                    split /\s*%%\s*/, $args{params}, -1;
            @p = ('') unless @p;
            my $translation = $c->translate($args{phrase}, @p);
            if (exists $args{escape}) {
                if (lc($args{escape}) eq 'html') {
                    $translation = MT::Util::encode_html($translation);
                } elsif (lc($args{escape}) eq 'url') {
                    $translation = MT::Util::encode_url($translation);
                } else {
                    # fallback for js/javascript/singlequotes
                    $translation = encode_js($translation);
                }
            }
            $translation;
        }
        !igem or last;
    }
    return $text;
}

sub l10n_filter { $_[0]->translate_templatized( $_[1] ) }

# can be invoked statically or with an instance.
# if invoked statically, it queries all available plugins
#   MT::Plugin->registry("applications")
# if invoked with an instance, it only selects for that plugin's registry
#   $foo_plugin->registry("applications")

sub registry {
    my $c = shift;
    if ( ref $c ) {
        if ( !@_ ) { return $c->{registry} ||= {} }
        if ( ref $_[0] ) {
            return $c->{registry} = shift;
        }
        my @path = @_;
        my $r    = $c->{registry};
        return undef unless $r;
        my ( $last_r, $last_p );
        foreach my $p (@path) {
            if ( ref $p ) {

                # Handle the case where an assignment
                # is being made to a registry item. Ie
                # $comp->registry("foo","bar","baz", { stuff => ... })
                $last_r->{$last_p} = $p;
                $r = $last_r;
                last;
            }
            if ( exists $r->{$p} ) {
                my $v = $r->{$p};

                # check for a yaml file reference...
                if ( !ref($v) ) {
                    if ( $v =~ m/^[-\w]+\.yaml$/ ) {
                        my $f = File::Spec->catfile( $c->path, $v );
                        if ( -f $f ) {
                            require YAML::Tiny;
                            my $y = eval { YAML::Tiny->read($f) }
                                or die "Error reading $f: "
                                    . $YAML::Tiny::errstr;
                            # skip over non-hash elements
                            shift @$y
                                while @$y && ( ref( $y->[0] ) ne 'HASH' );
                            $r->{$p} = $y->[0] if @$y;
                        }
                    } elsif ($v =~ m/^\$\w+::/) {
                        my $code = MT->handler_to_coderef($v);
                        if (ref $code eq 'CODE') {
                            $r->{$p} = $code->($c);
                        }
                    }
                }
                elsif ( ref($v) eq 'CODE' ) {
                    $r->{$p} = $v->($c);
                }
                $last_r = $r;
                $last_p = $p;
                $r      = $r->{$p};
            }
            else {
                return undef;
            }
        }

        # deepscan for any label elements since they will need translation
        if ( ref $r eq 'HASH' ) {
            __deep_localize_labels( $c, $r );
            weaken($_->{plugin} = $c)
                for grep { ref $_ eq 'HASH' } values %$r;
        }

        # $r should now be the element of the path requested
        return $r;
    }
    else {
        my @objs = $c->select();
        my @list;
        foreach my $o (@objs) {
            my $r = $o->registry(@_);
            push @list, $r if defined $r;
        }
        return @list ? \@list : undef;
    }
}

sub __deep_localize_labels {
    my ( $c, $hash ) = @_;
    foreach my $k ( keys %$hash ) {
        if ( ref( $hash->{$k} ) eq 'HASH' ) {
            __deep_localize_labels( $c, $hash->{$k} );
        }
        else {
            next unless $k =~ m/(?:\b|_)label\b/;
            if ( !ref( my $label = $hash->{$k} ) ) {
                $hash->{$k} = sub { $c->translate($label) };
            }
        }
    }
}

1;
__END__

=head1 NAME

MT::Component - Movable Type class that describes a component.

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ARGUMENTS

=over 4

=item * id (recommended)

=item * label

=item * version

The version number for the release of the plugin. Will be displayed
next to the plugin's name wherever listed. This information is not
required, but recommended.

=item * schema_version

If your plugin declares a list of object classes, the schema_version
is used to determine whether your classes require installation or
upgrade. MT will store your plugin's schema_version in the C<MT::Config>
table for future reference.

=back

=head1 METHODS

=head1 LOCALIZATION

=head1 AUTHOR & COPYRIGHT

Please see L<MT/AUTHOR & COPYRIGHT>.

=cut
