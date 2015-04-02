class RssController < ApplicationController
  def index
    @branch = Branch.where(name: params[:branch]).first
    @srpms = @branch.srpms.where('srpms.created_at > ?', Time.now - 2.day).order('srpms.created_at DESC').all
    render layout: nil
    response.headers['Content-Type'] = 'application/xml; charset=utf-8'
  end
end
