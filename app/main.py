from flask import Flask, jsonify

app = Flask(__name__)

@app.route('/')
def home():
    # Added this comment to verify CI/CD pipeline trigger
    return jsonify(message="Hello from the Cloud Native Platform!", status="success")

@app.route('/health')
def health():
    return jsonify(status="healthy")

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)