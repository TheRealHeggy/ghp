#!bin/bash
while true; do
read -p "make sure all forensics have been completed. do you want to proceed with the script? (y/n) " yn
case $yn in
  [yY] ) echo proceeding;
    break;;
  [nN] ) echo exiting;
    break;;
  * ) echo invalid response;;
esac
done
#PWDthi=$(pwd)
#if [ ! -d $PWDthi/referenceFiles ]; then
#    echo "cd into script directory pwease"
#    exit
#fi
#STILL TRYING TO FIX THIS???

if [ "$EUID" -ne 0 ] ;
    then echo "run this as the root!" #use sudo bash here (so sudo bash script.sh)
    exit
fi

sudo apt-get install ufw -y >> /dev/null 2>&1
(ufw enable  >> Firewall.txt; yes | ufw reset  >> Firewall.txt; ufw enable  >> Firewall.txt; ufw allow http; ufw allow https; ufw deny 23; ufw deny 515; ufw deny 2049; ufw deny 111; ufw logging high >> Firewall.txt; echo "" >> Firewall.txt) &
echo Working on Firewall! owo
#disable ufw by typing "sudo ufw disable"
#EXPLANATIONS:
  #allow http = allows http on the firewall
  #allow https = allows https while on the firewall
  #deny 23 = denies port 23
  #deny 515 = denies port 515
  #deny 2049 = denies port 2049
  #deny 111 = denies port 111
  #logging = logs incoming/outgoing requests
  #the & allows the section to run while the rest of the script works 

/usr/lib/lightdm/lightdm-set-defaults -1 false
#sets lightdm to false
echo allow-guest=false >> /etc/lightdm/lightdm.conf
#sets allow-guest to false
printf "[SeatDefaults]\nautologin-guest=false\nautologin-user=none\nautologin-user-timeout=0\nautologin-session=lightdm-autologin\nallow-guest=false\ngreeter-hide-users=true" > /etc/lightdm/lightdm.conf
echo completed guest accounts <3
#prevents guest users from entering the computer

sed -i 's/PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config
service sshd restart
echo root login doesnt work?
#prevents root login

crontab -r
cd /etc/
/bin/rm -f cron.deny at.deny
echo root >cron.allow
echo root >at.allow
/bin/chown root:root cron.allow at.allow
/bin/chmod 644 cron.allow at.allow
echo finished crontab permissions!
#makes sure cron permissions are set correctly for users
#make sure to check crontab! could include important commands

apt-get install -y chkrootkit clamav rkhunter apparmor apparmor-profiles
cont
sudo freshclam
sudo clamscan -i -r -remove=yes 
echo finished installing important application
#installs default apps needed to look for issues
    #clam av should scan for malware
    #rkhunter and chkrootkit looks for rootkits
    #apparmor restricts admin powers

kill $(sudo netstat -tulnp | grep apache ftp telnet | awk '{print $2}' )


find / -name "*.tiff" -type f -delete 
find / -name "*.tif" -type f -delete 
find / -name "*.gif" -type f -delete 
find / -name "*.jpeg" -type f -delete 
find / -name "*.jpg" -type f -delete 
find / -name "*.jpe" -type f -delete 
find / -name "*.png" -type f -delete 
find / -name "*.rgb" -type f -delete 
find / -name "*.mpeg" -type f -delete 
find / -name "*.mpg" -type f -delete 
find / -name "*.mov" -type f -delete 
find / -name "*.wax" -type f -delete 
find / -name "*.wmv" -type f -delete 
find / -name "*.mov" -type f -delete 
find / -name "*.mp4" -type f -delete 
find / -name "*.avi" -type f -delete 
find / -name "*.mp3" -type f -delete 
find / -name "*.mp2" -type f -delete 
find / -name "*.wav" -type f -delete 
find / -name "*.ogg" -type f -delete 
d / && ls -laR 2> /dev/null | grep rwxrwxrwx | grep -v "lrwx" &> /tmp/777s
echo deleted banned files!
cont
#should ban every single banned file that isn't supposed to be on the computer (MAKE SURE YOU CHECK THAT ALL FILES THAT SHOULDNT BE THERE ARENT THERE)

