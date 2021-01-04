# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::Theme::TemplateSet;
use strict;
use warnings;
use MT;
use MT::Util qw( dirify );

sub apply {
    my ( $element, $theme, $obj_to_apply, $opts ) = @_;
    my $set = $element->{data};
    if ( !ref $set ) {
        $set = MT->registry( 'template_sets', $set );
    }
    require Clone::PP;
    $set = Clone::PP::clone($set);

    ## deep localize for labels
    $theme->__deep_localize_labels($set);
    $theme->__deep_localize_templatized_values($set);
    $set->{templates}{plugin} = $theme
        if $set->{templates} && 'HASH' eq ref $set->{templates};
    ## taken from MT::CMS::Template
    my $backup  = exists $opts->{backup} ? $opts->{backup} : 1;
    my $blog    = $obj_to_apply;
    my $blog_id = $blog->id;
    my $t       = time;
    my @ts      = MT::Util::offset_time_list( $t, $blog_id );
    my $ts      = sprintf "%04d-%02d-%02d %02d:%02d:%02d",
        $ts[5] + 1900, $ts[4] + 1, @ts[ 3, 2, 1, 0 ];

    my $tmpl_iter = MT->model('template')->load_iter(
        {   blog_id => $blog->id,
            type    => { not => 'backup' },
        }
    );

    while ( my $tmpl = $tmpl_iter->() ) {
        if ($backup) {

            # zap all template maps
            require MT::TemplateMap;
            MT::TemplateMap->remove( { template_id => $tmpl->id, } );
            $tmpl->name(
                $tmpl->name . ' (Backup from ' . $ts . ') ' . $tmpl->type );
            $tmpl->type('backup');
            $tmpl->identifier(undef);
            $tmpl->rebuild_me(0);
            $tmpl->linked_file(undef);
            $tmpl->outfile('');
            $tmpl->save;
        }
        else {
            $tmpl->remove;
        }
    }

    if ($blog_id) {

        # Create the default templates and mappings for the selected
        # set here, instead of below.
        if ( ref $set ) {
            $set->{envelope} = $theme->path;
        }

        local MT->app->{component} = $theme->id;
        $blog->create_default_templates($set)
            or return $element->error( $blog->errstr );
    }

    return 1;
}

sub info {
    my ( $element, $theme, $blog ) = @_;
    my $set = $element->{data};
    if ( !ref $set ) {
        $set = MT->registry( 'template_sets' => $set );
    }
    return unless 'HASH' eq ref $set;
    my $templates
        = $set->{templates} eq '*'
        ? MT->registry("default_templates")
        : $set->{templates};
    return unless 'HASH' eq ref $templates;
    my %counts = ( widget => 0, widgetset => 0, template => 0 );
    for my $group_key ( keys %$templates ) {
        next if 'HASH' ne ref $templates->{$group_key};
        my $group
            = $group_key eq 'widget'    ? 'widget'
            : $group_key eq 'widgetset' ? 'widgetset'
            :                             'template';
        $counts{$group} += scalar keys %{ $templates->{$group_key} };
    }
    return sub {
        MT->translate(
            'A template set containing [quant,_1,template,templates], [quant,_2,widget,widgets], and [quant,_3,widget set,widget sets].',
            $counts{template}, $counts{widget}, $counts{widgetset}, );
    };
}

sub condition {
    my ($blog) = @_;

    # Export if at least one template;
    my $tmpl = MT->model('template')
        ->load( { blog_id => $blog->id }, { limit => 1 } );
    return defined $tmpl ? 1 : 0;
}

