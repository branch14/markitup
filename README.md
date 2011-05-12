Markitup
========

Rack middleware to inject CSS & Javascript to turn text areas into
rich text editors using Jay Salvat's *MarkItUp!*.

It effortlessly integrates with Rails and other Rackbased frameworks.

### Setup

Put this in your Gemfile.

    gem 'markitup'

And run a couple of rake tasks to get the CSS, Javascript & image
assets in place.

    rake markitup:install:base
    rake markitup:install:markdown

Now, if you provide a text area with the class specified as keyword in
config/markup.yml, the text area will turn into an editor. The default
keyword is (this is case sensitive!):

    markItUp

So this should do it...

    <textarea class='markItUp'></textarea>

### Configuration

There is no additional configuration needed. However a config file is
created, which can be customized, if you want to have things
differently. After the first request, you'll find it here:

    config/markitup.yml

### Limitations & Todo

 * preview function, not yet supported
 * currently only supports markdown

### Links & Acknowledgements

 * Thanks to Jay Salvat for the awsome markup editor
 * http://markitup.jaysalvat.com/home/