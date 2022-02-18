# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Template;

use strict;
use warnings;
use utf8;
use open ':utf8';
use base qw( MT::Object MT::Revisable );
use MT::Util qw( weaken );

use MT::Template::Node;
sub NODE () {'MT::Template::Node'}

our $DEBUG;

__PACKAGE__->install_properties(
    {   column_defs => {
            'id'              => 'integer not null auto_increment',
            'blog_id'         => 'integer not null',
            'content_type_id' => 'integer',
            'name'            => {
                type       => 'string',
                size       => '255',
                not_null   => 1,
                label      => 'Name',
                revisioned => 1,
            },
            'type'    => 'string(25) not null',
            'outfile' => {
                type       => 'string',
                size       => '255',
                label      => 'Output File',
                revisioned => 1
            },
            'text' => {
                type       => 'text',
                label      => 'Template Text',
                revisioned => 1
            },
            'linked_file' => {
                type       => 'string',
                size       => '255',
                revisioned => 1,
            },
            'linked_file_mtime' => 'string(10)',
            'linked_file_size'  => 'integer',
            'rebuild_me'        => {
                type       => 'boolean',
                label      => 'Rebuild with Indexes',
                revisioned => 1,
            },
            'build_dynamic' => {
                type       => 'boolean',
                label      => 'Dynamicity',
                revisioned => 1
            },
            'identifier' => {
                type       => 'string',
                size       => 50,
                revisioned => 1
            },
            'build_type' => {
                type       => 'smallint',
                label      => 'Build Type',
                revisioned => 1
            },
            'build_interval' => {
                type       => 'integer',
                label      => 'Interval',
                revisioned => 1,
            },

            # meta properties
            'last_rebuild_time'     => 'integer meta',
            'page_layout'           => 'string meta',
            'include_with_ssi'      => 'integer meta',
            'cache_expire_type'     => 'integer meta',
            'cache_expire_interval' => 'integer meta',
            'cache_expire_event'    => 'string meta',
            'cache_path'            => 'string meta',
            'modulesets'            => 'string meta',
            'revision'              => 'integer meta',
        },
        indexes => {
            blog_id         => 1,
            name            => 1,
            type            => 1,
            outfile         => 1,
            identifier      => 1,
            content_type_id => 1,
        },
        defaults => {
            'rebuild_me'     => 1,
            'build_dynamic'  => 0,
            'build_type'     => 1,
            'build_interval' => 0,
        },
        meta          => 1,
        child_of      => 'MT::Blog',
        child_classes => [ 'MT::TemplateMap', 'MT::FileInfo' ],
        audit         => 1,
        datasource    => 'template',
        primary_key   => 'id',
    }
);
__PACKAGE__->add_trigger( 'pre_remove' => \&pre_remove_children );

use MT::Builder;
use MT::Blog;
use File::Spec;

sub class_label {
    MT->translate("Template");
}

sub class_label_plural {
    MT->translate("Templates");
}

sub list_props {
    return +{
        id      => { base => '__virtual.id', display => 'none', },
        name    => { auto => 1,              display => 'none' },
        blog_id => {
            auto    => 1,
            display => 'none',
        },
        type => {
            auto  => 1,
            terms => sub {
                my $prop = shift;
                my ( $args, $db_terms, $db_args ) = @_;
                return +{ type => $args->{value} };
            },
            display => 'none',
        },
        created_on => {
            base    => '__virtual.created_on',
            display => 'none',
        },
        modified_on => {
            base    => '__virtual.modified_on',
            display => 'none',
        },
        created_by => {
            auto    => 1,
            display => 'none',
        },
        modified_by => {
            auto    => 1,
            display => 'none',
        },
        content => {
            base    => '__virtual.content',
            fields  => [qw( name identifier text )],
            display => 'none',
        },
    };
}

sub new {
    my $pkg = shift;
    my (%param) = @_;
    if ( my $type = delete $param{type} ) {
        if ( $type eq 'filename' ) {
            return $pkg->new_file( $param{source}, %param );
        }
        elsif ( $type eq 'scalarref' ) {
            return $pkg->new_string( $param{source}, %param );
        }
        else {
            delete $param{source} if exists $param{source};
        }
    }
    my $tmpl = $pkg->SUPER::new(@_);
    $tmpl->{include_path}   = $param{path};
    $tmpl->{include_filter} = $param{filter};
    return $tmpl;
}

sub new_file {
    my $pkg = shift;
    my ( $file, %param ) = @_;
    my $tmpl = $pkg->new;
    $tmpl->{include_path}   = $param{path};
    $tmpl->{include_filter} = $param{filter};
    $tmpl->{__file}         = $file;
    my $contents = $tmpl->load_file($file);
    if ( defined $contents ) {

        if ( $tmpl->{include_filter} ) {
            $tmpl->{include_filter}->( \$contents, $file );
        }
        $tmpl->text($contents);
        return $tmpl;
    }
    return $pkg->trans_error( "File not found: [_1]", $file )
        ;    # load_file errror;
}

