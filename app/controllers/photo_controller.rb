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

  def delete
    @photo = Photo.find(params[:id])

    if(@photo.place.photos.count <= 2)
      flash[:error] = "Images should be more than 2."
    else
      @photo.destroy
      flash[:notice] = "Image deleted."
    end

    respond_to do |format|
      format.html { redirect_to request.referrer }
    end
  end
end
