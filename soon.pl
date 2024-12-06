#!/usr/bin/perl
use strict;
use warnings;
use utf8;
use Encode;
use Getopt::Long;
use feature 'say';

# Default options
my $buffer_size = 30 * 1024 * 1024; # 30 MB buffer
my $enable_dot_split = 1;           # Enable splitting by dot (.)
my $enable_slash_split = 1;         # Enable splitting by slash (/)
my $remove_slash_prefix = 1;        # Enable removing leading slashes
my $search_pattern;                 # Search pattern (regex)

# Parse command-line options
GetOptions(
    "buffer-size=i"         => \$buffer_size,          # Allow custom buffer size
    "disable-dot-split"     => sub { $enable_dot_split = 0 },  # Disable dot splitting
    "disable-slash-split"   => sub { $enable_slash_split = 0 }, # Disable slash splitting
    "no-remove-slash-prefix" => sub { $remove_slash_prefix = 0 }, # Don't remove leading slashes
    "search=s"              => \$search_pattern,       # Set search pattern
    "help"                  => \&print_help           # Display help message
) or die("Error in command-line arguments\n");

binmode(STDIN, ':encoding(UTF-8)');

# Help message function
sub print_help {
    say "Usage: perl script.pl [options]";
    say "Options:";
    say "  --buffer-size=<size>         Set the buffer size in bytes (default: 30 MB)";
    say "  --disable-dot-split          Disable splitting by dot (.)";
    say "  --disable-slash-split        Disable splitting by slash (/)";
    say "  --no-remove-slash-prefix     Do not remove leading slashes from strings";
    say "  --search=<pattern>           Print only lines or substrings matching the given regex";
    say "  --help                       Show this help message";
    exit;
}

my %seen; # Store the output lines to check for duplicates

while (<STDIN>) {
    chomp;
    process($_, \%seen);
}

sub process {
    my ($text, $list) = @_;
    while ($text =~ /[a-zA-Z0-9\.\-\_\/]+/g) {
        my $match = $&;
        if ($match ne '') {
            if ($enable_dot_split && index($match, '.') != -1) {
                split_by($match, '\.', $list);
            }
            if ($enable_slash_split && index($match, '/') != -1) {
                split_by($match, '/', $list);
            }
            print_if_unique($match, $list);
        }
    }
}

sub split_by {
    my ($text, $delimiter, $list) = @_;
    my @split_strings = split(/$delimiter/, $text);
    foreach my $match (@split_strings) {
        if ($match ne '') {
            print_if_unique($match, $list);
        }
    }
}

sub remove_slash_prefix {
    my ($text) = @_;
    return $remove_slash_prefix ? ($text =~ s{^/+}{}gr) : $text; # Conditionally remove leading slashes
}

sub print_if_unique {
    my ($text, $list) = @_;
    $text = remove_slash_prefix($text);

    # Skip if already seen
    return if exists $list->{$text};

    # Skip if search pattern is set and does not match
    if ($search_pattern && $text !~ /$search_pattern/) {
        return;
    }

    # Print and mark as seen
    say $text;
    $list->{$text} = 1;
}
