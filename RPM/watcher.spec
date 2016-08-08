%define _topdir	 	/root
%define name			watcher 
%define release		1
%define version 	1
%define buildroot %{_topdir}/%{name}-%{version}-root

BuildRoot:	%{buildroot}
Summary: 		Watcher Script
License: 		GPL
Name: 			%{name}
Version: 		%{version}
Release: 		%{release}
Source: 		%{name}
Prefix: 		/opt
Group: 			Development/Tools

%description
Simple Python monitoring script. https://github.com/kainam00/watcher for more info.

%prep

%build

%install
pwd
mkdir -p $RPM_BUILD_ROOT/opt/watcher
mkdir -p $RPM_BUILD_ROOT/etc/init.d
mkdir -p $RPM_BUILD_ROOT/etc/sysconfig
cp /root/SOURCES/watcher/watcher $RPM_BUILD_ROOT/opt/watcher
cp /root/SOURCES/watcher/initscript.bash $RPM_BUILD_ROOT/etc/init.d/watcher
cp /root/SOURCES/watcher/watcher.sysconfig $RPM_BUILD_ROOT/etc/sysconfig/watcher


%files
%defattr(-,root,root)
/opt/watcher/watcher
/etc/init.d/watcher
/etc/sysconfig/watcher

%post 
useradd watcher
chmod +x /etc/init.d/watcher
touch /var/log/watcher.log
chown watcher /var/log/watcher.log
chown -R watcher /opt/watcher

