SGX php demonstration


## Building and Running

```sh
docker-compose up
```

## observe app server works fine

```sh
curl localhost
```


## manipulate the running containers php files


```sh
docker exec php-sgx sh -c 'echo >>  /app/wordpress/index.php'
```

## observe that the app server no longer worls

```sh
curl localhost:80
<nothing>
```

in the containers output spot

```
error: Accessing file '/app/wordpress/index.php' is denied: incorrect hash of file chunk at 0-20.
```

