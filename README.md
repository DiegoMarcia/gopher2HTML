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
&& awk -v title=_TITLE_ -f ./gopher2HTML.awk $gopherFile > $gopherFile.html \
&& open -a Firefox $gopherFile.html \
&& rm $gopherFile
```


## [NOT] Opening gopher links

Thanks to some online resources[^1][^2], I came to this configuration in Firefox:
```
network.protocol-handler.expose.gopher           false
network.protocol-handler.external.gopher         true
network.protocol-handler.warn-external.gopher    false
```
More on these can be found [here](http://kb.mozillazine.org/Network.protocol-handler.expose.%28protocol%29) and in related pages.

Unfortunately, Firefox doesn't let you choose shell scripts (at least, on OSX), not even if you explicitly write down the script path in `~/Library/Application\ Support/Firefox/Profiles/_PROFILE_/handlers.json`.  
You need to package your script as an app[^3]. This suffices to open your script, but is seems the URL doesn't get passed as an argument to it.  
I tried partially following instructions[^4] for an `Info.plist` file like this:
```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>CFBundleURLTypes</key>
    <array>
      <dict>
        <key>CFBundleURLName</key>
        <string>gopher URL</string>

        <key>CFBundleURLSchemes</key>
        <array>
          <string>gopher</string>
        </array>
      </dict>
    </array>
  </dict>
</plist>
```
But it seems some other steps (like registration) would be needed, and it's starting to become too complicated wrt what I initially thought, so I abandoned this task.

Furthermore, there's no straightforward way to open an HTML file in a specific Firefox tab from the shell, so navigation would be too cumbersome.

[^1]: https://askubuntu.com/q/161553
[^2]: https://stackoverflow.com/a/42187354
[^3]: https://stackoverflow.com/a/30792824
[^4]: https://stackoverflow.com/a/471642
