# TemplateRefresh plugin for Movable Type
# Author: Nick O'Neill and Brad Choate, Six Apart (http://www.sixapart.com)
# Released under the Artistic License
#
# $Id$

package MT::Plugin::TemplateRefresh;

use strict;
use MT;
use base qw(MT::Plugin);

my $plugin;
BEGIN {
    MT->add_plugin($plugin =
        new MT::Plugin::TemplateRefresh({
            name => "Template Backup and Refresh",
            description => q(<MT_TRANS phrase="Backup and refresh existing templates to Movable Type's default templates.">),
            version => 1.2,
            registry => {
                applications => {
                    cms => {
                        page_actions => {
                            list_templates => {
                                refresh_all_blog_templates => {
                                    label => "Refresh Blog Templates",
                                    code => sub {
                                        MT->app->param('no_backup', 1);
MT::Plugin::TemplateRefresh->instance->refresh_all_templates(@_) },
                                    condition => sub {
                                        MT->app->blog,
                                    },
                                    order => 1000,
                                    continue_prompt => MT->translate('This action will restore your blog\'s templates to factory settings without creating a backup. Click OK to continue or Cancel to abort.'),
                                },
                                refresh_global_templates => {
                                    label => "Refresh Global Templates",
                                    code => sub {
                                        MT->app->param('no_backup', 1);
                                            MT::Plugin::TemplateRefresh->instance->refresh_all_templates(@_) },
                                    condition => sub {
                                        ! MT->app->blog,
                                    },
                                    order => 1000,
                                    continue_prompt => MT->translate('This action will restore your global templates to factory settings without creating a backup. Click OK to continue or Cancel to abort.'),
                                },
                            },
                        },
                        list_actions => {
                            blog => {
                                refresh_blog_templates => {
                                    label => "Refresh Template(s)",
                                    code => sub { MT::Plugin::TemplateRefresh->instance->refresh_all_templates(@_) },
                                },
                            },
                            template => {
                                refresh_tmpl_templates => {
                                    label => "Refresh Template(s)",
                                    code => sub { MT::Plugin::TemplateRefresh->instance->refresh_individual_templates(@_) },
                                    permissions => 'can_edit_templates',
                                },
                            },
                        },
                    },
                },
            },
        }),
    );
}

sub instance { $plugin }

