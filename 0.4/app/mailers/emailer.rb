class Emailer < ActionMailer::Base
  default :from => "chosunobri@gmail.com"
  
  HOMEPAGE ="http://obri.or.kr"
  
  # 새 투고가 왔을때 메인데이터에게만 보냄.
  def send_new_paper(paper, who)
    @paper = paper
    @users = User.all
    
    if @paper.status.eql?('Peer review(Revision)')
        title = "OBRI ## A revised paper resubmission"
    else
        title = "OBRI ## A new paper submission"
    end
    
    mail(:to => who, :subject => title)  
      
  end
  
  # comment완성 되었을대 에디터 에게.
  def send_comment_complete(paper, who)
    @users = User.all
    @paper = paper
    
    title = 'OBRI ## All comments have been written : ' + @paper.title
    

    mail(:to => who, :subject => title)  
  end
  
  def send_paper(paper,title, who)
    @paper = paper
    mail(:to => who, :subject => title)  
  end
  
  # 접수 확인 메일 을   작가에게 
  def send_receipt(paper)
    @paper = paper
    
    if @paper.status.eql?('Peer review(Revision)')
        title = "OBRI ## Your revised paper registered : " + @paper.title
    else
        title = 'OBRI ## Your paper was registered :' + @paper.title
    end
    
    mail(:to => paper.email, :subject => title)
  end
  
  def send_result(paper)
    @paper = paper
    mail(:to => paper.email, :subject => 'OBRI ## Result of examination :' + @paper.title)
  end
  
  # role그룹에게 info의 내용으로 from)who로 부터 title과 가이 간다.
  # 현재 코멘트를 메ㄷ에디텡게 알릴대 사용. 
  def send_info_to_role(paper,info, title, who, from_who)
    @paper = paper
    @from_who = from_who
    @info = info

    mail(:to => who, :subject => title)  
  end
  
  def send_status(paper)
    @status = paper.status
    @title = paper.title
 
    if @status.eql?("On chief editor")
      @title = "OBRI ## Your paper was passed to chief editor "
    elsif @status.eql?("Peer review")
      @title = "OBRI ## Your paper are in Peer review "
    elsif @status.eql?("On chief reviewer")
      @title = "OBRI ## Your paper was passed to chief reviewer "
    else
    end
    mail(:to => paper.email, :subject => @title)  
  end
  
end
