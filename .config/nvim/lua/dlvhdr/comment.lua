local status_ok, comment = pcall(require, "Comment")
if not status_ok then
  return
end

comment.setup({
  pre_hook = function(ctx)
    -- Only calculate commentstring for tsx filetypes
    if vim.bo.filetype ~= "typescriptreact" then
      return
    end

    local U = require("Comment.utils")

    -- Detemine whether to use linewise or blockwise commentstring
    local type = ctx.ctype == U.ctype.line and "__default" or "__multiline"

    -- Determine the location where to calculate commentstring from
    local location = nil
    if ctx.ctype == U.ctype.block then
      location = require("ts_context_commentstring.utils").get_cursor_location()
    elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
      location = require("ts_context_commentstring.utils").get_visual_start_location()
    end

    return require("ts_context_commentstring.internal").calculate_commentstring({
      key = type,
      location = location,
    })
  end,
})
