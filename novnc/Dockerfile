FROM caddy
WORKDIR /usr/share/caddy
RUN apk add --no-cache curl \
 && curl -fsSL $(curl -s https://api.github.com/repos/novnc/novnc/releases/latest |\
    grep tarball_url | head -1 | cut -d \" -f 4) | tar xz --strip-components=1 \
 && ln -sf vnc.html index.html \
 && apk del --purge curl
