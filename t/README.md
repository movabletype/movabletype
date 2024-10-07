# MT test documentation

## Setup and Basics

You can learn how to test Movabletype by reading 
[.github/workflows/movabletype.yml](https://github.com/movabletype/movabletype/blob/develop/.github/workflows/movabletype.yml).
The following are some small portions of it.

```sh
$ git clone git@github.com:movabletype/movabletype.git
$ cd movabletype
$ docker run -it -v $PWD:/mt -w /mt movabletype/test:centos8 bash -c "BUILD_RELEASE_NUMBER=1 make"
$ docker run -it -v $PWD:/mt -w /mt movabletype/test:centos8 prove -It/lib t/app
```

Some tests need to be run on the dedicated docker images.

```sh
$ docker run -it -v $PWD:/mt -w /mt movabletype/test:chromiumdriver prove -It/lib t/selenium
```

PHP files can be tested by following command.

```sh
$ docker run -it -v $PWD:/mt -w /mt movabletype/test:chromiumdriver phpunit
```

Some tests are skipped by default. These cases can be run by setting environment variables starting with `MT_TEST_`.

For example,

```sh
$ docker run -it -v $PWD:/mt -w /mt movabletype/test:centos8 bash -c "MT_TEST_CRAWL=1 prove -It/lib t/selenium/crawl.t"
```

For details, please do `grep -r MT_TEST_ t/`.

mysql is used for tests by default. You can inspect the tables by following command.

```sh
$ docker run -it -v $PWD:/mt -w /mt movabletype/test:centos8 /bin/bash
$ prove -It/lib path/to/test.t
$ mysql -u root --database mt_test
```

## Parallel testing

Run tests in parallel. This command needs [App::Prove::Plugin::MySQLPool](https://metacpan.org/pod/App::Prove::Plugin::MySQLPool).

```sh
$ prove -j4 -PMySQLPool=MT::Test::Env -It/lib ./t ./plugins/**/t
```

## Fixture

Pre recorded fixtures are used by default for speeding up the tests. You can ignore/update them.

### update fixture

Fixtures depend on the followings.
* installed addons/plugins
* schema_version of core and addons/plugins

So, when you update fixtures for core tests, you need to remove additional addons/plugins before executing the following command.

```sh
$ MT_TEST_UPDATE_FIXTURE=1 prove ./t ./plugins/**/t
```

### ignore fixture

```sh
$ MT_TEST_IGNORE_FIXTURE=1 prove ./t ./plugins/**/t
```

### update fixture schema

```sh
$ perl -It/lib -MMT::Test::Env -E 'MT::Test::Env->save_schema'
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
  * tests for theming mechanism of CMS
* t/*.t
  * tests other than the above
