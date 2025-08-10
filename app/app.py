# app/app.py

from flask import Flask
import os

app = Flask(__name__)

@app.route('/')
def hello():
    # We can use an environment variable to customize the message later
    message = os.environ.get('MESSAGE', 'Hello, World!')
    return f"<h1>{message}</h1>"

if __name__ == '__main__':
    # The app will listen on port 80, which is the standard HTTP port
    app.run(host='0.0.0.0', port=80)
