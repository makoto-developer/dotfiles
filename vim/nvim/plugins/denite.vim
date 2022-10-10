nnoremap [denite] <Nop>
nmap <C-d> [denite]
nnoremap <silent> [denite]g :<C-u>Denite grep -buffer-name=search-buffer-denite<CR>
nnoremap <silent> [denite]r :<C-u>Denite -resume -buffer-name=search-buffer-denite<CR>
nnoremap <silent> [denite]p :<C-u>Denite file_rec<CR>

call denite#custom#option('default', 'prompt', '>')
call denite#custom#option('_', 'highlight_matched_range', 'None')
call denite#custom#option('_', 'highlight_matched_char', 'None')
call denite#custom#map('insert', "<Tab>", '<denite:move_to_next_line>')
call denite#custom#map('insert', "<S-Tab>", '<denite:move_to_previous_line>')
call denite#custom#map('insert', "<C-t>", '<denite:do_action:tabopen>')
call denite#custom#map('insert', "<C-v>", '<denite:do_action:vsplit>')
call denite#custom#map('normal', "v", '<denite:do_action:vsplit>')
call denite#custom#var('grep', 'command', ['pt', '--follow', '--nogroup', '--nocolor', '--hidden'])
call denite#custom#var('grep', 'default_opts', [])
call denite#custom#var('grep', 'recursive_opts', [])
call denite#custom#var('file_rec', 'command', ['pt', '--follow', '--nocolor', '--nogroup', '--hidden', '-g', ''])

