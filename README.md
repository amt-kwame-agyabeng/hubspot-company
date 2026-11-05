# DevSecOps Environment Setup and Operations Manual

## 1. Project Overview

This project implements a complete DevSecOps environment for automated
application deployment using a self-hosted GitLab platform.

Environment Components: - Ubuntu Linux Server (Multipass VM) - GitLab
Community Edition (Self-hosted) - GitLab Runner - Secure Linux
Configuration - CI/CD Pipeline Automation - Node.js Web Application
Deployment

------------------------------------------------------------------------

## 2. Infrastructure Architecture

Client → GitLab Server (Port 80)\
Client → Web Application (Port 3000)

GitLab manages repositories and CI/CD automation while the application
runs independently.

------------------------------------------------------------------------

## 3. Server Access

Access Ubuntu server: multipass shell `<instance-name>`{=html}

Switch user: su - appuser

------------------------------------------------------------------------

## 4. Application Directory

Application location: /var/www/app/web-app

This directory is automatically updated by the CI/CD pipeline.

------------------------------------------------------------------------

## 5. Running Application Manually

cd /var/www/app/web-app npm install node app.js

Access: http://`<server-ip>`{=html}:3000

------------------------------------------------------------------------

## 6. CI/CD Deployment Workflow

Push code: git add . git commit -m "update" git push origin main

Pipeline Stages: 1. Build 2. Code Analysis 3. Security Testing 4.
Automated Testing 5. Deployment

Pipeline Logs: GitLab → Project → Build → Pipelines

------------------------------------------------------------------------

## 7. GitLab Service Management

Check status: sudo gitlab-ctl status

Restart: sudo gitlab-ctl restart

Stop: sudo gitlab-ctl stop

------------------------------------------------------------------------

## 8. GitLab Runner Management

Check runner: sudo gitlab-runner status

Restart runner: sudo gitlab-runner restart

List runners: sudo gitlab-runner list

------------------------------------------------------------------------

## 9. System Maintenance

Update packages: sudo apt update && sudo apt upgrade -y

Check services: systemctl status gitlab-runsvdir systemctl status
gitlab-runner

------------------------------------------------------------------------

## 10. Firewall Configuration

Check firewall: sudo ufw status

Allowed Ports: 22 → SSH 80 → GitLab 3000 → Application

------------------------------------------------------------------------

## 11. Backup and Recovery

Create backup: sudo gitlab-backup create

Important directories: /etc/gitlab /var/opt/gitlab /var/www/app

------------------------------------------------------------------------

## 12. Troubleshooting

Pipeline stuck: sudo gitlab-runner status

Permission errors: sudo chown -R appuser:appuser /var/www/app

Application not accessible: ps aux \| grep node

------------------------------------------------------------------------

## 13. Security Practices

- Non-root application user
- Restricted directory permissions
- Firewall configuration
- Service isolation
- Secure GitLab installation
- Controlled CI/CD deployment

------------------------------------------------------------------------

## 14. Operational Responsibilities

Administrator tasks: - Monitor pipelines - Maintain GitLab services -
Update server packages - Review deployment logs - Perform backups -
Ensure runner availability

------------------------------------------------------------------------

## 15. Author

DevSecOps Engineering Assignment\
Nponto Technologies
