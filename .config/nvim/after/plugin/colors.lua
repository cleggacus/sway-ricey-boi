function ColorMyPencils(color)
	color = color or "dracula"
	vim.cmd.colorscheme(color)
end

ColorMyPencils()
