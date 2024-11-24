import requests
import re

from requests.auth import HTTPBasicAuth


BASE_URL = "http://rag.comovamo.app:5000/"

def get_rag_response(text, username="test", password="test"):
    """
    Makes a GET request to the /rag endpoint with the given text as a parameter,
    using Basic Authentication.

    Args:
        text (str): The input text to send to the /rag endpoint.
        username (str): The username for Basic Authentication (default: "test").
        password (str): The password for Basic Authentication (default: "test").

    Returns:
        dict: The JSON response from the endpoint if successful.
        str: Error message if the request fails.
    """
    endpoint = f"{BASE_URL}rag"  # Complete endpoint URL
    params = {"input": text}  # Query parameters for GET request

    try:
        # Perform the GET request with Basic Authentication
        response = requests.get(endpoint, params=params, auth=HTTPBasicAuth(username, password))
        response.raise_for_status()  # Raise an error for bad status codes

        # Return the JSON response
        return response.json()
    except requests.exceptions.RequestException as e:
        # Handle request exceptions
        return f"An error occurred: {e}"

def fix_double_asterisks(text: str):
    return re.sub(r'\*\*', '*', text)


def get_answer_from_rag(text):
    response = get_rag_response(text)
    answer = fix_double_asterisks(response['answer'])
    

    return answer