sub default_dictionary {

    # sha1 signatures for all default templates
    # we use these to determine if user has altered their templates;
    # if so, we backup the original, if not, we overwrite it
    my $dict = {};

    eval q[
    # 1.1
    $dict->{'index'}{'Main Index'}{'407110d0415eb2124fa1aa7fcec4a5cc0bebba82'} = 1;
    $dict->{'index'}{'XML RSS Index'}{'59f5ecc2753251c43340b82213c7e16623c0410f'} = 1;
    $dict->{'index'}{'Master Archive Index'}{'5770ee182268b0cfb12ef9b1e66caa7d6406e4d8'} = 1;
    $dict->{'archive'}{'Date-Based Archive Template'}{'c01c93248e62619772298ccaf99fd4310bc11ea8'} = 1;
    $dict->{'category'}{'Category Archive Template'}{'c01c93248e62619772298ccaf99fd4310bc11ea8'} = 1;
    $dict->{'individual'}{'Individual Entry Archive Template'}{'c32c51426c660fc865929ab6a043869b8a3d3e85'} = 1;
    $dict->{'comment_preview'}{'Comment Preview Template'}{'e6377a7ad2f550a94ca36b9bc09dd7204783a37e'} = 1;
    $dict->{'comments'}{'Comment Listing Template'}{'d4c0d0290912320805f04ff15832ac1a6fc80af6'} = 1;

    # 1.2
    $dict->{'index'}{'Main Index'}{'4dc91ae495205f70d87ee3b6f2162e86fb5731a8'} = 1;
    $dict->{'index'}{'XML RSS Index'}{'59f5ecc2753251c43340b82213c7e16623c0410f'} = 1;
    $dict->{'index'}{'Master Archive Index'}{'5770ee182268b0cfb12ef9b1e66caa7d6406e4d8'} = 1;
    $dict->{'archive'}{'Date-Based Archive Template'}{'c01c93248e62619772298ccaf99fd4310bc11ea8'} = 1;
    $dict->{'category'}{'Category Archive Template'}{'c01c93248e62619772298ccaf99fd4310bc11ea8'} = 1;
    $dict->{'individual'}{'Individual Entry Archive Template'}{'c32c51426c660fc865929ab6a043869b8a3d3e85'} = 1;
    $dict->{'comment_preview'}{'Comment Preview Template'}{'e6377a7ad2f550a94ca36b9bc09dd7204783a37e'} = 1;
    $dict->{'comments'}{'Comment Listing Template'}{'d4c0d0290912320805f04ff15832ac1a6fc80af6'} = 1;
    $dict->{'popup_image'}{'Uploaded Image Popup Template'}{'71b0a469d94db802f03aa69965415dea137ace06'} = 1;

    # 1.31
    $dict->{'index'}{'Main Index'}{'816f80828d83fcc7ef6170459929f7cccc999c61'} = 1;
    $dict->{'index'}{'XML RSS Index'}{'6743a150c8eb9f90a44df7c45920a1cd4693b80d'} = 1;
    $dict->{'index'}{'Master Archive Index'}{'5e1279912e02f5c20d58d50f5b47dc3c08e02c43'} = 1;
    $dict->{'archive'}{'Date-Based Archive Template'}{'c01c93248e62619772298ccaf99fd4310bc11ea8'} = 1;
    $dict->{'category'}{'Category Archive Template'}{'c01c93248e62619772298ccaf99fd4310bc11ea8'} = 1;
    $dict->{'individual'}{'Individual Entry Archive Template'}{'1edf13dc974b75c9f0580e6f298a9046fd536dd3'} = 1;
    $dict->{'comment_preview'}{'Comment Preview Template'}{'e6377a7ad2f550a94ca36b9bc09dd7204783a37e'} = 1;
    $dict->{'comments'}{'Comment Listing Template'}{'d5bd507c47d953167cc949c914b2e708af414474'} = 1;
    $dict->{'popup_image'}{'Uploaded Image Popup Template'}{'71b0a469d94db802f03aa69965415dea137ace06'} = 1;

    # 1.4
    $dict->{'index'}{'Main Index'}{'879245bcd891fe2ce9d69d97e7f2892b3011e45a'} = 1;
    $dict->{'index'}{'XML RSS Index'}{'6743a150c8eb9f90a44df7c45920a1cd4693b80d'} = 1;
    $dict->{'index'}{'Master Archive Index'}{'ed2babcbd627bae187b72e8a7ca7de1b63c6c6c5'} = 1;
    $dict->{'comment_error'}{'Comment Error Template'}{'ce6914e66298009da5dc1275f9e7f3792f39eedb'} = 1;
    $dict->{'popup_image'}{'Uploaded Image Popup Template'}{'71b0a469d94db802f03aa69965415dea137ace06'} = 1;
    $dict->{'index'}{'Stylesheet'}{'846a2bc52a437dbd7424fed900ccf0abd42c1c33'} = 1;
    $dict->{'archive'}{'Date-Based Archive Template'}{'2b8698c7260f48fc9e0c06fa1400756eff6430fc'} = 1;
    $dict->{'category'}{'Category Archive Template'}{'d4e902c451f53966b067d118ed2883e697fdc02a'} = 1;
    $dict->{'individual'}{'Individual Entry Archive Template'}{'a2957010ed5c5b8e11e98f1e463860063d8fc7eb'} = 1;
    $dict->{'comment_preview'}{'Comment Preview Template'}{'a1980ad808894996c7b50e88ca29a66f969e8870'} = 1;
    $dict->{'comments'}{'Comment Listing Template'}{'7e7807d1400f569593c7abeba423f3be3357f826'} = 1;

    # 2.0
    $dict->{'index'}{'Main Index'}{'76f902f398a10f3728a76027f962bb9f2ce84ff4'} = 1;
    $dict->{'index'}{'RSS 0.91 Index'}{'6743a150c8eb9f90a44df7c45920a1cd4693b80d'} = 1;
    $dict->{'index'}{'Master Archive Index'}{'29987f5f7ba64bf30f5b36ea3ad3bc1b66f028f8'} = 1;
    $dict->{'comment_preview'}{'Comment Preview Template'}{'a1980ad808894996c7b50e88ca29a66f969e8870'} = 1;
    $dict->{'comment_error'}{'Comment Error Template'}{'ce6914e66298009da5dc1275f9e7f3792f39eedb'} = 1;
    $dict->{'popup_image'}{'Uploaded Image Popup Template'}{'71b0a469d94db802f03aa69965415dea137ace06'} = 1;
    $dict->{'comments'}{'Comment Listing Template'}{'7e7807d1400f569593c7abeba423f3be3357f826'} = 1;
    $dict->{'index'}{'RSS 1.0 Index'}{'108ae4976884ad68fb85042c63b101e8d6b67068'} = 1;
    $dict->{'index'}{'Stylesheet'}{'846a2bc52a437dbd7424fed900ccf0abd42c1c33'} = 1;
    $dict->{'archive'}{'Date-Based Archive'}{'92ed95ad9e80e25c977b95cc161468d736a8dfc2'} = 1;
    $dict->{'category'}{'Category Archive'}{'b1833e03af47af1e8648186098584152d49e18df'} = 1;
    $dict->{'individual'}{'Individual Entry Archive'}{'0d50f720a92bad17746bddaf945ac3023c5b97f6'} = 1;

    # 2.11
    $dict->{'index'}{'Main Index'}{'317217b27900666d12d1abf9dc74fb8c8e2bebf0'} = 1;
    $dict->{'index'}{'RSS 0.91 Index'}{'5429e642862a459adc0d6520f610c7113faa211f'} = 1;
    $dict->{'index'}{'Master Archive Index'}{'c257052cf28bfc3ddf9f2ee6ad89a1b83e754906'} = 1;
    $dict->{'comment_preview'}{'Comment Preview Template'}{'55ae4e949428a927c7f48ba013e49a565bb57880'} = 1;
    $dict->{'comment_error'}{'Comment Error Template'}{'b154c876d3b629103a21add608201b9a9595772e'} = 1;
    $dict->{'popup_image'}{'Uploaded Image Popup Template'}{'71b0a469d94db802f03aa69965415dea137ace06'} = 1;
    $dict->{'comments'}{'Comment Listing Template'}{'a5c451d553f7736f4cafb6c61bf1ad0170727721'} = 1;
    $dict->{'index'}{'RSS 1.0 Index'}{'678c192ee6cddfdf8b13b1c30cb3ef5e2bbf7ca6'} = 1;
    $dict->{'index'}{'Stylesheet'}{'4d62b1ecdea486e234a1fba1bceeb777713c467a'} = 1;
    $dict->{'archive'}{'Date-Based Archive'}{'92332c5acbd58a5e2c67418252c6922a7e412792'} = 1;
    $dict->{'category'}{'Category Archive'}{'f58abd34ef257d693f70d12c4b3bbdf102c943b6'} = 1;
    $dict->{'individual'}{'Individual Entry Archive'}{'b201aa4eeaf2c113d033753e3db9f37ea1096c04'} = 1;

    # 2.21
    $dict->{'index'}{'Main Index'}{'ba7bce3d5ea6e7f247c4e88c32465c85bd02242d'} = 1;
    $dict->{'index'}{'RSS 0.91 Index'}{'19abb8489f1703226e2081ce47818151fc1e1533'} = 1;
    $dict->{'index'}{'Master Archive Index'}{'07234b049e1a319f76c0099724a18cedb7af7a82'} = 1;
    $dict->{'comment_preview'}{'Comment Preview Template'}{'55ae4e949428a927c7f48ba013e49a565bb57880'} = 1;
    $dict->{'comment_error'}{'Comment Error Template'}{'b154c876d3b629103a21add608201b9a9595772e'} = 1;
    $dict->{'popup_image'}{'Uploaded Image Popup Template'}{'71b0a469d94db802f03aa69965415dea137ace06'} = 1;
    $dict->{'comments'}{'Comment Listing Template'}{'a5c451d553f7736f4cafb6c61bf1ad0170727721'} = 1;
    $dict->{'index'}{'RSS 1.0 Index'}{'72afff93eb20e4ee9ac68342e265e5b2eea043a9'} = 1;
    $dict->{'index'}{'Stylesheet'}{'3ed7a660665db0fdfd34223fa7677b4268fe5eee'} = 1;
    $dict->{'archive'}{'Date-Based Archive'}{'6c505b012093710d942ad45da55456407f063ecb'} = 1;
    $dict->{'category'}{'Category Archive'}{'d3d2e9c7767ed0e5443f92fde96679486da26968'} = 1;
    $dict->{'individual'}{'Individual Entry Archive'}{'ab71eb8782a242ff74fe0d73a5122bf74c3b6ccc'} = 1;
    $dict->{'pings'}{'TrackBack Listing Template'}{'091fa8912983f9f83adea54089cd3ec69e44f335'} = 1;

    # 2.51
    $dict->{'index'}{'Main Index'}{'f650d9b711be71f4986834c23033e52ae3f134e1'} = 1;
    $dict->{'index'}{'RSS 0.91 Index'}{'26faba6fe7b65b57a8bd8e99679407dc06c301ff'} = 1;
    $dict->{'index'}{'Master Archive Index'}{'b523cd4f0e588abaf869694f5e9f4a08394d79dd'} = 1;
    $dict->{'comment_preview'}{'Comment Preview Template'}{'e80238e281bb77b4891baf2bdd1934fd275b002a'} = 1;
    $dict->{'comment_error'}{'Comment Error Template'}{'b4262b19482af08373b92979abf6e5b1e963e6d8'} = 1;
    $dict->{'popup_image'}{'Uploaded Image Popup Template'}{'71b0a469d94db802f03aa69965415dea137ace06'} = 1;
    $dict->{'comments'}{'Comment Listing Template'}{'7305e3b33b834ae6aa64b22dd18cb55f1e091cbd'} = 1;
    $dict->{'index'}{'RSS 1.0 Index'}{'c4e641a020ba037307e473976974db94ca0058e9'} = 1;
    $dict->{'index'}{'Stylesheet'}{'d8264261da0fb212c8e2e20d34c8f8dc6ce25422'} = 1;
    $dict->{'archive'}{'Date-Based Archive'}{'7875e9fc58524dfe2d5e1fd94182b3f721f7d3e6'} = 1;
    $dict->{'category'}{'Category Archive'}{'e0a6ae9184ef388988d92c1aa86125cc0ab31550'} = 1;
    $dict->{'individual'}{'Individual Entry Archive'}{'ad2a6232d8db895c994a91b19da844def6a5680b'} = 1;
    $dict->{'pings'}{'TrackBack Listing Template'}{'46eb8b1c552d783d3ef7941b38be0899571147db'} = 1;

    # 2.661
    $dict->{'index'}{'Main Index'}{'cff7cd6b841e5784d931c87c93f3c428626f67e6'} = 1;
    $dict->{'index'}{'RSD'}{'287880a4c3840625053077b6334d91c345acd2e4'} = 1;
    $dict->{'index'}{'Atom Index'}{'ecdfb3afb486e634d9438bf0af2e9db47e3a8cf5'} = 1;
    $dict->{'index'}{'RSS 2.0 Index'}{'b2ebbc25310c57b0cf85ae1d2566193fc7ba72c3'} = 1;
    $dict->{'index'}{'Master Archive Index'}{'31f1cd87d6590215dc6babc66809ad6c5ed19a28'} = 1;
    $dict->{'comment_preview'}{'Comment Preview Template'}{'e1c70ed21317c97c8c951ed3bf3279f888635e19'} = 1;
    $dict->{'comment_error'}{'Comment Error Template'}{'cfc5d39862e2cb625596f9e0fb0add633fd3fc7a'} = 1;
    $dict->{'popup_image'}{'Uploaded Image Popup Template'}{'71b0a469d94db802f03aa69965415dea137ace06'} = 1;
    $dict->{'comments'}{'Comment Listing Template'}{'5ab05a3b442ffd5e1d98766e7f1eb7bc0dd89cc3'} = 1;
    $dict->{'index'}{'RSS 1.0 Index'}{'587c576c4df2053bdade147c2eed06676fb57373'} = 1;
    $dict->{'index'}{'Stylesheet'}{'d47f2fc739944385d1f2486d0d34ee129d47c746'} = 1;
    $dict->{'archive'}{'Date-Based Archive'}{'0f4007fe393b99633d5948927f53033eefd4a0f2'} = 1;
    $dict->{'category'}{'Category Archive'}{'908855e015ad1934353550ecd2c640aa9192a53d'} = 1;
    $dict->{'individual'}{'Individual Entry Archive'}{'968646f67c9afda99ac0e0b4e7e85c63fe088ed0'} = 1;
    $dict->{'pings'}{'TrackBack Listing Template'}{'7383112b177902906236e8943890104a9c77344a'} = 1;

    # 3.16
    $dict->{'index'}{'Main Index'}{'257e3d22a3682e9e86aa2d9be53af1e4c9abbbc7'} = 1;
    $dict->{'index'}{'Main Index'}{'4b2e54a6cc5917428b3fb48fb36414a42a5920a6'} = 1;
    $dict->{'index'}{'Main Index'}{'505f1d363a314ef2da488c157a374d6e00c58d57'} = 1;
    $dict->{'index'}{'Main Index'}{'654bcea62270e62de2a28ecc0dd899c8887a69f2'} = 1;
    $dict->{'index'}{'Main Index'}{'78a47d6748c87ad110ef0bead8838a09f26e81a4'} = 1;
    $dict->{'index'}{'Main Index'}{'e7a7a2c704f18d87e723bfffaf5bef04a1dc91dd'} = 1;
    $dict->{'index'}{'Dynamic Site Bootstrapper'}{'2143a746f4f73d9515ca9ab94f3241ca12d17306'} = 1;
    $dict->{'index'}{'RSD'}{'287880a4c3840625053077b6334d91c345acd2e4'} = 1;
    $dict->{'index'}{'Atom Index'}{'b72c5bbb48d9129ea39383e14b98286128952ade'} = 1;
    $dict->{'index'}{'RSS 2.0 Index'}{'81c3335d388f2f69d6311ad4eb6ec344b654684f'} = 1;
    $dict->{'index'}{'Master Archive Index'}{'2214c531eb49879641f1756311e0892f0399a702'} = 1;
    $dict->{'index'}{'Master Archive Index'}{'4fbea20e8866041a59473c23968165499ca58263'} = 1;
    $dict->{'index'}{'Master Archive Index'}{'9c6505c0f818e0f3347797939745f645414b3f47'} = 1;
    $dict->{'index'}{'Master Archive Index'}{'a7851e7e1df743e7697ce987050c6cefe6757295'} = 1;
    $dict->{'index'}{'Master Archive Index'}{'bcb285fdb914d77d1f64f9bdfd93440f3a32720a'} = 1;
    $dict->{'comment_preview'}{'Comment Preview Template'}{'24a9f9c9aa0ba6d6741dc68e10ed5be406d67df8'} = 1;
    $dict->{'comment_preview'}{'Comment Preview Template'}{'785529e76220b7ff2028ba216f5845f981ca7d7d'} = 1;
    $dict->{'comment_preview'}{'Comment Preview Template'}{'82caa3186da19bcea245f653618a0187e2634137'} = 1;
    $dict->{'comment_preview'}{'Comment Preview Template'}{'94a7cb5c4fe76bdae83d3757b4cf2c3e702df34e'} = 1;
    $dict->{'comment_preview'}{'Comment Preview Template'}{'ea173dfc883944776432dd24a103cb7b68e097b4'} = 1;
    $dict->{'comment_preview'}{'Comment Preview Template'}{'fc4cb69b72fbeb8e9cd83886a5ced4f258b8693b'} = 1;
    $dict->{'comment_pending'}{'Comment Pending Message'}{'26eeb357eb88eaf0f750a345b850d59f3f604556'} = 1;
    $dict->{'comment_pending'}{'Comment Pending Message'}{'5c43581ac1a2ce853f4196ba08c6a31b662cd1d1'} = 1;
    $dict->{'comment_pending'}{'Comment Pending Message'}{'8665ead2344f283b1cb7418b9a68dca75876c27b'} = 1;
    $dict->{'comment_pending'}{'Comment Pending Message'}{'951151dc04e6b9ccfdddb9897b3f8c02f3545c6c'} = 1;
    $dict->{'comment_pending'}{'Comment Pending Message'}{'aadde51bddbb40aba343fb9582d4d2cad87fa3e8'} = 1;
    $dict->{'comment_pending'}{'Comment Pending Message'}{'ee85c8685ac1da0841ba3e8a3bf48f6f9665800a'} = 1;
    $dict->{'comment_error'}{'Comment Error Template'}{'30653dc0cb616ae26770cdbd866883ffb2fc0ec9'} = 1;
    $dict->{'comment_error'}{'Comment Error Template'}{'42558b4feda5735b6e9d483fa6765ba094ed6d5e'} = 1;
    $dict->{'comment_error'}{'Comment Error Template'}{'957ca0607d478f8caba7a3e1ba2397d9cd37885f'} = 1;
    $dict->{'comment_error'}{'Comment Error Template'}{'a9d7ebf9d0acd5f2fc8a393591b6b38f09c6b740'} = 1;
    $dict->{'comment_error'}{'Comment Error Template'}{'af1975d66189367b15cec61e342a2b0e23cc9cbd'} = 1;
    $dict->{'comment_error'}{'Comment Error Template'}{'b99d721f630aa2728bea73de47f6cdd87e95ad6c'} = 1;
    $dict->{'popup_image'}{'Uploaded Image Popup Template'}{'f159c35e14a46fe206bf8907bffbb16447cad15c'} = 1;
    $dict->{'comments'}{'Comment Listing Template'}{'64da0621324294f6c9c3341c31c0c941f35e3b57'} = 1;
    $dict->{'comments'}{'Comment Listing Template'}{'92ed4e477d08086e5efc2ded4502c08ff98b9f64'} = 1;
    $dict->{'comments'}{'Comment Listing Template'}{'9d687512b3b2bfc9cb976c903046a579ab887374'} = 1;
    $dict->{'comments'}{'Comment Listing Template'}{'c41bf5b92366ce227689953f1cae14824cdd54ef'} = 1;
    $dict->{'comments'}{'Comment Listing Template'}{'e71b31aebef0475e8c6a8e8de0fd47baec1445d9'} = 1;
    $dict->{'comments'}{'Comment Listing Template'}{'ef9e2dfdf5e99522068456c1871a1d01aaacd2d3'} = 1;
    $dict->{'dynamic_error'}{'Dynamic Pages Error Template'}{'ff3a52b390df5ec6aacdec43112bd047413b4c8c'} = 1;
    $dict->{'index'}{'RSS 1.0 Index'}{'2ff7ed6dc4f509ead2407b6ea3e3f350f28b25bd'} = 1;
    $dict->{'index'}{'Stylesheet'}{'e37a1b39e4c974bf0f3e79dddbf1e855edd0bdca'} = 1;
    $dict->{'archive'}{'Date-Based Archive'}{'1bd4a4984845a41ad3b8a7303b5b4560daa84752'} = 1;
    $dict->{'archive'}{'Date-Based Archive'}{'445a90339da5320f442ecc40d7271b574797677a'} = 1;
    $dict->{'archive'}{'Date-Based Archive'}{'484a36f54c0968b2dbe336845e04307b5e20aa85'} = 1;
    $dict->{'archive'}{'Date-Based Archive'}{'75936096e7d46e0e3f7c06c9df86f69a12b94768'} = 1;
    $dict->{'archive'}{'Date-Based Archive'}{'edeed36ce2b0d6d0ff8052f6cf7f4116f39ac1ab'} = 1;
    $dict->{'archive'}{'Date-Based Archive'}{'f3ef091689d36fc9826200bd55ed21d85a8c53ed'} = 1;
    $dict->{'category'}{'Category Archive'}{'26e7859c15812790454b99de1d3887d0a8e8e6ff'} = 1;
    $dict->{'category'}{'Category Archive'}{'3454326c2552bc1b5bfd1b542ec3ab6c87fb2c43'} = 1;
    $dict->{'category'}{'Category Archive'}{'39096f7db2d393ed66df7de855b9841a90c95485'} = 1;
    $dict->{'category'}{'Category Archive'}{'c0358a683783d625249e9b57075d4d0e6c04cfa7'} = 1;
    $dict->{'category'}{'Category Archive'}{'d178ce949a06690f5c83aa519d801a674430c15c'} = 1;
    $dict->{'category'}{'Category Archive'}{'e81f09062b54027bcd316594c3b945378f0f1347'} = 1;
    $dict->{'individual'}{'Individual Entry Archive'}{'4fcff69ba6afdbcf734ee7c4542cd706a6afdc35'} = 1;
    $dict->{'individual'}{'Individual Entry Archive'}{'551c79d951c8b31a24993a2d9e82fe8b00c2cb3f'} = 1;
    $dict->{'individual'}{'Individual Entry Archive'}{'5a07a70562ecee1aacfb2c2edfd77d1cc7cbf2c6'} = 1;
    $dict->{'individual'}{'Individual Entry Archive'}{'61b03a841e5bb5d2dad7794c068edcaa375853fd'} = 1;
    $dict->{'individual'}{'Individual Entry Archive'}{'855be3df1a0ea28b93bcfc859ed4a9ad723169cc'} = 1;
    $dict->{'individual'}{'Individual Entry Archive'}{'9d01472a423315728d78fcf7e356dbb818ed9ad5'} = 1;
    $dict->{'pings'}{'TrackBack Listing Template'}{'0eef136c91c29bb85a2e3679b6edb5cbcdad843d'} = 1;
    $dict->{'pings'}{'TrackBack Listing Template'}{'5e894b4ee8fcda2023c7fd38af6d26227f00c59a'} = 1;
    $dict->{'pings'}{'TrackBack Listing Template'}{'6a00c296985925588567d31029ad3bb6e018f6ed'} = 1;
    $dict->{'pings'}{'TrackBack Listing Template'}{'7a9681c99d268c7c191c373e7e5e7ff7634e7dd3'} = 1;
    $dict->{'pings'}{'TrackBack Listing Template'}{'cef4ada361d56ab4387be0c890d0be861ee9bf66'} = 1;
    $dict->{'pings'}{'TrackBack Listing Template'}{'fba39a64ad0d8b65344eba4e7f9ca48c8cdb2e3c'} = 1;
    $dict->{'custom'}{'Remember Me'}{'7a644226fb29adec3d541a88d52d792e5672710d'} = 1;

    # 3.17
    $dict->{'index'}{'Main Index'}{'257e3d22a3682e9e86aa2d9be53af1e4c9abbbc7'} = 1;
    $dict->{'index'}{'Main Index'}{'4b2e54a6cc5917428b3fb48fb36414a42a5920a6'} = 1;
    $dict->{'index'}{'Main Index'}{'505f1d363a314ef2da488c157a374d6e00c58d57'} = 1;
    $dict->{'index'}{'Main Index'}{'654bcea62270e62de2a28ecc0dd899c8887a69f2'} = 1;
    $dict->{'index'}{'Main Index'}{'78a47d6748c87ad110ef0bead8838a09f26e81a4'} = 1;
    $dict->{'index'}{'Main Index'}{'e7a7a2c704f18d87e723bfffaf5bef04a1dc91dd'} = 1;
    $dict->{'index'}{'Dynamic Site Bootstrapper'}{'2143a746f4f73d9515ca9ab94f3241ca12d17306'} = 1;
    $dict->{'index'}{'RSD'}{'287880a4c3840625053077b6334d91c345acd2e4'} = 1;
    $dict->{'index'}{'Atom Index'}{'b72c5bbb48d9129ea39383e14b98286128952ade'} = 1;
    $dict->{'index'}{'RSS 2.0 Index'}{'81c3335d388f2f69d6311ad4eb6ec344b654684f'} = 1;
    $dict->{'index'}{'Master Archive Index'}{'2214c531eb49879641f1756311e0892f0399a702'} = 1;
    $dict->{'index'}{'Master Archive Index'}{'4fbea20e8866041a59473c23968165499ca58263'} = 1;
    $dict->{'index'}{'Master Archive Index'}{'9c6505c0f818e0f3347797939745f645414b3f47'} = 1;
    $dict->{'index'}{'Master Archive Index'}{'a7851e7e1df743e7697ce987050c6cefe6757295'} = 1;
    $dict->{'index'}{'Master Archive Index'}{'bcb285fdb914d77d1f64f9bdfd93440f3a32720a'} = 1;
    $dict->{'comment_preview'}{'Comment Preview Template'}{'24a9f9c9aa0ba6d6741dc68e10ed5be406d67df8'} = 1;
    $dict->{'comment_preview'}{'Comment Preview Template'}{'785529e76220b7ff2028ba216f5845f981ca7d7d'} = 1;
    $dict->{'comment_preview'}{'Comment Preview Template'}{'82caa3186da19bcea245f653618a0187e2634137'} = 1;
    $dict->{'comment_preview'}{'Comment Preview Template'}{'94a7cb5c4fe76bdae83d3757b4cf2c3e702df34e'} = 1;
    $dict->{'comment_preview'}{'Comment Preview Template'}{'ea173dfc883944776432dd24a103cb7b68e097b4'} = 1;
    $dict->{'comment_preview'}{'Comment Preview Template'}{'fc4cb69b72fbeb8e9cd83886a5ced4f258b8693b'} = 1;
    $dict->{'comment_pending'}{'Comment Pending Message'}{'26eeb357eb88eaf0f750a345b850d59f3f604556'} = 1;
    $dict->{'comment_pending'}{'Comment Pending Message'}{'5c43581ac1a2ce853f4196ba08c6a31b662cd1d1'} = 1;
    $dict->{'comment_pending'}{'Comment Pending Message'}{'8665ead2344f283b1cb7418b9a68dca75876c27b'} = 1;
    $dict->{'comment_pending'}{'Comment Pending Message'}{'951151dc04e6b9ccfdddb9897b3f8c02f3545c6c'} = 1;
    $dict->{'comment_pending'}{'Comment Pending Message'}{'aadde51bddbb40aba343fb9582d4d2cad87fa3e8'} = 1;
    $dict->{'comment_pending'}{'Comment Pending Message'}{'ee85c8685ac1da0841ba3e8a3bf48f6f9665800a'} = 1;
    $dict->{'comment_error'}{'Comment Error Template'}{'30653dc0cb616ae26770cdbd866883ffb2fc0ec9'} = 1;
    $dict->{'comment_error'}{'Comment Error Template'}{'42558b4feda5735b6e9d483fa6765ba094ed6d5e'} = 1;
    $dict->{'comment_error'}{'Comment Error Template'}{'957ca0607d478f8caba7a3e1ba2397d9cd37885f'} = 1;
    $dict->{'comment_error'}{'Comment Error Template'}{'a9d7ebf9d0acd5f2fc8a393591b6b38f09c6b740'} = 1;
    $dict->{'comment_error'}{'Comment Error Template'}{'af1975d66189367b15cec61e342a2b0e23cc9cbd'} = 1;
    $dict->{'comment_error'}{'Comment Error Template'}{'b99d721f630aa2728bea73de47f6cdd87e95ad6c'} = 1;
    $dict->{'popup_image'}{'Uploaded Image Popup Template'}{'f159c35e14a46fe206bf8907bffbb16447cad15c'} = 1;
    $dict->{'comments'}{'Comment Listing Template'}{'64da0621324294f6c9c3341c31c0c941f35e3b57'} = 1;
    $dict->{'comments'}{'Comment Listing Template'}{'92ed4e477d08086e5efc2ded4502c08ff98b9f64'} = 1;
    $dict->{'comments'}{'Comment Listing Template'}{'9d687512b3b2bfc9cb976c903046a579ab887374'} = 1;
    $dict->{'comments'}{'Comment Listing Template'}{'c41bf5b92366ce227689953f1cae14824cdd54ef'} = 1;
    $dict->{'comments'}{'Comment Listing Template'}{'e71b31aebef0475e8c6a8e8de0fd47baec1445d9'} = 1;
    $dict->{'comments'}{'Comment Listing Template'}{'ef9e2dfdf5e99522068456c1871a1d01aaacd2d3'} = 1;
    $dict->{'dynamic_error'}{'Dynamic Pages Error Template'}{'ff3a52b390df5ec6aacdec43112bd047413b4c8c'} = 1;
    $dict->{'index'}{'RSS 1.0 Index'}{'2ff7ed6dc4f509ead2407b6ea3e3f350f28b25bd'} = 1;
    $dict->{'index'}{'Stylesheet'}{'e37a1b39e4c974bf0f3e79dddbf1e855edd0bdca'} = 1;
    $dict->{'archive'}{'Date-Based Archive'}{'1bd4a4984845a41ad3b8a7303b5b4560daa84752'} = 1;
    $dict->{'archive'}{'Date-Based Archive'}{'445a90339da5320f442ecc40d7271b574797677a'} = 1;
    $dict->{'archive'}{'Date-Based Archive'}{'484a36f54c0968b2dbe336845e04307b5e20aa85'} = 1;
    $dict->{'archive'}{'Date-Based Archive'}{'75936096e7d46e0e3f7c06c9df86f69a12b94768'} = 1;
    $dict->{'archive'}{'Date-Based Archive'}{'edeed36ce2b0d6d0ff8052f6cf7f4116f39ac1ab'} = 1;
    $dict->{'archive'}{'Date-Based Archive'}{'f3ef091689d36fc9826200bd55ed21d85a8c53ed'} = 1;
    $dict->{'category'}{'Category Archive'}{'26e7859c15812790454b99de1d3887d0a8e8e6ff'} = 1;
    $dict->{'category'}{'Category Archive'}{'3454326c2552bc1b5bfd1b542ec3ab6c87fb2c43'} = 1;
    $dict->{'category'}{'Category Archive'}{'39096f7db2d393ed66df7de855b9841a90c95485'} = 1;
    $dict->{'category'}{'Category Archive'}{'c0358a683783d625249e9b57075d4d0e6c04cfa7'} = 1;
    $dict->{'category'}{'Category Archive'}{'d178ce949a06690f5c83aa519d801a674430c15c'} = 1;
    $dict->{'category'}{'Category Archive'}{'e81f09062b54027bcd316594c3b945378f0f1347'} = 1;
    $dict->{'individual'}{'Individual Entry Archive'}{'4fcff69ba6afdbcf734ee7c4542cd706a6afdc35'} = 1;
    $dict->{'individual'}{'Individual Entry Archive'}{'551c79d951c8b31a24993a2d9e82fe8b00c2cb3f'} = 1;
    $dict->{'individual'}{'Individual Entry Archive'}{'5a07a70562ecee1aacfb2c2edfd77d1cc7cbf2c6'} = 1;
    $dict->{'individual'}{'Individual Entry Archive'}{'61b03a841e5bb5d2dad7794c068edcaa375853fd'} = 1;
    $dict->{'individual'}{'Individual Entry Archive'}{'855be3df1a0ea28b93bcfc859ed4a9ad723169cc'} = 1;
    $dict->{'individual'}{'Individual Entry Archive'}{'9d01472a423315728d78fcf7e356dbb818ed9ad5'} = 1;
    $dict->{'pings'}{'TrackBack Listing Template'}{'0eef136c91c29bb85a2e3679b6edb5cbcdad843d'} = 1;
    $dict->{'pings'}{'TrackBack Listing Template'}{'5e894b4ee8fcda2023c7fd38af6d26227f00c59a'} = 1;
    $dict->{'pings'}{'TrackBack Listing Template'}{'6a00c296985925588567d31029ad3bb6e018f6ed'} = 1;
    $dict->{'pings'}{'TrackBack Listing Template'}{'7a9681c99d268c7c191c373e7e5e7ff7634e7dd3'} = 1;
    $dict->{'pings'}{'TrackBack Listing Template'}{'cef4ada361d56ab4387be0c890d0be861ee9bf66'} = 1;
    $dict->{'pings'}{'TrackBack Listing Template'}{'fba39a64ad0d8b65344eba4e7f9ca48c8cdb2e3c'} = 1;
    $dict->{'custom'}{'Remember Me'}{'7a644226fb29adec3d541a88d52d792e5672710d'} = 1;

    # 3.2
    $dict->{'index'}{'Main Index'}{'50c83d4f945489528298570a92f2b4ad1afdb1f6'} = 1;
    $dict->{'index'}{'Main Index'}{'c57f03abae67d14e4163535d6e811e274087a4e4'} = 1;
    $dict->{'index'}{'Main Index'}{'6c70ae96c27376919b21bd0e2605cc2aaf3a84b8'} = 1;
    $dict->{'index'}{'Main Index'}{'31ad7c7ebc035652b77e9987fd2d6f203e5fcc8d'} = 1;
    $dict->{'index'}{'Main Index'}{'d03205618f10d0843d61cd664599c2c4c2a85627'} = 1;
    $dict->{'index'}{'Main Index'}{'289070a23482e6e04fbb3f8020c697269ee167cd'} = 1;
    $dict->{'index'}{'Dynamic Site Bootstrapper'}{'e9b325331bd4fce9ca9b544b2a09fa9e01fbd541'} = 1;
    $dict->{'index'}{'RSD'}{'57543f1fd2c6bcb1ed16eaa7d928730a837149d0'} = 1;
    $dict->{'index'}{'Atom Index'}{'5fa1a4c059ce2dcddb526cfa12eae1003be2583b'} = 1;
    $dict->{'index'}{'RSS 2.0 Index'}{'c8b422769d99f8fd21442642d2b79e5a0ee1a85a'} = 1;
    $dict->{'index'}{'Master Archive Index'}{'e9db4c670ff9aff2baea7f609b6db77935ac4282'} = 1;
    $dict->{'index'}{'Master Archive Index'}{'792372eb3c7d207818cea314290369b05c392c3b'} = 1;
    $dict->{'index'}{'Master Archive Index'}{'bff8a874202697b68f9227b71c35ceb11e39a436'} = 1;
    $dict->{'index'}{'Master Archive Index'}{'315b7a74963f553bbd4bd5141052c90520fe6e41'} = 1;
    $dict->{'index'}{'Master Archive Index'}{'653bd8afe0c2763320e7a5f12ceef732a61ed009'} = 1;
    $dict->{'index'}{'Master Archive Index'}{'c95c904e8ee5fd1d7031fe53696c150d7de88956'} = 1;
    $dict->{'comment_preview'}{'Comment Preview Template'}{'4c46ae1ad45f314b47a5bc6216c36bd91f83a932'} = 1;
    $dict->{'comment_preview'}{'Comment Preview Template'}{'1a008e9944ae68ecca38581650ab1e877e131755'} = 1;
    $dict->{'comment_preview'}{'Comment Preview Template'}{'c47383d88a3496506a2c5096933e46f3a95caacc'} = 1;
    $dict->{'comment_preview'}{'Comment Preview Template'}{'2ced278066ee02eb3f247fb8219af43aad049b1b'} = 1;
    $dict->{'comment_preview'}{'Comment Preview Template'}{'08d99a3752549f3d03b4a6265f4c9aaa17724e4e'} = 1;
    $dict->{'comment_preview'}{'Comment Preview Template'}{'bb4801361a4d93826641b184cb9bf2514fb4ca95'} = 1;
    $dict->{'comment_pending'}{'Comment Pending Template'}{'ebd77c22cad2162e95fe9c9e68a1c03aac2aadca'} = 1;
    $dict->{'comment_pending'}{'Comment Pending Template'}{'8cfcdc8a96ec36a8b05851d292f6fba5eb2b4a0d'} = 1;
    $dict->{'comment_pending'}{'Comment Pending Template'}{'19d72988852a13874e6f44ed070b2e1195ceba5d'} = 1;
    $dict->{'comment_pending'}{'Comment Pending Template'}{'3d8028a0374adb4832d828bc729bacc6c2ea2847'} = 1;
    $dict->{'comment_pending'}{'Comment Pending Template'}{'3d08a028a703672bffeadbd914cb2cb1a2e230a8'} = 1;
    $dict->{'comment_pending'}{'Comment Pending Template'}{'b9baeb21b2d210d2e3ef21792a5924b5697b0dde'} = 1;
    $dict->{'comment_error'}{'Comment Error Template'}{'249ed8a29c6a907d952c99b8eb7ce8ff985ede81'} = 1;
    $dict->{'comment_error'}{'Comment Error Template'}{'643bcfa881c379c964423eec1d7d684e75d499e8'} = 1;
    $dict->{'comment_error'}{'Comment Error Template'}{'02f0b905002fe592a0cf112d37564e276b0faa2d'} = 1;
    $dict->{'comment_error'}{'Comment Error Template'}{'b4f20dae1728aa1fe16dd69ea4be6b9e781f502a'} = 1;
    $dict->{'comment_error'}{'Comment Error Template'}{'65b5906a68d564a801c39887e1fee0d2e5f49e2a'} = 1;
    $dict->{'comment_error'}{'Comment Error Template'}{'8f6bcc9c90a8ee868e5968e9a6bd2c32a986b14d'} = 1;
    $dict->{'popup_image'}{'Uploaded Image Popup Template'}{'f159c35e14a46fe206bf8907bffbb16447cad15c'} = 1;
    $dict->{'comments'}{'Comment Listing Template'}{'1a438795836b35184d43c07071fcb40cf3d8464d'} = 1;
    $dict->{'comments'}{'Comment Listing Template'}{'9e7b74ac71a7b0dc52b2c0cd90ec79df06ec3f98'} = 1;
    $dict->{'comments'}{'Comment Listing Template'}{'e8486e7aa71b9421f2d9c344bf10bbdad97f7685'} = 1;
    $dict->{'comments'}{'Comment Listing Template'}{'8d85f97157a0614e0311ba37f1f2f6873bad21b2'} = 1;
    $dict->{'comments'}{'Comment Listing Template'}{'eaaa98262408c5fc639d137b59d90948393532f1'} = 1;
    $dict->{'comments'}{'Comment Listing Template'}{'a38c1b53de303a6d170ef1a5e0cbccccbd2e409a'} = 1;
    $dict->{'dynamic_error'}{'Dynamic Pages Error Template'}{'a966eff35cf5ba521b3cf65b3a864e7928ce545e'} = 1;
    $dict->{'index'}{'Stylesheet'}{'c5fcd0645c518f20229845ae6d1d5f87705561dc'} = 1;
    $dict->{'archive'}{'Date-Based Archive'}{'56045fcb3935d936148a2885f38b6a78404b4744'} = 1;
    $dict->{'archive'}{'Date-Based Archive'}{'12bcfe8fbe9d111156791b8c8f3c8749f83dd424'} = 1;
    $dict->{'archive'}{'Date-Based Archive'}{'a8a589ba1331776f44ed3bec77a786071dd5dc1e'} = 1;
    $dict->{'archive'}{'Date-Based Archive'}{'77799d5e65d5d122112ac8b88457fa03fe082aec'} = 1;
    $dict->{'archive'}{'Date-Based Archive'}{'f4b51a67552dbe21883b49225de20ade4ae32796'} = 1;
    $dict->{'archive'}{'Date-Based Archive'}{'5136216dedc36b2c09c5f8af50ce882500691ec8'} = 1;
    $dict->{'category'}{'Category Archive'}{'224baa825cd0aabad7103d63e658445b8a526832'} = 1;
    $dict->{'category'}{'Category Archive'}{'75bdfb699a3ffed81a694c28a4546eb69a63b048'} = 1;
    $dict->{'category'}{'Category Archive'}{'a7dbf80b657fbb0aa60a7921d4afb28f5e3deab5'} = 1;
    $dict->{'category'}{'Category Archive'}{'151218ebde34c7b519d545b2599cdd7710f94581'} = 1;
    $dict->{'category'}{'Category Archive'}{'8228cc33b01dfc9e56d54ef9244050b5fb4b5edb'} = 1;
    $dict->{'category'}{'Category Archive'}{'2477eaa407ceedf22a5cfd45a712ecfa679bb239'} = 1;
    $dict->{'individual'}{'Individual Entry Archive'}{'2478a6d2a8e2263e08e186c16e628c3308537f7e'} = 1;
    $dict->{'individual'}{'Individual Entry Archive'}{'4481d3e46f181fc48f20deb04cefee32e10b93df'} = 1;
    $dict->{'individual'}{'Individual Entry Archive'}{'5450a02da684d62ce641def899ce2fb1552bd4df'} = 1;
    $dict->{'individual'}{'Individual Entry Archive'}{'12a44b921edd2c334f080d12e12165667ba32bec'} = 1;
    $dict->{'individual'}{'Individual Entry Archive'}{'e9bb249680f91f4ae47dc7f378549dbe96be449b'} = 1;
    $dict->{'individual'}{'Individual Entry Archive'}{'45ff13684d97060048bc6713a998cefc969c8a73'} = 1;
    $dict->{'pings'}{'TrackBack Listing Template'}{'804336c28aa4889bf1db400d104ba4ae96c8268b'} = 1;
    $dict->{'pings'}{'TrackBack Listing Template'}{'26640fe63e03f3bfc5b7352816f7f1da45a64105'} = 1;
    $dict->{'pings'}{'TrackBack Listing Template'}{'c3d91a9921bdab4ea7ce0861add698bdc626fdd2'} = 1;
    $dict->{'pings'}{'TrackBack Listing Template'}{'4056479095700a138b9496e8ec213fc98a2d3757'} = 1;
    $dict->{'pings'}{'TrackBack Listing Template'}{'be7d64c95bc35412fb2849c66b4c98a00a354302'} = 1;
    $dict->{'pings'}{'TrackBack Listing Template'}{'c141038bad4434a325f2addca28d70cd3fc52601'} = 1;
    $dict->{'index'}{'Site JavaScript'}{'353deac26b1e36413f04e168334673cf4ceb0d6e'} = 1;
    $dict->{'index'}{'Site JavaScript'}{'f434f656daffa9d38f2aead9afff9479c3f02370'} = 1;
    $dict->{'index'}{'Site JavaScript'}{'e1d1b06e1d5ea59074ce4c6a3d1d97de5d66fbbc'} = 1;
    $dict->{'index'}{'Site JavaScript'}{'5eda24da316fc1d2fe419b27f0f9271da1a01b04'} = 1;
    $dict->{'index'}{'Site JavaScript'}{'c791e4ff1f6ff8219fe9164f5abfe99caedc097e'} = 1;
    $dict->{'index'}{'Site JavaScript'}{'7d7fee169eff2197beb2d402a760f3983ed215b5'} = 1;

    # 3.3
    $dict->{'index'}{'Main Index'}{'5c40d95bb5dfd4ad1925eab9f09dcdb2f4e4667e'} = 1;
    $dict->{'index'}{'Main Index'}{'6183febd21fd0ee9b401ca55b69318785498da95'} = 1;
    $dict->{'index'}{'Main Index'}{'6e5c86d10ed330c9823d993d316c5253d6cf7675'} = 1;
    $dict->{'index'}{'Main Index'}{'b449bb77af595dad6be852b94f0e4b9405b8dc21'} = 1;
    $dict->{'index'}{'Main Index'}{'bee2ede21b56818fb509437325d083b7812f0355'} = 1;
    $dict->{'index'}{'Main Index'}{'dd5394ca9d1883a9a0addba0a872f7c333fbf72c'} = 1;
    $dict->{'index'}{'Dynamic Site Bootstrapper'}{'e9b325331bd4fce9ca9b544b2a09fa9e01fbd541'} = 1;
    $dict->{'index'}{'RSD'}{'ff390cfb6e179278ed90ed19c46980046cc6ca98'} = 1;
    $dict->{'index'}{'Atom Index'}{'fba75a39812b73ed25b178c6d54a0d88ded749c6'} = 1;
    $dict->{'index'}{'RSS 2.0 Index'}{'28308bc499f2d583cc16451fdee9b4fd0afe7535'} = 1;
    $dict->{'index'}{'Master Archive Index'}{'43fc316f6cbd036a454105a4650633256a7848d2'} = 1;
    $dict->{'index'}{'Master Archive Index'}{'4e7986a28b29f3f9c71b83611c9d7fa801e712f5'} = 1;
    $dict->{'index'}{'Master Archive Index'}{'6967e2b3a874721e415a14974d07bf8d98bb7313'} = 1;
    $dict->{'index'}{'Master Archive Index'}{'6b5420d20e98b218729532bf4cd6f3a1e854b63d'} = 1;
    $dict->{'index'}{'Master Archive Index'}{'aa78a22812234cfedac73007f3174c11e97f5ca7'} = 1;
    $dict->{'index'}{'Master Archive Index'}{'f24a0cd05ce723f528a0cf5b5bdd9fd8e7b122a3'} = 1;
    $dict->{'comment_preview'}{'Comment Preview Template'}{'02a7238b5cf47492a25346c12403bf4619dde421'} = 1;
    $dict->{'comment_preview'}{'Comment Preview Template'}{'0d4d33131d2619c282a772a6612ced7b1b756e74'} = 1;
    $dict->{'comment_preview'}{'Comment Preview Template'}{'1c9ed4be426132a92234b931d08dc293f8821c74'} = 1;
    $dict->{'comment_preview'}{'Comment Preview Template'}{'39b252fd0d7be06928c0c85f27db9d782a7ad8cc'} = 1;
    $dict->{'comment_preview'}{'Comment Preview Template'}{'78ade98c2c2c1c302003b75704271edcd9a1a553'} = 1;
    $dict->{'comment_preview'}{'Comment Preview Template'}{'de1b72e1f90d18c8f4d53fc20b058a415229cb34'} = 1;
    $dict->{'search_template'}{'Search Results Template'}{'486ef66c812aff3cea76e0139a119741f378c03e'} = 1;
    $dict->{'search_template'}{'Search Results Template'}{'5c61bb51b5009064ac5d0714c45872e90f962ec7'} = 1;
    $dict->{'search_template'}{'Search Results Template'}{'6083abaa94bc6124d7c81b0e6eb2edece1e2b6e6'} = 1;
    $dict->{'search_template'}{'Search Results Template'}{'7ea885c35f4babd5e5d27dbd29de4883d90b7ad5'} = 1;
    $dict->{'search_template'}{'Search Results Template'}{'a0ae181a5da00e05fecd2da63a93707a60cdf46a'} = 1;
    $dict->{'search_template'}{'Search Results Template'}{'fc747caff630fc6ce954c2167fd76291b32442ee'} = 1;
    $dict->{'comment_pending'}{'Comment Pending Template'}{'203c19dc815ee2a569e999ffe45c9d181938c7e8'} = 1;
    $dict->{'comment_pending'}{'Comment Pending Template'}{'45623af81ada62e96da3a0250677a2a9eb89165a'} = 1;
    $dict->{'comment_pending'}{'Comment Pending Template'}{'af1b078b411608c1624479f9fef21bf23e7035aa'} = 1;
    $dict->{'comment_pending'}{'Comment Pending Template'}{'b0a9c1e1fdb222415252334fc806b1e9cd1e9cd4'} = 1;
    $dict->{'comment_pending'}{'Comment Pending Template'}{'bc45c2305e3dd8980369e30d9b26a6a04a01e439'} = 1;
    $dict->{'comment_pending'}{'Comment Pending Template'}{'e7489716f8a2b0a3858337a37ae8836394f690fd'} = 1;
    $dict->{'comment_error'}{'Comment Error Template'}{'15d7ebb7000b738ac3afd9666874772165962f90'} = 1;
    $dict->{'comment_error'}{'Comment Error Template'}{'a8d3a908dca1d038a2dc8904628d76aa94a289a1'} = 1;
    $dict->{'comment_error'}{'Comment Error Template'}{'b836e718fa1241b2ef68b7da8cfa2fa3918f2dae'} = 1;
    $dict->{'comment_error'}{'Comment Error Template'}{'d742280800194d70a9dc5dc72c774183e5566e32'} = 1;
    $dict->{'comment_error'}{'Comment Error Template'}{'ed3c39c66bb65883520844671d17ba19d408e28c'} = 1;
    $dict->{'comment_error'}{'Comment Error Template'}{'f11e4ab182d6f9d0a0ddeb002e7d84a3296ad9f8'} = 1;
    $dict->{'popup_image'}{'Uploaded Image Popup Template'}{'f159c35e14a46fe206bf8907bffbb16447cad15c'} = 1;
    $dict->{'comments'}{'Comment Listing Template'}{'da39a3ee5e6b4b0d3255bfef95601890afd80709'} = 1;
    $dict->{'dynamic_error'}{'Dynamic Pages Error Template'}{'67f321198052295b9c7090a843a7dd39e1856b5c'} = 1;
    $dict->{'dynamic_error'}{'Dynamic Pages Error Template'}{'74f785030fee43e54aec17495a0d668b32d04400'} = 1;
    $dict->{'dynamic_error'}{'Dynamic Pages Error Template'}{'8263c276766334f5ade678c814c7bc2705e60094'} = 1;
    $dict->{'dynamic_error'}{'Dynamic Pages Error Template'}{'9cf7a4087e15af2c97513d96bc0645c50bb7988c'} = 1;
    $dict->{'dynamic_error'}{'Dynamic Pages Error Template'}{'be2e380cc8806fe7d28722f2edab1b01c5a2e7eb'} = 1;
    $dict->{'dynamic_error'}{'Dynamic Pages Error Template'}{'beb0de4c18f4ccb7c96d0fa8a20443b89fd561e5'} = 1;
    $dict->{'index'}{'Stylesheet'}{'f56b73a0ee479d80cd828351cd0e44d28f1b408c'} = 1;
    $dict->{'archive'}{'Date-Based Archive'}{'40741d060c976c434bce68f04ba67a3a0ec00b0e'} = 1;
    $dict->{'archive'}{'Date-Based Archive'}{'49fa2e5810477aca64084689aa424993bc5b6e22'} = 1;
    $dict->{'archive'}{'Date-Based Archive'}{'7bde4f815ccb8657b0680b10ecda21dc7e48123b'} = 1;
    $dict->{'archive'}{'Date-Based Archive'}{'89ef8a786feea9b3071c0c0ae4aff3fd6f3882be'} = 1;
    $dict->{'archive'}{'Date-Based Archive'}{'b2702df25d1b570009bd0a55d2fb9a645343a92c'} = 1;
    $dict->{'archive'}{'Date-Based Archive'}{'b99e0a5026a5863bbaea907cbc11cd51fbd336d5'} = 1;
    $dict->{'category'}{'Category Archive'}{'a1b4c5cbada8123d978bff41286f1703be686cfd'} = 1;
    $dict->{'category'}{'Category Archive'}{'b2d98dbefdd32ff4d4f9d1368dbca4b6518cca2f'} = 1;
    $dict->{'category'}{'Category Archive'}{'c22c57d60ad210ae743c8e427c441a07fd3ab2b7'} = 1;
    $dict->{'category'}{'Category Archive'}{'c274c9b03542f5dfb765ea8540c7185da09fdeac'} = 1;
    $dict->{'category'}{'Category Archive'}{'e3dcd193e33875d0982a28f2c443a27126c10cf1'} = 1;
    $dict->{'category'}{'Category Archive'}{'f6771cefb5e3d8ae7d1bb6bb264171ac843a5df3'} = 1;
    $dict->{'individual'}{'Individual Entry Archive'}{'0a84e63531a74dd4a4ef6b24ea8c2b91ee271e4f'} = 1;
    $dict->{'individual'}{'Individual Entry Archive'}{'2af8713ded4763c22fa49b675d7c46823e860522'} = 1;
    $dict->{'individual'}{'Individual Entry Archive'}{'4f109310012f04b90b5fcf3f3989f573e105da07'} = 1;
    $dict->{'individual'}{'Individual Entry Archive'}{'cd34a24be876fcb4d3791a007fffbb860f719ab1'} = 1;
    $dict->{'individual'}{'Individual Entry Archive'}{'e5997b7781fac409e8b0c5291e62d7110f9f70f2'} = 1;
    $dict->{'individual'}{'Individual Entry Archive'}{'ea8ff046d33b13e184a6554913b1a1ca9f511caf'} = 1;
    $dict->{'pings'}{'TrackBack Listing Template'}{'2413900dd7bab6a9f343b3928e87b0e9a002e51f'} = 1;
    $dict->{'pings'}{'TrackBack Listing Template'}{'37447d36ad1b21412dbbca4e65e1ab9dd3fc568d'} = 1;
    $dict->{'pings'}{'TrackBack Listing Template'}{'467445a45144ab4693afe5dfb9afd2227d030096'} = 1;
    $dict->{'pings'}{'TrackBack Listing Template'}{'6091982a5937c8f195fa9f7a088257422b541401'} = 1;
    $dict->{'pings'}{'TrackBack Listing Template'}{'976b0a3ab1150ea819179e2142cfa26f04ddeef6'} = 1;
    $dict->{'pings'}{'TrackBack Listing Template'}{'ed00503cfdad65bc0dc6052dcec65156c28e70f5'} = 1;
    $dict->{'index'}{'Site JavaScript'}{'54bca4e2bc0f5dbb60597510fbe61ff4ed003411'} = 1;
    $dict->{'index'}{'Site JavaScript'}{'5f3eed652dcf68046f9b97d3fdce37c775f342d8'} = 1;
    $dict->{'index'}{'Site JavaScript'}{'6f0f45ab3722ceb61975b6f6dd8a520f928764a6'} = 1;
    $dict->{'index'}{'Site JavaScript'}{'c09cf11cc201c9f496d288c70b04ece48e6538b9'} = 1;
    $dict->{'index'}{'Site JavaScript'}{'cb63919ca27db43fb53d8a276330173f38b1711a'} = 1;
    $dict->{'index'}{'Site JavaScript'}{'d9fde44333056883277185fc507eb162d5334bcf'} = 1;

    # MTE 1.51
    $dict->{'index'}{'Main Index'}{'313ff96167d85dc564e8b577be4cb0f21a57ff36'} = 1;
    $dict->{'index'}{'Main Index'}{'34b9a84fd904fa243ce5bff1f7bb570eab37cd8e'} = 1;
    $dict->{'index'}{'Main Index'}{'392cd1eaad29457abe09876f4215e53482ab0932'} = 1;
    $dict->{'index'}{'Main Index'}{'57bb52200d69dbe3aa3790bd29def3264244a0fc'} = 1;
    $dict->{'index'}{'Main Index'}{'c59ca450273e6315e6416276c2f57bb4ced8f53b'} = 1;
    $dict->{'index'}{'Main Index'}{'d35f6145a1fed70c6b48d6ca82308a578e95343b'} = 1;
    $dict->{'index'}{'Dynamic Site Bootstrapper'}{'e9b325331bd4fce9ca9b544b2a09fa9e01fbd541'} = 1;
    $dict->{'index'}{'RSD'}{'ff390cfb6e179278ed90ed19c46980046cc6ca98'} = 1;
    $dict->{'index'}{'Atom Index'}{'4ca4dd94a6ec56e2a2a506bd1039cf886cc07b04'} = 1;
    $dict->{'index'}{'RSS 2.0 Index'}{'b432c8fef71ec8ff3826bb870bdcb435eb34a7e8'} = 1;
    $dict->{'index'}{'Master Archive Index'}{'6237ff54b2a7b71f5d55e68ff70da40ca6421486'} = 1;
    $dict->{'index'}{'Master Archive Index'}{'985a3f84fe24aaead9a28d7fb90933d661a72d12'} = 1;
    $dict->{'index'}{'Master Archive Index'}{'a83c2bfe580562c77f42a2ac61bf0d42278c980a'} = 1;
    $dict->{'index'}{'Master Archive Index'}{'c3b9ce80a837629c92ad9cb31ee18393bc06c6f4'} = 1;
    $dict->{'index'}{'Master Archive Index'}{'d1ca7959fb5e8edf6648e6474bb3f4feafdcd61f'} = 1;
    $dict->{'index'}{'Master Archive Index'}{'f361fec0148d58238e9558c20117f2a7bf1fb552'} = 1;
    $dict->{'comment_preview'}{'Comment Preview Template'}{'485adc13e97ac8156f40a4502b20072e2f08629a'} = 1;
    $dict->{'comment_preview'}{'Comment Preview Template'}{'516a58045dca00e539dc57c7f553b9bec5657154'} = 1;
    $dict->{'comment_preview'}{'Comment Preview Template'}{'647698177249dea2b8e4b930259b1a30e5d1d86b'} = 1;
    $dict->{'comment_preview'}{'Comment Preview Template'}{'a293a6806509221435c304084d3bb0013cab589c'} = 1;
    $dict->{'comment_preview'}{'Comment Preview Template'}{'ae5851eab2018c2ae8e63083d58e9200316ca03c'} = 1;
    $dict->{'comment_preview'}{'Comment Preview Template'}{'f192a8d0a920e78f43558754b4d81249e51b8863'} = 1;
    $dict->{'search_template'}{'Search Results Template'}{'16808308a12156eb48e09d6c784c0b1f64310945'} = 1;
    $dict->{'search_template'}{'Search Results Template'}{'4ddc46ef33b2a2e6f2020c3785401a40074fe19b'} = 1;
    $dict->{'search_template'}{'Search Results Template'}{'565687178c2da3ece1c921c7a34abb4f1733e711'} = 1;
    $dict->{'search_template'}{'Search Results Template'}{'a7cac531ea2b495f387e66ac05ca0ea767318f4b'} = 1;
    $dict->{'search_template'}{'Search Results Template'}{'bae89f413f82176ef9af7e2de4035aae197d2fe6'} = 1;
    $dict->{'search_template'}{'Search Results Template'}{'bc37bab9d99f67c53526897784b51c0fdcace5e5'} = 1;
    $dict->{'comment_pending'}{'Comment Pending Template'}{'203c19dc815ee2a569e999ffe45c9d181938c7e8'} = 1;
    $dict->{'comment_pending'}{'Comment Pending Template'}{'45623af81ada62e96da3a0250677a2a9eb89165a'} = 1;
    $dict->{'comment_pending'}{'Comment Pending Template'}{'af1b078b411608c1624479f9fef21bf23e7035aa'} = 1;
    $dict->{'comment_pending'}{'Comment Pending Template'}{'b0a9c1e1fdb222415252334fc806b1e9cd1e9cd4'} = 1;
    $dict->{'comment_pending'}{'Comment Pending Template'}{'bc45c2305e3dd8980369e30d9b26a6a04a01e439'} = 1;
    $dict->{'comment_pending'}{'Comment Pending Template'}{'e7489716f8a2b0a3858337a37ae8836394f690fd'} = 1;
    $dict->{'comment_error'}{'Comment Error Template'}{'5b5ded6c4513c91cd7cd864c7a652a4dc2a87558'} = 1;
    $dict->{'comment_error'}{'Comment Error Template'}{'a8d3a908dca1d038a2dc8904628d76aa94a289a1'} = 1;
    $dict->{'comment_error'}{'Comment Error Template'}{'b836e718fa1241b2ef68b7da8cfa2fa3918f2dae'} = 1;
    $dict->{'comment_error'}{'Comment Error Template'}{'d742280800194d70a9dc5dc72c774183e5566e32'} = 1;
    $dict->{'comment_error'}{'Comment Error Template'}{'ed3c39c66bb65883520844671d17ba19d408e28c'} = 1;
    $dict->{'comment_error'}{'Comment Error Template'}{'f11e4ab182d6f9d0a0ddeb002e7d84a3296ad9f8'} = 1;
    $dict->{'popup_image'}{'Uploaded Image Popup Template'}{'f159c35e14a46fe206bf8907bffbb16447cad15c'} = 1;
    $dict->{'comments'}{'Comment Listing Template'}{'da39a3ee5e6b4b0d3255bfef95601890afd80709'} = 1;
    $dict->{'dynamic_error'}{'Dynamic Pages Error Template'}{'67f321198052295b9c7090a843a7dd39e1856b5c'} = 1;
    $dict->{'dynamic_error'}{'Dynamic Pages Error Template'}{'74f785030fee43e54aec17495a0d668b32d04400'} = 1;
    $dict->{'dynamic_error'}{'Dynamic Pages Error Template'}{'8263c276766334f5ade678c814c7bc2705e60094'} = 1;
    $dict->{'dynamic_error'}{'Dynamic Pages Error Template'}{'9cf7a4087e15af2c97513d96bc0645c50bb7988c'} = 1;
    $dict->{'dynamic_error'}{'Dynamic Pages Error Template'}{'be2e380cc8806fe7d28722f2edab1b01c5a2e7eb'} = 1;
    $dict->{'dynamic_error'}{'Dynamic Pages Error Template'}{'beb0de4c18f4ccb7c96d0fa8a20443b89fd561e5'} = 1;
    $dict->{'index'}{'Stylesheet'}{'d27b1454b8300141315d1151fce877b305c39c84'} = 1;
    $dict->{'archive'}{'Date-Based Archive'}{'2143b314f58124bf77244ebf84091a3ce6af2139'} = 1;
    $dict->{'archive'}{'Date-Based Archive'}{'4ee5fcb51a26ce600a01a5a03c7d186669ee77db'} = 1;
    $dict->{'archive'}{'Date-Based Archive'}{'a80b7f056ad684dd58f43b4b48118384ba02e282'} = 1;
    $dict->{'archive'}{'Date-Based Archive'}{'bd160389f58d0ecac3cf1ead0f512a69fa7ea866'} = 1;
    $dict->{'archive'}{'Date-Based Archive'}{'e3914933ce528c588bc901932a02738e87fb7d7e'} = 1;
    $dict->{'archive'}{'Date-Based Archive'}{'fb0ce9af3f9918dcab128e346a0fbb6771550d07'} = 1;
    $dict->{'category'}{'Category Archive'}{'6f4f50d8c86a7dfb2e00866b0ccc0bd6a70d3c6b'} = 1;
    $dict->{'category'}{'Category Archive'}{'72d2be988cab822e955568810b7157d20eacb03a'} = 1;
    $dict->{'category'}{'Category Archive'}{'9487ba109bb2371a2d99fe5c8a0c53e1f61dc34f'} = 1;
    $dict->{'category'}{'Category Archive'}{'d2a476d700d3cdee1b810e47f99202cf84b6fa57'} = 1;
    $dict->{'category'}{'Category Archive'}{'dc923b61b77bf3f18a0cf459fc32bdc00be50e14'} = 1;
    $dict->{'category'}{'Category Archive'}{'f6c9ad614f4e7ffd17e4e23477e2cfbd77ca190c'} = 1;
    $dict->{'individual'}{'Individual Entry Archive'}{'123c98313ae62f3f343c4b12fe1e715ad0296c58'} = 1;
    $dict->{'individual'}{'Individual Entry Archive'}{'5925f800791fcdd03e99f20af1e557ab8ce849fa'} = 1;
    $dict->{'individual'}{'Individual Entry Archive'}{'6cec4aa05733f0ea3b3f5e91fa15c98d65b62622'} = 1;
    $dict->{'individual'}{'Individual Entry Archive'}{'db77b0d9164a007170995b7970312fa587518ba5'} = 1;
    $dict->{'individual'}{'Individual Entry Archive'}{'e357cef68ef7f0e7453bc89aaa35a6d2bea5de4a'} = 1;
    $dict->{'individual'}{'Individual Entry Archive'}{'edd4a1b58f6ff9ad6a545e5990cb4c63c20c2d51'} = 1;
    $dict->{'pings'}{'TrackBack Listing Template'}{'2413900dd7bab6a9f343b3928e87b0e9a002e51f'} = 1;
    $dict->{'pings'}{'TrackBack Listing Template'}{'37447d36ad1b21412dbbca4e65e1ab9dd3fc568d'} = 1;
    $dict->{'pings'}{'TrackBack Listing Template'}{'467445a45144ab4693afe5dfb9afd2227d030096'} = 1;
    $dict->{'pings'}{'TrackBack Listing Template'}{'6091982a5937c8f195fa9f7a088257422b541401'} = 1;
    $dict->{'pings'}{'TrackBack Listing Template'}{'976b0a3ab1150ea819179e2142cfa26f04ddeef6'} = 1;
    $dict->{'pings'}{'TrackBack Listing Template'}{'ed00503cfdad65bc0dc6052dcec65156c28e70f5'} = 1;
    $dict->{'index'}{'Site JavaScript'}{'1c376f4fd213e5434ac8a604535817a338f4ce51'} = 1;
    $dict->{'index'}{'Site JavaScript'}{'50afbfdef7823ab5b79f10c0127b18b995b8b07c'} = 1;
    $dict->{'index'}{'Site JavaScript'}{'690680f572521bf47d1e25295c23b05f4212de5c'} = 1;
    $dict->{'index'}{'Site JavaScript'}{'b2292561b588e527260b82939b52b19ede801632'} = 1;
    $dict->{'index'}{'Site JavaScript'}{'bf4420283b317eb92f7a9e2118c6ee6838bfc8ab'} = 1;
    $dict->{'index'}{'Site JavaScript'}{'cf6e064a86b907f1baef6ec5880feb1617e64390'} = 1;

    # 4.0
    $dict->{'index'}{'Stylesheet - Base Theme'}{'6dc75f7583da67feca8b5629221e07fa8e8eccb4'} = 1;
    $dict->{'index'}{'Archive Index'}{'039512be33ee18fa182f0879ad03650ccf270acd'} = 1;
    $dict->{'index'}{'Archive Index'}{'2bc06b2d6b486eb825605f609c739f9524621aa0'} = 1;
    $dict->{'index'}{'Archive Index'}{'6489dd9c8b7cfcf1bebf4f409d313124128de79b'} = 1;
    $dict->{'index'}{'Archive Index'}{'655a5e68a2911c721b2aea24db5b8ade35e9b8a3'} = 1;
    $dict->{'index'}{'Archive Index'}{'6cd685f6371e8011171c95176f80db929c1a79d4'} = 1;
    $dict->{'index'}{'Archive Index'}{'8aead6eaa6e45ca8ee0b491328d9e4d20760d263'} = 1;
    $dict->{'index'}{'Main Index'}{'1d3ea8f59b7e2d36bebd4cdb8ed4556343d732b1'} = 1;
    $dict->{'index'}{'Main Index'}{'73ac8a4824a68e96c5ff11c574747033ff3789bd'} = 1;
    $dict->{'index'}{'Main Index'}{'7c2a29b1c91376b2a34d166ff2ba169ce7e05d59'} = 1;
    $dict->{'index'}{'Main Index'}{'8ff1c6e7a8a1d160fabcb955d8c30d850ebe3486'} = 1;
    $dict->{'index'}{'Main Index'}{'c8e0a4fe2d63a06b94416a08c6c91d0d8b314f77'} = 1;
    $dict->{'index'}{'Main Index'}{'f61319d94abd074ce93ad2bb5d9ffceb6d7f2696'} = 1;
    $dict->{'index'}{'Stylesheet - Main'}{'185c9e87222707452bf5cbfcdcf2f3317c2e5786'} = 1;
    $dict->{'index'}{'JavaScript'}{'27d7424aae0f9d438a4aa449692f2f9b9762ded7'} = 1;
    $dict->{'index'}{'JavaScript'}{'49cde74f0015b63179dccb75562dac12321ed81e'} = 1;
    $dict->{'index'}{'JavaScript'}{'50b9c9ec8611dbc5931d0d53c0abe7ea069a080b'} = 1;
    $dict->{'index'}{'JavaScript'}{'66bafef1f9264b7106a46dfe0fd4aa673fe0629b'} = 1;
    $dict->{'index'}{'JavaScript'}{'e0b2b2c90fed80071ea609c9fd2c53336177965e'} = 1;
    $dict->{'index'}{'JavaScript'}{'eeb67a8450bd65be1e58d969d5265036e59b5ac3'} = 1;
    $dict->{'index'}{'RSD'}{'ff390cfb6e179278ed90ed19c46980046cc6ca98'} = 1;
    $dict->{'index'}{'Atom'}{'2bcd3aa274be4c7abe7c65e361a223337de122bc'} = 1;
    $dict->{'index'}{'RSS'}{'d274afe47539eb8cf0a031ff8475f5d8b13d764c'} = 1;
    $dict->{'page'}{'Page'}{'160e6907f7d9ddac0cff2c90b498fc9afdff8e75'} = 1;
    $dict->{'page'}{'Page'}{'2f88c6aca27b5063b57f229dbc5a10214f770ece'} = 1;
    $dict->{'page'}{'Page'}{'3acac2bdbc3054b8fd604d7c684b0d84f47e9ee8'} = 1;
    $dict->{'page'}{'Page'}{'a857abd7aa06eb4f51370f0199d1cea8916da83c'} = 1;
    $dict->{'page'}{'Page'}{'cf7b37c9dc2068455438783ae7e38ab59d698b81'} = 1;
    $dict->{'page'}{'Page'}{'f7c4b6076bda24ac4408158c98b67cbca97142ec'} = 1;
    $dict->{'archive'}{'Entry Listing'}{'243f1a201f4708a7ea7e7687710bd25c6f8309b3'} = 1;
    $dict->{'archive'}{'Entry Listing'}{'48ca63f1ffcc425c2a68ecda295998297e8b426b'} = 1;
    $dict->{'archive'}{'Entry Listing'}{'6f41be7fc62b57cfcd02cd203f20a58b5d10f0b3'} = 1;
    $dict->{'archive'}{'Entry Listing'}{'acdfc4a5e0b560096da40c03e257b831627294c7'} = 1;
    $dict->{'archive'}{'Entry Listing'}{'c88ec9df7187c7665f5d5e045e3e07fdda1f53c9'} = 1;
    $dict->{'archive'}{'Entry Listing'}{'dfa8e41948fe37f4c0cca8a4ae15f1eef48b739c'} = 1;
    $dict->{'comment_response'}{'Comment Response'}{'56984390ab02d25a40885084b40eedb384eb7209'} = 1;
    $dict->{'comment_response'}{'Comment Response'}{'6111cfae25386777020686ba09a16e318aa91e39'} = 1;
    $dict->{'comment_response'}{'Comment Response'}{'7a0f7d92dce2699cf106a61e3f7ede5491b2005a'} = 1;
    $dict->{'comment_response'}{'Comment Response'}{'c6b14674541372b7bc23462a58f5013284e6e20e'} = 1;
    $dict->{'comment_response'}{'Comment Response'}{'c7c744b30671a65b40e39368adae730b6a3b64e3'} = 1;
    $dict->{'comment_response'}{'Comment Response'}{'f9d96e36c3a64dcb8e56415e8b3a4a7958cf7ebb'} = 1;
    $dict->{'popup_image'}{'Popup Image'}{'87a21a86b05d756cb141f046d973f953fe23dec5'} = 1;
    $dict->{'dynamic_error'}{'Dynamic Error'}{'2a692dafb4af80d9f15e783cffc1b2fb48296721'} = 1;
    $dict->{'dynamic_error'}{'Dynamic Error'}{'6ef9701b7ad03c9bf71b5e0b46c65a2c7cdf2937'} = 1;
    $dict->{'dynamic_error'}{'Dynamic Error'}{'72c4e25b8bbe84d311423740ccad95aa7e4378dd'} = 1;
    $dict->{'dynamic_error'}{'Dynamic Error'}{'76a63d76c9203e6f5911649a2e7f78d85e162b03'} = 1;
    $dict->{'dynamic_error'}{'Dynamic Error'}{'76b9ff237838985b576e633171de2f1a6629f5ae'} = 1;
    $dict->{'dynamic_error'}{'Dynamic Error'}{'b668c4c2657cbab512488b40c2d1a0bdf1450782'} = 1;
    $dict->{'comment_preview'}{'Comment Preview'}{'304a4d8df01501df59ed9745e765b2fe7a278b13'} = 1;
    $dict->{'comment_preview'}{'Comment Preview'}{'69da3c031d3404dc06c0c13ccffea0e63e156691'} = 1;
    $dict->{'comment_preview'}{'Comment Preview'}{'73b80267069e6fde0a363b71bab1bc12b5d39a28'} = 1;
    $dict->{'comment_preview'}{'Comment Preview'}{'a26a7b610fd739fc466f37bc05e1c1a4499ce783'} = 1;
    $dict->{'comment_preview'}{'Comment Preview'}{'d48b25e9b59ba5f9752aab7a88201a3108609ed2'} = 1;
    $dict->{'comment_preview'}{'Comment Preview'}{'da15e8deb39c8932a6f5097e7ffb837f7d9294a6'} = 1;
    $dict->{'search_results'}{'Search Results'}{'223d1f7a61284aa9a7569f62b2553bc34727169c'} = 1;
    $dict->{'search_results'}{'Search Results'}{'22c3dd3d7578a961c16870263d5cc3b688dadfc0'} = 1;
    $dict->{'search_results'}{'Search Results'}{'6a13955e9fec8e0bc1e1b99de61000f3570e36f9'} = 1;
    $dict->{'search_results'}{'Search Results'}{'87b019a8d423f485715688e158ff517106ce0769'} = 1;
    $dict->{'search_results'}{'Search Results'}{'a216ece3a802853dbecac2a66ac73d59084d68a6'} = 1;
    $dict->{'search_results'}{'Search Results'}{'e0e8554afdc0c8c6d3a93781d8a821a6b925a8cf'} = 1;
    $dict->{'individual'}{'Entry'}{'1fc23da172c523b2f1b8a725736f477e80a963d6'} = 1;
    $dict->{'individual'}{'Entry'}{'25eb1c94d618988f398fce464ee8d5e43c8703c9'} = 1;
    $dict->{'individual'}{'Entry'}{'31666509bad21f049ed74a10f8ae167b4a531ef8'} = 1;
    $dict->{'individual'}{'Entry'}{'5063cbb3cefe2df05da735d01d1b53937a0a200d'} = 1;
    $dict->{'individual'}{'Entry'}{'d4359c0bcca4cefd6cdcf943b07d30b8b9b6bcde'} = 1;
    $dict->{'individual'}{'Entry'}{'f12724aa1c415e000193f3751bfa37b2941a7a00'} = 1;
    $dict->{'custom'}{'Comment Detail'}{'38d29ed5aefae83cab210bdae703030a7b1f21d7'} = 1;
    $dict->{'custom'}{'Comment Detail'}{'43a32f584fb16845997587e849ad61d33ec82159'} = 1;
    $dict->{'custom'}{'Comment Detail'}{'b57d3f1ea05cbb8d76803c8d2d616b8155edacb3'} = 1;
    $dict->{'custom'}{'Comment Detail'}{'bd2133701d86a50411074a7fc7e7931f4ace6991'} = 1;
    $dict->{'custom'}{'Comment Detail'}{'e1504391358f0d5d3714531d50d18de92a5c167a'} = 1;
    $dict->{'custom'}{'Comment Detail'}{'e9fcfb00bb0d416b1ce15fa104fd3c4e3779c5ad'} = 1;
    $dict->{'custom'}{'Entry Summary'}{'09e1f1862d9f4051de367fd48caf4b66e4b6557a'} = 1;
    $dict->{'custom'}{'Entry Summary'}{'302d4f247f3004759a0d7b7501a73f63da771986'} = 1;
    $dict->{'custom'}{'Entry Summary'}{'4ab82e7acdb356e8890b6cb62158beef88a6bf94'} = 1;
    $dict->{'custom'}{'Entry Summary'}{'a64375898788a28fc910f8438d4994cde34616be'} = 1;
    $dict->{'custom'}{'Entry Summary'}{'af26bf0a2192fc3f5a8640963edf2f96fc649785'} = 1;
    $dict->{'custom'}{'Entry Summary'}{'b143c353314910205587f9cf47f53f98e8371f2f'} = 1;
    $dict->{'custom'}{'Sidebar - 3 Column Layout'}{'36bef04d182c841ffa909043a4fb05f73cf4d5d6'} = 1;
    $dict->{'custom'}{'Sidebar - 3 Column Layout'}{'499bebba5de29a7f8116e2cba4ae7e006e5e673b'} = 1;
    $dict->{'custom'}{'Sidebar - 3 Column Layout'}{'69e5406c21f1ff906804a0b70a3dcc2d582d1da0'} = 1;
    $dict->{'custom'}{'Sidebar - 3 Column Layout'}{'c1c87672f88bf9eba6b2573bede6d5a877632630'} = 1;
    $dict->{'custom'}{'Sidebar - 3 Column Layout'}{'e489e027aa31451a40fdac56b33e5a21b15c8359'} = 1;
    $dict->{'custom'}{'Sidebar - 3 Column Layout'}{'f894bfe67f553c9e9f37fc327c3ef2b48bcc2b82'} = 1;
    $dict->{'custom'}{'Categories'}{'429decb5434919dd4b0741f7a9a38e0c4f0f1948'} = 1;
    $dict->{'custom'}{'Categories'}{'5ab8e1525ceaa69cbdbc74c6e9d34755586c04e9'} = 1;
    $dict->{'custom'}{'Categories'}{'6f8efadf93acf1ebf4549601d860a3fc261558ca'} = 1;
    $dict->{'custom'}{'Categories'}{'9d7c8b52967df0bfff09c8c1c4e92f42b2a6e330'} = 1;
    $dict->{'custom'}{'Categories'}{'9eda4d3ab80e53d333f20336783e7db65eaa2459'} = 1;
    $dict->{'custom'}{'Categories'}{'ccfb69c532935071a500c0abc4c2a9ce48997e78'} = 1;
    $dict->{'custom'}{'Comments'}{'19370c7987e054d18de2ec5a9a766dc08aa1a67c'} = 1;
    $dict->{'custom'}{'Comments'}{'4506a999249d86cdbe055c595672b4ba526d5a59'} = 1;
    $dict->{'custom'}{'Comments'}{'5389e0b035787064bb391529fd347687ba4bf1ea'} = 1;
    $dict->{'custom'}{'Comments'}{'7253947a77727204a19b1518e641144226e7aea6'} = 1;
    $dict->{'custom'}{'Comments'}{'d04f934e9d7d180a1eff56ac3be33656922d0357'} = 1;
    $dict->{'custom'}{'Comments'}{'defa1328a5b233b36c1a01bc21bf8d065a5ad297'} = 1;
    $dict->{'custom'}{'Footer'}{'2e54bc21d660e432521dd22c00633ff3fc166898'} = 1;
    $dict->{'custom'}{'Footer'}{'9052e4b2059496aa09aeb375c2c916ecd644a28c'} = 1;
    $dict->{'custom'}{'Footer'}{'97d6b5d81b0d68e6029a2c4e45cf646585c1d4d2'} = 1;
    $dict->{'custom'}{'Footer'}{'a114285d81cd9fa7c639203da097a92d75fb4d66'} = 1;
    $dict->{'custom'}{'Footer'}{'b4d43e2038ad773a9647fbfef93b33aea1374c81'} = 1;
    $dict->{'custom'}{'Footer'}{'ef14321148f650dcc1c5b49fc54b22fd3e48f47e'} = 1;
    $dict->{'custom'}{'Tags'}{'3f7dd7f2a0ece8ca8f1075ca2e9db3c2eee2cbb9'} = 1;
    $dict->{'custom'}{'Tags'}{'4ed82e88baf781481e76406ac464ed548df9bee6'} = 1;
    $dict->{'custom'}{'Tags'}{'7f78fa54a4f50625d91c3e771c0ed58ef4202884'} = 1;
    $dict->{'custom'}{'Sidebar - 2 Column Layout'}{'13f23427d80bae301db47dbd5d5cfd640b84c639'} = 1;
    $dict->{'custom'}{'Sidebar - 2 Column Layout'}{'5be399dc59bf8f0ebfb19c43f496d695bea386ba'} = 1;
    $dict->{'custom'}{'Sidebar - 2 Column Layout'}{'5d0f713aa4527bf4a7c566bff6ce88373d411111'} = 1;
    $dict->{'custom'}{'Sidebar - 2 Column Layout'}{'5e3e11885a913203a120f130770daff4310bbcbd'} = 1;
    $dict->{'custom'}{'Sidebar - 2 Column Layout'}{'aadae3758910070228664f80c348d8b6f90215e4'} = 1;
    $dict->{'custom'}{'Sidebar - 2 Column Layout'}{'f2055abccf5d76eb76150a0a58bc13193e8a279a'} = 1;
    $dict->{'custom'}{'Entry Metadata'}{'1b154e786cdb6aa58300568e4541da7b56c54226'} = 1;
    $dict->{'custom'}{'Entry Metadata'}{'34980120b9c39d412b9cec7b4ac3a8e6ad0455c9'} = 1;
    $dict->{'custom'}{'Entry Metadata'}{'495e7827186a8046d8a06c477d269ae4dac9bda0'} = 1;
    $dict->{'custom'}{'Entry Metadata'}{'4f437942a6321ca845ee8f1a1081ce7a11b45198'} = 1;
    $dict->{'custom'}{'Entry Metadata'}{'5bb05a29784ee787e010aa064de8fa9da794612c'} = 1;
    $dict->{'custom'}{'Entry Metadata'}{'7075b36e8ae4373d95506b511b9493dac6a27652'} = 1;
    $dict->{'custom'}{'TrackBacks'}{'1bcabaa34cffac08439c5e24f6b7b22d9ba827a5'} = 1;
    $dict->{'custom'}{'TrackBacks'}{'81dd701c1a2d4162ca1ed90bd384bd1fe48c3fce'} = 1;
    $dict->{'custom'}{'TrackBacks'}{'a1b00512dcb4a8ee3f75f6a6e76a70c9631e94ea'} = 1;
    $dict->{'custom'}{'TrackBacks'}{'a28f6e18e5e74052bc2c75f71767501a917b6899'} = 1;
    $dict->{'custom'}{'TrackBacks'}{'b51c8baeb24a5d36f7374211a1808d8887e00866'} = 1;
    $dict->{'custom'}{'TrackBacks'}{'f7d79e53f9f7dd9a5e57612a86b410d009a4e0b8'} = 1;
    $dict->{'custom'}{'Comment Form'}{'10529a62967a195876e3338569f6c9f207a509cd'} = 1;
    $dict->{'custom'}{'Comment Form'}{'25eddc9af819bcebccba4d13f8d021ef613f9b92'} = 1;
    $dict->{'custom'}{'Comment Form'}{'3901256baf25db2425a3f63cc96fc9ed1edd131b'} = 1;
    $dict->{'custom'}{'Comment Form'}{'42e36255ce0a7a97b0e2287f45fd3b34265f4e52'} = 1;
    $dict->{'custom'}{'Comment Form'}{'4f2233c3120cf6b047dcb0d0a2d33990da36f4ec'} = 1;
    $dict->{'custom'}{'Comment Form'}{'c018255fcdd9d6b003f25e14563b7662e50b6f57'} = 1;
    $dict->{'custom'}{'Page Detail'}{'2dd109646ccbeb5b0ba200273a7ab0ebbef5984d'} = 1;
    $dict->{'custom'}{'Header'}{'3f9bd6268984e0f48c64cec7cb96630e642b21fb'} = 1;
    $dict->{'custom'}{'Header'}{'61346944cf1292b7cc12c2468f65c85e40853976'} = 1;
    $dict->{'custom'}{'Header'}{'793262104aa29a745846d918ba0d63029d97cadf'} = 1;
    $dict->{'custom'}{'Header'}{'80d4947b6bbd0a7d1138193a90b14a00e11f20c5'} = 1;
    $dict->{'custom'}{'Header'}{'b0a29c8887089d39c113dde8499569b9e8441e87'} = 1;
    $dict->{'custom'}{'Header'}{'c931187ce1bd794c39ee19eeef4ec9dffee87640'} = 1;
    $dict->{'custom'}{'Entry Detail'}{'0390a5bffc514d6638da0db59f55ea6af07d0dc6'} = 1;
    $dict->{'custom'}{'Entry Detail'}{'79dfd8472ae891368dcafd3913a73955f14e1939'} = 1;
    $dict->{'custom'}{'Entry Detail'}{'be3ca7941a56dea5262f76ad32b5b03df3fd1232'} = 1;
    $dict->{'custom'}{'Entry Detail'}{'ccf9cb07d69c3ddc56b17436fa694bcaf5ee1ae7'} = 1;
    $dict->{'custom'}{'Entry Detail'}{'f1bbe7ecaaa2c538fd58a3fd9fc5d57156fb0d53'} = 1;
    $dict->{'custom'}{'Entry Detail'}{'fdf3df399009d7e4175735b2ea22840a7605383e'} = 1;
    ];

    $dict;
}

