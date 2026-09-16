#!/bin/bash

ssh-keygen -t rsa -b 4096 -C "pfleger@lisha.ufsc.br"
ssh-copy-id pfleger@ssh.lisha.ufsc.br
ssh-copy-id  -o ProxyJump=pfleger@ssh.lisha.ufsc.br pj@150.162.62.155
