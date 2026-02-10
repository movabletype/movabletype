#!/usr/bin/env perl

# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

use 5.014;
use strict;
use warnings;
use FindBin;
use Config;
use Menlo::CLI::Compat;
use File::Find;
use File::Copy::Recursive qw/rcopy/;
use Path::Tiny;
use JSON;
use File::Path;
use Getopt::Long qw/:config bundling pass_through/;
use IO::Prompt::Tiny 'prompt';
use Perl::PrereqScanner::NotQuiteLite;
use Pod::Usage;

pod2usage(0) unless @ARGV;

GetOptions(\my %opts, "n", "debug", "v", "f", "subdir=s");

my $workdir  = "$FindBin::Bin/../";  # MT_HOME
my $subdir   = $opts{subdir} // '';
my $root     = "$workdir/local/lib/perl5";
my $extlib   = $subdir ? "$workdir/$subdir/extlib" : "$workdir/extlib";
my $meta_dir = "$root/$Config{archname}/.meta/";

rmtree($root) if -d $root && $opts{f};
mkpath($root) unless -d $root;

local $File::Copy::Recursive::RMTrgFil = 1;

my @options = ("-L", "local");
push @options, "-n" if $opts{n};
push @options, "-v" if $opts{v};
push @options, "-f" if $opts{f};
for my $arg (@ARGV) {
    my $menlo = Menlo::CLI::Compat->new;
    $menlo->parse_options(@options, $arg);
    $menlo->run;

    my $arg_module   = $arg        =~ s/\@.+$//r;
    my $expected_dir = $arg_module =~ s|::|/|gr;

    my %copied;
    finddepth({
            wanted => sub {
                my $file = $File::Find::name;
                return unless $file =~ /install\.json$/;
                my $json = eval { decode_json(path($file)->slurp) } or return;
                return unless $json->{provides}{$arg_module};
                for my $module (keys %{ $json->{provides} }) {
                    my $done         = 0;
                    my $default_path = "$module.pm" =~ s|::|/|gr;
                MODULE_PATH:
                    for my $path ($default_path, $json->{provides}{$module}{file}) {
                        $path =~ s|^lib/||;
                        for my $arch ("", "$Config{archname}/") {
                            my $pmfile = path("$root/$arch$path");
                            if (!-f $pmfile) {
                                next;
                            }
                            my $body = $pmfile->slurp;
                            if ($body =~ /(use|require).+(?:XSLoader|DynaLoader)/) {
                                my $scanner  = Perl::PrereqScanner::NotQuiteLite->new(recommends => 1, suggests => 1);
                                my $ctx      = $scanner->scan_file($pmfile);
                                my $requires = $ctx->requires->as_string_hash;
                                if (exists $requires->{XSLoader} or exists $requires->{DynaLoader}) {
                                    # really requires XS
                                    say STDERR "SKIP: $path uses XS";
                                    $done = 1;
                                    last MODULE_PATH;
                                }
                            }
                            my $extfile = "$extlib/$path";
                            rcopy $pmfile, $extfile or warn $!;
                            say "copied $pmfile to $extfile";
                            $copied{$path} = 1;
                            $done = 1;
                            last MODULE_PATH;
                        }
                    }
                    say STDERR "$root/$default_path not found!" unless $done;
                }
            },
            no_chdir => 1,
        },
        $meta_dir
    ) if -d $meta_dir;

    my $asked;
    finddepth({
            wanted => sub {
                my $file = $File::Find::name;
                return if -d $file;
                return if $file =~ /(\.packlist|\.pod|README|\.so|\.bs|\.sample)$/;
                return if $file =~ /$Config{archname}/;
                my ($path) = $file =~ m!/($expected_dir(?:/.+|.*?\.pm)$)!;
                if (!$path) {
                    return if $file =~ /\.pm$/;
                    return if $file =~ /$meta_dir/;
                    $path = path($file)->relative($root);
                } else {
                    return if $copied{$path};
                }
                # known special cases
                my $res;
                if ($path eq 'Algorithm/DiffOld.pm') {
                    $res = 'n';
                } elsif ($path =~ m!^Image/ExifTool/.+?\.(?:pm|pl|dat)$!) {
                    $res = $arg_module eq 'Image::ExifTool' ? 'y' : 'n';
                } elsif ($path =~ m!^IPC/Run3/.+?\.pm$!) {
                    $res = $arg_module eq 'IPC::Run3' ? 'y' : 'n';
                } elsif ($path =~ m!^JSON/backportPP!) {
                    $res = $arg_module eq 'JSON' ? 'y' : 'n';
                } elsif ($path eq 'LWP/media.types') {
                    $res = $arg_module eq 'LWP::MediaTypes' ? 'y' : 'n';
                } elsif ($path =~ m!^MIME/Charset/!) {
                    $res = $arg_module eq 'MIME::Charset' ? 'y' : 'n';
                } elsif ($path eq 'MIME/types.db') {
                    $res = $arg_module eq 'MIME::Types' ? 'y' : 'n';
                } elsif ($path =~ m!^URI/_\w+\.pm$!) {
                    $res = $arg_module eq 'URI' ? 'y' : 'n';
                } elsif ($path =~ m!^XML/SAX/.+?\.(?:ini|pm|pl)$!) {
                    # Strictly speaking, ::Exception and ::Base belong to XML::SAX::Base
                    if ($path =~ /(?:Exception|Base)\.pm$/) {
                        $res = $arg_module eq 'XML::SAX::Base' ? 'y' : 'n';
                    } elsif ($path =~ /\.pl$/) {
                        $res = 'n';
                    } else {
                        $res = $arg_module eq 'XML::SAX' ? 'y' : 'n';
                    }
                } else {
                    $res = prompt("needs $file? (y/n)", "n");
                }
                if ($res =~ /^y/i) {
                    my $extfile = "$extlib/$path";
                    rcopy $file, $extfile or warn $!;
                    say "copied $file to $extfile";
                }
                $asked = 1;
            },
            no_chdir => 1,
        },
        $root
    ) if -d $root;

    rmtree($root) if $asked;
}

__END__

=head1 NAME

build/update-extlib.pl - installs/updates modules under extlib

=head1 BASIC USAGE

$ perl build/update-extlib.pl Modules::To::Update

Running this script copies manifested modules in the distribution into the extlib directory.

Sometimes you may be asked if unknown (not-manifested) files are found in the working (local) directory.

=head1 OPTIONS

=over 4

=item n

Installs modules without testing

=item v

Install modules verbosely

=item f

Installs modules even they are already installed; sometimes useful when you install dual-life modules

=item debug

Shows debug messages

=item subdir

Installs modules into extlib under the subdirectory, like plugins/Foo or addons/Bar

