class MoreUserData < ActiveRecord::Migration
  def up
    User.where(view_adult: true).each do |user|
      user.update_attribute(:settings, user.settings.merge({view_adult: "1"}))
    end

    User.all.each do |user|
      user.update_attribute(:artist_types, user.attributes["artist_type"].split(", ").select{ |type| CONFIG[:artist_types].include? type}) if user.attributes["artist_type"]
      user.update_attribute(:offsite_galleries, user.attributes["offsite_gallery"].split(" ")) if user.attributes["offsite_gallery"]
    end
    remove_column :users, :view_adult, :boolean, default: false

    remove_column :users, :artist_type, :string
    remove_column :users, :offsite_gallery, :string
  end
end
