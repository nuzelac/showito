class TimelineController < ApplicationController
  skip_before_filter :require_login
  
  def index
    @activities = PublicActivity::Activity.order("created_at DESC").limit(20)
  end

  def show
  	@user = User.friendly.find(params[:slug])
  	@activities = PublicActivity::Activity.order("created_at DESC").where(owner_type: "User", owner_id: @user).all
  end
end
