class UploadController < ApplicationController
  def index

  end

  def uploadFile
    post = Upload.import( params[:upload] )
    render :text => "<pre>File uploaded:\n#{post}</pre>"
  end
end
