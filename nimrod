#!/usr/bin/env ruby

#
# Author: Ch0c0late
# Date: Aug. 29 2015
#
# nimrod
#

require File.expand_path "." + "/source+"
require 'pathname'

man = <<-Block
  nimrod - Hunt source code files.

  Search through given directory and finds source code files
  with given extension.  

  Synopsis

    nimrod directory_path source_code_file_extension
Block

class DirectoryStore
  attr_accessor :directories

  def initialize directories = []
      raise "Wrong argument given. Expected Array, given #{directories.class}." if Array != directories.class
      
      @directories = directories
  end
end

def nimrod
  directory_store, extension = DirectoryStore.new(Array ARGV[0]), ARGV[1]

  hunt_n_bark = lambda do |directory|
    entries   = Pathname(directory).each_child.flat_map { |entry| entry }

    dirs                         = entries.select { |file| File.directory? file } - ["..", "."]
    directory_store.directories += dirs
    
    files   = (entries - dirs).select { |file| (File.extname file).delete(".") == extension }

    files.map { |source_code| bark source_code }
    
    return if [] == directory_store.directories
    
    hunt_n_bark.call directory_store.directories.shift
  end

  hunt_n_bark.call directory_store.directories.shift
end

abort(man) if ARGV.count < 2

nimrod
