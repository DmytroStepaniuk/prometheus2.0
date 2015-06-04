class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :set_default_locale
  before_filter :set_default_branch
  before_filter :authorizer_for_profiler

  helper_method :sort_column, :sort_order, :sort_order_next

  def set_default_locale
    params[:locale] ||= 'en'
    I18n.locale = FastGettext.locale = params[:locale]
  end

  def set_default_branch
    params[:branch] ||= 'Sisyphus'
    @branch = Branch.find_by!(name: params[:branch])
  end

  def default_url_options(_options = {})
    { locale: I18n.locale }
  end

  def sort_column
    %w[status name age].include?(params[:sort]) ? params[:sort] : 'name'
  end

  def sort_order
    %w[asc desc].include?(params[:order]) ? params[:order] : 'asc'
  end

  def sort_order_next(column)
    return 'desc' if params[:order] == 'asc' && params[:sort] == column
    return 'asc' if params[:order] == 'desc' && params[:sort] == column
    'asc'
  end

  def authorizer_for_profiler
    if current_user && current_user.admin?
      Rack::MiniProfiler.authorize_request
    end
  end

  rescue_from ActiveRecord::RecordNotFound do
    # TODO
  end
end
