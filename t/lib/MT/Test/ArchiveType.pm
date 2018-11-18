package MT::Test::ArchiveType;

use strict;
use warnings;
use Test::More;
use Encode;
use MT::Test;
use MT::Test::Fixture::ArchiveType;

BEGIN {
    eval qq{ use Test::Base -Base; 1 }
        or plan skip_all => 'Test::Base is not installed';
    eval qq{ use IPC::Run3 'run3'; 1 }
        or plan skip_all => 'IPC::Run3 is not installed';
}

# Beware Spiffy magic ($self is provided automatically)

sub template_maps {
    MT::Test::Fixture::ArchiveType->template_maps(@_);
}

# Default var fitler does nothing but shuts up errors.
# You may need to add your own var filter in a .t file.
sub Test::Base::Filter::var {
    my $self = shift;
    my $data = shift;
    $data;
}

sub MT::Test::ArchiveType::filter_spec {
    my %filters = (
        stash         => [qw/ chomp eval /],
        template      => [qw/ var chomp /],
        expected      => [qw/ var chomp /],
        expected_todo => [qw/ var chomp /],
    );
    for my $archive_type ( MT->publisher->archive_types ) {
        ( my $name = $archive_type ) =~ tr/A-Z-/a-z_/;
        $filters{"expected_$name"}                = [qw/ var chomp /];
        $filters{"expected_todo_$name"}           = [qw/ var chomp /];
        $filters{"expected_php_todo_$name"}       = [qw/ var chomp /];
        $filters{"expected_todo_error_$name"}     = [qw/ var chomp /];
        $filters{"expected_error_$name"}          = [qw/ var chomp /];
        $filters{"expected_php_error_$name"}      = [qw/ var chomp /];
        $filters{"expected_php_todo_error_$name"} = [qw/ var chomp /];
    }
    %filters;
}

my $vars = {};

sub vars {
    $vars = shift if @_;
    $vars;
}

sub run_tests {
    my @maps = @_;

    MT->instance;

    unless (@maps) {
        @maps = MT::Test::Fixture::ArchiveType->template_maps;
    }

    my $objs    = MT::Test::Fixture::ArchiveType->load_objs;
    my $blog_id = $objs->{blog_id};

    for my $map ( sort { $a->archive_type cmp $b->archive_type } @maps ) {
    SKIP: {
            my $archive_type = $map->archive_type;

            $vars->{archive_type} = $archive_type;

            my $blog = MT::Blog->load($blog_id);
            $blog->archive_type_preferred($archive_type);
            $blog->save;

            $self->_run_perl_test( $blog_id, $map, $objs );

            if ( !defined $ENV{MT_TEST_ARCHIVETYPE_PHP}
                or $ENV{MT_TEST_ARCHIVETYPE_PHP} )
            {
                if ( !has_php() ) {
                    skip "Can't find executable file: php", 1 * blocks;
                }

                $self->_run_php_test( $blog_id, $map, $objs );
            }
        }
    }
}

