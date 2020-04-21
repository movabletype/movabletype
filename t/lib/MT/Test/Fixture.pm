package MT::Test::Fixture;

use strict;
use warnings;
use Carp;
use MT::Test::Permission;
use MT::Serialize;

sub prepare {
    my ( $class, $spec ) = @_;

    my $test_root = $ENV{MT_TEST_ROOT} || "$ENV{MT_HOME}/t";

    my %objs;
    $class->prepare_author( $spec, \%objs );
    $class->prepare_website( $spec, \%objs );
    $class->prepare_blog( $spec, \%objs );
    $class->prepare_category( $spec, \%objs );
    $class->prepare_customfield( $spec, \%objs );
    $class->prepare_entry( $spec, \%objs );
    $class->prepare_folder( $spec, \%objs );
    $class->prepare_page( $spec, \%objs );
    $class->prepare_category_set( $spec, \%objs );
    $class->prepare_content_type( $spec, \%objs );
    $class->prepare_content_data( $spec, \%objs );
    $class->prepare_template( $spec, \%objs );

    \%objs;
}

# TODO: support more variations

sub prepare_author {
    my ( $class, $spec, $objs ) = @_;
    return unless $spec->{author};

    my @author_names;
    if ( ref $spec->{author} eq 'ARRAY' ) {
        for my $item ( @{ $spec->{author} } ) {
            my %arg = ref $item eq 'HASH' ? %$item : ( name => $item );
            $arg{nickname} ||= $arg{name};
            my $author = MT::Test::Permission->make_author(%arg);
            if ( !defined $arg{is_superuser} or $arg{is_superuser} ) {
                $author->is_superuser(1);
                $author->save;
            }
            $objs->{author}{ $author->name } = $author;
            push @author_names, $author->name;
        }
    }
    if ( @author_names == 1 ) {
        $objs->{author_id} = $objs->{author}{ $author_names[0] }->id;
    }
}

sub prepare_website {
    my ( $class, $spec, $objs ) = @_;
    return unless $spec->{website};

    my @site_names;
    if ( ref $spec->{website} eq 'ARRAY' ) {
        for my $item ( @{ $spec->{website} } ) {
            my %arg = ref $item eq 'HASH' ? %$item : ( name => $item );

            my $site = MT::Test::Permission->make_website(%arg);
            $objs->{website}{ $site->name } = $site;
            push @site_names, $site->name;
        }
    }
    if ( @site_names == 1 ) {
        $objs->{blog_id} = $objs->{website}{ $site_names[0] }->id;
    }
}

sub prepare_blog {
    my ( $class, $spec, $objs ) = @_;
    return unless $spec->{blog};

    my @blog_names;
    if ( ref $spec->{blog} eq 'ARRAY' ) {
        for my $item ( @{ $spec->{blog} } ) {
            my %arg = ref $item eq 'HASH' ? %$item : ( name => $item );

            my $blog = MT::Test::Permission->make_blog(%arg);
            $objs->{blog}{ $blog->name } = $blog;
            push @blog_names, $blog->name;
        }
    }
    if ( $objs->{blog_id} && @blog_names ) {
        delete $objs->{blog_id};
    }
    elsif ( @blog_names == 1 ) {
        $objs->{blog_id} = $objs->{blog}{ $blog_names[0] }->id;
    }
}

sub prepare_category {
    my ( $class, $spec, $objs ) = @_;
    return unless $spec->{category};

    if ( ref $spec->{category} eq 'ARRAY' ) {
        for my $item ( @{ $spec->{category} } ) {
            my %arg;
            if ( ref $item eq 'HASH' ) {
                %arg = %$item;
                if ( my $blog_name = delete $arg{blog} ) {
                    my $blog = $objs->{blog}{$blog_name}
                        or croak "unknown blog: $blog_name";
                    $arg{blog_id} = $blog->id;
                }
                if ( my $parent_name = $arg{parent} ) {
                    my $parent = $objs->{category}{$parent_name}
                        or croak "unknown parent category: $parent_name";
                    $arg{parent} = $parent->id;
                }
            }
            else {
                %arg = ( label => $item );
            }
            $arg{blog_id} ||= $objs->{blog_id}
                or croak "blog_id is required: category";
            my $cat = MT::Test::Permission->make_category(%arg);
            $objs->{category}{ $cat->label } = $cat;
        }
    }
}

