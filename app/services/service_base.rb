class ServiceBase
  def self.call(**args)
    new(**args).call
  end

  def on_success(data)
    OpenStruct.new(success?: true, data: data, errors: nil)
  end

  def on_failure(errors, data = nil)
    OpenStruct.new(success?: false, data: data, errors: errors)
  end
end
