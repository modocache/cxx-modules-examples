# Examples of using various Clang/C++ modules flavors

The tests in the Clang test suite are nice, but sometimes they're too modular
(e.g.: one only tests the driver logic, another just tests compiling an object
file, etc.).

This repository contains a bunch of small end-to-end examples of building and
importing modules. You can build all of them by running `make`. (You'll probably
need to specify the path to your Clang, so `make CC=/path/to/clang++`.)

This repository is mainly for my own use, though.