sub prepare_folder {
    my ( $class, $spec, $objs ) = @_;
    return unless $spec->{folder};

    if ( ref $spec->{folder} eq 'ARRAY' ) {
        for my $item ( @{ $spec->{folder} } ) {
            my %arg;
            if ( ref $item eq 'HASH' ) {
                %arg = %$item;
                if ( my $blog_name = delete $arg{blog} ) {
                    my $blog = $objs->{blog}{$blog_name}
                        or croak "unknown blog: $blog_name";
                    $arg{blog_id} = $blog->id;
                }
                if ( my $parent_name = $arg{parent} ) {
                    my $parent = $objs->{folder}{$parent_name}
                        or croak "unknown parent folder: $parent_name";
                    $arg{parent} = $parent->id;
                }
            }
            else {
                %arg = ( label => $item );
            }
            $arg{blog_id} ||= $objs->{blog_id}
                or croak "blog_id is required: folder";
            my $folder = MT::Test::Permission->make_folder(%arg);
            $objs->{folder}{ $folder->label } = $folder;
        }
    }
}

sub prepare_customfield {
    my ( $class, $spec, $objs ) = @_;
    return unless $spec->{customfield};

    if ( ref $spec->{customfield} eq 'ARRAY' ) {
        for my $item ( @{ $spec->{customfield} } ) {
            my %arg;
            if ( ref $item eq 'HASH' ) {
                %arg = %$item;
                if ( my $blog_name = delete $arg{blog} ) {
                    my $blog = $objs->{blog}{$blog_name}
                        or croak "unknown blog: $blog_name";
                    $arg{blog_id} = $blog->id;
                }
            }
            else {
                %arg = (
                    name     => $item,
                    obj_type => 'entry',
                    type     => 'text',
                    basename => $item,
                    tag      => $item,
                );
            }
            $arg{blog_id} ||= $objs->{blog_id}
                or croak "blog_id is required: customfield";
            my $field = MT::Test::Permission->make_field(%arg);
            $objs->{customfield}{ $field->name } = $field;
        }
    }
}

sub prepare_entry {
    my ( $class, $spec, $objs ) = @_;
    return unless $spec->{entry};

    if ( ref $spec->{entry} eq 'ARRAY' ) {
        for my $item ( @{ $spec->{entry} } ) {
            my %arg;
            if ( ref $item eq 'HASH' ) {
                %arg = %$item;
                if ( my $author_name = delete $arg{author} ) {
                    my $author = $objs->{author}{$author_name}
                        or croak
                        "unknown author: $author_name: entry: $arg{title}";
                    $arg{author_id} = $author->id;
                }
                if ( my $blog_name = delete $arg{blog} ) {
                    my $blog = $objs->{blog}{$blog_name}
                        or croak "unknown blog: $blog_name";
                    $arg{blog_id} = $blog->id;
                }
                my $status = $arg{status} || 'publish';
                if ( $status =~ /\w+/ ) {
                    require MT::Entry;
                    $arg{status} = MT::Entry::status_int($status);
                }
            }
            else {
                %arg = ( title => $item );
            }
            my $title = $arg{title} || '(no title)';
            my @cat_names = @{ delete $arg{categories} || [] };

            my $blog_id = $arg{blog_id} || $objs->{blog_id}
                or croak "blog_id is required: entry: $title";
            my $author_id = $arg{author_id} || $objs->{author_id}
                or croak "author_id is required: entry: $title";

            my $entry = MT::Test::Permission->make_entry(
                blog_id   => $blog_id,
                author_id => $author_id,
                %arg,
            );
            $objs->{entry}{ $entry->basename } = $entry;

            for my $cat_name (@cat_names) {
                my $category = $objs->{category}{$cat_name}
                    or croak "unknown category: $cat_name entry: $title";
                MT::Test::Permission->make_placement(
                    blog_id     => $blog_id,
                    entry_id    => $entry->id,
                    category_id => $category->id,
                );
            }
        }
    }
}

