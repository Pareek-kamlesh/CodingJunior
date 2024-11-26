from flask import Flask, request, jsonify
import sys
import io
import traceback

app = Flask(__name__)

@app.route('/execute', methods=['POST'])
def execute_code():
    try:
        code = request.json.get("code", "")
        if not code.strip():
            return jsonify({"error": "No code provided", "output": ""}), 400

        # Redirect stdout to capture print statements
        old_stdout = sys.stdout
        sys.stdout = io.StringIO()

        # Define a restricted set of built-ins
        allowed_builtins = {
            "print": print, 
            "len": len, 
            "range": range,
            "int": int, 
            "float": float, 
            "str": str,
            "bool": bool,
        }

        # Execute the code in a restricted environment
        exec(code, {"__builtins__": allowed_builtins}, {})

        # Capture the output
        output = sys.stdout.getvalue()

        # Reset stdout
        sys.stdout = old_stdout

        return jsonify({"output": output, "error": ""})
    except Exception as e:
        # Capture runtime errors
        error_message = traceback.format_exc()
        return jsonify({"output": "", "error": error_message}), 400


if __name__ == "__main__":
    app.run(debug=True)
