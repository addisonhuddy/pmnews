class Comment < ActiveRecord::Base
  belongs_to :post
  belongs_to :user

  validates :body,
            :presence => {:message => "Can't be blank"},
            :length => {:minimum  => 10, :message => "Comment must be more than 10 characters" }

end
