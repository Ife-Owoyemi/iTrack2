# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'csv'
Institution.delete_all
@achieve = ["BA", "BS", "BA-S", "Minors", "Pre-med"]
Institution.create(:name => "Rice University", :id => 1, :nickname => "Rice")
@instst = Institution.all
@instst.each do |insts|
  @inst = insts.id
end
institution = Institution.find(@inst)

Dir::foreach('db/institutions/rice'){|achievementtype|
  if @achieve.include?(achievementtype)
    a = institution.achievementtypes.create!(:achievementtype => achievementtype)
    Dir::foreach("db/institutions/rice/#{achievementtype}"){|college|
      if college.length > 2 and college != ".DS_Store"
        @college = college.gsub(/_/, ' ')
        b = a.colleges.create!(:college => @college)
        Dir::foreach("db/institutions/rice/#{achievementtype}/#{college}"){|achievementname|
          if achievementname.length > 2 and achievementname != ".DS_Store"
            @achievementname = achievementname.gsub(/_/, ' ')
            c = b.achievementnames.create!(:achievementname => @achievementname)
            Dir::foreach("db/institutions/rice/#{achievementtype}/#{college}/#{achievementname}"){|specialty|
              if specialty.length > 2 and specialty != ".DS_Store"
                @specialty = specialty.gsub(/_/, ' ')
                d = c.specialties.create!(:specialty => @specialty)
                Dir::foreach("db/institutions/rice/#{achievementtype}/#{college}/#{achievementname}/#{specialty}"){|reqtype|
                  if reqtype.length > 2 and reqtype != ".DS_Store" and reqtype == "Core"
                    Dir::foreach("db/institutions/rice/#{achievementtype}/#{college}/#{achievementname}/#{specialty}/Core"){|corereq|
                      if corereq.length > 2 and corereq != ".DS_Store"
                        count = 0
                        CSV.foreach("db/institutions/rice/#{achievementtype}/#{college}/#{achievementname}/#{specialty}/Core/#{corereq}") do |cell|
                          if count == 0
                            @corereq = corereq[1..(corereq.length - 1 )].gsub(/_/, ' ')
                            @z = d.corereqs.create!(:corereqname => @corereq[0..(@corereq.length - 5)], :cgoal => cell[0])
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
                        @opreq = opreq[1..(opreq.length - 1)].gsub(/_/, ' ')
                        f = d.opreqs.create!(:opreqname => @opreq)
                        Dir::foreach("db/institutions/rice/#{achievementtype}/#{college}/#{achievementname}/#{specialty}/Multi/#{opreq}"){|option|
                          if option.length > 2 and option != ".DS_Store"
                            count = 0
                            CSV.foreach("db/institutions/rice/#{achievementtype}/#{college}/#{achievementname}/#{specialty}/Multi/#{opreq}/#{option}") do |cell|
                              if count == 0

                                @option = option[1..(option.length - 1)].gsub(/_/, ' ')
                                @g = f.options.create!(:optionname => @option[0..(@option.length-7)], :cgoal => cell[0])

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
                  if reqtype.length > 2 and reqtype != ".DS_Store" and reqtype == "Depnum"
                    Dir::foreach("db/institutions/rice/#{achievementtype}/#{college}/#{achievementname}/#{specialty}/Depnum"){|depnumreq|
                      if depnumreq.length > 2 and depnumreq != ".DS_Store"
                        @depnumreq = depnumreq.gsub(/_/, ' ')
                        count = 0
                        cds = 0

                        @depnumreq.each_char {|c|
                          if c == "-"
                            if count == 0
                              print @p1 = cds
                            elsif count == 1
                              print @p2 = cds
                            elsif count == 2
                              print @p3 = cds
                            end
                            count += 1
                          end
                          cds += 1
                        }
                        fa = d.depnumreqs.create!(:depnumreqname => @depnumreq[0..@p1], :cgoal => @depnumreq[(@p1 + 1)..@p2], :hgoal => @depnumreq[(@p2 + 1)..@p3], :doublecount => @depnumreq[(@p3 + 1)..(@depnumreq.length - 1)])
                        Dir::foreach("db/institutions/rice/#{achievementtype}/#{college}/#{achievementname}/#{specialty}/Depnum/#{depnumreq}"){|depabbr|
                          if depabbr.length > 2 and depabbr != ".DS_Store"
                            @depabbr = depabbr.gsub(/_/, ' ')
                            fb = fa.deps.create!(:department => @depabbr)
                            Dir::foreach("db/institutions/rice/#{achievementtype}/#{college}/#{achievementname}/#{specialty}/Depnum/#{depnumreq}/#{depabbr}"){|reqtype|
                              if reqtype.length > 2 and reqtype != ".DS_Store"
                                if reqtype == "Bound.csv"
                                  count = 0
                                  CSV.foreach("db/institutions/rice/#{achievementtype}/#{college}/#{achievementname}/#{specialty}/Depnum/#{depnumreq}/#{depabbr}/#{reqtype}") do |cell|
                                    fb.bounds.create!(:min => cell[0], :max => cell[1])
                                  end
                                end
                                if reqtype == "Exceptions.csv"
                                  count = 0
                                  CSV.foreach("db/institutions/rice/#{achievementtype}/#{college}/#{achievementname}/#{specialty}/Depnum/#{depnumreq}/#{depabbr}/#{reqtype}") do |cell|
                                    fb.cexceptions.create!(:department => cell[0], :num => cell[1])
                                  end
                                end
                                if reqtype == "Lists.csv"
                                  count = 0
                                  CSV.foreach("db/institutions/rice/#{achievementtype}/#{college}/#{achievementname}/#{specialty}/Depnum/#{depnumreq}/#{depabbr}/#{reqtype}") do |cell|
                                    fb.clists.create!(:department => cell[0], :num => cell[1])
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
  end
}


count1 = 0
dI = 0
dII = 0
dIII = 0
Catalog.delete_all
@riceCatalog = Catalog.create!(:institution_id => @inst)
Dir::foreach('db/course_catalog_rice'){|field|
  if field.length > 2 and field != ".DS_Store"
    field1 = field.gsub(/_/, ' ')
    @college = @riceCatalog.coleges.create!( :colegename => field1 )
    Dir::foreach("db/course_catalog_rice/#{field}"){|subfield|
      if subfield.length > 2 and subfield != ".DS_Store"
        count = 0
        CSV.foreach("db/course_catalog_rice/#{field}/#{subfield}") do |cell|
          if count == 0
            count1 = 0
            dI = 0
            dII = 0
            dIII = 0
            cell.each do |string|
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
            subfield1 = subfield[0..3].gsub(/_/, ' ')
            @department = @college.departments.create!( :departmentabbr => subfield1, :departmentname => departmentname)

          elsif cell[0] != nil
            print dI
            print cell
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
            @department.nums.create!(:number => cell[0][5..7], :name => cell[1], :di => di, :dii => dii, :diii => diii, :credit =>  cell[2])
          end

        end

      end

    }

  end
}


=begin

count1 = 7
Dir::foreach('db/institutions/users'){|username|
  count1 += 1
  if username.length > 2 and username != ".DS_Store"
    @user = User.all(:conditions => {:name => username})
    if @user != []
      User.delete(@user.id)
    end
    @username = username.gsub(/_/, ' ')
    a = User.create!(:name => @username, :email => "itrackuser#{count1}@gmail.com", :password => "Melissas1", :password_confirmation => "Melissas1")
    
    Dir::foreach("db/institutions/users/#{username}"){|year|
      if year.length > 2 and year != ".DS_Store"
        b = a.years.create!(:year => year)
        Dir::foreach("db/institutions/users/#{username}/#{year}"){|semester|
          if semester.length > 2 and semester != ".DS_Store"
            c = b.semesters.create!(:semester => semester)
            Dir::foreach("db/institutions/users/#{username}/#{year}/#{semester}"){|document|
              if document.length > 2 and document != ".DS_Store"
                count = 0
                CSV.foreach("db/institutions/users/#{username}/#{year}/#{semester}/Courses.csv") do |cell|
                  c.usercourses.create!(:department => cell[0], :num => cell[1], :credits => cell[2], :institution => cell[3], :status => cell[4])
                end
              end
            }
          end
        }
      end
    }
  end
}
=end
#print institution


