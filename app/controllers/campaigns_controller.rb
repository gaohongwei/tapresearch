class CampaignsController < ApplicationController
  def ordered_campaigns
    render json: Campaign.sorted_list()
  end

  def query_params
    params.permit(:sort_field, :sort_order)
  end
end
