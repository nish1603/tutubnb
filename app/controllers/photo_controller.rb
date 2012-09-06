class PhotoController < ApplicationController
  def upload
  	@photo = Photo.new
  end

  def save
  	@photo = Photo.new(params[:photo])


    respond_to do |format|
      if @photo.save
        format.html { redirect_to display_show_path }
      else
        format.html { redirect_to display_show_path, :notice => params[:photo] }
      end
    end
  end
end
