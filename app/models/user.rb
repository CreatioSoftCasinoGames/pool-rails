class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

  has_many :login_histories, :dependent => :destroy
  has_many :friend_requests, :dependent => :destroy, foreign_key: "requested_to_id"
  has_many :friend_requests_sent, :dependent => :destroy, foreign_key: "user_id", class_name: "FriendRequest"
  has_many :unconfirmed_friend_requests, -> { where(confirmed: false) }, class_name: "FriendRequest", foreign_key: "requested_to_id"
  has_many :friendships, :dependent => :destroy
  has_many :friends, through: :friendships

  before_validation  :set_fb_password, :set_guest_login_details, :set_fb_friends

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessor :fb_friends_list, :is_friend, :is_requested

  accepts_nested_attributes_for :login_histories

  def self.fetch_by_login_token(login_token)
    if login_token
      self.where(login_token: login_token).first || LoginHistory.where(login_token: login_token).first.user
    end
  end

  def player_since
    created_at.strftime("%B,%Y")
  end

  def full_name
    [first_name, last_name].join(" ")
  end
  
  def image_url 
    if fb_id
      "http://graph.facebook.com/#{fb_id}/picture?height=200"
    end
  end

  def num_friend_request
    self.unconfirmed_friend_requests.where(requested_to_id: self.id, confirmed: false).count()
  end

  private

  def set_fb_password
    if fb_id
      generated_password = SecureRandom.hex(4)
      self.password = generated_password
      self.password_confirmation = generated_password    
    end
  end

  def set_guest_login_details
    if is_guest
      password_generated = SecureRandom.hex(4)
      self.email = "guest_"+SecureRandom.hex(3)+"@poolapi.com"
      self.password = password_generated
      self.password_confirmation = password_generated
    end
  end

  def set_fb_friends
    if fb_friends_list
      user_ids = User.where(fb_id: fb_friends_list).collect(&:id)
      friend_ids = self.friends.collect(&:id)
      new_friend_ids = user_ids - friend_ids
      deleted_friends_ids = friend_ids - user_ids
      new_friend_ids.each do |friend_id|
        Friendship.create(user_id: self.id, friend_id: friend_id)
        Friendship.create(user_id: friend_id, friend_id: self.id)
      end
      deleted_friends_ids.each do |deleted_friend_id|
        Friendship.where(user_id: self.id, friend_id: deleted_friend_id).first.delete
        Friendship.where(user_id: deleted_friend_id, friend_id: self.id).first.delete
      end
    end
  end

end
