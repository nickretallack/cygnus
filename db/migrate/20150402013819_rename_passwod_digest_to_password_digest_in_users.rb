class RenamePasswodDigestToPasswordDigestInUsers < ActiveRecord::Migration
  def change
  	rename_column :users, :passwod_digest, :password_digest
  end
end