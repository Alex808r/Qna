# frozen_string_literal: true

module ApplicationHelper
  # использование таблицного метода
  FLASH_TYPES_TO_CSS_CLASS = {
    notice: 'info',
    alert: 'warning',
    error: 'danger'
  }.freeze

  def class_for_flash_message(key)
    FLASH_TYPES_TO_CSS_CLASS.fetch(key.to_sym, key)
  end
end
