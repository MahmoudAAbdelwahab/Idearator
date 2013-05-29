#!/usr/bin/env ruby

# Author: Mina Nagy Zaki <mnzaki [AT] gmail.com>
# Usage: ./git-autho-changes.rb <author> <file1> [file2 file3 ...]
# This script will list the the total changes made by <author> to each <file>

author = ARGV[0]
files = ARGV.drop(1)

if author.nil?
  $stderr.puts "Usage: #{__FILE__} <author> <file1> [file2 file3 ...]"
  exit
end

stats = {}

full_names = files.map { |f| "'#{f}'" }
full_names = `git ls-files --full-name #{files.join ' '}`.split "\n"

max_len = full_names.max_by { |f| f.length }.length
max_len = 70 if max_len > 70

cmd = "git log --no-merges --author=#{author} --pretty=format: --stat=999 -- #{files.join " "}"
#puts "Running #{cmd}"
changes = `#{cmd}`.split "\n"

changes.each do |change|
  file, sep, count = change.split
  if sep == '|' && count != 'Bin' && full_names.include?(file)
    stats[file] ||= 0
    stats[file] += count.to_i
  end
end

stats.each do |file, change|
  puts file.ljust(max_len) + " " * 10 + change.to_s
end
