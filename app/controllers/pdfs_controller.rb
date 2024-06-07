class PdfsController < ApplicationController
  before_action :authenticate_user!

  def index
    @pdfs = current_user.pdfs
  end

  def new
    @pdf = Pdf.new
  end

  def create
    uploaded_file = params[:pdf][:file]
    if uploaded_file
      @file_path = Rails.root.join('tmp', uploaded_file.original_filename)
      File.open(@file_path, 'wb') do |file|
        file.write(uploaded_file.read)
      end
  
      pdf = current_user.pdfs.create(file_name: uploaded_file.original_filename)
  
      if pdf.persisted?
        questions = ingestor
        storer = QuestionStorer.new(questions, pdf)
        storer.store
  
        flash[:notice] = "Successfully ingested #{questions.size} questions."
        redirect_to pdf_path(pdf)
      else
        flash[:alert] = "Failed to create PDF record."
        render :new
      end
    else
      flash[:alert] = "Please upload a valid PDF file."
      render :new
    end
  end

  def show
    @pdf = current_user.pdfs.find(params[:id])
    @questions = @pdf.questions
  end

  def destroy
    @pdf = current_user.pdfs.find(params[:id])
    @pdf.destroy
    redirect_to pdfs_path, notice: "PDF deleted successfully."
  end

  private

  def ingestor
    reader = PDF::Reader.new(@file_path)
    text_content = []
  
    reader.pages.each do |page|
      text_content << page.text
    end
  
    # Combine all text content from the PDF
    combined_text = text_content.join("\n")
  
    # Call the Python script to extract questions
    result = `python3 app/services/main.py "#{combined_text}"`
    Rails.logger.debug "Python script result: #{result}"
  
    # Split the result into individual questions
    questions = result.split("\n").map(&:strip).reject(&:empty?)
  
    questions
  end
end
