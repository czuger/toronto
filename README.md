# Toronto

This is a fork from https://github.com/decioferreira/bootstrap-generators

* Patch your scaffold generator
* Use bootstrap
* Translate fields (english and french for the moment)
* References produce selects
* Automatic menu

*Caution* : supported template engine : haml only

## Current Twitter Bootstrap version

The current supported version of Twitter Bootstrap is 3.3.4.

## Installing Gem

In your Gemfile, add this line:

    gem 'toronto'

Run bundle install:

    bundle install

## Generators

Get started: 

    rails generate toronto:install

To overwrite files that already exist, pass the `--force` (`-f`) option.

Once you've done that, any time you generate a controller or scaffold, you'll get [Bootstrap](http://twitter.github.com/bootstrap/) templates.

### Give it a try

In Rails >= 4.1 you need to run `spring stop` so than Rails preloader knows about new templates.

    rails generate scaffold post title body:text published:boolean

You can easily customize colors, grid system, fonts, and much more by editing `bootstrap-variables.[less|scss]` on your application assets folder.

## Usage

To print the options and usage run the command `rails toronto:install --help`

    Usage:
      rails generate toronto:install [options]

    Options:
      -se, [--stylesheet-engine=STYLESHEET_ENGINE]     # Indicates when to generate stylesheet engine
                                                       # Default: scss
          [--skip-turbolinks], [--no-skip-turbolinks]  # Indicates when to generate skip turbolinks
          [--languages=LANGUAGES_LIST]                 # Indicates wich languages to use
                                                       # Use --languages=en,fr,de,cn for english, french, german and chineese (the only languages that are implemented)
                                                       # The first language in the list will be the default language in rails.
                                                       # If option not given, then only the language english is generated
          
    Runtime options:
      -f, [--force]                    # Overwrite files that already exist
      -p, [--pretend], [--no-pretend]  # Run but do not make any changes
      -q, [--quiet], [--no-quiet]      # Suppress status output
      -s, [--skip], [--no-skip]        # Skip files that already exist

    Copy BootstrapGenerators default files

### Options

#### Template engines

Supported template engines:

* Haml

#### Stylesheet engines

Supported stylesheet engines:

* CSS
* SCSS
* LESS

##### SCSS

Make sure you have `sass-rails` dependency on your Gemfile:

    gem 'sass-rails'

And then run:

    rails generate bootstrap:install --stylesheet-engine=scss

Now you can customize the look and feel of Bootstrap.

##### LESS

Add the dependency on your Gemfile:

    gem 'therubyracer', platforms: :ruby
    gem 'less-rails'

And then run:

    rails generate bootstrap:install --stylesheet-engine=less

Now you can customize the look and feel of Bootstrap.

#### Skip turbolinks

Run the generator with option `--skip-turbolinks` to remove turbolinks references from the generated layout.

## Assets

### Customize and extend Bootstrap

If you select LESS or SCSS as your stylesheet engine, you will get an `app/assets/stylesheets/bootstrap-variables.[less|scss]` file with all of the default variables of Bootstrap. This way you can customize the look and feel of Bootstrap without having to download any extra file.

### Javascript

Select all jQuery plugins (`app/assets/javascripts/bootstrap.js`)

    //= require bootstrap

Or quickly add only the necessary javascript (Transitions: required for any animation; Popovers: requires Tooltips)

    //= require bootstrap/collapse
    //= require bootstrap/modal
    //= require bootstrap/button
    //= require bootstrap/affix
    //= require bootstrap/tab
    //= require bootstrap/alert
    //= require bootstrap/transition
    //= require bootstrap/tooltip
    //= require bootstrap/popover
    //= require bootstrap/scrollspy
    //= require bootstrap/dropdown
    //= require bootstrap/carousel


## Customizing Templates

In Rails 3.0 and above, generators don’t just look in the source root for templates, they also search for templates in other paths. And one of them is lib/templates.

Since Bootstrap Generators installs its templates under lib/templates, you can go and customize them.

## Update Bootstrap Version

To update the version of Bootstrap on this Gem you can run the following command:

    rake bootstrap:update

There might be some manual changes needed after running this command. But most of the process is automatic.

## Credits

* [Twitter Bootstrap](http://getbootstrap.com)
