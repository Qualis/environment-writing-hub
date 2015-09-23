FROM shippableimages/ubuntu1404_base:latest

RUN sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
    mkdir -p /var/log/supervisor && \
    mkdir -p /etc/supervisor/conf.d && \
    apt-get update && \
    apt-get upgrade -y && \
    apt-get install supervisor -y && \
    apt-get install software-properties-common -y && \
    apt-add-repository ppa:ansible/ansible -y && \
    apt-get update && \
    apt-get install ansible -y && \
    echo "localhost ansible_connection=local" | tee /etc/ansible/hosts && \
    apt-get install git-core -y && \
    git clone --recursive https://github.com/Qualis/environment-writing-hub.git && \
    cd environment-writing-hub && \
    ansible-playbook playbook.yml --skip-tags "vagrant" && \
    cd - && \
    rm -rf environment-writing-hub

RUN lein --version

ENV DISPLAY :10
ENV LEIN_ROOT 1

ADD supervisor.conf /etc/supervisor.conf

CMD ["supervisord", "-n", "-c", "/etc/supervisor.conf"]
