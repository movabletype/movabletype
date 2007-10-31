# WXRImporter plugin for Movable Type
# Author: Six Apart (http://www.sixapart.com)
# Released under the Artistic License
#
# $Id$

package WXRImporter::Import;
use strict;

use base qw(MT::ErrorHandler);

sub import {
    my $class = shift;
    my %param = @_;
    my $iter = $param{Iter};
    my $blog = $param{Blog} or return $class->error(MT->translate("No Blog"));
    my $cb = $param{Callback} || sub { };
    my $encoding = $param{Encoding};

    my($root_path, $root_url, $relative_path);
    if (my $p = delete $param{'mt_site_path'}) {
        $root_path = $blog->site_path;
        $root_url = $blog->site_url;
    } else {
        $root_path = $blog->archive_path;
        $root_url = $blog->archive_url;
    }

    if ($root_path && $root_url) {
        $relative_path = delete $param{'mt_extra_path'};
        my $path = $root_path;
        if ($relative_path) {
            if ($relative_path =~ m!\.\.|\0|\|!) {
                return $class->error(MT->translate(
                    "Invalid extra path '[_1]'", $relative_path));
            }
            $path = File::Spec->catdir($path, $relative_path);
        }

        ## $path should be local path to file now (we don't create/upload files nor mkpath)

        my $url = $path;
        $url =~ s!\Q$root_path\E!$root_url!;
        $url =~ s!\\!/!g;

        $param{'mt_path'} = $path;
        $param{'mt_url'} = $url;
    }

    if (exists $param{ImportAs}) {
    } elsif (exists $param{ParentAuthor}) {
        require MT::Auth;
            return $class->error(MT->translate(
                "You need to provide a password if you are going to\n" .
                "create new users for each user listed in your blog.\n"))
                    if MT::Auth->password_exists && !(exists $param{NewAuthorPassword});
    } else {
        return $class->error(MT->translate(
            "Need either ImportAs or ParentAuthor"));
    }
    $cb->("\n");
    my $import_result = eval {
        while (my $stream = $iter->()) {
            my $result = eval {
                $class->start_import($stream, %param);
            };
            $cb->($@) unless $result;
        }
        $class->errstr ? undef : 1;
    };
    $import_result;
}

sub start_import {
    my $self = shift;
    my ($stream, %param) = @_;

    require XML::SAX;
    require WXRImporter::WXRHandler;
    my $handler = WXRImporter::WXRHandler->new(
        callback => $param{Callback},
        blog => $param{Blog},
        def_cat_id => $param{DefaultCategoryID},
        convert_breaks => $param{ConvertBreaks},
        (exists $param{ImportAs}) ?
            ( author => $param{ImportAs} ) :
            ( parent => $param{ParentAuthor} ),
        pass => $param{NewAuthorPassword},
        wp_path => $param{wp_path},
        mt_path => $param{mt_path},
        mt_url => $param{mt_url},
    );

    require MT::Util;
    my $parser = MT::Util::sax_parser();
    $param{Callback}->(ref($parser) . "\n") if MT::ConfigMgr->instance->DebugMode;
    $parser->{Handler} = $handler;
    my $e;
    eval { $parser->parse_file($stream); };
    $e = $@ if $@;
    if ($e) {
        $param{Callback}->($e);
        return $self->error($e);
    }
    1;
}

sub get_param {
    my $class = shift;
    my ($blog_id) = @_;

    my $blog = MT::Blog->load($blog_id) or return $class->error(MT->translate('No Blog'));

    my $param = { blog_id => $blog_id };
    my $label_path;
    if ($blog->column('archive_path')) {
        $param->{enable_archive_paths} = 1;
        $label_path = MT->translate('Archive Root');
    } else {
        $label_path = MT->translate('Site Root');
    }
    $param->{missing_paths} =
           ((defined $blog->site_path || defined $blog->archive_path) 
         && (-d $blog->site_path || -d $blog->archive_path)) ? 0 : 1;
    $param;
}

1;

__END__
