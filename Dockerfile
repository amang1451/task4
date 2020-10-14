FROM centos

RUN yum install openssh-server -y
RUN yum install sudo -y
RUN yum install java-11-openjdk-devel -y
RUN yum install git -y

RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
RUN ssh-keygen -A
RUN chmod +x ./kubectl 
RUN sudo mv ./kubectl /usr/local/bin/kubectl
RUN kubectl version --client
RUN export PATH=/usr/local/bin/kubectl:$PATH

COPY config /root/.kube/
COPY ca.crt /root/
COPY client.crt /root/
COPY client.key /root/
WORKDIR /root/
COPY .  .
COPY * /root/
EXPOSE 22
CMD ["/usr/sbin/sshd","-D"]  && /bin/bash
