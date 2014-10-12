Shrtn
=====

Shrtn (pronounced "shorten") is a tiny url shortener inspired by @joemoreno,
@davewiner and @windley - see their posts below for background:

- http://blog.adjix.com/2009/04/kobayashi-maru.html
- http://scripting.com/stories/2009/04/27/adjixHasABreakthroughIdeaI.html
- http://www.windley.com/archives/2012/07/my_own_url_shortener.shtml

TL;DR version: redirect files are just static html files with meta refresh
headers, so the only server requirement is a simple web server - no database,
no dynamic code, very little to go wrong.

The set of mappings from codes to urls is just stored in a yaml text file,
so it is trivial to backup etc.

And if the data directory is detected to be a git repo, shrtn will
automatically commit and push your mappings remotely, making backup
completely automatic.


Usage
-----

shrtn is a just a script that generates your shortcodes and redirect html
pages for you. Usage is:

```bash
./shrtn <url> [<code>]
```

e.g.

```bash
./shrtn http://www.example.com/amazing_piece_of_newness
```

You can optionally supply your own shortcode, which shrtn will use if
available:

```bash
./shrtn http://www.openfusion.net/ ofn
```

You can either run `shrtn` directly on your server (say via ssh), or you
can run it on your laptop or workstation, and sync the generated html files
over to your webserver using rsync (just set `rsync_path` in your
`data/config.yml` file).

shrtn is written in perl; the only requirements are YAML and Digest::MD5
(the latter is in core for perl >= 5.7.3).


Setup
-----

Simple:

```bash
git clone https://github.com/gavincarr/shrtn.git
cd shrtn

# Use the shrtn_setup script to copy template configs from conf to a new
# 'data' directory (it will ask you about copying apache or nginx templates)
./shrtn_setup

# Configure to taste (you must at least set the 'base_url' in config.yml,
# and your server name and paths in the webserver configs)
$EDITOR data/*

# If you're setting up on your server, copy or link the webserver configs to
# the appropriate locations, and then restart your webserver
# e.g. apache:
sudo ln -s /etc/httpd/conf.d/shrtn.conf $PWD/data/apache.conf
# e.g. nginx:
sudo ln -s /etc/nginx/conf.d/shrtn.conf $PWD/data/nginx.conf

# If you're going to push your redirect files to a remote webserver, copy
# your shrtn webserver configs remotely, and make sure you set 'rsync_path'
# in your data/config.yml. e.g.
scp data/apache.conf WEBSERVER:/etc/httpd/conf.d/shrtn.conf
scp data/nginx.conf  WEBSERVER:/etc/nginx/conf.d/shrtn.conf
```
  
In addition, if you want to auto-commit your shortenings to github, you
can create a new repo on github (I'm using 'shrtn-data'), and clone it
as your data directory e.g.

```bash
mv data data.orig
git clone https://github.com/USER/shrtn-data data
cp data.orig/* data
cd data
git add *
git commit -m 'Initial import.'
```

After this `shrtn` will auto-commit and push any new shortenings you add
to github.


Author and Licence
------------------

Copyright 2012-2014 Gavin Carr <gavin@openfusion.com.au>

Shrtn is available under the same terms as perl i.e. either under the
GPL, version 1, or (at your option) any later version; or under the
"Artistic License". See http://dev.perl.org/licenses/.

