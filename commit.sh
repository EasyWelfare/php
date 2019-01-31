#!/bin/bash

git show-ref --tags -d

echo "insert the new tag for new commit please"

read tag

git add .
git tag $tag
git push origin master --tags
