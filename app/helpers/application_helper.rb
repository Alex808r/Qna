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
  
  # кеширование
  def collection_cache_key_for(model)
    klass = model.to_s.capitalize.constantize
    count = klass.count
    max_updated_at = klass.maximum(:updated_at).try(:utc).try(:to_s, :number)
    "#{model.to_s.pluralize}/collection-#{count}-#{max_updated_at}"
  end
end
