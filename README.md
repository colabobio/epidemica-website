# Epidemica website

Website of the Epidemica project by the Colubri Lab.

Based on the [Jekyll lean startup template](https://github.com/MattiSG/jekyll-template) from [Matti Schneider](https://mattischneider.fr/).


## Local usage

- [Install Jekyll](https://jekyllrb.com/docs/installation/)

- Install all required dependencies: `bundle install` 

- Start the server with the following options: `bundle exec jekyll serve --watch --safe --strict_front_matter`

> - `watch` improves your developer experience: the server will reload automatically when it detects changes to files (except the config file, you’ll get bitten by that at some point).
> - `safe` mirrors GitHub Pages' setup.
> - `strict_front_matter` allows to catch errors early.


### Change the menu

In order to avoid mixing content files with config & dev files, pages are never created at the root: they all get written in collections. In order to add a page to the menu, you can simply add it to `_toplevel`, as long as you set its URL with `permalink`. Prefix their filename with the index at which you'd like them to appear in the menu. The first one (by convention, index `0`) will appear on the left handside of the menu, along with your website logo.


### Publish to GitHub Pages

- Create a repository on GitHub.
- Push your content to it.
- Activate GitHub Pages in the settings.


### Set up Continuous Integration

If you use [CircleCI](https://circleci.com), just log in with GitHub and activate builds for your repository. They offer a free plan for open-source.
