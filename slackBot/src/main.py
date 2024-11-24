# src/slacktools/test_slacktools.py
import re
from slack_bolt import App
from slack_bolt.adapter.socket_mode import SocketModeHandler
from slack_sdk.errors import SlackApiError
from rag import get_answer_from_rag

# Initialize the app with your bot token and signing secret
app = App(
    token="xoxb-",
    signing_secret=""
)


# Greeting messages
@app.message(re.compile(r"\b(hello|hi|hey|greetings|hola)\b", re.IGNORECASE))
def message_hello(message, say):
    try:
        user = message["user"]  # Extract user who sent the message
        say(f"Hello <@{user}>! What can I help you with?")  # Respond to the user
    except SlackApiError as e:
        print(f"Error posting message: {e.response['error']}")

# Handle any other messages
@app.event("message")
def handle_message_events(body, say):
    try:
        user = body["event"]["user"]  # The user who sent the message
        text = body["event"]["text"]  # The text of the message
    except SlackApiError as e:
        print(f"Error posting message: {e.response['error']}")
    except KeyError as e:
        # Handle cases where the event structure is not as expected
        print(f"KeyError: Missing expected key {e}")

    try:
        answer = get_answer_from_rag(text)
        say(f"{answer}")
    except:
        say(f"I'm sorry, I didn't understand what you said")
        
# Start your app
if __name__ == "__main__":
    handler = SocketModeHandler(app, "xapp-")
    handler.start()

