class RequestsController < ApplicationController
  before_action :set_request, only: [:request_action, :destroy, :return_action, :update, :edit]
  before_action :check_request, only: [:create]
  
  def index
    @requests = Request.where(book_id: params[:b_id])
  end
  
  def show
    @request = Request.find_by_id(params[:id])
    redirect_to root_path
  end

  def new
    respond_to do |format|
      format.js
      format.html
    end
  end

  def create
    @request = Request.create(user_id: params[:user_id], book_id: params[:book_id])
    redirect_to books_path, notice: "Your request has been sent to admin"
  end

  def request_action
    if params[:request] == 'accepted'
      @request.accepted!
      redirect_to requests_path(b_id: @request.book_id), notice: "Request has been marked accepted"
    elsif
      @request.rejected!
      redirect_to requests_path(b_id: @request.book_id), notice: "Request has been marked rejected"
    else
      @request.destroy!
      redirect_to requests_path(b_id: @request.book_id), notice: "Book has been deleted Successfully"
    end
  end
  
  def update
    @request.update(due_date: params[:request][:due_date])
    redirect_to requests_path(b_id: @request.book_id), notice: "due_date added Successfully"
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
    if current_user.requests.pluck(:fine).max > 0
      redirect_to books_path, notice: "OOPS! fine is pending" if @request.nil?

    end
  end
end