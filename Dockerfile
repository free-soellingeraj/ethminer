FROM nvcr.io/nvidia/pytorch:20.03-py3
RUN apt upgrade -y && apt update -y && apt install git cmake g++-6  mesa-common-dev -y
RUN update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-6 10 &&\
update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-6 10
ENV CC=gcc
ENV CCX=g++
RUN git clone https://github.com/ethereum-mining/ethminer.git
COPY cmake/Hunter/config.cmake ethminer/cmake/Hunter/config.cmake
RUN cd ethminer &&\
git submodule update --init --recursive &&\
mkdir build; cd build &&\
cmake .. -DETHASHCUDA=ON -DETHASHCL=OFF &&\
cmake --build . -- -j &&\
make install
RUN apt install bash
ENTRYPOINT ["ethminer"]
