class AddNodeDirectoryToOauthApplications < ActiveRecord::Migration[6.0]
  def change
    add_reference :oauth_applications, :node_directory, type: :uuid, null: true
  end
end
