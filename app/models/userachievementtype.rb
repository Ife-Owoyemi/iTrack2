class Userachievementtype < ActiveRecord::Base
  attr_accessible :achievementname, :achievementtype, :college, :specialty
  belongs_to :user
  def self.achievementhashgenerator(modelArray)
    achievementhash = Hash.new
    modelArray.each do |type|
      if !achievementhash.has_key?(type.achievementtype)
        achievementhash[type.achievementtype] = Hash.new
      end
      if !achievementhash[type.achievementtype].has_key?(type.college)
        achievementhash[type.achievementtype][type.college] = Hash.new
      end
      if !achievementhash[type.achievementtype][type.college].has_key?(type.achievementname)
        achievementhash[type.achievementtype][type.college][type.achievementname] = Hash.new
      end
      if !achievementhash[type.achievementtype][type.college][type.achievementname].has_key?(type.specialty)
        achievementhash[type.achievementtype][type.college][type.achievementname][type.specialty] = Hash.new
      end
    end 
    return achievementhash
  end
=begin
  searchable do
  	text :achievementname, :achievementtype, :college, :specialty
  end

 # bundle exec rake sunspot:solr:start or sunspot:solr:run to start in foreground

  def self.reIndexSolr
    Userachievementtype.reindex
    Sunspot.commit
  end  


  def self.searchBy(q,search_type) 
 
    if (search_type == "Achievement Type")    
      Userachievementtype.search do
        paginate :page => 1, :per_page => 10 
        fulltext q do
          fields(:email)
        end
      end  

    elsif (search_type == "College")    
      Userachievementtype.search do
        paginate :page => 1, :per_page => 10 
        fulltext q do
          fields(:college)
        end
      end

    elsif (search_type == "Specialty")    
      Userachievementtype.search do
        paginate :page => 1, :per_page => 10 
        fulltext q do
          fields(:specialty)
        end
      end

    else   
      Userachievementtype.search do
        paginate :page => 1, :per_page => 10 
        fulltext q do
          fields(:achievementname)
        end
      end
    end
  end

=end

  def self.railSearchBy(q,search_type) 
 
    if (search_type == "Achievement Type") 
      results = Userachievementtype.where(['achievementtype LIKE ?', "%#{q}%"])      

    elsif (search_type == "College")    
      results = Userachievementtype.where(['college LIKE ?', "%#{q}%"])

    elsif (search_type == "Specialty")    
      results = Userachievementtype.where(['specialty LIKE ?', "%#{q}%"])

    else   
      results = Userachievementtype.where(['achievementname LIKE ?', "%#{q}%"])
    end
  end


  def self.findUsers(userachievements)
  	user_ids = userachievements.map(&:user_id)
  	users = User.find(user_ids)
  	return users

  end



end
