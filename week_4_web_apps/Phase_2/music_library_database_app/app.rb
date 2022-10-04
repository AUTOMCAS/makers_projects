# file: app.rb
require 'sinatra'
require "sinatra/reloader"
require_relative 'lib/database_connection'
require_relative 'lib/album_repository'
require_relative 'lib/artist_repository'

DatabaseConnection.connect

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
    also_reload 'lib/album_repository'
    also_reload 'lib/artist_repository'
  end

  get '/albums' do
    album_repo = AlbumRepository.new
    @albums = album_repo.all
  
    return erb(:albums)
  end

  get "/albums/:id" do
    repo = AlbumRepository.new
    artist_repo = ArtistRepository.new
    repo.all
    artist_repo.all
    @album = repo.find(params[:id])

    @artist = artist_repo.find(@album.artist_id)
    
    return erb(:index)
  end

  post '/albums' do
    title = params[:title]
    release_year = params[:release_year]
    artist_id = params[:artist_id]

    repo = AlbumRepository.new
    new_album = Album.new
    new_album.title = title
    new_album.release_year = release_year
    new_album.artist_id = artist_id

    repo.create(new_album)

    return nil
  end

  get '/artists' do
    repo = ArtistRepository.new
    @artists = repo.all

    return erb(:artists2)
  end

  get "/artists/:id" do
    repo = ArtistRepository.new
    repo.all

    @artist = repo.find(params[:id])
    return erb(:artists)
  end

  post '/artists' do
    name = params[:name]
    genre = params[:genre]

    repo = ArtistRepository.new

    new_artist = Artist.new
    new_artist.name = name
    new_artist.genre = genre

    repo.create(new_artist)

    return nil
  end

  get '/albums/:id' do
    album_repo = AlbumRepository.new

    album_repo.all
    @album = album_repo.find(params[:id])
  
    artist_repo = ArtistRepository.new
    @artist = artist_repo.find(@album.artist_id)
    
    return erb(:index)
  end


end