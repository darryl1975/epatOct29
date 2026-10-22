docker build -t d13revision:latest .
docker run -d --rm --name d13revision-app -p 8080:8080 d13revision:latest
