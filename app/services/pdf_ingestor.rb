require 'pdf-reader'
# require 'pycall'
require 'open3'

class PdfIngestor
    def initialize(file_path)
        @file_path = file_path
    end

    def extract_questions
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
        questions
    end

    private

    # def resp()
    #     result = `python main.py params`
    #     return result
    # end
end
