class SaveToLog
  # EmailLogger
  def initialize(file, txt, success)
    @file = file
    @txt = txt
    @success = success
  end

  def save
    logger = Logger.new "#{Rails.root}/log/#{@file}"

    if @success
      logger.debug @txt
    else
      logger.error @txt
    end
  end

end