class SecurityController < ApplicationController
  def index
    @branch = Branch.where(name: params[:branch]).first
    @changelogs = @branch.changelogs.where("changelogs.changelogtext LIKE '%CVE%'").includes(:srpm).includes(srpm: [:branch]).order('changelogs.changelogtime DESC').page(params[:page]).per(50)
  end
end