sub _run_perl_test {
    my ( $blog_id, $map, $objs ) = @_;

    run {
        my $block = shift;
    SKIP: {
            skip $block->skip, 1 if $block->skip;

            MT::Request->instance->reset;
            MT::ObjectDriver::Driver::Cache::RAM->clear_cache;

            my $archive_type = $map->archive_type;
            my $archiver     = MT->publisher->archiver($archive_type);

            ( my $method_name = $archive_type ) =~ tr|A-Z-|a-z_|;

            my $tmpl = MT::Template->load( $map->template_id );
            $tmpl->text( $self->_filter_vars( $block->template ) );

            my $tmpl_name = $tmpl->name;
            my $ctx       = $tmpl->context;

            $ctx->{archive_type} = $ctx->{current_archive_type}
                = $archive_type;

            my $test_info = " [[$tmpl_name]]";

            my $blog = MT::Blog->load($blog_id);
            $ctx->stash( blog          => $blog );
            $ctx->stash( blog_id       => $blog->id );
            $ctx->stash( local_blog_id => $blog->id );
            $ctx->stash( builder       => MT::Builder->new );

            my ( $stash, $skip )
                = $self->_set_stash( $block, $map, $tmpl, $archiver, $objs );
            if ($skip) { skip $block->name . "$skip $test_info", 1 }

            $ctx->stash( template_map => $map );

            if ($stash) {
                if ( $stash->{timestamp} ) {
                    my ( $start, $end ) = @{ delete $stash->{timestamp} };
                    $ctx->{current_timestamp}     = $start;
                    $ctx->{current_timestamp_end} = $end;
                }

                for my $key ( keys %$stash ) {
                    $ctx->stash( $key => $stash->{$key} );
                }
            }

            require MT::Promise;
            if ( $archiver->group_based ) {
                if ( $archiver->contenttype_group_based ) {
                    my $contents
                        = sub { $archiver->archive_group_contents($ctx) };
                    $ctx->stash( 'contents', MT::Promise::delay($contents) );
                }
                else {
                    my $entries
                        = sub { $archiver->archive_group_entries($ctx) };
                    $ctx->stash( 'entries', MT::Promise::delay($entries) );
                }
            }

            if ( my $tmpl_param = $archiver->template_params ) {
                $tmpl->param($tmpl_param);
            }

            my $result = eval { $tmpl->build($ctx) };
            diag $@ if $@;

            if ( my $error = $ctx->errstr ) {
                my $expected_error_method = "expected";
                my @extra_error_methods   = (
                    "expected_todo_error_$method_name",
                    "expected_error_$method_name",
                    "expected_error"
                );
                for my $method (@extra_error_methods) {
                    if ( exists $block->{$method} ) {
                        $expected_error_method = $method;
                        last;
                    }
                }
                $error =~ s/^(\r\n|\r|\n|\s)+|(\r\n|\r|\n|\s)+\z//g;
                local $TODO = "may fail"
                    if $expected_error_method =~ /^expected_todo_/;
                is( $error,
                    $self->_filter_vars( $block->$expected_error_method ),
                    $block->name . $test_info . ' (error)'
                );
            }
            else {
                my $expected_method = 'expected';
                my @extra_methods   = (
                    "expected_todo_$method_name",
                    "expected_$method_name", "expected_todo"
                );
                for my $method (@extra_methods) {
                    if ( exists $block->{$method} ) {
                        $expected_method = $method;
                        last;
                    }
                }

                $result =~ s/^(\r\n|\r|\n|\s)+|(\r\n|\r|\n|\s)+\z//g
                    if defined $result;

                local $TODO = "may fail"
                    if $expected_method =~ /^expected_todo/;

                is( $result,
                    $self->_filter_vars( $block->$expected_method ),
                    $block->name . $test_info
                );
            }
        }
    }
}

