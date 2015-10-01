git add .
git commit -a -m" $* "
git checkout master
git merge development
git push github
git push deploy
git checkout development
