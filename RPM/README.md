A simple RPM is provided here for convenience. It automates the already simple setup steps. Please note that the CentOS5 RPM has some known issues and may require a couple manual tinkering steps... but you shouldn't be using CentOS5 at this point anyway.


Building your own RPM (if you want to do that for some reason)

* Create your rpm build environment using your preferred tutorial from the cybernets
  * This is a good example of setting up your RPM build environment - https://wiki.centos.org/HowTos/SetupRpmBuildEnvironment
* Download/checkout the code into <your-rpmbuild-dir>/SOURCES/watcher
* Place the watcher.spec file provided here into <your-rpmbuild-dir>/SPECS/watcher.spec
* Adjust the spec file as your see fit
* Run rpmbuild -v -bb --clean SPECS/watcher.spec
* Grab the RPM from the proper RPMS directory
