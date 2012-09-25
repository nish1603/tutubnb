class Place < ActiveRecord::Base
  attr_accessible :description, :property_type, :room_type, :title, :add_guests, :add_price, :daily, :monthly, :weekend, :weekly, :place_id, :address_attributes, :detail_attributes, :photos_attributes, :rules_attributes, :tags_string
  
  validates :description, :property_type, :room_type, presence: true
  validates :add_guests, :add_price, :monthly, :weekend, :weekly, :numericality => { :greater_than_or_equal_to => 0}, :allow_nil => true
  validates :title, :presence => true, :uniqueness => { :scope => [:user_id] }
  validates :daily, :presence => true, :numericality => { :greater_than_or_equal_to => 0}, :allow_nil => true

  PROPERTY_TYPE = ['Appartment', 'House', 'Castle', 'Villa', 'Cabin', 'Bed & Breakfast', 'Boat', 'Plane', 'Light House', 'Tree House', 'Earth House', 'Other']
  ROOM_TYPE = ['Private room', 'Shared room', 'Entire Home/apt']
  PLACE_TYPE = ['Activated', 'Deactivated']

  before_save :set_prices
  before_destroy :check_current_deals
  
  has_one :detail, :dependent => :delete
  has_one :address, :dependent => :delete
  has_one :rules, :dependent => :delete
  has_many :photos, :dependent => :delete_all
  has_many :deals, :dependent => :nullify
  has_many :reviews, :dependent => :delete_all
  
  has_and_belongs_to_many :tags

  belongs_to :user

  accepts_nested_attributes_for :address
  accepts_nested_attributes_for :detail
  accepts_nested_attributes_for :photos, :allow_destroy => true, :reject_if => lambda { |photo| photo[:avatar].blank? }
  accepts_nested_attributes_for :rules


  scope :by_location, lambda{ |type, location| joins(:address).where("addresses.#{type} LIKE ?", "%#{location}%") }
  scope :by_property, lambda{ |type, type_value| where(type => type_value) }
  scope :visible, lambda{ |flag| where(:verified => flag) }
  scope :admin_visible, where(:hidden => false)

  def tags_string
    tags.map(&:tag).join(', ')
  end

  def tags_string=(string)
    place_tags = string.split(", ").reject{ |tag| tag.nil? or tag.blank? }
    self.tags = place_tags.map do |tag|
      Tag.find_or_initialize_by_tag(tag.strip)
    end
  end

  def set_prices()
    if(valid?)
      weekend = daily if weekend.nil?
      weekly = daily * 5 + weekend * 2 if weekly.nil? 
      monthly = daily * 30 if monthly.nil?
    end
  end

  def check_photos(params)
    photos_count = photos.count
    unless(params[:place][:photos_attributes].nil?)
      params[:place][:photos_attributes].each do |key, photo|
        if(!photo[:avatar].blank?)
          photos_count += 1
        elsif(photo["_destroy"] == "1")
          photos_count -= 1
        end
      end
    end
    
    if(photos_count < 2)
      errors.add(:base, "Photos should be more than or equal to 2")
      return false
    end
    return true
  end

  def check_current_deals
    if(Deal.completed_by_place(self).empty?)
      return true
    else
      return false
    end
  end

  def check_commit(commit_type)
    if(commit_type == "Save Place")
      validate = false
      notice = "Your place has been saved. But it is hidden from the outside world."
    else
      validate = true
      notice = "Your place has been created."
    end
  end
end