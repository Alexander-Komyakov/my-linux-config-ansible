Role Name
=========

my-linux-config

Requirements
------------


Role Variables
--------------

```
user_name: 'testtest'
user_password: '123456'
xrandr_exec: "exec xrandr --output DP-1 --primary --mode 1920x1080 --rate 170 --pos 1920x0 --rotate normal --output HDMI-1 --off --output HDMI-2 --mode 1920x1080 --pos 0x0 --rotate normal"
polybar_exec: "exec polybar --reload example2 &"
```

Dependencies
------------


Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

```
---
- name: install my desktop
  hosts: all
  gather_facts: no
  become: yes
  ignore_errors: true
  tasks:
    - name: my-desktop role
      include_role:
        name: my-desktop
      vars:
        user_name: 'testtest'
        user_password: '123456'
        xrandr_exec: "exec xrandr --output DP-1 --primary --mode 1920x1080 --rate 170 --pos 1920x0 --rotate normal --output HDMI-1 --off --output HDMI-2 --mode 1920x1080 --pos 0x0 --rotate normal"
        polybar_exec: "exec polybar --reload example2 &"

...

```

Author Information
------------------

Alexander-Komyakov
