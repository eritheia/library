class AdminsController < ApplicationController
	before_action :authenticate_user!
	before_action :check_admin, only:[:new,:show,:update,:destroy]
	def index
		if current_user.role == "admin"
			@admins = User.admin
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
		
		if User.where(email: params[:admin_email]).first.nil?
		  admin = User.create(first_name: params[:admin_fname], last_name: params[:admin_lname], email: params[:admin_email], role: 0, password: "123456")
		end
		redirect_to admins_path
	    
	end

	def destroy
		
		admin = User.find_by_id(params[:id])
		admin.destroy
		redirect_to admins_path
	    
    end

	def show
		
		@admin = User.find_by_id(params[:id])
	    
	end
	def update
		
 		admin = User.find_by_id(params[:id])
  		admin.update(first_name: params[:admin_fname], last_name: params[:admin_lname])
		redirect_to admins_path
	    
	end


end
