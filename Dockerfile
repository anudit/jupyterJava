FROM openjdk:10.0.1-10-jdk

RUN apt-get update
RUN apt-get install -y python3-pip

RUN pip3 install --no-cache-dir notebook==5.5.* jupyterlab==0.32.*

USER root

RUN curl -L https://anudit.tech/cdn/ijava-kernel.zip > ijava-kernel.zip

RUN unzip ijava-kernel.zip -d ijava-kernel \
  && cd ijava-kernel \
  && python3 install.py --sys-prefix

ENV NB_USER jovyan
ENV NB_UID 1000
ENV HOME /home/$NB_USER

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid $NB_UID \
    $NB_USER

COPY . $HOME
RUN chown -R $NB_UID $HOME

USER $NB_USER

WORKDIR $HOME/UserData
CMD ["jupyter", "notebook", "--ip", "0.0.0.0"]