class Campaign < ApplicationRecord
  extend UploadCampaign
  # Todo
  self.primary_key = 'campaign_id'
  has_many :quotes, class_name: 'Quotum', foreign_key: :campaign_id
  has_many :qualifications, through: :quotes

  def self.sorted_list(params=nil)
    raw_list = Campaign.includes(quotes: :qualifications).map{|campaign| campaign.serializer}
    raw_list.sort{|x, y| x["qualification_count"] <=> y["qualification_count"]}
  end

  def serializer
    my_data = self.as_json.except("created_at", "updated_at")
    my_data["qualification_count"] = 0
    return my_data if self.quotes.blank?
    my_data["quotes"] = self.quotes.map{|quote| quote.serializer}
    my_data["qualification_count"] = self.quotes.map{|quote| quote.qualifications.size}.sum
    my_data
  end

  def update_quota(quota_array)
    quota_array.each do |one_quota|
      quotum_id = one_quota['id']
      begin
        self.quotes << Quotum.new({
          quotum_id: quotum_id,
          name: one_quota['name']
        })
      rescue => exception
        puts("\n\nException:")
        puts exception.message
      end
    end
    self.save
  end
end