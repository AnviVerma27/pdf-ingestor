class QuestionStorer
    def initialize(questions, pdf)
        @questions = questions
        @pdf = pdf
    end

    def store
        @questions.each do |question|
            question_record = @pdf.questions.create(content: question)
        # Debugging log
            if question_record.persisted?
                Rails.logger.debug("Stored question: #{question_record.content}")
            else
                Rails.logger.debug("Failed to store question: #{question_record.errors.full_messages}")
            end
        end
    end
end
