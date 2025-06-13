
function ColorMyPencils(color)
        color = color or "catppuccin-macchiato"
        vim.cmd.colorscheme(color)

        vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
        vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
        vim.api.nvim_set_hl(0, "NotifyBackground", { bg = "#000000" })


end

return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		config = function()
			require('catppuccin').setup({
				transparent_background = true
			})
			ColorMyPencils()
		end
	}  
}


