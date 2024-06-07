import sys
import openai
import os
from dotenv import load_dotenv

load_dotenv()

openai.api_key = os.getenv('OPENAI_API_KEY')

def get_questions(text: str):
    response = openai.ChatCompletion.create(
        model="gpt-3.5-turbo",
        messages=[
            {"role": "system", "content": "Extract all the questions and things that are asked without answers from the following text."},
            {"role": "user", "content": text}
        ],
        max_tokens=1000,
        n=1,
        stop=None,
        temperature=0.5,
    )
    result = response.choices[0].message['content']
    questions = result.split('\n')
    return [q for q in questions if q.strip()]

if __name__ == "__main__":
    text = sys.argv[1]
    questions = get_questions(text)
    for question in questions:
        print(question)
