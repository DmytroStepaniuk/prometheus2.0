class HomeController < ApplicationController
  layout "default"

  def index
    @package_counter = Srpm.count :conditions => { :branch => 'Sisyphus' }
    @top15 = Packager.find_by_sql("SELECT COUNT(acls.package) AS counter,
                                          packagers.name AS name,
                                          packagers.login AS login
                                   FROM acls, packagers
                                   WHERE packagers.login = acls.login
                                   AND packagers.team = false
                                   AND acls.branch = 'Sisyphus'
                                   GROUP BY packagers.name, packagers.login
                                   ORDER BY 1 DESC LIMIT 15")
  end

  def project
    @package_counter = Srpm.count :conditions => { :branch => 'Sisyphus' }
  end

  def news
    @package_counter = Srpm.count :conditions => { :branch => 'Sisyphus' }
  end

  def security
    @package_counter = Srpm.count :conditions => { :branch => 'Sisyphus' }
  end

  def rss
    @package_counter = Srpm.count :conditions => { :branch => 'Sisyphus' }
  end

  def stats
    @packages_counter = Srpm.count
  end

  def top15
#    @top15 = Packager.find_by_sql("SELECT COUNT(srpms.name) AS counter, packagers.name AS name, packagers.login AS login FROM srpms, packagers WHERE packagers.id = srpms.packager_id AND packagers.team = false AND srpms.branch = 'Sisyphus' GROUP BY packagers.name, packagers.login ORDER BY 1 DESC LIMIT 1500")
    @top15 = Packager.find_by_sql("SELECT COUNT(acls.package) AS counter, packagers.name AS name, packagers.login AS login FROM acls, packagers WHERE packagers.login = acls.login AND packagers.team = false AND acls.branch = 'Sisyphus' GROUP BY packagers.name, packagers.login ORDER BY 1 DESC LIMIT 1500")
  end

  def search
    @package_counter = Srpm.count :conditions => { :branch => 'Sisyphus' }

    @search = Srpm.name_or_summary_or_description_like_all(params[:search].to_s.split).branch_equals("Sisyphus").ascend_by_name
    @srpms, @srpms_count = @search.all, @search.count
  end

  def groups_list
    @package_counter = Srpm.count :conditions => { :branch => 'Sisyphus' }

    @groups = Group.find_by_sql("SELECT COUNT(srpms.name) AS counter,
                                        groups.name
                                 FROM srpms, groups
                                 WHERE groups.branch = 'Sisyphus'
                                 AND srpms.group = groups.name
                                 GROUP BY groups.name
                                 ORDER BY groups.name")
  end

  def bygroup
    @package_counter = Srpm.count :conditions => { :branch => 'Sisyphus' }

    # TODO: Change Sisyphus
    @group = Group.find :first,
                        :conditions => {
                          :name => params[:group],
                          :branch => 'Sisyphus' }
    @srpms = Srpm.find :all,
                       :conditions => {
                         :group => @group.name,
                         :branch => 'Sisyphus' },
                       :order => 'name ASC'
  end

  def bytwogroup
    @package_counter = Srpm.count :conditions => { :branch => 'Sisyphus' }

    @group = Group.find :first,
                        :conditions => {
                          :name => params[:group] + '/' + params[:group2],
                          :branch => 'Sisyphus' }
    @srpms = Srpm.find :all,
                       :conditions => {
                         :group => @group.name,
                         :branch => 'Sisyphus' },
                       :order => 'name ASC'
  end

  def bythreegroup
    @package_counter = Srpm.count :conditions => { :branch => 'Sisyphus' }
    
    @group = Group.find :first,
                        :conditions => {
                          :name => params[:group] + '/' + params[:group2] + '/' + params[:group3],
                          :branch => 'Sisyphus' }
    @srpms = Srpm.find :all,
                       :conditions => {
                         :group => @group.name,
                         :branch => 'Sisyphus' },
                       :order => 'name ASC'
  end

  def packagers_list
    @package_counter = Srpm.count :conditions => { :branch => 'Sisyphus' }

    @packagers = Packager.find_by_sql("SELECT COUNT(acls.package) AS counter,
                                              packagers.name AS name,
                                              packagers.login AS login
                                       FROM acls, packagers
                                       WHERE packagers.login = acls.login
                                       AND packagers.team = false
                                       AND acls.branch = 'Sisyphus'
                                       GROUP BY packagers.name, packagers.login
                                       ORDER BY 1 DESC")

    @teams = Packager.find_by_sql("SELECT COUNT(acls.package) AS counter,
                                          packagers.name AS name,
                                          packagers.login AS login
                                   FROM acls, packagers
                                   WHERE packagers.login = acls.login
                                   AND packagers.team = true
                                   AND acls.branch = 'Sisyphus'
                                   GROUP BY packagers.name, packagers.login
                                   ORDER BY 1 DESC")
  end

end
