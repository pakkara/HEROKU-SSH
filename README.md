
## Easy Deploy:
[![Deploy](https://heroku.com/deploy)

# Scale Dynos (Optional)

```
heroku ps:scale web=3
Scaling dynos... done, now running web at 2:Standard-1X
```

# Check Dynos are up

```
heroku ps -a <APP_NAME>
=== web (Standard-1X): /bin/sh -c bash /heroku-exec.sh && gunicorn --bind 0.0.0.0:$PORT wsgi (3)
web.1: up 2019/01/13 00:48:24 +0530 (~ 12m ago)
web.2: up 2019/01/13 00:48:31 +0530 (~ 12m ago)
web.3: up 2019/01/13 00:48:31 +0530 (~ 12m ago)
```
# SSH into Dyno

```
heroku ps:exec --dyno=web.3 -a <APP_NAME>
Establishing credentials... done
Connecting to web.3 on ⬢ exec-docker... 
~ $ 
```
