class ChangeApplyingStoreIdsToAffiliationApplications < ActiveRecord::Migration[5.2]
  def change
    rename_table :applying_store_ids, :affiliation_applications
  end
end
