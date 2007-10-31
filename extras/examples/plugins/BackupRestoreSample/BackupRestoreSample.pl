# Copyright 2005-2007 Six Apart. This code cannot be redistributed without
# permission from www.sixapart.com.
#
# $Id$

package MT::Plugin::BackupRestoreSample;

use strict;
use base 'MT::Plugin';
use vars qw($VERSION);
$VERSION = '0.1';

use BackupRestoreSample::Object;

my $plugin;
my $ns = 'urn:sixapart.com:ns:pluginsample';
$plugin = MT::Plugin::BackupRestoreSample->new({
    name => "BackupRestoreSample",
    version => $VERSION,
    description => "<MT_TRANS phrase=\"This plugin is to test out the backup restore callback.\">",
    author_name => "Fumiaki Yoshimatsu",
    author_link => "http://www.sixapart.com/",
    #l10n_class => 'BackupRestore::L10N',
    object_classes => [
        'BackupRestoreSample::Object'
    ],
    schema_version => '0.1',
});
MT->add_plugin($plugin);
MT->add_callback('Backup', 9, $plugin, \&backup);
MT->add_callback("Restore.backup_restore_sample_object:$ns", 9, $plugin, \&restore);

sub backup {
    my ($cb, $blog_ids, $progress) = @_;
    my $xml;
    my $terms = {};
    $terms->{blog_id} = $blog_ids if defined($blog_ids) && (0 < scalar(@$blog_ids));
    my @objects = BackupRestoreSample::Object->load($terms);
    for my $object (@objects) {
        $xml .= $object->to_xml($ns);
    }
    $progress->('BackupRestoreSampleObject is backed up.', 'BackupRestoreSample::Object');
    return $xml;
}

sub restore {
    my ($cb, $data, $objects, $deferred, $progress) = @_;
    return 0 if $ns ne $data->{NamespaceURI};
    
    my $attrs = $data->{Attributes};
    my %column_data = map { $attrs->{$_}->{LocalName} => $attrs->{$_}->{Value} }
        grep { $attrs->{$_}->{Value} ne $ns } keys(%$attrs);
    my $obj = BackupRestoreSample::Object->new;
    $obj->set_values(\%column_data); 
    $progress->('BackupRestoreSampleObject is restored.', 'BackupRestoreSample::Object');
    return $obj;
}

1;
