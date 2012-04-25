module AccountStuff
  AccountStuff::RESERVED_SUBDOMAINS = %w(app www site we blog dev stage)
  AccountStuff::TEAM_AGILEISTA = ["lebreeze@gmail.com"]
  AccountStuff::MASTER_SUBDOMAIN = "app"
  AccountStuff::DOMAIN = "agileista.com"
  AccountStuff::SIGNUP_SITE = "#{AccountStuff::MASTER_SUBDOMAIN}.#{AccountStuff::DOMAIN}"

  protected
  
  def current_user
    @current_user ||= login_to_subdomain
  end

  def login_to_subdomain
    begin
      session[:account_subdomain] = current_subdomain
      account = Account.find_by_subdomain(session[:account_subdomain])
      @current_user = (session[:user] && session[:account_subdomain]) ? account.people.find(session[:user]) : nil
    rescue
      session[:user] = nil
      session[:account_subdomain] = nil
      session[:timeout] = nil
      @current_user = nil
    end
  end
  
  def do_logout
    session[:user] = nil
    session[:account_subdomain] = nil
    session[:timeout] = nil
  end
    
  def logged_in?
    current_user.nil? ? false : true
  end
  
  # adds ActionView helper methods
  def self.included(base)
    base.send :helper_method, :logged_in?, :current_user
  end
end
