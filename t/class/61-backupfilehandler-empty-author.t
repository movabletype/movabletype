#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT;
use MT::Test;
use JSON;
use File::Spec;
use MT::BackupRestore;
use MT::BackupRestore::BackupFileHandler;
use MT::Author;

$test_env->prepare_fixture('db');

my $schema_version = 7.0050;

mt->instance->user(MT::Author->load(1));

subtest 'author skip does not break objects when element is empty' => sub {
    my $objects  = {};

    my $handler = MT::BackupRestore::BackupFileHandler->new(
        callback           => sub { },
        objects            => $objects,
        deferred           => {},
        errors             => [],
        schema_version     => $schema_version,
        overwrite_template => {},
    );

    my $parser = MT::Util::sax_parser();
    $handler->{is_pp}  = ref($parser) eq 'XML::SAX::PurePerl' ? 1 : 0;
    $parser->{Handler} = $handler;

    $parser->parse_string(<<'__XML__');
<?xml version='1.0'?>
<movabletype xmlns='http://www.sixapart.com/ns/movabletype'
schema_version='7.0050' backup_by='Melody(ID: 1)' backup_what='1' backup_on='2021-07-29T08:20:50'>
<website id='1' allow_comment_html='1' allow_commenter_regist='1' allow_comments_default='1' allow_pings='1' allow_pings_default='1' allow_reg_comments='1' allow_unreg_comments='0' autolink_urls='1' basename_limit='100' children_modified_on='20101231120000' class='website' convert_paras='richtext' convert_paras_comments='1' created_on='20210729082044' custom_dynamic_templates='none' date_language='en_US' days_on_index='0' email_new_comments='1' email_new_pings='1' entries_on_index='10' file_extension='html' internal_autodiscovery='0' junk_folder_expiry='14' junk_score_threshold='0' language='en_US' moderate_pings='1' moderate_unreg_comments='2' modified_on='20210729082044' name='First Website' ping_blogs='0' ping_google='0' ping_technorati='0' ping_weblogs='0' require_comment_emails='0' sanitize_spec='0' server_offset='0' site_url='/' sort_order_comments='ascend' sort_order_posts='descend' status_default='2' use_comment_confirmation='1' use_revision='1' words_in_excerpt='40' page_layout='layout-wtt' commenter_authenticators='MovableType' follow_auth_links='1' nofollow_urls='1'></website>
<author id='1' api_password='ud440mzs' auth_type='MT' basename='authorce2f3' created_by='1' created_on='20210729082044' date_format='relative' locked_out_time='0' modified_on='20210729082044' name='Melody' password='$6$wjcn79ph18xqp0zh$YpZ0X/TNJS7BmoGSKpwFfOq6/LoJKa+H1NoAjm+AYQLH/0tsoU+Ulx3Fgjbze4NazCSIkg4TSzFVf1Mu6bEaGw' preferred_language='en_US' status='1' type='1'></author>
<template id='150' blog_id='1' build_dynamic='0' build_interval='0' build_type='1' created_on='20210729082044' identifier='category_entry_listing' modified_on='20210729082044' name='Awsome Template' rebuild_me='1' type='archive' current_revision='0'><text>
content
</text></template>
</movabletype>
__XML__

    is(ref $objects->{'MT::Website#1'}, 'MT::Website', 'right class');
    is(ref $objects->{'MT::Template#150'}, 'MT::Template', 'right class');
    is(keys %$objects, 2, 'right number of keys');
};

done_testing();
