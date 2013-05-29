#!/usr/bin/env ruby

# Author: Mina Nagy Zaki <mnzaki [AT] gmail.com>
# Usage: ./git-max-changes.rb <file1> [file2 file3 ...]
# This script will list the author who made the maximum changes to each <file>
# With '-l' as the first argument, this will orient the output per author

require 'set'

case ARGV[0]
when '-h', '--help'
  $stderr.puts "Usage: #{__FILE__} <file1> [file2 file3 ...]"
  exit
when '-l'
  files = ARGV.drop(1)
  stat_type = :files_per_author
else
  files = ARGV
  stat_type = :max_author
end

stats = {}

full_names = files.map { |f| "'#{f}'" }
full_names = `git ls-files --full-name #{files.join ' '}`.split "\n"

max_file_len = full_names.max_by { |f| f.length }.length
max_file_len = 70 if max_file_len > 70

cmd = "git log --no-merges --pretty=format:%ae --stat=999 -- #{files.join " "}"
#puts "Running #{cmd}"
changes = `#{cmd}`.split "\n"

all_authors = Set.new
cur_auth = ""

changes.each do |change|
  file, sep, count = change.split
  if sep == '|' && count != 'Bin' && full_names.include?(file)
    stats[file] ||= {}
    stats[file][cur_auth] ||= 0
    stats[file][cur_auth] += count.to_i
  elsif change =~ /@/ # this is an author line
    cur_auth = change
    all_authors.add cur_auth
  end
end

max_author_len = all_authors.max_by { |a| a.length }.length

case stat_type
when :max_author
  stats.each do |file, authors|
    max_author = authors.max_by { |k, v| v }[0]
    puts file.ljust(max_file_len) + ' ' * 10 + max_author.ljust(max_author_len) + authors[max_author].to_s
  end
when :files_per_author
  stats_per_author = {}
  stats.each do |file, authors|
    max_author = authors.max_by { |k, v| v }[0]
    stats_per_author[max_author] ||= []
    stats_per_author[max_author].push ' ' * 4 + file.ljust(max_file_len) + ' ' * 4 + authors[max_author].to_s
  end

  stats_per_author.each do |author, author_changes|
    puts author
    puts author_changes.join "\n"
    puts
  end
end
