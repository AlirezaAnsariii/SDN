from flask import Flask, request, jsonify

app = Flask(__name__)
status_store = {"status": "OK"}

@app.route("/api/v1/status", methods=["GET", "POST"])
def status():
    global status_store
    if request.method == "POST":
        data = request.get_json()
        status_store["status"] = data.get("status", "not OK")
        return jsonify(status_store), 201
    return jsonify(status_store), 200

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000)