sub export_template {
    my $app = shift;
    my ( $blog, $saved ) = @_;
    require MT::CMS::Template;
    my %checked;
    if ($saved) {
        %checked = map { $_ => 1 } @{ $saved->{template_set_export_ids} };
    }
    my @templates = MT->model('template')->load(
        {   blog_id => $blog->id,
            type    => { 'not' => 'backup' },
        }
    );

    my %types = (
        'index' => {
            label => $app->translate("Index Templates"),
            order => 100,
        },
        'archive' => {
            label => $app->translate("Archive Templates"),
            order => 200,
        },
        'ct' => {
            label => $app->translate('Content Type Templates'),
            order => 250,
        },
        'module' => {
            label => $app->translate("Template Modules"),
            order => 300,
        },
        'system' => {
            label => $app->translate("System Templates"),
            order => 400,
        },
        'email' => {
            label => $app->translate("Email Templates"),
            order => 500,
        },
        'widget' => {
            label => $app->translate("Widget Templates"),
            order => 600,
        },
        'widgetset' => {
            label => $app->translate("Widget Sets"),
            order => 700,
        },
    );
    my %tmpl_groups;
    my %id_map = map { $_->name => $_->id, } @templates;
    for my $tmpl (@templates) {
        my $type = $tmpl->type;
        my $template_type;
        if ( $type =~ m/^(individual|page|category|archive)$/ ) {
            $template_type = 'archive';
        }
        elsif ( $type eq 'ct' || $type eq 'ct_archive' ) {
            $template_type = 'ct';
        }
        elsif ( $type eq 'widget' ) {
            $template_type = 'widget';
        }
        elsif ( $type eq 'widgetset' ) {
            $template_type = 'widgetset';
        }
        elsif ( $type eq 'index' ) {
            $template_type = 'index';
        }
        elsif ( $type eq 'custom' ) {
            $template_type = 'module';
        }
        elsif ( $type eq 'email' ) {
            $template_type = 'email';
        }
        else {
            $template_type = 'system';
        }

        my $group = $tmpl_groups{$template_type} ||= {
            order               => $types{$template_type}{order},
            template_type       => $template_type,
            template_type_label => $types{$template_type}{label},
            object_loop         => [],
        };
        my $obj = {
            tmpl_label => $tmpl->name,
            tmpl_id    => $tmpl->id,
            checked    => $saved ? $checked{ $tmpl->id } : 1,
        };
        if ( $template_type =~ /index/ ) {
            $obj->{outfile} = $tmpl->outfile;
        }
        if ( $template_type eq 'archive' || $template_type eq 'ct' ) {
            $obj->{archive_types}
                = MT::CMS::Template::_populate_archive_loop( $app, $blog,
                $tmpl );
        }

        my $tokens   = $tmpl->compile;
        my @includes = (
            @{ $tokens->getElementsByTagName('include')      || [] },
            @{ $tokens->getElementsByTagName('includeblock') || [] },
        );
        for my $include (@includes) {
            my $module = $include->getAttribute('module')
                || $include->getAttribute('widget');
            my $module_id = $id_map{$module};
            push @{ $obj->{includes} ||= [] }, $module_id if $module_id;
        }
        push @{ $group->{templates} }, $obj;
    }

    for my $group ( values %tmpl_groups ) {
        $group->{templates} = [ sort { $a->{tmpl_label} cmp $b->{tmpl_label} }
                @{ $group->{templates} } ];
    }
    my %param = ( tmpl_groups =>
            [ sort { $a->{order} <=> $b->{order} } values %tmpl_groups ], );
    return $app->load_tmpl( 'include/theme_exporters/templateset.tmpl',
        \%param );
}

{
    my %known_section = (
        index      => 1,
        archive    => 1,
        ct         => 1,
        ct_archive => 1,
        module     => 1,
        widget     => 1,
        widgetset  => 1,
    );

    sub _type {
        my $tmpl = shift;
        my $type = $tmpl->type;
        return
              $known_section{$type} ? $type
            : $type eq 'custom'     ? 'module'
            : $type eq 'individual'
            ? ( $tmpl->identifier eq 'page' ? 'page' : 'individual' )
            : $type eq 'page'     ? 'page'
            : $type eq 'category' ? 'archive'
            :                       'system';
    }
}

