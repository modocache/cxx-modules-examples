export module foo;

import "bar.h";

namespace foo {
  export const char *version() {
    return FIVE;
  }
}
