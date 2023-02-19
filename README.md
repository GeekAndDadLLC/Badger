# Badger prototype

## Status

This is a prototype that seems to work on PNG files but has only been tested on PNG files.
PRs gladly accepted, or feel free to fork it and customize it to your needs.


## Usage / Notes
You can even chain Badger to add two overlays to your icon:

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
