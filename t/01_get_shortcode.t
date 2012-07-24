# Test Shrtn::Utils::get_shortcode

use Test::More 0.88;
use YAML qw(LoadFile Dump);

use FindBin qw($Bin);
use lib "$Bin/../lib";
use Shrtn::Utils qw(get_shortcode);

my @urls = (
  # Test new
  [ 'http://www.identi.ca/'         => '1cf' ],
  [ 'http://www.twitter.com/'       => '3Ou' ],
  [ 'http://www.google.com/'        => '5CC' ],
  # Test existing
  [ 'http://www.mysociety.org/2012/07/18/governments-dont-have-websites-governments-are-websites/' => 'PVp' ],
  # Test existing custom
  [ 'http://www.openfusion.net/'    => 'ofn' ],
);

my $db = LoadFile "$Bin/t01/db.yml";
ok($db && ref $db eq 'HASH', 'db loaded ok');

for my $rec (@urls) {
  my ($url, $expected_code) = @$rec;
  my $code = get_shortcode($db, $url);
  is($code, $expected_code, "get_shortcode for $url ok");
}

done_testing;

