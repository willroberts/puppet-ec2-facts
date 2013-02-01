puppet-ec2-facts
================

* Various puppet/facter plugins for EC2 instances.
* Install in /usr/lib/ruby/1.8/facter/ (Ubuntu) or /usr/lib/ruby/site_ruby/1.8/facter/ (CentOS)

ec2_ebs_present.rb
==================

* Determines if an EC2 instance is using EBS volumes.
* Creates a puppet fact (in facter) called "ec2_ebs_present" with a value of "True" or "False".

ec2_user_data.rb
================

* Retrieves the 'user-data' field for EC2 instances.
* Attempts to parse the user-data string for JSON.
    * Returns "ec2_user-data_KEYNAME" facts for each JSON key present
* If you don't use JSON, returns a "ec2_user-data_string" fact
* If "user-data" is not set, returns the string "" (puppet will ignore the fact).
