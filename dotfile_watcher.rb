entries = prune(get_entries)


def prune(entries)
  entries[2..-1].reject { |entry| entry.match(".git*") }
end

def get_entries
  Dir.chdir
  Dir.entries('dotfiles')
end
