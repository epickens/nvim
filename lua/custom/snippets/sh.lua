local ls = require 'luasnip'
local fmt = require('luasnip.extras.fmt').fmt

local s = ls.snippet
local i = ls.insert_node

return {
  s(
    'sbatch',
    fmt(
      [[
#!/usr/bin/env bash
#SBATCH --job-name=<>
#SBATCH --output=logs/%x-%j.out
#SBATCH --error=logs/%x-%j.err
#SBATCH --time=<>
#SBATCH --cpus-per-task=<>
#SBATCH --mem=<>
#SBATCH --partition=<>

set -euo pipefail

module purge
<>

uv run <>
]],
      {
        i(1, 'job-name'),
        i(2, '01:00:00'),
        i(3, '1'),
        i(4, '4G'),
        i(5, 'standard'),
        i(6, 'module load python'),
        i(7, 'python script.py'),
      },
      { delimiters = '<>' }
    )
  ),

  s(
    'sarray',
    fmt(
      [[
#SBATCH --array=<>

task_id="${SLURM_ARRAY_TASK_ID}"
<>
]],
      {
        i(1, '0-9'),
        i(2, 'uv run python script.py --task-id "${task_id}"'),
      },
      { delimiters = '<>' }
    )
  ),

  s(
    'srunpy',
    fmt(
      [[
srun --cpus-per-task=<> --mem=<> --time=<> --pty bash -lc '<>'
]],
      {
        i(1, '1'),
        i(2, '4G'),
        i(3, '01:00:00'),
        i(4, 'uv run python'),
      },
      { delimiters = '<>' }
    )
  ),
}
