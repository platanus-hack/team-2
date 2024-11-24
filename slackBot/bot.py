from slack_bolt import App
from slack_bolt.adapter.socket_mode import SocketModeHandler

# Initialize your app with your bot token and signing secret
app = App(token="xoxb-")

@app.event("app_mention")
def handle_app_mentions(body, say):
    print("paiojpoijicjijapijpijp")
    # Respond with "hello" when the bot is mentioned
    say("hello")

# Run the app
if __name__ == "__main__":
    handler = SocketModeHandler(app, "xapp-")
    handler.start()
