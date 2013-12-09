class HomeController < ApplicationController



  def index

    letters = ('A'..'F').to_a
    _data = Department.where('substr("dept_code", 1, 1) IN (?)', letters)

    @deptArray1 = _data.collect {|dept| {:dept_code => dept.dept_code, :dept_name => dept.dept_name }}


    letters = ('G'..'M').to_a
    _data = Department.where('substr("dept_code", 1, 1) IN (?)', letters)
    @deptArray2 = _data.collect {|dept| {:dept_code => dept.dept_code, :dept_name => dept.dept_name }}

    letters = ('N'..'Z').to_a
    _data = Department.where('substr("dept_code", 1, 1) IN (?)', letters)
    @deptArray3 = _data.collect {|dept| {:dept_code => dept.dept_code, :dept_name => dept.dept_name }}
  end
end