echo please print out every user that is NOT THE OWNER OF THE COMPUTER with a space between
read -a users
for ((i=0; i<${#users[@]}; i++))
do
  echo "wanna delete ${users[${i}]}? y/n"
  read yn1
  if [ "$yn1" == "y" ]
  then
    userdel -r ${users[${i}]}
    echo "deleted ${users[${i}]}"
  else
    echo "make ${users[${i}]} an admin? y/n"
    read yn2
    if [ "$yn2" == "y" ]
    then
      usermod -aG sudo ${users[${i}]}
      gpasswd -a ${users[${i}]} adm
      gpasswd -a ${users[${i}]} lpadmin
      gpasswd -a ${users[${i}]} sudo
      echo "made ${users[${i}]} an admin"
    else
      gpasswd -d ${users[${i}]} adm
      gpasswd -d ${users[${i}]} sudo
      gpasswd -d ${users[${i}]} lpadmin
      gpasswd -d ${users[${i}]} root
      echo "made ${users[${i}]} a normal user"
    fi
    echo "make a new secure password for ${users[${i}]}? y/n"
    read yn3
    if [ "$yn3" == "y" ]
    then
      echo type password:
      read pw
      echo -e "$pw\n$pw" | passwd ${users[${i}]}      
    else
      echo -e "Cyberdragons!1\nCyberdragons!1" | passwd ${users[${i}]}
      echo "gave Cyberdragons!1 password to ${users[${i}]}"
    fi
  fi
done
echo please print out the users you want to add with spaces between
read -a user
for ((i=0; i<${#user[@]};i++))
do
  adduser ${user[${i}]}
  echo "added ${user[${i}]}"
  echo "make ${user[${i}]} an admin? y/n"
  read yn4
  if [ "$yn4" == "y" ]
  then
    usermod -aG sudo ${user[${i}]}
    gpasswd -a ${user[${i}]} adm
    gpasswd -a ${user[${i}]} lpadmin
    gpasswd -a ${user[${i}]} sudo
    echo "made ${user[${i}]} an admin"
  else
    echo "made ${user[${i}]} a normal user"
  fi
done
#adds, deletes, and promotes/demotes users

echo please print out all groups to be added with a space between
read -a groups
for ((i=0; i<${#groups[@]};i++))
do
  addgroup ${groups[${i}]}
  echo print out all users you want to add to this group
  read -a name
  for ((i=0; i<${#name[@]};i++))
  do
    usermod -a -G ${groups[${i}]} ${name[${i}]}
  done
done
#group configuration

chmod 644 /etc/passwd
chmod 640 /etc/shadow
chmod 640 .bash_history
chmod 777 /etc/hosts
chmod 644 /etc/apt/apt.conf.d/10periodic
echo "file permissions set"
#file permissions

apt-get purge ophcrack -y
apt-get purge ophcrack-cli -y
apt-get purge logkeys -y
apt-get purge aircrack-ng -y
apt-get purge wireshark -y
apt-get purge wireshark-common -y
apt-get purge doomsday -y 
apt-get purge freedoom -y
apt-get purge doomsday-common -y
apt-get purge john -y
apt-get purge hydra -y
apt-get purge nikto -y
echo "deleted most hacking/games tools"
#deletes hacking/gaming tools

passwd -l root
usermod -L root
unalias -a 
find /bin/ -name "*.sh" -type f -delete
echo "extras done"
#misc. stuff

echo -e "# Controls IP packet forwarding\nnet.ipv4.ip_forward = 0\n\n# IP Spoofing protection\nnet.ipv4.conf.all.rp_filter = 1\nnet.ipv4.conf.default.rp_filter = 1\n\n# Ignore ICMP broadcast requests\nnet.ipv4.icmp_echo_ignore_broadcasts = 1\n\n# Disable source packet routing\nnet.ipv4.conf.all.accept_source_route = 0\nnet.ipv6.conf.all.accept_source_route = 0\nnet.ipv4.conf.default.accept_source_route = 0\nnet.ipv6.conf.default.accept_source_route = 0\n\n# Ignore send redirects\nnet.ipv4.conf.all.send_redirects = 0\nnet.ipv4.conf.default.send_redirects = 0\n\n# Block SYN attacks\nnet.ipv4.tcp_syncookies = 1\nnet.ipv4.tcp_max_syn_backlog = 2048\nnet.ipv4.tcp_synack_retries = 2\nnet.ipv4.tcp_syn_retries = 5\n\n# Log Martians\nnet.ipv4.conf.all.log_martians = 1\nnet.ipv4.icmp_ignore_bogus_error_responses = 1\n\n# Ignore ICMP redirects\nnet.ipv4.conf.all.accept_redirects = 0\nnet.ipv6.conf.all.accept_redirects = 0\nnet.ipv4.conf.default.accept_redirects = 0\nnet.ipv6.conf.default.accept_redirects = 0\n\n# Ignore Directed pings\nnet.ipv4.icmp_echo_ignore_all = 1\n\n# Accept Redirects? No, this is not router\nnet.ipv4.conf.all.secure_redirects = 0\n\n# Log packets with impossible addresses to kernel log? yes\nnet.ipv4.conf.default.secure_redirects = 0\n\n########## IPv6 networking start ##############\n# Number of Router Solicitations to send until assuming no routers are present.\n# This is host and not router\nnet.ipv6.conf.default.router_solicitations = 0\n\n# Accept Router Preference in RA?\nnet.ipv6.conf.default.accept_ra_rtr_pref = 0\n\n# Learn Prefix Information in Router Advertisement\nnet.ipv6.conf.default.accept_ra_pinfo = 0\n\n# Setting controls whether the system will accept Hop Limit settings from a router advertisement\nnet.ipv6.conf.default.accept_ra_defrtr = 0\n\n#router advertisements can cause the system to assign a global unicast address to an interface\nnet.ipv6.conf.default.autoconf = 0\n\n#how many neighbor solicitations to send out per address?\nnet.ipv6.conf.default.dad_transmits = 0\n\n# How many global unicast IPv6 addresses can be assigned to each interface?net.ipv6.conf.default.max_addresses = 1\n\n########## IPv6 networking ends ##############" >> /etc/sysctl.conf
sysctl -p
echo "sysctl reconfigured"
echo -e "\n\n# Disable IPv6\nnet.ipv6.conf.all.disable_ipv6 = 1\nnet.ipv6.conf.default.disable_ipv6 = 1\nnet.ipv6.conf.lo.disable_ipv6 = 1" >> /etc/sysctl.conf
echo "disabled ipv6"
#sysctl reconfiguration

apt-get install unattended-upgrades apt-listchanges
echo -e "APT::Periodic::Update-Package-Lists \"1\";\nAPT::Periodic::Download-Upgradeable-Packages \"1\";\nAPT::Periodic::AutocleanInterval \"1\";\nAPT::Periodic::Unattended-Upgrade \"1\";" > /etc/apt/apt.conf.d/10periodic
echo "finished daily updates"
#daily updates

echo "auth optional pam_tally.so deny=5 unlock_time=1800 onerr=fail " >> /etc/pam.d/common-auth
echo -e "password requisite pam_cracklib.so retry=3 minlen=8 difok=3 reject_username minclass=3 maxrepeat=2 dcredit=1 ucredit=1 lcredit=1 ocredit=1\npassword requisite pam_pwhistory.so use_authtok remember=24 enforce_for_root" >>  /etc/pam.d/common-password
#sed on the password min/max
#password stuff?
sed -i '160s/.*/PASS_MAX_DAYS\o01130/' /etc/login.defs
sed -i '161s/.*/PASS_MIN_DAYS\o0115/' /etc/login.defs
sed -i '162s/.*/PASS_MIN_LEN\o0118/' /etc/login.defs
sed -i '163s/.*/PASS_WARN_AGE\o0117/' /etc/login.defs
#find out how to edit /etc/pam.d/common-password and /etc/pam.d/common-auth
#echo "finished password complexity stuff!"
#updates default settings for password complexity n stuff

apt update -y
apt-get upgrade -y
apt-get dist-upgrade -y
apt autoremove -y
apt autoclean -y
#upgrades/updates everything within computer

echo "remember to delete unwanted users"