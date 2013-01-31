ec2_ebs_present.rb
==================
Puppet plugin to determine if an EC2 instance is using EBS volumes.
Creates a puppet fact (in facter) called "ec2_ebs_present" with a value of "True" or "False".
Install in /usr/lib/ruby/1.8/facter/ec2_ebs_present.rb (Ubuntu) or /usr/lib/ruby/site_ruby/1.8/facter/ec2_ebs_present.rb (CentOS)

ec2_user_data.rb
================
Puppet plugin to retrieve the 'user-data' field for EC2 instances.
Creates a puppet fact (in facter) called "ec2_user_data" with a string value.
Install in /usr/lib/ruby/1.8/facter/ec2_user_data.rb (Ubuntu) or /usr/lib/ruby/site_ruby/1.8/facter/ec2_user_data.rb (CentOS)
