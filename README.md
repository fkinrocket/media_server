## How to

1. Clone The Repository
2. chmod +x config.sh
3. ./config.sh and add the requested information
4. chmod +x deploy_media_server.sh
5. ./deploy_media_server.sh
6. Configure qbittorrent, radarr, sonarr and plex
7. check my youtube video

RADARR+SONARR CONFIG
![Screenshot 2025-02-24 at 21 49 48](https://github.com/user-attachments/assets/90abb194-0295-487a-8477-9731daf9d632)
![Screenshot 2025-02-24 at 21 50 29](https://github.com/user-attachments/assets/96351f76-fc8a-424b-bedc-19c1e093e4ad)



There is also a script that will monitor deleted file either from plex or from torrent and will remove the hardlinks or original files if hardlinks are removed.
Consider running it in crontab at a time when you you dont download any movies as they might be deleted.
I usually run it @5:00 AM once a week.


## 💖 Support Me
If you like my work and want to support me, you can donate via PayPal:
<a href="https://www.paypal.com/paypalme/mztnw" target="_blank">
    <img src="https://www.paypalobjects.com/webstatic/en_US/i/buttons/PP_logo_h_100x26.png" width="120" alt="Donate via PayPal">
</a>
