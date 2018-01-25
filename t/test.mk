.PHONY: cover covertags tags test testall quick-test test-parallel test-update-fixture test-ignore-fixture test-phpunit test-php-lint

cover:
	-cover -delete
	HARNESS_PERL_SWITCHES=-MDevel::Cover \
	prove

covertags:
	-cover -delete
	HARNESS_PERL_SWITCHES=-MDevel::Cover \
	prove t/*tags*.t
	-cover

tags:
	-rm -rf t/db/*
	prove t/*tags*.t

test:
	prove

testall:
	prove t plugins/*/t addons/*/t

quick-test:
	prove \
		t/00-compile.t t/01-serialize.t t/04-config.t \
		t/05-errorhandler.t t/07-builder.t t/08-util.t           \
		t/09-image.t t/10-filemgr.t t/11-sanitize.t t/12-dsa.t   \
		t/13-dirify.t t/20-setup.t t/21-callbacks.t t/22-author.t\
		t/23-entry.t t/26-pings.t t/27-context.t t/28-xmlrpc.t   \
		t/32-mysql.t t/33-postgresql.t   \
		t/34-sqlite.t t/35-tags.t t/45-datetime.t t/46-i18n-en.t \
		t/47-i18n-ja.t t/48-cache.t

test-parallel:
	prove -j4 -PMySQLPool=MT::Test::Env -It/lib

test-update-fixture:
	MT_TEST_UPDATE_FIXTURE=1 prove

test-ignore-fixture:
	MT_TEST_IGNORE_FIXTURE=1 prove

test-phpunit:
	php -v
	phpunit

PHP_LINT_DIR ?= .

test-php-lint:
	php -v
	find $(PHP_LINT_DIR) -name "*.php" | xargs -n1 php -l

