class SearchesController < ApplicationController
  def show
    @branch = Branch.where(name: params[:branch]).first
    @branches = Branch.order('order_id').all
    if params[:query].nil? || params[:query].empty?
      redirect_to controller: 'home', action: 'index'
    else
      @srpms = Srpm.search(
        Riddle::Query.escape(params[:query]),
        order: :name,
        max_matches: 10_000,
        per_page: 10_000,
        with: { branch_id: @branch.id },
        include: :branch
      )
      redirect_to(srpm_path(@branch, @srpms.first), status: 302) if @srpms.count == 1
    end
  rescue Mysql2::Error
    render 'search_is_not_available'
  end
end
