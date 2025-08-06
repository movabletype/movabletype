package MT::Test::Util::Plugin;

use strict;
use warnings;
use File::Spec;
use File::Path     qw(mkpath);
use File::Basename qw(dirname);
use Mojo::Template;
use Data::Section::Simple qw(get_data_section);
use MT::Util::YAML;
use Data::Dump;  ## no critic('TooMuchCode::ProhibitUnusedImport')
use String::CamelCase qw(decamelize);

my $templates = get_data_section();

sub write {
    my ($class, %conf) = @_;
    my $plugin_root = delete $conf{plugin_root} || 'plugins';
    for my $plugin_dir (keys %conf) {
        for my $file (keys %{$conf{$plugin_dir}}) {
            my $data  = ref $conf{$plugin_dir}{$file} eq 'HASH' ? $conf{$plugin_dir}{$file} : {};
            if (!$data->{name}) {
                my $name = $plugin_dir;
                $name =~ s/\-[0-9.]+$//;
                $data->{name} = $name;
            }
            $data->{id}      ||= decamelize($data->{name});
            $data->{version} ||= '0.01';
            my $abspath = File::Spec->catdir($ENV{MT_TEST_ROOT}, $plugin_root, $plugin_dir, $file);
            my $parent  = dirname($abspath);
            mkpath $parent unless -d $parent;
            my ($ext) = $file =~ /\.(\w+)$/;
            if ($ext eq 'pm') {
                my $module = $file;
                $module =~ s!^lib/!!;
                $module =~ s!.pm$!!;
                $module =~ s!/!::!g;
                $data->{module} = $module;
            }
            my $template = Mojo::Template->new->render($templates->{$ext}, $data);
            open my $fh, '>', $abspath;
            print $fh $template;
            print STDERR "PLUGIN FILE: $abspath\n$template\n\n" if $ENV{MT_TEST_SHOW_CREATED_PLUGIN};
            close $fh;
        }
    }
}

1;

__DATA__

@@ yaml
% my $data = shift;
% my $yaml = delete $data->{yaml};
%= MT::Util::YAML::Dump($data);
% if ($yaml) {
%= $yaml
% }

@@ pl
% my $data = shift;
% my $use  = delete $data->{use};
% my $code = delete $data->{code};
use strict;
use warnings;
use MT;
use MT::Plugin;
% if ($use) {
%= $use
% }

my $plugin = MT::Plugin->new(<%= Data::Dump::dumpf($data, sub {
    my ($ctx, $vref) = @_;
    if ($ctx->is_ref && $ctx->reftype eq 'SCALAR') {
        return {dump => $$vref};
    } elsif ($ctx->is_code) {
        require B::Deparse;
        return {dump => 'sub ' . B::Deparse->new->coderef2text($vref)};
    }
    return;
}); %>);

% if ($code) {
%= $code
% }

MT->add_plugin($plugin);
1;

@@ pm
% my $data = shift;
package <%= $data->{module} %>;
use strict;
use warnings;
our $VERSION = '<%= $data->{version} %>';

<%= $data->{code} // '' %>
1;

