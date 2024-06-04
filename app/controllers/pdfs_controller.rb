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
      file_path = Rails.root.join('tmp', uploaded_file.original_filename)
      File.open(file_path, 'wb') do |file|
        file.write(uploaded_file.read)
      end

      pdf = current_user.pdfs.create(file_name: uploaded_file.original_filename)

      if pdf.persisted?
        ingestor = PdfIngestor.new(file_path.to_s)
        questions = ingestor.extract_questions

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
      questions = []
      reader.pages.each do |page|
        page.text do |line|
          script_path = Rails.root.join('services', 'main.py')
          result = `python3 #{script_path} '#{line}'`
          questions<<result

                # if is_question?(line)
                # questions << line.strip
                # end
        end
      end
      puts questions
      return questions
  end

end
