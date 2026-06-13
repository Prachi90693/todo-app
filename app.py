# Import tools from the Flask library
# Flask    -> creates the web app
# render_template -> loads your HTML file
# request  -> reads form data (what user typed)
# redirect -> sends user to a different URL
from flask import Flask, render_template, request, redirect, jsonify

# Create the Flask app object
# __name__ tells Flask where to look for templates
app = Flask(__name__)

# A simple Python list as our "database"
# Resets when server restarts - fine for learning
todos = []

# Route for the homepage "/"
# When someone visits localhost:5000 this runs
@app.route("/")
def index():
    return render_template("index.html", todos=todos)

# Route for adding a task
# Only runs on form submit (POST), not page visit (GET)
@app.route("/add", methods=["POST"])
def add():
    task = request.form.get("task")  # read what user typed
    if task:
        todos.append(task)
    return redirect("/")  # go back to homepage

# Route for deleting a task
# /delete/0 deletes task 0, /delete/1 deletes task 1
@app.route("/delete/<int:index>")
def delete(index):
    if 0 <= index < len(todos):
        todos.pop(index)
    return redirect("/")

# Health check endpoint for Kubernetes liveness/readiness probes
@app.route("/health")
def health():
    return jsonify(status="healthy"), 200

# Start the app when you run: python app.py
# host="0.0.0.0" is required for Docker to work
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
