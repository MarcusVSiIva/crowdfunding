class CreateSponsorships < ActiveRecord::Migration[6.1]
  def change
    create_table :sponsorships do |t|
      t.references :user, null: false, foreign_key: true
      t.references :project, null: false, foreign_key: true
      t.float :amount

      t.timestamps
    end
  end
end
