class Quotum < ApplicationRecord
  #       t.integer :campaign_id
  self.primary_key = 'quotum_id'
  belongs_to :campaign
  has_many :qualifications, class_name: 'Qualification', foreign_key: :quotum_id

  def serializer
    my_data = self.as_json.except("created_at", "updated_at")
    return my_data if self.qualifications.blank?

    my_data["qualifications"] = qualifications.map{|qualification| qualification.as_json.except("id","created_at", "updated_at", "pre_codes") }
    my_data
  end

end

