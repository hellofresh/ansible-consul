# Ansible Consul Role

`consul` is an [ansible](http://www.ansible.com) role 

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

Min Ansible 1.9.x 

Role Variables
--------------



Example Playbook
----------------



License
-------

MIT

Contributors (sorted alphabetically on the first name)
------------------

* [Adham Helal](https://github.com/ahelal)
