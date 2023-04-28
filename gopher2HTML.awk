# BEGIN block before any line is parsed, useful for inits
BEGIN {
  FS = "\t";    # Field Separator
  RS = "\n";    # Record Separator (no regex in BSD, took me a good hour)

  isMenu = 0;
  isPre = 0;
  if (title == "") { title = ARGV[1]; }
  class = "???";

  # HTML header
  printf\
"<!DOCTYPE html>\
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
  # Since I can't use "\r\n" as a separator, remove all '\r'
  sub("\r", "");
  # Generic HTML entities substitutions
  sub("&", "\\&amp;");
  sub("<", "\\&lt;");
  sub(">", "\\&gt;");
  sub("\"", "\\&quot;");

  # Readable item types
  class = selector_to_class(substr($1, 1, 1));
  validItem = check_line_format();
}


# If the first line is a valid menu item, assume all lines are
NR == 1 {
  isMenu = validItem;
}


# Split item type indicator and display string
isMenu && validItem { 
  $0 = substr($1, 1, 1) FS substr($1, 2) FS $2 FS $3 FS $4;
}


# "Info" menu line
isMenu && validItem && class == "INFO" {
  # Start an HTML preformatted block
  if (! isPre) {
    printf "  <pre>";
    isPre = 1;
  }
  # Print display string only, the rest is gibberish
  printf "%s\n", $2;

  # Skip following rules, go to next line
  next;
}


# Item menu line
isMenu && validItem {
  # Close current preformatted block, if any
  if (isPre) { printf "  </pre>\n"; isPre = 0; }

  # Distinguish web links from others (some other types would need different handling)
  if (class == "HTML" && $3 ~ /^URL:/) { class = "WEB"; href = "http://" substr($3, 5); }
  else { href = "gopher://" $4 ":" $5 $3; }

  # Print link
  printf "  <a class=\"%s\" href=\"%s\">%s</a><br>\n", class, href, $2; 
}


# A menu has been detected, but current line is not a valid menu item
isMenu && ! validItem {
  # By specification, last line is a full stop
  if ($0 == "." && getline == 0) { exit 0; }
  else { exit 1; }
}


# No menu detected, assume plaintext
! isMenu {
  printf "  <pre>";
  do
    print;
  while (getline > 0) # put each next line in $0 until EOF
  printf "  </pre>\n";
}


# END block after all lines have been parsed
END {
  if (isPre) { printf "  </pre>\n" }
  printf \
" </body>\
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
  if (c == "i") { return "INFO"; }
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


function check_line_format() {
  return NF == 4 && class != "???" && $4 ~ /[0-9]+/
}
