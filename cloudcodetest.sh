curl -X POST \
  -H "X-Parse-Application-Id: amBfyHfkqcjWSIH1tteESSpiHI3ZEkz3Xuk0eGNF" \
  -H "X-Parse-REST-API-Key: UWwg3Jp7lldJEK3MSTKbYehWW0VBbtDhM8c2TSW6" \
  -H "X-Parse-Session-Token: eCf2e8rVqb4mj8kiKZljB0VTh" \
  -H "Content-Type: application/json" \
  -d '{
        "where": {
          "channels": ["ltHamlRIq2"],
          "deviceType": "ios"
        },
        "data": {
          "alert": "Alert message here."
        }
      }' \
  https://api.parse.com/1/push
