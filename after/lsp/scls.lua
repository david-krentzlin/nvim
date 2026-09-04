return {
  cmd = { 'simple-completion-language-server' },
  filetypes = { 'markdown', 'org' },
  root_markers = { '.git' },
  settings = {
    feature_words = true,
    feature_snippets = true,
    snippets_first = true,
    case_sensitive = false,
    snippets_inline_by_word_tail = false,
    feature_unicode_input = false,
    feature_paths = false,
    feature_citations = false,
  },
}
