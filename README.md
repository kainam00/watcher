# watcher
Simple Python script to monitor applications from a loadbalancer.

The script will perform a defined application check and look for a maint file indicating that the application server is in maintenance mode. This prevents you from having to build this logic into the LB itself, and allows those monitors to be generic.

<h3>Installation</h3>
This assumes a CentOS/RedHat-like system. Everything else should be easily hackable.

<h4>Easy-mode</h4>
Grab the RPM from the RPM directory. Install it manually, add it to you local repo, do whatever you want. The associated documentation is in there, but it's pretty easy-mode.

<h4>Manual</h4>
Also not that complicated, just more of a pain if you're putting this on a lot of hosts.
* Clone or download the repo into a place of your choosing (such as /opt/watcher) and go into that directory

```bash
export USERTOUSE=<username>
```

```bash
cp ./initscript.bash /etc/init.d/watcher ; chmod +x /etc/init.d/watcher
cp ./watcher.sysconfig /etc/sysconfig/watcher
chown -R $USERTOUSE ./
touch /var/log/watcher.log ; chown $USERTOUSE /var/log/watcher.log
```

Edit <code>/etc/sysconfig/watcher</code> if needed. You'll want to change the CHECK_COMMAND at minimum.
IMPORTANT: Whatever you put into the CHECK_COMMAND variable will be visible in the process list. Don't use anything sensitive (such as auth credentials) in there.

Start it up!
```
chkconfig watcher on
service watcher start
```

<h3>Usage</h3>
curl http://hostname:watcher-port/status

Return values:
* OK - Check command returned 0 and maint file is abscent.
* MAINT - Maint file is present. We don't care what the check command returns.
* FAIL - Maint file is abscent. Check command returned something other than 0 status.
