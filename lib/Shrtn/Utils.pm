package Shrtn::Utils;

use strict;
use warnings;
use Exporter;
use Digest::MD5 qw(md5_hex);
use YAML qw(DumpFile);
use Carp;

our @ISA = qw(Exporter);
our @EXPORT = qw();
our @EXPORT_OK = qw(
  shortcode_available
  get_shortcode
  save_db
  generate_new_redirect_page
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
    die "Code '$code' already exists in db pointing to that URL => $url\n";
  }
  else {
    warn "Code '$code' already exists in db => $db_url\n";
    die  "(use --force option to force the '$code' URL to be updated)\n";
  }
}

# Generate a series of candidate shortcodes from the md5 checksum of $url,
# and check against $db hash
my %url_db;
sub get_shortcode
{
  my ($db, $url) = @_;
  croak "Invalid db '$db' - not a hashref" unless ref $db and ref $db eq 'HASH';

  # Invert $db to return an existing code if one exists for that URL
  if (not %url_db) {
    # Note we ignore collisions here - if a URL is repeated, we'll pick one of its codes at random
    %url_db = reverse %$db;
  }
  return $url_db{$url} if exists $url_db{$url};

  # Prep checksum
  my $checksum = uc md5_hex($url);

  # Search subchunks of $checksum to find first unused
  my $copy = $checksum;
  my $length = 3;
  while ($length <= 8) {
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

sub save_db
{
  my ($db, $db_file) = @_;

  DumpFile("$db_file.tmp", $db)
    and rename("$db_file.tmp", $db_file)
      or die "Saving database failed: $!";
}

# Generate a new $code.html redirect page
sub generate_new_redirect_page
{
  my ($Bin, $code, $url) = @_;

  # Read template
  my $template_file = "$Bin/data/template.html";
  my $template;
  open my $tfh, '<', $template_file
    or die "Cannot open '$template_file' for input: $!";
  {
    local $/;
    $template = <$tfh>;
    die "No template content found\n" if length $template < 100;
  }
  close $tfh;

  # Munge template
  $template =~ s/<% URL %>/$url/gs;

  # Generate
  my $outfile = "$Bin/htdocs/$code.html";
  open my $fh, '>', $outfile
    or die "Cannot open '$outfile' for output: $!";
  print $fh $template
    or die "Cannot write to $outfile: $!";
  close $fh;
}

1;

