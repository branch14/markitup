Markitup
========

Rack middleware to inject CSS & Javascript to turn text areas into
rich text editors using  Jay Salvat's *MarkItUp!*.

It effortlessly integrates with Rails.

Setup
-----

Put this in your Gemfile.

    gem 'markitup'

And run a couple of rake tasks to get the CSS, Javascript & image
assets in place.

    rake markitup:install:base
    rake markitup:install:markdown

Configuration
-------------

There is no additional configuration needed. However a config file is
created, which can be customized, if you want to have things
differently. After the first request, you'll find it here:

    config/markitup.yml

Links
-----

* http://markitup.jaysalvat.com/home/