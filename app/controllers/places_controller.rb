class PlacesController < ApplicationController  
  skip_before_filter :authorize, only: :show
  before_filter :owner_activated, :only => [:activate, :operation]
  before_filter :place_exists, :only => [:edit, :update, :destroy, :operation, :show]
  before_filter :validating_owner, :only => [:edit, :update, :operation]
  #  before_filter :expires_cache_show, :only => :show
  
  # caches_action :show, :layout => :false, :if => lambda { |c| Place.find_by_id(c.params[:id]).user != current_user }
  
  # def expires_cache_show
  #   @place = Place.find_by_id(params[:id])
  #   expire_action :action => :show, :id => params[:id] if(@place.user == current_user)
  # end

  def new
  	@place = Place.new
    @place.build_detail 
    @place.build_address
    @place.build_rules

    2.times { @place.photos.build }
    respond_to do |format|
      format.html
    end
  end

  def create
  	@place = current_user.places.build(params[:place])

    validate, notice = check_commit(@place)
    
  	respond_to do |format|
      if(@place.save(:validate => validate))  
        format.html { redirect_to root_url }
        flash[:notice] = notice
      else
        format.html { render action: "new" }
      end
    end 
  end

  def edit
    @place = Place.find_by_id(params[:id]) 
  end

  def update
    @place = Place.find_by_id(params[:id])
    expire_fragment("show_#{@place.id}_hi")
    expire_fragment("show_#{@place.id}_en")
      
    notice = "Successfully updated."
    notice += "It is still hidden, you can make it visible on My Places." if(@place.hidden == true)

    respond_to do |format|
      if(@place.update_attributes(params[:place]))
        format.html { redirect_to root_url }
        flash[:notice] = notice
        expires_action :show
      else
        format.html { render action: "edit" }
      end
    end
  end

  def show
    @place = Place.find_by_id(params[:id])
    @user = User.find_by_id(session[:id])
    @deal = Deal.unreviewed_by_user_on_place(@user, @place).first if(@user)
    @detail = @place.detail
    @rules = @place.rules
    @address = @place.address
    @reviews = @place.reviews
    @review = Review.new
    @address_json = @address.to_gmaps4rails
    @api_data = ApiData.find_by_url('localhost:3001')

    respond_to do |format|
      format.html
      if @api_data.try(:authenticate_token, params[:token])
        format.json { render json: @place }
      else
        format.json { render json: {} }
      end 
    end
  end

  # def get_job_applications
  #   @place = Place.find(params[:id])
  #   @api_data = ApiData.find_by_token('localhost:3001')
  #   if @api_data.authenticate_token(params[:token])
  #     link = "localhost:3001/"
  #     @json_response = RestClient.get link, { :accept => :json }
  #   else
  #   # retrieving the jobs of a particular Employer
  #   link = "http://localhost:3000/places/1.json?token=#{@api_data}"
  #   @json_response = RestClient.get link, { :accept => :json }
  #   session[:emp_id] = JSON.parse(@json_response).first.fetch("employer_id")
  #   end
  # end

  def destroy
    @place = Place.find_by_id(params[:id])
    
    respond_to do |format|
      if(@place.destroy)
        flash[:notice] = "This place has been deleted"
      else
        flash[:error] = "This place can't be deleted because it has some pending deals."
      end
      format.html { redirect_to request.referrer }
    end
  end

  def operation
    @place = Place.find_by_id(params[:id])

    respond_to do |format|
      if(params[:flag] == "hide" && @place.hide!)
        flash[:notice] = "#{@place.title} is now hidden"
      elsif(params[:flag] == "show" && @place.show!)
        flash[:notice] = "#{@place.title} is now visible"
      else
        flash[:error] = "#{@place.title} is not visible."
      end
      format.html { redirect_to request.referrer }
    end
  end

  def check_commit(place)
    if(params[:commit] == "Save Place")
      validate = false
      place.hidden = true
      notice = "Your place has been saved. But it is hidden from the outside world."
    else
      validate = true
      notice = "Your place has been created."
    end
    return validate, notice
  end
end