# php-fpm
PHP-FPM images for running in Kubernetes
```bash
alias buildrun="docker-compose -f docker-compose-test.yml build && runrun"
alias runrun="docker-compose -f docker-compose-test.yml up php8-init && docker-compose -f docker-compose-test.yml down"
```
## Todo
- Add: DNS/Wait-DNS
- Add: Wait-Storage
- Add: Django
- Add: Build for NodeJS
- Add: Git/Wait for gitlab jobs