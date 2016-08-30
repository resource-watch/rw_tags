module V1
  class InfoController < ApplicationController
    def docs
      @docs = YAML.load(File.read('lib/files/swagger.yml')).to_json
      render json: @docs
    end

    def info
      @service = ServiceSetting.save_gateway_settings(params)
      if @service
        @docs = Oj.load(File.read("lib/files/service_#{ENV['RAILS_ENV']}.json"))
        render json: @docs
      else
        render json: { success: false, message: 'Missing url and token params' }, status: 422
      end
    end
  end
end
