local ls = require 'luasnip'

local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node

local cuda_check = {
  'static void cuda_check(cudaError_t err, const char *file, int line) {',
  '  if (err != cudaSuccess) {',
  '    fprintf(stderr, "CUDA error %s:%d: %s\\n", file, line, cudaGetErrorString(err));',
  '    exit(EXIT_FAILURE);',
  '  }',
  '}',
  '',
  '#define CUDA_CHECK(call) cuda_check((call), __FILE__, __LINE__)',
}

return {
  s('kernel', {
    t '__global__ void ',
    i(1, 'kernel_name'),
    t '(',
    i(2),
    t { ') {', '  int idx = blockIdx.x * blockDim.x + threadIdx.x;', '  ' },
    i(3),
    t { '', '}' },
  }),

  s('check', {
    t(cuda_check),
    t { '', '' },
    i(1),
  }),

  s('main', {
    t { '#include <cuda_runtime.h>', '#include <stdio.h>', '#include <stdlib.h>', '' },
    t(cuda_check),
    t { '', '', '__global__ void ' },
    i(1, 'kernel_name'),
    t { '() {', '  int idx = blockIdx.x * blockDim.x + threadIdx.x;', '  ' },
    i(2),
    t { '', '}', '', 'int main() {', '  int threads = ' },
    i(3, '256'),
    t { ';', '  int blocks = ' },
    i(4, '1'),
    t { ';', '', '  ' },
    i(5, 'kernel_name'),
    t { '<<<blocks, threads>>>();', '  CUDA_CHECK(cudaGetLastError());', '  CUDA_CHECK(cudaDeviceSynchronize());', '', '  return 0;', '}' },
  }),
}
