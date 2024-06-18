FROM fauria/vsftpd

ENV FTP_USER=user
ENV FTP_PASS=pass

EXPOSE 20 21 21100-21110

CMD ["/usr/sbin/vsftpd", "/etc/vsftpd/vsftpd.conf"]
