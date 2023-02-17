#!/bin/bash
#This script was made by txr8v9s2ytg7xr.us
# Website: https://txr8v9s2ytg7xr.us/
# txr8v9s2ytg7xr.us is NOT responsible for any misuse of this script
#Welcome
echo "Welcome to Blacktel-Secure.sh!"
sleep 0.5
echo "We are downloading and installing all of the tools now. Please be patient..."
sleep 0.5
#End Welcome
#Start installing services
sudo apt install tor privoxy locate ufw ssh
#Aquire SSH pub key from user
echo "Enter your public SSH key (Leave blank if you don't want public key authentication set up): " 
read ssh_key #set var ssh pub key

if [ ! -d ~/.ssh ]; then
  mkdir ~/.ssh
  echo "$ssh_key" >> ~/.ssh/authorized_keys
  echo "Created .ssh directory and added public key to authorized_keys file."
else
  echo "$ssh_key" >> ~/.ssh/authorized_keys
  echo "Added public key to authorized_keys file."
fi
#SSH port input
clear
echo "what port would you like to use for SSH? (WARNING, THE SCRIPT WILL RESTART SSH AFTER YOU CHOOSE YOUR DESIRED PORT. TO MAINTAIN A STABLE CONNECTION, SELECT 22): "
read ssh_port
sleep 0.3
echo "Ok! Designating port $ssh_port as the new SSH port"
#Allow UFW port
sudo ufw allow $ssh_port
 echo "Changing your SSH port to $ssh_port..."
sleep 0.3
echo "Settng UFW to $ssh_port"
sudo ufw allow $ssh_port
sleep 0.3
#Password authentication on/off
echo "Would you like password authentication for this server? yes/no (please enter your answer in all lowercase to avoid problems with SSH default is yes if you wish to have no public key authentication):"
read passauth
#Permit empty passwords
echo "would you like to permit empty password authentication for this server? (please enter your answer in all lowercase to avoid problems with SSH. Default is no)"
read emptypassauth
#Deleting and recreating sshd file in /etc/ssh/sshd_config
echo "changing your sshd cpnfig in /etc/sshd/sshd_config..."
echo "" > /etc/ssh/sshd_config
echo "#       $OpenBSD: sshd_config,v 1.103 2018/04/09 20:41:22 tj Exp $

# This is the sshd server system-wide configuration file.  See
# sshd_config(5) for more information.

# This sshd was compiled with PATH=/usr/bin:/bin:/usr/sbin:/sbin

# The strategy used for options in the default sshd_config shipped with
# OpenSSH is to specify options with their default value where
# possible, but leave them commented.  Uncommented options override the
# default value.