sub new_string {
    my $pkg = shift;
    my ( $str, %param ) = @_;
    my $tmpl = $pkg->new;
    $tmpl->{include_path}   = $param{path};
    $tmpl->{include_filter} = $param{filter};
    if ( ref($str) && defined($$str) ) {
        if ( $tmpl->{include_filter} ) {
            $tmpl->{include_filter}->($str);
        }
        $tmpl->text($$str);
    }
    return $tmpl;
}

sub load_file {
    my $tmpl = shift;
    my ($file) = @_;

    # Canonicalize
    my $real_file = MT::Util::canonicalize_path($file);
    $real_file = MT::Util::realpath($file);

    # Find template via include_path
    unless ( File::Spec->file_name_is_absolute($real_file) ) {
        my @paths = @{ $tmpl->{include_path} || [] };
        my $ok = 0;
        foreach my $path (@paths) {
            my $test_file = File::Spec->catfile( $path, $real_file );
            $test_file = MT::Util::canonicalize_path($test_file);
            $test_file = MT::Util::realpath($test_file);
            $real_file = $test_file, $ok = 1, last if -f $test_file;
        }
        return $tmpl->trans_error( "File not found: [_1]", $file )
            unless -e $real_file;
    }

    my $ok = 0;
    my @paths = @{ $tmpl->{include_path} || [] };

    # Add plugin's load path for check
    foreach my $sig ( keys %MT::Plugins ) {
        my $obj = $MT::Plugins{$sig}{object};
        next if !$obj || ( $obj && !$obj->isa('MT::Plugin') );

        my $full_path = $obj->{full_path};
        push @paths, File::Spec->catdir( $full_path, 'tmpl' )
            if -d $full_path;
    }

    foreach my $path (@paths) {
        my $real_path = MT::Util::realpath($path);
        next unless -d $real_path;
        $ok = 1, last if $real_file =~ /^\Q$real_path\E/;
    }

    die MT->translate(
        "Template load error: [_1]",
        MT->translate(
            "Tried to load the template file from outside of the include path '[_1]'",
            $file
        )
    ) unless $ok;

    return $tmpl->trans_error( "File not found: [_1]", $file )
        unless -e $real_file;
    open my $fh, '<', $real_file
        or
        return $tmpl->trans_error( "Error reading file '[_1]': [_2]", $file,
        $! );
    my $c;
    do { local $/; $c = <$fh> };
    close $fh;
    return $c;
}

sub context {
    my $tmpl = shift;
    return $tmpl->{context} = shift if @_;
    require MT::Template::Context;
    my $ctx = $tmpl->{context} ||= MT::Template::Context->new;
    weaken( $ctx->{__stash}{'template'} = $tmpl );
    return $ctx;
}

sub param {
    my $tmpl = shift;
    my $ctx  = $tmpl->context;
    if ( @_ == 1 ) {
        if ( ref( $_[0] ) eq 'HASH' ) {
            $ctx->var( $_, $_[0]->{$_} ) for keys %{ $_[0] };
        }
        else {
            return $ctx->var( $_[0] );
        }
    }
    elsif ( @_ == 2 ) {
        $ctx->var( $_[0], $_[1] );
    }
    else {
        return $ctx->{__stash}{vars};
    }
}

sub clear_params {
    my $tmpl = shift;
    my $ctx  = $tmpl->context;
    %{ $ctx->{__stash}{vars} } = ();
}

sub reflow {
    my $tmpl = shift;
    my ($tokens) = @_;
    $tokens ||= $tmpl->tokens;

    # reconstitute text of template based on tokens
    my $str = '';
    foreach my $token (@$tokens) {
        my $tag = $token->tag;
        if ( $tag eq 'TEXT' ) {
            $str .= $token->nodeValue;
        }
        else {
            $str .= '<mt' . $tag;
            if ( my $attrs = $token->attribute_list ) {
                my $attrh = $token->attributes;
                foreach my $a (@$attrs) {
                    delete $attrh->{ $a->[0] };
                    my $v = $a->[1];
                    $v = $v =~ m/"/ ? qq{'$v'} : qq{"$v"};
                    $str .= ' ' . $a->[0] . '=' . $v;
                }
                foreach my $a ( keys %$attrh ) {
                    my $v = $attrh->{$a};
                    $v = $v =~ m/"/ ? qq{'$v'} : qq{"$v"};
                    $str .= ' ' . $a . '=' . $v;
                }
            }
            $str .= '>';
            if ( my $childNodes = $token->childNodes ) {

                # container tag
                $str .= $tmpl->reflow($childNodes);
                $str .= '</mt' . $tag . '>';
            }
        }
    }
    return $str;
}

