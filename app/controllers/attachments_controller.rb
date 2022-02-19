# frozen_string_literal: true

class AttachmentsController < ApplicationController
  def destroy
    authorize! :destroy, attachment
    attachment.purge
  end

  private

  def attachment
    @attachment = ActiveStorage::Attachment.find(params[:id])
  end

  helper_method :attachment
end
