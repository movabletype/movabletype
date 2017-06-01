#!/usr/bin/perl
# $Id: 00-compile.t 2573 2008-06-13 18:54:41Z bchoate $

use strict;
use warnings;

use lib 't/lib', 'lib', 'extlib';
use FindBin;
use File::Spec;
use MT::Test;

use Test::More;

use_ok('ContentType::App::CMS');
use_ok('ContentType::Feed');
use_ok('ContentType::ListProperties');
use_ok('ContentType::Permission');
use_ok('ContentType::Tags');
use_ok('MT::CategoryList');
use_ok('MT::CMS::CategoryList');
use_ok('MT::CMS::ContentData');
use_ok('MT::ContentData');
use_ok('MT::ContentField');
use_ok('MT::ContentFieldIndex');
use_ok('MT::ContentFieldType::Asset');
use_ok('MT::ContentFieldType::Category');
use_ok('MT::ContentFieldType::Checkbox');
use_ok('MT::ContentFieldType::Common');
use_ok('MT::ContentFieldType::ContentType');
use_ok('MT::ContentFieldType::Date');
use_ok('MT::ContentFieldType::DateTime');
use_ok('MT::ContentFieldType::Float');
use_ok('MT::ContentFieldType::Integer');
use_ok('MT::ContentFieldType::List');
use_ok('MT::ContentFieldType::Number');
use_ok('MT::ContentFieldType::Radio');
use_ok('MT::ContentFieldType::SelectBox');
use_ok('MT::ContentFieldType::SingleLineText');
use_ok('MT::ContentFieldType::Table');
use_ok('MT::ContentFieldType::Tag');
use_ok('MT::ContentFieldType::Time');
use_ok('MT::ContentFieldType::URL');
use_ok('MT::ContentType');
use_ok('MT::ContentType::UniqueID');
use_ok('MT::ObjectCategory');

test_all_modules_are_checked();

done_testing();

# compares the list of modules that this test checks with
# the actual modules that are on the file system
sub test_all_modules_are_checked {
    my $in_test  = _read_compile_test();
    my $libpath  = File::Spec->catfile( $FindBin::Bin, "..", 'lib' );
    my @in_files = _collect_modules($libpath);

    my @not_in_test;
    foreach my $name (@in_files) {
        if ( not exists $in_test->{$name} ) {
            push @not_in_test, $name;
            next;
        }
        delete $in_test->{$name};
    }
    my $res = '';
    if (@not_in_test) {
        $res .= "Modules not tested: " . join( ", ", @not_in_test );
    }
    if ( keys %$in_test ) {
        $res .= " " if $res;
        $res .= "Modules not on HD: " . join( ", ", keys %$in_test );
    }
    if ($res) {
        ok( 0, $res );
    }
    else {
        ok( 1, "All modules are checked, " . scalar(@in_files) . " modules" );
    }
}

sub _collect_modules {
    my ($path) = @_;
    my @files = _internal_collect_modules( $path, "" );
    my @files2 = map { s/^:://; s/\.pm$//; $_ } grep {m/\.pm$/} @files;
    return @files2;
}

sub _internal_collect_modules {
    my ( $path, $prex ) = @_;
    my @files;
    opendir my $dh, $path or die "can not open dir $path";
    while ( my $filename = readdir $dh ) {
        next if $filename =~ /^\./;
        if ( -d File::Spec->catfile( $path, $filename ) ) {
            push @files,
                _internal_collect_modules(
                File::Spec->catfile( $path, $filename ),
                $prex . "::" . $filename );
            next;
        }
        push @files, $prex . "::" . $filename;
    }
    closedir $dh;
    return @files;
}

sub _read_compile_test {
    my %modules;
    open my $fh, "<" . File::Spec->catfile( $FindBin::Bin, "00-compile.t" )
        or die "can not open 00-compile.t file";
    while ( my $line = <$fh> ) {
        chomp $line;
        next unless $line =~ /use_ok\('([\w:]+)'\)/;
        my $module = $1;
        $module =~ s/\s+//g;
        warn "duplicate inside 00-compile.t: $module\n"
            if exists $modules{$module};
        $modules{$module} = 1;
    }
    close $fh;
    return \%modules;
}