sub build {
    my $tmpl = shift;
    my ( $ctx, $cond ) = @_;
    $ctx ||= $tmpl->context;

    my $timer = MT->get_timer();
    local $timer->{elapsed} = 0 if $timer;

    local $ctx->{__stash}{template} = $tmpl;
    my $tokens = $tmpl->tokens
        or return;

    my $tmpl_name = $tmpl->name || $tmpl->{__file} || "?";

    if ( $tmpl->{errors} && @{ $tmpl->{errors} } ) {
        my $error = "";
        foreach my $err ( @{ $tmpl->{errors} } ) {
            $error .= $err->{message};
        }
        return $tmpl->error(
            MT->translate(
                "Publish error in template '[_1]': [_2]", $tmpl_name,
                $error
            )
        );
    }

    my $build = $ctx->{__stash}{builder} || MT::Builder->new;
    my $page_layout;
    if ( my $blog_id = $tmpl->blog_id ) {
        $ctx->stash( 'blog_id',       $blog_id );
        $ctx->stash( 'local_blog_id', $blog_id )
            unless $ctx->stash('local_blog_id');
        my $blog = $ctx->stash('blog');
        unless ($blog) {
            $blog = MT->model('blog')->load($blog_id)
                or return $tmpl->error(
                MT->translate(
                    "Load of blog '[_1]' failed: [_2]", $blog_id,
                    MT::Blog->errstr
                )
                );
            $ctx->stash( 'blog', $blog );
        }
        else {
            $ctx->stash( 'blog_id',       $blog->id );
            $ctx->stash( 'local_blog_id', $blog->id )
                unless $ctx->stash('local_blog_id');
        }
        MT->request( 'time_offset', $blog->server_offset );
        $page_layout = $blog->page_layout;
    }
    my $type = $tmpl->type;
    if (   $type
        && $type ne 'module'
        && $type ne 'widget'
        && $type ne 'custom' )
    {
        $page_layout = $tmpl->page_layout if $tmpl->page_layout;
    }
    $ctx->var( 'page_layout', $page_layout )
        unless $ctx->var('page_layout');
    if ( my $layout = $ctx->var('page_layout') ) {
        my $columns = {
            'layout-wt'  => 2,
            'layout-tw'  => 2,
            'layout-wm'  => 2,
            'layout-mw'  => 2,
            'layout-wtt' => 3,
            'layout-twt' => 3,
        }->{$layout};
        $ctx->var( 'page_columns', $columns ) if $columns;
    }
    $ctx->var( $tmpl->identifier, 1 )
        if defined( $tmpl->identifier ) && !$ctx->var( $tmpl->identifier );

    $timer->pause_partial if $timer;

    my $res = $build->build( $ctx, $tokens, $cond );
    if ($DEBUG) {
        $res =~ s/\A\s+//s;
        $res =~ s/\s+\z//s;
        $res = join "",
            "<!-- begin_tmpl $tmpl_name -->",
            $res,
            "<!-- end_tmpl $tmpl_name -->";
    }

    if ($timer) {
        $timer->mark( "MT::Template::build["
                . ( $tmpl->name || $tmpl->{__file} || "?" )
                . ']' );
    }

    unless ( defined($res) ) {
        return $tmpl->error(
            MT->translate(
                "Publish error in template '[_1]': [_2]", $tmpl_name,
                $build->errstr
            )
        );
    }
    $res =~ s/^\s*//;
    return $res;
}

sub output {
    my $tmpl = shift;
    my ($param) = @_;
    $tmpl->param($param) if $param;
    return $tmpl->build();
}

sub widgets_to_modulesets {
    my $pkg = shift;
    my ( $widgets, $blog_id ) = @_;
    return unless $widgets && @$widgets;

    my @wtmpls = $pkg->load(
        {   name    => $widgets,
            blog_id => $blog_id ? [ $blog_id, 0 ] : 0,
            type    => 'widget'
        }
    );
    my @wids;
    foreach my $name (@$widgets) {
        my ($widget) = grep { $_->name eq $name } @wtmpls;
        next unless $widget;
        push @wids, $widget->id;
    }
    return join ',', @wids;
}

sub save_widgetset {
    my $obj = shift;

    my $ms = $obj->modulesets;

    # build module list
    my @inst;
    if ( $ms && $ms =~ /;/ ) {
        my @mods = split /;/, $ms;
        for (@mods) {

            # tmpl_id = column index . order in column ;
            my ( $id, $col ) = /(\d+)=(\d+)\.(\d+)/;
            push @inst, $id if $col && ( $col == 1 );
        }
        $obj->modulesets( join ',', @inst );
    }
    else {
        @inst = split /,/, ( $obj->modulesets || '' );
    }

    my @widgets;
    @widgets = MT::Template->load(
        {   id      => \@inst,
            type    => 'widget',
            blog_id => $obj->blog_id ? [ 0, $obj->blog_id ] : '0'
        },
        { fetchonly => [ 'id', 'name' ] }
    ) if @inst;

    my $string_tmpl = '<mt:include widget="%s">';
    my $text        = q();
    my @ids;
    foreach my $wid (@inst) {
        my ($tmpl) = grep { $_->id eq $wid } @widgets;
        next unless $tmpl;
        $text .= sprintf( $string_tmpl, $tmpl->name );
        push @ids, $wid;
    }
    $obj->modulesets( join ',', @ids )
        if scalar @ids != scalar @inst;
    $obj->text($text);
    return $obj->SUPER::save;
}

