class CategoryController < ApplicationController
 before_action :check_admin, only:[:new,:update,:destroy]

  def index
    @category = Category.order(created_at: :desc)
  end

   def check_admin
      if current_user.role == "admin"
        true
      else
        redirect_to root_path, notice: "OOPS! Not Authorized To Edit This Category" 
      end
    end

  def show
   
      @category = Category.find_by_id(params[:id])
      respond_to do |format|
      format.js
      format.html
    end
  end

  def new
    @category = Category.new
    respond_to do |format|
      format.js
      format.html
    end
  end

  def create    
    @category = Category.create(name:params[:name])
    redirect_to category_index_path
  end

  def update
    @category = Category.find_by_id(params[:id])
    @category.update(name: params[:name])
    redirect_to category_index_path
  end

  def destroy
     @category = Category.find_by_id(params[:id])
  if @category.present?
     @category.destroy
  end
    respond_to do |format|
      format.js {redirect_to category_index_path, notice: "Category was successfully destroyed"}
      format.html{redirect_to category_index_path, notice: "Category was successfully deleted"}
    end
 end
end
