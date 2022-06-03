# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Component;

use strict;
use warnings;
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
    return @MT::Plugins    if $class eq 'MT::Plugin';
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
                if (ref $callbacks->{$cbname} eq 'CODE'
                    || ( ref $callbacks->{$cbname} eq ''
                        && $callbacks->{$cbname} )
                    )
                {
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
    if ( my $init = _getset( $c, 'init' ) ) {
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
    require MT::Util::YAML;
    my $y = eval { MT::Util::YAML::LoadFile($path) }
        or die "Error reading $path: "
        . ( MT::Util::YAML->errstr || $@ || $! );
    return $y;
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
    my $c       = shift;
    my $root_cb = _getset( $c, 'callbacks' ) || {};
    my $apps    = _getset( $c, 'applications' );
    for my $app ( keys %$apps ) {
        my @path = qw( applications );
        push @path, $app;
        my $r = $c->registry(@path);
        if ($r) {
            my $cb = _getset( $r, 'callbacks' ) || {};
            MT::__merge_hash( $root_cb, $cb );
        }
    }
    return $root_cb;
}

# STUB
sub init_app     { }
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
            if (   defined($out)
                && !ref($out)
                && ( $out =~ m/^[-\w]+\.yaml$/ ) )
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

sub name {&_getset_translate}

sub label {
    my $c = shift;
    return $c->_getset('label') || $c->name();
}

sub description {&_getset_translate}

sub pack_link   {&_getset_translate}
sub author_link {&_getset_translate}

sub needs_upgrade {
    my $c  = shift;
    my $sv = $c->schema_version;
    return 0 unless defined $sv;
    my $key = 'PluginSchemaVersion';
    my $id  = $c->id;
    my $ver = MT->config($key);
    my $cfg_ver;
    $cfg_ver = $ver->{$id} if $ver;

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
    if ( $mt->{plugin_template_path} ) {
        if (File::Spec->file_name_is_absolute( $mt->{plugin_template_path} ) )
        {
            push @paths, $mt->{plugin_template_path}
                if -d $mt->{plugin_template_path};
        }
        else {
            my $dir = File::Spec->catdir( $mt->app_dir,
                $mt->{plugin_template_path} );
            if ( -d $dir ) {
                push @paths, $dir;
            }
            else {
                $dir = File::Spec->catdir( $mt->mt_dir,
                    $mt->{plugin_template_path} );
                push @paths, $dir if -d $dir;
            }
        }
    }
    my @alt_paths = $mt->config('AltTemplatePath');
    foreach my $alt_path (@alt_paths) {
        if ( -d $alt_path ) {    # AltTemplatePath is absolute
            push @paths, File::Spec->catdir( $alt_path, $mt->{template_dir} )
                if $mt->{template_dir};
            push @paths, $alt_path;
        }
    }
    if ( UNIVERSAL::isa( $c, 'MT::Plugin' ) ) {
        for my $addon ( @{ $mt->find_addons('pack') } ) {
            push @paths,
                File::Spec->catdir( $addon->{path}, 'tmpl',
                $mt->{template_dir} )
                if $mt->{template_dir};
            push @paths, File::Spec->catdir( $addon->{path}, 'tmpl' );
        }
    }
    push @paths, File::Spec->catdir( $path, $mt->{template_dir} )
        if $mt->{template_dir};
    push @paths, $path;
    return @paths;
}

sub load_tmpl {
    my $c = shift;
    my ( $file, $param ) = @_;

    my $mt = MT->instance;
    my $type
        = { 'SCALAR' => 'scalarref', 'ARRAY' => 'arrayref' }->{ ref $file }
        || 'filename';

    require MT::Template;
    my $tmpl = MT::Template->new(
        type   => $type,
        source => $file,
        path   => [ $c->template_paths ],
        (   $mt->isa('MT::App')
            ? ( filter => sub {
                    my ( $str, $fname ) = @_;
                    if ($fname) {
                        $fname = File::Basename::basename($fname);
                        $fname =~ s/\.tmpl$//;
                        $mt->run_callbacks( "template_source.$fname", $mt,
                            @_ );
                    }
                    else {
                        $mt->run_callbacks( "template_source", $mt, @_ );
                    }
                    return $str;
                }
                )
            : ()
        ),
    );
    return $c->error(
        $mt->translate(
            "Loading template '[_1]' failed: [_2]", $file,
            MT::Template->errstr
        )
    ) unless defined $tmpl;
    my $text = $tmpl->text;
    if ( ( $text =~ m/<(mt|_)_trans/i ) && ( $c->id ) ) {
        $tmpl->text( '<__trans_section component="'
                . $c->id . '">'
                . $text
                . '</__trans_section>' );
    }
    $tmpl->{__file} = $file if $type eq 'filename';

    ## We do this in load_tmpl because show_error and login don't call
    ## build_page; so we need to set these variables here.
    $mt->set_default_tmpl_params($tmpl);
    $tmpl->param($param) if $param;

    return $tmpl;
}

sub l10n_class { _getset( shift, 'l10n_class', @_ ) || '' }

sub translate {
    my $c       = shift;
    my $handles = MT->request('l10n_handle') || {};
    my $lang    = MT->current_language || MT->config->DefaultLanguage;
    my $h       = $handles->{ $c->id };

    if ( !defined $h ) {
        $h = $handles->{ $c->id } = $c->_init_l10n_handle($lang) || 0;
        MT->request( 'l10n_handle', $handles );
    }

    my ( $format, @args ) = @_;
    foreach (@args) {
        $_ = $_->() if ref($_) eq 'CODE';
    }
    my $str;
    eval {
        if ($h) {
            $str = $h->maketext( $format, @args );
        }
        if ( !defined $str ) {
            $str = MT->translate(@_);
        }
    };
    $str = $format unless $str;
    $str;
}

## If Component has Lexicon in his registry, merge them to L10N modules, or
## create as new module.
## Locale::Maketext::get_handle has NO second try, so we have to create all
## possibly modules before invoking Locale::Maketext::get_handle.
sub _init_l10n_handle {
    my $c          = shift;
    my ($lang)     = @_;
    my $l10n_reg   = $c->registry('l10n_lexicon') || {};
    my $base_class = $c->l10n_class;
    if ( !$base_class ) {
        my $id = $c->id;
        $id =~ s/[\W]//g;
        return if $id !~ /^[a-zA-Z]/;
        $base_class = join( '::', $id, 'L10N' );
    }
    $c->_generate_l10n_module( $base_class, 'MT::Plugin::L10N' );
    ## we need en_us because he is the default language.
    ## TBD: ... is it truth?
    my $en_us = join '::', $base_class, 'en_us';
    my $en_us_lexicon = $c->registry( 'l10n_lexicon', 'en_us' ) || {};
    $c->_generate_l10n_module( $en_us, $base_class, $en_us_lexicon );
    my $lang_tag = lc $lang;
    $lang_tag =~ s/-/_/g;
    if ( $lang_tag ne 'en_us' ) {
        my $lexicon = $c->registry( 'l10n_lexicon', $lang_tag );
        my $class = join '::', $base_class, $lang_tag;
        $c->_generate_l10n_module( $class, $en_us, $lexicon );
    }
    require Locale::Maketext;
    return Locale::Maketext::get_handle( $base_class, $lang_tag );
}

sub _generate_l10n_module {
    my $c = shift;
    my ( $class, $base, $lexicon ) = @_;
    my $got_class;
    if ( $c->id eq 'core' ) {
        eval "require $class";
        $got_class = 1;
    }
    elsif ( ( MT->config('RequiredCompatibility') || 0 ) < 5.0 ) {
        my @paths = split '::', $class;
        $paths[-1] .= '.pm';
        my $inc_path = join '/', @paths;
        if ( exists $INC{$inc_path} ) {
            ## l10n class is already loaded.
            return $class;
        }
        my $path = File::Spec->catfile( $c->path, 'lib', $inc_path );
        require MT::FileMgr;
        my $fmgr = MT::FileMgr->new('Local');
        if ( $fmgr->exists($path) ) {
            ## automatically decoded here!
            my $file = $fmgr->get_data($path);
            eval "$file";
            $got_class = !$@ ? 1 : 0;
            $INC{$inc_path} = $path;
        }
    }
    else {
        eval "require $class";
        $got_class = !$@ ? 1 : 0;
    }

    if ($got_class) {
        if ( !ref $lexicon ) {
            $lexicon = MT->handler_to_coderef($lexicon);
        }
        if ( 'CODE' eq ref $lexicon ) {
            $lexicon = $lexicon->();
        }
        if ( 'HASH' eq ref $lexicon ) {
            no strict 'refs';
            %{ $class . '::Lexicon' }
                = ( %{ $class . '::Lexicon' }, %$lexicon );
        }
    }
    else {
        my $lexicon_code = $lexicon ? 'use vars qw( %Lexicon );' : '';
        my $code = <<"CODE";
package $class;
use base qw( $base );
$lexicon_code
1;
CODE
        eval $code;
        die "Failed to make L10N handle: $code : $@" if $@;
        if ($lexicon) {
            if ( !ref $lexicon ) {
                $lexicon = MT->handler_to_coderef($lexicon);
            }
            if ( 'CODE' eq ref $lexicon ) {
                $lexicon = $lexicon->();
            }
            {
                no strict 'refs';
                %{ $class . '::Lexicon' } = (%$lexicon);
            }
        }
    }
    return $class;
}

sub translate_templatized {
    my $c = shift;
    my ($text) = @_;
    return "" unless defined $text;

    # Here, the text must be handled as binary ( non utf-8 ) data,
    # because regexp for utf-8 string is too heavy.
    # things we have to do is
    #  * encode $text before parse
    #  * decode the strings captured by regexp
    #  * encode the translated string from translate()
    #  * decode again for return
    $text = Encode::encode( 'utf8', $text )
        if Encode::is_utf8($text);
    my @cstack;
    while (1) {
        $text
            =~ s!(<(/)?(?:_|MT)_TRANS(_SECTION)?(?:(?:\s+((?:\w+)\s*=\s*(["'])(?:(<(?:[^"'>]|"[^"]*"|'[^']*')+)?>|[^\5]+?)*?\5))+?\s*/?)?>)!
        my($msg, $close, $section, %args) = ($1, $2, $3);
        while ($msg =~ /\b(\w+)\s*=\s*(["'])((?:<(?:[^"'>]|"[^"]*"|'[^']*')+?>|[^\2])*?)?\2/g) {  #"
            $args{$1} = Encode::is_utf8($3) ? $3 : Encode::decode_utf8($3);
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
            my @p = split /\s*%%\s*/, $args{params}, -1;
            @p = ('') unless @p;
            my $phrase = $args{phrase};
            $phrase = Encode::decode_utf8($phrase) unless Encode::is_utf8($phrase);
            my $translation = $c->translate($phrase, @p);
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
            $translation = Encode::encode('utf8', $translation)
                if Encode::is_utf8($translation);
            $translation;
        }
        !igem or last;
    }
    $text = Encode::decode_utf8($text) unless Encode::is_utf8($text);
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
            $c->{__localized} = 0;
            return $c->{registry} = shift;
        }
        my @path   = @_;
        my $r      = $c->{registry} ||= {};
        my $setter = grep { ref $_ } @_;
        return undef if ( !$r && !$setter );

        # deepscan for any label elements since they will need translation
        if ( !$c->{__localized} ) {
            __deep_localize_labels( $c, $r );
            $c->{__localized} = 1;
        }
        my ( $last_r, $last_p );
        foreach my $p (@path) {
            if ( ref $p ) {

                # Handle the case where an assignment
                # is being made to a registry item. Ie
                # $comp->registry("foo","bar","baz", { stuff => ... })
                __deep_localize_labels( $c, $p );
                $last_r->{$last_p} = $p;
                $r = $last_r;
                last;
            }

            if ( exists $r->{$p} ) {
                my $v = $r->{$p};

                # check for a yaml file reference...
                if ( !ref($v) && $v ) {
                    if ( $v =~ m/^[-\w]+\.yaml$/ ) {
                        my $f = File::Spec->catfile( $c->path, $v );
                        if ( -f $f ) {
                            require MT::Util::YAML;
                            my $y = eval { MT::Util::YAML::LoadFile($f) }
                                or die "Error reading $f: "
                                . ( MT::Util::YAML->errstr || $@ || $! );
                            if ($y) {
                                __deep_localize_labels( $c, $y )
                                    if ref $y eq 'HASH';
                                $r->{$p} = $y;
                            }
                        }
                    }
                    elsif ( $v =~ m/^\$\w+::/ ) {
                        my $code = MT->handler_to_coderef($v);
                        if ( ref $code eq 'CODE' ) {
                            my $res = $code->($c);
                            __deep_localize_labels( $c, $res )
                                if $res && ref $res eq 'HASH';
                            $r->{$p} = $res;
                        }
                    }
                }
                elsif ( ref($v) eq 'CODE' ) {
                    my $res = $v->($c);
                    __deep_localize_labels( $c, $res )
                        if $res && ref $res eq 'HASH';
                    $r->{$p} = $res;
                }
                $last_r = $r;
                $last_p = $p;
                $r      = $r->{$p};
            }
            elsif ($setter) {
                $r->{$p} = {};
                $last_r  = $r;
                $last_p  = $p;
                $r       = $r->{$p};
            }
            else {
                return undef;
            }
        }

        if ( ref $r eq 'HASH' ) {
            weaken( $_->{plugin} = $c )
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
            next unless $k =~ m/(?:\b|_)(?:hint|label|label_plural)\b/;
            next
                if exists $hash->{'no_translate'}
                && $hash->{'no_translate'}->{$k};
            if ( !ref( my $label = $hash->{$k} ) ) {
                $hash->{$k} = sub { $c->translate($label) };
            }
        }
    }
}

sub __deep_localize_templatized_values {
    my ( $c, $hash ) = @_;
    foreach my $k ( keys %$hash ) {
        if ( ref( $hash->{$k} ) eq 'HASH' ) {
            __deep_localize_templatized_values( $c, $hash->{$k} );
        }
        else {
            next unless $k =~ m/\A(?:
                  name
                | description
                | category_field
                | category_set
                | content_type
                | datetime_field
                | source
            )\z/x;
            if ( !ref( my $value = $hash->{$k} ) ) {
                $hash->{$k} = $c->translate_templatized($value);
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