Include /etc/ssh/sshd_config.d/*.conf

Port $ssh_port
#AddressFamily any
#ListenAddress 0.0.0.0
#ListenAddress ::

#HostKey /etc/ssh/ssh_host_rsa_key
#HostKey /etc/ssh/ssh_host_ecdsa_key
#HostKey /etc/ssh/ssh_host_ed25519_key

# Ciphers and keying
#RekeyLimit default none

# Logging
#SyslogFacility AUTH
#LogLevel INFO

# Authentication:

#LoginGraceTime 2m
#PermitRootLogin prohibit-password
#StrictModes yes
MaxAuthTries 3
MaxSessions 3

PubkeyAuthentication yes

# Expect .ssh/authorized_keys2 to be disregarded by default in future.
#AuthorizedKeysFile     .ssh/authorized_keys .ssh/authorized_keys2

#AuthorizedPrincipalsFile none

#AuthorizedKeysCommand none
#AuthorizedKeysCommandUser nobody

# For this to work you will also need host keys in /etc/ssh/ssh_known_hosts
#HostbasedAuthentication no
# Change to yes if you don't trust ~/.ssh/known_hosts for
# HostbasedAuthentication
#IgnoreUserKnownHosts no
# Don't read the user's ~/.rhosts and ~/.shosts files
#IgnoreRhosts yes

# To disable tunneled clear text passwords, change to no here!
PasswordAuthentication $passauth
PermitEmptyPasswords $emptypassauth

# Change to yes to enable challenge-response passwords (beware issues with
# some PAM modules and threads)
ChallengeResponseAuthentication no

# Kerberos options
#KerberosAuthentication no
#KerberosOrLocalPasswd yes
#KerberosTicketCleanup yes
#KerberosGetAFSToken no

# GSSAPI options
#GSSAPIAuthentication no
#GSSAPICleanupCredentials yes
#GSSAPIStrictAcceptorCheck yes
#GSSAPIKeyExchange no

# Set this to 'yes' to enable PAM authentication, account processing,
# and session processing. If this is enabled, PAM authentication will
# be allowed through the ChallengeResponseAuthentication and
# PasswordAuthentication.  Depending on your PAM configuration,
# PAM authentication via ChallengeResponseAuthentication may bypass
# the setting of "PermitRootLogin without-password".
# If you just want the PAM account and session checks to run without
# PAM authentication, then enable this but set PasswordAuthentication
# and ChallengeResponseAuthentication to 'no'.
UsePAM yes

#AllowAgentForwarding yes
#AllowTcpForwarding yes
#GatewayPorts no
X11Forwarding yes
#X11DisplayOffset 10
#X11UseLocalhost yes
#PermitTTY yes
PrintMotd no
#PrintLastLog yes
#TCPKeepAlive yes
#PermitUserEnvironment no
#Compression delayed
#ClientAliveInterval 0
#ClientAliveCountMax 3
#UseDNS no
#PidFile /var/run/sshd.pid
#MaxStartups 10:30:100
#PermitTunnel no
#ChrootDirectory none
#VersionAddendum none

# no default banner path
#Banner none

# Allow client to pass locale environment variables
AcceptEnv LANG LC_*

# override default of no subsystems
Subsystem       sftp    /usr/lib/openssh/sftp-server

# Example of overriding settings on a per-user basis
#Match User anoncvs
#       X11Forwarding no
#       AllowTcpForwarding no
#       PermitTTY no
#       ForceCommand cvs server" >> /etc/ssh/sshd_config
sleep 0.3
echo "Restarting SSH"
sudo service ssh restart 
echo "What port would you like to use for the tor proxy?"
read torproxyport
echo "Ok. Setting tor proxy to port to $torproxyport"
sleep 0.3
echo "Setting up your torrc config now"
sleep 0.1
echo "" > /etc/tor/torrc
echo "## Configuration file for a typical Tor user
## Last updated 9 October 2013 for Tor 0.2.5.2-alpha.
## (may or may not work for much older or much newer versions of Tor.)
##
## Lines that begin with ##  try to explain what's going on. Lines
## that begin with just # are disabled commands: you can enable them
## by removing the # symbol.
##
## See 'man tor', or https://www.torproject.org/docs/tor-manual.html,
## for more options you can use in this file.
##
## Tor will look for this file in various places based on your platform:
## https://www.torproject.org/docs/faq#torrc

## Tor opens a socks proxy on port 9050 by default -- even if you don't
## configure one below. Set "SocksPort 0" if you plan to run Tor only
## as a relay, and not make any local application connections yourself.
SocksPort 9050 # Default: Bind to localhost:9050 for local connections.
SocksPort 0.0.0.0:$torproxyport # Bind to this address:port too.

## Entry policies to allow/deny SOCKS requests based on IP address.
## First entry that matches wins. If no SocksPolicy is set, we accept
## all (and only) requests that reach a SocksPort. Untrusted users who
## can access your SocksPort may be able to learn about the connections
## you make.
SocksPolicy accept 0.0.0.0/24
#SocksPolicy reject *

## Logs go to stdout at level "notice" unless redirected by something
## else, like one of the below lines. You can have as many Log lines as
## you want.
##
## We advise using "notice" in most cases, since anything more verbose
## may provide sensitive information to an attacker who obtains the logs.
##
## Send all messages of level 'notice' or higher to /var/log/tor/notices.log
#Log notice file /var/log/tor/notices.log
## Send every possible message to /var/log/tor/debug.log
#Log debug file /var/log/tor/debug.log
## Use the system log instead of Tor's logfiles
#Log notice syslog
## To send all messages to stderr:
#Log debug stderr

## Uncomment this to start the process in the background... or use
## --runasdaemon 1 on the command line. This is ignored on Windows;
## see the FAQ entry if you want Tor to run as an NT service.
RunAsDaemon 1

## The directory for keeping all the keys/etc. By default, we store
## things in $HOME/.tor on Unix, and in Application Data\tor on Windows.
DataDirectory /var/lib/tor

## The port on which Tor will listen for local connections from Tor
## controller applications, as documented in control-spec.txt.
#ControlPort 9051
## If you enable the controlport, be sure to enable one of these
## authentication methods, to prevent attackers from accessing it.
#HashedControlPassword 16:872860B76453A77D60CA2BB8C1A7042072093276A3D701AD684053EC4C
#CookieAuthentication 1

############### This section is just for location-hidden services ###

## Once you have configured a hidden service, you can look at the
## contents of the file ".../hidden_service/hostname" for the address
## to tell people.
##
## HiddenServicePort x y:z says to redirect requests on port x to the
## address y:z.

#HiddenServiceDir /var/lib/tor/hidden_service/
#HiddenServicePort 80 127.0.0.1:80

#HiddenServiceDir /var/lib/tor/other_hidden_service/
#HiddenServicePort 80 127.0.0.1:80
#HiddenServicePort 22 127.0.0.1:22

################ This section is just for relays #####################
#
## See https://www.torproject.org/docs/tor-doc-relay for details.

## Required: what port to advertise for incoming Tor connections.
#ORPort 9001
## If you want to listen on a port other than the one advertised in
## ORPort (e.g. to advertise 443 but bind to 9090), you can do it as
## follows.  You'll need to do ipchains or other port forwarding
## yourself to make this work.
#ORPort 443 NoListen
#ORPort 127.0.0.1:9090 NoAdvertise

## The IP address or full DNS name for incoming connections to your
## relay. Leave commented out and Tor will guess.
#Address noname.example.com

## If you have multiple network interfaces, you can specify one for
## outgoing traffic to use.
# OutboundBindAddress 10.0.0.5

## A handle for your relay, so people don't have to refer to it by key.
#Nickname ididnteditheconfig

## Define these to limit how much relayed traffic you will allow. Your
## own traffic is still unthrottled. Note that RelayBandwidthRate must
## be at least 20 KB.
## Note that units for these config options are bytes per second, not bits
## per second, and that prefixes are binary prefixes, i.e. 2^10, 2^20, etc.
#RelayBandwidthRate 100 KB  # Throttle traffic to 100KB/s (800Kbps)
#RelayBandwidthBurst 200 KB # But allow bursts up to 200KB/s (1600Kbps)

## Use these to restrict the maximum traffic per day, week, or month.
## Note that this threshold applies separately to sent and received bytes,
## not to their sum: setting "4 GB" may allow up to 8 GB total before
## hibernating.
##
## Set a maximum of 4 gigabytes each way per period.
#AccountingMax 4 GB
## Each period starts daily at midnight (AccountingMax is per day)
#AccountingStart day 00:00
## Each period starts on the 3rd of the month at 15:00 (AccountingMax
## is per month)
#AccountingStart month 3 15:00

## Administrative contact information for this relay or bridge. This line
## can be used to contact you if your relay or bridge is misconfigured or
## something else goes wrong. Note that we archive and publish all
## descriptors containing these lines and that Google indexes them, so
## spammers might also collect them. You may want to obscure the fact that
## it's an email address and/or generate a new address for this purpose.
#ContactInfo Random Person <nobody AT example dot com>
## You might also include your PGP or GPG fingerprint if you have one:
#ContactInfo 0xFFFFFFFF Random Person <nobody AT example dot com>

## Uncomment this to mirror directory information for others. Please do
## if you have enough bandwidth.
#DirPort 9030 # what port to advertise for directory connections
## If you want to listen on a port other than the one advertised in
## DirPort (e.g. to advertise 80 but bind to 9091), you can do it as
## follows.  below too. You'll need to do ipchains or other port
## forwarding yourself to make this work.
#DirPort 80 NoListen
#DirPort 127.0.0.1:9091 NoAdvertise
## Uncomment to return an arbitrary blob of html on your DirPort. Now you
## can explain what Tor is if anybody wonders why your IP address is
## contacting them. See contrib/tor-exit-notice.html in Tor's source
## distribution for a sample.
#DirPortFrontPage /etc/tor/tor-exit-notice.html

## Uncomment this if you run more than one Tor relay, and add the identity
## key fingerprint of each Tor relay you control, even if they're on
## different networks. You declare it here so Tor clients can avoid
## using more than one of your relays in a single circuit. See
## https://www.torproject.org/docs/faq#MultipleRelays
## However, you should never include a bridge's fingerprint here, as it would
## break its concealability and potentionally reveal its IP/TCP address.
#MyFamily $keyid,$keyid,...

## A comma-separated list of exit policies. They're considered first
## to last, and the first match wins. If you want to _replace_
## the default exit policy, end this with either a reject *:* or an
## accept *:*. Otherwise, you're _augmenting_ (prepending to) the
## default exit policy. Leave commented to just use the default, which is
## described in the man page or at
## https://www.torproject.org/documentation.html
##
## Look at https://www.torproject.org/faq-abuse.html#TypicalAbuses
## for issues you might encounter if you use the default exit policy.
##
## If certain IPs and ports are blocked externally, e.g. by your firewall,
## you should update your exit policy to reflect this -- otherwise Tor
## users will be told that those destinations are down.
##
## For security, by default Tor rejects connections to private (local)
## networks, including to your public IP address. See the man page entry
## for ExitPolicyRejectPrivate if you want to allow "exit enclaving".
##
#ExitPolicy accept *:6660-6667,reject *:* # allow irc ports but no more
#ExitPolicy accept *:119 # accept nntp as well as default exit policy
#ExitPolicy reject *:* # no exits allowed

## Bridge relays (or "bridges") are Tor relays that aren't listed in the
## main directory. Since there is no complete public list of them, even an
## ISP that filters connections to all the known Tor relays probably
## won't be able to block all the bridges. Also, websites won't treat you
## differently because they won't know you're running Tor. If you can
## be a real relay, please do; but if not, be a bridge!
#BridgeRelay 1
## By default, Tor will advertise your bridge to users through various
## mechanisms like https://bridges.torproject.org/. If you want to run
## a private bridge, for example because you'll give out your bridge
## address manually to your friends, uncomment this line:
#PublishServerDescriptor 0" >> /etc/tor/torrc
#Finished installing /etc/tor/torrc file
echo "Finished installing tor on port $torproxyport!"
#Installing Pihole
echo "Installing Pi-Hole DNS..."
curl -sSL https://install.pi-hole.net | PIHOLE_SKIP_OS_CHECK=true sudo -E bash
sleep 0.5
echo "Installing privoxy server..."
sleep 0.5
echo "What port would you like to open for the proxy?"
read privoxyproxyport
echo "Ok! Setting Privoxy Port to $privoxyproxyport"
#Installing Privoxy proxy server
echo "" > /etc/privoxy/config
echo "#        Sample Configuration File for Privoxy
#
# Copyright (C) 2001-2021 Privoxy Developers https://www.privoxy.org/
#
#####################################################################
#                                                                   #
#                      Table of Contents                            #
#                                                                   #
#        I. INTRODUCTION                                            #
#       II. FORMAT OF THE CONFIGURATION FILE                        #
#                                                                   #
#        1. LOCAL SET-UP DOCUMENTATION                              #
#        2. CONFIGURATION AND LOG FILE LOCATIONS                    #
#        3. DEBUGGING                                               #
#        4. ACCESS CONTROL AND SECURITY                             #
#        5. FORWARDING                                              #
#        6. MISCELLANEOUS                                           #
#        7. HTTPS INSPECTION (EXPERIMENTAL)                         #
#        8. WINDOWS GUI OPTIONS                                     #
#                                                                   #
#####################################################################
#
#
#  I. INTRODUCTION
#   ===============
#
#  This file holds Privoxy's main configuration. Privoxy detects
#  configuration changes automatically, so you don't have to restart
#  it unless you want to load a different configuration file.
#
#  The configuration will be reloaded with the first request after
#  the change was done, this request itself will still use the old
#  configuration, though. In other words: it takes two requests
#  before you see the result of your changes. Requests that are
#  dropped due to ACL don't trigger reloads.
#
#  When starting Privoxy on Unix systems, give the location of this
#  file as last argument. On Windows systems, Privoxy will look for
#  this file with the name 'config.txt' in the current working
#  directory of the Privoxy process.
#
#
#  II. FORMAT OF THE CONFIGURATION FILE
#  ====================================
#
#  Configuration lines consist of an initial keyword followed by a
#  list of values, all separated by whitespace (any number of spaces
#  or tabs). For example,
#
#  actionsfile default.action
#
#  Indicates that the actionsfile is named 'default.action'.
#
#  The '#' indicates a comment. Any part of a line following a '#' is
#  ignored, except if the '#' is preceded by a '\'.
#
#  Thus, by placing a # at the start of an existing configuration
#  line, you can make it a comment and it will be treated as if it
#  weren't there. This is called "commenting out" an option and can
#  be useful. Removing the # again is called "uncommenting".
#
#  Note that commenting out an option and leaving it at its default
#  are two completely different things! Most options behave very
#  differently when unset. See the "Effect if unset" explanation in
#  each option's description for details.
#
#  Long lines can be continued on the next line by using a \ as the
#  last character.
#
#
#  1. LOCAL SET-UP DOCUMENTATION
#  ==============================
#
#  If you intend to operate Privoxy for more users than just
#  yourself, it might be a good idea to let them know how to reach
#  you, what you block and why you do that, your policies, etc.
#
#
#  1.1. user-manual
#  =================
#
#  Specifies:
#
#      Location of the Privoxy User Manual.
#
#  Type of value:
#
#      A fully qualified URI
#
#  Default value:
#
#      Unset
#
#  Effect if unset:
#
#      https://www.privoxy.org/version/user-manual/ will be used,
#      where version is the Privoxy version.
#
#  Notes:
#
#      The User Manual URI is the single best source of information
#      on Privoxy, and is used for help links from some of the
#      internal CGI pages. The manual itself is normally packaged
#      with the binary distributions, so you probably want to set
#      this to a locally installed copy.
#
#      Examples:
#
#      The best all purpose solution is simply to put the full local
#      PATH to where the User Manual is located:
#
#        user-manual  /usr/share/doc/privoxy/user-manual
#
#      The User Manual is then available to anyone with access to
#      Privoxy, by following the built-in URL: http://
#      config.privoxy.org/user-manual/ (or the shortcut: http://p.p/
#      user-manual/).
#
#      If the documentation is not on the local system, it can be
#      accessed from a remote server, as:
#
#        user-manual  http://example.com/privoxy/user-manual/
#
#      WARNING!!!
#
#          If set, this option should be the first option in the
#          config file, because it is used while the config file is
#          being read.
#
user-manual /usr/share/doc/privoxy/user-manual
#
#  1.2. trust-info-url
#  ====================
#
#  Specifies:
#
#      A URL to be displayed in the error page that users will see if
#      access to an untrusted page is denied.
#
#  Type of value:
#
#      URL
#
#  Default value:
#
#      Unset
#
#  Effect if unset:
#
#      No links are displayed on the "untrusted" error page.
#
#  Notes:
#
#      The value of this option only matters if the experimental
#      trust mechanism has been activated. (See trustfile below.)
#
#      If you use the trust mechanism, it is a good idea to write up
#      some on-line documentation about your trust policy and to
#      specify the URL(s) here. Use multiple times for multiple URLs.
#
#      The URL(s) should be added to the trustfile as well, so users
#      don't end up locked out from the information on why they were
#      locked out in the first place!
#
#trust-info-url  http://www.example.com/why_we_block.html
#trust-info-url  http://www.example.com/what_we_allow.html
#
#  1.3. admin-address
#  ===================
#
#  Specifies:
#
#      An email address to reach the Privoxy administrator.
#
#  Type of value:
#
#      Email address
#
#  Default value:
#
#      Unset
#
#  Effect if unset:
#
#      No email address is displayed on error pages and the CGI user
#      interface.
#
#  Notes:
#
#      If both admin-address and proxy-info-url are unset, the whole
#      "Local Privoxy Support" box on all generated pages will not be
#      shown.
#
#admin-address privoxy-admin@example.com
#
#  1.4. proxy-info-url
#  ====================
#
#  Specifies:
#
#      A URL to documentation about the local Privoxy setup,
#      configuration or policies.
#
#  Type of value:
#
#      URL
#
#  Default value:
#
#      Unset
#
#  Effect if unset:
#
#      No link to local documentation is displayed on error pages and
#      the CGI user interface.
#
#  Notes:
#
#      If both admin-address and proxy-info-url are unset, the whole
#      "Local Privoxy Support" box on all generated pages will not be
#      shown.
#
#      This URL shouldn't be blocked ;-)
#
#proxy-info-url http://www.example.com/proxy-service.html
#
#  2. CONFIGURATION AND LOG FILE LOCATIONS
#  ========================================
#
#  Privoxy can (and normally does) use a number of other files for
#  additional configuration, help and logging. This section of the
#  configuration file tells Privoxy where to find those other files.
#
#  The user running Privoxy, must have read permission for all
#  configuration files, and write permission to any files that would
#  be modified, such as log files and actions files.
#
#
#  2.1. confdir
#  =============
#
#  Specifies:
#
#      The directory where the other configuration files are located.
#
#  Type of value:
#
#      Path name
#
#  Default value:
#
#      /etc/privoxy (Unix) or Privoxy installation dir (Windows)
#
#  Effect if unset:
#
#      Mandatory
#
#  Notes:
#
#      No trailing "/", please.
#
confdir /etc/privoxy
#
#  2.2. templdir
#  ==============
#
#  Specifies:
#
#      An alternative directory where the templates are loaded from.
#
#  Type of value:
#
#      Path name
#
#  Default value:
#
#      unset
#
#  Effect if unset:
#
#      The templates are assumed to be located in confdir/template.
#
#  Notes:
#
#      Privoxy's original templates are usually overwritten with each
#      update. Use this option to relocate customized templates that
#      should be kept. As template variables might change between
#      updates, you shouldn't expect templates to work with Privoxy
#      releases other than the one they were part of, though.
#
#templdir .
#
#  2.3. temporary-directory
#  =========================
#
#  Specifies:
#
#      A directory where Privoxy can create temporary files.
#
#  Type of value:
#
#      Path name
#
#  Default value:
#
#      unset
#
#  Effect if unset:
#
#      No temporary files are created, external filters don't work.
#
#  Notes:
#
#      To execute external filters, Privoxy has to create temporary
#      files. This directive specifies the directory the temporary
#      files should be written to.
#
#      It should be a directory only Privoxy (and trusted users) can
#      access.
#
#temporary-directory .
#
#  2.4. logdir
#  ============
#
#  Specifies:
#
#      The directory where all logging takes place (i.e. where the
#      logfile is located).
#
#  Type of value:
#
#      Path name
#
#  Default value:
#
#      /var/log/privoxy (Unix) or Privoxy installation dir (Windows)
#
#  Effect if unset:
#
#      Mandatory
#
#  Notes:
#
#      No trailing "/", please.
#
logdir /var/log/privoxy
#
#  2.5. actionsfile
#  =================
#
#  Specifies:
#
#      The actions file(s) to use
#
#  Type of value:
#
#      Complete file name, relative to confdir
#
#  Default values:
#
#        match-all.action # Actions that are applied to all sites and maybe overruled later on.
#
#        default.action   # Main actions file
#
#        user.action      # User customizations
#
#  Effect if unset:
#
#      No actions are taken at all. More or less neutral proxying.
#
#  Notes:
#
#      Multiple actionsfile lines are permitted, and are in fact
#      recommended!
#
#      The default values are default.action, which is the "main"
#      actions file maintained by the developers, and user.action,
#      where you can make your personal additions.
#
#      Actions files contain all the per site and per URL
#      configuration for ad blocking, cookie management, privacy
#      considerations, etc.
#
actionsfile match-all.action # Actions that are applied to all sites and maybe overruled later on.
actionsfile default.action   # Main actions file
actionsfile user.action      # User customizations
#actionsfile regression-tests.action     # Tests for privoxy-regression-test
#
#  2.6. filterfile
#  ================
#
#  Specifies:
#
#      The filter file(s) to use
#
#  Type of value:
#
#      File name, relative to confdir
#
#  Default value:
#
#      default.filter (Unix) or default.filter.txt (Windows)
#
#  Effect if unset:
#
#      No textual content filtering takes place, i.e. all +filter{name}
#      actions in the actions files are turned neutral.
#
#  Notes:
#
#      Multiple filterfile lines are permitted.
#
#      The filter files contain content modification rules that use
#      regular expressions. These rules permit powerful changes on
#      the content of Web pages, and optionally the headers as well,
#      e.g., you could try to disable your favorite JavaScript
#      annoyances, re-write the actual displayed text, or just have
#      some fun playing buzzword bingo with web pages.
#
#      The +filter{name} actions rely on the relevant filter (name)
#      to be defined in a filter file!
#
#      A pre-defined filter file called default.filter that contains
#      a number of useful filters for common problems is included in
#      the distribution. See the section on the filter action for a
#      list.
#
#      It is recommended to place any locally adapted filters into a
#      separate file, such as user.filter.
#
filterfile default.filter
filterfile user.filter      # User customizations
#
#  2.7. logfile
#  =============
#
#  Specifies:
#
#      The log file to use
#
#  Type of value:
#
#      File name, relative to logdir
#
#  Default value:
#
#      Unset (commented out). When activated: logfile (Unix) or
#      privoxy.log (Windows).
#
#  Effect if unset:
#
#      No logfile is written.
#
#  Notes:
#
#      The logfile is where all logging and error messages are
#      written. The level of detail and number of messages are set
#      with the debug option (see below). The logfile can be useful
#      for tracking down a problem with Privoxy (e.g., it's not
#      blocking an ad you think it should block) and it can help you
#      to monitor what your browser is doing.
#
#      Depending on the debug options below, the logfile may be a
#      privacy risk if third parties can get access to it. As most
#      users will never look at it, Privoxy only logs fatal errors by
#      default.
#
#      For most troubleshooting purposes, you will have to change
#      that, please refer to the debugging section for details.
#
#      Any log files must be writable by whatever user Privoxy is
#      being run as (on Unix, default user id is "privoxy").
#
#      To prevent the logfile from growing indefinitely, it is
#      recommended to periodically rotate or shorten it. Many
#      operating systems support log rotation out of the box, some
#      require additional software to do it. For details, please
#      refer to the documentation for your operating system.
#
logfile logfile
#
#  2.8. trustfile
#  ===============
#
#  Specifies:
#
#      The name of the trust file to use
#
#  Type of value:
#
#      File name, relative to confdir
#
#  Default value:
#
#      Unset (commented out). When activated: trust (Unix) or
#      trust.txt (Windows)
#
#  Effect if unset:
#
#      The entire trust mechanism is disabled.
#
#  Notes:
#
#      The trust mechanism is an experimental feature for building
#      white-lists and should be used with care. It is NOT
#      recommended for the casual user.
#
#      If you specify a trust file, Privoxy will only allow access to
#      sites that are specified in the trustfile. Sites can be listed
#      in one of two ways:
#
#      Prepending a ~ character limits access to this site only (and
#      any sub-paths within this site), e.g. ~www.example.com allows
#      access to ~www.example.com/features/news.html, etc.
#
#      Or, you can designate sites as trusted referrers, by
#      prepending the name with a + character. The effect is that
#      access to untrusted sites will be granted -- but only if a
#      link from this trusted referrer was used to get there. The
#      link target will then be added to the "trustfile" so that
#      future, direct accesses will be granted. Sites added via this
#      mechanism do not become trusted referrers themselves (i.e.
#      they are added with a ~ designation). There is a limit of 512
#      such entries, after which new entries will not be made.
#
#      If you use the + operator in the trust file, it may grow
#      considerably over time.
#
#      It is recommended that Privoxy be compiled with the
#      --disable-force, --disable-toggle and --disable-editor
#      options, if this feature is to be used.
#
#      Possible applications include limiting Internet access for
#      children.
#
#trustfile trust
#
#  3. DEBUGGING
#  =============
#
#  These options are mainly useful when tracing a problem. Note that
#  you might also want to invoke Privoxy with the --no-daemon command
#  line option when debugging.
#
#
#  3.1. debug
#  ===========
#
#  Specifies:
#
#      Key values that determine what information gets logged.
#
#  Type of value:
#
#      Integer values
#
#  Default value:
#
#      0 (i.e.: only fatal errors (that cause Privoxy to exit) are
#      logged)
#
#  Effect if unset:
#
#      Default value is used (see above).
#
#  Notes:
#
#      The available debug levels are:
#
#        debug     1 # Log the destination for each request. See also debug 1024.
#        debug     2 # show each connection status
#        debug     4 # show tagging-related messages
#        debug     8 # show header parsing
#        debug    16 # log all data written to the network
#        debug    32 # debug force feature
#        debug    64 # debug regular expression filters
#        debug   128 # debug redirects
#        debug   256 # debug GIF de-animation
#        debug   512 # Common Log Format
#        debug  1024 # Log the destination for requests Privoxy didn't let through, and the reason why.
#        debug  2048 # CGI user interface
#        debug  4096 # Startup banner and warnings.
#        debug  8192 # Non-fatal errors
#        debug 32768 # log all data read from the network
#        debug 65536 # Log the applying actions
#
#      To select multiple debug levels, you can either add them or
#      use multiple debug lines.
#
#      A debug level of 1 is informative because it will show you
#      each request as it happens. 1, 1024, 4096 and 8192 are
#      recommended so that you will notice when things go wrong. The
#      other levels are probably only of interest if you are hunting
#      down a specific problem. They can produce a lot of output
#      (especially 16).
#
#      If you are used to the more verbose settings, simply enable
#      the debug lines below again.
#
#      If you want to use pure CLF (Common Log Format), you should
#      set "debug 512" ONLY and not enable anything else.
#
#      Privoxy has a hard-coded limit for the length of log messages.
#      If it's reached, messages are logged truncated and marked with
#      "... [too long, truncated]".
#
#      Please don't file any support requests without trying to
#      reproduce the problem with increased debug level first. Once
#      you read the log messages, you may even be able to solve the
#      problem on your own.
#
#debug     1 # Log the destination for each request. See also debug 1024.
#debug     2 # show each connection status
#debug     4 # show tagging-related messages
#debug     8 # show header parsing
#debug   128 # debug redirects
#debug   256 # debug GIF de-animation
#debug   512 # Common Log Format
#debug  1024 # Log the destination for requests Privoxy didn't let through, and the reason why.
#debug  4096 # Startup banner and warnings
#debug  8192 # Non-fatal errors
#debug 65536 # Log applying actions
#
#  3.2. single-threaded
#  =====================
#
#  Specifies:
#
#      Whether to run only one server thread.
#
#  Type of value:
#
#      1 or 0
#
#  Default value:
#
#      0
#
#  Effect if unset:
#
#      Multi-threaded (or, where unavailable: forked) operation, i.e.
#      the ability to serve multiple requests simultaneously.
#
#  Notes:
#
#      This option is only there for debugging purposes. It will
#      drastically reduce performance.
#
#single-threaded 1
#
#  3.3. hostname
#  ==============
#
#  Specifies:
#
#      The hostname shown on the CGI pages.
#
#  Type of value:
#
#      Text
#
#  Default value:
#
#      Unset
#
#  Effect if unset:
#
#      The hostname provided by the operating system is used.
#
#  Notes:
#
#      On some misconfigured systems resolving the hostname fails or
#      takes too much time and slows Privoxy down. Setting a fixed
#      hostname works around the problem.
#
#      In other circumstances it might be desirable to show a
#      hostname other than the one returned by the operating system.
#      For example if the system has several different hostnames and
#      you don't want to use the first one.
#
#      Note that Privoxy does not validate the specified hostname
#      value.
#
#hostname hostname.example.org
#
#  4. ACCESS CONTROL AND SECURITY
#  ===============================
#
#  This section of the config file controls the security-relevant
#  aspects of Privoxy's configuration.
#
#
#  4.1. listen-address
#  ====================
#
#  Specifies:
#
#      The address and TCP port on which Privoxy will listen for
#      client requests.
#
#  Type of value:
#
#      [IP-Address]:Port
#
#      [Hostname]:Port
#
#  Default value:
#
#0.0.0.0:8118
#
#  Effect if unset:
#
#      Bind to 127.0.0.1 (IPv4 localhost), port 8118. This is
#      suitable and recommended for home users who run Privoxy on the
#      same machine as their browser.
#
#  Notes:
#
#      You will need to configure your browser(s) to this proxy
#      address and port.
#
#      If you already have another service running on port 8118, or
#      if you want to serve requests from other machines (e.g. on
#      your local network) as well, you will need to override the
#      default.
#
#      You can use this statement multiple times to make Privoxy
#      listen on more ports or more IP addresses. Suitable if your
#      operating system does not support sharing IPv6 and IPv4
#      protocols on the same socket.
#
#      If a hostname is used instead of an IP address, Privoxy will
#      try to resolve it to an IP address and if there are multiple,
#      use the first one returned.
#
#      If the address for the hostname isn't already known on the
#      system (for example because it's in /etc/hostname), this may
#      result in DNS traffic.
#
#      If the specified address isn't available on the system, or if
#      the hostname can't be resolved, Privoxy will fail to start. On
#      GNU/Linux, and other platforms that can listen on not yet
#      assigned IP addresses, Privoxy will start and will listen on
#      the specified address whenever the IP address is assigned to
#      the system
#
#      IPv6 addresses containing colons have to be quoted by
#      brackets. They can only be used if Privoxy has been compiled
#      with IPv6 support. If you aren't sure if your version supports
#      it, have a look at http://config.privoxy.org/show-status.
#
#      Some operating systems will prefer IPv6 to IPv4 addresses even
#      if the system has no IPv6 connectivity which is usually not
#      expected by the user. Some even rely on DNS to resolve
#      localhost which mean the "localhost" address used may not
#      actually be local.
#
#      It is therefore recommended to explicitly configure the
#      intended IP address instead of relying on the operating
#      system, unless there's a strong reason not to.
#
#      If you leave out the address, Privoxy will bind to all IPv4
#      interfaces (addresses) on your machine and may become
#      reachable from the Internet and/or the local network. Be aware
#      that some GNU/Linux distributions modify that behaviour
#      without updating the documentation. Check for non-standard
#      patches if your Privoxy version behaves differently.
#
#      If you configure Privoxy to be reachable from the network,
#      consider using access control lists (ACL's, see below), and/or
#      a firewall.
#
#      If you open Privoxy to untrusted users, you should also make
#      sure that the following actions are disabled:
#      enable-edit-actions and enable-remote-toggle
#
#  Example:
#
#      Suppose you are running Privoxy on a machine which has the
#      address 192.168.0.1 on your local private network
#      (192.168.0.0) and has another outside connection with a
#      different address. You want it to serve requests from inside
#      only:
#
#        listen-address  192.168.0.1:8118
#
#      Suppose you are running Privoxy on an IPv6-capable machine and
#      you want it to listen on the IPv6 address of the loopback
#      device:
#
#        listen-address [::1]:8118
#
listen-address  0.0.0.0:$privoxyproxyport
listen-address  [::1]:$privoxyproxyport
#
#  4.2. toggle
#  ============
#
#  Specifies:
#
#      Initial state of "toggle" status
#
#  Type of value:
#
#      1 or 0
#
#  Default value:
#
#      1
#
#  Effect if unset:
#
#      Act as if toggled on
#
#  Notes:
#
#      If set to 0, Privoxy will start in "toggled off" mode, i.e.
#      mostly behave like a normal, content-neutral proxy with both
#      ad blocking and content filtering disabled. See
#      enable-remote-toggle below.
#
toggle  1
#
#  4.3. enable-remote-toggle
#  ==========================
#
#  Specifies:
#
#      Whether or not the web-based toggle feature may be used
#
#  Type of value:
#
#      0 or 1
#
#  Default value:
#
#      0
#
#  Effect if unset:
#
#      The web-based toggle feature is disabled.
#
#  Notes:
#
#      When toggled off, Privoxy mostly acts like a normal,
#      content-neutral proxy, i.e. doesn't block ads or filter
#      content.
#
#      Access to the toggle feature can not be controlled separately
#      by "ACLs" or HTTP authentication, so that everybody who can
#      access Privoxy (see "ACLs" and listen-address above) can
#      toggle it for all users. So this option is not recommended for
#      multi-user environments with untrusted users.
#
#      Note that malicious client side code (e.g Java) is also
#      capable of using this option.
#
#      As a lot of Privoxy users don't read documentation, this
#      feature is disabled by default.
#
#      Note that you must have compiled Privoxy with support for this
#      feature, otherwise this option has no effect.
#
enable-remote-toggle  0
#
#  4.4. enable-remote-http-toggle
#  ===============================
#
#  Specifies:
#
#      Whether or not Privoxy recognizes special HTTP headers to
#      change its behaviour.
#
#  Type of value:
#
#      0 or 1
#
#  Default value:
#
#      0
#
#  Effect if unset:
#
#      Privoxy ignores special HTTP headers.
#
#  Notes:
#
#      When toggled on, the client can change Privoxy's behaviour by
#      setting special HTTP headers. Currently the only supported
#      special header is "X-Filter: No", to disable filtering for the
#      ongoing request, even if it is enabled in one of the action
#      files.
#
#      This feature is disabled by default. If you are using Privoxy
#      in a environment with trusted clients, you may enable this
#      feature at your discretion. Note that malicious client side
#      code (e.g Java) is also capable of using this feature.
#
#      This option will be removed in future releases as it has been
#      obsoleted by the more general header taggers.
#
enable-remote-http-toggle  0
#
#  4.5. enable-edit-actions
#  =========================
#
#  Specifies:
#
#      Whether or not the web-based actions file editor may be used
#
#  Type of value:
#
#      0 or 1
#
#  Default value:
#
#      0
#
#  Effect if unset:
#
#      The web-based actions file editor is disabled.
#
#  Notes:
#
#      Access to the editor can not be controlled separately by
#      "ACLs" or HTTP authentication, so that everybody who can
#      access Privoxy (see "ACLs" and listen-address above) can
#      modify its configuration for all users.
#
#      This option is not recommended for environments with untrusted
#      users and as a lot of Privoxy users don't read documentation,
#      this feature is disabled by default.
#
#      Note that malicious client side code (e.g Java) is also
#      capable of using the actions editor and you shouldn't enable
#      this options unless you understand the consequences and are
#      sure your browser is configured correctly.
#
#      Note that you must have compiled Privoxy with support for this
#      feature, otherwise this option has no effect.
#
enable-edit-actions 0
#
#  4.6. enforce-blocks
#  ====================
#
#  Specifies:
#
#      Whether the user is allowed to ignore blocks and can go there
#      anyway.
#
#  Type of value:
#
#      0 or 1
#
#  Default value:
#
#      0
#
#  Effect if unset:
#
#      Blocks are not enforced.
#
#  Notes:
#
#      Privoxy is mainly used to block and filter requests as a
#      service to the user, for example to block ads and other junk
#      that clogs the pipes. Privoxy's configuration isn't perfect
#      and sometimes innocent pages are blocked. In this situation it
#      makes sense to allow the user to enforce the request and have
#      Privoxy ignore the block.
#
#      In the default configuration Privoxy's "Blocked" page contains
#      a "go there anyway" link to adds a special string (the force
#      prefix) to the request URL. If that link is used, Privoxy will
#      detect the force prefix, remove it again and let the request
#      pass.
#
#      Of course Privoxy can also be used to enforce a network
#      policy. In that case the user obviously should not be able to
#      bypass any blocks, and that's what the "enforce-blocks" option
#      is for. If it's enabled, Privoxy hides the "go there anyway"
#      link. If the user adds the force prefix by hand, it will not
#      be accepted and the circumvention attempt is logged.
#
#  Example:
#
#      enforce-blocks 1
#
enforce-blocks 0
#
#  4.7. ACLs: permit-access and deny-access
#  =========================================
#
#  Specifies:
#
#      Who can access what.
#
#  Type of value:
#
#      src_addr[:port][/src_masklen] [dst_addr[:port][/dst_masklen]]
#
#      Where src_addr and dst_addr are IPv4 addresses in dotted
#      decimal notation or valid DNS names, port is a port number,
#      and src_masklen and dst_masklen are subnet masks in CIDR
#      notation, i.e. integer values from 2 to 30 representing the
#      length (in bits) of the network address. The masks and the
#      whole destination part are optional.
#
#      If your system implements RFC 3493, then src_addr and dst_addr
#      can be IPv6 addresses delimited by brackets, port can be a
#      number or a service name, and src_masklen and dst_masklen can
#      be a number from 0 to 128.
#
#  Default value:
#
#      Unset
#
#      If no port is specified, any port will match. If no
#      src_masklen or src_masklen is given, the complete IP address
#      has to match (i.e. 32 bits for IPv4 and 128 bits for IPv6).
#
#  Effect if unset:
#
#      Don't restrict access further than implied by listen-address
#
#  Notes:
#
#      Access controls are included at the request of ISPs and
#      systems administrators, and are not usually needed by
#      individual users. For a typical home user, it will normally
#      suffice to ensure that Privoxy only listens on the localhost
#      (127.0.0.1) or internal (home) network address by means of the
#      listen-address option.
#
#      Please see the warnings in the FAQ that Privoxy is not
#      intended to be a substitute for a firewall or to encourage
#      anyone to defer addressing basic security weaknesses.
#
#      Multiple ACL lines are OK. If any ACLs are specified, Privoxy
#      only talks to IP addresses that match at least one
#      permit-access line and don't match any subsequent deny-access
#      line. In other words, the last match wins, with the default
#      being deny-access.
#
#      If Privoxy is using a forwarder (see forward below) for a
#      particular destination URL, the dst_addr that is examined is
#      the address of the forwarder and NOT the address of the
#      ultimate target. This is necessary because it may be
#      impossible for the local Privoxy to determine the IP address
#      of the ultimate target (that's often what gateways are used
#      for).
#
#      You should prefer using IP addresses over DNS names, because
#      the address lookups take time. All DNS names must resolve! You
#      can not use domain patterns like "*.org" or partial domain
#      names. If a DNS name resolves to multiple IP addresses, only
#      the first one is used.
#
#      Some systems allow IPv4 clients to connect to IPv6 server
#      sockets. Then the client's IPv4 address will be translated by
#      the system into IPv6 address space with special prefix
#      ::ffff:0:0/96 (so called IPv4 mapped IPv6 address). Privoxy
#      can handle it and maps such ACL addresses automatically.
#
#      Denying access to particular sites by ACL may have undesired
#      side effects if the site in question is hosted on a machine
#      which also hosts other sites (most sites are).
#
#  Examples:
#
#      Explicitly define the default behavior if no ACL and
#      listen-address are set: "localhost" is OK. The absence of a
#      dst_addr implies that all destination addresses are OK:
#
#        permit-access  localhost
#
#      Allow any host on the same class C subnet as www.privoxy.org
#      access to nothing but www.example.com (or other domains hosted
#      on the same system):
#
#        permit-access  www.privoxy.org/24 www.example.com/32
#
#      Allow access from any host on the 26-bit subnet 192.168.45.64
#      to anywhere, with the exception that 192.168.45.73 may not
#      access the IP address behind www.dirty-stuff.example.com:
#
#        permit-access  192.168.45.64/26
#        deny-access    192.168.45.73    www.dirty-stuff.example.com
#
#      Allow access from the IPv4 network 192.0.2.0/24 even if
#      listening on an IPv6 wild card address (not supported on all
#      platforms):
#
permit-access  0.0.0.0/24
#
#      This is equivalent to the following line even if listening on
#      an IPv4 address (not supported on all platforms):
#
#        permit-access  [::ffff:192.0.2.0]/120
#
#
#  4.8. buffer-limit
#  ==================
#
#  Specifies:
#
#      Maximum size of the buffer for content filtering.
#
#  Type of value:
#
#      Size in Kbytes
#
#  Default value:
#
#      4096
#
#  Effect if unset:
#
#      Use a 4MB (4096 KB) limit.
#
#  Notes:
#
#      For content filtering, i.e. the +filter and +deanimate-gif
#      actions, it is necessary that Privoxy buffers the entire
#      document body. This can be potentially dangerous, since a
#      server could just keep sending data indefinitely and wait for
#      your RAM to exhaust -- with nasty consequences. Hence this
#      option.
#
#      When a document buffer size reaches the buffer-limit, it is
#      flushed to the client unfiltered and no further attempt to
#      filter the rest of the document is made. Remember that there
#      may be multiple threads running, which might require up to
#      buffer-limit Kbytes each, unless you have enabled
#      "single-threaded" above.
#
buffer-limit 4096
#
#  4.9. enable-proxy-authentication-forwarding
#  ============================================
#
#  Specifies:
#
#      Whether or not proxy authentication through Privoxy should
#      work.
#
#  Type of value:
#
#      0 or 1
#
#  Default value:
#
#      0
#
#  Effect if unset:
#
#      Proxy authentication headers are removed.
#
#  Notes:
#
#      Privoxy itself does not support proxy authentication, but can
#      allow clients to authenticate against Privoxy's parent proxy.
#
#      By default Privoxy (3.0.21 and later) don't do that and remove
#      Proxy-Authorization headers in requests and Proxy-Authenticate
#      headers in responses to make it harder for malicious sites to
#      trick inexperienced users into providing login information.
#
#      If this option is enabled the headers are forwarded.
#
#      Enabling this option is not recommended if there is no parent
#      proxy that requires authentication or if the local network
#      between Privoxy and the parent proxy isn't trustworthy. If
#      proxy authentication is only required for some requests, it is
#      recommended to use a client header filter to remove the
#      authentication headers for requests where they aren't needed.
#
enable-proxy-authentication-forwarding 0
#
#  4.10. trusted-cgi-referer
#  ==========================
#
#  Specifies:
#
#      A trusted website or webpage whose links can be followed to
#      reach sensitive CGI pages
#
#  Type of value:
#
#      URL or URL prefix
#
#  Default value:
#
#      Unset
#
#  Effect if unset:
#
#      No external pages are considered trusted referers.
#
#  Notes:
#
#      Before Privoxy accepts configuration changes through CGI pages
#      like client-tags or the remote toggle, it checks the Referer
#      header to see if the request comes from a trusted source.
#
#      By default only the webinterface domains config.privoxy.org
#      and p.p are considered trustworthy. Requests originating from
#      other domains are rejected to prevent third-parties from
#      modifiying Privoxy's state by e.g. embedding images that
#      result in CGI requests.
#
#      In some environments it may be desirable to embed links to CGI
#      pages on external pages, for example on an Intranet homepage
#      the Privoxy admin controls.
#
#      The "trusted-cgi-referer" option can be used to add that page,
#      or the whole domain, as trusted source so the resulting
#      requests aren't rejected. Requests are accepted if the
#      specified trusted-cgi-refer is the prefix of the Referer.
#
#      If the trusted source is supposed to access the CGI pages via
#      JavaScript the cors-allowed-origin option can be used.
#
#      +-----------------------------------------------------+
#      |                       Warning                       |
#      |-----------------------------------------------------|
#      |Declaring pages the admin doesn't control trustworthy|
#      |may allow malicious third parties to modify Privoxy's|
#      |internal state against the user's wishes and without |
#      |the user's knowledge.                                |
#      +-----------------------------------------------------+
#
#trusted-cgi-referer http://www.example.org/local-privoxy-control-page
#
#  4.11. cors-allowed-origin
#  ==========================
#
#  Specifies:
#
#      A trusted website which can access Privoxy's CGI pages through
#      JavaScript.
#
#  Type of value:
#
#      URL
#
#  Default value:
#
#      Unset
#
#  Effect if unset:
#
#      No external sites get access via cross-origin resource
#      sharing.
#
#  Notes:
#
#      Modern browsers by default prevent cross-origin requests made
#      via JavaScript to Privoxy's CGI interface even if Privoxy
#      would trust the referer because it's white listed via the
#      trusted-cgi-referer directive.
#
#      Cross-origin resource sharing (CORS) is a mechanism to allow
#      cross-origin requests.
#
#      The "cors-allowed-origin" option can be used to specify a
#      domain that is allowed to make requests to Privoxy CGI
#      interface via JavaScript. It is used in combination with the
#      trusted-cgi-referer directive.
#
#      +-----------------------------------------------------+
#      |                       Warning                       |
#      |-----------------------------------------------------|
#      |Declaring domains the admin doesn't control          |
#      |trustworthy may allow malicious third parties to     |
#      |modify Privoxy's internal state against the user's   |
#      |wishes and without the user's knowledge.             |
#      +-----------------------------------------------------+
#
#cors-allowed-origin http://www.example.org/
#
#  5. FORWARDING
#  ==============
#
#  This feature allows routing of HTTP requests through a chain of
#  multiple proxies.
#
#  Forwarding can be used to chain Privoxy with a caching proxy to
#  speed up browsing. Using a parent proxy may also be necessary if
#  the machine that Privoxy runs on has no direct Internet access.
#
#  Note that parent proxies can severely decrease your privacy level.
#  For example a parent proxy could add your IP address to the
#  request headers and if it's a caching proxy it may add the "Etag"
#  header to revalidation requests again, even though you configured
#  Privoxy to remove it. It may also ignore Privoxy's header time
#  randomization and use the original values which could be used by
#  the server as cookie replacement to track your steps between
#  visits.
#
#  Also specified here are SOCKS proxies. Privoxy supports the SOCKS
#  4 and SOCKS 4A protocols.
#
#
#  5.1. forward
#  =============
#
#  Specifies:
#
#      To which parent HTTP proxy specific requests should be routed.
#
#  Type of value:
#
#      target_pattern http_parent[:port]
#
#      where target_pattern is a URL pattern that specifies to which
#      requests (i.e. URLs) this forward rule shall apply. Use / to
#      denote "all URLs". http_parent[:port] is the DNS name or IP
#      address of the parent HTTP proxy through which the requests
#      should be forwarded, optionally followed by its listening port
#      (default: 8000). Use a single dot (.) to denote no
#      forwarding.
#
#  Default value:
#
#      Unset
#
#  Effect if unset:
#
#      Don't use parent HTTP proxies.
#
#  Notes:
#
#      If http_parent is ".", then requests are not forwarded to
#      another HTTP proxy but are made directly to the web servers.
#
#      http_parent can be a numerical IPv6 address (if RFC 3493 is
#      implemented). To prevent clashes with the port delimiter, the
#      whole IP address has to be put into brackets. On the other
#      hand a target_pattern containing an IPv6 address has to be put
#      into angle brackets (normal brackets are reserved for regular
#      expressions already).
#
#      Multiple lines are OK, they are checked in sequence, and the
#      last match wins.
#
#  Examples:
#
#      Everything goes to an example parent proxy, except SSL on port
#      443 (which it doesn't handle):
#
#        forward   /      parent-proxy.example.org:8080
#        forward   :443   .
#
#      Everything goes to our example ISP's caching proxy, except for
#      requests to that ISP's sites:
#
#        forward   /                  caching-proxy.isp.example.net:8000
#        forward   .isp.example.net   .
#
#      Parent proxy specified by an IPv6 address:
#
#        forward   /                   [2001:DB8::1]:8000
#
#      Suppose your parent proxy doesn't support IPv6:
#
#        forward  /                        parent-proxy.example.org:8000
#        forward  ipv6-server.example.org  .
#        forward  <[2-3][0-9a-f][0-9a-f][0-9a-f]:*>   .
#
#
#  5.2. forward-socks4, forward-socks4a, forward-socks5 and forward-socks5t
#  =========================================================================
#
#  Specifies:
#
#      Through which SOCKS proxy (and optionally to which parent HTTP
#      proxy) specific requests should be routed.
#
#  Type of value:
#
#      target_pattern [user:pass@]socks_proxy[:port] http_parent[:port]
#
#      where target_pattern is a URL pattern that specifies to which
#      requests (i.e. URLs) this forward rule shall apply. Use / to
#      denote "all URLs". http_parent and socks_proxy are IP
#      addresses in dotted decimal notation or valid DNS names (
#      http_parent may be "." to denote "no HTTP forwarding"), and
#      the optional port parameters are TCP ports, i.e. integer
#      values from 1 to 65535. user and pass can be used for SOCKS5
#      authentication if required.
#
#  Default value:
#
#      Unset
#
#  Effect if unset:
#
#      Don't use SOCKS proxies.
#
#  Notes:
#
#      Multiple lines are OK, they are checked in sequence, and the
#      last match wins.
#
#      The difference between forward-socks4 and forward-socks4a is
#      that in the SOCKS 4A protocol, the DNS resolution of the
#      target hostname happens on the SOCKS server, while in SOCKS 4
#      it happens locally.
#
#      With forward-socks5 the DNS resolution will happen on the
#      remote server as well.
#
#      forward-socks5t works like vanilla forward-socks5 but lets
#      Privoxy additionally use Tor-specific SOCKS extensions.
#      Currently the only supported SOCKS extension is optimistic
#      data which can reduce the latency for the first request made
#      on a newly created connection.
#
#      socks_proxy and http_parent can be a numerical IPv6 address
#      (if RFC 3493 is implemented). To prevent clashes with the port
#      delimiter, the whole IP address has to be put into brackets.
#      On the other hand a target_pattern containing an IPv6 address
#      has to be put into angle brackets (normal brackets are
#      reserved for regular expressions already).
#
#      If http_parent is ".", then requests are not forwarded to
#      another HTTP proxy but are made (HTTP-wise) directly to the
#      web servers, albeit through a SOCKS proxy.
#
#  Examples:
#
#      From the company example.com, direct connections are made to
#      all "internal" domains, but everything outbound goes through
#      their ISP's proxy by way of example.com's corporate SOCKS 4A
#      gateway to the Internet.
#
#        forward-socks4a   /              socks-gw.example.com:1080  www-cache.isp.example.net:8080
#        forward           .example.com   .
#
#      A rule that uses a SOCKS 4 gateway for all destinations but no
#      HTTP parent looks like this:
#
#        forward-socks4   /               socks-gw.example.com:1080  .
#
#      To connect SOCKS5 proxy which requires username/password
#      authentication:
#
#        forward-socks5   /               user:pass@socks-gw.example.com:1080  .
#
#      To chain Privoxy and Tor, both running on the same system, you
#      would use something like:
#
#        forward-socks5t   /               127.0.0.1:9050 .
#
#      Note that if you got Tor through one of the bundles, you may
#      have to change the port from 9050 to 9150 (or even another
#      one). For details, please check the documentation on the Tor
#      website.
#
#      The public Tor network can't be used to reach your local
#      network, if you need to access local servers you therefore
#      might want to make some exceptions:
#
#        forward         192.168.*.*/     .
#        forward          10.*.*.*/       .
#        forward         127.*.*.*/       .
#
#      Unencrypted connections to systems in these address ranges
#      will be as (un)secure as the local network is, but the
#      alternative is that you can't reach the local network through
#      Privoxy at all. Of course this may actually be desired and
#      there is no reason to make these exceptions if you aren't sure
#      you need them.
#
#      If you also want to be able to reach servers in your local
#      network by using their names, you will need additional
#      exceptions that look like this:
#
#        forward           localhost/     .
#
#
#  5.3. forwarded-connect-retries
#  ===============================
#
#  Specifies:
#
#      How often Privoxy retries if a forwarded connection request
#      fails.
#
#  Type of value:
#
#      Number of retries.
#
#  Default value:
#
#      0
#
#  Effect if unset:
#
#      Connections forwarded through other proxies are treated like
#      direct connections and no retry attempts are made.
#
#  Notes:
#
#      forwarded-connect-retries is mainly interesting for socks4a
#      connections, where Privoxy can't detect why the connections
#      failed. The connection might have failed because of a DNS
#      timeout in which case a retry makes sense, but it might also
#      have failed because the server doesn't exist or isn't
#      reachable. In this case the retry will just delay the
#      appearance of Privoxy's error message.
#
#      Note that in the context of this option, forwarded
#      connections includes all connections that Privoxy forwards
#      through other proxies. This option is not limited to the HTTP
#      CONNECT method.
#
#      Only use this option, if you are getting lots of
#      forwarding-related error messages that go away when you try
#      again manually. Start with a small value and check Privoxy's
#      logfile from time to time, to see how many retries are usually
#      needed.
#
#  Example:
#
#      forwarded-connect-retries 1
#
forwarded-connect-retries  0
#
#  6. MISCELLANEOUS
#  =================
#
#  6.1. accept-intercepted-requests
#  =================================
#
#  Specifies:
#
#      Whether intercepted requests should be treated as valid.
#
#  Type of value:
#
#      0 or 1
#
#  Default value:
#
#      0
#
#  Effect if unset:
#
#      Only proxy requests are accepted, intercepted requests are
#      treated as invalid.
#
#  Notes:
#
#      If you don't trust your clients and want to force them to use
#      Privoxy, enable this option and configure your packet filter
#      to redirect outgoing HTTP connections into Privoxy.
#
#      Note that intercepting encrypted connections (HTTPS) isn't
#      supported.
#
#      Make sure that Privoxy's own requests aren't redirected as
#      well. Additionally take care that Privoxy can't intentionally
#      connect to itself, otherwise you could run into redirection
#      loops if Privoxy's listening port is reachable by the outside
#      or an attacker has access to the pages you visit.
#
#      If you are running Privoxy as intercepting proxy without being
#      able to intercept all client requests you may want to adjust
#      the CGI templates to make sure they don't reference content
#      from config.privoxy.org.
#
#  Example:
#
#      accept-intercepted-requests 1
#
accept-intercepted-requests 0
#
#  6.2. allow-cgi-request-crunching
#  =================================
#
#  Specifies:
#
#      Whether requests to Privoxy's CGI pages can be blocked or
#      redirected.
#
#  Type of value:
#
#      0 or 1
#
#  Default value:
#
#      0
#
#  Effect if unset:
#
#      Privoxy ignores block and redirect actions for its CGI pages.
#
#  Notes:
#
#      By default Privoxy ignores block or redirect actions for its
#      CGI pages. Intercepting these requests can be useful in
#      multi-user setups to implement fine-grained access control,
#      but it can also render the complete web interface useless and
#      make debugging problems painful if done without care.
#
#      Don't enable this option unless you're sure that you really
#      need it.
#
#  Example:
#
#      allow-cgi-request-crunching 1
#
allow-cgi-request-crunching 0
#
#  6.3. split-large-forms
#  =======================
#
#  Specifies:
#
#      Whether the CGI interface should stay compatible with broken
#      HTTP clients.
#
#  Type of value:
#
#      0 or 1
#
#  Default value:
#
#      0
#
#  Effect if unset:
#
#      The CGI form generate long GET URLs.
#
#  Notes:
#
#      Privoxy's CGI forms can lead to rather long URLs. This isn't a
#      problem as far as the HTTP standard is concerned, but it can
#      confuse clients with arbitrary URL length limitations.
#
#      Enabling split-large-forms causes Privoxy to divide big forms
#      into smaller ones to keep the URL length down. It makes
#      editing a lot less convenient and you can no longer submit all
#      changes at once, but at least it works around this browser
#      bug.
#
#      If you don't notice any editing problems, there is no reason
#      to enable this option, but if one of the submit buttons
#      appears to be broken, you should give it a try.
#
#  Example:
#
#      split-large-forms 1
#
split-large-forms 0
#
#  6.4. keep-alive-timeout
#  ========================
#
#  Specifies:
#
#      Number of seconds after which an open connection will no
#      longer be reused.
#
#  Type of value:
#
#      Time in seconds.
#
#  Default value:
#
#      None
#
#  Effect if unset:
#
#      Connections are not kept alive.
#
#  Notes:
#
#      This option allows clients to keep the connection to Privoxy
#      alive. If the server supports it, Privoxy will keep the
#      connection to the server alive as well. Under certain
#      circumstances this may result in speed-ups.
#
#      By default, Privoxy will close the connection to the server if
#      the client connection gets closed, or if the specified timeout
#      has been reached without a new request coming in. This
#      behaviour can be changed with the connection-sharing option.
#
#      This option has no effect if Privoxy has been compiled without
#      keep-alive support.
#
#      Note that a timeout of five seconds as used in the default
#      configuration file significantly decreases the number of
#      connections that will be reused. The value is used because
#      some browsers limit the number of connections they open to a
#      single host and apply the same limit to proxies. This can
#      result in a single website "grabbing" all the connections the
#      browser allows, which means connections to other websites
#      can't be opened until the connections currently in use time
#      out.
#
#      Several users have reported this as a Privoxy bug, so the
#      default value has been reduced. Consider increasing it to 300
#      seconds or even more if you think your browser can handle it.
#      If your browser appears to be hanging, it probably can't.
#
#  Example:
#
#      keep-alive-timeout 300
#
keep-alive-timeout 5
#
#  6.5. tolerate-pipelining
#  =========================
#
#  Specifies:
#
#      Whether or not pipelined requests should be served.
#
#  Type of value:
#
#      0 or 1.
#
#  Default value:
#
#      None
#
#  Effect if unset:
#
#      If Privoxy receives more than one request at once, it
#      terminates the client connection after serving the first one.
#
#  Notes:
#
#      Privoxy currently doesn't pipeline outgoing requests, thus
#      allowing pipelining on the client connection is not guaranteed
#      to improve the performance.
#
#      By default Privoxy tries to discourage clients from pipelining
#      by discarding aggressively pipelined requests, which forces
#      the client to resend them through a new connection.
#
#      This option lets Privoxy tolerate pipelining. Whether or not
#      that improves performance mainly depends on the client
#      configuration.
#
#      If you are seeing problems with pages not properly loading,
#      disabling this option could work around the problem.
#
#  Example:
#
#      tolerate-pipelining 1
#
tolerate-pipelining 1
#
#  6.6. default-server-timeout
#  ============================
#
#  Specifies:
#
#      Assumed server-side keep-alive timeout if not specified by the
#      server.
#
#  Type of value:
#
#      Time in seconds.
#
#  Default value:
#
#      None
#
#  Effect if unset:
#
#      Connections for which the server didn't specify the keep-alive
#      timeout are not reused.
#
#  Notes:
#
#      Enabling this option significantly increases the number of
#      connections that are reused, provided the keep-alive-timeout
#      option is also enabled.
#
#      While it also increases the number of connections problems
#      when Privoxy tries to reuse a connection that already has been
#      closed on the server side, or is closed while Privoxy is
#      trying to reuse it, this should only be a problem if it
#      happens for the first request sent by the client. If it
#      happens for requests on reused client connections, Privoxy
#      will simply close the connection and the client is supposed to
#      retry the request without bothering the user.
#
#      Enabling this option is therefore only recommended if the
#      connection-sharing option is disabled.
#
#      It is an error to specify a value larger than the
#      keep-alive-timeout value.
#
#      This option has no effect if Privoxy has been compiled without
#      keep-alive support.
#
#  Example:
#
#      default-server-timeout 60
#
#default-server-timeout 5
#
#  6.7. connection-sharing
#  ========================
#
#  Specifies:
#
#      Whether or not outgoing connections that have been kept alive
#      should be shared between different incoming connections.
#
#  Type of value:
#
#      0 or 1
#
#  Default value:
#
#      None
#
#  Effect if unset:
#
#      Connections are not shared.
#
#  Notes:
#
#      This option has no effect if Privoxy has been compiled without
#      keep-alive support, or if it's disabled.
#
#  Notes:
#
#      Note that reusing connections doesn't necessary cause
#      speedups. There are also a few privacy implications you should
#      be aware of.
#
#      If this option is enabled, outgoing connections are shared
#      between clients (if there are more than one) and closing the
#      browser that initiated the outgoing connection does not affect
#      the connection between Privoxy and the server unless the
#      client's request hasn't been completed yet.
#
#      If the outgoing connection is idle, it will not be closed
#      until either Privoxy's or the server's timeout is reached.
#      While it's open, the server knows that the system running
#      Privoxy is still there.
#
#      If there are more than one client (maybe even belonging to
#      multiple users), they will be able to reuse each others
#      connections. This is potentially dangerous in case of
#      authentication schemes like NTLM where only the connection is
#      authenticated, instead of requiring authentication for each
#      request.
#
#      If there is only a single client, and if said client can keep
#      connections alive on its own, enabling this option has next to
#      no effect. If the client doesn't support connection
#      keep-alive, enabling this option may make sense as it allows
#      Privoxy to keep outgoing connections alive even if the client
#      itself doesn't support it.
#
#      You should also be aware that enabling this option increases
#      the likelihood of getting the "No server or forwarder data"
#      error message, especially if you are using a slow connection
#      to the Internet.
#
#      This option should only be used by experienced users who
#      understand the risks and can weight them against the benefits.
#
#  Example:
#
#      connection-sharing 1
#
#connection-sharing 1
#
#  6.8. socket-timeout
#  ====================
#
#  Specifies:
#
#      Number of seconds after which a socket times out if no data is
#      received.
#
#  Type of value:
#
#      Time in seconds.
#
#  Default value:
#
#      None
#
#  Effect if unset:
#
#      A default value of 300 seconds is used.
#
#  Notes:
#
#      The default is quite high and you probably want to reduce it.
#      If you aren't using an occasionally slow proxy like Tor,
#      reducing it to a few seconds should be fine.
#
#      +-----------------------------------------------------+
#      |                       Warning                       |
#      |-----------------------------------------------------|
#      |When a TLS library is being used to read or write    |
#      |data from a socket with https-inspection enabled the |
#      |socket-timeout currently isn't applied and the       |
#      |timeout used depends on the library (which may not   |
#      |even use a timeout).                                 |
#      +-----------------------------------------------------+
#  Example:
#
#      socket-timeout 300
#
socket-timeout 300
#
#  6.9. max-client-connections
#  ============================
#
#  Specifies:
#
#      Maximum number of client connections that will be served.
#
#  Type of value:
#
#      Positive number.
#
#  Default value:
#
#      128
#
#  Notes:
#
#      Connections are served until a resource limit is reached.
#
#      Privoxy creates one thread (or process) for every incoming
#      client connection that isn't rejected based on the access
#      control settings.
#
#      If the system is powerful enough, Privoxy can theoretically
#      deal with several hundred (or thousand) connections at the
#      same time, but some operating systems enforce resource limits
#      by shutting down offending processes and their default limits
#      may be below the ones Privoxy would require under heavy load.
#
#      Configuring Privoxy to enforce a connection limit below the
#      thread or process limit used by the operating system makes
#      sure this doesn't happen. Simply increasing the operating
#      system's limit would work too, but if Privoxy isn't the only
#      application running on the system, you may actually want to
#      limit the resources used by Privoxy.
#
#      If Privoxy is only used by a single trusted user, limiting the
#      number of client connections is probably unnecessary. If there
#      are multiple possibly untrusted users you probably still want
#      to additionally use a packet filter to limit the maximal
#      number of incoming connections per client. Otherwise a
#      malicious user could intentionally create a high number of
#      connections to prevent other users from using Privoxy.
#
#      Obviously using this option only makes sense if you choose a
#      limit below the one enforced by the operating system.
#
#      One most POSIX-compliant systems Privoxy can't properly deal
#      with more than FD_SETSIZE file descriptors if Privoxy has been
#      configured to use select() and has to reject connections if
#      the limit is reached. When using select() this limit therefore
#      can't be increased without recompiling Privoxy with a
#      different FD_SETSIZE limit unless Privoxy is running on
#      Windows with _WIN32 defined.
#
#      When Privoxy has been configured to use poll() the FD_SETSIZE
#      limit does not apply.
#
#  Example:
#
#      max-client-connections 256
#
#max-client-connections 256
#
#  6.10. listen-backlog
#  =====================
#
#  Specifies:
#
#      Connection queue length requested from the operating system.
#
#  Type of value:
#
#      Number.
#
#  Default value:
#
#      128
#
#  Effect if unset:
#
#      A connection queue length of 128 is requested from the
#      operating system.
#
#  Notes:
#
#      Under high load incoming connection may queue up before
#      Privoxy gets around to serve them. The queue length is limited
#      by the operating system. Once the queue is full, additional
#      connections are dropped before Privoxy can accept and serve
#      them.
#
#      Increasing the queue length allows Privoxy to accept more
#      incoming connections that arrive roughly at the same time.
#
#      Note that Privoxy can only request a certain queue length,
#      whether or not the requested length is actually used depends
#      on the operating system which may use a different length
#      instead.
#
#      On many operating systems a limit of -1 can be specified to
#      instruct the operating system to use the maximum queue length
#      allowed. Check the listen man page to see if your platform
#      allows this.
#
#      On some platforms you can use "netstat -Lan -p tcp" to see the
#      effective queue length.
#
#      Effectively using a value above 128 usually requires changing
#      the system configuration as well. On FreeBSD-based system the
#      limit is controlled by the kern.ipc.soacceptqueue sysctl.
#
#  Example:
#
#      listen-backlog 4096
#
#listen-backlog -1
#
#  6.11. enable-accept-filter
#  ===========================
#
#  Specifies:
#
#      Whether or not Privoxy should use an accept filter
#
#  Type of value:
#
#      0 or 1
#
#  Default value:
#
#      0
#
#  Effect if unset:
#
#      No accept filter is enabled.
#
#  Notes:
#
#      Accept filters reduce the number of context switches by not
#      passing sockets for new connections to Privoxy until a
#      complete HTTP request is available.
#
#      As a result, Privoxy can process the whole request right away
#      without having to wait for additional data first.
#
#      For this option to work, Privoxy has to be compiled with
#      FEATURE_ACCEPT_FILTER and the operating system has to support
#      it (which may require loading a kernel module).
#
#      Currently accept filters are only supported on FreeBSD-based
#      systems. Check the accf_http(9) man page to learn how to
#      enable the support in the operating system.
#
#  Example:
#
#      enable-accept-filter 1
#
#enable-accept-filter 1
#
#  6.12. handle-as-empty-doc-returns-ok
#  =====================================
#
#  Specifies:
#
#      The status code Privoxy returns for pages blocked with
#      +handle-as-empty-document.
#
#  Type of value:
#
#      0 or 1
#
#  Default value:
#
#      0
#
#  Effect if unset:
#
#      Privoxy returns a status 403(forbidden) for all blocked pages.
#
#  Effect if set:
#
#      Privoxy returns a status 200(OK) for pages blocked with
#      +handle-as-empty-document and a status 403(Forbidden) for all
#      other blocked pages.
#
#  Notes:
#
#      This directive was added as a work-around for Firefox bug
#      492459: Websites are no longer rendered if SSL requests for
#      JavaScripts are blocked by a proxy.
#      (https://bugzilla.mozilla.org/show_bug.cgi?id=492459), the bug
#      has been fixed for quite some time, but this directive is also
#      useful to make it harder for websites to detect whether or not
#      resources are being blocked.
#
#handle-as-empty-doc-returns-ok 1
#
#  6.13. enable-compression
#  =========================
#
#  Specifies:
#
#      Whether or not buffered content is compressed before delivery.
#
#  Type of value:
#
#      0 or 1
#
#  Default value:
#
#      0
#
#  Effect if unset:
#
#      Privoxy does not compress buffered content.
#
#  Effect if set:
#
#      Privoxy compresses buffered content before delivering it to
#      the client, provided the client supports it.
#
#  Notes:
#
#      This directive is only supported if Privoxy has been compiled
#      with FEATURE_COMPRESSION, which should not to be confused with
#      FEATURE_ZLIB.
#
#      Compressing buffered content is mainly useful if Privoxy and
#      the client are running on different systems. If they are
#      running on the same system, enabling compression is likely to
#      slow things down. If you didn't measure otherwise, you should
#      assume that it does and keep this option disabled.
#
#      Privoxy will not compress buffered content below a certain
#      length.
#
#enable-compression 1
#
#  6.14. compression-level
#  ========================
#
#  Specifies:
#
#      The compression level that is passed to the zlib library when
#      compressing buffered content.
#
#  Type of value:
#
#      Positive number ranging from 0 to 9.
#
#  Default value:
#
#      1
#
#  Notes:
#
#      Compressing the data more takes usually longer than
#      compressing it less or not compressing it at all. Which level
#      is best depends on the connection between Privoxy and the
#      client. If you can't be bothered to benchmark it for yourself,
#      you should stick with the default and keep compression
#      disabled.
#
#      If compression is disabled, the compression level is
#      irrelevant.
#
#  Examples:
#
#        # Best speed (compared to the other levels)
#        compression-level 1
#
#        # Best compression
#        compression-level 9
#
#        # No compression. Only useful for testing as the added header
#        # slightly increases the amount of data that has to be sent.
#        # If your benchmark shows that using this compression level
#        # is superior to using no compression at all, the benchmark
#        # is likely to be flawed.
#        compression-level 0
#
#compression-level 1
#
#  6.15. client-header-order
#  ==========================
#
#  Specifies:
#
#      The order in which client headers are sorted before forwarding
#      them.
#
#  Type of value:
#
#      Client header names delimited by spaces or tabs
#
#  Default value:
#
#      None
#
#  Notes:
#
#      By default Privoxy leaves the client headers in the order they
#      were sent by the client. Headers are modified in-place, new
#      headers are added at the end of the already existing headers.
#
#      The header order can be used to fingerprint client requests
#      independently of other headers like the User-Agent.
#
#      This directive allows to sort the headers differently to
#      better mimic a different User-Agent. Client headers will be
#      emitted in the order given, headers whose name isn't
#      explicitly specified are added at the end.
#
#      Note that sorting headers in an uncommon way will make
#      fingerprinting actually easier. Encrypted headers are not
#      affected by this directive unless https-inspection is enabled.
#
#client-header-order Host \
#   User-Agent \
#   Accept \
#   Accept-Language \
#   Accept-Encoding \
#   Proxy-Connection \
#   Referer \
#   Cookie \
#   DNT \
#   Connection \
#   Pragma \
#   Upgrade-Insecure-Requests \
#   If-Modified-Since \
#   Cache-Control \
#   Content-Length \
#   Origin \
#   Content-Type
#
#  6.16. client-specific-tag
#  ==========================
#
#  Specifies:
#
#      The name of a tag that will always be set for clients that
#      requested it through the webinterface.
#
#  Type of value:
#
#      Tag name followed by a description that will be shown in the
#      webinterface
#
#  Default value:
#
#      None
#
#  Notes:
#
#      Client-specific tags allow Privoxy admins to create different
#      profiles and let the users chose which one they want without
#      impacting other users.
#
#      One use case is allowing users to circumvent certain blocks
#      without having to allow them to circumvent all blocks. This is
#      not possible with the enable-remote-toggle feature because it
#      would bluntly disable all blocks for all users and also affect
#      other actions like filters. It also is set globally which
#      renders it useless in most multi-user setups.
#
#      After a client-specific tag has been defined with the
#      client-specific-tag directive, action sections can be
#      activated based on the tag by using a CLIENT-TAG pattern. The
#      CLIENT-TAG pattern is evaluated at the same priority as URL
#      patterns, as a result the last matching pattern wins. Tags
#      that are created based on client or server headers are
#      evaluated later on and can overrule CLIENT-TAG and URL
#      patterns!
#
#      The tag is set for all requests that come from clients that
#      requested it to be set. Note that "clients" are differentiated
#      by IP address, if the IP address changes the tag has to be
#      requested again.
#
#      Clients can request tags to be set by using the CGI interface
#      http://config.privoxy.org/client-tags. The specific tag
#      description is only used on the web page and should be phrased
#      in away that the user understands the effect of the tag.
#
#  Examples:
#
#          # Define a couple of tags, the described effect requires action sections
#          # that are enabled based on CLIENT-TAG patterns.
#          client-specific-tag circumvent-blocks Overrule blocks but do not affect other actions
#          client-specific-tag disable-content-filters Disable content-filters but do not affect other actions
#          client-specific-tag overrule-redirects Overrule redirect sections
#          client-specific-tag allow-cookies Do not crunch cookies in either direction
#          client-specific-tag change-tor-socks-port Change forward-socks5 settings to use a different Tor socks port (and circuits)
#          client-specific-tag no-https-inspection Disable HTTPS inspection
#          client-specific-tag no-tls-verification Don't verify certificates when http-inspection is enabled
#
#
#  6.17. client-tag-lifetime
#  ==========================
#
#  Specifies:
#
#      How long a temporarily enabled tag remains enabled.
#
#  Type of value:
#
#      Time in seconds.
#
#  Default value:
#
#      60
#
#  Notes:
#
#      In case of some tags users may not want to enable them
#      permanently, but only for a short amount of time, for example
#      to circumvent a block that is the result of an overly-broad
#      URL pattern.
#
#      The CGI interface http://config.privoxy.org/client-tags
#      therefore provides a "enable this tag temporarily" option. If
#      it is used, the tag will be set until the client-tag-lifetime
#      is over.
#
#  Example:
#
#            # Increase the time to life for temporarily enabled tags to 3 minutes
#            client-tag-lifetime 180
#
#
#  6.18. trust-x-forwarded-for
#  ============================
#
#  Specifies:
#
#      Whether or not Privoxy should use IP addresses specified with
#      the X-Forwarded-For header
#
#  Type of value:
#
#      0 or one
#
#  Default value:
#
#      0
#
#  Notes:
#
#      If clients reach Privoxy through another proxy, for example a
#      load balancer, Privoxy can't tell the client's IP address from
#      the connection. If multiple clients use the same proxy, they
#      will share the same client tag settings which is usually not
#      desired.
#
#      This option lets Privoxy use the X-Forwarded-For header value
#      as client IP address. If the proxy sets the header, multiple
#      clients using the same proxy do not share the same client tag
#      settings.
#
#      This option should only be enabled if Privoxy can only be
#      reached through a proxy and if the proxy can be trusted to set
#      the header correctly. It is recommended that ACL are used to
#      make sure only trusted systems can reach Privoxy.
#
#      If access to Privoxy isn't limited to trusted systems, this
#      option would allow malicious clients to change the client tags
#      for other clients or increase Privoxy's memory requirements by
#      registering lots of client tag settings for clients that don't
#      exist.
#
#  Example:
#
#            # Allow systems that can reach Privoxy to provide the client
#            # IP address with a X-Forwarded-For header.
#            trust-x-forwarded-for 1
#
#
#  6.19. receive-buffer-size
#  ==========================
#
#  Specifies:
#
#      The size of the buffer Privoxy uses to receive data from the
#      server.
#
#  Type of value:
#
#      Size in bytes
#
#  Default value:
#
#      5000
#
#  Notes:
#
#      Increasing the receive-buffer-size increases Privoxy's memory
#      usage but can lower the number of context switches and thereby
#      reduce the cpu usage and potentially increase the throughput.
#
#      This is mostly relevant for fast network connections and large
#      downloads that don't require filtering.
#
#      Reducing the buffer size reduces the amount of memory Privoxy
#      needs to handle the request but increases the number of
#      systemcalls and may reduce the throughput.
#
#      A dtrace command like: "sudo dtrace -n 'syscall::read:return /
#      execname == "privoxy"/ { @[execname] = llquantize(arg0, 10, 0,
#      5, 20); @m = max(arg0)}'" can be used to properly tune the
#      receive-buffer-size. On systems without dtrace, strace or
#      truss may be used as less convenient alternatives.
#
#      If the buffer is too large it will increase Privoxy's memory
#      footprint without any benefit. As the memory is (currently)
#      cleared before using it, a buffer that is too large can
#      actually reduce the throughput.
#
#  Example:
#
#            # Increase the receive buffer size
#            receive-buffer-size 32768
#
#
#  7. HTTPS INSPECTION (EXPERIMENTAL)
#  ===================================
#
#  HTTPS inspection allows to filter encrypted requests and
#  responses. This is only supported when Privoxy has been built with
#  FEATURE_HTTPS_INSPECTION. If you aren't sure if your version
#  supports it, have a look at http://config.privoxy.org/show-status.
#
#
#  7.1. ca-directory
#  ==================
#
#  Specifies:
#
#      Directory with the CA key, the CA certificate and the trusted
#      CAs file.
#
#  Type of value:
#
#      Text
#
#  Default value:
#
#      Empty string
#
#  Effect if unset:
#
#      Default value is used.
#
#  Notes:
#
#      This directive specifies the directory where the CA key, the
#      CA certificate and the trusted CAs file are located.
#
#      The permissions should only let Privoxy and the Privoxy admin
#      access the directory.
#
#  Example:
#
#      ca-directory /usr/local/etc/privoxy/CA
#
#ca-directory /etc/privoxy/CA
#
#  7.2. ca-cert-file
#  ==================
#
#  Specifies:
#
#      The CA certificate file in ".crt" format.
#
#  Type of value:
#
#      Text
#
#  Default value:
#
#      cacert.crt
#
#  Effect if unset:
#
#      Default value is used.
#
#  Notes:
#
#      This directive specifies the name of the CA certificate file
#      in ".crt" format.
#
#      The file is used by Privoxy to generate website certificates
#      when https inspection is enabled with the https-inspection
#      action.
#
#      Privoxy clients should import the certificate so that they can
#      validate the generated certificates.
#
#      The file can be generated with: openssl req -new -x509
#      -extensions v3_ca -keyout cakey.pem -out cacert.crt -days 3650
#
#  Example:
#
#      ca-cert-file root.crt
#
#ca-cert-file cacert.crt
#
#  7.3. ca-key-file
#  =================
#
#  Specifies:
#
#      The CA key file in ".pem" format.
#
#  Type of value:
#
#      Text
#
#  Default value:
#
#      cacert.pem
#
#  Effect if unset:
#
#      Default value is used.
#
#  Notes:
#
#      This directive specifies the name of the CA key file in ".pem"
#      format. The ca-cert-file section contains a command to
#      generate it.
#
#      The CA key is used by Privoxy to sign generated certificates.
#
#      Access to the key should be limited to Privoxy.
#
#  Example:
#
#      ca-key-file cakey.pem
#
#ca-key-file cakey.pem
#
#  7.4. ca-password
#  =================
#
#  Specifies:
#
#      The password for the CA keyfile.
#
#  Type of value:
#
#      Text
#
#  Default value:
#
#      Empty string
#
#  Effect if unset:
#
#      Default value is used.
#
#  Notes:
#
#      This directive specifies the password for the CA keyfile that
#      is used when Privoxy generates certificates for intercepted
#      requests.
#
#      +-----------------------------------------------------+
#      |                       Warning                       |
#      |-----------------------------------------------------|
#      |Note that the password is shown on the CGI page so   |
#      |don't reuse an important one.                        |
#      |                                                     |
#      |If disclosure of the password is a compliance issue  |
#      |consider blocking the relevant CGI requests after    |
#      |enabling the enforce-blocks and                      |
#      |allow-cgi-request-crunching.                         |
#      +-----------------------------------------------------+
#  Example:
#
#      ca-password blafasel
#
#ca-password swordfish
#
#  7.5. certificate-directory
#  ===========================
#
#  Specifies:
#
#      Directory to save generated keys and certificates.
#
#  Type of value:
#
#      Text
#
#  Default value:
#
#      ./certs
#
#  Effect if unset:
#
#      Default value is used.
#
#  Notes:
#
#      This directive specifies the directory where generated TLS/SSL
#      keys and certificates are saved when https inspection is
#      enabled with the https-inspection action.
#
#      The keys and certificates currently have to be deleted
#      manually when changing the ca-cert-file and the ca-cert-key.
#
#      The permissions should only let Privoxy and the Privoxy admin
#      access the directory.
#
#      +-----------------------------------------------------+
#      |                       Warning                       |
#      |-----------------------------------------------------|
#      |Privoxy currently does not garbage-collect obsolete  |
#      |keys and certificates and does not keep track of how |
#      |may keys and certificates exist.                     |
#      |                                                     |
#      |Privoxy admins should monitor the size of the        |
#      |directory and/or make sure there is sufficient space |
#      |available. A cron job to limit the number of keys and|
#      |certificates to a certain number may be worth        |
#      |considering.                                         |
#      +-----------------------------------------------------+
#  Example:
#
#      certificate-directory /usr/local/var/privoxy/certs
#
#certificate-directory /var/lib/privoxy/certs
#
#  7.6. cipher-list
#  =================
#
#  Specifies:
#
#      A list of ciphers to use in TLS handshakes
#
#  Type of value:
#
#      Text
#
#  Default value:
#
#      None
#
#  Effect if unset:
#
#      A default value is inherited from the TLS library.
#
#  Notes:
#
#      This directive allows to specify a non-default list of ciphers
#      to use in TLS handshakes with clients and servers.
#
#      Ciphers are separated by colons. Which ciphers are supported
#      depends on the TLS library. When using OpenSSL, unsupported
#      ciphers are skipped. When using MbedTLS they are rejected.
#
#      +-----------------------------------------------------+
#      |                       Warning                       |
#      |-----------------------------------------------------|
#      |Specifying an unusual cipher list makes              |
#      |fingerprinting easier. Note that the default list    |
#      |provided by the TLS library may be unusual when      |
#      |compared to the one used by modern browsers as well. |
#      +-----------------------------------------------------+
#  Examples:
#
#          # Explicitly set a couple of ciphers with names used by MbedTLS
#        cipher-list cipher-list TLS-ECDHE-RSA-WITH-CHACHA20-POLY1305-SHA256:\
#        TLS-ECDHE-ECDSA-WITH-CHACHA20-POLY1305-SHA256:\
#        TLS-DHE-RSA-WITH-CHACHA20-POLY1305-SHA256:\
#        TLS-ECDHE-ECDSA-WITH-AES-128-GCM-SHA256:\
#        TLS-ECDHE-ECDSA-WITH-AES-256-GCM-SHA384:\
#        TLS-ECDHE-ECDSA-WITH-AES-256-CCM:\
#        TLS-ECDHE-ECDSA-WITH-AES-256-CCM-8:\
#        TLS-ECDHE-ECDSA-WITH-AES-128-CCM:\
#        TLS-ECDHE-ECDSA-WITH-AES-128-CCM-8:\
#        TLS-ECDHE-ECDSA-WITH-CAMELLIA-128-GCM-SHA256:\
#        TLS-ECDHE-ECDSA-WITH-CAMELLIA-256-GCM-SHA384:\
#        TLS-ECDHE-RSA-WITH-AES-128-GCM-SHA256:\
#        TLS-ECDHE-RSA-WITH-AES-256-GCM-SHA384:\
#        TLS-ECDHE-RSA-WITH-CAMELLIA-128-GCM-SHA256:\
#        TLS-ECDHE-RSA-WITH-CAMELLIA-256-GCM-SHA384:\
#        TLS-DHE-RSA-WITH-AES-256-GCM-SHA384:\
#        TLS-DHE-RSA-WITH-AES-128-GCM-SHA256:\
#        TLS-DHE-RSA-WITH-AES-256-CCM:\
#        TLS-DHE-RSA-WITH-AES-256-CCM-8:\
#        TLS-DHE-RSA-WITH-AES-128-CCM:\
#        TLS-DHE-RSA-WITH-AES-128-CCM-8:\
#        TLS-DHE-RSA-WITH-CAMELLIA-128-GCM-SHA256:\
#        TLS-DHE-RSA-WITH-CAMELLIA-256-GCM-SHA384:\
#        TLS-ECDH-RSA-WITH-AES-128-GCM-SHA256:\
#        TLS-ECDH-RSA-WITH-AES-256-GCM-SHA384:\
#        TLS-ECDH-RSA-WITH-CAMELLIA-128-GCM-SHA256:\
#        TLS-ECDH-RSA-WITH-CAMELLIA-256-GCM-SHA384:\
#        TLS-ECDH-ECDSA-WITH-AES-128-GCM-SHA256:\
#        TLS-ECDH-ECDSA-WITH-AES-256-GCM-SHA384:\
#        TLS-ECDH-ECDSA-WITH-CAMELLIA-128-GCM-SHA256:\
#        TLS-ECDH-ECDSA-WITH-CAMELLIA-256-GCM-SHA384
#
#          # Explicitly set a couple of ciphers with names used by OpenSSL
#        cipher-list ECDHE-RSA-AES256-GCM-SHA384:\
#        ECDHE-ECDSA-AES256-GCM-SHA384:\
#        DH-DSS-AES256-GCM-SHA384:\
#        DHE-DSS-AES256-GCM-SHA384:\
#        DH-RSA-AES256-GCM-SHA384:\
#        DHE-RSA-AES256-GCM-SHA384:\
#        ECDH-RSA-AES256-GCM-SHA384:\
#        ECDH-ECDSA-AES256-GCM-SHA384:\
#        ECDHE-RSA-AES128-GCM-SHA256:\
#        ECDHE-ECDSA-AES128-GCM-SHA256:\
#        DH-DSS-AES128-GCM-SHA256:\
#        DHE-DSS-AES128-GCM-SHA256:\
#        DH-RSA-AES128-GCM-SHA256:\
#        DHE-RSA-AES128-GCM-SHA256:\
#        ECDH-RSA-AES128-GCM-SHA256:\
#        ECDH-ECDSA-AES128-GCM-SHA256:\
#        ECDHE-RSA-AES256-GCM-SHA384:\
#        AES128-SHA
#
#          # Use keywords instead of explicitly naming the ciphers (Does not work with MbedTLS)
#        cipher-list ALL:!EXPORT:!EXPORT40:!EXPORT56:!aNULL:!LOW:!RC4:@STRENGTH
#
#
#  7.7. trusted-cas-file
#  ======================
#
#  Specifies:
#
#      The trusted CAs file in ".pem" format.
#
#  Type of value:
#
#      File name relative to ca-directory
#
#  Default value:
#
#      trustedCAs.pem
#
#  Effect if unset:
#
#      Default value is used.
#
#  Notes:
#
#      This directive specifies the trusted CAs file that is used
#      when validating certificates for intercepted TLS/SSL requests.
#
#      An example file can be downloaded from https://curl.se/ca/cacert.pem.
#      If you want to create the file yourself, please
#      see: https://curl.se/docs/caextract.html.
#
#  Example:
#
#      trusted-cas-file trusted_cas_file.pem
#
#trusted-cas-file /etc/ssl/certs/ca-certificates.crt
#
#  8. WINDOWS GUI OPTIONS
#  =======================
#
#  Privoxy has a number of options specific to the Windows GUI
#  interface:
#
#
#  If "activity-animation" is set to 1, the Privoxy icon will animate
#  when "Privoxy" is active. To turn off, set to 0.
#
#activity-animation   1
#
#  If "log-messages" is set to 1, Privoxy copies log messages to the
#  console window. The log detail depends on the debug directive.
#
#log-messages   1
#
#  If "log-buffer-size" is set to 1, the size of the log buffer, i.e.
#  the amount of memory used for the log messages displayed in the
#  console window, will be limited to "log-max-lines" (see below).
#
#  Warning: Setting this to 0 will result in the buffer to grow
#  infinitely and eat up all your memory!
#
#log-buffer-size 1
#
#  log-max-lines is the maximum number of lines held in the log
#  buffer. See above.
#
#log-max-lines 200
#
#  If "log-highlight-messages" is set to 1, Privoxy will highlight
#  portions of the log messages with a bold-faced font:
#
#log-highlight-messages 1
#
#  The font used in the console window:
#
#log-font-name Comic Sans MS
#
#  Font size used in the console window:
#
#log-font-size 8
#
#  "show-on-task-bar" controls whether or not Privoxy will appear as
#  a button on the Task bar when minimized:
#
#show-on-task-bar 0
#
#  If "close-button-minimizes" is set to 1, the Windows close button
#  will minimize Privoxy instead of closing the program (close with
#  the exit option on the File menu).
#
#close-button-minimizes 1
#
#  The "hide-console" option is specific to the MS-Win console
#  version of Privoxy. If this option is used, Privoxy will
#  disconnect from and hide the command console.
#
#hide-console
# " >> /etc/privoxy/config
#Installed privoxy /etc/privoxy/config file
echo "Installed Privoxy on port $privoxyproxyport"
sleep 0.5
echo "ading ufw rules"
sudo ufw allow $torproxyport
sudo ufw allow $privoxyproxyport
sudo ufw allow $ssh_port
#Pihole DNS port
sudo ufw allow 53
#Restarting all services
echo "Restarting Tor, Pihole, UFW, and Privoxy"
sudo service tor restart
sudo service privoxy restart
sudo pihole -up
sudo ufw enable -y
sudo ufw reload
clear
#Creating startup script 1/2
echo "Creating start up script to keep this server up to date."
sleep 0.5
sudo touch /etc/systemd/system/updateandupgradeandupdatedb.service
echo "[Unit]
Description=update&upgrade&updatedb

[Service]
Type=simple
ExecStart=/etc/updateblacktel.sh

[Install]
WantedBy=multi-user.target" >> /etc/systemd/system/updateandupgradeandupdatedb.service
#Creating startup script 2/2
sudo touch /etc/updateblacktel.sh
echo "#!/bin/bash
sudo apt-get update
sudo apt-get upgrade -y
sudo updatedb" >> /etc/updateblacktel.sh 
#Enabling the new startup script
sudo systemctl enable updateandupgradeandupdatedb.service
