require 'nokogiri'
require 'open-uri'
require 'date'


class Admin

  def get_day_array(day_string)
    day_array = Array.new()

    day_array.append 'M' if day_string.include? "M"
    day_array.append 'T' if ((day_string.include? "T" and !day_string.include? "Th") or (day_string.include? "T" and day_string.count("T") == 2))
    day_array.append 'W' if day_string.include? "W"
    day_array.append 'Th' if day_string.include? "Th"
    day_array.append 'F' if day_string.include? "F"

    return day_array
  end

  def make_items(info_array)
    if info_array.length != 10
      return
    end

    full_course_code = info_array[0]

    course_name = info_array[1].gsub('Computer Requirements','')

    method = info_array[2]

    room = info_array[3]

    campus = "TBAY"


    unless info_array[4].nil?
      unless info_array[4].empty?
        day_array = get_day_array(info_array[4])
        mon = day_array[0]
        tue = day_array[1]
        wed = day_array[2]
        thu = day_array[3]
        fri = day_array[4]
      end
    end

    unless info_array[5].nil? or info_array[5].empty? or info_array[5]== '-'
      time_array = info_array[5].split('-')
      start_time = Time.strptime(time_array[0], "%H:%M%P").strftime("%H:%M")
      end_time = Time.strptime(time_array[1], "%H:%M%P").strftime("%H:%M")
    end

    date_array = info_array[6].split('-')
    start_date = date_array[0]
    end_date = date_array[1]

    credits = info_array[7]

    synonym = info_array[8].sub(%r{.*: },'')

    instructor = info_array[9].sub(%r{.*: },'')

    department = full_course_code[0..3].to_s

    course_code = full_course_code[5..9].gsub(/\-/,'')

    section_code = full_course_code[10..13].gsub(/\-/,'')

    # ----------------- BEGIN ADDING NEW COURSE ------------------
    new_course = Course.find_or_create_by(department: department, course_code: course_code )
    new_course.department = department
    new_course.course_code = course_code
    new_course.name = course_name
    new_course.credits = credits.to_f


    description_url = 'http://timetable.lakeheadu.ca/scripts/return.course.description.php?c=' + department + '&cn=' + course_code
    description, prerequisite = get_description_and_prereq description_url


    new_course.description = description
    new_course.prerequisite = prerequisite

    if course_name.include? 'Clinical for'
      method = 'PRA'
    elsif course_name.include? 'Laboratory for'
      method = 'LAB'
    end

    new_course.method = method

    new_course.save
    # ----------------- END ADDING NEW COURSE ------------------

    # ----------------- BEGIN ADDING SECTIONS ------------------
    new_section = Section.find_or_create_by(department: department, course_code: course_code, section_code: section_code )


    new_section.department = department
    new_section.course_code = course_code
    new_section.section_code = section_code
    new_section.name = course_name


    new_section.start_date = start_date ? Time.parse('20'+start_date) : nil
    new_section.end_date = end_date ? Time.parse('20'+end_date) : nil
    new_section.instructor = instructor



    # do some parsing to see where a TUT or PRA are linked to - find the number
    if ((not course_name[/\d+/].nil?) and (method == 'TUT' or (method == 'PRA' and department == 'NURS')))
      new_section.link = department+'-'+course_name[/\d+/]
    elsif method == 'LAB'
      new_section.link = department+'-'+course_code
    else
      new_section.link = nil
    end


    new_section.synonym = synonym.to_i
    new_section.method = method
    new_section.course_id = new_course.id

    new_section.save
    # ----------------- END ADDING SECTIONS ------------------

    # ----------------- BEGIN ADDING CLASSES ------------------
    unless day_array.nil?
      day_array.each do |day|
        if day

          new_klass = Klass.new

          new_klass.department = department
          new_klass.course_code = course_code
          new_klass.section_code = section_code
          new_klass.day = day
          new_klass.start_time = start_time
          new_klass.end_time = end_time
          new_klass.room = room
          new_klass.section_id = new_section.id
          new_klass.save
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

    description = divs[1] ? divs[1].content : ''
    prerequisite = divs[3] ? divs[3].content.gsub(/.*: /,'') : ''

    return description, prerequisite
  end

  def add_dept(dept_code, dept_name)
    Department.find_or_create_by(:dept_code => dept_code, :dept_name => dept_name)
  end

  def run_db_import
    doc = Nokogiri::HTML(open('http://timetable.lakeheadu.ca/2014FW_UG_TBAY/courtime.html'))


    link_array = Array.new()
    #Add the rows to the departments table and push to the links array
    puts 'Getting the links...'
    #doc.css('div#copy ul li a').each do |x|
    ['POLI','PSYC','RELI','SOCI','SOWK','SPAN','VISU','WATE','WOME'].each do |x|
      #add_dept(x["href"][0..3].upcase, x.text)
      link_array.push("http://timetable.lakeheadu.ca/2014FW_UG_TBAY/" + x.downcase + ".html")
    end

    puts 'Constructing course array...'

    start_count = 0
    i = 0
    current_link = -1.0
    info_array = []
    info_array2 = []

    link_array.each do |link|
      doc = Nokogiri::HTML(open(link))
      current_link += 1
      doc.css('tr td').each do |x|

        unless x.attr('style').nil?
          if x.attr('style') == 'nowrap'
            if start_count == 0
              start_count = 1
              i = 0

              unless info_array[10].nil?
                unless info_array[10].empty?
                  info_array2 = info_array[0..9]
                  info_array2[2] = info_array[10]
                  info_array2[3] = info_array[11]
                  info_array2[4] = info_array[12]
                  info_array2[5] = info_array[13]
                  info_array2[6] = info_array[14]
                end
              end

              make_items info_array2 unless info_array2.empty?

              make_items info_array[0..9] unless info_array[0].nil?

              info_array = []
              info_array2 = []
            else
              start_count=0
            end
          end
        end
        info_array[i] = x.content.strip
        i+=1
      end
    end
  end
  handle_asynchronously :run_db_import, :run_at => Proc.new { 5.seconds.from_now }
end