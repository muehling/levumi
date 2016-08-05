git add .
git commit -a -m" $* "
git checkout deploy
git merge preview
git push deploy deploy
git checkout development
cap production deploy
