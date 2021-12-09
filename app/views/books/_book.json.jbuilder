json.extract! book, :id, :price, :category, :title, :isbn, :auther, :created_at, :updated_at
json.url book_url(book, format: :json)
