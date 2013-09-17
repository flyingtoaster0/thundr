class HomeController < ApplicationController



  def index

    letters = ('A'..'F').to_a
    _data = Department.where('substr("deptCode", 1, 1) IN (?)', letters)

    @deptArray1 = _data.collect {|dept| {:deptCode => dept.deptCode, :deptName => dept.deptName }}


    letters = ('G'..'M').to_a
    _data = Department.where('substr("deptCode", 1, 1) IN (?)', letters)
    @deptArray2 = _data.collect {|dept| {:deptCode => dept.deptCode, :deptName => dept.deptName }}

    letters = ('N'..'Z').to_a
    _data = Department.where('substr("deptCode", 1, 1) IN (?)', letters)
    @deptArray3 = _data.collect {|dept| {:deptCode => dept.deptCode, :deptName => dept.deptName }}
  end
end