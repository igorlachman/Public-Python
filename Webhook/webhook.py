#!/usr/bin/env python

import os

from flask import Flask, request, json

app = Flask(__name__)

@app.route('/')
def api_root():
    return 'API WebHook_GIT'


@app.route('/github', methods=['POST'])
def api_github_mess():
    if request.headers['Content-Type'] == 'application/json':
        content = request.json
        branch_name = content.get('ref')
        if 'dev_lachman' in branch_name:
            os.system('./test_pj.sh')
        return json.dumps(request.json)


if __name__ == '__main__':
  app.run(host="0.0.0.0", port=5000)
