class Tag < ActiveRecord::Base
  attr_accessible :tag

  validates :tag, :presence => true, :uniqueness => true

  has_and_belongs_to_many :places

  def self.tags_starting_with(word)
    @tags = self.find(:all,:conditions => ['tag LIKE ?', "#{params[:tag]}%"],  :limit => 10, :order => 'tag') if(params[:tag])
    @tags.map(&:tag)
  end
end
