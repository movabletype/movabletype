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
