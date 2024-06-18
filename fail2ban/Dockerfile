FROM debian:latest

RUN apt-get update && apt-get install -y fail2ban

COPY config /etc/fail2ban

CMD ["fail2ban-server", "-f", "-x", "-v"]
