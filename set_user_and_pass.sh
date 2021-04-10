echo "Once you have register enter login details for a new bash script that will auto login"
echo "Press CTRL + C to cancel if you haven't already signed up in the app"
read -p "Enter username: " name
read -p "Enter password: " password
file="run_app_logged_in.sh"
touch $file

printf "ruby main.rb $name $password" > $file