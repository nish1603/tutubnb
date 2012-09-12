class RuleController < ApplicationController
	skip_before_filter :authorize, only: :show

  def new
  	@rules = Rules.new
  end

  def create
  	@rules = Rules.new(params[:rules])
    @rules.place_id = session[:place_id]

    respond_to do |format|
      if @rules.save
        format.html { redirect_to new_address_path }
      end
    end 
  end

  def edit
    @rules = Rules.find(params[:id])
    
    if !@rules.nil?
      validating_owner(@rules.place.user_id, rules_path(params[:id]))
    end
  end

  def update
    @rules = Rules.find(params[:id])
    update_attributes(@detail, :detail)
  end

  def show
    @rules = Rules.find(params[:id])
  end

  def destroy
  end
end
