require "render_anywhere"
 
class ReportPdf
  include RenderAnywhere
 
  def initialize(student)
    @student = student
  end
 
  def to_pdf
    kit = PDFKit.new(as_html, page_size: 'A4')
    kit.to_file("#{Rails.root}/public/report.pdf")
  end
 
  def filename
    "Report #{@student.id}.pdf"
  end
 
  private
    attr_reader :invoice
    
    def as_html
      render template: "student_reports/pdf", layout: "pdf_layout", locals: { student: @student }
    end
end
