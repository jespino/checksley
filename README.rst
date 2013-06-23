Parsley.coffee
==============

.. image:: https://travis-ci.org/guillaumepotier/Parsley.js.png?branch=master
    :target: https://travis-ci.org/guillaumepotier/Parsley.js

Coffeescript form validation, without actually writing a single line of coffeescript!

Curent Stable Version
=====================

1.1.16

Browser compatibility
=====================

* IE 7/8 (with jQuery < 2.x.x, parsley.min, not parsley.standalone)
* IE 9+ (latest jQuery and Zepto)
* FF 14+
* Chrome

Requirements
============

jQuery 1.6+

Install dependencies for documentation and tests
================================================

`bower install jquery`
`bower install bootstrap`

Run tests
=========

* In your browser: go to `tests/index.html`
* Headless tests: `grunt test`

Make production minified versions
=================================

`grunt dist`

Contribute!
===========

Validators
----------

Add new validators in `parsley.extend.coffee` and minify it. No validators will be allowed directly into parsley.coffee
(but great validators could move from extra to parsley ;))

Localization
------------

If file does not exist, create it into `ì18n/` directory with same syntax as others.  
Reference file is _messages.en.fr

Integrations
------------

Create integration with other framework as a separate Github repo and send a pull request for including here.  
Some integrations are

* [Django](https://github.com/agiliq/django-parsley)
* [Rails](https://github.com/mekishizufu/parsley-rails)
* [Wicket](https://github.com/code-troopers/wicket-jsr303-parsley)

Global
------

* fork repository
* add your changes to parsley.coffee
* add / update tests to test suite (tests/index.html / tests/tests.js)
* run tests (see above)
* create new minified versions with minify script (see above) (use next tag-dev as version. Ie: if 1.1.1, use 1.1.2-dev)
* make a Pull Request!

Licence
=======

See LICENCE
