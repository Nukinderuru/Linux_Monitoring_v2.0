FROM ubuntu:20.04

WORKDIR /home

COPY main.sh /home/main.sh
COPY check_input.sh /home/check_input.sh
COPY generate_folders.sh /home/generate_folders.sh
COPY generate_path.sh /home/generate_path.sh

RUN chmod +x main.sh

ENTRYPOINT [ "bash" ]