class ParserJob < ApplicationJob
  queue_as :default

  def perform(*args)
    ParserController.new.index
    #EmailLogger.new("parser.log",)
  end
end
