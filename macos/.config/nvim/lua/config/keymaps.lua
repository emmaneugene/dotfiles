-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Shift + arrow keys to select in any mode
-- Normal mode
vim.keymap.set('n', '<S-Up>', 'v<Up>', { noremap = false })
vim.keymap.set('n', '<S-Down>', 'v<Down>', { noremap = false })
vim.keymap.set('n', '<S-Left>', 'v<Left>', { noremap = false })
vim.keymap.set('n', '<S-Right>', 'v<Right>', { noremap = false })
-- Visual mode
vim.keymap.set('v', '<S-Up>', '<Up>', { noremap = false })
vim.keymap.set('v', '<S-Down>', '<Down>', { noremap = false })
vim.keymap.set('v', '<S-Left>', '<Left>', { noremap = false })
vim.keymap.set('v', '<S-Right>', '<Right>', { noremap = false })
-- Insert mode
vim.keymap.set('i', '<S-Up>', '<Esc>v<Up>', { noremap = false })
vim.keymap.set('i', '<S-Down>', '<Esc>v<Down>', { noremap = false })
vim.keymap.set('i', '<S-Left>', '<Esc>v<Left>', { noremap = false })
vim.keymap.set('i', '<S-Right>', '<Esc>v<Right>', { noremap = false })
