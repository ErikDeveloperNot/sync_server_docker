INCLUDES=-I "/opt/jsonP/include"
CXX=g++
CXXFLAGS=-O3 -std=c++11 -fPIC
LDFLAGS=-Wl,-soname,libjsonP.so.1
FINAL_DIR=/opt/jsonP

OBJ=file_chunk_impl.o jsonP_json.o jsonP_push_parser.o jsonP_buffer_parser.o jsonP_parser.o

#OBJ = ./src/file_chunk_impl.cpp ./src/jsonP_json.cpp ./src/jsonP_push_parser.cpp ./src/jsonP_buffer_parser.cpp ./src/jsonP_parser.cpp



libjsonP.so.1.0: ${OBJ}
	${CXX} ${CXXFLAGS} ${INCLUDES} -shared -o ${FINAL_DIR}/$@ $^ ${LDFLAGS}

${OBJ}:
	${CXX} ${CXXFLAGS} ${INCLUDES} -c *.cpp

clean:
	-rm -f *.o core *.core
	exit

all: libjsonP.so.1.0 clean
