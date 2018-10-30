package MT::Test::Fixture;

use strict;
use warnings;
use Carp;
use MT::Test::Permission;

sub prepare {
    my ( $class, $spec ) = @_;

    my $test_root = $ENV{MT_TEST_ROOT} || "$ENV{MT_HOME}/t";

    my %objs;
    $class->prepare_author( $spec, \%objs );
    $class->prepare_website( $spec, \%objs );
    $class->prepare_blog( $spec, \%objs );
    $class->prepare_category( $spec, \%objs );
    $class->prepare_entry( $spec, \%objs );
    $class->prepare_folder( $spec, \%objs );
    $class->prepare_page( $spec, \%objs );
    $class->prepare_category_set( $spec, \%objs );
    $class->prepare_content_type( $spec, \%objs );
    $class->prepare_content_data( $spec, \%objs );

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
    if ( @blog_names == 1 ) {
        $objs->{blog_id} = $objs->{blog}{ $blog_names[0] }->id;
    }
}

sub prepare_category {
    my ( $class, $spec, $objs ) = @_;
    return unless $spec->{category};

    if ( ref $spec->{category} eq 'ARRAY' ) {
        my $blog_id = $objs->{blog_id}
            or croak "blog_id is required: category";
        for my $item ( @{ $spec->{category} } ) {
            my %arg;
            if ( ref $item eq 'HASH' ) {
                %arg = %$item;
                if ( my $parent_name = $arg{parent} ) {
                    my $parent = $objs->{category}{$parent_name}
                        or croak "unknown parent category: $parent_name";
                    $arg{parent} = $parent->id;
                }
            }
            else {
                %arg = ( label => $item );
            }
            my $cat = MT::Test::Permission->make_category(
                blog_id => $blog_id,
                %arg,
            );
            $objs->{category}{ $cat->label } = $cat;
        }
    }
}

sub prepare_folder {
    my ( $class, $spec, $objs ) = @_;
    return unless $spec->{folder};

    if ( ref $spec->{folder} eq 'ARRAY' ) {
        my $blog_id = $objs->{blog_id}
            or croak "blog_id is required: folder";
        for my $item ( @{ $spec->{folder} } ) {
            my %arg;
            if ( ref $item eq 'HASH' ) {
                %arg = %$item;
                if ( my $parent_name = $arg{parent} ) {
                    my $parent = $objs->{folder}{$parent_name}
                        or croak "unknown parent folder: $parent_name";
                    $arg{parent} = $parent->id;
                }
            }
            else {
                %arg = ( label => $item );
            }
            my $folder = MT::Test::Permission->make_folder(
                blog_id => $blog_id,
                %arg,
            );
            $objs->{folder}{ $folder->label } = $folder;
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
                        or croak "unknown author: $author_name: entry: $arg{title}";
                    $arg{author_id} = $author->id;
                }
                my $status = $arg{status} || 'publish';
                if ( $status =~ /\w+/ ) {
                    require MT::EntryStatus;
                    $arg{status} = MT::EntryStatus::status_int($status);
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
                        or croak "unknown author: $author_name: page: $arg{title}";
                    $arg{author_id} = $author->id;
                }
                my $status = $arg{status} || 'publish';
                if ( $status =~ /\w+/ ) {
                    require MT::EntryStatus;
                    $arg{status} = MT::EntryStatus::status_int($status);
                }
            }
            else {
                %arg = ( title => $item );
            }
            my $title = $arg{title} || '(no title)';
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
        for my $name ( keys %{ $spec->{category_set} } ) {
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
        for my $name ( keys %{ $spec->{content_type} } ) {
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
                            || croak
                            "category_set is required: content_field: $set_name";
                        $cf_arg{related_cat_set_id} = $set->id;
                        %options = (
                            label        => $cf_name,
                            category_set => $set->id,
                        );
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
                        id      => $cf->id,
                        label   => 1,
                        name    => $cf->name,
                        type    => $cf_type,
                        order   => @fields + 1,
                        options => \%options,
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
        for my $name ( keys %{ $spec->{content_data} } ) {
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
                    if ( $cf_type =~ /date/ ) {
                        $data{ $cf->id } = $cf_arg;
                    }
                    elsif ( $cf_type eq 'categories' ) {
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
                }
                $arg{data} = \%data;

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

1;
