class Sport < ActiveRecord::Base
  attr_accessible :description, :image_url, :name, :nyt_blog_url
end
