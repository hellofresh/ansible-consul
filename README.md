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

See defaults/main.yml

License
-------

MIT


Contributors (sorted alphabetically on the first name)
------------------

* [Adham Helal](https://github.com/ahelal)


Snippets 
-------
Some snippets of code was taken from various sources. We will try our best to list them
