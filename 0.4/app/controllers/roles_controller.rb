class RolesController < ApplicationController
 # DB이름이 users여서 그런지 controller 이름을 users로 해주어야 정상작동.
  
  # 로그인 하지 않으면 볼수 없음. 특정 페이지로 바로 이동하면 이로그인 화면이 뜬다. 
  #before_filter :authenticate_user!
  before_filter :authenticate_user!
  
  #TODO : Administrator 만 관리 할 수 있게.

  def index    
  end
  
  def all_user
    @users = User.all
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end
  
  def change_role
    @user = User.find(params[:id])
    
    @user.role = params[:role]
    temp = @user.name
    
    @notice = "You assigned " + temp + " to the examiner"

    respond_to do |format|
      if @user.update_attributes(params[:id])
        format.html { redirect_to(all_user_roles_path, :notice => @notice) }
      else
        format.html { redirect_to(all_user_roles_path, :notice => 'You got an error, please retry.')} 
      end
    end    

  end
  
  def manage_role
    @users = User.all
    
    @examiners = Array.new
    @editors = Array.new
    
    @users.each do |user|
      if user.role.eql?('Reviewer')
        @examiners.push(user) 
      end
    end
  
    @users.each do |user|
      if user.role.eql?('Chiefeditor')
        @editors.push(user) 
      end
    end

  end
  
  def assignment
    @papers = Paper.all
    @users = User.all
    
    # examiner1,examiner2,examiner3 가 모두 채워지지 않은 경우에만 배정. 
    @unassigned = Array.new
    @assigned = Array.new
    
    # ㅋ컨펌 한 것아중 처음 보는 것들은 편집위원장으로 status 체인지.
    @papers.each do |p|
      if p.status.eql?("Submitted")
        p.status = "On chief editor"
        p.save
        # 작가에세 메일 스테이터스 변경 발송.
        #Emailer.send_status(p).deliver
      end
    end  
    
    @papers.each do |paper|
      if paper.status.eql?("On chief editor")
        @unassigned.push(paper) 
      elsif paper.status.eql?("Submitted")
        # 올페이퍼에서 안보고 바로오는 경우도 있다. 
        paper.status = "On chief editor"
        paper.save
        # 작가에세 메일 스테이터스 변경 발송.
        #Emailer.send_status(paper).deliver
        @unassigned.push(paper) 
      elsif paper.status.eql?("Peer review")
        @assigned.push(paper) 
      end
    end
    
    @temp = get_examiners
    @examiners = []
    
    @temp.each do |id, name|
      @examiners.push(id.to_s + '. '+name)
    end
 
  end
  
  def make_assignment
    @paper = Paper.find(params[:id])
    
    # 2번 배정이 없어야 실행. 
    unless params[:examiner1] == params[:examiner2] or params[:examiner1] == params[:examiner3] or params[:examiner2] == params[:examiner3]    
      @paper.examiner_name1 = params[:examiner1]
      @paper.examiner_name2 = params[:examiner2]
      @paper.examiner_name3 = params[:examiner3]
    
      # id로 이메일을 찾는다.
      @paper.examiner1 = User.find(params[:examiner1].split(".")[0]).email
      @paper.examiner2 = User.find(params[:examiner2].split(".")[0]).email
      @paper.examiner3 = User.find(params[:examiner3].split(".")[0]).email
    
      @paper.status = "Peer review"
      @paper.save
      
      title = 'OBRI ## You are assigned to reviewer : ' + @paper.title
      #리 리뷰어들에게 메일 보내는거 추가.
      Emailer.send_paper(@paper,  title, @paper.examiner1).deliver
      Emailer.send_paper(@paper,  title, @paper.examiner2).deliver
      Emailer.send_paper(@paper,  title, @paper.examiner3).deliver
      
      #Emailer.send_status(@paper).deliver   
    end
    
    @notice = params[:examiner1].split(".")[1].lstrip + ", " + params[:examiner2].split(".")[1].lstrip + "," + params[:examiner3].split(".")[1].lstrip + "  were assigned to paper as reviewer."
    respond_to do |format|
      if params[:examiner1] == params[:examiner2] or params[:examiner1] == params[:examiner3] or params[:examiner2] == params[:examiner3]
        format.html { redirect_to(assignment_roles_path, :notice => "One reviewer was assigned twice. Your assignment command didn't excute.") }
      elsif @paper.update_attributes(params[:id])
        format.html { redirect_to(assignment_roles_path, :notice => @notice) }
      else
        format.html { redirect_to(assignment_roles_path, :notice => 'You got an error, please retry.')}
      end     
    end
  end
  
  # id와 이름을  리턴.
  def get_examiners
    @users = User.all
    @examiners = Hash.new
    
    @users.each do |user|
      if user.role.eql?("Reviewer")
        @temp = { user.id => user.name }
        @examiners.merge!(@temp)
      end
    end
    
    return @examiners
  end
  
end