#!/bin/bash
set -e

apt-get update -y
apt-get install python3-pip python3-venv git -y  # 👈 add git

mkdir -p /home/ubuntu/app
cd /home/ubuntu/app

# Clone your repo (all files including pkl come with it)
git clone https://github.com/FrancisMiadi/aws_session.git .  # 👈 the dot clones into current dir

pip install flask flask-cors joblib scikit-learn==1.6.0 nltk pandas

chown -R ubuntu:ubuntu /home/ubuntu/app
nohup venv/bin/python app.py > app.log 2>&1 &
