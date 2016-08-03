git add .
git commit -a -m" $* "
git checkout deploy
git merge development
git push github development
git push deploy development
git push deploy deploy
git checkout development
cap production deploy
