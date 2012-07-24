Shrtn
=====

Shrtn (pronounced "shorten"!) is a tiny url shortener inspired by @joemoreno,
@davewiner and @windley - see their posts below for background:

- http://blog.adjix.com/2009/04/kobayashi-maru.html
- http://scripting.com/stories/2009/04/27/adjixHasABreakthroughIdeaI.html
- http://www.windley.com/archives/2012/07/my_own_url_shortener.shtml

(TL;DR version: redirects just use static html files with meta refresh
headers, so you just need a basic web server, no database, no dynamic code)

The set of mappings from codes to urls is just stored in a yaml text file,
so it is trivial to backup etc.


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

shrtn is written in perl; the only requirements are YAML and Digest::MD5
(the latter is in core for perl >= 5.7.3).


Setup
-----

Pretty simple (unix version):

```bash
git clone https://github.com/gavincarr/shrtn.git
cd shrtn

# Copy the example data/config.yml.dist and update the base_url setting
cp data/config.yml.dist data/config.yml
$EDITOR data/config.yml

# Copy and tweak the appropriate webserver config
# e.g. apache:
cp conf/apache.conf.dist conf/apache.conf
$EDITOR conf/apache.conf
sudo ln -s /etc/httpd/conf.d/shrtn.conf $PWD/conf/apache.conf
# e.g. nginx:
cp conf/nginx.conf.dist conf/nginx.conf
$EDITOR conf/nginx.conf
sudo ln -s /etc/nginx/conf.d/shrtn.conf $PWD/conf/nginx.conf

# Restart webserver
```
  
Done!



Author and Licence
------------------

Copyright 2012 Gavin Carr <gavin@openfusion.com.au>

Shrtn is available under the same terms as perl i.e. either under the
GPL, version 1, or (at your option) any later version; or under the
"Artistic License". See http://dev.perl.org/licenses/.

