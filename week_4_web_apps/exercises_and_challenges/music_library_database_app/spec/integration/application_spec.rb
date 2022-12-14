require "spec_helper"
require "rack/test"
require_relative '../../app'

def reset_albums_table
  seed_sql = File.read('spec/seeds/albums_seeds.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_test' })
  connection.exec(seed_sql)
end

describe Application do
  before(:each) do 
    reset_albums_table
    reset_artists_table
  end

  include Rack::Test::Methods
  let(:app) { Application.new }

  context 'GET /albums' do
    it 'should return the list of albums' do
      response = get('/albums')

      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Albums</h1>')
      expect(response.body).to include('Title: Doolittle')
      expect(response.body).to include("<a href='/albums/1'>Link to the album's page</a>")
      expect(response.body).to include('Title: Surfer Rosa')
      expect(response.body).to include("<a href='/albums/2'>Link to the album's page</a>")
    end
  end

  describe 'new album form' do
    context 'GET /albums/new' do
      it 'returns form page' do
        response = get('/albums/new')

        expect(response.status).to eq(200)
        expect(response.body).to include('<h1>Add an album</h1>')
        expect(response.body).to include('<form action="/albums" method="POST">')
      end
    end

    context 'POST /albums' do
      it 'returns a success page' do
        response = post('/albums', title: "Voyage" , release_year: "2022", artist_id: "2")

        expect(response.status).to eq(200)
        expect(response.body).to include('<h1>Album added</h1>')
      end

      it 'responds with 400 status if parameters are invalid' do
        response = post('/albums', title: "title" , release_yea: "2", artist_id: "2")
        expect(response.status).to eq(400)
      end
    end
  end

  describe 'new artist form' do
    context 'GET /artists/new' do
      it 'returns form page' do
        response = get('/artists/new')

        expect(response.status).to eq(200)
        expect(response.body).to include('<h1>Add an artist</h1>')
        expect(response.body).to include('<form action="/artists" method="POST">')
      end
    end

    context 'POST /artists' do
      it 'returns success page' do
        response = post('/artists', name: "Art", genre: "rock")

        expect(response.status).to eq(200)
        expect(response.body).to include('<h1>Artist added</h1>')
      end
    end

    it 'responds with 400 status if parameters are invalid' do
      response = post('/artists', name: "title" , genr: "2")

      expect(response.status).to eq(400)
    end
  end
  
  context 'POST /albums' do
    it "creates an album" do
      response = post('/albums', title: "Voyage" , release_year: "2022", artist_id: "2")

      albums = get('/albums')
      result = albums.body.include?("Voyage")

      expect(response.status).to eq(200)
      expect(result).to eq true
    end
  end

  context 'GET /artists' do
    it 'should return a list of artists with a link to the artist\'s page' do
      response = get('/artists')

      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Artists</h1>')
      expect(response.body).to include('Name: Pixies')
      expect(response.body).to include("<a href='/artists/1'>Link to artist's page</a>")

      expect(response.body).to include('Name: ABBA')
      expect(response.body).to include("<a href='/artists/2'>Link to artist's page</a>")
    end
  end  

  context 'POST /artists' do
    it 'creates a new artist with given parameters' do
      response = post('/artists', name: 'Wild nothing', genre: 'Indie')

      artists_list = get('/artists')
      title_presence_check = artists_list.body.include?('Wild nothing')
      
      expect(response.status).to eq(200)
      expect(title_presence_check).to eq true
    end
  end


  
  context 'GET /albums/:id' do
    it 'gets information for album with id 1' do
      response = get('/albums/1')

      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Doolittle</h1>')
      expect(response.body).to include('Release year: 1989')
      expect(response.body).to include('Artist: Pixies')
    end

    it "gets information about the album with id 2" do
      response = get('/albums/2')

      expect(response.body).to include('<h1>Surfer Rosa</h1>')
      expect(response.body).to include('Release year: 1988')
      expect(response.body).to include('Artist: Pixies')      
    end
  end

  context 'GET /artists/:id' do
    it 'gets information for artist with id 1' do
      response = get('/artists/1')

      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Pixies</h1>')
      expect(response.body).to include('Genre: Rock')
    end
    it 'gets information for artist with id 1' do
      response = get('/artists/2')

      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>ABBA</h1>')
      expect(response.body).to include('Genre: Pop')
    end
  end
end
