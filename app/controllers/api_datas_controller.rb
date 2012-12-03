class ApiDatasController < ApplicationController
  skip_before_filter :authorize, :only => :request_token

  def new
    @user = User.find_by_id(current_user.id)
    @api_data = @user.api_datas.build
  end

  def create
    @user = User.find_by_id(current_user.id)
    @api_data = @user.api_datas.build(params[:api_data])

    respond_to do |format|
      if(@api_data.save)  
        format.html { redirect_to root_url }
        flash[:notice] = "api is registered"
      else
        format.html { render action: "new" }
      end
    end
  end

  def destroy
  end

  def edit
    @api_data = ApiData.find_by_id(params[:id])
  end

  def update
    @api_data = ApiData.find_by_id(params[:id])
    
    respond_to do |format|
      if(@api_data.update_attributes(params[:api_data]))  
        format.html { redirect_to root_url }
        flash[:notice] = "api is registered"
      else
        format.html { render action: "new" }
      end
    end
  end

  def index
  end

  def show
  end

  def generate
    @api_data = ApiData.find_by_id(params[:id])
    @api_data.generate_token_and_secret()

    respond_to do |format|
      if(@api_data.save)  
        format.html { redirect_to request.referrer }
        flash[:notice] = "token and secret is registered"
      else
        format.html { render action: "show" }
      end
    end
  end

  def request_token
    params[:url] = request.referrer
    @api_data = ApiData.find_by_url('localhost:3001')
    flag = @api_data.try(:authenticate, params[:email], params[:password])
    
    respond_to do |format|
      if flag && @api_data.save 
        format.html { redirect_to params[:url] + "?token=#{@api_data.token}" }
      else
        format.html { redirect_to params[:url] }
      end
    end
  end
end