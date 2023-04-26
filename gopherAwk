# BEGIN block before any line is parsed, useful for inits
BEGIN {
  FS = "\t";    # Field Separator
  RS = "\r";    # Record Separator (no regex in BSD, took me a good hour)

  isMenu = 0;
  isPre = 0;
  if (title == "") { title = ARGV[1]; }

  # HTML header
  printf "<!DOCTYPE html>\
<html lang=\"en\">\
 <head>\
  <meta http-equiv=\"Content-Type\" content=\"text/html;charset=UTF-8\">\
  <title>%s</title>\
  <style>\
   a.TEXT::before { content: \"\\1F4C4\"; }\
   a.MENU::before { content: \"\\1F5C2\"; }\
   a.SEARCH::before { content: \"\\1F50D\"; }\
   a.WEB::before { content: \"\\1F310\"; }\
  </style>\
 </head>\
 <body>\n", title;
}


# No expression means always execute
{
  # Since I can't use "\r\n" as a separator, remove all '\n'
  sub("\n", "");
  # Generic HTML entities substitutions
  sub("&", "\\&amp;");
  sub("<", "\\&lt;");
  sub(">", "\\&gt;");
  sub("\"", "\\&quot;");
}


# Check if the line looks like a menu item
NF == 4 && $1 ~ /..+/ && $4 ~ /[0-9]+/ {
  # If it was also the first line, we're most likely parsing a menu
  if (NR == 1) { isMenu = 1; }

  # Split item type indicator and display string
  if (isMenu == 1) {
    $0 = substr($1, 1, 1) "\t" substr($1, 2) "\t" $2 "\t" $3 "\t" $4;
  }
}


# "Info" menu line
NF == 5 && $1 ~ /i/ && isMenu == 1 {
  # Start an HTML preformatted block
  if (isPre == 0) {
    printf "  <pre>" ;
    isPre = 1;
  }
  # Print display string only, the rest is gibberish
  printf "%s\n", $2;

  # Skip following rules, go to next line
  next;
}


# Item menu line
NF == 5 && isMenu == 1 {
  # Close previous preformatted block, if any
  if (isPre == 1) { printf "  </pre>\n"; isPre = 0; }

  # Fancy styling for different item types
  class = selector_to_class($1);

  # Distinguish web links from others (some other types would need different handling)
  if (class == "HTML" && $3 ~ /^URL:/) { class = "WEB"; href = "http://" substr($3, 5); }
  else { href = "gopher://" $4 ":" $5 $3; }

  # Print link
  printf "  <a class=\"%s\" href=\"%s\">%s</a><br>\n", class, href, $2; 
}


# The line has not been detected as a menu item, assume plaintext
isMenu == 0 {
  if (isPre == 0) {
    printf "  <pre>" ;
    isPre = 1;
  }
  print;
}


# END block after all lines have been parsed
END {
  if (isPre == 1) { printf "  </pre>\n" }
  printf " </body>\
</html>\n";
}


# Fancy styling for different item types
function selector_to_class(c) {
  if (c == 0) { return "TEXT"; }
  if (c == 1) { return "MENU"; }
  if (c == 2) { return "CCSO"; }
  if (c == 3) { return "ERR"; }
  if (c == 4) { return "BINHEX"; }
  if (c == 5) { return "DOS"; }
  if (c == 6) { return "UUCP"; }
  if (c == 7) { return "SEARCH"; }
  if (c == 8) { return "TELNET"; }
  if (c == 9) { return "BIN"; }
  if (c == "+") { return "MIRR"; }
  if (c == "g") { return "GIF"; }
  if (c == "I") { return "IMG"; }
  if (c == "T") { return "TN3270"; }
  if (c == ":") { return "BITMAP"; }
  if (c == ";") { return "MOVIE"; }
  if (c == "<") { return "SOUND"; }
  if (c == "d") { return "DOC"; }
  if (c == "h") { return "HTML"; }
  if (c == "p") { return "PNG"; }
  if (c == "r") { return "RTF"; }
  if (c == "s") { return "WAV"; }
  if (c == "P") { return "PDF"; }
  if (c == "X") { return "XTML"; }
  return "???";
}
