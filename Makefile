-include build/mt-dists/default.mk
-include build/mt-dists/$(BUILD_PACKAGE).mk
-include build/mt-dists/$(BUILD_LANGUAGE).mk

latin1_modules = lib/MT/L10N/es-iso-8859-1.pm \
		 lib/MT/L10N/fr-iso-8859-1.pm \
		 lib/MT/L10N/de-iso-8859-1.pm \
		 lib/MT/L10N/nl-iso-8859-1.pm

local_js = mt-static/mt_de.js \
        mt-static/mt_fr.js \
        mt-static/mt_nl.js \
        mt-static/mt_ja.js \
        mt-static/mt_es.js

core_js = mt-static/js/common/Core.js \
          mt-static/js/common/JSON.js \
          mt-static/js/common/Timer.js \
          mt-static/js/common/DOM.js \
          mt-static/js/common/Observable.js \
          mt-static/js/common/Autolayout.js \
          mt-static/js/common/Component.js \
          mt-static/js/common/List.js \
          mt-static/js/common/App.js \
          mt-static/js/common/Cache.js \
          mt-static/js/common/Client.js \
          mt-static/js/common/Template.js \
          mt-static/js/menus.js \
          mt-static/js/tc.js \
          mt-static/js/tc/tableselect.js

all: code

mt-static/js/mt_core_compact.js: $(core_js)
	cat $(core_js) > mt-static/js/mt_core_compact.js

#all: code docs

.PHONY: code-common code code-en_US code-de code-fr code-nl \
	code-es code-ja
code_common = lib/MT.pm php/mt.php mt-check.cgi \
        mt-static/js/mt_core_compact.js \
	mt-config.cgi-original index.html

code: check code-$(BUILD_LANGUAGE)
code-en_US code-de code-fr code-nl code-es: check $(code_common) \
	$(latin1_modules) $(local_js)
code-ja: check $(code_common) mt-static/mt_ja.js

build-language-stamp:

check:
	@(test $(BUILD_LANGUAGE) || echo You must define BUILD_LANGUAGE)
	@test $(BUILD_LANGUAGE)
	@(test $(BUILD_PACKAGE) || echo You must define BUILD_PACKAGE)
	@test $(BUILD_PACKAGE)
	@(test $(BUILD_VERSION_ID) || echo You must define BUILD_VERSION_ID)
	@test $(BUILD_VERSION_ID)
	-@if [ "`cat build-language-stamp`" != ${BUILD_LANGUAGE} ] ;  \
	then                                                   \
		echo ${BUILD_LANGUAGE} > build-language-stamp; \
		echo updated build-language-stamp;             \
	fi

lib/MT.pm: %: %.pre build-language-stamp build/mt-dists/$(BUILD_PACKAGE).mk build/mt-dists/default.mk
	sed -e 's!__BUILD_LANGUAGE__!$(BUILD_LANGUAGE)!g' \
	    -e 's!__PRODUCT_CODE__!$(PRODUCT_CODE)!g' \
	    -e 's!__PRODUCT_NAME__!$(PRODUCT_NAME)!g' \
	    -e 's!__PRODUCT_VERSION__!$(PRODUCT_VERSION)!g' \
	    -e 's!__PRODUCT_VERSION_ID__!$(BUILD_VERSION_ID)!g' \
	    -e 's!__SCHEMA_VERSION__!$(SCHEMA_VERSION)!g' \
        -e 's!__API_VERSION__!$(API_VERSION)!g' \
	    $< > $@

php/mt.php: %: %.pre build-language-stamp build/mt-dists/$(BUILD_PACKAGE).mk
	sed -e 's!__BUILD_LANGUAGE__!$(BUILD_LANGUAGE)!g' \
	    -e 's!__PUBLISH_CHARSET__!$(PUBLISH_CHARSET)!g' \
	    -e 's!__PRODUCT_NAME__!$(PRODUCT_NAME)!g' \
	    -e 's!__PRODUCT_VERSION__!$(PRODUCT_VERSION)!g' \
	    -e 's!__PRODUCT_VERSION_ID__!$(BUILD_VERSION_ID)!g' \
        -e 's!__API_VERSION__!$(API_VERSION)!g' \
	$< > $@

