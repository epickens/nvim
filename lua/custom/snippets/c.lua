local ls = require 'luasnip'

local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node

return {
  s('main', {
    t { '#include <stdio.h>', '', 'int main(int argc, char **argv) {', '  ' },
    i(1, 'printf("hello\\n");'),
    t { '', '  return 0;', '}' },
  }),
}
