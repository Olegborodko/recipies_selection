class SaveToLog
  # EmailLogger
  def initialize(file, txt, error)
    @file = file
    @txt = txt
    @error = error
  end

  def save
    logger = Logger.new "#{Rails.root}/log/#{@file}"

    if @error
      logger.error @txt
    else
      logger.debug @txt
    end
  end

end