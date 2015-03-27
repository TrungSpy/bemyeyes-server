require 'rubygems'
require 'sinatra'
root = File.expand_path('../', __FILE__)
$:.unshift root unless $:.include?(root)
require File.expand_path '../app.rb', __FILE__

run App.new
