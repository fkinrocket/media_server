1. clone the files into the /opt/ directory
2. add the plex claim code from plex.tv/claim
3. run the ./deploy_media_server.sh
4. add deploy_media_server.sh in crontab to update regularly and automatically

There is also a script that will monitor deleted file either from plex or from torrent and will remove the hardlinks or original files if hardlinks are removed.
Consider running it in crontab at a time when you you dont download any movies as they might be deleted.
I usually run it @5:00 AM once a week.


## Support My Work ❤️  
If you find this project useful, consider supporting me:  
https://www.paypal.com/paypalme/mztnw


