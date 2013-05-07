#/bin/bash
ghc --make Main.hs
mv ./Main ./parrotBot

find . -name "*.o" -exec rm -f '{}' +
find . -name "*.hi" -exec rm -f '{}' +

rm ./DEBIAN/usr/bin/parrotBot
rm ./DEBIAN/usr/bin/appender

cp ./parrotBot ./DEBIAN/usr/bin/
cp ./appender ./DEBIAN/usr/bin/

rm ./DEBIAN/usr/share/doc/parrotBot/README
cp ./README.md ./DEBIAN/usr/share/doc/parrotBot/README

rm -rf ./StatAnal
cp -R ../StatAnal ./StatAnal
rm *.deb
fakeroot dpkg -b ./DEBIAN
dpkg-name *.deb

git add *
git add -u
