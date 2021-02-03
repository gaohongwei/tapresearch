# README

- rails db:migrate
- rake campaign:list_from_api email="codetest@tap.com" api_token="1c7dd6fd2a94b2e6431b367189aead01"
- rake campaign:list_from_db
- rake campaign:upload_list email="codetest@tap.com" api_token="1c7dd6fd2a94b2e6431b367189aead01"
- rake campaign:upload_details email="codetest@tap.com" api_token="1c7dd6fd2a94b2e6431b367189aead01" campaign_ids=278562,278563,278564,278565,278566,278567,278568,278569,278570

- Questions and discussion
  - ActiveRecord::Base.connection.execute(sql) can be used in model to load large amount data, or query
  - batch create is used to create in bacth
  - update_all, insert_all, upsert, upsert_all, can be used in Rails 6
