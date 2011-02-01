class PapersController < ApplicationController
  # cancan 인증 작업. 각 작업에 대해서 인증된사 사람만이 접근. 자신의 논문만 제어하는 것은 ability.rb에서 처리. 
  load_and_authorize_resource
  
  # 로그인 하지 않으면 볼수 없음. 특정 페이지로 바로 이동하면 이로그인 화면이 뜬다. 
  before_filter :authenticate_user!
  #before_filter :authenticate_user!, :except => [:show, :index]
  
  # GET /papers
  # GET /papers.xml
  def index
    # cancan 인증으로 필요 없음.
    # 모든 사용장의 논문을 보여준다.
    #@papers = Paper.all
    
    #현재 사용자의 논문만 보여준다. 
    @papers = current_user.papers.all
      
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @papers }
    end
  end
  
  # GET /papers/1
  # GET /papers/1.xml
  def show
    # cancan 인증으로 필요 없음.
    #@paper = Paper.find(params[:id])
   
    # 어드민이나 에디터의 코멘트 처리를 위해 필요.
    if current_user.role.eql?("Administrator") or current_user.role.eql?("Chiefeditor") 
      @comments = { @paper.examiner1 => [@paper.examiner_name1.split(".")[1].lstrip, @paper.comment1], @paper.examiner2 => [@paper.examiner_name2.split(".")[1].lstrip, @paper.comment2], @paper.examiner3 => [@paper.examiner_name3.split(".")[1].lstrip, @paper.comment3]}
    elsif current_user.role.eql?("Reviewer")               
      # 심사위원이 남긴콭멘트 내가 마긴 코멘트이다. 
      @my_comment = filter_for_review(@paper, current_user)
    end
    

    ################ TEST ##################
    #@paper.examiner_name1 = "4. 심사위원"
    #@paper.examiner_name2 = "8. 심사위원2"
    #@paper.examiner_name3 = "6. Bean"
    
    #@paper.examiner1 = "examiner@g.com"
    #@paper.examiner2 = "examiner2@g.com"
    #@paper.examiner3 = "jinwoojiji@gmail.com"
    
    #@paper.comment1 = ""
    #@paper.comment2 = ""
    #@paper.comment3 = ""
    
    #@paper.status = 'Peer review'
    #@paper.save
    ############### TEST ###################
    
    
    # 다른 방법 접근 예를 들어. localhost:3000/papers/13 시으로 숫자를 바로 입력 하
    # Reviewer는 접근이 가능 하니 문제가 있음. Reviewer는 읽는것은 모든게 가능.
    # 그래서런 이런 접근을 막기 위해서 examiner 의 접근을 자기가 가진 것과 리뷰 할 수 있는 것만 으로 제한. 
    # 이 제한은 위와 같인 임의로 접근 하는 것을 위한 것이고 다른 곳에서는 이미 구비되어 있음.
    # 다른 곳에서는 index에서 이미 필터하여 보이지가 않음. 
    if current_user.role.eql?('Reviewer')
      unless current_user.papers.include?(@paper) 
        flash[:error] = "Access denied!"  
        #redirect_to root_url
      end
      unless filter_for_review(@paper, current_user)
        flash[:error] = "Access denied!"  
        #redirect_to root_url
      end
    end
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @paper }
    end
  end

  # GET /papers/new
  # GET /papers/new.xml
  def new
    # cancan 인증으로 필요 없음.
    #@paper = Paper.new
    # 부가파일 갯수 정의. 5개 까지 정의 하고 업로드으 되었을 경우 그 수만큼 빼고 보여줌.  
    (10 - @paper.assets.length).times { @paper.assets.build }

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @paper }
    end
  end

  # GET /papers/1/edit
  def edit
    # cancan 인증으로 필요 없음.
    #@paper = Paper.find(params[:id])
    # 수정시 시간 변경.
    t = Time.new
    @paper.receive_time = t.strftime("%Y-%m-%d %H:%M")
    
   # (5 - @paper.assets.length).times { @paper.assets.build }
  end

  # POST /papers
  # POST /papers.xml
  def create
    ##########################################################################################
    # paper와 user 연동을 위해 필수 적인곳. 하위 개념인 paper에 상위 개념에 해당하는 user의 user_id의 integer 형을 만들어 주어야
    # cancan 인증에서도 이건 필요함. 
    ##########################################################################################
    @paper = current_user.papers.build(params[:paper])

    ################ Initial value ##################
    @paper.status = 'On editing'
    t = Time.new
    @paper.receive_time = t.strftime("%Y-%m-%d %H:%M:%S")
    @paper.nation = 'Korea'
    
    @paper.examiner_name1 = "0. Not yet assigned"
    @paper.examiner_name2 = "0. Not yet assigned"
    @paper.examiner_name3 = "0. Not yet assigned"
    
    @paper.examiner1 = "Not yet"
    @paper.examiner2 = "Not yet"
    @paper.examiner3 = "Not yet"
    
    @paper.comment1 = "Not yet"
    @paper.comment2 = "Not yet"
    @paper.comment3 = "Not yet"
  
    ################ Initial value ##################
    
    
    respond_to do |format|
      if @paper.save
        format.html { redirect_to(@paper, :notice => 'The new submission was successfully created.') }
        format.xml  { render :xml => @paper, :status => :created, :location => @paper }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @paper.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /papers/1
  # PUT /papers/1.xml
  def update
    # cancan 인증으로 필요 없음.
    #@paper = Paper.find(params[:id])

    respond_to do |format|
      if @paper.update_attributes(params[:paper])
        format.html { redirect_to(@paper, :notice => 'The submission was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @paper.errors, :status => :unprocessable_entity }
      end
    end  
  end

  # DELETE /papers/1
  # DELETE /papers/1.xml
  def destroy
    # cancan 인증으로 필요 없음.
    #@paper = Paper.find(params[:id])
    @paper.destroy

    respond_to do |format|
      format.html { redirect_to(papers_url) }
      format.xml  { head :ok }
    end
  end
  
  ########################  ########################  ########################  ########################
  ### 추가 함수 
  ########################  ########################  ########################  ########################
  
  # term& condition을 보여줌.
  def authorship
  end
  
  ##################################################################################  
  # 상태 변경 함수. 주로 view에서 컨트롤러 쪽으로 읽어오는게 많다. 
  ##################################################################################
  
  # status change. 어드민이 인위적으로 status 변경.
  def change_status
    @paper = Paper.find(params[:id])
    @paper.status = params[:status]
    @paper.save

    respond_to do |format|
      if @paper.update_attributes(params[:id])
        if current_user.role.eql?('Administrator')
      	  format.html { redirect_to(all_paper_papers_path, :notice => 'You changed the status of paper : '+ @paper.title) }
        else
          format.html { redirect_to(filtered_for_editor_papers_path, :notice => 'You changed the status of paper : '+ @paper.title) }
        end
      else
        if current_user.role.eql?('Administrator')
          format.html { redirect_to(all_paper_papers_path, :notice => 'You got an error, please retry.')}
        else
          format.html { redirect_to(filtered_for_editor_papers_path, :notice => 'You got an error, please retry.')}
        end
      end
    end
    
  end
  
  # 투고자의  컨펌 함수 
  def confirm_submission
    @paper = Paper.find(params[:id])
    @editors = get_editors
    
    if @paper.status == 'On editing'
      @paper.status = 'Submitted'
      @paper.save
      # 컨펌시에는 메인에디터에게만 메일 보냄.
    
    # revision일경우엔 바로 peer review로 넘어간다. 이미 심사위원은 정해짐.      
    elsif  @paper.status == 'Revision'
      @paper.status = 'Peer review(Revision)'
      @paper.comment1 = "Not yet"
      @paper.comment2 = "Not yet"
      @paper.comment3 = "Not yet"
      @paper.result = "Not yet"
      @paper.save
      
      title = 'OBRI ## The revised paper comes to you : ' + @paper.title
      #리 리뷰어들에게 메일 보내는거 추가. 지점장과 작가 에게도.
      Emailer.send_paper(@paper,  title, @paper.examiner1).deliver
      Emailer.send_paper(@paper,  title, @paper.examiner2).deliver
      Emailer.send_paper(@paper,  title, @paper.examiner3).deliver      
    else
    end
    
    @editors.each do |editor|
      Emailer.send_new_paper(@paper,editor.email).deliver
    end
    
    Emailer.send_receipt(@paper).deliver
   
   respond_to do |format|
     if @paper.update_attributes(params[:id])
       format.html { redirect_to(papers_path, :notice => 'You have submitted the paper : '+ @paper.title) }
     else
       format.html { redirect_to(papers_path, :notice => 'You got an error, please retry.')}
     end
   end
    
  end
  
  
  # 리절트 치는 함수 에디터가.
  def result
    @paper = Paper.find(params[:id])
    
    # accept 결정. 
    if params[:yn] == "1"
      @paper.status = "Accepted"
    elsif params[:yn] == "0"
      @paper.status = "Revision"
    elsif params[:yn] == "-1"
      @paper.status = "Rejected"
    else
      redirect_to(papers_path, :notice => 'You got an error, please retry.')
    end
    
    # final result 저장.
    @paper.result = params[:result]
    
    @paper.save
    
    Emailer.send_result(@paper).deliver

    respond_to do |format|
      if @paper.update_attributes(params[:id])
        format.html { redirect_to(filtered_for_editor_papers_path, :notice => 'Sent the resulf of the paper : '+ @paper.title) }
      else
        format.html { redirect_to(filtered_for_editor_papers_path, :notice => 'You got an error, please retry.')}
      end
    end
    
    
  end
  
  
  # 심사위원이 코멘트 치는 함수 
  def make_comment
    @paper = Paper.find(params[:id])
    title = @paper.title
    @editors = get_editors
        
    # E-mail 주석 모두 제거.
    if current_user.email.eql?(@paper.examiner1) 
      @paper.comment1 = params[:comment]
    elsif current_user.email.eql?(@paper.examiner2) 
      @paper.comment2 = params[:comment]
    elsif current_user.email.eql?(@paper.examiner3) 
      @paper.comment3 = params[:comment]
    else
      redirect_to(review_papers_path, :notice => 'You got an error')
    end
    
    @editors.each do |editor|
      Emailer.send_info_to_role(@paper, params[:comment],'OBRI ## A new comment on "' + title+ '"',editor.email,current_user.name).deliver
    end
        
    if @paper.comment1 != "Not yet" and @paper.comment2 != "Not yet" and @paper.comment3 != "Not yet"
      if @paper.status == 'Peer review(Revision)'
        @paper.status = 'On chief reviewer(Revision)'
      else
        @paper.status = "On chief reviewer"
      end
      
      #작가에게 하나 보내고.맨 에디터에게 커멘트 끝났으니 파이날 쓰라고 메일 보낸다.
      #Emailer.send_status(@paper).deliver
      @editors.each do |editor|
        Emailer.send_comment_complete(@paper,editor.email).deliver
      end
      
    end
        
    @paper.save
    
    respond_to do |format|
      if @paper.update_attributes(params[:id])
        format.html { redirect_to(review_papers_path, :notice => 'You have commented the paper : '+ @paper.title) }
      else
        format.html { redirect_to(review_papers_path, :notice => 'You got an error, please retry.')}
      end
    end
  end
    
    
  ##################################################################################  
  # listing 함수 
  ##################################################################################  
    
  # 모든 논문을 보여주는 함수 . admin용 
  def all_paper
    # cancan 인증으로 필요 없음.
    # 모든 사용장의 논문을 보여준다.
    @papers = Paper.all
      
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @papers }
    end
  end
  
  ### 끝난 노논문 보여줌. 에디터용.
  def completed_paper 
    @papers = Paper.all
    
    @papers.each do |paper|
      if paper.status != "Accepted" and paper.status != "Rejected" and paper.status != "Revision"
        @papers.delete(paper)
      end
    end
  end
  
  # 컨펌한 것과 리뷰할 것만 보여 준다.
  def filtered_for_editor
    # cancan 인증으로 필요 없음.
    # 모든 사용장의 논문을 보여준다.
    @papers = Paper.all
    
    #기본적으로 컨펌한 것만 통과.
    @papers = filter_for_confirm(@papers)
    
    # ㅋ컨펌 한 것아중 처음 보는 것들은 편집위원장으로 status 체인지.
    @papers.each do |p|
      if p.status.eql?("Submitted")
        p.status = "On chief editor"
        p.save
        # 작가에세 메일 스테이터스 변경 발송.
    #    Emailer.send_status(p).deliver
      end
    end
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @papers }
    end
  end
  
  # 컨펌한 것과 리뷰할 것만 보여 준다. 심사워원용.
  def review
    # cancan 인증으로 필요 없음.
    # 모든 사용장의 논문을 보여준다.
    @papers = Paper.all
    
    #기본적으로 컨펌한 것만 통과.
    @papers = filter_for_confirm(@papers)
    # Reviewer인 경우엔 reviwd 할것만 보여준다.
    if current_user.role.eql?('Reviewer')
      # hash 로 처리해서 받음.
      @papers = filter_for_review(@papers, current_user)
      
    end
      
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @papers }
    end
  end
  
  ##################################################################################  
  # 보조 함수 
  ##################################################################################  
 
  
  # 컨펌한 것만 통과 
  def filter_for_confirm(papers)
    @temp = Array.new
    
    # 어레이를 만들어 어레이 리턴.
    papers.each do |paper|
      if paper.status.eql?("On editing")
        papers.delete(paper)
      end
    end
    
    return papers
  
  end
  
  # 리뷰라 아티클만 거른다. array 뿐만 아니라 객첵 하나만도 가능. 
  def filter_for_review(papers, user)    
    # class끼리 비교하여야 함.
    if papers.class == Array  
      @temp = Hash.new
      @set = Hash.new
      papers.each do |paper|
        # 해시로 처리해서 받는다. merge! 합치는 건데. !는 리턴없이 현재 해쉬에 합치라는 것. 심사중인것과 심사 씉나고 확정 하기 까지 볼수 이쎅 한다.
        if paper.examiner1.eql?(user.email) 
          if paper.status.eql?("Peer review") or paper.status.eql?("On chief reviewer") or paper.status.eql?('Peer review(Revision)') or paper.status.eql?("On chief reviewer(Revision)")
            @set = { paper => [paper.examiner_name1.split(".")[1].lstrip, paper.examiner1, paper.comment1]}
            @temp.merge!(@set) 
          end
        elsif paper.examiner2.eql?(user.email) 
          if paper.status.eql?("Peer review") or paper.status.eql?("On chief reviewer") or paper.status.eql?('Peer review(Revision)') or paper.status.eql?("On chief reviewer(Revision)")
            @set = { paper => [paper.examiner_name2.split(".")[1].lstrip, paper.examiner2, paper.comment2]}          
            @temp.merge!(@set)          
          end
        elsif paper.examiner3.eql?(user.email) 
          if paper.status.eql?("Peer review") or paper.status.eql?("On chief reviewer") or paper.status.eql?('Peer review(Revision)') or paper.status.eql?("On chief reviewer(Revision)")  
            @set = { paper => [paper.examiner_name3.split(".")[1].lstrip, paper.examiner3, paper.comment3]}
            @temp.merge!(@set)
          end                        
        end
      end
      
    # 클래스가 아닌경우엔 paper 하나임. paper하나만 반환.array 리턴.
    else
      @temp = Array.new
      if papers.examiner1.eql?(user.email)  
        if paper.status.eql?("Peer review") or paper.status.eql?("On chief reviewer") or paper.status.eql?('Peer review(Revision)') or paper.status.eql?("On chief reviewer(Revision)")
          @temp = [ papers, papers.examiner_name1.split(".")[1].lstrip, papers.examiner1, papers.comment1]
        end
      elsif papers.examiner2.eql?(user.email)
        if paper.status.eql?("Peer review") or paper.status.eql?("On chief reviewer") or paper.status.eql?('Peer review(Revision)') or paper.status.eql?("On chief reviewer(Revision)")
          @temp = [ papers, papers.examiner_name2.split(".")[1].lstrip, papers.examiner2, papers.comment2]
        end
      elsif papers.examiner3.eql?(user.email)
        if paper.status.eql?("Peer review") or paper.status.eql?("On chief reviewer") or paper.status.eql?('Peer review(Revision)') or paper.status.eql?("On chief reviewer(Revision)")
          @temp = [ papers, papers.examiner_name3.split(".")[1].lstrip, papers.examiner3, papers.comment3]
        end
      end
    end  
    
    return @temp
  end
  
  def get_editors
    @users = User.all
    
    @users.each do |user|
      unless user.role.eql?("Chiefeditor")
        @users.delete(user)
      end
    end
    
    return @users
  end
end