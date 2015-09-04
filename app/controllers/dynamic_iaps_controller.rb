class DynamicIapsController < ApplicationController
  before_action :set_dynamic_iap, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    if params[:iap_type].blank?
      @dynamic_iaps = DynamicIap.all
    else
      @dynamic_iaps = DynamicIap.where(iap_type: params[:iap_type])
    end
    respond_with(@dynamic_iaps)
  end

  def show
    respond_with(@dynamic_iap)
  end

  def new
    @dynamic_iap = DynamicIap.new
    respond_with(@dynamic_iap)
  end

  def edit
  end

  def create
    @dynamic_iap = DynamicIap.new(dynamic_iap_params)
    @dynamic_iap.save
    respond_with(@dynamic_iap)
  end

  def update
    @dynamic_iap.update(dynamic_iap_params)
    respond_with(@dynamic_iap)
  end

  def destroy
    @dynamic_iap.destroy
    respond_with(@dynamic_iap)
  end

  private
    def set_dynamic_iap
      @dynamic_iap = DynamicIap.find(params[:id])
    end

    def dynamic_iap_params
      params.require(:dynamic_iap).permit(:iap_id, :name,  :old_value, 
        :new_value, :offer, :currency, :country, :iap_type, :created_at, :updated_at, 
        :is_active, :old_pricing, :new_pricing, :deal_value, :more, :end_time)
    end
end
