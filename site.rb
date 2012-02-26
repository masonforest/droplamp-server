require 'dropbox_sdk'
class Site < ActiveRecord::Base
  belongs_to :owner, :class_name =>"User"

  
  def get(path)
    puts "getting"+ self.dropbox_folder + path
    dropbox.get_file(self.dropbox_folder + path )
  end
  def create_dropbox_folder
    Dir["#{Rails.root}/templates/default/**/**"].each do |file|
      next if File.directory?(file)
      to_path=self.dropbox_folder+file.sub("#{Rails.root}/templates/default","")
      dropbox.put_file( to_path,File.new(file,"r") )
    end
  end
  def dropbox
   @dropbox ||= begin
    session=DropboxSession.new(ENV['DROPBOX_KEY'], ENV['DROPBOX_SECRET'])
    session.set_access_token(self.owner.dropbox_token,self.owner.dropbox_token_secret)
    dropbox=DropboxClient.new(session,:app_folder)
    dropbox 
   end
  end

end


