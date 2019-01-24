BUILD_LANGUAGE ?= en_US
BUILD_PACKAGE ?= MTOS

-include build/mt-dists/default.mk
-include build/mt-dists/$(BUILD_PACKAGE).mk
-include build/mt-dists/$(BUILD_LANGUAGE).mk

BUILD_VERSION_ID ?= $(PRODUCT_VERSION)

local_js = mt-static/mt_en_us.js \
        mt-static/mt_de.js \
        mt-static/mt_fr.js \
        mt-static/mt_nl.js \
        mt-static/mt_ja.js \
        mt-static/mt_es.js

core_js = mt-static/js/common/Core.js \
          mt-static/js/common/JSON.js \
          mt-static/js/common/Timer.js \
          mt-static/js/common/Cookie.js \
          mt-static/js/common/DOM.js \
          mt-static/js/common/Observable.js \
          mt-static/js/common/Autolayout.js \
          mt-static/js/common/Component.js \
          mt-static/js/common/List.js \
          mt-static/js/common/App.js \
          mt-static/js/common/Cache.js \
          mt-static/js/common/Client.js \
          mt-static/js/common/Template.js \
          mt-static/js/tc.js \
          mt-static/js/tc/tableselect.js

editor_js = mt-static/js/editor/editor_manager.js \
          mt-static/js/editor/editor_command.js \
          mt-static/js/editor/editor_command/wysiwyg.js \
          mt-static/js/editor/editor_command/source.js \
          mt-static/js/editor/app.js \
          mt-static/js/editor/editor.js \
          mt-static/js/editor/app/editor_strategy.js \
          mt-static/js/editor/app/editor_strategy/single.js \
          mt-static/js/editor/app/editor_strategy/multi.js \
          mt-static/js/editor/app/editor_strategy/separator.js \
          mt-static/js/editor/editor/source.js

jquery_js = mt-static/jquery/jquery.mt.js

tinymce_plugin_mt_js = mt-static/plugins/TinyMCE/tiny_mce/plugins/mt/plugin.js

tinymce_plugin_mt_fullscreen_js = mt-static/plugins/TinyMCE/tiny_mce/plugins/mt_fullscreen/plugin.js

main_css = mt-static/css/reset.css \
	mt-static/css/structure.css \
	mt-static/css/form.css \
	mt-static/css/listing.css \
	mt-static/css/sortable.css \
	mt-static/css/dialog.css \
	mt-static/css/messaging.css \
	mt-static/css/utilities.css \
	mt-static/css/icons.css

simple_css = mt-static/css/reset.css \
	mt-static/css/chromeless.css \
	mt-static/css/form.css \
	mt-static/css/listing.css \
	mt-static/css/messaging.css \
	mt-static/css/utilities.css

all: code

mt-static/js/mt_core_compact.js: $(core_js)
	cat $(core_js) > mt-static/js/mt_core_compact.js
	./build/minifier.pl mt-static/js/mt_core_compact.js

mt-static/js/editor.js: $(editor_js)
	cat $(editor_js) > mt-static/js/editor.js
	./build/minifier.pl mt-static/js/editor.js

mt-static/jquery/jquery.mt.min.js: $(jquery_js)
	cat $(jquery_js) > mt-static/jquery/jquery.mt.min.js
	./build/minifier.pl mt-static/jquery/jquery.mt.min.js

mt-static/plugins/TinyMCE/tiny_mce/plugins/mt/plugin.min.js: $(tinymce_plugin_mt_js)
	cat $(tinymce_plugin_mt_js) > mt-static/plugins/TinyMCE/tiny_mce/plugins/mt/plugin.min.js
	./build/minifier.pl mt-static/plugins/TinyMCE/tiny_mce/plugins/mt/plugin.min.js

mt-static/plugins/TinyMCE/tiny_mce/plugins/mt_fullscreen/plugin.min.js: $(tinymce_plugin_mt_fullscreen_js)
	cat $(tinymce_plugin_mt_fullscreen_js) > mt-static/plugins/TinyMCE/tiny_mce/plugins/mt_fullscreen/plugin.min.js
	./build/minifier.pl mt-static/plugins/TinyMCE/tiny_mce/plugins/mt_fullscreen/plugin.min.js

mt-static/css/main.css: $(main_css)
	cat $(main_css) > mt-static/css/main.css
	./build/minifier.pl mt-static/css/main.css

mt-static/css/simple.css: $(simple_css)
	cat $(simple_css) > mt-static/css/simple.css
	./build/minifier.pl mt-static/css/simple.css

.PHONY: code-common code code-en_US code-de code-fr code-nl \
	code-es code-ja
