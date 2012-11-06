#/bin/sh
rm -rf build/*
r.js -o build.js
cp -r javascripts stylesheets circle.html  build/
mkdir build/html
mv build/circle.html build/html/circle.html
zip -r build build