sub prepare_page {
    my ( $class, $spec, $objs ) = @_;
    return unless $spec->{page};

    if ( ref $spec->{page} eq 'ARRAY' ) {
        for my $item ( @{ $spec->{page} } ) {
            my %arg;
            if ( ref $item eq 'HASH' ) {
                %arg = %$item;
                if ( my $author_name = delete $arg{author} ) {
                    my $author = $objs->{author}{$author_name}
                        or croak
                        "unknown author: $author_name: page: $arg{title}";
                    $arg{author_id} = $author->id;
                }
                if ( my $blog_name = delete $arg{blog} ) {
                    my $blog = $objs->{blog}{$blog_name}
                        or croak "unknown blog: $blog_name";
                    $arg{blog_id} = $blog->id;
                }
                my $status = $arg{status} || 'publish';
                if ( $status =~ /\w+/ ) {
                    require MT::Entry;
                    $arg{status} = MT::Entry::status_int($status);
                }
            }
            else {
                %arg = ( title => $item );
            }
            my $title       = $arg{title} || '(no title)';
            my $folder_name = delete $arg{folder};

            my $blog_id = $arg{blog_id} || $objs->{blog_id}
                or croak "blog_id is required: page: $title";
            my $author_id = $arg{author_id} || $objs->{author_id}
                or croak "author_id is required: page: $title";

            my $page = MT::Test::Permission->make_page(
                blog_id   => $blog_id,
                author_id => $author_id,
                %arg,
            );
            $objs->{page}{ $page->basename } = $page;

            if ($folder_name) {
                my $folder = $objs->{folder}{$folder_name}
                    or croak "unknown folder: $folder_name entry: $title";
                MT::Test::Permission->make_placement(
                    blog_id     => $blog_id,
                    entry_id    => $page->id,
                    category_id => $folder->id,
                );
            }
        }
    }
}

sub prepare_category_set {
    my ( $class, $spec, $objs ) = @_;
    return unless $spec->{category_set};

    if ( ref $spec->{category_set} eq 'HASH' ) {
        for my $name ( sort keys %{ $spec->{category_set} } ) {
            my $items = $spec->{category_set}{$name};
            if ( ref $items eq 'ARRAY' ) {
                my $blog_id = $objs->{blog_id}
                    or croak "blog_id is required: category_set: $name";
                my $set = MT::Test::Permission->make_category_set(
                    blog_id => $blog_id,
                    name    => $name,
                );
                $objs->{category_set}{$name}{category_set} = $set;

                my %categories;
                for my $item (@$items) {
                    my %arg;
                    if ( ref $item eq 'HASH' ) {
                        %arg = %$item;
                        if ( my $parent_name = $arg{parent} ) {
                            my $parent = $categories{$parent_name}
                                or croak
                                "unknown parent category: $parent_name";
                            $arg{parent} = $parent->id;
                        }
                    }
                    else {
                        %arg = ( label => $item );
                    }
                    my $cat = MT::Test::Permission->make_category(
                        blog_id         => $blog_id,
                        category_set_id => $set->id,
                        %arg,
                    );
                    $categories{ $cat->label } = $cat;
                }
                $objs->{category_set}{ $set->name }{category} = \%categories;
            }
        }
    }
}

