from flask import Flask, request, jsonify
import requests
from flask_cors import CORS

app = Flask(__name__)
CORS(app)  # Enable CORS for all routes

# Replace this with your actual Replicate API Token
REPLICATE_API_TOKEN = '_________________________________________'

REPLICATE_API_URL = 'https://api.replicate.com/v1/predictions'

@app.route('/api/caption-image', methods=['POST'])
def caption_image():
    # Extract the image URL from the request body
    data = request.json
    image_url = data.get('image_url')
    
    if not image_url:
        return jsonify({'error': 'Image URL is required'}), 400
    
    # Create the payload for the Replicate API
    payload = {
        "version": "2e1dddc8621f72155f24cf2e0adbde548458d3cab9f00c0139eea840d0ac4746",
        "input": {
            "task": "image_captioning",
            "image": image_url
        }
    }
    
    # Set the headers including the authorization token
    headers = {
        'Content-Type': 'application/json',
        'Authorization': f'Bearer {REPLICATE_API_TOKEN}',
        'Prefer': 'wait'
    }

    try:
        # Forward the request to Replicate API
        response = requests.post(REPLICATE_API_URL, json=payload, headers=headers)
        response.raise_for_status()

        # Return the response from Replicate to the client
        return jsonify(response.json())

    except requests.exceptions.RequestException as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True)
