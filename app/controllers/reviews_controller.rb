class ReviewsController < ApplicationController
	before_action :find_book
	before_action :find_review, only: [:edit, :update, :destroy]
	before_action :authenticate_user!, only: [:new, :edit]

    	
	def new
		@review = Review.new

	end

	def create
		@review = Review.new(review_params)
		@review.book_id = @book.id
		@review.user_id = current_user.id
		if @review.save
			redirect_to book_path(@book)
		else
			render 'new'
		end
	end

	def edit
	end

	def update
		if @review.update(review_params)
			redirect_to   book_path(@book)	
		else
			render 'edit'
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
		@review.destroy
		redirect_to book_path(@book)
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
