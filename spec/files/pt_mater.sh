#!/bin/sh
# set -x

curl -H "X-TrackerToken: 188f901073b501960bcbf3f5ef756c43" -X GET https://www.pivotaltracker.com/services/v3/projects/574033/stories?filter=owned_by%3A%22Aaron%20Harris%22%20current_state%3Astarted -o "info.xml"

ruby pt_mater.rb

rm info.xml

# project_id=sed -n 's|<id type="integer">\(.*\)</id>|\1|p' info.xml