sub save {
    my $tmpl = shift;

    return $tmpl->error( MT->translate('Content Type is required.') )
        if ( $tmpl->type eq 'ct' || $tmpl->type eq 'ct_archive' )
        && !$tmpl->content_type_id;

    my $existing = MT::Template->load(
        {   ( $tmpl->id ? ( id => { not => $tmpl->id } ) : () ),
            name    => $tmpl->name,
            blog_id => $tmpl->blog_id,
            type    => $tmpl->type,
        }
    );
    if ($existing) {
        my $scope;
        if ( $tmpl->blog_id ) {
            my $blog = $tmpl->blog;
            $scope = lc $blog->class_label;
        }
        else {
            $scope = MT->translate('system');
        }
        return $tmpl->error(
            MT->translate(
                'Template name must be unique within this [_1].', $scope
            )
        );
    }

    if ( 'widgetset' eq $tmpl->type ) {
        return $tmpl->save_widgetset();
    }

    if ( $tmpl->id && ( $tmpl->is_changed('build_type') ) ) {

        # check for templatemaps, and update them appropriately
        require MT::TemplateMap;
        require MT::PublishOption;
        my @maps = MT::TemplateMap->load( { template_id => $tmpl->id } );
        foreach my $map (@maps) {
            if ( ( $map->build_type || 0 ) != ( $tmpl->build_type || 0 ) ) {
                $map->build_type( $tmpl->build_type );
                $map->save or die $map->errstr;
            }
        }
    }

    if ( $tmpl->linked_file ) {
        $tmpl->_sync_to_disk( $tmpl->column('text') ) or return;
    }
    $tmpl->needs_db_sync(0);

    $tmpl->SUPER::save;
}

sub build_dynamic {
    my $tmpl = shift;
    return $tmpl->column( 'build_dynamic', $_[0] ) if @_;
    require MT::PublishOption;
    return 1 if $tmpl->build_type == MT::PublishOption::DYNAMIC();
    return $tmpl->column('build_dynamic');
}

sub blog {
    my $this = shift;
    return undef unless $this->blog_id;
    return $this->{__blog} if $this->{__blog};
    return $this->{__blog} = MT::Blog->load( $this->blog_id );
}

sub content_type {
    my $self = shift;
    $self->cache_property(
        'content_type',
        sub {
            return unless $self->content_type_id;
            MT->model('content_type')->load( $self->content_type_id );
        }
    );
}

sub set_values_internal {
    my $tmpl = shift;
    my ($cols) = @_;
    if ( exists $cols->{text} ) {

        # The text column of the MT::Template object can be associated
        # with a physical file. When loading the record data from the
        # database, we should observe whether or not it is in sync with
        # the physical file. This logic handles the case where the
        # record is loaded through the MT::ObjectDriver and should
        # not apply for any other use of $tmpl->set_values, since those
        # should all be explicitly setting the template text.
        my @info = caller();
        if ( $info[0] =~ m/^MT::ObjectDriver::/ ) {
            if ( $cols->{linked_file} ) {
                my %local_cols = %$cols;
                delete $local_cols{text};
                $tmpl->SUPER::set_values_internal( \%local_cols );
                my $sync_text = $tmpl->text();
                if ( !defined $sync_text ) {
                    $tmpl->text( $cols->{text} );
                }
                return;
            }
        }
    }
    $tmpl->SUPER::set_values_internal(@_);
}

sub text {
    my $tmpl = shift;
    my $text;
    if ( $tmpl->{reflow_flag} ) {
        $tmpl->{reflow_flag} = 0;
        $text = $tmpl->reflow();
    }
    $text = $tmpl->column( 'text', @_ );

    $tmpl->needs_db_sync(0);
    unless (@_) {
        if ( $tmpl->linked_file ) {
            if ( my $res = $tmpl->_sync_from_disk ) {
                $text = $res;
                $tmpl->column( 'text', $text );
                $tmpl->needs_db_sync(1);
            }
        }
        $tmpl->reset_tokens;
    }
    $text = '' unless defined $text;
    return $text;
}

{
    my $resync_to_db;

    sub needs_db_sync {
        my $tmpl = shift;
        return if $tmpl->is_revisioned;
        if ( scalar @_ > 0 && $tmpl->id ) {
            ## We used to save the template here; now we don't, because
            ## it causes deadlock (the DB is locked from loading the
            ## template, so saving would try to write-lock it).
            if ( !defined $resync_to_db ) {
                $resync_to_db = {};
                MT->add_callback( 'take_down', 9, undef, \&_resync_to_db );
            }
            $resync_to_db->{ $tmpl->id } = $_[0] ? $tmpl : undef;
        }
        else {
            my $id = $tmpl->id or return 0;
            return
                   $resync_to_db
                && exists $resync_to_db->{$id}
                && defined $resync_to_db->{$id} ? 1 : 0;
        }
    }

    sub _resync_to_db {
        return unless defined $resync_to_db;
        return unless %$resync_to_db;
        foreach my $tmpl_id ( keys %$resync_to_db ) {
            my $tmpl = $resync_to_db->{$tmpl_id};
            next unless $tmpl;
            $tmpl->save;
        }
        $resync_to_db = {};
    }
}

