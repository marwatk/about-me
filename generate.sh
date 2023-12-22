#!/bin/bash

set -e

if [[ -z "${GITHUB_PAT}" ]]; then
  echo "GITHUB_PAT is missing, go here: https://github.com/settings/tokens?type=beta"
  exit 1
fi

cat <<EOF > Resume.html
<!DOCTYPE html>
<html>
  <head>
    <title>Marcus Watkins - Software Engineer</title>
    <style type='text/css'>
      $(curl -s --fail -L https://raw.githubusercontent.com/marwatk/markdown-to-html-github-style/master/style.css)
      body {
        font-size: 12px;
      }
      h1, h2, h3, h4 {
        line-height: 1;
      }
      p {
        line-height: 1.1;
      }
      table {
        margin-bottom: 0;
      }
      thead {
        display: none;
      }
      td {
        border-left-width: 0;
        border-right-width: 0;
        padding: 1em;
        padding-top: .1em;
        padding-bottom: .1em;
      }
      li {
        line-height: 1;
      }
      li + li {
        margin-top: 0;
      }
    </style>
  </head>
  <body>
    $(curl -s --fail -L \
      -X POST \
      -H "Accept: application/vnd.github+json" \
      -H "Authorization: Bearer ${GITHUB_PAT}" \
      -H "Content-Type: text/x-markdown" \
      -H "X-GitHub-Api-Version: 2022-11-28" \
      https://api.github.com/markdown/raw \
      -d "$(cat Resume.md)")
  </body>
</html>
EOF

sudo docker run -v "$(pwd):/workspace" pink33n/html-to-pdf:79.1 --url file:///workspace/Resume.html --pdf Resume.pdf