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
  handle_asynchronously :start_update, :run_at => Proc.new { 5.seconds.from_now }
end