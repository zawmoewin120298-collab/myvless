FROM alpine:latest

# လိုအပ်တဲ့ Tools များသွင်းခြင်း
RUN apk add --no-cache wget unzip ca-certificates bash

# Xray-core နောက်ဆုံး Version ကို Download ဆွဲပြီး ထည့်သွင်းခြင်း
RUN wget https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip && \
    unzip Xray-linux-64.zip && \
    mv xray /usr/local/bin/xray && \
    chmod +x /usr/local/bin/xray && \
    rm Xray-linux-64.zip

# Cloudflared ကို သွင်းခြင်း
RUN wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 -O /usr/local/bin/cloudflared && \
    chmod +x /usr/local/bin/cloudflared

WORKDIR /etc/xray

# သင့်ရဲ့ config.json ကို Docker ထဲ ကူးထည့်ခြင်း
COPY config.json .

# Process နှစ်ခုလုံးကို တပြိုင်နက် run ရန် script သုံးခြင်း (သို့မဟုတ် && ဖြင့် ဆက်ခြင်း)
CMD xray run -c /etc/xray/config.json & cloudflared tunnel --no-autoupdate run --token $TUNNEL_TOKEN
