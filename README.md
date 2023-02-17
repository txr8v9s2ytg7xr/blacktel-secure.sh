# blacktel-secure.sh
A simple bash script that sets up SSH authentcation, privoxy proxy server, pihole server, and a tor proxy server, all at once. This script is meant to be ran on a VPS or oversea hosting
Check here to downlaod the website's version: https://txr8v9s2ytg7xr.us/
<-Pre Reqs to installing blacktel-secure.sh->
*Fresh system install with no configurations made to tor, pihole (if present), ssh, and privoxy
*On a VPS (See a list of reccomended VPS providers to use)
*Running Ubuntu 22.04 (This was the OS that was tested with th e script that is known to for sure work. Feel free to try another distro)
<-VPS providers best with the script->
*Cherry Servers (https://www.cherryservers.com/)
Note that their are other providers that you can use. However, Cherry server's allow for quick sign up and accept crypto currency for monthly payments

<-Other-Notes->
*Have your public key for SSH ready to paste (if you plan on using cert auth SSH)
*Pay anonymously when setting up this VPS that you choose to run the script on
*Be safe ;)

To quickly download the script and the SHA value to check the file's integrity, run this command in linux:

wget https://txr8v9s2ytg7xr.us/software/blacktel-secure.sh/blacktel-secure.sh && https://txr8v9s2ytg7xr.us/software/blacktel-secure.sh/sha-value.txt
