package MT::Test::Util::Plugin;

use strict;
use warnings;
use File::Spec;
use File::Path     qw(mkpath);
use File::Basename qw(dirname);
use Mojo::Template;
use Data::Section::Simple qw(get_data_section);
use YAML;
use Data::Dump;

my $templates = get_data_section();

sub write {
    my ($class, %conf) = @_;
    my $plugin_root = delete $conf{plugin_root} || 'plugins';
    for my $plugin_dir (keys %conf) {
        for my $file (keys %{$conf{$plugin_dir}}) {
            my $data  = ref $conf{$plugin_dir}{$file} eq 'HASH' ? $conf{$plugin_dir}{$file} : {};
            $data->{name}    ||= $plugin_dir;
            $data->{id}      ||= lc $data->{name};
            $data->{version} ||= '0.01';
            my $abspath = File::Spec->catdir($ENV{MT_TEST_ROOT}, $plugin_root, $plugin_dir, $file);
            my $parent  = dirname($abspath);
            mkpath $parent unless -d $parent;
            my ($ext) = $file =~ /\.(\w+)/;
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
            close $fh;
        }
    }
}

1;

__DATA__

@@ yaml
% my $data = shift;
% my $yaml = delete $data->{yaml};
%== YAML::Dump($data);
% if ($yaml) {
%== $yaml
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
%== $use
% }

my $plugin = MT::Plugin->new({
% for my $key (keys %$data) {
    '<%== $key %>' => <%== ref $data->{$key} eq 'SCALAR' ? ${$data->{$key}} : Data::Dump::dump($data->{$key}) %>,
% }
});
% if ($code) {
%== $code
% }

MT->add_plugin($plugin);
1;

@@ pm
% my $data = shift;
package <%= $data->{module} %>;
use strict;
use warnings;
our $VERSION = '<%== $data->{version} %>';

<%== $data->{code} %>

1;
