namespace :campaign do
  desc <<-DESC
    Get Campaign list from API call. Usage:
    rake campaign:list_from_api email="codetest@tap.com" api_token="1c7dd6fd2a94b2e6431b367189aead01"
  DESC
  task list_from_api: :environment do
    email = ENV['email']
    api_token = ENV['api_token']
    if email.blank? || api_token.blank?
      puts <<-DESC
        Get Campaign list from API call. Usage:
        rake campaign:list_from_api email="codetest@tap.com" api_token="1c7dd6fd2a94b2e6431b367189aead01"
      DESC
    else
      out = Campaign.list_from_api(email: email, api_token: api_token)
      if out[:succeed]
        out = out[:data]
        puts out.map{|x|"#{x['id']}, #{x['name']}"}
        puts "Total: #{out.size}"
      else
        puts "API call failed"
      end
    end
  end

  desc <<-DESC
    Get Campaign list from API call. Usage:
    rake campaign:list_from_db
  DESC
  task list_from_db: :environment do
    out = Campaign.all.map{|x|"#{x.campaign_id}, #{x.name}"}
    puts out
    puts "Total: #{out.size}"
  end

  desc <<-DESC
    Get Campaign list from API call. Usage:
    rake campaign:upload_list email="codetest@tap.com" api_token="1c7dd6fd2a94b2e6431b367189aead01"
  DESC
  task upload_list: :environment do
    email = ENV['email']
    api_token = ENV['api_token']
    if email.blank? || api_token.blank?
      puts <<-DESC
        Get Campaign list from API call. Usage:
        rake campaign:upload_list email="codetest@tap.com" api_token="1c7dd6fd2a94b2e6431b367189aead01"
      DESC
    else
      Campaign.upload_list(email: email, api_token: api_token)
    end
  end

  desc <<-DESC
    Get one campaign details from API call
    And populate into the table. Usage:
    rake campaign:upload_details campaign_ids=4,5 email="codetest@tap.com" api_token="1c7dd6fd2a94b2e6431b367189aead01"
  DESC
  task upload_details: :environment do
    campaign_ids = ENV['campaign_ids']
    email = ENV['email']
    api_token = ENV['api_token']
    if email.blank? || api_token.blank? || campaign_ids.blank?
      puts <<-DESC
          Get one campaign details from API call
          And populate into the table. Usage:
          rake campaign:upload_details campaign_ids=4,5 email="codetest@tap.com" api_token="1c7dd6fd2a94b2e6431b367189aead01"
        DESC
    else
      Campaign.upload_details(email: email, api_token: api_token, campaign_ids: campaign_ids)
    end
  end
end
