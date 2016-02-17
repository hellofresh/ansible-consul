# Ansible Consul Role

`consul` is an ansible role to install and manage consul services.

## Warning.

This code is still in early development

## Overview

This is an opinionated setup of consul. It deploys HAproxy with each consumer and use consul template.

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


Requirements
------------

 - Developedon for Ansible 2.X but will be compatible with 1.9.x
 - Controller should have python-netaddr

Role Variables
--------------

See [defaults/main.yml](https://github.com/hellofresh/ansible-consul/blob/master/defaults/main.yml)


Road map
-----
- Support agent retery
- Support template retery
- serf Encryption
- consul-template should not take things out of load balancers if services goes down let haproxy handle that.
- Be docker friendly 

Caveat
------
- With ansible 1.9.x ipaddr used by ip_match will return strings instead of list. That will break the role if your using consul_network_autobind = true

License
-------
MIT


Contributors (sorted alphabetically on the first name)
------------------
* [Adham Helal](https://github.com/ahelal)


Snippets 
-------
Some snippets of code was taken from various sources. We will try our best to list them.
