# Docker image for ML
---------------------
Includes notebooks for:
- Python 3.7
- Julia 1.3.1 

### Quick start
Should Change directory for mount inside docker by `cd` and run: 
```
docker run -d -p 4545:4545 -v $PWD:/home/user vlasoff/ml jupyter notebook 
```

If you want stop it just use `docker ps` and `docker stop`

> :warning: Unsecure! 
> Close port 4545 on your local machine while container is running  
