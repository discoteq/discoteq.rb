#!/usr/bin/env bats

@test "service map should match expected" {
  cat > /tmp/expected.json <<EOF
{"services":{"myface":[{"hostname":"myface.example.net","port":8080}],"myface-cache":[{"host":"myface-cache-001.example.net"}]}}
EOF

  diff /etc/myface.json /tmp/expected.json
}
