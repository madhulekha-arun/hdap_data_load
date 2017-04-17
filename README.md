# hdap_data_load
Scripts to load sensor data into hdfs

Dropbox location :
https://www.dropbox.com/home/HDAP%20Sensors%20Box

Used this plugin on chrome to get cookie data (https://chrome.google.com/webstore/detail/cookietxt-export/lopabhfecdfhgogdbojmaicoicjekelh)

Save it as cookies.txt

Upload the cookies.txt on your server using scp.
scp cookies.txt  <username>@hadoop-hdap.phdi.gatech.edu:

Login to server
ssh <username>@hadoop-hdap.phdi.gatech.edu

Clone the repo
git clone https://github.com/madhulekha-arun/hdap_data_load.git


Run the script to download files from dropbox
sh hdap_data_load/download.sh









