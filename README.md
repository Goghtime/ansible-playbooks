---
- name: Update and Upgrade Ubuntu Servers
  hosts: all
  become: yes
  tasks:
    - name: Update apt-get repo and cache
      apt:
        update_cache: yes
        cache_valid_time: 3600

    - name: Upgrade all packages to the latest version
      apt:
        upgrade: dist

    - name: Remove unused packages
      apt:
        autoremove: yes
