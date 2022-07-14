class ErrorsController < ApplicationController
  rescue_from SyntaxError, NoMethodError, ArgumentError do |e|
    Rails.logger.error("Error has occurred. Message: #{e.clean_message}, backtrace: #{e.clean_backtrace}")
    render "error_422", status: :unprocessable_entity
  end

  def index
    raise ArgumentError
  end

  def index_begin_rescue_ensure
    raise ArgumentError
  rescue ArgumentError => e
    Rails.logger.error("ArgumentError has occurred. Message: #{e.clean_message}, backtrace: #{e.clean_backtrace}")
    render(:status => :unprocessable_entity, json: "Try with better params! :D ")
    return
  ensure
    Rails.logger.info("Show must go on")
  end
end
