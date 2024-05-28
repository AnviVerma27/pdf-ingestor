class QuestionsController < ApplicationController
  def index
    @questions = Question.all
  end

  def new
  end

  def create
    uploaded_file = params[:pdf_file]
    if uploaded_file
      file_path = Rails.root.join('tmp', uploaded_file.original_filename)
      File.open(file_path, 'wb') do |file|
        file.write(uploaded_file.read)
      end

      ingestor = PdfIngestor.new(file_path.to_s)
      questions = ingestor.extract_questions

      storer = QuestionStorer.new(questions)
      storer.store

      flash[:notice] = "Successfully ingested #{questions.size} questions."
    else
      flash[:alert] = "Please upload a valid PDF file."
    end

    redirect_to questions_path
  end
end
