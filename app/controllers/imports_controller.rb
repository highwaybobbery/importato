class ImportsController < ApplicationController

  before_filter :authenticate_user!

  def new
  end

  def create
    result = import_file
    if result[:success]
      redirect_to purchases_path, flash: result
    else
      redirect_to new_import_path, flash: result
    end
  rescue ActionController::ParameterMissing
    redirect_to new_import_path, flash: { error: 'Please select a file' }
  end

  private

  def import_file
    FileImporter.new(import_params[:file].tempfile.path).import!
  end

  def import_params
    params.require(:import).permit(:file)
  end

end
