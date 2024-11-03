dependencies:
  - clangd
  - clang-tidy
  - Node.js (prob >18.something)



clangd and clang-tidy look in build folder (from root) for compile_commands.json in order to propery build syntax tree.
Thus, make sure to generate a compile_commands.json there.

common keybindings:
<leader>d for diagnostics
K for hover info
<leader>cc for copilot chat
<leader><Tab> for toggle copilot inline suggestions
<leader>f for find file (telescope)
<leader>fr for find recent file (telescope)
<leader>fb for find open buffer (telescope)
<leader>g for live grep
