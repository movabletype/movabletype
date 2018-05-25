# MT test documentation

## Test commands

### default

```sh
$ prove ./t ./plugins/**/t
```

### parallel test

Run tests in parallel. This command needs [App::Prove::Plugin::MySQLPool](https://metacpan.org/pod/App::Prove::Plugin::MySQLPool).

```sh
$ prove -j4 -PMySQLPool=MT::Test::Env -It/lib ./t ./plugins/**/t
```

### update fixture

Fixture depends on the followings.
* installed addons/plugins
* schema_version of core and addons/plugins

So, when you update fixture for Travis CI, you need to remove additional addons/plugins before executing the following command.

```sh
$ MT_TEST_IGNORE_FIXTURE=1 prove ./t ./plugins/**/t
```

### ignore fixture

```sh
$ MT_TEST_IGNORE_FIXTURE=1 prove ./t ./plugins/**/t
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
* t/*.t
  * tests other than the above

## CI services

### [Travis CI](https://travis-ci.org/movabletype/movabletype)

Test on the following environments.

* all branches
  * Perl 5.18, PHP 5.5, MySQL 5.5
* master/develop branch
  * Perl 5.10, PHP 5.3, MySQL 5.1
  * Perl 5.24, PHP 7.0, MariaDB 10.1
  
Setting file is .travis.yml.

### [Shippable](https://app.shippable.com/github/movabletype/movabletype/dashboard)

Test on the following environment.

* Perl 5.18, PHP 5.5, MySQL 5.5

Test without fixture to check whether fixture is broken or not. (MT_TEST_IGNORE_FIXTURE=0)

Setting file is shippable.yml.
