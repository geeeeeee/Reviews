class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  # role 추가 하엿음. 이렇게 해야 수정ㅡ 및 접근 가능. 
  # section은 섹션에만 종사 할 경우 치프 같은 경우에 고려.
  attr_accessible :email, :password, :password_confirmation, :remember_me, :role, :name, :section
  
  # paper 를 위한 설정 
  #has_many :papers, :dependent => :destroy
  #accepts_nested_attributes_for :papers, :allow_destroy => true
  has_many :papers, :dependent => :destroy
  accepts_nested_attributes_for :papers, :allow_destroy => true
  
  # role 설정 
  # role bases authorization. 루비에서 끝내고 db를 사용하지 않음.
  ROLES = %w[Author Administrator Chiefeditor Reviewer]
  ROLES_FOR_EDITOR = %w[Author Chiefeditor Reviewer]
  

end
