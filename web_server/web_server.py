# Python Echo Web Server
# Returns HTTP request headers/form data
# as JSON
# Feb. 2021

# import relevant packages
from http.server import HTTPServer, BaseHTTPRequestHandler
from urllib.parse import urlparse, parse_qsl
import json

# Set global vars
PORT = 5000

# Request handler class
class HandleRequests(BaseHTTPRequestHandler):
    def _set_headers(self):
        self.send_response(200)
        self.send_header('Content-type', 'application/json')
        self.end_headers()

    # GET handler
    # 1. Send the HTTP header response
    # 2. Parse the path for a clean version of the query,
    #    which in turn gets converted into a dict
    # 3. Convert dict to JSON, make it pretty
    # 4. Return JSON
    def do_GET(self):
        self._set_headers()
        path = self.convert_to_json_str(urlparse(self.path).query)
        self.wfile.write(path.encode())

    # POST handler
    # 1. Read the data
    # 2. Get the type of the data
    # 3. If JSON, return the JSON body
    # 4. If not, return the form data as JSON
    def do_POST(self):
        self._set_headers()
        content_length = int(self.headers['Content-Length'])
        post_data = (self.rfile.read(content_length)).decode('utf_8')

        if self.headers['Content-type'] == 'application/json':
            post_data_json = json.dumps(json.loads(post_data), sort_keys=True, indent=2)
            self.wfile.write(post_data_json.encode())
        else:
            post_data_json = self.convert_to_json_str(post_data)
            self.wfile.write(post_data_json.encode())

    # Convert content to JSON
    def convert_to_json_str(self, content):
        content_dict = dict(parse_qsl(content))
        content_json_str = json.dumps(content_dict, sort_keys=True, indent=2)

        return content_json_str

# Server run method
def run(server_class=HTTPServer, handler_class=HandleRequests):
    # Set up server on https://localhost:5000
    server_address = ("0.0.0.0", PORT)
    httpd = server_class(server_address, handler_class)

    # Run server
    print("Server running at http://localhost:5000...")
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        print("\n")
        pass

# Main method
if __name__ == "__main__":
    run()
