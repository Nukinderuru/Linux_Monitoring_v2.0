FROM ubuntu:20.04

WORKDIR /home

COPY main.sh /home/main.sh
COPY check_input.sh /home/check_input.sh
COPY generate_folders.sh /home/generate_folders.sh

RUN chmod +x main.sh \
    && ./main.sh . 4 az 5 az.az 3kb

ENTRYPOINT [ "bash" ]