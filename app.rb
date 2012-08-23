# -*- encoding: utf-8 -*-
require 'rubygems'
require 'sinatra'

require 'erb'
require 'less'
require 'coffee-script'

# for debug
require 'pry'

VERSION_NUMBER = 0.3

get '/' do
  @players = Player.create_players

  erb :index
end

get '/index.css' do
  less :index
end

get '/images/*.*' do |file, ext|
  content_type ext
  send_file "/images/#{file}.#{ext}"
end

get '/javascript/wolf.js' do
  coffee :wolf
end

helpers do
  def version
    "version #{VERSION_NUMBER}"
  end
end


class Player
  attr_accessor :no, :name, :file

  def initialize(path)
    case path
    when "bear.gif"
      set_params("01", "くまー", path)
    when "bird.gif"
      set_params("02", "とり", path)
    when "buchi.gif"
      set_params("03", "ぶっち", path)
    when "dack.gif"
      set_params("04", "あひる", path)
    when "fox.gif"
      set_params("05", "ふぉっくす", path)
    when "frog.gif"
      set_params("06", "かえる", path)
    when "kame.gif"
      set_params("07", "かめ", path)
    when "kuro.png"
      set_params("08", "くろ", path)
    when "panda.gif"
      set_params("09", "ぱんだ", path)
    when "pen.gif"
      set_params("10", "ぺんぎん", path)
    when "piyo.gif"
      set_params("11", "ぴよぴよ", path)
    when "sika.gif"
      set_params("12", "こじか", path)
    when "siro.gif"
      set_params("13", "しろ", path)
    when "usa.gif"
      set_params("14", "うさ", path)
    end

    self
  end

  def self.create_players
    %w[bear.gif bird.gif buchi.gif dack.gif fox.gif frog.gif kame.gif kuro.png panda.gif pen.gif piyo.gif sika.gif siro.gif usa.gif].map do |pic|
      Player.new(pic)
    end
  end

  private
  def set_params(no, name, file)
    @no = no
    @name = name
    @file = file
  end
end