sub prepare_content_type {
    my ( $class, $spec, $objs ) = @_;
    return unless $spec->{content_type};

    if ( ref $spec->{content_type} eq 'HASH' ) {
        for my $name ( sort keys %{ $spec->{content_type} } ) {
            my $item = $spec->{content_type}{$name};
            my @fields;
            my ( $ct, %cfs );
            if ( ref $item eq 'ARRAY' ) {
                my $blog_id = $objs->{blog_id}
                    or croak "blog_id is required: content_type: $name";
                $ct = MT::Test::Permission->make_content_type(
                    name    => $name,
                    blog_id => $blog_id,
                );

                my @field_spec = @$item;
                while ( my ( $cf_name, $item ) = splice @field_spec, 0, 2 ) {
                    my ( %cf_arg, %options );
                    if ( ref $item eq 'HASH' ) {
                        $cf_arg{type} = $item->{type};
                    }
                    else {
                        $cf_arg{type} = $item;
                    }

                    my $cf_type = $cf_arg{type};
                    if ( $cf_type =~ /date/ ) {
                        %options = ( label => $cf_name );
                    }
                    elsif ( $cf_type eq 'categories' ) {
                        my $set_name = $item->{category_set};
                        my $set
                            = $objs->{category_set}{$set_name}{category_set}
                            or croak
                            "category_set is required: content_field: $set_name";
                        $cf_arg{related_cat_set_id} = $set->id;
                        %options = (
                            label        => $cf_name,
                            category_set => $set->id,
                            %{ delete $item->{options} || {} },
                        );
                    }
                    elsif ( $cf_type eq 'content_type' ) {
                        my $source_name = $item->{source};
                        my $source
                            = $objs->{content_type}{$source_name}
                            {content_type}
                            or croak
                            "source content_type is required: content_field: $source_name";
                        %options = (
                            %{ delete $item->{options} || {} },
                            source => $source->id,
                        );
                    }
                    elsif ( $cf_type =~ /\A(?:checkboxes|radio_button|select_box)\z/ ) {
                        for my $key (qw/min max values required multiple/) {
                            next unless defined $item->{$key};
                            $options{$key} = delete $item->{$key};
                        }
                    }
                    my $cf = MT::Test::Permission->make_content_field(
                        blog_id         => $blog_id,
                        content_type_id => $ct->id,
                        name            => $cf_name,
                        description     => $cf_name,
                        %cf_arg,
                    );
                    $cfs{$cf_name} = $cf;

                    push @fields,
                        {
                        id        => $cf->id,
                        label     => 1,
                        name      => $cf->name,
                        type      => $cf_type,
                        order     => @fields + 1,
                        options   => \%options,
                        unique_id => $cf->unique_id,
                        };
                }
            }
            $ct->fields( \@fields );
            $ct->save;

            $objs->{content_type}{ $ct->name } = {
                content_type  => $ct,
                content_field => \%cfs,
            };
        }
    }
}

sub prepare_content_data {
    my ( $class, $spec, $objs ) = @_;
    return unless $spec->{content_data};

    if ( ref $spec->{content_data} eq 'HASH' ) {
        for my $name ( sort keys %{ $spec->{content_data} } ) {
            my $item = $spec->{content_data}{$name};
            if ( ref $item eq 'HASH' ) {
                my %arg     = %$item;
                my $ct_name = delete $arg{content_type};
                my $ct      = $objs->{content_type}{$ct_name}{content_type}
                    or croak "content_type is required: content_data: $name";
                $arg{content_type_id} = $ct->id;

                if ( my $author = delete $arg{author} ) {
                    $author = $objs->{author}{$author}
                        or croak "author is required: content_data: $name";
                    $arg{author_id} = $author->id;
                }
                $arg{blog_id} ||= $objs->{blog_id}
                    or croak "blog_id is required: content_data: $name";
                $arg{label} = $name;

                my %data;
                for my $cf_name ( keys %{ $arg{data} } ) {
                    my $cf
                        = $objs->{content_type}{$ct_name}{content_field}
                        {$cf_name}
                        or croak
                        "content_field is required: content_data: $cf_name";
                    my $cf_type = $cf->type;
                    my $cf_arg  = $arg{data}{$cf_name};
                    if ( $cf_type eq 'categories' ) {
                        my $set_id = $cf->related_cat_set_id;
                        my @sets   = values %{ $objs->{category_set} };
                        my ($set)
                            = grep { $_->{category_set}->id == $set_id }
                            @sets;

                        my @cat_ids;
                        for my $cat_name (@$cf_arg) {
                            my $cat = $set->{category}{$cat_name}
                                or croak
                                "category is required: content_data: $cat_name";
                            push @cat_ids, $cat->id;
                        }
                        $data{ $cf->id } = \@cat_ids;
                    }
                    elsif ( $cf_type eq 'content_type' ) {
                        my @cd_ids;
                        for my $cd_name (@$cf_arg) {
                            my $cd = $objs->{content_data}{$cd_name}
                                or croak
                                "content_data is required: content_data: $cd_name";
                            push @cd_ids, $cd->id;
                        }
                        $data{ $cf->id } = \@cd_ids;
                    }
                    else {
                        $data{ $cf->id } = $cf_arg;
                    }
                }
                $arg{data} = \%data;

                if ( $arg{convert_breaks} ) {
                    my %convert_breaks;
                    for my $cf_name ( keys %{ $arg{convert_breaks} } ) {
                        my $cf
                            = $objs->{content_type}{$ct_name}{content_field}
                            {$cf_name}
                            or croak
                            "content_field is required: content_data: $cf_name";
                        $convert_breaks{ $cf->id }
                            = $arg{convert_breaks}{$cf_name};
                    }
                    $arg{convert_breaks}
                        = MT::Serialize->serialize( \{%convert_breaks} );
                }

                my $status = $arg{status} || 'publish';
                if ( $status =~ /\w+/ ) {
                    require MT::ContentStatus;
                    $arg{status} = MT::ContentStatus::status_int($status);
                }

                my $cd = MT::Test::Permission->make_content_data(%arg);
                $objs->{content_data}{ $cd->label } = $cd;
            }
        }
    }
}

