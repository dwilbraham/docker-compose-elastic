#!/bin/bash

firefox localhost:`docker-compose port kibana 5601 | cut -d: -f2`/app/sense
