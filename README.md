# Badger prototype

## Status

This is a prototype that seems to work on PNG files but has only been tested on PNG files.
PRs gladly accepted, or feel free to fork it and customize it to your needs.


## Usage / Notes

### Example script to get current HEAD sha and use that as the badge when calling Badger:

```
#/bin/env sh

# Assumes working dir is root directory of the project and that it's using git SCM
# Assumes badger is in your execution path somewhere
badger `git rev-parse --short=7 HEAD` -i ~/Desktop/ICON_BASE.png -o ~/Desktop/ICON.png
```

This could be used as the basis of an Xcode Run Script Build Phase that runs before
 resources are compiled. May want to the Xcode Build Script environment variable
 `PROJECT_DIR` and git's `-C` option to execute git at the root of the project, so
  something like:

```
#/bin/env sh

# Assumes badger is in your execution path somewhere

theSHA=`git -C "${PROJECT_DIR}" rev-parse --short=7 HEAD`
badger $theSHA -i "~/${SRCROOT)/<path-to>/ICON_BASE.png -o ~/${DERIVED_FILE_DIR)/<path-to>/ICON.png
```

`DERIVED_FILE_DIR` is a thought, but probably isn't correct.  One possibility is to modify 
the built app at the end (using `TARGET_BUILD_DIR` or `CONFIGURATION_BUILD_DIR`) just 
before you code-sign it (I think that's what we did on the last project I did badging on, 
but that was doing manual code-signing which is less common now).

### Chaining to add multiple badges

You can even chain Badger to add two overlays to your icon by running it twice - using the
output of the first time as the input of the second time:

```
./badger 0x2023A -i ~/Desktop/Otter.png -o ~/Desktop/Otter_out.png -f Chalkboard
./badger 1.0b2 -i ~/Desktop/Otter_out.png -o ~/Desktop/Otter_out2.png -s 48 -y 230
open -g ~/Otter_out2.png 
```

The first line adds "0x2023A" at the bottom in Chalkboard font at the default font size.
The second line adds "1.0b2" in the default font (Courier) at 48 point up at the top.


## Parameters and options:

```
% ./badger --help                                                                                                                
USAGE: badger <badge-string> --input-file <input-file> --output-file <output-file> [--font-name <font-name>] [--size <size>] [--x-offset <x-offset>] [--y-offset <y-offset>] [--verbose]

ARGUMENTS:
  <badge-string>          The string to draw over the image; a short, non-empty string is required)

OPTIONS:
  -i, --input-file <input-file>
                          The image file path for the icon
  -o, --output-file <output-file>
                          The file path to save the output to
  -f, --font-name <font-name>
                          Name of the font to use; default is Courier. Optional (default: Courier)
  -s, --size <size>       Size of font to use. default is 24. Optional (default: 24.0)
  -x, --x-offset <x-offset>
                          text position x coordinate. Optional. (default: 10.0)
  -y, --y-offset <y-offset>
                          text position y coordinate. Optional. (default: 10.0)
  -v, --verbose           extra logging
  -h, --help              Show help information.
  ```

# License

MIT License
