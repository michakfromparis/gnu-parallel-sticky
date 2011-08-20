#!/bin/bash

SERVER1=parallel-server3
SERVER2=parallel-server2

# -L1 will join lines ending in ' '
cat <<'EOF' | sed -e s/\$SERVER1/$SERVER1/\;s/\$SERVER2/$SERVER2/ | parallel -j0 -k -L1
echo '### Test --onall'; 
  parallel --onall -S parallel@$SERVER2,$SERVER1 '(echo {3} {2}) | awk \{print\ \$2}' ::: a b c ::: 1 2

echo '### Test | --onall'; 
  seq 3 | parallel --onall -S parallel@$SERVER2,$SERVER1 '(echo {3} {2}) | awk \{print\ \$2}' ::: a b c :::: -

echo '### Test --onall -u'; 
  parallel --onall -S parallel@$SERVER2,$SERVER1 -u '(echo {3} {2}) | awk \{print\ \$2}' ::: a b c ::: 1 2 3 | sort

echo '### Test --nonall'; 
  parallel --nonall -k -S parallel@$SERVER2,$SERVER1 'hostname' | sort

echo '### Test --nonall -u'; 
  parallel --nonall -S parallel@$SERVER2,$SERVER1 -u 'hostname|grep -q nlv.pi.dk && sleep 2; hostname;sleep 4;hostname;'

echo '### Test read sshloginfile from STDIN'; 
  echo nlv.pi.dk | parallel -S - --nonall hostname; 
  echo nlv.pi.dk | parallel --sshloginfile - --nonall hostname

echo '### Test --nonall --basefile'; 
  touch /tmp/nonall--basefile; 
  parallel --nonall --basefile /tmp/nonall--basefile -S parallel@$SERVER2,$SERVER1 ls /tmp/nonall--basefile

echo '### Test --onall --basefile'; 
  touch /tmp/onall--basefile; 
  parallel --onall --basefile /tmp/onall--basefile -S parallel@$SERVER2,$SERVER1 ls ::: /tmp/onall--basefile
EOF
