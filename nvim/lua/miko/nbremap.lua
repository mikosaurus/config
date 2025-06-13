
-- Norwegian keys
vim.keymap.set({'i', 'n', 'v', 'c', 'x', 'l', 's', 'o'}, '¤', '$')

-- Remap $
vim.keymap.set({'n', 'v'}, 'f¤', 'f$')
vim.keymap.set({'n', 'v'}, 'F¤', 'F$')
vim.keymap.set({'n', 'v'}, 'r¤', 'r$')
vim.keymap.set({'n', 'v'}, 't¤', 't$')
vim.keymap.set({'n', 'v'}, 'T¤', 'T$')

-- Remap - to be / when in normal mode for easier searching
vim.keymap.set({'n', 'v' }, '-', '/')

-- Remap {} and []
vim.keymap.set({'i', 'n', 'v'}, 'ø', '{')
vim.keymap.set({'i', 'n', 'v'}, 'æ', '}')
vim.keymap.set({'i', 'n', 'v'}, 'Ø', '[')
vim.keymap.set({'i', 'n', 'v'}, 'Æ', ']')

-- Remaps for { differnt motions
vim.keymap.set({'n', 'v'}, 'tø', 't{')
vim.keymap.set({'n', 'v'}, 'Tø', 'T{')
vim.keymap.set({'n', 'v'}, 'Fø', 'F{')
vim.keymap.set({'n', 'v'}, 'fø', 'f{')
vim.keymap.set({'n', 'v'}, 'rø', 'r{')
vim.keymap.set({'n', 'v'}, 'iø', 'i{')
vim.keymap.set({'n', 'v'}, 'aø', 'a{')

-- Remaps for } differnt motions
vim.keymap.set({'n', 'v'}, 'tæ', 't}')
vim.keymap.set({'n', 'v'}, 'Tæ', 'T}')
vim.keymap.set({'n', 'v'}, 'fæ', 'f}')
vim.keymap.set({'n', 'v'}, 'Fæ', 'F}')
vim.keymap.set({'n', 'v'}, 'ræ', 'r}')
vim.keymap.set({'n', 'v'}, 'iæ', 'i}')
vim.keymap.set({'n', 'v'}, 'aæ', 'a}')

-- Remaps for [ differnt motions
vim.keymap.set({'n', 'v'}, 'tØ', 't[')
vim.keymap.set({'n', 'v'}, 'TØ', 'T[')
vim.keymap.set({'n', 'v'}, 'fØ', 'f[')
vim.keymap.set({'n', 'v'}, 'FØ', 'F[')
vim.keymap.set({'n', 'v'}, 'rØ', 'r[')
vim.keymap.set({'n', 'v'}, 'iØ', 'i[')
vim.keymap.set({'n', 'v'}, 'aØ', 'a[')

-- Remaps for ] differnt motions
vim.keymap.set({'n', 'v'}, 'tÆ', 't]')
vim.keymap.set({'n', 'v'}, 'TÆ', 'T]')
vim.keymap.set({'n', 'v'}, 'fÆ', 'f]')
vim.keymap.set({'n', 'v'}, 'FÆ', 'F]')
vim.keymap.set({'n', 'v'}, 'rÆ', 'r]')
vim.keymap.set({'n', 'v'}, 'iÆ', 'i]')
vim.keymap.set({'n', 'v'}, 'aÆ', 'a]')

