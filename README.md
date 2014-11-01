## Gnu parallel sticky
This project is a fork of GNU parallel version 20141022 by O. Tange and fetched from git://git.savannah.gnu.org/parallel.git.
GNU parallel is a great tool to distribute tasks on multicore machines / grids of hosts over the network. See the original website <a href="http://www.gnu.org/software/parallel/">here</a>  and its original tutorial <a href="http://www.gnu.org/software/parallel/parallel_tutorial.html">here</a> 

When using the network distribution scheme, the tasks are distributed in a random way with no control over the destination host of a specific task as explained by the original author here: http://stackoverflow.com/questions/26645042/gnu-parallel-host-sticky-jobs/26647768#26647768

This version of parallel should work transparently with your previous parallel usages but adds a simple grammar to tag jobs and hosts. Here is a little example that shows you the difference in the grammar by distributing 3 sleep commands to 3 different hosts to sleep for 5, 15 and 10 seconds remotely to simulate a time consuming task.

## Tutorial

#### Regular parallel grammar:

```bash
parallel -j1 --tag \
--sshlogin 16/hostname1 \
--sshlogin 8/user@hostname2 \
--sshlogin 8/hostname3 \
"sleep" ::: 5 15 10
```

Here the jobs will be distributed completely randomly to the various hosts

#### Sticky parallel grammar:

```bash
parallel -j1 --tag \
--sshlogin 16/iOS+Android/hostname1 \
--sshlogin 4/iOS/user@hostname2 \
--sshlogin 8/OSX/hostname3 \
"sleep" :::5@iOS 15@Android 10@OSX
```

### Description

You can tag any host with any number of arbitrary tags separated by the **+** sign
You can then tag any job with a tag by adding the tag name to it using the **@** sign

First, host tagging:

+ hostname1 is tagged with the tags "iOS" and "Android"
+ hostname2 is tagged with the tag "iOS"
+ hostname3 is tagged with the tag "OSX"

then job tagging:

+ job "5" is tagged with the tag "iOS"
+ job "15" is tagged with the tag "Android"
+ job "10" is tagged with the tag "OSX"

### Outcome

+ job 5 will be sent to hostname1 or hostname2 as they both support jobs of type "iOS"
+ job 15 will be sent to hostname1 as it is the only one supporting jobs of type "Android" or wait for job 5 to complete
+ job 10 will be sent to hostname3

## Authors and Contributors
This code is a a fork by @michaKFromParis of GNU parallel version 20141022 by O. Tange and fetched from git://git.savannah.gnu.org/parallel.git. Any contributor is welcome and I will take pull requests as long as they make sense

## Support or Contact
Having trouble with GNU Parallel Sticky? Do not hesitate to contact me directly at github@michak.net
