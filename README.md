## How to

1. Clone The Repository
2. chmod +x config.sh
3. ./config.sh and add the requested information
4. chmod +x deploy_media_server.sh
5. ./deploy_media_server.sh
6. Configure qbittorrent, radarr, sonarr and plex
7. check my youtube video

## RADARR+SONARR CONFIG
Settings -> Media Management: /data/TVSHOWS/Shows
Settings -> Download Clients:

Host -> IP Address of qbittorrent
Remote Path -> /data/{ MOVIES | SHOWS }/Download/
Local Path  -> /data/{ MOVIES | SHOWS }/Download/
* MOVIES for radarr | SHOWS for sonarr



There is also a script that will monitor deleted file either from plex or from torrent and will remove the hardlinks or original files if hardlinks are removed.
Consider running it in crontab at a time when you you dont download any movies as they might be deleted.
I usually run it @5:00 AM once a week.


## 💖 Support Me
If you like my work and want to support me, you can donate via PayPal:
<a href="https://www.paypal.com/paypalme/mztnw" target="_blank">
    <img src="https://www.paypalobjects.com/webstatic/en_US/i/buttons/PP_logo_h_100x26.png" width="120" alt="Donate via PayPal">
</a>
