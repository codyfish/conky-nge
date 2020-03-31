# conky-nge

## Installation
Install conky with lua support, e.g. if you are using Archlinux `conky-lua` from the aur. Note that for some reason the mpd panel does not work in version 1.11.5

## Usage 
Copy the files in `.config/conky` and start `conky`. In order to debug, it is usefull to start it without the `-d` (daemonize) option and restart it sometimes completely even though it should reload config files automatically.

## Configuration
Set `minimum_height` and `minimum_width` to your screen height and width in `conky.conf`. The rest is done in `nge.lua`:

### Arranging hexagons

You can arrange the hexagons displaying information using following grid pattern:
```
	< 0,0 >---< 0,1 >---< 0,1 >	
	  ---< 1,0 >---< 1,1 >---
	< 2,0 >---< 2,1 >---< 2,2 >
```

The methods in the first method section take those coordinates and call the methods from the implementation section. 


### Style and fonts

Style and fonts are set in `tables` and then passed to the according functions.



## Disclaimer 

The code is probably really ugly.
Names, characters, businesses, places, events, locales, and incidents are either the products of the author's imagination or used in a fictitious manner. And any resemblance to actual and fictional persons, living or dead, or actual and fictional events is purely coincidental

 
