class EmailLogger
  #attr_reader :file, :txt, :error

  def initialize(file, txt, error)
    @file = file
    @txt = txt
    @error = error
  end

  def save
    f = "#{Rails.root}/log/#{@file}"
    File.new(f, "a+")
    logger = Logger.new f

    if @error
      logger.error @txt
    else
      logger.debug @txt
    end
  end
end