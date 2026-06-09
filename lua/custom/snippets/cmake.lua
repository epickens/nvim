local ls = require 'luasnip'
local fmt = require('luasnip.extras.fmt').fmt

local s = ls.snippet
local i = ls.insert_node

return {
  s(
    'cpp',
    fmt(
      [[
cmake_minimum_required(VERSION 3.20)
project(<> LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

add_executable(<> <>)
]],
      {
        i(1, 'project_name'),
        i(2, 'main'),
        i(3, 'src/main.cpp'),
      },
      { delimiters = '<>' }
    )
  ),

  s(
    'cuda',
    fmt(
      [[
cmake_minimum_required(VERSION 3.24)
project(<> LANGUAGES CXX CUDA)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CUDA_STANDARD 17)
set(CMAKE_CUDA_STANDARD_REQUIRED ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

add_executable(<> <>)
set_target_properties(<> PROPERTIES CUDA_ARCHITECTURES native)
]],
      {
        i(1, 'cuda_project'),
        i(2, 'main'),
        i(3, 'src/main.cu'),
        i(4, 'main'),
      },
      { delimiters = '<>' }
    )
  ),
}
