require_relative "../lib/book_repository"
require_relative "../lib/book"

def reset_books_table
  seed_sql = File.read('spec/seeds_book_store_test.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'book_store_test' })
  connection.exec(seed_sql)
end

describe BookRepository do
  before(:each) do 
    reset_books_table
  end

  it "returns correct results" do
    repo = BookRepository.new
    books = repo.all

    expect(books.length).to eq 5

    expect(books[0].id).to eq '1'
    expect(books[0].title).to eq 'Nineteen Eighty-Four'
    expect(books[0].author_name).to eq 'George Orwell'

    expect(books[1].id).to eq  '2'
    expect(books[1].title).to eq 'Mrs Dalloway'
    expect(books[1].author_name).to eq 'Virginia Woolf'
  end
end