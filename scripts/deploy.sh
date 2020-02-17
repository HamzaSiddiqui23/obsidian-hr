appname="obsidian-hr-solution"
echo "Start to deploy to $appname"
git push origin master
heroku run bundle install -a $appname
echo "Installing bundle $appname"
heroku run RAILS_ENV=production rake db:migrate -a $appname
echo "Doing Migrations $appname"
if [ $1 == '-f' ]; then
  heroku run rake db:seed -a $appname
  echo "Seeding DB $appname"
fi
heroku restart -a $appname
echo "Restarting and ready to go $appname"