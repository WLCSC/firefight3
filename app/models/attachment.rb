class Attachment < ActiveRecord::Base
  has_attached_file :file
  validates_attachment_content_type :file, :content_type => [
    'image/jpeg',
    'image/gif',
    'image/png',
    'text/plain',
    'application/pdf',
    'application/msword',
  ]

  def image?
    file_content_type.match 'image'
  end

  def user
    begin
    User.find(user_sid)
    rescue
      nil
    end
  end
end
