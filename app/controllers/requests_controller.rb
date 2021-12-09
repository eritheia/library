class RequestsController < ApplicationController
	before_action :set_request, only: [:request_action, :destroy]
	before_action :check_request, only: [:create]
	
	def index
	  @requests = Request.where(book_id: params[:b_id])
	end
	
	def show
		@request = Request.find_by_id(params[:id])
		redirect_to root_path
	end

	def new
	end

	def create
 	  @request = Request.create(user_id: params[:user_id], book_id: params[:book_id])
      redirect_to books_path, notice: "Your request has been sent to admin"
	end

	def request_action

	  if params[:request] == 'accepted'
	  	@request.accepted!
	  	redirect_to books_path, notice: "Request has been marked accepted"
	  elsif
	  	@request.rejected!
	  	redirect_to books_path, notice: "Request has been marked rejected"

	  elsif 
	  	@request.return!
	  	redirect_to books_path, notice: "Request has been returned Successfully"

	  else
	  	@request.destroy!
	  	redirect_to books_path, notice: "Request has been deleted Successfully"

	  end

	end
	
	def update 
	end 
	
	def destroy 
      @request.destroy
      respond_to do |format|
      format.html { redirect_to books_path, notice: "Request was successfully destroyed." }
      format.json { head :no_content }
    end
	end

	def set_request
	  @request = Request.find_by(id: params[:id])
	end
	def check_request
		if current_user.role == "admin"
		@request = current_user.requests.find_by(id: params[:id])
		redirect_to books_path, notice: "OOPS! You Are Admin So You Can't Send Request" if @request.nil?
	end
	end
end