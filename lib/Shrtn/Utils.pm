package Shrtn::Utils;

use strict;
use warnings;
use Exporter::Lite;
use Digest::MD5 qw(md5_base64);
use Carp;

our @EXPORT = qw();
our @EXPORT_OK = qw(
  shortcode_available
  get_shortcode
);

# Check if $code is available in $db, returning 1 if so.
# Otherwise, either return 0, or die if $die is set.
sub shortcode_available
{
  my ($code, $db, $url, $arg) = @_;
  my $die = $arg->{die};
  my $base_url = $arg->{base_url};

  return 1 if not exists $db->{$code};

  return 0 unless $die;

  # Going to die - check whether db url matches $url
  my $db_url = $db->{$code};
  my $display = $base_url ? "$base_url/$code" : $code;
  if ($url and $db_url eq $url) {
    die "URL is already in db with that code: $display => $url\n";
  }
  else {
    die "Code $code is already used in db: $display => $db_url\n";
  }
}

# Generate a series of candidate shortcodes from the md5 checksum of $url,
# and check against $db hash
sub get_shortcode
{
  my ($db, $url) = @_;
  croak "Invalid db '$db' - not a hashref" unless ref $db and ref $db eq 'HASH';

  # Prep checksum
  my $checksum = md5_base64($url);
  # Remove '+' and '/' characters
  $checksum =~ s![+/]+!!g;

  # Search subchunks of $checksum to find first unused
  my $copy = $checksum;
  my $length = 3;
  while ($length <= 6) {
    while ($copy =~ m/^(.{$length})(.*)/) {
      my $candidate = $1;
      $copy = $2;

      return $candidate if shortcode_available($candidate, $db, $url);
    }

    # Reset $copy and bump $length
    $copy = $checksum;
    $length++;
  }

  die "Failed to generate unused shortcode for url $url - perhaps supply one manually?\n";
}

1;