code_common = lib/MT.pm php/mt.php mt-check.cgi version_file \
        mt-static/js/mt_core_compact.js \
        mt-static/js/editor.js \
        mt-static/jquery/jquery.mt.min.js \
	    mt-static/plugins/TinyMCE/tiny_mce/plugins/mt/plugin.min.js \
	    mt-static/plugins/TinyMCE/tiny_mce/plugins/mt_fullscreen/plugin.min.js \
        mt-static/css/main.css \
        mt-static/css/simple.css

code: check code-$(BUILD_LANGUAGE)
code-en_US code-de code-fr code-nl code-es: check $(code_common) \
	$(local_js)
code-ja: check $(code_common) mt-static/mt_ja.js

build-language-stamp:

check:
	@(test $(BUILD_LANGUAGE) || echo You must define BUILD_LANGUAGE)
	@test $(BUILD_LANGUAGE)
	@(test $(BUILD_PACKAGE) || echo You must define BUILD_PACKAGE)
	@test $(BUILD_PACKAGE)
	@(test $(BUILD_VERSION_ID) || echo You must define BUILD_VERSION_ID)
	@test $(BUILD_VERSION_ID)
	@(test $(BUILD_RELEASE_NUMBER) || echo You must define BUILD_RELEASE_NUMBER)
	@test $(BUILD_RELEASE_NUMBER)
	-@if [ "`cat build-language-stamp`" != ${BUILD_LANGUAGE} ] ;  \
	then                                                   \
		echo ${BUILD_LANGUAGE} > build-language-stamp; \
		echo updated build-language-stamp;             \
	fi

lib/MT.pm: build-language-stamp build/mt-dists/$(BUILD_PACKAGE).mk build/mt-dists/default.mk
	mv lib/MT.pm lib/MT.pm.pre
	sed -e "s!__PRODUCT_NAME__!$(PRODUCT_NAME)!g" \
	    -e "s!__BUILD_ID__!$(BUILD_VERSION_ID)!g" \
	    -e "s!__PORTAL_URL__!$(PORTAL_URL)!g" \
	    -e "s!__PRODUCT_VERSION_ID__!$(BUILD_VERSION_ID)!g" \
	    -e "s!__RELEASE_NUMBER__!$(BUILD_RELEASE_NUMBER)!g" \
	    lib/MT.pm.pre > lib/MT.pm
	rm lib/MT.pm.pre

php/mt.php: build-language-stamp build/mt-dists/$(BUILD_PACKAGE).mk
	mv php/mt.php php/mt.php.pre
	sed -e "s!__PRODUCT_NAME__!$(PRODUCT_NAME)!g" \
	    -e "s!__PRODUCT_VERSION_ID__!$(BUILD_VERSION_ID)!g" \
	    -e "s!__RELEASE_NUMBER__!$(BUILD_RELEASE_NUMBER)!g" \
	    php/mt.php.pre > php/mt.php
	rm php/mt.php.pre

mt-check.cgi: build-language-stamp build/mt-dists/$(BUILD_PACKAGE).mk
	mv mt-check.cgi mt-check.cgi.pre
	sed -e "s!__PRODUCT_VERSION_ID__!$(BUILD_VERSION_ID)!g" \
	    -e "s!__RELEASE_NUMBER__!$(BUILD_RELEASE_NUMBER)!g" \
	mt-check.cgi.pre > mt-check.cgi
	rm mt-check.cgi.pre
	chmod +x mt-check.cgi

$(local_js): mt-static/mt_%.js: mt-static/mt.js lib/MT/L10N/%.pm
	perl build/mt-dists/make-js

version_file:
	mv VERSIONS VERSIONS.pre
	sed -e "s!__BUILD_VERSION_ID__!$(BUILD_VERSION_ID)!g" \
	    -e "s!__BUILD_LANGUAGE__!$(BUILD_LANGUAGE)!g" \
	    -e "s!__RELEASE_NUMBER__!$(BUILD_RELEASE_NUMBER)!g" \
	    -e "s!__BUILD_VERSIONS_TRAILER__!$(BUILD_VERSIONS_TRAILER)!g" \
	VERSIONS.pre > VERSIONS
	rm VERSIONS.pre

##### Other useful targets

.PHONY: dist me clean

dist:
	perl build/exportmt.pl --local

me:
	perl build/exportmt.pl --make

clean:
	-rm -rf $(local_js)
	-rm -rf mt-static/js/mt_core_compact.js
	-rm -rf mt-static/js/editor.js
	-rm -f mt-static/jquery/jquery.mt.min.js
	-rm -f mt-static/plugins/TinyMCE/tiny_mce/plugins/mt/plugin.min.js
	-rm -f mt-static/plugins/TinyMCE/tiny_mce/plugins/mt_fullscreen/plugin.min.js
	-rm -rf mt-static/css/main.css mt-static/css/simple.css
	-rm -rf MANIFEST
	-rm -rf build-language-stamp
	-git checkout lib/MT.pm php/mt.php mt-check.cgi mt-config.cgi-original VERSIONS

# test tasks
-include t/test.mk
-include t/docker-test.mk

