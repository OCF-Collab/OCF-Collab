class AddS3RegionToNodeDirectories < ActiveRecord::Migration[7.1]
  def change
    add_column :node_directories, :s3_region, :string, default: 'us-east-1'
  end
end
