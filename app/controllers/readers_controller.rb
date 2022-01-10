class ReadersController < ApplicationController
	before_action :authenticate_user!
	before_action :check_admin, only:[:new,:update,:destroy]

	def index
		if current_user.role == "admin"
			@readers = User.reader.order(created_at: :desc)
		else
			respond_to do |format|
		 format.js { redirect_to readers_path, notice: "Reader was successfully added." }
		 format.html { redirect_to readers_path, notice: "Reader was successfully added." }
		end
		end
	end

    def check_admin
    	if current_user.role == "admin"
    		true
    	else
    		redirect_to root_path, notice: "OOPS! Not Authorized To Edit The Admin" 
    	end
    end

	def new	
		@user = User.new
		respond_to do |format|
			format.js
			format.html
		end	
	end

	def create
		if User.where(email: params[:reader_email]).first.nil?
		  reader = User.create(first_name: params[:reader_fname], last_name: params[:reader_lname], email: params[:reader_email], role: 1, password: "123456")
		end
		respond_to do |format|
		 format.js { redirect_to readers_path, notice: "Reader was successfully added." }
		 format.html { redirect_to readers_path, notice: "Reader was successfully added." }
		end
	end

	def destroy	
		reader = User.find_by_id(params[:id])
		reader.destroy
		respond_to do |format|
         format.js { redirect_to readers_path, notice: "Reader was successfully destroyed." }
         format.html { redirect_to readers_path, notice: "Reader was successfully destroyed." }
     end 
	end	

	def show	
		@reader = User.find_by_id(params[:id])
		respond_to do |format|
			format.js
			format.html
		end
	end	

	def update	
 		reader = User.find_by_id(params[:id])
  		reader.update(first_name: params[:reader_fname], last_name: params[:reader_lname])
		redirect_to readers_path
	end
end