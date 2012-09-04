class PhotoController < ApplicationController
  def upload
  	@photo = Photo.new
  end
end
