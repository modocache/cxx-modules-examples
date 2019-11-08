#include <iostream>
// When Clang lexes this include, it determines that "foo.h" is a header
// that is defined as being part of the module 'foo-module'. It executes
// a subprocess that then compiles the 'foo-module' module.
#include "foo.h"

int main() {
  std::cout << FOO_VERSION << "\n";
}