sub default_templates {
    my $app = shift;

    require MT::DefaultTemplates;
    my $tmpl_list = MT::DefaultTemplates->templates(@_);
    return $app->error( $app->translate("Error loading default templates.") )
      unless $tmpl_list;

    eval {
        my $widgetmgr = MT::Plugin::WidgetManager->instance;
        my $widget_tmpls = $widgetmgr->templates($app);
        push @$tmpl_list, @$widget_tmpls;
    };

    $tmpl_list;
}

sub refresh_all_templates {
    my $plugin = shift;
    my ($app) = @_;

    my $backup = 1;
    if ($app->param('no_backup')) {
        $backup = 0;
    }

    my $t = time;

    my @id;
    if ($app->param('blog_id')) {
        @id = ( scalar $app->param('blog_id') );
    }
    else {
        @id = $app->param('id');
        if (! @id) {
            # refresh global templates
            @id = ( 0 );
        }
    }

    require MT::Template;

    # logic:
    #    process scope of templates...

    #    load default templates:
    my $dict = default_dictionary();

    my @msg;
    require MT::Blog;
    require MT::Permission;
    require MT::Util;

    foreach my $blog_id (@id) {
        my $blog;
        if ($blog_id) {
            $blog = MT::Blog->load($blog_id);
            next unless $blog;
        }
        if ( !$app->{author}->is_superuser() ) {
            my $perms = MT::Permission->load(
                { blog_id => $blog_id, author_id => $app->{author}->id } );
            if (
                !$perms
                || (   !$perms->can_edit_templates()
                    && !$perms->can_administer_blog() )
              )
            {
                push @msg,
                  $app->translate(
"Insufficient permissions to modify templates for blog '[_1]'",
                    $blog->name()
                  );
                next;
            }
        }

        my $tmpl_list;
        if ($blog_id) {
            push @msg,
              $app->translate( "Processing templates for blog '[_1]'",
                $blog->name );
            $tmpl_list = default_templates($app, $blog->template_set)
                or default_templates($app);
        }
        else {
            push @msg,
              $app->translate( "Processing global templates" );
            $tmpl_list = default_templates($app);
        }

        foreach my $val (@$tmpl_list) {
            if ($blog_id) {
                # when refreshing blog templates,
                # skip over global templates which
                # specify a blog_id of 0...
                next if $val->{global};
            }
            else {
                next unless exists $val->{global};
            }

            if ( !$val->{orig_name} ) {
                $val->{orig_name} = $val->{name};
                $val->{name}      = $app->translate( $val->{name} );
                $val->{text}      = $app->translate_templatized( $val->{text} );
            }

            my $orig_name = $val->{orig_name};

            my @ts = MT::Util::offset_time_list( $t, ( $blog_id ? $blog_id : undef ) );
            my $ts = sprintf "%04d-%02d-%02d %02d:%02d:%02d", $ts[5] + 1900,
              $ts[4] + 1, @ts[ 3, 2, 1, 0 ];

            my $terms = {};
            $terms->{blog_id} = $blog_id;
            if ( $val->{type} =~
                m/^(archive|individual|page|category|index|custom|widget)$/ )
            {
                $terms->{name} = $val->{name};
            }
            else {
                $terms->{type} = $val->{type};
            }

            # this should only return 1 template; we're searching
            # within a given blog for a specific type of template (for
            # "system" templates; or for a type + name, which should be
            # unique for that blog.
            my $tmpl = MT::Template->load($terms);
            if ($tmpl && $backup) {

                # check for default template text...
                # if it is a default template, then outright replace it
                my $text = $tmpl->text;
                $text =~ s/\s+//g;

                # generate sha1 of $text
                my $digest = MT::Util::perl_sha1_digest_hex($text);
                if ( !$dict->{ $val->{type} }{$orig_name}{$digest} ) {

                    # if it has been customized, back it up to a new tmpl record
                    my $backup = $tmpl->clone;
                    delete $backup->{column_values}
                      ->{id};    # make sure we don't overwrite original
                    delete $backup->{changed_cols}->{id};
                    $backup->name(
                        $backup->name . ' (Backup from ' . $ts . ')' );
                    if ( $backup->type !~
                        m/^(archive|individual|page|category|index|custom|widget)$/ )
                    {
                        $backup->type('custom')
                          ;      # system templates can't be created
                    }
                    $backup->outfile('');
                    $backup->linked_file( $tmpl->linked_file );
                    $backup->identifier(undef);
                    $backup->rebuild_me(0);
                    $backup->build_dynamic(0);
                    $backup->save;
                    push @msg,
                      $app->translate(
'Refreshing template <strong>[_3]</strong> with <a href="?__mode=view[_1]&amp;_type=template&amp;id=[_2]">backup</a>',
                        ( $blog_id ? "&amp;blog_id=" . $blog_id : '' ), $backup->id, $tmpl->name );
                }
            }
            if ($tmpl) {
                if (!$backup) {
                    push @msg,
                      $app->translate( "Refreshing template '[_1]'.",
                        $tmpl->name );
                }
                # we found that the previous template had not been
                # altered, so replace it with new default template...
                $tmpl->text( $val->{text} );
                $tmpl->identifier( $val->{identifier} );
                $tmpl->type( $val->{type} )
                  ; # fixes mismatch of types for cases like "archive" => "individual"
                $tmpl->linked_file('');
                $tmpl->save;
            }
            else {
                # create this one...
                my $tmpl = new MT::Template;
                $tmpl->build_dynamic(0);
                $tmpl->set_values(
                    {
                        text       => $val->{text},
                        name       => $val->{name},
                        type       => $val->{type},
                        identifier => $val->{identifier},
                        outfile    => $val->{outfile},
                        rebuild_me => $val->{rebuild_me}
                    }
                );
                $tmpl->blog_id($blog_id);
                $tmpl->save
                  or return $app->error(
                        $app->translate("Error creating new template: ")
                      . $tmpl->errstr );
                push @msg,
                  $app->translate( "Created template '[_1]'.", $tmpl->name );
            }
        }
    }
    my @msg_loop;
    push @msg_loop, { message => $_ } foreach @msg;

    $app->param('__mode', '');
    $app->mode('');
    $app->build_page( $plugin->load_tmpl('results.tmpl'),
        { message_loop => \@msg_loop, return_url => $app->return_uri, plugin_name => $plugin->name } );
}

