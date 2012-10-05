require File.dirname(__FILE__) + '/../spec_helper'

describe SprintsController do
  it "should be an abstract_security_controller" do
    controller.is_a?(AbstractSecurityController).should be_true
  end
  
  describe "before filters" do
    before(:each) do
      stub_login_and_account_setup
      @sprint = Sprint.new
    end

    SprintsController.instance_methods(false).each do |action|
      it "should ensure iteration length specified for action #{action}" do
        @account.should_receive(:iteration_length).and_return([])
        get action.to_sym
        response.should be_redirect
        response.should redirect_to(:action => 'settings', :controller => 'account')
      end
    end
    
    %w(show edit plan update destroy).each do |action|
      it "should set sprint on '#{action}'" do
        controller.stub!(:iteration_length_must_be_specified).and_return(true)
        get action.to_sym
      end
    end
  end
  
  describe "#new" do
    before(:each) do
      stub_login_and_account_setup
      controller.stub!(:iteration_length_must_be_specified).and_return(true)
      @sprint = Sprint.new
    end
    
    it "should instantiate object" do
      @account.sprints.should_receive(:new).and_return(@sprint)
      get :new
      assigns(:sprint).should == @sprint
    end
  end
  
  describe "#plan" do
    before(:each) do
      stub_login_and_account_setup
      controller.stub!(:iteration_length_must_be_specified).and_return(true)
      @sprint = Sprint.new
    end
    
    it "should render 404 if sprint finished" do
      pending
      @account.sprints.stub!(:find).and_return(@sprint)
      @sprint.should_receive(:finished?).and_return(true)
      controller.should_receive(:render).with(:file => "#{RAILS_ROOT}/public/404.html", :status => 404)
      get :plan
    end
    
    it "shouldn't render 404 if active or future sprint" do
      pending
      @account.sprints.stub!(:find).and_return(@sprint)
      @sprint.should_receive(:finished?).and_return(false)
      get :plan
      response.should be_success
    end
  end
  
  describe "#index" do
    before(:each) do
      stub_login_and_account_setup
    end
    
    describe "after before filters" do
      before(:each) do
        stub_iteration_length
      end

      it "should load all the sprints" do
        @account.should_receive(:sprints).and_return(['sprint'])
        get :index
        assigns[:sprints].should == ['sprint']
      end
    end
  end
  
  describe "#destroy" do
    before(:each) do
      stub_login_and_account_setup
      controller.stub!(:iteration_length_must_be_specified).and_return(true)
      @sprint = Sprint.new
    end
    
    it "should destroy and redirect to sprints with flash on success" do
      @account.sprints.should_receive(:find).and_return(@sprint)
      @sprint.should_receive(:destroy).and_return(true)
      post :destroy
      response.should be_redirect
      response.should redirect_to(:action => 'index')
      flash[:error].should be_nil
      flash[:notice].should_not be_nil
    end    
    
    it "should destroy and redirect to sprints with flash on fail" do
      @account.sprints.should_receive(:find).and_return(@sprint)
      @sprint.should_receive(:destroy).and_return(false)
      post :destroy
      response.should be_redirect
      response.should redirect_to(:action => 'index')
      flash[:error].should_not be_nil
      flash[:notice].should be_nil
    end
  end
  
  describe "#create" do
    before(:each) do
      stub_login_and_account_setup
      controller.stub!(:iteration_length_must_be_specified).and_return(true)
      @sprint = Sprint.new
      @sprint.stub!(:account).and_return(@account)
    end

    it "should create sprint and redirect on success" do
      @account.sprints.should_receive(:new).with('sprinthash').and_return(@sprint)
      @sprint.should_receive(:save).and_return(true)
      post :create, :sprint => 'sprinthash'
      response.should be_redirect
      response.should redirect_to(:action => 'index')
    end
    
    it "should create sprint and redirect on fail" do
      @account.sprints.should_receive(:new).with('sprinthash').and_return(@sprint)
      @sprint.should_receive(:save).and_return(false)
      controller.should_receive(:render).with(:action => 'new')
      post :create, :sprint => 'sprinthash'
    end
    
    it "should calculate start date if blank" do
      @sprint.account.should_receive(:iteration_length).and_return(2)
      @sprint.start_at = nil
      @account.sprints.stub!(:new).and_return(@sprint)
      post :create, :from => {:year => '2008', :month => '4', :day => '1'}
    end
  end
  
  describe "#update" do
    before(:each) do
      stub_login_and_account_setup
      controller.stub!(:iteration_length_must_be_specified).and_return(true)
      @sprint = Sprint.new
    end
    
    it "should update sprint and redirect on success" do
      @account.sprints.should_receive(:find).and_return(@sprint)
      @sprint.should_receive(:update_attributes).with('sprinthash').and_return(true)
      post :update, :sprint => 'sprinthash'
      response.should be_redirect
      response.should redirect_to(:action => 'index')
    end
    
    it "should update sprint and redirect on fail" do
      @account.sprints.should_receive(:find).and_return(@sprint)
      @sprint.should_receive(:update_attributes).with('sprinthash').and_return(false)
      controller.should_receive(:render).with(:action => 'edit')
      post :update, :sprint => 'sprinthash'
    end
  end
  
  describe "#show" do
    before(:each) do
      stub_login_and_account_setup
    end
    
    describe "after before filters" do
      before(:each) do
        stub_iteration_length
      end
    
      it "should ensure sprint exists" do
        @sprint = Sprint.new(:start_at => 1.months.ago, :end_at => 2.weeks.ago)
        @account.sprints.should_receive(:find).with('23').and_return(@sprint)
        get :show, :id => 23
        assigns[:sprint].should == @sprint
        assigns[:current_sprint].should == @sprint
      end
    
      describe "by loading a real sprint" do
        before(:each) do
          @sprint = Sprint.new(:start_at => 1.day.ago, :end_at => 1.day.from_now)
          @account.sprints.should_receive(:find).with('23').and_return(@sprint)          
        end
        
        it "should call create_chart"

        it "should render show_task_board if current sprint and calc burndown" do
          controller.stub!(:calculate_burndown_points)
          controller.stub!(:calculate_todays_burndown)
          @sprint.should_receive(:current?).and_return(true)
          controller.should_receive(:calculate_tomorrows_burndown).exactly(1).times
          get :show, :id => 23
          response.should render_template("sprints/task_board")
        end

        it "should render show if not current sprint and NOT calc burndown" do
          controller.stub!(:calculate_burndown_points)
          @sprint.should_receive(:current?).and_return(false)
          controller.should_receive(:calculate_tomorrows_burndown).exactly(0).times
          get :show, :id => 23
          response.should render_template("sprints/show")
        end
      end    
    end
  end
end
