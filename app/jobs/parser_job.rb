class ParserJob < ApplicationJob
  queue_as :default

  def perform(*args)
    ParserService.new.index
  end
end