sub _run_php_test {
    my ( $blog_id, $map, $objs ) = @_;

    run {
        my $block = shift;
    SKIP: {
            skip $block->skip, 1 if $block->skip;
            skip 'skip php test', 1 if $block->skip_php;

            MT::Request->instance->reset;
            MT::ObjectDriver::Driver::Cache::RAM->clear_cache;

            my $archive_type = $map->archive_type;
            my $archiver     = MT->publisher->archiver($archive_type);

            ( my $method_name = $archive_type ) =~ tr|A-Z-|a-z_|;

            my $tmpl = MT::Template->load( $map->template_id );

            my $tmpl_name = $tmpl->name;
            my $test_info = " [[$tmpl_name dynamic]]";

            my ( $stash, $skip )
                = $self->_set_stash( $block, $map, $tmpl, $archiver, $objs,
                'dynamic' );
            if ($skip) { skip $block->name . "$skip $test_info", 1 }

            MT->publisher->rebuild(
                BlogID      => $blog_id,
                ArchiveType => $archive_type,
                TemplateMap => $map,
            );

            my %finfo_arg = (
                blog_id        => $blog_id,
                templatemap_id => $map->id,
            );
            if ( $stash->{category} ) {
                $finfo_arg{category_id} = $stash->{category}->id;
            }

            my @finfo = MT::FileInfo->load( \%finfo_arg );

            my $finfo_id;
            if ( my $finfo = $finfo[0] ) {
                $finfo_id = $finfo->id;
            }

            my $template = $self->_filter_vars( $block->template );
            $template =~ s/<\$(mt.+?)\$>/<$1>/gi;

            my $text = $block->text || '';

            my $test_script = <<PHP;
<?php
\$MT_HOME   = '@{[ $ENV{MT_HOME} ? $ENV{MT_HOME} : '.' ]}';
\$MT_CONFIG = '@{[ MT->instance->find_config ]}';
\$blog_id   = '$blog_id';
\$tmpl = <<<__TMPL__
$template
__TMPL__
;
\$text = <<<__TMPL__
$text
__TMPL__
;
PHP
            $test_script .= <<'PHP';
include_once($MT_HOME . '/php/mt.php');
include_once($MT_HOME . '/php/lib/MTUtil.php');

$mt = MT::get_instance($blog_id, $MT_CONFIG);
$mt->init_plugins();

$db = $mt->db();
$ctx =& $mt->context();
$vars =& $ctx->__stash['vars'];

$ctx->stash('blog_id', $blog_id);
$ctx->stash('local_blog_id', $blog_id);
$blog = $db->fetch_blog($blog_id);
$ctx->stash('blog', $blog);

$page_layout = $blog->blog_page_layout;
$vars['page_layout'] = $page_layout;
PHP

            $test_script .= <<"PHP";
\$at = '$archive_type';
require_once("archive_lib.php");
\$archiver = ArchiverFactory::get_archiver(\$at);
\$archiver->template_params(\$ctx);
PHP

            if ($finfo_id) {
                $test_script .= <<"PHP";
require_once('class.mt_fileinfo.php');
\$fileinfo = new FileInfo;
\$fileinfo->Load($finfo_id);
\$ctx->stash('_fileinfo', \$fileinfo);
PHP
            }

            $test_script .= <<"PHP";
\$ctx->stash('current_archive_type', '$archive_type');
PHP

            if ( my $ct = $stash->{content_type} ) {
                my $ct_id = $ct->id;
                $test_script .= <<"PHP";
require_once('class.mt_content_type.php');
\$ct = new ContentType;
\$ct->Load($ct_id);
\$ctx->stash('content_type', \$ct);
PHP
            }

            if ( my $timestamp = $stash->{timestamp} ) {
                my ( $start, $end ) = @{ $stash->{timestamp} };
                $test_script .= <<"PHP";
\$ctx->stash('current_timestamp', '$start');
\$ctx->stash('current_timestamp_end', '$end');
PHP
            }

            if ( my $category = $stash->{category} ) {
                my $category_id = $category->id;
                $test_script .= <<"PHP";
require_once('class.mt_category.php');
\$cat = new Category;
\$cat->Load($category_id);
\$ctx->stash('category', \$cat);
\$ctx->stash('archive_category', \$cat);
PHP
            }

            if ( my $author = $stash->{author} ) {
                my $author_id = $author->id;
                $test_script .= <<"PHP";
require_once('class.mt_author.php');
\$author = new Author;
\$author->Load($author_id);
\$ctx->stash('author', \$author);
\$ctx->stash('archive_author', \$author);
PHP
            }

            if ( my $entry = $stash->{entry} ) {
                my $entry_id = $entry->id;
                $test_script .= <<"PHP";
require_once('class.mt_entry.php');
\$entry = new Entry;
\$entry->Load($entry_id);
\$ctx->stash('entry', \$entry);
PHP
            }

            if ( my $cd = $stash->{content} ) {
                my $cd_id = $cd->id;
                $test_script .= <<"PHP";
require_once('class.mt_content_data.php');
\$cd = new ContentData;
\$cd->Load($cd_id);
\$ctx->stash('content', \$cd);
PHP
            }

            $test_script .= <<'PHP';

set_error_handler(function($error_no, $error_msg, $error_file, $error_line, $error_vars) {
    print($error_msg."\n");
}, E_USER_ERROR );

if ($ctx->_compile_source('evaluated template', $tmpl, $_var_compiled)) {
    $ctx->_eval('?>' . $_var_compiled);
} else {
    print('Error compiling template module.');
}

?>
PHP

            run3 [ 'php', '-q' ], \$test_script, \my $result, undef,
                { binmode_stdin => 1 }
                or die $?;

            my @extra_methods = (
                "expected_php_todo_error_$method_name",
                "expected_php_error_$method_name",
                "expected_php_todo_$method_name",
                "expected_todo_$method_name",
                "expected_$method_name",
                "expected_todo",
            );
            my $expected_method = "expected";
            for my $method (@extra_methods) {
                if ( exists $block->{$method} ) {
                    $expected_method = $method;
                    last;
                }
            }
            $result =~ s/^(\r\n|\r|\n|\s)+|(\r\n|\r|\n|\s)+\z//g;
            $result = Encode::decode_utf8($result);

            my $expected = $block->$expected_method;
            $expected = '' unless defined $expected;
            $expected =~ s/\\r/\\n/g;
            $expected =~ s/\r/\n/g;

            my $name = $block->name;

            local $TODO = "may fail"
                if $expected_method =~ /^expected_(?:php_)?todo/
                or $ENV{MARK_ALL_PHP_TESTS_TODO};
            is( $result, $self->_filter_vars($expected), "$name $test_info" );
        }
    }
}

