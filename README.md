dependencies:
  - neovim (v10?)
  - [clangd](https://clangd.llvm.org/installation)
  - build-essential (c/c++ compilers)
  - clang-tidy
  - [Node.js (prob >18.something)](https://nodejs.org/en/download/package-manager/)
      ```bash
      # Download and install n and Node.js:
      curl -fsSL https://raw.githubusercontent.com/mklement0/n-install/stable/bin/n-install | bash -s 22
      
      # Node.js already installs during n-install, but you can also install it manually:
      #   n install 22
      
      # Verify the Node.js version:
      node -v # Should print "v22.15.0".
      
      # Verify npm version:
      npm -v # Should print "10.9.2".
    ```
  - git-auto-sync (for automatic *.md file syncing)
    * OSX - `brew install GitJournal/tap/git-auto-sync`
    * Linux (Ubuntu)
    
        ```bash
        sudo echo "deb [trusted=yes] https://apt.fury.io/vhanda/ /" | sudo tee /etc/apt/sources.list.d/git-auto-sync.list
        sudo apt-get update
        sudo apt-get install -y git-auto-sync
        ```



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
