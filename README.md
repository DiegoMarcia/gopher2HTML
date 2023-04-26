# gopher to HTML

Retrieving resources or menus via Gopher and showing them as HTML.

Mostly useless exercise since on OSX mapping weblinks to a shell script seems to be impossible (maybe for the better).  
Anyway, this allowed me to get past theoretical knowledge of `awk`.


## How to use this awk progfile

Don't.  
Seriously, apart from being useless, this file has not been tested.


## How this awk progfile could be used

```
gopherFile=$(mktemp /tmp/gopher2html.X) \
&& printf "_RESOURCE_\r\n" | nc _SERVER_ _PORT_ > $gopherFile \
&& awk -v title=_TITLE_ -f ./gopherAwk $gopherFile > $gopherFile.html \
&& open -a Firefox $gopherFile.html \
&& rm $gopherFile```
