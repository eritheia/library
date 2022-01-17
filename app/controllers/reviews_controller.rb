class ReviewsController < ApplicationController
  before_action :find_book
  before_action :find_review, only: [:edit, :update, :destroy]
  before_action :authenticate_user!, only: [:new, :edit]

      
    def new
      @review = Review.new
      respond_to do |format|
        format.js 
        format.html
      end
    end

    def create
      
       @book = Book.find(params[:book_id])
       @review = @book.reviews.create(review_params)
       @review.user = current_user
       if @review.save
        respond_to do |format|
        format.js {redirect_to book_path(@book), notice: "comment Created successfully", turbolinks: false}
        format.html {redirect_to book_path(@book), notice: "Review Created successfully"}
        end 
       else
        render :new
      end
    end

    def edit
    end

    def show
      redirect_to books_path(id: @review.book)
    end

    def update
    
      if @review.update(review_params)
        respond_to do |format|
        format.js {redirect_to book_path(params[:book_id]), notice: "comment Edited successfully", turbolinks: false}
        format.html {redirect_to book_path(params[:book_id]), notice: "Review Edited successfully"}
        end  
      else
        render :edit
      end
    end

    def top_books
      rat = {}
      Book.all.each do |book|
        rating = []
        book.reviews.each do |review|
          @rating = review.rating.to_i
           rating << @rating
           
        end
        rating.compact!
        @length = rating.length
        @sum = rating.sum
        unless @length == 0
             @rating = @sum/@length
        end
        unless @rating == nil 
              rat[book.id] = @rating
        end
      end
      max = rat.values.max
      @books = rat.key(max)
      @books = Book.find_by_id(@books)    
    end

    def destroy
      if @review.destroy
        respond_to do |format|
         format.js
         format.html { redirect_to book_path(@book), notice: "Review was successfully destroyed." }
        end
      end
    end 

    private

    def review_params
      params.require(:review).permit(:rating, :comment)
    end

    def find_book
    @book = Book.find_by_id(params[:book_id])
    end

    def find_review
      @review = Review.find(params[:id])
    end
  end
