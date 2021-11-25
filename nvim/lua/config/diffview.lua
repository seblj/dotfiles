---------- DIFFVIEW ----------

require('diffview').setup({
    enhanced_diff_hl = true,
})

-- Changes DiffChange and DiffText to be highlighted as DiffDelete
-- in the left buffer and highlighted as DiffAdd in the right buffer
local StandardView = require('diffview.views.standard.standard_view').StandardView
function StandardView:post_layout()
    local curhl = vim.wo[self.left_winid].winhl
    self.winopts.left.winhl = table.concat({
        'DiffAdd:DiffviewDiffAddAsDelete',
        'DiffDelete:DiffviewDiffDelete',
        'DiffChange:DiffDelete',
        'DiffText:DiffDelete',
        curhl ~= '' and curhl or nil,
    }, ',')

    curhl = vim.wo[self.right_winid].winhl
    self.winopts.right.winhl = table.concat({
        'DiffDelete:DiffviewDiffDelete',
        'DiffChange:DiffAdd',
        'DiffText:DiffAdd',
        curhl ~= '' and curhl or nil,
    }, ',')
end
