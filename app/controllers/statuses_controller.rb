class StatusController < ApplicationController
  before_action :correct_user, only: :destroy
  respond_to :html, :json

  def show
    @status = Status.find params[:id]
    @status.comments.build
    @user = current_user
    @user_list = current_user.following
  end

   def create
    @status = current_user.statuses.build status_params
    if @status.save
      flash[:success] = "Status created!"
      redirect_to root_url
    else
      @feed_items = []
      render "static_pages/home"
    end
  end

   def update
    @status = Status.find params[:id]
    @status.update_attributes status_params
    respond_with @status
  end

   def destroy
    @status.destroy
    flash[:success] = "Status deleted"
    redirect_to request.referrer || root_url
  end

  private
  def status_params
    params.require(:status).permit :content, :picture_status
  end

  def correct_user
    @status = current_user.statuses.find_by id: params[:id]
    redirect_to root_url if @status.nil?
  end

end
