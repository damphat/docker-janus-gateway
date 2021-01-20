FROM debian:bullseye-slim

RUN apt-get -y update && \
	apt-get install -y \
		libmicrohttpd-dev \
		libjansson-dev \
		libssl-dev \
		libsofia-sip-ua-dev \
		libglib2.0-dev \
		libopus-dev \
		libogg-dev \
		libcurl4-openssl-dev \
		liblua5.3-dev \
		libconfig-dev \
		libusrsctp-dev \
		libwebsockets-dev \
		libnanomsg-dev \
		librabbitmq-dev \
		pkg-config \
		gengetopt \
		libtool \
		automake \
		build-essential \
		wget \
		git \
		gtk-doc-tools && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*


RUN cd /tmp && \
	wget https://github.com/cisco/libsrtp/archive/v2.3.0.tar.gz && \
	tar xfv v2.3.0.tar.gz && \
	cd libsrtp-2.3.0 && \
	./configure --prefix=/usr --enable-openssl && \
	make shared_library && \
	make install

RUN cd /tmp && \
	git clone https://gitlab.freedesktop.org/libnice/libnice && \
	cd libnice && \
	git checkout 0.1.17 && \
	./autogen.sh && \
	./configure --prefix=/usr && \
	make && \
	make install

RUN cd /usr/local/src && \
    git clone https://github.com/meetecho/janus-gateway && \
	cd janus-gateway && \
	sh autogen.sh && \
	./configure --prefix=/opt/janus && \
	make && \
	make install && \
	make configs

FROM debian:bullseye-slim

RUN apt-get -y update && \
	apt-get install -y \
		libmicrohttpd12 \
		libjansson4 \
		libssl1.1 \
		libsofia-sip-ua0 \
		libglib2.0-0 \
		libopus0 \
		libogg0 \
		libcurl4 \
		liblua5.3-0 \
		libconfig9 \
		libusrsctp1 \
		libwebsockets16 \
		libnanomsg5 \
		librabbitmq4 && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

COPY --from=0 /usr/lib/libsrtp2.so.1 /usr/lib/libsrtp2.so.1
RUN ln -s /usr/lib/libsrtp2.so.1 /usr/lib/libsrtp2.so

COPY --from=0 /usr/lib/libnice.la /usr/lib/libnice.la
COPY --from=0 /usr/lib/libnice.so.10.10.0 /usr/lib/libnice.so.10.10.0
RUN ln -s /usr/lib/libnice.so.10.10.0 /usr/lib/libnice.so.10
RUN ln -s /usr/lib/libnice.so.10.10.0 /usr/lib/libnice.so

COPY --from=0 /opt/janus/bin/janus /opt/janus/bin/janus
COPY --from=0 /opt/janus/bin/janus-cfgconv /opt/janus/bin/janus-cfgconv
COPY --from=0 /opt/janus/etc/janus /opt/janus/etc/janus
COPY --from=0 /opt/janus/lib/janus /opt/janus/lib/janus
COPY --from=0 /opt/janus/share/janus /opt/janus/share/janus

EXPOSE 10000-10200/udp
EXPOSE 8088
EXPOSE 8188
EXPOSE 7088

CMD ["/opt/janus/bin/janus"]
