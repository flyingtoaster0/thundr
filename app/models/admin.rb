require 'nokogiri'
require 'open-uri'
require 'date'


class Admin
  def start_update
    #update code goes here
    #update progress table
    #@prog = @prog +1
    @prog = Progress.first


    _i = 0
    _num = 100

    while _i < _num  do
      _i +=1
      @prog.percent = _i
      @prog.save
      sleep 0.1

    end



  end
  #handle_asynchronously :start_update, :run_at => Proc.new { 5.seconds.from_now }


  def getDayArray(dayString)
    dayArr = Array.new()

    dayArr[0] = false
    dayArr[1] = false
    dayArr[2] = false
    dayArr[3] = false
    dayArr[4] = false

    dayArr[0] = true if dayString.include? "M"
    dayArr[1] = true if ((dayString.include? "T" and !dayString.include? "Th") or (dayString.include? "T" and dayString.count("T") == 2))
    dayArr[2] = true if dayString.include? "W"
    dayArr[3] = true if dayString.include? "Th"
    dayArr[4] = true if dayString.include? "F"

    return dayArr
  end


  def makeCourse(infoArr)
    # just make sure that the array actually makes sense
    if infoArr.length != 10
      return
    end

    _courseCode = infoArr[0]

    _courseName = infoArr[1]

    _method = infoArr[2]

    _room = infoArr[3]

    _campus = "TBAY"


    unless infoArr[4].nil?
      unless infoArr[4].empty?
        _dayArr = getDayArray(infoArr[4])
        _mon = _dayArr[0]
        _tue = _dayArr[1]
        _wed = _dayArr[2]
        _thu = _dayArr[3]
        _fri = _dayArr[4]
      end
    end

    unless infoArr[5].nil? or infoArr[5].empty? or infoArr[5]== '-'
      _timeArr = infoArr[5].split('-')
      _startTime = Time.strptime(_timeArr[0], "%H:%M%P").strftime("%H:%M")
      _endTime = Time.strptime(_timeArr[1], "%H:%M%P").strftime("%H:%M")
    end

    _dateArr = infoArr[6].split('-')
    _startDate = _dateArr[0]
    _endDate = _dateArr[1]

    _credits = infoArr[7]

    _synonym = infoArr[8].sub(%r{.*: },'')

    _instructor = infoArr[9].sub(%r{.*: },'')

    _department = _courseCode[0..3].to_s

    _newCourse = Course.new
    _newCourse.code = _courseCode[5..9].gsub(/\-/,'')
    _newCourse.department = _courseCode[0..3].to_s
    _newCourse.section = _courseCode[10..13].gsub(/\-/,'')

    _newCourse.name = _courseName
    _newCourse.room = _room
    _newCourse.campus = _campus
    _newCourse.mon = _mon
    _newCourse.tue = _tue
    _newCourse.wed = _wed
    _newCourse.thu = _thu
    _newCourse.fri = _fri
    _newCourse.startTime = _startTime # ? Time.parse(_startTime) : nil
    _newCourse.endTime = _endTime # ? Time.parse(_endTime) : nil
    _newCourse.startDate = _startDate ? Time.parse('20'+_startDate) : nil
    _newCourse.endDate = _endDate ? Time.parse('20'+_endDate) : nil
    _newCourse.credits = _credits.to_f
    _newCourse.synonym = _synonym.to_i
    _newCourse.instructor = _instructor


    if _courseName.include? 'Clinical for'
      _method = 'PRA'
      #puts(_courseName)
    elsif _courseName.include? 'Laboratory for'
      _method = 'LAB'
      #puts(_courseName)
    end

    _newCourse.method = _method


    # do some parsing to see where a TUT or PRA are linked to - find the number
    if ((not _courseName[/\d+/].nil?) and (_method == 'TUT' or (_method == 'PRA' and _department == 'NURS')))
      _newCourse.link = _department+'-'+_courseName[/\d+/]
    elsif _method == 'LAB'
      _newCourse.link = _department+'-'+_courseCode[5..8].gsub(/\-/,'')
    else
      _newCourse.link = nil
    end

    _description_url = 'http://timetable.lakeheadu.ca/scripts/return.course.description.php?c=' + _department + '&cn=' + _courseCode[5..9].gsub(/\-/,'')
    _description, _prerequisite = get_description_and_prereq _description_url
    _newCourse.description =_description
    _newCourse.prerequisite = _prerequisite

    #puts('New course added: ' + _courseCode)

    return _newCourse
  end



  def department_from_course_code(whole_course_code)
    return whole_course_code[0..3].to_s
  end

  def code_from_course_code(whole_course_code)
    return whole_course_code[5..9].gsub(/\-/,'')
  end

  def section_from_course_code(whole_course_code)
    return whole_course_code[10..13].gsub(/\-/,'')
  end
  
  
  
  def get_description_and_prereq url
    doc = Nokogiri::HTML(open(url))
    divs = doc.css('div')

    _description = divs[1] ? divs[1].content : ''
    _prerequisite = divs[3] ? divs[3].content.gsub(/.*: /,'') : ''

    return _description, _prerequisite
  end


  def update_course(existing_course, info_array)
    if info_array.length != 10
      return
    end

    _courseCode = info_array[0]

    _courseName = info_array[1].gsub(/Computer Requirements/,'')

    _method = info_array[2]

    _room = info_array[3]

    _campus = "TBAY"


    unless info_array[4].nil?
      unless info_array[4].empty?
        _dayArr = getDayArray(info_array[4])
        _mon = _dayArr[0]
        _tue = _dayArr[1]
        _wed = _dayArr[2]
        _thu = _dayArr[3]
        _fri = _dayArr[4]
      end
    end

    unless info_array[5].nil? or info_array[5].empty? or info_array[5]== '-'
      _timeArr = info_array[5].split('-')
      _startTime = Time.strptime(_timeArr[0], "%H:%M%P").strftime("%H:%M")
      _endTime = Time.strptime(_timeArr[1], "%H:%M%P").strftime("%H:%M")
    end

    _dateArr = info_array[6].split('-')
    _startDate = _dateArr[0]
    _endDate = _dateArr[1]

    _credits = info_array[7]

    _synonym = info_array[8].sub(%r{.*: },'')

    _instructor = info_array[9].sub(%r{.*: },'')

    _department = _courseCode[0..3].to_s

    existing_course.code = _courseCode[5..9].gsub(/\-/,'')
    existing_course.department = _courseCode[0..3].to_s
    existing_course.section = _courseCode[10..13].gsub(/\-/,'')

    existing_course.name = _courseName
    existing_course.room = _room
    existing_course.campus = _campus
    existing_course.mon = _mon
    existing_course.tue = _tue
    existing_course.wed = _wed
    existing_course.thu = _thu
    existing_course.fri = _fri
    existing_course.startTime = _startTime ? Time.parse(_startTime) : nil
    existing_course.endTime = _endTime ? Time.parse(_endTime) : nil
    existing_course.startDate = _startDate ? Time.parse('20'+_startDate) : nil
    existing_course.endDate = _endDate ? Time.parse('20'+_endDate) : nil
    existing_course.credits = _credits.to_f
    existing_course.synonym = _synonym.to_i
    existing_course.instructor = _instructor


    if _courseName.include? 'Clinical for'
      _method = 'PRA'
      #puts(_courseName)
    elsif _courseName.include? 'Laboratory for'
      _method = 'LAB'
      #puts(_courseName)
    end

    existing_course.method = _method


    if ((not _courseName[/\d+/].nil?) and (_method == 'TUT' or (_method == 'PRA' and _department == 'NURS')))
      existing_course.link = _department+'-'+_courseName[/\d+/]
    elsif _method == 'LAB'
      existing_course.link = _department+'-'+_courseCode[5..8].gsub(/\-/,'')
    else
      existing_course.link = nil
    end

    existing_course.save
    
  end
  


  def add_dept(deptCode, deptName)
    unless Department.find_by_deptCode(deptCode)
      _newDept = Department.new(:deptCode => deptCode, :deptName => deptName)
      _newDept.save
    end
  end


  # this function runs the bulk of the code
  def run_db_import
    doc = Nokogiri::HTML(open('http://timetable.lakeheadu.ca/2013FW_UG_TBAY/courtime.html'))


    linkArr = Array.new()


    #doc.css('div#copy ul li a').map {|link| [ link["href"]]}.each do |x|
    #  linkArr.push("http://timetable.lakeheadu.ca/2013FW_UG_TBAY/" + x[0])
    #
    #end

    #Add the rows to the departments table and push to the links array
    puts 'Getting the links...'
    doc.css('div#copy ul li a').each do |x|
      add_dept(x["href"][0..3].upcase, x.text)
      linkArr.push("http://timetable.lakeheadu.ca/2013FW_UG_TBAY/" + x["href"])
    end

    # Leaving this here for testing purposes
    #linkArr.push("http://timetable.lakeheadu.ca/2013FW_UG_TBAY/nurs.html")

    _courseArray = Array.new
    @prog = Progress.first
    @prog.percent = 0
    @prog.description = 'Constructing course array'
    puts 'Constructing course array...'
    @prog.save

    startCount = 0
    i = 0
    currentLink = -1.0
    total = linkArr.length
    percent = 0.0
    infoArray = []
    infoArray2 = []
    infoArray3 = []

    linkArr.each do |link|
      doc = Nokogiri::HTML(open(link))
      currentLink += 1
      percent = (currentLink/total) * 50
      @prog.percent = percent
      @prog.description = 'Parsing: ' << link
      @prog.save
      doc.css('tr td').each do |x|

        unless x.attr('style').nil?
          if x.attr('style') == 'nowrap'
            if startCount == 0
              startCount = 1
              i = 0

              unless infoArray[10].nil?
                unless infoArray[10].empty?
                  infoArray2 = infoArray[0..9]
                  infoArray2[2] = infoArray[10]
                  infoArray2[3] = infoArray[11]
                  infoArray2[4] = infoArray[12]
                  infoArray2[5] = infoArray[13]
                  infoArray2[6] = infoArray[14]
                end
              end


              #make a special case for nrmt?? this is picking up stray text, so it isn't working properly
              #check out nmrt to see whats up...
              #unless infoArray[18].nil?
              #  unless infoArray[18].empty?

              #    infoArray3 = infoArray[0..9]
              #    infoArray3[2] = infoArray[18]
              #    infoArray3[3] = infoArray[19]
              #    infoArray3[4] = infoArray[20]
              #    infoArray3[5] = infoArray[21]
              #    infoArray3[6] = infoArray[22]
              #  end
              ## make 3rd course entry
              #end


              unless infoArray2.empty?
                #puts "_________________"

                existing_course = Course.find_by_department_and_code_and_section(department_from_course_code(infoArray2[0]),
                                                                                 code_from_course_code(infoArray2[0]),
                                                                                 section_from_course_code(infoArray2[0]))

                if existing_course
                  update_course(existing_course, infoArray2)
                else
                  _courseArray.append(makeCourse(infoArray2))
                end


              end

              #unless infoArray3.empty?
              #  puts "_________________3"
              #  puts infoArray3
              #end




              unless infoArray[0].nil?
                #puts "__________________"
                #puts infoArray[0]
                
                existing_course = Course.find_by_department_and_code_and_section(department_from_course_code(infoArray[0]),
                                                                                  code_from_course_code(infoArray[0]),
                                                                                  section_from_course_code(infoArray[0]))
                
                if existing_course
                  update_course(existing_course, infoArray[0..9])
                else
                  _courseArray.append(makeCourse(infoArray[0..9]))
                end
                
                
              end

              infoArray = []
              infoArray2 = []
              #infoArray3 = []
            else
              startCount=0
            end
          end
        end
        infoArray[i] = x.content.strip
        i+=1
      end
    end
    #actually add them here

    @prog.description = 'Saving courses to the database'

    _courseArraySize =_courseArray.length
    _currentCourseNum = 0.0
    _coursePercent = 0.0

    puts 'Saving courses to the database...'
    #Courses and departments get added to their respective tables here
    _courseArray.each do |c|
      _currentCourseNum += 1
      _coursePercent = ((_currentCourseNum / _courseArraySize) * 50) + 50


      @prog.description = 'Saving courses to the database... '
      @prog.percent = _coursePercent
      @prog.save
      c.save
    end

    @prog.percent = 100
    @prog.description = 'Done'
    @prog.save
  end
  handle_asynchronously :run_db_import, :run_at => Proc.new { 5.seconds.from_now }
end