FROM centos:centos8

# Install the needed bits for centos
RUN set -ex; \
	yum -y update; \
	yum -y install openssl-devel postgresql-devel gcc gcc-c++ make git


# Build jsonP and install as a shared lib
ENV jsonp_src src/jsonP
ENV jsonp_dst /opt/jsonP
ENV bld /opt/build

RUN set -ex; \
	mkdir -p {bld}; \
	mkdir -p ${jsonp_dst}/include

COPY ${jsonp_src}/jsonP-libs.conf /etc/ld.so.conf.d/
COPY ${jsonp_src}/Makefile ${bld}/

#RUN g++ -O3 -fPIC -I ${jsonp_dst}/include ${jsonp_bld}/src/*.cpp -shared -o ${jsonp_dst}/libjsonP.so.1.0 -Wl,-soname,libjsonP.so.1
RUN set -ex; \
        cd ${bld}; \
	git clone https://github.com/ErikDeveloperNot/jsonP_dyn.git; \
	cp ${bld}/jsonP_dyn/*.h ${jsonp_dst}/include; \
	mv Makefile ${bld}/jsonP_dyn; \
	cd ${bld}/jsonP_dyn; \
	make; \	
	ldconfig; \
	ln /opt/jsonP/libjsonP.so.1 /opt/jsonP/libjsonP.so; \
	ldconfig

# Build hiredis (c-client)
ENV redis_src /opt/hiredis

RUN set -ex; \
	mkdir -p ${redis_src}; \
	cd /opt; \
	git clone https://github.com/redis/hiredis.git; \
	cd hiredis; \
	make dynamic; \
	make install; \
	echo "/usr/local/lib" > /etc/ld.so.conf.d/hiredis.conf; \
	ldconfig


# Build sync_server
ENV sync_src src/sync/src
ENV sync_cfg src/sync/config
ENV sync_dst /opt/sync_server

COPY ${sync_cfg}/Makefile ${bld}/

RUN set -ex; \
	mkdir -p ${sync_dst}; \
	cd ${bld}; \
	git clone https://github.com/ErikDeveloperNot/sync_server.git; \
	mv Makefile sync_server; \
	cd sync_server; \
	make; \
	yum -y erase gcc gcc-c++ make git


COPY ${sync_cfg}/* ${sync_dst}/

#RUN g++ -O2 -I ${jsonp_dst}/include -I /usr/include/openssl -pthread -o ${sync_dst}/sync_server ${sync_bld}/*.cpp -lpq -L${jsonp_dst} -ljsonP -lssl -lcrypto -Wl,-rpath,${jsonp_dst}


EXPOSE 8443

CMD /opt/sync_server/startup.sh
