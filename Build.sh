#/bin/bash
ghc --make Main.hs
ghc --make parrotOne.hs

mv ./Main ./parrotBot

g++ ./appender.cpp
mv ./a.out ./appender

find . -name "*.o" -exec rm -f '{}' +
find . -name "*.hi" -exec rm -f '{}' +

rm ./DEBIAN/usr/bin/parrotBot
rm ./DEBIAN/usr/bin/appender
rm ./DEBIAN/usr/bin/parrotOne

cp ./parrotBot ./DEBIAN/usr/bin/
cp ./appender ./DEBIAN/usr/bin/
cp ./parrotOne ./DEBIAN/usr/bin

rm ./DEBIAN/usr/share/doc/parrotBot/README
cp ./README.md ./DEBIAN/usr/share/doc/parrotBot/README

rm -rf ./StatAnal
cp -R ../StatAnal ./StatAnal
rm -R *.deb
fakeroot dpkg -b ./DEBIAN
dpkg-name *.deb

mkdir debs
mkdir executables

mv ./random ./executables
mv ./appender ./executables
mv ./parrotOne ./executables
mv ./parrotBot ./executables

mv *.deb ./debs

git add *
git add -u