sub prepare_template {
    my ( $class, $spec, $objs ) = @_;
    return unless $spec->{template};

    if ( ref $spec->{template} eq 'ARRAY' ) {
        for my $item ( @{ $spec->{template} } ) {
            my %arg
                = ref $item eq 'HASH' ? %$item : ( archive_type => $item );
            my $archive_type = delete $arg{archive_type};
            my $archiver;
            if ($archive_type) {
                $archiver = MT->publisher->archiver($archive_type)
                    or croak "unknown archive_type: $archive_type";
                $arg{type} = _template_type($archive_type);
            }
            if ( my $blog_name = delete $arg{blog} ) {
                my $blog = $objs->{blog}{$blog_name}
                    or croak "unknown blog: $blog_name";
                $arg{blog_id} = $blog->id;
            }
            my $blog_id = $arg{blog_id} ||= $objs->{blog_id}
                or croak "blog_id is required: template: $arg{type}";

            my $ct;
            if ( my $ct_name = delete $arg{content_type} ) {
                $ct = $objs->{content_type}{$ct_name}{content_type}
                    or croak "content_type is not found: $ct_name";
                $arg{content_type_id} = $ct->id;
            }
            if ( !$arg{name} ) {
                ( my $archive_type_name = $archive_type ) =~ tr/A-Z-/a-z_/;
                $arg{name} = "tmpl_$archive_type_name";
            }

            my $mapping = delete $arg{mapping};

            ## Remove (to replace) if a template identifier is specified
            if ( $arg{identifier} ) {
                MT::Template->remove(
                    { blog_id => $blog_id, identifier => $arg{identifier} },
                    { nofetch => 1 } );
            }

            my $tmpl = MT::Test::Permission->make_template(
                blog_id => $blog_id,
                %arg,
            );

            $objs->{template}{ $tmpl->name } = $tmpl;

            next unless $archive_type && $mapping;

            my $preferred = 1;
            $mapping = [$mapping] if ref $mapping eq 'HASH';
            for my $map (@$mapping) {
                $map->{file_template} ||= _file_template($archiver);
                $map->{build_type}    ||= 1;
                $map->{is_preferred} = $preferred;
                $map->{template_id}  = $tmpl->id;
                $map->{blog_id}      = $blog_id;
                $map->{archive_type} = $archive_type;

                if ( my $cat_field_name = delete $map->{cat_field} ) {
                    my @cat_fields = grep { $_->{type} eq 'categories' }
                        @{ $ct->fields };
                    my ($cat)
                        = grep { $_->{name} eq $cat_field_name } @cat_fields;

                    $map->{cat_field_id} = $cat->{id} if $cat;
                }

                if ( my $dt_field_name = delete $map->{dt_field} ) {
                    my @dt_fields
                        = grep { $_->{type} =~ /date/ } @{ $ct->fields };
                    my ($dt)
                        = grep { $_->{name} eq $dt_field_name } @dt_fields;

                    $map->{dt_field_id} = $dt->{id} if $dt;
                }

                my $tmpl_map = MT::Test::Permission->make_templatemap(%$map);

                $objs->{templatemap}{ $tmpl_map->file_template } = $tmpl_map;

                $preferred = 0;
            }
        }
    }
}

sub _template_type {
    my $archive_type = shift;
    return 'individual' if $archive_type eq 'Individual';
    return 'page'       if $archive_type eq 'Page';
    return 'ct'         if $archive_type eq 'ContentType';
    return 'ct_archive' if $archive_type =~ /^ContentType/;
    return 'archive';    # and custom?
}

sub _file_template {
    my $archiver = shift;
    my $prefix   = $archiver->name =~ /^ContentType/ ? "ct/" : "";
    for my $archive_template ( @{ $archiver->default_archive_templates } ) {
        next unless $archive_template->{default};
        return $prefix . $archive_template->{template};
    }
}

1;
