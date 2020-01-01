FROM python:3.7
FROM julia:latest


MAINTAINER Kirill Vlasov <vlasoff.k@gmail.com>

RUN apt-get update && yes|apt-get upgrade
RUN apt-get install -y wget bzip2


RUN apt-get install --no-install-recommends -y apt-utils software-properties-common curl nano unzip openssh-server
RUN apt-get install -y python3 python3-dev python-distribute python3-pip git


RUN pip install --upgrade pip 
RUN pip3 install --upgrade pip



ADD requirements.txt /var/tmp/requirements.txt
RUN python3 -m pip install -r /var/tmp/requirements.txt

RUN apt-get update && apt-get install -y \
    make cmake gcc libzmq3-dev bzip2 hdf5-tools unzip sudo

# Install conda, jupyter, and IJulia kernel
RUN julia -e 'Pkg.update(); Pkg.add("IJulia")'

# Install some common packages (that I've randomly chosen based on my own usage...)
RUN julia -e 'for p in ["HDF5","JSON","OAuth","Requests","PyCall","PyPlot","TimeZones","ParallelDataTransfer"]; Pkg.add(p); end'


RUN jupyter notebook --allow-root --generate-config -y
RUN echo "c.NotebookApp.password = ''" >> ~/.jupyter/jupyter_notebook_config.py
RUN echo "c.NotebookApp.token = ''" >> ~/.jupyter/jupyter_notebook_config.py
#RUN jupyter nbextension enable --py --sys-prefix widgetsnbextension

COPY entry-point.sh /


# Final setup: directories, permissions, ssh login, symlinks, etc
RUN mkdir -p /home/user && \
    mkdir -p /var/run/sshd && \
    echo 'root:12345' | chpasswd && \
    sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd && \
  #  chmod a+x /usr/local/bin/h2o && \
    chmod a+x /entry-point.sh

WORKDIR /home/user
EXPOSE 22 4545

ENTRYPOINT ["/entry-point.sh"]

CMD ["shell"]