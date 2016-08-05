git add .
git commit -a -m" $* "
git checkout preview
git merge development
git push github development
git push deploy development
git push deploy preview
git checkout development
#cap testing deploy
