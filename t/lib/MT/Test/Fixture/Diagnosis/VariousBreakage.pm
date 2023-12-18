package MT::Test::Fixture::Diagnosis::VariousBreakage;
use strict;
use warnings;
use base 'MT::Test::Fixture';

sub prepare_fixture {
    MT::Test->init_db;

    for my $site_id (1 .. 3) {
        my $site = MT::Test::Permission->make_website(
            name => 'my website' . $site_id,
        );

        # Make broken child site
        for my $child_site_id (1 .. 3) {
            my $child = MT::Test::Permission->make_blog(
            parent_id => $site->id,
                name      => 'child site' . $child_site_id,
            );
            $child->parent_id(undef);
            $child->save;
        }

        # entry including child sites
        for my $child_site_id (4 .. 6) {
            my $child = MT::Test::Permission->make_blog(
                parent_id => $site->id,
                name      => 'child site' . $child_site_id,
            );

            # Make entries with revision duplication
            for my $entry_id (1 .. 10) {
                my $e = MT::Test::Permission->make_entry(blog_id => $child->id, name => 'hello world part '. $entry_id);
                entry_revision_duplication($e);
            }
        }
    }

    # entry including sites
    for my $site_id (4 .. 6) {
        my $site = MT::Test::Permission->make_website(
            name => 'my website' . $site_id,
        );

        # Make entries with revision duplication
        for my $entry_id (1 .. 10) {
            my $e = MT::Test::Permission->make_entry(blog_id => $site->id, name => 'hello world part '. $entry_id);
            entry_revision_duplication($e);
        }
    }

    # Make plugindata with breakage
    for my $plugin_name ('NotInstalled', 'FormattedText') {
        for (1 .. int(rand(100))) {
            my $pd = MT::PluginData->new('plugin' => $plugin_name, 'key' => 'configuration:blog:10');
            $pd->save;
        }
        for (1 .. int(rand(100))) {
            my $pd = MT::PluginData->new('plugin' => $plugin_name, 'key' => 'configuration:blog:3');
            $pd->save;
        }
        for (1 .. int(rand(100))) {
            my $pd = MT::PluginData->new('plugin' => $plugin_name, 'key' => 'configuration:blog:4');
            $pd->save;
        }
        for (1 .. int(rand(100))) {
            my $pd = MT::PluginData->new('plugin' => $plugin_name, 'key' => 'configuration');
            $pd->save;
        }
    }

    my $pd = MT::PluginData->new('plugin' => 'NotInstalled', 'key' => 'configuration:blog:200');
    $pd->data(\'1');    # broken data emulation
    $pd->save;
}

sub entry_revision_duplication {
    my $obj = shift;

    for (1 .. int(rand(100))) {
        my $rev_obj = $obj->clone();
        $rev_obj->{changed_revisioned_cols} = ['status'];
        $rev_obj->save_revision();
    }
}

1;
