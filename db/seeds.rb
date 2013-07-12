# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'csv'

=begin
Dir::foreach('db/course_catalog_rice'){|field| 
  if field.length > 2 and field != ".DS_Store"
    Dir::foreach("db/course_catalog_rice/#{field}"){|subfield| 
      if subfield.length > 2 and subfield != ".DS_Store"
        count = 0
        CSV.foreach("db/course_catalog_rice/#{field}/#{subfield}") do |cell|
          if count == 0
            count1 = 0
            dI = 0
            dII = 0
            dIII = 0
            for cell.each do |string|
              if string == "DI"
                dI = count1
              elsif string == "DII"
                dII = count1
              elsif string == "DIII"
                dIII = count1
              end
              count1 += 1
            end
            count += 1
            departmentname = cell[0]
          elsif cell[0] != nil
            if cell[dI] == "1"
              di = "true"
            else 
              di = "false"
            end
            if cell[dII] == "1"
              dii = "true"
            else 
              dii = "false"
            end
            if cell[dIII] == "1"
              diii = "true"
            else 
              diii = "false"
            end

            params = {:u => {:institution_id => 1, :coleges_attributes => [{
              :colegename => field, :departments_attributes => [{
                :departmentabbr => subfield[0..3], :departmentname => departmentname, :nums_attributes => [{
                  :number => cell[0][5..7], :name => cell[1], :di => di, :dii => dii, :diii => diii, :credit =>  cell[2]
                  }]
                }]
              }]}}
            Catalog.create!(params[:u])
          end
        end
      end
    }
  end
}
=end

@achieve = ["BA", "BS", "BA-S", "Minors", "Pre-med"]
Institution.create!(:name => "Rice University", :id => 1, :nickname => "Rice")
institution = Institution.find(1)

Dir::foreach('db/institutions/rice'){|achievementtype|
  if @achieve.include?(achievementtype)
    a = institution.achievementtypes.create!(:achievementtype => achievementtype)
    Dir::foreach("db/institutions/rice/#{achievementtype}"){|college|
      if college.length > 2 and college != ".DS_Store"
        b = a.colleges.create!(:college => college)
        Dir::foreach("db/institutions/rice/#{achievementtype}/#{college}"){|achievementname|
          if achievementname.length > 2 and achievementname != ".DS_Store"
            c = b.achievementnames.create!(:achievementname => achievementname)
            Dir::foreach("db/institutions/rice/#{achievementtype}/#{college}/#{achievementname}"){|specialty|
              if specialty.length > 2 and specialty != ".DS_Store"
                d = c.specialties.create!(:specialty => specialty)
                Dir::foreach("db/institutions/rice/#{achievementtype}/#{college}/#{achievementname}/#{specialty}"){|reqtype|
                  if reqtype.length > 2 and reqtype != ".DS_Store" and reqtype == "Core"
                    Dir::foreach("db/institutions/rice/#{achievementtype}/#{college}/#{achievementname}/#{specialty}/Core"){|corereq|
                      if corereq.length > 2 and corereq != ".DS_Store"
                        count = 0
                        CSV.foreach("db/institutions/rice/#{achievementtype}/#{college}/#{achievementname}/#{specialty}/Core/#{corereq}") do |cell|
                          if count == 0
                            @z = d.corereqs.create!(:corereqname => corereq[0..(corereq.length-4)], :cgoal => cell[0])
                            count += 1
                          else
                            @z.ccourses.create!(:department => cell[0], :num => cell[1])
                          end
                        end
                      end
                    }
                  end
                  if reqtype.length > 2 and reqtype != ".DS_Store" and reqtype == "Multi"
                    Dir::foreach("db/institutions/rice/#{achievementtype}/#{college}/#{achievementname}/#{specialty}/Multi"){|opreq|
                      if opreq.length > 2 and opreq != ".DS_Store"
                        f = d.opreqs.create!(:opreqname => opreq)
                        Dir::foreach("db/institutions/rice/#{achievementtype}/#{college}/#{achievementname}/#{specialty}/Multi/#{opreq}"){|option|
                          if option.length > 2 and option != ".DS_Store"
                            count = 0
                            CSV.foreach("db/institutions/rice/#{achievementtype}/#{college}/#{achievementname}/#{specialty}/Multi/#{opreq}/#{option}") do |cell|
                              if count == 0
                                @g = f.options.create!(:optionname => option[0..(option.length-4)], :cgoal => cell[0])
                                count += 1
                              else
                                @g.ocourses.create!(:department => cell[0], :num => cell[1])
                                
                              end
                            end
                          end
                        }
                      end
                    }
                  end
                }
              end
            }
          end
        }
      end
    }
  end
}
#print institution


