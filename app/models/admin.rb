require 'nokogiri'
require 'open-uri'
require 'date'


class Admin

  def getDayArray(dayString)
    dayArr = Array.new()

    dayArr.append 'M' if dayString.include? "M"
    dayArr.append 'T' if ((dayString.include? "T" and !dayString.include? "Th") or (dayString.include? "T" and dayString.count("T") == 2))
    dayArr.append 'W' if dayString.include? "W"
    dayArr.append 'Th' if dayString.include? "Th"
    dayArr.append 'F' if dayString.include? "F"

    return dayArr
  end

  def make_items(infoArr)
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

    _course_code = _courseCode[5..9].gsub(/\-/,'')

    _section_code = _courseCode[10..13].gsub(/\-/,'')

    # ----------------- BEGIN ADDING NEW COURSE ------------------
    _newCourse = Course.find_or_create_by(department: _department, course_code: _course_code )
    _newCourse.department = _courseCode[0..3].to_s
    _newCourse.course_code = _courseCode[5..9].gsub(/\-/,'')
    _newCourse.name = _courseName
    _newCourse.credits = _credits.to_f


    _description_url = 'http://timetable.lakeheadu.ca/scripts/return.course.description.php?c=' + _department + '&cn=' + _courseCode[5..9].gsub(/\-/,'')
    _description, _prerequisite = get_description_and_prereq _description_url


    _newCourse.description =_description
    _newCourse.prerequisite = _prerequisite

    if _courseName.include? 'Clinical for'
      _method = 'PRA'
    elsif _courseName.include? 'Laboratory for'
      _method = 'LAB'
    end

    _newCourse.method = _method

    _newCourse.save
    # ----------------- END ADDING NEW COURSE ------------------

    # ----------------- BEGIN ADDING SECTIONS ------------------
    _newSection = Section.find_or_create_by(department: _department, course_code: _course_code, section_code: _section_code )


    _newSection.department = _courseCode[0..3].to_s
    _newSection.course_code = _courseCode[5..9].gsub(/\-/,'')
    _newSection.section_code = _courseCode[10..13].gsub(/\-/,'')


    _newSection.start_date = _startDate ? Time.parse('20'+_startDate) : nil
    _newSection.end_date = _endDate ? Time.parse('20'+_endDate) : nil
    _newSection.instructor = _instructor



    # do some parsing to see where a TUT or PRA are linked to - find the number
    if ((not _courseName[/\d+/].nil?) and (_method == 'TUT' or (_method == 'PRA' and _department == 'NURS')))
      _newSection.link = _department+'-'+_courseName[/\d+/]
    elsif _method == 'LAB'
      _newSection.link = _department+'-'+_courseCode[5..8].gsub(/\-/,'')
    else
      _newSection.link = nil
    end


    _newSection.synonym = _synonym.to_i
    _newSection.method = _method
    _newSection.course_id = _newCourse.id

    _newSection.save
    # ----------------- END ADDING SECTIONS ------------------

    # ----------------- BEGIN ADDING CLASSES ------------------
    unless _dayArr.nil?
      _dayArr.each do |day|
        if day

          _newKlass = Klass.new

          _newKlass.day = day
          _newKlass.start_time = _startTime
          _newKlass.end_time = _endTime
          _newKlass.room = _room
          _newKlass.section_id = _newSection.id
          _newKlass.save
        end
      end
    end
    # ----------------- END ADDING CLASSES ------------------


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

  def add_dept(dept_code, dept_name)
    Department.find_or_create_by(:dept_code => dept_code, :dept_name => dept_name)
  end

  def run_db_import
    doc = Nokogiri::HTML(open('http://timetable.lakeheadu.ca/2013FW_UG_TBAY/courtime.html'))


    linkArr = Array.new()
    #Add the rows to the departments table and push to the links array
    puts 'Getting the links...'
    doc.css('div#copy ul li a').each do |x|
      add_dept(x["href"][0..3].upcase, x.text)
      linkArr.push("http://timetable.lakeheadu.ca/2013FW_UG_TBAY/" + x["href"])
    end

    puts 'Constructing course array...'

    startCount = 0
    i = 0
    currentLink = -1.0
    total = linkArr.length
    infoArray = []
    infoArray2 = []

    linkArr.each do |link|
      doc = Nokogiri::HTML(open(link))
      currentLink += 1
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

              make_items infoArray2 unless infoArray2.empty?

              make_items infoArray[0..9] unless infoArray[0].nil?

              infoArray = []
              infoArray2 = []
            else
              startCount=0
            end
          end
        end
        infoArray[i] = x.content.strip
        i+=1
      end
    end
  end
  handle_asynchronously :run_db_import, :run_at => Proc.new { 5.seconds.from_now }
end