Consul Demo
-----------

This demo will create the three instances 

* demo1
* demo2
* demo3


All instances share [common var](https://github.com/hellofresh/ansible-consul/blob/master/demo/vars/common_var.yml)


**Demo1** 
- Is the consul_server with a UI [demo1 vars](https://github.com/hellofresh/ansible-consul/blob/master/demo/vars/demo1_var.yml)
- Accessible via **192.168.56.150**

**Demo2** 
- Is an app server hosts our **superapp** [demo2 vars](https://github.com/hellofresh/ansible-consul/blob/master/demo/vars/demo2_var.yml)
- It is a producer of **superapp** and consumer of **superdb**
- Accessible via **192.168.56.151**

**Demo3** 
- Is our DB server hosts our **superdb** [demo3 vars](https://github.com/hellofresh/ansible-consul/blob/master/demo/vars/demo1_var.yml)
- It is a producer of **superdb**
- Accessible via **192.168.56.152**

