class ReadersController < ApplicationController
	before_action :authenticate_user!
	before_action :check_admin, only:[:new,:update,:destroy]

	def index
		if current_user.role == "admin"
			@readers = User.reader
		else
			redirect_to root_path
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
	end

	def create
		if User.where(email: params[:reader_email]).first.nil?
		  reader = User.create(first_name: params[:reader_fname], last_name: params[:reader_lname], email: params[:reader_email], role: 1, password: "123456")
		end
		redirect_to readers_path
	end

	def destroy	
		reader = User.find_by_id(params[:id])
		reader.destroy
		redirect_to readers_path
	end	

	def show	
		@reader = User.find_by_id(params[:id])
	end	

	def update	
 		reader = User.find_by_id(params[:id])
  		reader.update(first_name: params[:reader_fname], last_name: params[:reader_lname])
		redirect_to readers_path
	end
end