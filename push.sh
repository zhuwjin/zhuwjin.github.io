#! /bin/bash

hugo -d docs
git add *
git commit -m "updates $(date)"
git push -u origin main