sub _sync_from_disk {
    my $tmpl  = shift;
    my $lfile = $tmpl->linked_file;
    if ( $lfile eq '*' ) {
        require MT::DefaultTemplates;
        my $blog = $tmpl->blog;
        my $set  = MT::DefaultTemplates->templates(
            $blog ? $blog->template_set : () );
        my ($set_tmpl) = grep {
                   ( $_->{type} eq $tmpl->type )
                && ( $_->{identifier} eq $tmpl->identifier )
        } @$set;
        if ($set_tmpl) {
            my $c = $set_tmpl->{text};
            $c = '' unless defined $c;
            $c = MT->translate_templatized($c) if $c =~ m/<(?:mt|_)_trans\b/i;
            return $c;
        }
        return;
    }
    if ( MT->config->SafeMode ) {
        ## Check for a set of extensions that aren't allowed.
        for my $ext (qw( pl pm cgi cfg )) {
            if ( $lfile =~ /\.$ext$/i ) {
                return $tmpl->error(
                    MT->translate(
                        "You cannot use a [_1] extension for a linked file.",
                        ".$ext"
                    )
                );
            }
        }
    }
    unless ( File::Spec->file_name_is_absolute($lfile) ) {
        if ( $tmpl->blog_id ) {
            my $blog = MT::Blog->load( $tmpl->blog_id )
                or return;
            $lfile = File::Spec->catfile( $blog->site_path, $lfile );
        }
        else {

            # use MT path to base relative paths
            my $base_path = MT->config->BaseTemplatePath || MT->instance->server_path;
            $lfile = File::Spec->catfile( $base_path, $lfile );
        }
    }
    return unless -e $lfile && -w _;
    my ( $size, $mtime ) = ( stat _ )[ 7, 9 ];
    return
        if $size == $tmpl->linked_file_size
        && $mtime == $tmpl->linked_file_mtime;

# Use rw handle due to avoid that anyone do open unwritable file.
# ( -w file test operator can't detect windows ACL condition, so just try to open. )
    open my $fh, '+<', $lfile or return;
    my $c;
    do { local $/; $c = <$fh> };
    close $fh;
    $tmpl->linked_file_size($size);
    $tmpl->linked_file_mtime($mtime);
    return $c;
}

sub _sync_to_disk {
    my $tmpl   = shift;
    my ($text) = @_;
    my $lfile  = $tmpl->linked_file;
    return 1 if $lfile eq '*';
    my $cfg = MT->config;
    if ( $cfg->SafeMode ) {
        ## Check for a set of extensions that aren't allowed.
        for my $ext (qw( pl pm cgi cfg )) {
            if ( $lfile =~ /\.$ext$/i ) {
                return $tmpl->error(
                    MT->translate(
                        "You cannot use a [_1] extension for a linked file.",
                        ".$ext"
                    )
                );
            }
        }
    }
    unless ( File::Spec->file_name_is_absolute($lfile) ) {
        if ( $tmpl->blog_id ) {
            my $blog = MT::Blog->load( $tmpl->blog_id )
                or return;
            $lfile = File::Spec->catfile( $blog->site_path, $lfile );
        }
        else {
            my $base_path = MT->config->BaseTemplatePath || MT->instance->server_path;
            $lfile = File::Spec->catfile( $base_path, $lfile );
        }
    }
    ## If the linked file already exists, and there is no template text
    ## (empty textarea, etc.), then we read the template text from the
    ## linked file, assuming that it should not be overwritten. If the
    ## file does not already exist, or if there is template text, assume
    ## that we should update the linked file.
    if ( -e $lfile && !$tmpl->column('text') ) {
        open my $fh, '+<', $lfile or return;
        do { local $/; $tmpl->column( 'text', <$fh> ) };
        close $fh;
    }
    else {
        my ($vol, $dir) = File::Spec->splitpath($lfile);
        $dir = File::Spec->catpath($vol, $dir);
        unless (-d $dir) {
            require File::Path;
            eval { File::Path::mkpath($dir) } or return $tmpl->error(
                MT->translate(
                    "Opening linked file '[_1]' failed: [_2]",
                    $lfile,
                    ( Encode::is_utf8($!) ? "$!" : Encode::decode_utf8($!) )
                )
            );
        }

        my $umask = oct $cfg->HTMLUmask;
        my $old   = umask($umask);
        ## Untaint. We assume that the user knows what he/she is doing,
        ## and allow anything.
        ($lfile) = $lfile =~ /(.+)/s;
        open my $fh, '>',
            $lfile
            or return $tmpl->error(
            MT->translate(
                "Opening linked file '[_1]' failed: [_2]",
                $lfile,
                ( Encode::is_utf8($!) ? "$!" : Encode::decode_utf8($!) )
            )
            );
        print $fh $text;
        close $fh;
        umask($old);
    }
    my ( $size, $mtime ) = ( stat $lfile )[ 7, 9 ];
    $tmpl->linked_file_size($size);
    $tmpl->linked_file_mtime($mtime);
    1;
}

