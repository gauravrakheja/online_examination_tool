module ExamHelper
  def exam_start_date(exam)
    if date = exam.start_date
      if date > Date.today
        "Starts On: " + exam.start_date.strftime("%d %b %Y") 
      else
        "Started On: " + exam.start_date.strftime("%d %b %Y")
      end
    end
  end
end