git add .
git commit -a -m" $* "
git checkout preview
git merge development
git push github development
git push deploy preview
cap testing deploy
git checkout development
