export module foo;

import "bar/bar.h";

namespace foo {
  export const char *version() {
    return FIVE;
  }
}
