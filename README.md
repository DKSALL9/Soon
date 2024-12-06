# Soon
 This Perl script processes standard input, splits words or phrases by dots (.) and slashes (/), and removes leading slashes if necessary. The script allows customization of its behavior through command-line options and ensures that only unique substrings (based on the specified search pattern) are printed.

# Install
```
git clone https://github.com/DKSALL9/Soon.git
```

# Usage
```
Usage: perl script.pl [options]
Options:
  --buffer-size=<size>         Set the buffer size in bytes (default: 30 MB)
  --disable-dot-split          Disable splitting by dot (.)
  --disable-slash-split        Disable splitting by slash (/)
  --no-remove-slash-prefix     Do not remove leading slashes from strings
  --search=<pattern>           Print only lines or substrings matching the given regex
  --help                       Show this help message
```
