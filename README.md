--------
# Ansible Consul Role
[![Build Status](https://travis-ci.org/hellofresh/ansible-consul.svg?branch=master)](https://travis-ci.org/hellofresh/ansible-consul)

`consul` is an ansible role to install and manage consul services and client side load balancing.


## Overview

This is an opinionated setup of consul. That manages services discovery and client side load balancing. It deploys HAproxy with each consumer and use consul template.

```
                  +--------------+
                  | Consul UI    |
                  | Consul Server|
                  |              |
                  +--------------+
                   (Consul Server)

+----------------+            +--------------+
|HAproxy         |            | Consul(Agent)|
|Consul(Agent)   |            | App(Producer)|
|consul(template)|            |              |
|App(Consumer)   |            |              |
+----------------+            +--------------+
    (Consumer)                    (Producer)
```

Using with AMI
--------------

When the role is used to provision AMI image, ensure the following variables are set to these specific values

```yaml
consul_start_service: false         # Required: Prevent consul from starting at provision time
consul_node_name: auto              # Required: read node name from cloud meta-data
consul_network_bind: auto           # Required: read private IP from cloud meta-data
consul_network_autobind: false      # Required: disable provision time IP address discovery
consul_node_name_prefix: "service-" # Optional: node name prefix
```

Requirements
------------

 - Developed for Ansible 2.X
 - Controller should have python-netaddr

Role Variables
--------------

```yaml
---

consul_node_name                    : "{{ inventory_hostname }}"

# Type of installation
consul_server                       : false
consul_consumer                     : false
consul_producer                     : false
consul_ui                           : false
#
consul_consumer_services            : []
consul_producer_services            : []

# Consul Domain
consul_datacenter                   : "default"
consul_domain                       : "consul."

#consul_start_join                   : [ "127.0.0.1" ]
consul_rejoin_after_leave           : true
consul_leave_on_terminate           : false

#Consul log
consul_log_level                    : "INFO"
consul_log_syslog                   : false

# Consul Network                    :
consul_network_bind                 : "" # "0.0.0.0"
consul_network_autobind             : true
#consul_network_autobind_range       : "192.168.56.0/24"
consul_network_autobind_type        : "private" # "" or private or public
consul_client_addr                  : "127.0.0.1"

# Consul dir structure
consul_home_dir                     : "/opt/consul"
consul_bin_dir                      : "{{ consul_home_dir }}/bin"
consul_tmp_dir                      : "{{ consul_home_dir }}/tmp"
consul_data_dir                     : "{{ consul_home_dir }}/data"
consul_template_dir                 : "{{ consul_home_dir }}/templates"
consul_log_dir                      : "/var/log/consul"
consul_config_dir                   : "/etc/consul.d"
# Consul files
consul_config_agent_file            : "/etc/consul.conf"
consul_config_template_file         : "/etc/consul-template.conf"
consul_agent_log_file               : "{{ consul_log_dir }}/consul-agent.log"
consul_template_log_file            : "{{ consul_log_dir }}/consul-template.log"
consul_template_haproxy_file        : "{{ consul_template_dir }}/consul_template.cnf"

# Consul user/Group
consul_user                         : "consul"
consul_group                        : "consul"

# Consul template
consul_template_consul_server       : "127.0.0.1"
consul_template_consul_port         : "8500"
consul_template_templates           :
                                      - source      : "{{ consul_template_haproxy_file }}"
                                        destination : "/etc/haproxy/haproxy.cfg"
                                        command     : "haproxy -f /etc/haproxy/haproxy.cfg -c && sudo service haproxy reload"
                                        jtemplate   : "haproxy.ctmp.j2"

## Telemetry
# Enable telemetry
consul_telemetry                    : False
# StatsD server address and port (address:port)
consul_statsd_address               : ""
---

consul_agent_version                : "0.7.5"
consul_template_version             : "0.18.1"

consul_node_name                    : "{{ inventory_hostname }}"

# Type of installation
consul_server                       : false
consul_consumer                     : false
consul_producer                     : false
consul_ui                           : false

#
consul_consumer_services            : []
consul_producer_services            : []

# Consul Domain
consul_datacenter                   : "default"
consul_domain                       : "consul."

#consul_start_join                   : [ "127.0.0.1" ]
consul_servers_list                 : [ "127.0.0.1" ] # you can use ansible groups "{{ groups['consul_servers'] }}"
consul_rejoin_after_leave           : true
consul_leave_on_terminate           : false
# Retry Options
consul_retry_join                   : false
consul_retry_interval               : 30s
consul_retry_max                    : 0
# Consul log
consul_log_level                    : "INFO"
consul_log_syslog                   : false

consul_server_port_server           : 8300
consul_http_port                    : 8500
consul_https_port                   : -1

# Consul Network                    :
consul_network_bind                 : "" # "0.0.0.0"
consul_network_autobind             : true
#consul_network_autobind_range       : "192.168.56.0/24"
consul_network_autobind_type        : "private" # "" or private or public
consul_client_addr                  : "127.0.0.1"

# Consul dir structure
consul_home_dir                     : "/opt/consul"
consul_bin_dir                      : "{{ consul_home_dir }}/bin"
consul_tmp_dir                      : "{{ consul_home_dir }}/tmp"
consul_data_dir                     : "{{ consul_home_dir }}/data"
consul_template_dir                 : "{{ consul_home_dir }}/templates"
consul_log_dir                      : "/var/log/consul"
consul_config_dir                   : "/etc/consul.d"
# if you leave emtpy only "healthy" and passing services will be returned. You can also use "passing,warning" or "all"
# For more info check https://github.com/hashicorp/consul-template#service
consul_template_service_options     : ""

# Consul files
consul_config_agent_file            : "/etc/consul.conf"
consul_config_template_file         : "/etc/consul-template.conf"
consul_agent_log_file               : "{{ consul_log_dir }}/consul-agent.log"
consul_template_log_file            : "{{ consul_log_dir }}/consul-template.log"
consul_template_haproxy_file        : "{{ consul_template_dir }}/consul_template.cnf"

# Consul user/Group
consul_user                         : "consul"
consul_group                        : "consul"

# Consul template
consul_template_consul_server       : "127.0.0.1"
consul_template_consul_port         : "8500"
consul_template_templates           :
                                      - source      : "{{ consul_template_haproxy_file }}"
                                        destination : "/etc/haproxy/haproxy.cfg"
                                        command     : "{{ consul_bin_dir }}/haproxy-reload"
                                        jtemplate   : "haproxy.ctmp.j2"

consul_template_log_level           : "warn"

consul_encrypt                      : "Tq/xU3fTPyBRoA4R4CxOKg=="

## Telemetry
consul_telemetry                    : False
consul_statsd_address               : ""
consul_statsite_address             : ""
consul_statsite_prefix              : "consul"
consul_disable_hostname             : True

## HA Proxy
consul_haproxy_ppa_install          : False # By default use packaged version of Haproxy
consul_haproxy_ppa_url              : "ppa:vbernat/haproxy-1.6"
## Config global
consul_haproxy_user                 : "haproxy"
consul_haproxy_group                : "haproxy"
consul_haproxy_maxconn              : "8192"
consul_haproxy_log                  : [ "/dev/log	local0", "/dev/log	local1 info" ]

consul_haproxy_stats_socket         : "socket /var/lib/haproxy/stats.sock group {{ consul_group }} mode 660 level admin"
## Extra global key, value
consul_haproxy_extra_global         :
                                       chroot: "/var/lib/haproxy"
## Config defaults
consul_haproxy_default_log          : "global"
consul_haproxy_default_options      :
                                      - "dontlognull"
                                      - "log-separate-errors"
                                      - "redispatch"
consul_haproxy_default_timeout      :
                                      - "connect 5s"
                                      - "check   5s"
                                      - "client  120s"
                                      - "server  120s"
consul_haproxy_default_maxconn      : 2000
consul_haproxy_default_retries      : 3
consul_haproxy_default_balance      : "roundrobin"
## Extra default key, value
#consul_haproxy_extra_default       :

consul_haproxy_default_server_options  : "check inter 10s fastinter 5s downinter 8s rise 3 fall 2"
## Config Stats page by default HAproxy will have default stats
consul_haproxy_stats_enable         : True
consul_haproxy_stats_mode           : "http"
consul_haproxy_stats_port           : 3212
consul_haproxy_stats_uri            : "/"

# Ad-hoc commands RUN WITH CARE
consul_adhoc_build_raft_peers       : False
```


## Usage

Service definition
----
The role expects all services to be listed in `consul_services` dictionary:

```yaml
consul_services:
  hello-app:
    name: "hello-app"
    tags:
      - "env:live"
    port: 80
    local_port: 8032
    check:
      script: "curl localhost:80 > /dev/null 2>&1"
      interval: "10s"
    haproxy:
      server_options: "check inter 10s fastinter 5s downinter 8s rise 3 fall 2"

  hello-db:
    name: "hello-db"
    tags:
      - "env:live"
    port: 3306
    check:
      script: "netstat -ant | grep 3306 | grep -v grep > /dev/null 2>&1"
      interval: "10s"
    haproxy:
      server_options: "check inter 10s fastinter 5s downinter 8s rise 3 fall 2"
```

Service example
---------------
```yaml
  hello-app:
    name: "hello-app"
    tags:
      - "env:live"
    port: 80
    local_port: 8032
    check:
      script: "curl localhost:80 > /dev/null 2>&1"
      interval: "10s"
    haproxy:
      server_options: "check inter 10s fastinter 5s downinter 8s rise 3 fall 2"
```
`hello-app`:

`name`: service name to announce

`tags`: list of tags to filter by (see tags section)

`port`: port number server part listens on

`local_port`: port number CSLB agent (haproxy) will listen on, if absent equals `port`

`check`: healthcheck script and interval; most of the times as simple as in this example

`haproxy`: haproxy server check definition (https://cbonte.github.io/haproxy-dconv/1.7/configuration.html#5.2-check)


### Producer configuration
Define list of services you produce (offer to connect to)
```yaml
consul_producer: True
consul_producer_services:
  - hello-app
  - other-service
```
Role will install consul agent and configure it to announce specified services.

### Consumer configuration
Define list of services you consume (want to connect to)
```yaml
consul_consumer: True
consul_consumer_services:
  - hello-app
  - hello-db
```
Role will configure consul agent, consul template and haproxy. Haproxy will listen on specified ports, so you would be able to connect to specific service using `127.0.0.1:port`.

### Extended syntax
If you want to specify additional parameters you should use extended syntax:
```yaml
---
consul_producer: True
consul_producer_services:
  # simple syntax
  - hello-app
  # extended syntax
  - name: hello-app
    add_tags: ['host-specific-tag']
```


```yaml
---
consul_consumer: True
consul_consumer_services:
  # simple syntax
  - hello-app
  # extended syntax
  - name: hello-app
    tags_contains: "test"
```


### Using tags

#### Producer
You can specify additional tags for group/host. These tags will be added to a set of tags globally defined to this service.

```yaml
consul_producer: True
consul_producer_services:
  - name: hello-app
    add_tags: ['host-specific-tag']
```

#### Consumer
On consumer side, you can user additional parameters to filter services/nodes by tags.

```yaml
consul_consumer: True
consul_consumer_services:
  - name: hello-app
    tags_contains: "test"
    tag_regex: "v1.1.*"
```


Road map
-----
- Support agent retry
- Support template retry

License
-------

MIT


Contributors (sorted alphabetically on the first name)
------------------
* [Adham Helal](https://github.com/ahelal)


Snippets
-------
Some snippets of code was taken from various sources. We will try our best to list them.

--------

<p align="center">
  <a href="https://hellofresh.com">
    <img  width="120" src="https://www.hellofresh.de/images/hellofresh/press/HelloFresh_Logo.png">
  </a><br>
  HelloFresh - More Than Food.
</p>
