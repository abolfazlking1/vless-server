FROM alpine:latest
RUN apk add --no-cache curl unzip bash
RUN mkdir -p /etc/xray && \
    curl -L https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip -o /tmp/xray.zip && \
    unzip /tmp/xray.zip -d /usr/bin && \
    chmod +x /usr/bin/xray && \
    rm /tmp/xray.zip
RUN printf '{\n\
  "log": {"loglevel": "none"},\n\
  "inbounds": [{\n\
    "port": 7860,\n\
    "protocol": "vless",\n\
    "settings": {\n\
      "clients": [{"id": "766a5035-64d1-443b-8254-934c5148006e"}],\n\
      "decryption": "none"\n\
    },\n\
    "streamSettings": {\n\
      "network": "ws",\n\
      "wsSettings": {"path": "/vless-ws"}\n\
    }\n\
  }],\n\
  "outbounds": [{"protocol": "freedom"}]\n\
}' > /etc/xray/config.json
CMD ["/usr/bin/xray", "-config", "/etc/xray/config.json"]