sub refresh_individual_templates {
    my $plugin = shift;
    my ($app) = @_;

    require MT::Util;

    my $perms = $app->{perms};
    return $app->error(
        $app->translate(
            "Insufficient permissions for modifying templates for this weblog.")
      )
      #TODO: system level-designer permission
      unless $app->{author}->is_superuser()
      || ( $perms
        && ( $perms->can_edit_templates()
          || $perms->can_administer_blog ) );

    my $dict = default_dictionary();

    my $set;
    if ( my $blog_id = $app->param('blog_id') ) {
        my $blog = $app->model('blog')->load($blog_id);
        $set = $blog->template_set()
            if $blog;
    }
    
    my $tmpl_list = default_templates($app, $set) or return;

    my $trnames    = {};
    my $tmpl_types = {};
    my $tmpls      = {};
    foreach my $tmpl (@$tmpl_list) {
        $tmpl->{text} = $app->translate_templatized( $tmpl->{text} );
        $trnames->{ $app->translate( $tmpl->{name} ) } = $tmpl->{name};
        if ( $tmpl->{type} !~ m/^(archive|individual|page|category|index|custom|widget)$/ )
        {
            $tmpl_types->{ $tmpl->{type} } = $tmpl;
        }
        else {
            $tmpls->{ $tmpl->{type} }{ $tmpl->{name} } = $tmpl;
        }
    }

    my $t = time;

    my @msg;
    my @id = $app->param('id');
    require MT::Template;
    foreach my $tmpl_id (@id) {
        my $tmpl = MT::Template->load($tmpl_id);
        next unless $tmpl;
        my $blog_id = $tmpl->blog_id;

        # FIXME: permission check -- for this blog_id

        my @ts = MT::Util::offset_time_list( $t, $blog_id );
        my $ts = sprintf "%04d-%02d-%02d %02d:%02d:%02d", $ts[5] + 1900,
          $ts[4] + 1, @ts[ 3, 2, 1, 0 ];

        my $orig_name = $trnames->{ $tmpl->name } || $tmpl->name;
        my $val = $tmpl_types->{ $tmpl->type() }
          || $tmpls->{ $tmpl->type() }{$orig_name};
        if ( !$val ) {
            push @msg,
              $app->translate(
"Skipping template '[_1]' since it appears to be a custom template.",
                $tmpl->name
              );
            next;
        }

        my $text = $tmpl->text;
        $text =~ s/\s+//g;

        # generate sha1 of $text
        my $digest = MT::Util::perl_sha1_digest_hex($text);
        if ( !$dict->{ $tmpl->type }{$orig_name}{$digest} ) {

            # if it has been customized, back it up to a new tmpl record
            my $backup = $tmpl->clone;
            delete $backup->{column_values}
              ->{id};    # make sure we don't overwrite original
            delete $backup->{changed_cols}->{id};
            $backup->name( $backup->name . ' (Backup from ' . $ts . ')' );
            if ( $backup->type !~
                m/^(archive|individual|page|category|index|custom|widget)$/ )
            {
                $backup->type('custom');    # system templates can't be created
            }
            $backup->outfile('');
            $backup->linked_file( $tmpl->linked_file );
            $backup->rebuild_me(0);
            $backup->build_dynamic(0);
            $backup->identifier(undef);
            $backup->save;
            push @msg,
              $app->translate(
'Refreshing template <strong>[_3]</strong> with <a href="?__mode=view&amp;blog_id=[_1]&amp;_type=template&amp;id=[_2]">backup</a>',
                  $blog_id, $backup->id, $tmpl->name );
        }
        else {
            push @msg,
              $app->translate( "Refreshing template '[_1]'.", $tmpl->name );
        }

        # we found that the previous template had not been
        # altered, so replace it with new default template...
        $tmpl->text( $val->{text} );
        $tmpl->identifier( $val->{identifier} );
        $tmpl->linked_file('');
        $tmpl->save;
    }
    my @msg_loop;
    push @msg_loop, { message => $_ } foreach @msg;

    $app->build_page( $plugin->load_tmpl('results.tmpl'),
        { message_loop => \@msg_loop, return_url => $app->return_uri, plugin_name => $plugin->name } );
}

1;
