# gopher to HTML

Retrieving resources or menus via Gopher and showing them as HTML.

Mostly useless exercise since on OSX mapping weblinks to a shell script seems to be impossible (maybe for the better).  
Anyway, this allowed me to get past theoretical knowledge of `awk`.


## How to use this awk progfile

Don't.  
Seriously, apart from being useless, this file has not been tested.


## How this awk progfile could be used

1. Create a temporary file wherever you please. This is not strictly necessary.  
2. Use netcat (`nc`) to get the gopher resource on the tempfile (`curl` >7.21.2-DEV supports gopher URIs, too).
3. Use `awk` with the progfile. You can also set the `title` var.
4. Open the HTML output in a browser.

```
gopherFile=$(mktemp /tmp/gopher2html.X) \
&& printf "_RESOURCE_\r\n" | nc _SERVER_ _PORT_ > $gopherFile \
&& awk -v title=_TITLE_ -f ./gopherAwk $gopherFile > $gopherFile.html \
&& open -a Firefox $gopherFile.html \
&& rm $gopherFile```
