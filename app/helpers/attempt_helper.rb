module AttemptHelper
  def objective_answer_for_pair(question, attempt)
    question.answer_for_attempt(attempt).try(:submitted_option)
  end

  def subjective_answer_for_pair(question, attempt)
    question.answer_for_attempt(attempt).try(:text)
  end
end