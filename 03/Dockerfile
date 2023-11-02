FROM ubuntu:20.04

WORKDIR /home

COPY main.sh /home/main.sh
COPY check_input.sh /home/check_input.sh
COPY delete.sh /home/delete.sh

WORKDIR /home/create_files/

COPY create_files/main.sh /home/create_files/main.sh
COPY create_files/check_input.sh /home/create_files/check_input.sh
COPY create_files/generate_folders.sh /home/create_files/generate_folders.sh
COPY create_files/generate_path.sh /home/create_files/generate_path.sh

RUN chmod +x main.sh

ENTRYPOINT [ "bash" ]