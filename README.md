Ahmad Elghadban

## Automated ELK Stack Deployment

The files in this repository were used to configure the network depicted below.

![image](https://github.com/Ahmad14-2/My_Project/blob/main/Diagrams/FinalDiagram.png)


These files have been tested and used to generate a live ELK deployment on Azure. They can be used to either recreate the entire deployment pictured above. Alternatively, select portions of the playbook files be used to install only certain pieces of it, such as Filebeat.

  - [ELK install](https://github.com/Ahmad14-2/My_Project/blob/main/Ansible/install-elk.yml.txt)
  - [Metricbeat playbook](https://github.com/Ahmad14-2/My_Project/blob/main/Ansible/metricbeat-playbook.yml.txt)
  - [Filebeat playbook](https://github.com/Ahmad14-2/My_Project/blob/main/Ansible/filebeat-playbook.yml.txt)


This document contains the following details:
- Description of the Topologu
- Access Policies
- ELK Configuration
  - Beats in Use
  - Machines Being Monitored
- How to Use the Ansible Build


### Description of the Topology

The main purpose of this network is to expose a load-balanced and monitored instance of DVWA, the D*mn Vulnerable Web Application.

Load balancing ensures that the application will be highly available, in addition to restricting access to the network.
- Load balancers help ensure environment availability through distribution of incoming data to web servers. Jump boxes allow for more easy administration of multiple systems and provide an additional layer between the outside and internal assets.

Integrating an ELK server allows users to easily monitor the vulnerable VMs for changes to the event logs and system metrics.
- Filbeats watch for log directories or specific log files.
- Metricbeat helps you monitor your servers by collecting metrics from the system and services running on the server.

The configuration details of each machine may be found below.
_Note: Use the [Markdown Table Generator](http://www.tablesgenerator.com/markdown_tables) to add/remove values from the table_.

| Name     | Function | IP Address | Operating System |
|----------|----------|------------|------------------|
| Jump Box | Gateway  | 10.0.0.4   | Linux            |
| Web 1    | server   | 10.0.0.5   | Linux            |
| web 2    | server   | 10.0.0.6   | Linux            |
| ELK      |Log Server| 10.1.0.4   | Linux            |

### Access Policies

The machines on the internal network are not exposed to the public Internet. 

Only the Jump Box Provisioner machine can accept connections from the Internet. Access to this machine is only allowed from the following IP addresses:
- Port 5061

Machines within the network can only be accessed by each other.
- Jump Box can SSH into the Web Servers and Elk Servers. Web Servers sent log information to the Elk Server

A summary of the access policies in place can be found in the table below.

| Name     | Publicly Accessible | Allowed IP Addresses |
|----------|---------------------|----------------------|
| Jump Box | No                  | ssh Personal         |
| web 1    | Yes                 | 104.45.217.96        |
| web 2    | Yes                 | 104.45.217.96        |
| Elk      | No                  | ssh 10.1.0.4:5601    |

### Elk Configuration

Ansible was used to automate configuration of the ELK machine. No configuration was performed manually, which is advantageous because servcies running can be limited, system installation and update can be streamlined, and processes become more replicable.
- Using Ansible in this way allows us to quickly install, update, and add web servers to our network using the same playbooks.

The playbook implements the following tasks:
- First we install docker on all network machines so they will be able to recieve and install containers. 
- Ansible is installed on the Jump Box VM to distribute containers to other VMs on the network. 
- Ansible playbooks are used to install the ELK stack container on the ELK server and a 'Beats' containers on the Web servers

The following screenshot displays the result of running `docker ps` after successfully configuring the ELK instance.

![image](https://github.com/Ahmad14-2/My_Project/blob/main/Dockerps.png)

### Target Machines & Beats
This ELK server is configured to monitor the following machines:
 - Web-1 - 10.0.0.5
 - Web-2 - 10.0.0.6

We have installed the following Beats on these machines:
- Filebeat
- Metricbeat

These Beats allow us to collect the following information from each machine:
- <b>Filebeat</b> - Filebeat detects changes to the filesystem. We are using this to monitor our Web Log data. 
- <b>Metricbeat</b> - Metricbeat detects changes in system metrics, such as CPU usage. We use it to detect SSH login attempts, failed sudo escalations, and CPU/RAM statistics.

### Using the Playbook
In order to use the playbook, you will need to have an Ansible control node already configured. Assuming you have such a control node provisioned: 

SSH into the control node and follow the steps below:
- Copy the.yml file to '/etc/ansible' dir .
- Update the hosts file to be as follows . This will assign the VM servers to their server groups for the Ansible Playbooks.
- Run the playbook, and navigate to http://[Elk_VM_Public_IP]:5601/app/kibana to check that the installation worked as expected.

Answer the following questions to fill in the blanks:

- Which file is the playbook? The Filebeat-configuration 
- Where do you copy it? copy /etc/ansible/files/filebeat-config.yml to /etc/filebeat/filebeat.yml
- Which file do you update to make Ansible run the playbook on a specific machine? How do I specify which machine to install the ELK server on versus which to install Filebeat on? update filebeat-config.yml -- specify which machine to install by updating the host files with ip addresses of web/elk servers and selecting which group to run on in ansible
- Which URL do you navigate to in order to check that the ELK server is running? http://[your.ELK-VM.External.IP]:5601/app/kibana.

As a **Bonus**, provide the specific commands the user will need to run to download the playbook, update the files, etc._

filebeats
```bash
- name: Installing and Launch Filebeat
  hosts: webservers
  become: yes
  tasks:
    # Use command module
  - name: Download filebeat .deb file
    command: curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-7.4.0-amd64.deb

    # Use command module
  - name: Install filebeat .deb
    command: dpkg -i filebeat-7.4.0-amd64.deb

    # Use copy module
  - name: Drop in filebeat.yml
    copy:
      src: /etc/ansible/files/filebeat-config.yml
      dest: /etc/filebeat/filebeat.yml

    # Use command module
  - name: Enable and Configure System Module
    command: filebeat modules enable system

    # Use command module
  - name: Setup filebeat
    command: filebeat setup

    # Use command module
  - name: Start filebeat service
    command: service filebeat start

```

metricbeats
```bash
- name: Install metric beat
  hosts: webservers
  become: true
  tasks:
    # Use command module
  - name: Download metricbeat
    command: curl -L -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-7.4.0-amd64.deb

    # Use command module
  - name: install metricbeat
    command: dpkg -i metricbeat-7.4.0-amd64.deb

    # Use copy module
  - name: drop in metricbeat config
    copy:
      src: /etc/ansible/files/metricbeat-config.yml
      dest: /etc/metricbeat/metricbeat.yml

    # Use command module
  - name: enable and configure docker module for metric beat
    command: metricbeat modules enable docker

    # Use command module
  - name: setup metric beat
    command: metricbeat setup

    # Use command module
  - name: start metric beat
    command: service metricbeat start
```
