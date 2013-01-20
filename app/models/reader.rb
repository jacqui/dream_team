class Reader < ActiveRecord::Base
  attr_accessible :name, :username, :nytimes_id
  validates_uniqueness_of :nytimes_id, :if => lambda { !self.nytimes_id.nil? }

  # tries to authenticate against the nyt cookie
  # if there isn't a reader account yet, creates the reader and connects the FB account
  def self.authenticate!(cookies = {})
    return nil if cookies[:nytimes].nil?
    begin
      nyt_cookie = NYT::AuthCookie.decode(cookies[:nytimes])
    rescue ArgumentError => e
      return nil
    end
    return nil if (nyt_cookie.expired? || nyt_cookie.user_id == 0)
    reader = Reader.find_by_nytimes_id(nyt_cookie.user_id)

    if reader.nil?
      reader              = Reader.new
    end

    reader.nytimes_id   = nyt_cookie.user_id
    reader.email        = nyt_cookie.email
    reader.username     = username_from_cookie(nyt_cookie)

    begin
      reader.save! if reader.changed?
    rescue ActiveRecord::RecordInvalid
      reader = Reader.find_by_nytimes_id(nyt_cookie.user_id)
    end
    reader
  end

private
  def self.username_from_cookie(cookie)
    return cookie.username unless cookie.username.blank?
    cookie.email.gsub /@.+$/, ''
  end

  def set_name
    self.name = self.username
    self.save
  end
end
