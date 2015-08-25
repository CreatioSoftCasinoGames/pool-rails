class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

  before_validation :bot_login_details

  has_many :login_histories, :dependent => :destroy
  has_many :friend_requests, :dependent => :destroy, foreign_key: "requested_to_id"
  has_many :friend_requests_sent, :dependent => :destroy, foreign_key: "user_id", class_name: "FriendRequest"
  has_many :unconfirmed_friend_requests, -> { where(confirmed: false) }, class_name: "FriendRequest", foreign_key: "requested_to_id"
  has_many :friendships, :dependent => :destroy
  has_many :friends, through: :friendships
  has_many :my_friends, foreign_key: "friend_id", class_name: "Friendship"

  has_many :gift_requests, :dependent => :destroy, foreign_key: "send_to_id"
  has_many :gift_requests_sent, :dependent => :destroy, class_name: "GiftRequest", foreign_key: "user_id"
  has_many :unconfirmed_gift_requests, -> { where(confirmed: false) }, class_name: "GiftRequest", foreign_key: "send_to_id"
  has_many :games
  has_many :winners, class_name: "Game", foreign_key: "looser_id"
  has_many :buddy_friends, -> { where(friend_type: "buddy") }, class_name: "Friendship", foreign_key: "user_id"
  has_many :game_requests, :dependent => :destroy, foreign_key: "requested_to"
  has_many :revenges_sent, :dependent => :destroy, foreign_key: "user_id", class_name: "GameRequest"
  has_many :unaccepted_revenge_requests, -> { where(accepted: false) }, foreign_key: "requested_to", class_name: "GameRequest"

  before_validation  :set_fb_password, :set_guest_login_details, :set_fb_friends

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessor :fb_friends_list, :is_friend, :is_requested
  attr_accessor :requested_token

  accepts_nested_attributes_for :login_histories

  before_create :add_unique_id

  def is_ask_for_gift(friend_id)
    gift_sent = gift_requests_sent.where(gift_requests: {send_to_id: friend_id}).last
    if gift_sent.present?
      gift_sent.created_at < Time.zone.now - 24.hours
    else
      true
    end
  end

  def ask_for_gift_in(friend_id)
    gift_sent = gift_requests_sent.where(send_to_id: friend_id).last
    if gift_sent.present?
      gift_sent.created_at - Time.zone.now + 24.hours
    else
      0
    end
  end

  def can_challenge(friend_id)
    challenge_sent = revenges_sent.where(game_requests: {requested_to: friend_id}).last
    if challenge_sent.present?
      challenge_sent.created_at < Time.zone.now - 24.hours
    else
      true
    end
  end

  def xp_required_to_finish_level
    if LevelProgression.where(level: current_level).first.present?
      LevelProgression.where(level: current_level).first.xp_required_to_clear
    else
      0
    end
  end

  def level_required_to_clear_rank
    LevelProgression.where(rank: rank).first.level
  end

  def ask_for_challenge_in(friend_id)
    challenge_sent = revenges_sent.where(requested_to: friend_id).last
    if challenge_sent.present?
      challenge_sent.created_at - Time.zone.now + 24.hours
    else
      0
    end
  end

  def challenged_in(friend_id)
    challenge_sent = revenges_sent.where("requested_to = ? AND created_at >= ?", friend_id, Time.zone.now - 24.hours)
    if challenge_sent.present?
      challenge_sent.collect(&:club_config_id)
    else
      nil
    end
  end

  def self.fetch_by_login_token(login_token)
    if login_token
      self.where(login_token: login_token).first || LoginHistory.where(login_token: login_token).first.user
    end
  end

  def avatar
    self.image? ? image.url(:avatar) : nil
  end

  def player_since
    created_at.strftime("%B,%Y")
  end

  def full_name
    if first_name.blank? 
      "Guest User"
    else
      fullName = [first_name, last_name].join(" ")
    end
  end

  def requested_to_token
    requested_to.login_token
  end
  

  def image_url 
    if fb_id
      "http://graph.facebook.com/#{fb_id}/picture?height=200"
    end
  end

  def num_friend_request
    self.unconfirmed_friend_requests.where(requested_to_id: self.id, confirmed: false).count()
  end
  

  def self.confirmed(user_id, friend_id)
    FriendRequest.where(user_id: user_id, requested_to_id: friend_id).first.confirmed
  end

  def is_ask_for_revenge(winner_id)
    revenge_sent = revenges_sent.where(game_requests: {requested_to: winner_id}).last
    if revenge_sent.present?
      revenge_sent.created_at < Time.now - 24.hours
    else
      true
    end
  end

  def ask_for_revenge_in(winner_id)
    revenge_sent = revenges_sent.where(requested_to: winner_id).last
    if revenge_sent.present?
      revenge_sent.created_at - Time.now + 24.hours
    else
      0
    end
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

  def bot_login_details
    if is_dummy
      generated_password = SecureRandom.hex(9)
      self.email = "bot_#{SecureRandom.hex(8)}@poolapi.com"
      self.password = generated_password
      self.password_confirmation = generated_password
    end
  end

  def set_fb_friends
    if fb_friends_list
      user_ids = User.where(fb_id: fb_friends_list).collect(&:id)
      friend_ids = self.friends.collect(&:id)
      new_friend_ids = user_ids - friend_ids
      deleted_friends_ids = friend_ids - user_ids
      new_friend_ids.each do |friend_id|
        if Friendship.where(user_id: self.id, friend_id: friend_id).blank?
          Friendship.create(user_id: self.id, friend_id: friend_id)
          Friendship.create(user_id: friend_id, friend_id: self.id) 
        end
      end
      deleted_friends_ids.each do |deleted_friend_id|
        friend = Friendship.where(user_id: self.id, friend_id: deleted_friend_id, friend_type: "fb").first
        friend1 = Friendship.where(user_id: deleted_friend_id, friend_id: self.id, friend_type: "fb").first
        if friend.present?
          friend.delete
          friend1.delete
        end
      end
    end
  end

  def add_unique_id
   unique_value = SecureRandom.hex(4)
   self.unique_id = unique_value
  end

end
