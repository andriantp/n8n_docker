# 🔧 deploy n8n with docker


This repo provides a install n8n to **vps** and **local** using **docker compose**.


## 🚀 Getting Starte
```bash
# clone this git
$ git clone https://github.com/andriantp/n8n_docker.git n8n
```

### 📥 VPS
```bash
# 1. open docker-compose.yml and adjust port 
# 2. adjust webhook with ip public or domain 
# 3. deploy with 
$ make vps

# 4. wait until done
# 5. check logs with
$ docker logs -f n8n

# 6. open browser and copy domain
# 7. register
```

### 📥 Local
```bash
# 1. use ngrok for tunnel ip
# 2. get token at https://dashboard.ngrok.com/get-started/setup 
# 3. open file docker-compose.ngrok.yml
# 4. copy token at NGROK_AUTHTOKEN
# 5. adjust port
# 6. deploy with 
$ make local-ngrok

# 7. wait until done
# 8. open docker-compose.n8n.yml
# 9. adjust port
#10. copy NGROK_DOMAIN at .env to WEBHOOK_URL at docker-compose.n8n.yml
#11. deplot n8n
$ make local-n8n

#12. wait until done
#13. check logs with
$ docker logs -f n8n

#14. copy domain from ngrok 
#15. open browser and copy domain
#16. register

#17. if container ngrok restart or your pc reboot, domain ngrok can be change
#18. Get domain with
$ make local-url

#19. copy again domain to WEBHOOK_URL
#20. restart n8n
$ docker restart n8n

#21. open n8n at browset with new domain

```

### Instruction
- (medium)[https://andriantriputra.medium.com/n8n-how-to-deploy-n8n-with-docker-96c43fa8ade0]
