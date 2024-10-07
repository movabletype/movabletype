# MT test documentation

## Overview

You can learn how to test Movabletype by reading 
[.github/workflows/movabletype.yml](https://github.com/movabletype/movabletype/blob/develop/.github/workflows/movabletype.yml).
The following are some small portions of it.

```
$ git clone git@github.com:movabletype/movabletype.git
$ cd movabletype
$ docker run -it -v $PWD:/mt -w /mt movabletype/test:centos8 /bin/bash
[root@0919d7f18f05 mt]# BUILD_RELEASE_NUMBER=1 make
[root@0919d7f18f05 mt]# prove -It/lib t/app
```

Some tests need to be run on the dedicated docker images.

```
$ docker run -it -v $PWD:/mt -w /mt movabletype/test:chromiumdriver prove -It/lib t/selenium
```

## Environment Variables

Environment variables starting with `MT_TEST_` (and some common names) change the behavior of tests. Please do `grep -r MT_TEST_ t/` for
details.

### Examples

```
[root@0919d7f18f05 mt]# MT_TEST_DEBUG_MODE=7 prove -It/lib t/20-setup.t
[root@0919d7f18f05 mt]# MT_TEST_QUERY_LOG=1 prove -It/lib t/20-setup.t
[root@0919d7f18f05 mt]# MT_TEST_CRAWL=1 prove -It/lib t/selenium/crawl.t
[root@0919d7f18f05 mt]# EXTENDED_TESTING=1 prove -It/lib t/tag/php-only-test.t
```

Note that some test options may need extra cpan modules. Please do `cpanm ...`.

## Parallel testing

Run tests in parallel. This command needs [App::Prove::Plugin::MySQLPool](https://metacpan.org/pod/App::Prove::Plugin::MySQLPool).

```
[root@0919d7f18f05 mt]# prove -j4 -PMySQLPool=MT::Test::Env -It/lib ./t ./plugins/**/t
```

## Fixture

Pre-recorded fixtures are used by default for speeding up the tests. You can ignore/update them.

### Update fixture

Fixtures depend on the following.
* installed addons/plugins
* schema_version of core and addons/plugins

So, when you update fixtures for core tests, you need to remove additional addons/plugins before executing the following command.

```
[root@0919d7f18f05 mt]# MT_TEST_UPDATE_FIXTURE=1 prove ./t ./plugins/**/t
```

### Ignore fixture

```
[root@0919d7f18f05 mt]# MT_TEST_IGNORE_FIXTURE=1 prove ./t ./plugins/**/t
```

### Update fixture schema

```
[root@0919d7f18f05 mt]# perl -It/lib -MMT::Test::Env -E 'MT::Test::Env->save_schema'
```

## Test for PHP

PHP files can be tested by following command.

```
[root@0919d7f18f05 mt]# phpunit
```

Some perl tests also include tests against PHP via `MT::Test::Tag`. The following are just a partial list.

```
[root@0919d7f18f05 mt]# prove -It/lib t/tag/ t/mt7/tag/ t/mt7/multiblog/
```

## Database inspection

mysql is used for tests by default and a database named `mt_test` is automatically created.
You can inspect the tables by following command.

```
$ docker run -it -v $PWD:/mt -w /mt movabletype/test:centos8 /bin/bash
[root@0919d7f18f05 mt]# prove -It/lib path/to/test.t
[root@0919d7f18f05 mt]# mysql -u root --database mt_test
```

## Test files

There are test files in ./t and ./plugins/**/t directories.

* plugins/**/t
  * tests for each plugin
* t/app/*.t
  * tests for MT::App::*
* t/class/*.t
  * tests for class that does not inherit MT::Object
* t/cms/*.t
  * tests for MT::CMS::*
* t/cms_permission/*.t
  * permission tests for MT::CMS::*
* t/data_api/*.t
  * tests for Data API
* t/model/*.t
  * tests for class that inherits MT::Object
* t/mt7/**/*.t
  * tests for MT7 feature
* t/mt_object/*.t
  * tests for MT::Object, MT::Meta, MT::Summary and etc.
* t/object_driver/*.t
  * tests for MT::ObjectDriver/**/*.t
* t/tag/*.t
  * tests for template tag
* t/task/*.t
  * tests for schedule task
* t/template/*.t
  * tests for MT::Template*, MT::ArchiveType*, MT::*Publisher and etc.
* t/util/*.t
  * tests for MT::Util*
* t/xt/*.t
  * author tests
* t/tools
  * tests for command line tools
* t/upgrade
  * tests for upgrade
* t/admin_theme_id
  * tests for the theming mechanism of CMS
* t/*.t
  * tests other than the above

## Testing your own plugins

For starters, run core tests against Movabletype source with your plugin installed to make sure your plugin doesn't
break the tests.

```
$ cd movabletype
$ cp -r path/to/your-repo/plugins/your-plugin ./plugins/
$ cp -r path/to/your-repo/mt-static/plugins/your-plugin ./mt-static/plugins/
$ docker run -it -v $PWD:/mt -w /mt movabletype/test:centos8 prove -It/lib t
```

You can also run your own tests.

```
$ docker run -it -v $PWD:/mt -w /mt movabletype/test:centos8 prove -It/lib plugins/your-plugin/t
```
