module UploadCampaign
  # BATCH_SIZE = 100-500 is good number for production
  BATCH_SIZE = 2 # For testing
  def list_from_api(email:, api_token:)
    return TapresearchService.new(email: email, api_token: api_token).get_campaigns
  end

  def get_one(campaign_id:, email:, api_token:)
    return TapresearchService.new(email: email, api_token: api_token).get_campaign(campaign_id)
  end

  def upload_list(email:, api_token:)
    api_response = list_from_api(email: email, api_token: api_token)
    if !api_response[:succeed]
      puts 'API failed'
      return api_response
    end
    data_array =  api_response[:data]
    total = data_array.size
    puts "Ready to add to database"
    puts "total: #{total}, batch_size: #{BATCH_SIZE}"
    added = 0
    failed = 0
    data_array.each_slice(BATCH_SIZE).each_with_index do |groups, index|
      group_results = batch_create(groups)
      added += group_results[:added]
      failed += group_results[:failed]
      puts "Operation #{index}, #{added} of #{total} added, #{failed} failed "
    end
  end

  def batch_create(groups)
    new_records = groups.map{|item|{
      cpi: item['cpi'],
      length_of_interview: item['length_of_interview'],
      campaign_id: item['id'],
      name: item['name']
    }}
    begin
      # upsert can be used in Rails 6
      create(new_records)
      return {added: new_records.size, failed: 0}
    rescue
      # Todo, Try on each record?
      # Todo, Track ids for failed record
      # Todo, what is the expectation here?
      return {added: 0 , failed: new_records.size}
    end
  end

  # campaign_ids: '4,5'
  def upload_details(campaign_ids:, email:, api_token:)
    failed_ids = []
    succeed_ids = []
    ids = campaign_ids.split(',').map{|id|id.to_i}
    total = ids.size
    all_quota_array = []
    ids.each do |campaign_id|
      api_response = get_one(email: email, api_token: api_token, campaign_id: campaign_id)
      if !api_response[:succeed]
        failed_ids << campaign_id
        next
      end

      succeed_ids << campaign_id
      campaign_data = api_response[:data]
      campaign = find_by({campaign_id: campaign_id})
      campaign ||= create( {
        cpi: campaign_data['cpi'],
        length_of_interview: campaign_data['length_of_interview'],
        campaign_id: campaign_data['id'],
        name: campaign_data['name']
      })
      quota_array = campaign_data['campaign_quotas']
      next if quota_array.nil? || quota_array.size < 1

      campaign.update_quota(quota_array)
      all_quota_array += quota_array
    end
    Qualification.create_from_quotas(all_quota_array)

    failed_list = failed_ids.size < 1 ? 'NA' : failed_ids.join(',')
    puts "\nSummary: #{succeed_ids.size} of #{total} succeeded\nFailed: #{failed_list}\n\n"
  end
end