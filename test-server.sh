#!/usr/bin/env bash

PORT=5000
SERVER="http://localhost:$PORT"
PASS="PASS"
FAIL="FAIL"

echo "=============================================="
echo " Welcome to the Echo Web Server Tester 5000"
echo "This server will run on http://localhost:5000/"
echo "=============================================="

if ! command -v curl &> /dev/null; then
  echo "Cannot find the curl command, confirm it is installed and in your PATH."
  exit 1
fi

if ! command -v jq &> /dev/null; then
  echo "Cannot find the jq command, confirm it is installed and in your PATH."
  exit 1
fi

if ! command -v lsof &> /dev/null; then
  echo "Cannot find the lsof command, confirm it is installed and in your PATH."
  exit 1
fi

echo
echo "Checking port availability..."
if sudo lsof -Pi :5000 -sTCP:LISTEN -t >/dev/null ; then
    if sudo docker image ls | grep "web_server" &> /dev/null; then
      echo "Docker image is already running on port 5000."
    else
      echo "5000 port is already allocated."
      echo "Please leave port 5000 free to run docker image."
      exit 1
    fi
else
    echo "Build docker images..."
    sudo docker-compose build
    sudo docker-compose up -d
    sleep 1
fi

echo
echo "Beginning test..."
echo "Running Test 1: GET..."

test1=$(curl "$SERVER/?foo=bar&blang=Hello+World" 2>/dev/null)
foo1=$(echo "$test1" | jq -r '.foo')
blang1=$(echo "$test1" | jq -r '.blang')
if [[ "$foo1" != "bar" ]] || [[ "$blang1" != "Hello World" ]]; then
  teststatus1=$FAIL
else
  teststatus1=$PASS
fi

echo "Running Test 2: POST (form data)..."

test2=$(curl -XPOST "$SERVER/" --data 'fuzz=blip' --data 'frob=quxx' 2>/dev/null)
fuzz2=$(echo "$test2" | jq -r '.fuzz')
frob2=$(echo "$test2" | jq -r '.frob')
if [[ "$fuzz2" != "blip" ]] || [[ "$frob2" != "quxx" ]]; then
  teststatus2=$FAIL
else
  teststatus2=$PASS
fi

echo "Running Test 3: POST (JSON data)..."

test3=$(curl -XPOST "$SERVER/" -H 'Content-Type: application/json' --data '{"foo": "bar", "buzz": "fuzz"}' 2>/dev/null)
foo3=$(echo "$test3" | jq -r .foo)
buzz3=$(echo "$test3" | jq -r .buzz)
if [[ "$foo3" != "bar" ]] || [[ "$buzz3" != "fuzz" ]]; then
  teststatus3=$FAIL
else
  teststatus3=$PASS
fi

echo
echo "=================================="
echo "          Testing Summary"
echo "=================================="
echo "Test 1: GET...................$teststatus1"
echo "Test 2: PASS (form data)......$teststatus2"
echo "Test 3: PASS (JSON data)......$teststatus3"
echo "=================================="

exit 1