sub _filter_vars {
    my $str = shift;
    return $str unless defined $str;
    $str =~ s/\[% $_ %\]/$vars->{$_}/g for keys %$vars;
    chomp $str;
    $str;
}

sub _set_stash {
    my ( $block, $map, $tmpl, $archiver, $objs, $dynamic ) = @_;

    my $fixture_spec = MT::Test::Fixture::ArchiveType->fixture_spec;

    my %stash;
    my $names = $block->stash || {};    # or return;

    my $cd_name = $names->{content_data} || $names->{cd};

    my $cd;
    if ( $archiver->contenttype_based or $archiver->contenttype_group_based )
    {
        return ( undef, " requires content_data" ) unless $cd_name;

        my $cd_spec = $fixture_spec->{content_data}{$cd_name}
            or croak "unknown content_data: $cd_name";
        $cd = $objs->{content_data}{$cd_name};
        my $ct_name = $cd_spec->{content_type};
        my $ct      = $objs->{content_type}{$ct_name}{content_type};

        return ( undef, " this mapping is not for $ct_name" )
            unless $ct->id == $tmpl->content_type_id;

        $stash{content} = $cd if $archiver->contenttype_based;
        $stash{content_type} = $ct;

        $self->_update_map( $block, $map, $archiver, $objs, $ct, $cd,
            $dynamic );
    }

    my $entry;
    if ( $archiver->entry_based
        || ( $archiver->date_based && !$archiver->contenttype_date_based ) )
    {
        my $key = "entry";
        $key = "page" if $archiver->name eq 'Page';

        my $entry_name = $names->{$key}
            or return ( undef, " requires $key" );

        my ($entry_spec)
            = grep { $_->{basename} eq $entry_name }
            @{ $fixture_spec->{$key} || [] };

        unless ($entry_spec) {
            croak "unknown $key: $entry_name";
        }
        $entry = $objs->{$key}{$entry_name};
        if ( $archiver->entry_based ) {
            $stash{entry} = $entry;
        }
    }

    if ( $archiver->author_based ) {
        my $author;
        if ( $archiver->contenttype_author_based ) {
            my $cd_spec = $fixture_spec->{content_data}{$cd_name};
            unless ($cd_spec) {
                croak "unknown content_data: $cd_name";
            }
            $author = $objs->{author}{ $cd_spec->{author} };
            if ( !$author ) {
                return ( undef, " requires content_data's author" );
            }
        }
        else {
            my $entry_spec;
            my $entry_name = $names->{entry};
            if ($entry_name) {
                ($entry_spec)
                    = grep { $_->{basename} eq $entry_name }
                    @{ $fixture_spec->{entry} || [] };
            }
            if ($cd_name) {
                $entry_spec ||=
                    $cd_name
                    ? ( $fixture_spec->{content_data} || {} )->{$cd_name}
                    : undef;
            }
            my $author_name
                = exists $names->{author} ? $names->{author}
                : $entry_spec             ? $entry_spec->{author}
                :                           undef;
            if ( defined $author_name ) {
                $author = $objs->{author}{$author_name};
            }
            if ( !$author ) {
                return ( undef, " requires author or content_data's author" );
            }
        }
        $stash{author} = $author;
    }

    if ( $archiver->category_based ) {
        if ( $archiver->contenttype_category_based ) {
            my $cat_name
                = $names->{category}
                || $names->{cat}
                || $names->{content_category};
            return ( undef, " requires category" ) unless $cat_name;

            my $cat_field_id = $map->cat_field_id || 0;

            my $ct = $stash{content_type};
            my @fields
                = values %{ $objs->{content_type}{ $ct->name }{content_field}
                };
            my ($field) = grep { $_->id == $cat_field_id } @fields;
            if ( !$field ) {
                return ( undef, " $cat_name is not for this category_set" );
            }

            my $set_id = $field->related_cat_set_id;
            my @sets   = values %{ $objs->{category_set} };
            my ($set) = grep { $_->{category_set}->id == $set_id } @sets;

            my $category = $set->{category}{$cat_name};
            if ( !$category ) {
                return ( undef, " $cat_name is not for this category_set" );
            }

            $stash{category}         = $category;
            $stash{archive_category} = $category;
            $stash{category_set}     = $set->{category_set};
        }
        else {
            # Support folder as well?
            my $cat_name
                = $names->{entry_category}
                || $names->{entry_cat}
                || $names->{cat};
            return ( undef, " requires entry_category" ) unless $cat_name;
            my $category = $objs->{category}{$cat_name}
                or croak "unknown entry_category: $cat_name";
            $stash{category}         = $category;
            $stash{archive_category} = $category;
        }
    }

    if ( $archiver->date_based ) {
        my ( $start, $end );

        if ( $archiver->contenttype_date_based ) {
            if ( my $dt_field_id = $map->dt_field_id ) {
                $start = $cd->data->{$dt_field_id};
            }
            else {
                $start = $cd->authored_on;
            }
        }
        elsif ($entry) {
            $start = $entry->authored_on;
        }
        if ($start) {
            ( $start, $end ) = $archiver->date_range($start);
            $stash{timestamp} = [ $start, $end ];
        }
    }

    \%stash;
}

sub _update_map {
    my ( $block, $map, $archiver, $objs, $ct, $cd, $dynamic ) = @_;

    my $stash = $block->stash or return;

    if ( my $dt_field = $stash->{dt_field} ) {
        my $cf = $objs->{content_type}{ $ct->name }{content_field}{$dt_field}
            or croak "unknown dt_field: $dt_field";
        if ( exists $cd->data->{ $cf->id } ) {
            $map->dt_field_id( $cf->id );
        }
        else {
            return ( undef, "dt_field: $dt_field is not for this content" );
        }
    }
    else {
        $map->dt_field_id(undef);
    }

    if ( my $cat_field = $stash->{cat_field} ) {
        my $cf = $objs->{content_type}{ $ct->name }{content_field}{$cat_field}
            or croak "unknown cat_field: $cat_field";
        if ( exists $cd->data->{ $cf->id } ) {
            $map->cat_field_id( $cf->id );
        }
        else {
            return ( undef, "cat_field: $cat_field is not for this content" );
        }
    }
    else {
        $map->cat_field_id(undef);
    }

    $map->build_type( $dynamic ? 3 : 1 );
    $map->save;
}

1;
