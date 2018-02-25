class StudentReportsController < ApplicationController
  def show
    @student = User.find(params[:user_id])
    respond_to do |format|
      format.html
      format.pdf { send_report_pdf }
    end
  end

  private

  def report_pdf
    ReportPdf.new(@student)
  end

  def send_report_pdf
    send_file report_pdf.to_pdf,
      filname: report_pdf.filename,
      type: 'application/pdf',
      page_width: '100%',
      disposition: 'inline'
  end
end