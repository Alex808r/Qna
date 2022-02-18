# frozen_string_literal: true

class LinksController < ApplicationController
  before_action :authenticate_user!, only: :destroy

  def destroy
    @link = Link.find(params[:id])
    @link.destroy if authorize! :destroy, @link.linkable
  end
end
