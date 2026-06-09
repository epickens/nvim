local ls = require 'luasnip'

local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node

return {
  s('main', {
    t { '#include <iostream>', '', 'int main(int argc, char **argv) {', '  ' },
    i(1, 'std::cout << "hello\\n";'),
    t { '', '  return 0;', '}' },
  }),

  s('class', {
    t 'class ',
    i(1, 'Name'),
    t { ' {', 'public:', '  ' },
    i(2, 'Name'),
    t { '() = default;', '', 'private:', '  ' },
    i(3),
    t { '', '};' },
  }),
}
