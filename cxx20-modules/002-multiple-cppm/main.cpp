#include <iostream>

import foo;
import bar;

int main() {
  std::cout << "foo::version is " << foo::version() << "\n";
  std::cout << "bar::version is " << bar::version() << "\n";
}
