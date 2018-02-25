require 'rails_helper'
require 'render_anywhere'

describe ReportPdf do
  describe '#to_pdf' do
    let(:student) { double(:student) }
    let(:report_pdf) { ReportPdf.new(student) }
    let(:kit) { double(:kit, to_file: true) }
    let(:as_html) { double(:as_html) }

    before do
      allow(PDFKit).to receive(:new) { kit }
      allow(report_pdf).to receive(:as_html) { as_html }
    end

    it 'should create a new pdf and give a file back' do
      expect(PDFKit).to receive(:new).with(as_html, page_size: 'A4')
      expect(kit).to receive(:to_file)
      report_pdf.to_pdf
    end
  end
end