sub rescan {
    my $tmpl = shift;
    my ($tokens) = @_;
    unless ($tokens) {

        # top of tree; reset
        $tmpl->{__ids}     = {};
        $tmpl->{__classes} = {};

        # Use tokens if we already have them, otherwise compile
        $tokens = $tmpl->{__tokens} || $tmpl->compile;
    }
    return unless $tokens;
    foreach my $t (@$tokens) {
        if ( $t->tag ne 'TEXT' ) {
            if ( my $id = $t->getAttribute('id') ) {
                my $ids = $tmpl->{__ids} ||= {};
                $ids->{ lc $id } = $t;
            }
            elsif ( my $class = $t->getAttribute('class') ) {
                my $classes = $tmpl->{__classes} ||= {};
                push @{ $classes->{ lc $class } ||= [] }, $t;
            }
            if ( my $childNodes = $t->childNodes ) {
                $tmpl->rescan($childNodes);
            }
        }
    }
}

sub compile {
    my $tmpl = shift;
    require MT::Builder;
    my $b = new MT::Builder;
    $b->compile($tmpl) or return $tmpl->error( $b->errstr );
    return $tmpl->{__tokens};
}

sub errors {
    my $tmpl = shift;
    $tmpl->{errors} = shift if @_;
    $tmpl->{errors};
}

sub reset_tokens {
    my $tmpl = shift;
    $tmpl->{__tokens}  = undef;
    $tmpl->{__classes} = undef;
    $tmpl->{__ids}     = undef;
}

sub reset_ids {
    my $tmpl = shift;
    $tmpl->{__ids} = undef;
}

sub reset_classes {
    my $tmpl = shift;
    $tmpl->{__classes} = undef;
}

sub reset_markers {
    my $tmpl = shift;
    $tmpl->{__classes} = undef;
    $tmpl->{__ids}     = undef;
}

sub token_ids {
    my $tmpl = shift;
    if (@_) {
        return $tmpl->{__ids} = shift;
    }
    $tmpl->rescan unless $tmpl->{__ids};
    return $tmpl->{__ids};
}

sub token_classes {
    my $tmpl = shift;
    if (@_) {
        return $tmpl->{__classes} = shift;
    }
    $tmpl->rescan unless $tmpl->{__classes};
    return $tmpl->{__classes};
}

sub tokens {
    my $tmpl = shift;
    if (@_) {
        return bless $tmpl->{__tokens} = shift, 'MT::Template::Tokens';
    }
    my $t = $tmpl->{__tokens} || $tmpl->compile;
    return bless $t, 'MT::Template::Tokens' if $t;
    return undef;
}

sub published_url {
    my $tmpl = shift;

    return undef unless $tmpl->outfile;
    return undef unless ( $tmpl->type eq 'index' );

    my $blog = $tmpl->blog;
    return undef unless $blog;
    my $site_url = $blog->site_url || '';
    $site_url .= '/' if $site_url !~ m!/$!;
    my $url = $site_url . $tmpl->outfile;

    if ( $tmpl->build_dynamic ) {
        require MT::FileInfo;
        my @finfos = MT::FileInfo->load(
            {   blog_id     => $tmpl->blog_id,
                template_id => $tmpl->id
            }
        );
        if ( scalar @finfos == 1 ) {
            return $url;
        }
    }
    else {
        my $site_path = $blog->site_path || '';
        my $tmpl_path = File::Spec->catfile( $site_path, $tmpl->outfile );
        if ( -f $tmpl_path ) {
            return $url;
        }
    }
    undef;
}

sub pre_remove_children {
    my $tmpl = shift;
    $tmpl->remove_children( { key => 'template_id' } );
}

sub post_remove_widget {
    my $tmpl = shift;
    return unless $tmpl->type eq 'widget';

    my $iter = MT::Template->load_iter(
        {   blog_id => [ $tmpl->blog_id, 0 ],
            type    => 'widgetset',
        }
    );
    my @resave;
    while ( my $ws = $iter->() ) {
        my @mods = split( ',', $ws->modulesets || '' );
        if ( grep { $_ == $tmpl->id } @mods ) {
            push @resave, $ws;
        }
    }
    $_->save for @resave;
}
__PACKAGE__->add_trigger( 'post_remove' => \&post_remove_widget );

# Some DOM-inspired methods (replicating the interface, so it's more
# familiar to those who know DOM)
sub getElementsByTagName {
    my $tmpl = shift;
    return MT::Template::Tokens::getElementsByTagName( $tmpl->tokens, @_ );
}

sub getElementsByClassName {
    my $tmpl    = shift;
    my ($name)  = @_;
    my $classes = $tmpl->token_classes;
    my $tokens  = $classes->{ lc $name };
    if ( $tokens && @$tokens ) {

        #@$tokens = map { bless $_, NODE } @$tokens;
        return @$tokens;
    }
    return ();
}

