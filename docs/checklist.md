# Cloud host runbook — follow top to bottom, in order.

Do the whole run once on a **local VM** before touching any cloud account.

## 0. Inventory (write down before you start)

- Hostname, OS version, admin username, admin source IP
- Provider/region (if cloud), instance size, cost per month

## 1. Updates first

```bash
sudo apt update && sudo apt -y upgrade
sudo apt -y install unattended-upgrades
sudo dpkg-reconfigure -plow unattended-upgrades
```

## 2. Users and SSH keys

```bash
ssh-copy-id user@host            # from your machine
sudo nano /etc/ssh/sshd_config   # set: PasswordAuthentication no
sudo systemctl reload ssh
```

Verify from a second terminal before closing the first: key login works,
password login is refused.

## 3. Firewall baseline

Review `scripts/setup-ufw.sh`, then run it. Expected end state:

```bash
sudo ufw status numbered
# [1] 22/tcp  ALLOW  <admin-IP>
# [2] 80/tcp  ALLOW  Anywhere
# [3] 443/tcp ALLOW  Anywhere
```

`[capture]` screenshot this.

## 4. Web service + health endpoint

```bash
sudo apt -y install nginx
echo OK | sudo tee /var/www/html/healthz
curl -s -o /dev/null -w "%{http_code}\n" localhost/healthz   # → 200
```

`[capture]` the curl output.

## 5. Availability logging

```bash
sudo install -m 0755 scripts/health-check.sh /usr/local/bin/health-check.sh
(crontab -l; echo "*/5 * * * * /usr/local/bin/health-check.sh http://localhost/healthz") | crontab -
head /var/log/availability.csv
```

## 6. Weekly routine (10 minutes)

1. `sudo apt update && sudo apt -y upgrade`
2. Failed SSH logins: `sudo journalctl -u ssh --since "7 days ago" | grep -ci "failed"`
3. Downtime gaps: any non-200 rows in `/var/log/availability.csv`
4. `sudo ufw status numbered` — still exactly the 3 rules?

## 7. Cost notes

- Use the smallest instance class that fits (1 vCPU / 1 GB is plenty here).
- Stop the instance when the lab is idle; snapshots cost less than running hours.
- Watch egress if you serve real traffic; this lab's traffic is negligible.
