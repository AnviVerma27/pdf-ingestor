import openai
import requests
import sys
import os
from typing import List

openai.api_key = os.getenv("OPENAI_API_KEY")

text = sys.argv[1]

def get_questions(text: str):
    response = openai.ChatCompletion.create(
        model="gpt-3.5-turbo",
        messages=[
            {"role": "system", "content": "Extract questions from the following text."},
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

print(get_questions(text))