sub getElementsByName {
    my $tmpl = shift;
    return MT::Template::Tokens::getElementsByName( $tmpl->tokens, @_ );
}

sub getElementById {
    my $tmpl = shift;
    my ($id) = @_;
    if ( my $node = $tmpl->token_ids->{$id} ) {
        return $node;
    }
    undef;
}

sub createElement {
    my $tmpl = shift;
    my ( $tag, $attr ) = @_;
    return NODE->new( tag => $tag, attributes => $attr, template => $tmpl );
}

sub createTextNode {
    my $tmpl = shift;
    my ($text) = @_;
    return NODE->new( tag => 'TEXT', nodeValue => $text, template => $tmpl );
}

sub insertAfter {
    my $tmpl = shift;
    my ( $node1, $node2 ) = @_;
    my $parent_node
        = $node2 && $node2->parentNode ? $node2->parentNode : $tmpl;
    my $parent_array = $parent_node->childNodes;
    if ($node2) {
        for ( my $i = 0; $i < scalar @$parent_array; $i++ ) {
            if ( $parent_array->[$i] == $node2 ) {
                $node1->parentNode($parent_node);
                splice( @$parent_array, $i + 1, 0, $node1 );
                return 1;
            }
        }
        return 0;
    }
    else {
        $node1->parentNode($parent_node);
        push @$parent_array, $node1;
        return 1;
    }
    return 0;
}

sub insertBefore {
    my $tmpl = shift;
    my ( $node1, $node2 ) = @_;
    my $parent_node
        = $node2 && $node2->parentNode ? $node2->parentNode : $tmpl;
    my $parent_array = $parent_node->childNodes;
    if ($node2) {
        for ( my $i = 0; $i < scalar @$parent_array; $i++ ) {
            if ( $parent_array->[$i] == $node2 ) {
                $node1->parentNode($parent_node);
                splice( @$parent_array, $i, 0, $node1 );
                return 1;
            }
        }
        return 0;
    }
    else {
        $node1->parentNode($parent_node);
        unshift @$parent_array, $node1;
        return 1;
    }
    return 0;
}

sub childNodes {
    my $tmpl = shift;
    return $tmpl->tokens;
}

sub hasChildNodes {
    my $tmpl  = shift;
    my $nodes = $tmpl->childNodes;
    return $nodes && (@$nodes) ? 1 : 0;
}

sub appendChild {
    my $tmpl       = shift;
    my ($new_node) = @_;
    my $nodes      = $tmpl->childNodes;
    push @$nodes, $new_node;
    $tmpl->{reflow_flag} = 1;
}

# compute a cache-key based on the template fields
sub get_cache_key {
    my $self = shift;
    require MT::Util::Digest::MD5;
    require Encode;
    my $cache_key = MT::Util::Digest::MD5::md5_hex(
        Encode::encode_utf8(
                  'blog::'
                . $self->blog_id
                . '::template_'
                . $self->type . '::'
                . $self->name
        )
    );
    return $cache_key;
}

# Alias to perl_function_names for those that may prefer that.
# *get_elements_by_tag_name = \&getElementsByTagName;
# *get_elements_by_name = \&getElementsByName;
# *get_element_by_id = \&getElementById;
# *create_element = \&createElement;

# functionality for individual nodes gathered by DOM-like query operations.

package MT::Template::Tokens;

use strict;

sub getElementsByTagName {
    my ( $tokens, $name ) = @_;
    my @list;
    $name = lc $name;
    foreach my $t (@$tokens) {
        if ( lc $t->tag eq $name ) {
            push @list, $t;
        }
        if ( my $childNodes = $t->childNodes ) {
            my $subt = getElementsByTagName( $childNodes, $name );
            push @list, @$subt if $subt;
        }
    }
    scalar @list ? \@list : undef;
}

sub getElementsByName {
    my ( $tokens, $name ) = @_;
    my @list;
    $name = lc $name;
    foreach my $t (@$tokens) {
        if ( lc( $t->getAttribute('name') || '' ) eq $name ) {
            push @list, $t;
        }
        if ( my $childNodes = $t->childNodes ) {
            my $subt = getElementsByName( $childNodes, $name );
            push @list, @$subt if $subt;
        }
    }
    scalar @list ? \@list : undef;
}

# trans('Index')
# trans('Archive')
# trans('Category Archive')
# trans('Individual')
# trans('Page')
# trans('Comment Listing')
# trans('Ping Listing')
# trans('Comment Preview')
# trans('Comment Error')
# trans('Comment Pending')
# trans('Dynamic Error')
# trans('Uploaded Image')
# trans('Search Results')
# trans('Module')
# trans('Widget')

1;
__END__

=head1 NAME

MT::Template - Movable Type template record

=head1 SYNOPSIS

    use MT::Template;
    my $tmpl = MT::Template->load($tmpl_id);
    defined(my $html = $tmpl->build($ctx))
        or die $tmpl->errstr;

    $tmpl->name('New Template name');
    $tmpl->save
        or die $tmpl->errstr;