mt-config.cgi-original: mt-config.cgi-original.pre build-language-stamp
	sed -e 's!__BUILD_LANGUAGE__!$(BUILD_LANGUAGE)!g' \
	    -e 's!__HELP_URL__!$(HELP_URL)!g' \
	    -e 's!__PRODUCT_VERSION__!$(PRODUCT_VERSION)!g' \
        $< > $@

mt-check.cgi: %: %.pre build-language-stamp
	sed 's!__BUILD_LANGUAGE__!$(BUILD_LANGUAGE)!g' $< > $@
	chmod +x $@

$(local_js): mt-static/mt_%.js: mt-static/mt.js lib/MT/L10N/%.pm
	perl build/mt-dists/make-js

$(latin1_modules): %-iso-8859-1.pm: %.pm
	iconv -f utf-8 -t iso-8859-1 $< > $@

# Defunct
#.PHONY: docs docs-en_US docs-fr docs-de docs-es docs-ja
#
#docs-en_US:
#	$(MAKE) -C docs-en_US
#	-rm -rf mt-static/docs
#	cp -R docs-en_US mt-static/docs
#
#docs-nl: docs-en_US
#	-rm -rf mt-static/docs
#	cp -R docs-en_US mt-static/docs
#
#docs-fr docs-de docs-es docs-ja:
#	-rm -rf mt-static/docs
#	cp -R docs-$(BUILD_LANGUAGE) mt-static/docs
#
#docs: check docs-$(BUILD_LANGUAGE) build-language-stamp

index.html: check build-language-stamp
	cp index.html.en_US $@.pre
	-cp index.html.$(BUILD_LANGUAGE) $@.pre
	sed -e 's!__HELP_URL__!$(HELP_URL)!g' \
	    -e 's!__PRODUCT_VERSION__!$(PRODUCT_VERSION)!g' \
	index.html.pre > index.html
	rm $@.pre

##### Other useful targets

.PHONY: test cover clean all

cover:
	-cover -delete
	HARNESS_PERL_SWITCHES=-MDevel::Cover \
	perl -Ilib -Iextlib -It/lib -MTest::Harness -e 'runtests @ARGV' t/*.t

covertags:
	-cover -delete
	HARNESS_PERL_SWITCHES=-MDevel::Cover \
	perl -Ilib -Iextlib -It/lib -MTest::Harness -e 'runtests @ARGV' t/*tags*.t
	-cover

tags:
	-rm -rf t/db/*
	perl -Ilib -Iextlib -It/lib -MTest::Harness -e 'runtests @ARGV' t/*tags*.t

test: code
	MT_CONFIG=t/mt.cfg perl -Ilib -Iextlib -It/lib -MTest::Harness -e 'runtests @ARGV' t/*.t

quick-test: code
	MT_CONFIG=t/mt.cfg perl -Ilib -Iextlib -It/lib -MTest::Harness -e 'runtests @ARGV'  \
		t/00-compile.t t/01-serialize.t t/04-config.t \
		t/05-errorhandler.t t/07-builder.t t/08-util.t           \
		t/09-image.t t/10-filemgr.t t/11-sanitize.t t/12-dsa.t   \
		t/13-dirify.t t/20-setup.t t/21-callbacks.t t/22-author.t\
		t/23-entry.t t/26-pings.t t/27-context.t t/28-xmlrpc.t   \
		t/29-cleanup.t t/32-mysql.t t/33-postgres.t   \
		t/34-sqlite.t t/35-tags.t t/45-datetime.t t/46-i18n-en.t \
		t/47-i18n-ja.t t/48-cache.t

dist:
	perl build/exportmt.pl --local

me:
	perl build/exportmt.pl --make

clean:
	-rm -rf lib/MT.pm mt-config.cgi-original mt-check.cgi $(latin1_modules) $(local_js)
	-rm -rf php/mt.php
	-rm -rf mt-static/js/mt_core_compact.js
	-rm -rf index.html
	-rm -rf MANIFEST
	-rm -rf build-language-stamp

