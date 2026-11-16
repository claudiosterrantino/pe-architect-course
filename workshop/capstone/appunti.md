git clone https://github.com/redhat-developer-demos/urlshortener

cd urlshortener/front/

docker build -t urlshortener-front:local .

kind load docker-image urlshortener-front:local -n 5min-idp