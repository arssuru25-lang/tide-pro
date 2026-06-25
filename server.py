from flask import Flask, request, jsonify
from flask_cors import CORS
import anthropic

app = Flask(__name__)
CORS(app)

client = anthropic.Anthropic(
    api_key="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"
)

# ---------------- AI CHAT ---------------- #

@app.route('/chat', methods=['POST'])
def chat():

    message = request.json['message']

    try:
        response = client.messages.create(
            model="claude-sonnet-4-20250514",
            max_tokens=300,
            messages=[
                {
                    "role": "user",
                    "content": message
                }
            ]
        )

        return jsonify({
            "reply": response.content[0].text
        })

    except Exception as e:

        return jsonify({
            "reply": str(e)
        })


# ---------------- AI PLANNER ---------------- #

@app.route('/plan', methods=['POST'])
def plan():

    tasks = request.json['tasks']

    prompt = f"""
You are a productivity coach.

Tasks:
{tasks}

Order these tasks by urgency.
Explain briefly.
"""

    try:

        message = client.messages.create(
            model="claude-sonnet-4-20250514",
            max_tokens=500,
            messages=[
                {
                    "role": "user",
                    "content": prompt
                }
            ]
        )

        return jsonify({
            "plan": message.content[0].text
        })

    except Exception as e:

        return jsonify({
            "plan": str(e)
        })


# ---------------- AI CATEGORIZATION ---------------- #

@app.route('/categorize', methods=['POST'])
def categorize():

    title = request.json['title']

    prompt = f"""
Categorize the following task into exactly one category.

Categories:
- Work
- Personal
- Study
- Fitness
- Shopping

Task:
{title}

Return ONLY the category name.
"""

    try:

        message = client.messages.create(
            model="claude-sonnet-4-20250514",
            max_tokens=20,
            messages=[
                {
                    "role": "user",
                    "content": prompt
                }
            ]
        )

        return jsonify({
            "category":
                message.content[0].text.strip()
        })

    except Exception:

        return jsonify({
            "category": "Personal"
        })


# ---------------- AI SEMANTIC SEARCH ---------------- #

@app.route('/search', methods=['POST'])
def search():

    query = request.json['query']
    tasks = request.json['tasks']

    prompt = f"""
User Query:
{query}

Available Tasks:
{tasks}

Find the most relevant tasks.
Rank them.
Explain briefly.
"""

    try:

        message = client.messages.create(
            model="claude-sonnet-4-20250514",
            max_tokens=300,
            messages=[
                {
                    "role": "user",
                    "content": prompt
                }
            ]
        )

        return jsonify({
            "result":
                message.content[0].text
        })

    except Exception as e:

        return jsonify({
            "result": str(e)
        })


# ---------------- RUN SERVER ---------------- #

if __name__ == '__main__':

    app.run(
        host='0.0.0.0',
        port=5000,
        debug=True
    )