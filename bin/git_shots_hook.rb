#!/usr/bin/ruby
#-*-ruby-*-
# A script to run takes git shots on every commit. Can be run on
# the current dir, called from a git callback, or install itself as a
# git post-commit callback.

require "fileutils"

HOOKS = %w{post-commit}
HOOKS_DIR = '.git/hooks'

def ensure_git_repo
  if !File.writable?(HOOKS_DIR)
    $stderr.print "The install option [-i] can only be used within a git repo; exiting.\n"
    exit 1
  end
end

def install
  ensure_git_repo
  HOOKS.each { |hook| install_hook("#{HOOKS_DIR}/#{hook}") }
end

def reinstall
  ensure_git_repo
  HOOKS.each { |hook| delete_hook("#{HOOKS_DIR}/#{hook}") }
  install
end

def take_shot(dir, run_in_background = false)
  year = Time.now.strftime('%Y')
  month = Time.now.strftime('%m')
  FileUtils.mkdir_p("#{ENV['HOME']}/Dropbox/Photos/gitshots/#{year}/#{month}")
  file = "~/Dropbox/Photos/gitshots/#{year}/#{month}/#{Time.now.strftime('%Y%m%d%H%M%S')}.jpg"
  unless File.directory?(File.expand_path("../../rebase-merge", __FILE__))
    puts "Taking capture into #{file}!"
    system "imagesnap -q -w 3 #{file} &"
  end
end

def delete_hook(hook)
  File.delete(hook) if File.exists?(hook)
end

def install_hook(hook)
  if File.exists?(hook)
    $stderr.print "A file already exists at #{hook}, and will NOT be replaced.\n"
    return
  end

  print "Linking #{__FILE__} to #{hook}\n"
  %x{ln -s #{__FILE__} #{hook}}
end

if ARGV.first == '-i'
  install
elsif ARGV.first == '-r'
  reinstall
else
  take_shot Dir.pwd, HOOKS.include?(File.basename(__FILE__))
end
