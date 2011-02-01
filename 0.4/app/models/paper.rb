class Paper < ActiveRecord::Base
  # paper의 소유자는 user
  belongs_to :user
  
  # validation 체크와 ->ㅇ 보완 필요 
  validates :first_name,  :presence => true
  validates :last_name,  :presence => true
  validates :postal_address,  :presence => true
  validates :postal_code,  :presence => true
  validates :nation,  :presence => true
  validates :phone,  :presence => true
  #validates :fax
  
  validates :email,  :presence => true
  validates_format_of :email,
                      :with =>  /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i,
                      :message => "Its not a valid format"
                      
  validates :title,  :presence => true, :length => { :minimum => 5 }
  # integer
  validates :number_of_authors,  :presence => true
  #text                  
  validates :names_of_authors,  :presence => true
  validates :emails_of_authors,  :presence => true
  
  validates :abstract,  :presence => true
  validates :types,  :presence => true
  validates :section,  :presence => true

  # Coveletter
  has_attached_file :coverletter
  
  # PDFs
  has_attached_file :manuscript
   
  # supplemental files
  # 다수 그림 파일 처리.
  has_many :assets, :dependent => :destroy
  accepts_nested_attributes_for :assets, :allow_destroy => true
  
  # 선택지 설정.
  STATUS  = ['On editing','Submitted', 'On chief editor', 'Peer review','Peer review(Revision)','On chief reviewer','On chief reviewer(Revision)','Revision','Rejected','Accepted']
  
  TYPES = %w[Article Review Case_report Note]
  
  SECTIONS  =['Human Biology', 'Oral Anatomy','Oral Physiology','Oral Biochemistry','Oral Microbiology','Oral Histology',
              'Dental Materials','Dental Pharmacology','Oral and maxillofacial pathology','Oral Medicine',
              'Oral and Maxillofacial Radiology','Preventive and Public Health Dentistry','Oral Conservative Dentistry',
              'Pediatric Dentistry','Periodontology','Oral and Maxillofacial Surgery','Prosthodontics','Orthodontics']
  
  COUNTRYS = %w[ Korea,_Republic_of_(South_Korea)
  
    AFGHANISTAN ALBANIA ALGERIA AMERICAN_SAMOA ANDORRA ANGOLA ANGUILLA ANTARCTICA ARGENTINA ARMENIA ARUBA 
                 AUSTRALIA AUSTRIA AZERBAIJAN BAHAMAS BAHRAIN BANGLADESH BARBADOS BELARUS BELGIUM BELIZE BENIN BERMUDA BHUTAN BOLIVIA
                 BOSNIA_AND_HERZEGOVINA BOTSWANA BOUVET ISLAND BRAZIL BRUNEI BULGARIA BURUNDI CAMBODIA CAMEROON CANADA 
                 CAYMAN_ISLANDS CENTRAL_AFRICAN_REPUBLIC  CHAD CHILE CHINA CHRISTMAS_ISLAND COLOMBIA COMOROS CONGO COOK_ISLANDS 
                 COSTARICA COTE_D'IVOIRE CROATIA CUBA CURACAO CYPRUS CZECH_REPUBLIC DENMARK DJIBOUTI DOMINICA DOMINICAN_REPUBLIC   
               	ECUADOR EGYPT EL_SALVADOR ERITREA ESTONIA ETHIOPIA FRANCE GABON GAMBIA GEORGIA GERMANY GHANA GIBRALTAR GREECE 
               	GREENLAND GRENADA GUADELOUPE GUAM GUATEMALA GUERNSEY GUINEA GUINEA-BISSAU GUYANA HOLY_SEE HONDURAS HONGKONG HUNGARY
               	ICELAND INDIA INDONESIA IRAN IRAQ IRELAND ISRAEL ITALYJAMAICA JAPAN JERSEY JORDAN   
               	KAZAKHSTAN KENYA 
               	Korea,_Democratic_People's_Republic_of_(North_Korea)
               	KUWAIT KYRGYZSTAN   
               	LATVIA LEBANON LIBERIA JAMAHIRIYA LIECHTENSTEIN LITHUANIA LUXEMBOURG   
               	MALAYSIA MALDIVES MALI MALTA MEXICO MONACO MONGOLIA MONTENEGRO MONTSERRAT MOROCCO MOZAMBIQUE MYANMAR   
               	NEPAL NETHERLANDS NEW_CALEDONIA NEW_ZEALAND NICARAGUA NIGERIA NORWAY OMAN   
               			 PAKISTAN PANAMA PAPUA_NEW_GUINEA PARAGUAY PERU PHILIPPINES POLAND PORTUGAL PUERTO_RICO QATAR   
               		 ROMANIA RUSSIAN_FEDERATION RWANDA   
               			  SAMOA SAUDI_ARABIA SENEGAL SERBIA SINGAPORE SLOVAKIA SOUTH_AFRICA SPAIN SRI_LANKA SUDAN 
               			  SWAZILAND SWEDEN SWITZERLAND TAIWAN THAILAND TUNISIA TURKEY   
              UGANDA ARAB_EMIRATES UNITED_KINGDOM UNITED_STATES_OF_AMERICA URUGUAY UZBEKISTAN VENEZUELA YEMEN ZAMBIA ZIMBABWE


                 ]  
end
