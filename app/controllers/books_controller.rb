class BooksController < ApplicationController
  before_action :set_book, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, except: [:index, :show]
  before_action :correct_user, only: [:edit, :update, :destroy]

  def index
    @books = Book.order(created_at: :desc)
  end

  def show
    if @book.reviews.blank?
      @average_review = 0
    else
      @average_review = @book.reviews.average(:rating).round(2)
    end
  end

  def new
    @book = current_user.books.build
  end

  def edit
  end

  def create
     @book = current_user.books.build(book_params)
    respond_to do |format|
      if @book.save
        format.js
        format.html { redirect_to @book, notice: "Book was successfully created." }
        format.json { render :show, status: :created, location: @book }
      else
        format.js
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      book = Book.find_by_id(params[:id])
      if book.update(book_params)
        format.html { redirect_to @book, notice: "Book was successfully updated." }
        format.json { render :show, status: :ok, location: @book }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy

     @book.destroy
     
     respond_to do |format|
         format.html { redirect_to books_url, notice: "Book was successfully destroyed." }
        format.json { head :no_content }
        format.js   { render :layout => false }
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