=head1 DESCRIPTION

An I<MT::Template> object represents a template in the Movable Type system.
It contains the actual template body, along with metadata used for keeping
the template in sync with a linked file, etc. It also contains the
functionality necessary to build an output file from a generic template.

Linking a template to an external file means that any updates to the template
through the Movable Type CMS will be synced automatically to the file on
disk, and vice versa. This allows authors to edit their templates in an
external editor that supports FTP, which is preferable for users who do not
like editing in textareas.

=head1 USAGE

As a subclass of I<MT::Object>, I<MT::Template> inherits all of the
data-management and -storage methods from that class; thus you should look
at the I<MT::Object> documentation for details about creating a new object,
loading an existing object, saving an object, etc.

The following methods are unique to the I<MT::Template> interface:

=head2 $tmpl->build($ctx [, \%cond ])

Given a context I<$ctx> (an I<MT::Template::Context> object) and an optional
set of conditions \%cond, builds a template into its output form. The
template is first parsed into a list of tokens, then is interpreted/executed
to generate the final output.

If specified, I<\%cond> should be a reference to a hash with MT tag names
(without the leading C<MT>) as the keys, and boolean flags as the values--the
flags specify whether the template interpreter should include any
conditional containers found in the template body.

Returns the output as a scalar string, C<undef> on error. Because the empty
string C<''> and the value C<0> are both valid return values for this method,
you should check specifically for C<undef>:

    defined(my $html = $tmpl->build($ctx))
        or die $tmpl->errstr;

=head2 $tmpl->published_url

Only applicable if the template is an Index Template, this method returns
the url for the page which is the result of building the index template.
If the template is not of type index, or if the index template has not built
yet (if the template is static), or if the index template does not have
corresponding FileInfo record (if the template is dynamic), this method
returns undef.

=head2 $tmpl->blog

Returns the I<MT::Blog> object associated with the template.

=head2 $tmpl->save

Saves the template and if linked to a physical file, updates the file.

=head2 $tmpl->remove

Removes the template object and any related objects in I<MT::TemplateMap>
and I<MT::FileInfo>.

=head2 $tmpl->set_values

Updates the values of the C<$tmpl> object. When this is called through
the I<MT::ObjectDriver> classes (upon loading a template object), and if
the template is linked to a file, it will also load the contents of that
file, setting the 'text' property.

=head2 $tmpl->content_type

Returns MT::ContentType related to this template.

=head1 DATA ACCESS METHODS

The I<MT::Template> object holds the following pieces of data. These fields
can be accessed and set using the standard data access methods described in
the I<MT::Object> documentation.

=over 4

=item * id

The numeric ID of the template.

=item * blog_id

The numeric ID of the blog to which this template belongs.

=item * name

The name of the template. This should be unique on a per-blog basis, because
templates--particularly template modules, which are stored as regular
templates--are included by name, using C<E<lt>MTIncludeE<gt>>.

=item * type

The type of the template. This can be any of the following values: C<index>,
an Index Template; C<archive>, an Archive Template; C<category>, also an
Archive Template; C<individual>, also an Archive Template; C<comments>, a
Comment Listing Template; C<comment_preview>, a Comment Preview Template;
C<comment_error>, a Comment Error Template; C<popup_image>, an Uploaded Image
Popup Template; or C<custom>, a Template Module.

=item * outfile

The name/path of the output file of this template. This is only applicable
if the template is an Index Template.

=item * text

The body of the template, containing the markup and Movable Type template
tags.

If the template is linked to an external file, the body of the template is
automatically synced between this data field and the external file.

=item * rebuild_me

A boolean flag specifying whether or not the index template will be rebuilt
automatically when rebuilding indexes, rebuilding all, or saving a new entry.

=item * linked_file

The name/path of the file to which this template is linked in the filesystem,
if it is linked.

=item * linked_file_mtime

The last modified time of the linked file. This, along with
I<linked_file_size>, is used to determine whether a file has been updated on
disk, and needs to be re-synced.

=item * linked_file_size

The size of the linked file, in bytes. This, along with I<linked_file_mtime>,
is used to determine whether a file has been updated on disk, and needs to
be re-synced.

=item * content_type_id

MT::ContentType ID related to this template.
This value is set only when this template is for Content Type.
(this template type is 'ct' or 'ct_archive')

=back

=head1 DATA LOOKUP

In addition to numeric ID lookup, you can look up or sort records by any
combination of the following fields. See the I<load> documentation in
I<MT::Object> for more information.

=over 4

=item * blog_id

=item * name

=item * type

=back

=head1 NOTES

=over 4

=item *

When you remove a template using I<MT::Template::remove>, in addition to
removing the template record, all of the I<MT::TemplateMap> objects
associated with this template will be removed.

=item *

If a template is linked to an external file, I<MT::Template::save> will sync
the template body to disk, and I<MT::Template::text> (the data access method
to retrieve the body of the template) will sync the template body from disk.

=back

=head1 AUTHOR & COPYRIGHTS

Please see the I<MT> manpage for author, copyright, and license information.

=cut
