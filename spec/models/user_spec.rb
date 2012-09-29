require 'spec_helper'

module UserSpecHelper
  def valid_user_attributes
    { :first_name => "nishant",
      :last_name => "tuteja",
      :gender => "1",
      :email => "nishant.tuteja@vinsol.com",
      :password => "password",
      :password_confirmation => "password"
      # :avatar_file_name => "390550_2061284230599_1911003160_n.jpg",
      # :avatar_content_type => "image/jpeg",
      # :avatar_file_size => 17185,
      # :avatar_updated_at => Time.now
    }
  end
end

describe User do
  include UserSpecHelper
  before(:each) do
    @user = User.new
  end
  
  it "first name should not be nil" do
    @user.attributes = valid_user_attributes.except(:first_name)
    @user.should have(1).error_on(:first_name)
  end

  it "last name should not be nil" do
    @user.attributes = valid_user_attributes.except(:last_name)
    @user.should have(1).error_on(:last_name)
  end

  it "gender should not be nil" do
    @user.attributes = valid_user_attributes.except(:gender)
    @user.should have(1).error_on(:gender)
  end

  it "email should not be nil" do
    @user.attributes = valid_user_attributes.except(:email)
    @user.should have(1).error_on(:email)
  end

  it "email should be in proper format" do
    @user.attributes = valid_user_attributes.except(:email)
    @user.email = "nishant"
    @user.should have(1).error_on(:email)
  end

  it "email should be unique" do
    @user2 = User.create(valid_user_attributes)
    @user.attributes = valid_user_attributes
    @user.should have(1).error_on(:email)
  end

  it "password should not be nil" do
    @user.attributes = valid_user_attributes.except(:password)
    @user.should have(1).error_on(:password)
  end

  it "password should be at least 6 characters" do
    @user.attributes = valid_user_attributes.except(:password)
    @user.password = "1234"
    @user.should have(2).error_on(:password)
  end

  it "password_confirmation should not be nil" do
    @user.attributes = valid_user_attributes.except(:password_confirmation)
    @user.should have(1).error_on(:password_confirmation)
  end




  # it "password should not be nil" do
  #   @user.attributes = valid_user_attributes.except(:gender)
  #   @user.should have(1).error_on(:password)
  # end





#   it "Valid name"do
#     @user.attributes = valid_user_attributes.only(:name)
#     @user.should have(0).error_on(:name)
#   end
#   it "Email should not be null and same" do
#     @user.attributes = valid_user_attributes.except(:email)
#     @user.should have(2).error_on(:email)
#   end
#   it "Valid Email"do
#     @user.attributes = valid_user_attributes.only(:email)
#     @user.should have(0).error_on(:email)
#   end
#   it "age is nill"do
#     @user.attributes = valid_user_attributes.except(:age)
#     @user.should have(2).error_on(:age)
#   end
#   it "age is not in range"do
#     @user.attributes = valid_user_attributes.with(:age => 100)
#     @user.should have(1).error_on(:age)
#   end
#   it "valid age "do
#     @user.attributes = valid_user_attributes.only(:age)
#     @user.should have(0).error_on(:age)
#   end
#   it "Invalid Password short of length "do
#     @user.attributes = valid_user_attributes.with(:password=>"wer")
#     @user.should have(2).error_on(:password)
#   end
#   it "Password not matching cinfirmation"do
#     @user.attributes = valid_user_attributes.with(:password=>"qwertyuiop")
#     @user.should have(1).error_on(:password)
#   end
#   it "Avatar should not be nill"do
#     @user.avatar=nil
#     @user.should have(1).error_on(:avatar)
#   end
#   it "should be valid" do
# #    @user.name = "aayush"
# #    @user.email = "aayush.khandelwal@vinsol.com"
# #    @user.age = 22
# #    @user.password = "aayush11"
# #    @user.password_confirmation = "aayush11"
# #    @user.avatar_file_name = "390550_2061284230599_1911003160_n.jpg"
# #    @user.avatar_content_type = "image/jpeg"
# #    @user.avatar_file_size = 17185
# #    @user.avatar_updated_at = Time.now
#     @user.attributes = valid_user_attributes
#     @user.should be_valid
#   end
end  