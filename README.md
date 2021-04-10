# Echo Web Server

This is a containerized echo web server that will respond to HTTP requests.
This web server will be hosted on http://localhost:5000.

1. GET: Responds with query arguments returned in JSON format.
2. POST (standard): Responds with form data of request in JSON format.
3. POST (Content-type:application/json): Return JSON body.

## Requirements
Built using:
* docker
* python3

## Running web server
To run the web server in a detached docker container:

1. Navigate to the directory this package is in.
2. Install requirements using pip

````bash
pip3 install -r requirements.txt
````

3. Build docker images.

````bash
sudo docker-compose build
````

4. Run container.

````bash
sudo docker-compose up
````

## Build and test script
### Test script steps
The test script does the following steps:

1. Checks that port 5000 is available to docker. If not available, exit the program.
2. Checks if web_server container is already running on port 5000.
3. If web_server container is not running, build the image and run a container.
4. Run GET and POST tests from sample-test.sh
5. Print test status.

### Running test script
1. Navigate to directory this package is in.
2. Set appropriate permissions.

````bash
sudo chmod a+x ./test.sh
````

3. Run ./test.sh
