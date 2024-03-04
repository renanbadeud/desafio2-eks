#!/bin/bash

# URL to send requests to
url="http://localhost:8080"

# Send 60 requests to the URL
for i in {1..60}
do
   curl $url
done
