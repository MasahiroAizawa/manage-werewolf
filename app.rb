# -*- encoding: utf-8 -*-
require 'rubygems'
require 'sinatra'

require 'erb'
require 'less'
require 'coffee-script'

# for debug
require 'pry'

VERSION_NUMBER = 0.62

get '/' do
  erb :index
end

get '/wolf.manifest' do
  content_type "text/cache-manifest.manifest"
  send_file "/wolf.manifest"
end

get '/load_image' do
  erb :load_image
end

get '/*.css' do |file|
  less file.to_sym
end

get '/images/*.*' do |file, ext|
  content_type ext
  send_file "/images/#{file}.#{ext}"
end

get '/javascript/*.js' do |file|
  coffee file.to_sym
end

helpers do
  def version
    "version #{VERSION_NUMBER}"
  end
end

