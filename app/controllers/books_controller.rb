class BooksController < ApplicationController
  before_action :set_book, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, except: [:index, :show]
  before_action :correct_user, only: [:edit, :update, :destroy]
  BOOKS_PER_PAGE = 4
  def index
        @books = Book.order(created_at: :desc)
        @q = @books.ransack(params[:q])
        @books = @q.result
        @page = params.fetch(:page, 0).to_i
        @next_books = @books.offset(@page * BOOKS_PER_PAGE).limit(BOOKS_PER_PAGE + 1)
        @books = @books.offset(@page * BOOKS_PER_PAGE).limit(BOOKS_PER_PAGE)
  end

  def show    
    if @book.reviews.blank?
      @average_review = 0
    else
      @average_review = @book.reviews.average(:rating).round(2)
    end
    respond_to do |format|
      format.js
      format.html
    end
  end

  def new
    @book = current_user.books.build
    respond_to do |format|
      format.js
      format.html
    end
  end

  def edit
    respond_to do |format|
      format.js
      format.html
    end
  end

  def create
     @book = current_user.books.build(book_params)
      if @book.save
        redirect_to books_path
        #format.json { render :show, status: :created, location: @book }
      else
        render :new
        #format.json { render json: @book.errors, status: :unprocessable_entity }
      end
  end

  def update
       @book.update(book_params)
        redirect_to books_path
  end

  def destroy
     @book.destroy
     respond_to do |format|
         format.html { redirect_to books_url, notice: "Book was successfully destroyed." }
         format.js 
     end 
  end
  
  def correct_user
    @book = current_user.books.find_by(id: params[:id])
    redirect_to books_path, notice: "OOPS! Not Authorized To Edit This Book" if @book.nil?
  end

  def my_books
    book_ids = current_user.requests.where(request_type: "accepted").pluck(:book_id)
    @books = Book.where(id: book_ids)
  end

  def return_action
    request = Request.find_by(book_id: params[:id])
    request.update(request_type: Request.request_types[:returned], return_date: DateTime.current)
    fine = 0
    if (request.return_date - request.due_date).to_i > 0
      fine = (request.return_date - request.due_date).to_i * 100
    end
    request.update(fine: fine)
    redirect_to my_books_books_path, notice: "Book was successfully Returned To Admin"
  end

 

  private
    def set_book
      @book = Book.find(params[:id])
    end
    
    def book_params
      params.require(:book).permit(:id, :price, :category_id, :title, :isbn, :auther, :user_id)
    end
end
