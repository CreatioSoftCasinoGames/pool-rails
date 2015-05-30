class ClientBugsController < ApplicationController
  before_action :set_client_bug, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @client_bugs = ClientBug.all
    respond_with(@client_bugs)
  end

  def show
    respond_with(@client_bug)
  end

  def new
    @client_bug = ClientBug.new
    respond_with(@client_bug)
  end

  def edit
  end

  def create
    @client_bug = ClientBug.new(client_bug_params)
    @client_bug.save
    respond_with(@client_bug)
  end

  def update
    @client_bug.update(client_bug_params)
    respond_with(@client_bug)
  end

  def destroy
    @client_bug.destroy
    respond_with(@client_bug)
  end

  private
    def set_client_bug
      @client_bug = ClientBug.find(params[:id])
    end

    def client_bug_params
      params.require(:client_bug).permit(:exception, :bug_type)
    end
end
