class ReleasesController < AbstractSecurityController
  
  # ssl_required :index, :new, :create, :edit, :update, :show, :plan
  before_filter :must_be_team_member, :except => [:index]
  
  def index
    @releases = @account.releases.find(:all, :order => 'releases.name, user_stories.position', :include => [:user_stories])
    @velocity = params[:velocity] || 50
  end
  
  def new
    @release = @account.releases.new
  end
  
  def create
    @release = @account.releases.new(params[:release])
    if @release.save
      flash[:notice] = "Release saved successfully"
      redirect_to :action => 'index'
    else
      flash[:error] = "There were issues saving the release"
      render :action => 'new'
    end
  end
  
  def edit
    @release = @account.releases.find(params[:id])
  end
  
  def update
    @release = @account.releases.find(params[:id])
    if @release.update_attributes(params[:release])
      flash[:notice] = "Release saved successfully"
      redirect_to :action => 'index'
    else
      flash[:error] = "There were issues saving the release"
      render :action => 'edit', :id => params[:id]
    end
  end
  
  def show
    @release = @account.releases.find(params[:id])
  end
end