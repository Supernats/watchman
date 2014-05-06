require 'fileutils'

module Watchman
  include FileUtils

  def fire_updates(schedule, files)
    schedule.each_with_index do |s, i|
      case s
      when -1
        update_repo(files[i])
      when 1
        update_root(files[i])
      end
    end
  end

  def get_diffs(files)
    files.map do |file|
      cmp(relpath + file, file)
    end
  end

  def get_files
    Dir.chdir
    Dir.entries(relpath)
  end

  def get_pruned_files
    prune(get_files)
  end

  def get_update_schedule(diffs, files)
    schedule = Array.new(4, nil)

    diffs.each_with_index do |diff, i|
      if !diff
        comparator = (File.ctime(relpath + files[i]) <=> File.ctime(files[i]))
      else
        comparator = 0
      end
      schedule[i] = comparator
    end
    schedule
  end

  def prune(files)
    files[2..-1].reject { |file| file.match(".git*") }
  end

  def relpath
    "dotfiles/"
  end

  def update_root(file)
    cp(relpath + file, Dir.home)
  end

  def update_repo(file)
    cp(file, Dir.home + relpath)
  end

  def update
    Dir.chdir
    files = get_pruned_files
    diffs = get_diffs(files)
    schedule = get_update_schedule(diffs, files)
    fire_updates(schedule, files)
  end

end
