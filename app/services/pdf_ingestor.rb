require 'pdf-reader'

class PdfIngestor
    def initialize(file_path)
        @file_path = file_path
    end

    def extract_questions
        reader = PDF::Reader.new(@file_path)
        questions = []
        
        reader.pages.each do |page|
            page.text.each_line do |line|
                if is_question?(line)
                questions << line.strip
                end
            end
        end
        
        questions
    end

    private

    def is_question?(line)
        line.strip.end_with?('?')
    end
end
