class Course < ActiveRecord::Base
  
  # Ife : I added a few new attributes that may be interesting to play with: popularity can be determined by the number of student taking it and the rating. More ideas are encouraged and whether we want something like poplarity is still on the table 

  attr_accessible :year, :semester, :num, :department, :section_num, :professor_id, :class_times_array, :average_rating, :popularity, :institution_id 
  has_many :transcriptitems
  has_many :users, through: :transcriptitems
  belongs_to :institution
  belongs_to :professor

  # serialize arrays and hash attributes used when loading 
  serialize :class_times_array, Array

end