sub export {
    my $app = shift;
    my ( $blog, $setting ) = @_;
    my @templates;
    if ($setting) {
        @templates = MT->model('template')
            ->load( { id => $setting->{template_set_export_ids} } );
    }
    else {
        @templates = MT->model('template')->load(
            {   blog_id => $blog->id,
                type    => { not => 'backup' }
            }
        );
    }
    return unless scalar @templates;

    require MT::PublishOption;
    my $data = {};
    for my $t (@templates) {
        my $type = _type($t);
        $data->{$type} ||= {};
        my $this = { label => $t->name, };
        if ( $type eq 'index' ) {
            $this->{outfile}    = $t->outfile;
            $this->{rebuild_me} = $t->rebuild_me;
            $this->{build_type} = $t->build_type
                if $t->build_type != MT::PublishOption::ONDEMAND();
        }
        elsif ( $type eq 'ct' || $type eq 'ct_archive' ) {
            $this->{content_type} = $t->content_type->name;
        }
        if (   $type eq 'archive'
            || $type eq 'individual'
            || $type eq 'page'
            || $type eq 'ct'
            || $type eq 'ct_archive' )
        {
            my @maps
                = MT->model('templatemap')->load( { template_id => $t->id } );
            $this->{mappings} = {} if scalar @maps;
            my %type_count;
            for my $map (@maps) {
                my $map_data = {
                    archive_type => $map->archive_type,
                    preferred    => $map->is_preferred,
                    (   $map->build_type != MT::PublishOption::ONDEMAND()
                        ? ( build_type => $map->build_type )
                        : ()
                    ),
                };
                if ( $type eq 'ct' || $type eq 'ct_archive' ) {
                    if ( my $dt_field = $map->dt_field ) {
                        $map_data->{datetime_field} = $dt_field->name;
                    }
                    if ( my $cat_field = $map->cat_field ) {
                        $map_data->{category_field} = $cat_field->name;
                    }
                }
                $map_data->{file_template} = $map->file_template
                    if $map->file_template;
                my $type_count = $type_count{ $map->archive_type }++;
                my $map_id     = dirify( $map->archive_type );
                $map_id .= "_$type_count" if $type_count > 0;
                $this->{mappings}->{$map_id} = $map_data;
            }
        }
        if ( $type eq 'widgetset' ) {
            ## FIXME: this regex.
            my @widgets = $t->text =~ /<mt:include widget="([^\"]+)">/g;
            $this->{widgets} = \@widgets;
            $this->{order}   = 1000;
        }
        $data->{$type}->{ $t->identifier || 'template_' . $t->id } = $this;
    }
    return {
        label     => 'exported_template set',
        base_path => 'templates',
        templates => $data,
        objs      => \@templates,

    };
}

sub finalize {
    my $app = shift;
    my ( $blog, $theme_hash, $tmpdir, $setting ) = @_;
    my $ts_hash = $theme_hash->{elements}{template_set}
        or return 1;
    my $templates = $ts_hash->{data}{objs};
    delete $ts_hash->{data}{objs};

    require MT::FileMgr;
    require File::Spec;
    my $fmgr = MT::FileMgr->new('Local');
    my $outdir = File::Spec->catdir( $tmpdir, 'templates' );
    $fmgr->mkpath($outdir)
        or return $app->error(
        $app->translate(
            'Failed to make templates directory: [_1]',
            $fmgr->errstr,
        )
        );

    for my $t (@$templates) {
        my $tmpl_id = $t->identifier || 'template_' . $t->id;
        my $path = File::Spec->catfile( $outdir, $tmpl_id . '.mtml' );
        defined $fmgr->put_data( $t->text, $path )
            or return $app->error(
            $app->translate(
                'Failed to publish template file: [_1]',
                $fmgr->errstr,
            )
            );
    }
    return 1;
}

1;
