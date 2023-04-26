local M = {}

function M.setup()
    local npairs = require "nvim-autopairs"

    npairs.setup {
        check_ts = true,
    }

    npairs.add_rules(require "nvim-autopairs.rules.endwise-lua")

    local cmp_autopairs = require "nvim-autopairs.completion.cmp"
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done { map_char = { tex = "" } })
end


return M
