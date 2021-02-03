class Qualification < ApplicationRecord
  belongs_to :quotum

  def self.create_from_quotas(quota_array)
    new_records = []
    quota_array.each do |quota|
      qualifications = quota['campaign_qualifications']
      continue if qualifications.nil? || qualifications.size < 1

      quotum_id = quota['id']
      qualifications.each do |qualification|
        new_records << {
          quotum_id: quotum_id,
          question_id: qualification['question_id'],
          pre_codes: qualification['pre_codes'].join(',')
        }
      end
    end
    begin
      create(new_records)
    rescue => exception
      puts("\n\nException:")
      puts(exception.message)
    end
  end
end
